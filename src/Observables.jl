"""
    calObs!(tree::ObservableTree, bra::TangentMPS, ket::TangentMPS=bra; kwargs...)

Evaluate every observable registered in `tree` between the Hilbert-space states
obtained from `bra` and `ket` through the tangent-space natural isomorphism.
All local physical and purification indices, observable auxiliary indices, and
the optional global tangent charge are contracted; every stored result is a
`Number`.

`El` and `Er` may be used to supply nontrivial boundary intertwiners, following
the same orientation as `FiniteMPS.calObs!`.  In particular, `El` may carry an
observable auxiliary index that is consumed by the registered operator string.

The registered operator string and optional boundaries must close every
observable auxiliary and tangent-charge leg. There is no charge-mode switch:
successful contraction always stores a scalar. `normalize=true` divides by
`norm(bra) * norm(ket)`. The implementation currently supports in-memory,
serial traversal (`disk=false`, `serial=true`).
"""
function calObs!(
	tree::ObservableTree{L},
	bra::TangentMPS{L},
	ket::TangentMPS{L} = bra;
	El = nothing,
	Er = nothing,
	normalize::Bool = false,
	disk::Bool = false,
	serial::Bool = true,
	verbose::Int = 0,
) where L
	disk && throw(ArgumentError("disk-backed tangent observable environments are not implemented"))
	serial || throw(ArgumentError("parallel tangent observable traversal is not implemented"))
	FiniteMPS.merge!(tree)

	for refs in values(tree.Refs), ref in values(refs)
		ref[] = NaN
	end

	left_boundary = isnothing(El) ? _default_observable_left_boundary(bra, ket) : El
	right_boundary = isnothing(Er) ? _default_observable_right_boundary(bra, ket) : Er
	isnothing(left_boundary) && throw(ArgumentError(
		"bra and ket have different left boundary spaces; provide El explicitly",
	))
	isnothing(right_boundary) && throw(ArgumentError(
		"bra and ket have different right boundary spaces; provide Er explicitly",
	))

	left_cache = IdDict{Any,ObservableEnv4}()
	right_cache = IdDict{Any,ObservableEnv4}()
	left_cache[tree.RootL] = ObservableEnv4(observable_left_boundary(left_boundary))
	right_cache[tree.RootR] = ObservableEnv4(observable_right_boundary(right_boundary))

	timer = TimerOutput()

	# Finish the shared suffix tree first, so every right leaf is available when
	# its matching left leaf is visited.
	@timeit timer "right tree" begin
		for node in _observable_bfs(tree.RootR)
			si = node.Op[1] - 1
			env = right_cache[node]
			for child in node.children
				op = deepcopy(tree.Ops[si][child.Op[2]])
				op.strength[] = 1.0
				right_cache[child] = observable_pushleft(
					env,
					bra.base.Al[si], bra.base.Ar[si], bra.B[si],
					op,
					ket.base.Al[si], ket.base.Ar[si], ket.B[si],
				)
			end
		end
	end

	@timeit timer "left tree" begin
		for node in _observable_bfs(tree.RootL)
			si = node.Op[1] + 1
			env = left_cache[node]
			for child in node.children
				op = deepcopy(tree.Ops[si][child.Op[2]])
				op.strength[] = 1.0
				left_cache[child] = observable_pushright(
					env,
					bra.base.Al[si], bra.base.Ar[si], bra.B[si],
					op,
					ket.base.Al[si], ket.base.Ar[si], ket.B[si],
				)
			end

			# Several registered observables can share the same pair of leaves.
			leaf_values = IdDict{Any,Number}()
			for channel in node.Intrs
				right_leaf = channel.LeafR
				value = get!(leaf_values, right_leaf) do
					observable_leaf(env, right_cache[right_leaf])
				end
				channel.ref[] = value
			end
		end
	end

	if normalize
		factor = norm(bra) * norm(ket)
		iszero(factor) && throw(ArgumentError("cannot normalize a zero tangent vector"))
		for refs in values(tree.Refs), ref in values(refs)
			ref[] /= factor
		end
	end

	for refs in values(tree.Refs), ref in values(refs)
		isnan(ref[]) && error("an observable leaf was not evaluated")
	end

	if verbose > 0
		show(timer; title = "tangent observables")
		println()
	end

	return timer
end

function _observable_bfs(root)
	result = Any[]
	queue = Any[root]
	first = 1
	while first <= length(queue)
		node = queue[first]
		first += 1
		push!(result, node)
		append!(queue, node.children)
	end
	return result
end

function _default_observable_left_boundary(bra::TangentMPS, ket::TangentMPS)
	bra_space = codomain(bra.base.A[1])[1]
	ket_space = codomain(ket.base.A[1])[1]
	return bra_space == ket_space ? id(bra_space) : nothing
end

function _default_observable_right_boundary(bra::TangentMPS, ket::TangentMPS)
	ket_space = domain(ket.base.A[end])[end]
	bra_space = domain(bra.base.A[end])[end]
	return ket_space == bra_space ? id(ket_space) : nothing
end
