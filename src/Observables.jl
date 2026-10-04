"""
    calObs!(tree::ObservableTree, bra::TangentMPS, ket::TangentMPS=bra; kwargs...)

Evaluate every observable registered in `tree` between the Hilbert-space states
obtained from `bra` and `ket` through the tangent-space natural isomorphism.
All local physical and purification indices, observable auxiliary indices, and
the optional global tangent charge are contracted; every stored result is a
`Number`.

If a registered tensor string has one unmatched auxiliary leg, `addObs!`
normalizes it to the string's left edge. With the default rank-two left
boundary, that leg is propagated as a global bra-oriented charge and may close
against a charged ket center: rank 4 over rank-3 MPS isometries, or rank 5
over rank-4 purified-MPO isometries. Thus the ket charge remains on each
candidate canonical-center tensor `B[i]`; it need not be moved to the state's
left boundary.

`El` and `Er` may instead supply nontrivial boundary intertwiners, following
the same orientation as `FiniteMPS.calObs!`. In particular, an explicit
rank-three `El` may carry and consume the operator string's auxiliary leg;
this preserves the fused-left-boundary workflow without adding the default
open-leg seed.

The user is responsible for making the registered operator string, optional
boundaries, bra/ket boundaries, and tangent charges form a closed tensor
network. There is no charge-mode switch: successful contraction always stores
a scalar. `normalize=true` divides by `norm(bra) * norm(ket)`.

Execution uses FiniteMPS's shared layered tree evaluator. Pass
`alg=LayeredTreeEval(ntasks=1)` for synchronous execution, or use the default
`LayeredTreeEval()` to use the available Julia threads. Do not modify `tree`,
`bra`, or `ket` from another task during a call.

With `disk=true`, `maxsize` is the number of cached environments across both
trees. Each four-sector environment is one entry, regardless of its tensor
sizes. The default `maxsize=nothing` uses the upstream combined layer width;
`maxsize=0` disables the cache. This budget does not count contraction
intermediates and is not a memory limit in bytes.

`verbose`, `showtimes`, and `GCspacing` follow the upstream tree evaluator:
`verbose > 0` prints progress timers, `showtimes` controls their frequency, and
a positive `GCspacing` requests GC at stage barriers after that many completed
pushes and joins.
"""
function calObs!(
	tree::ObservableTree{L},
	bra::TangentMPS{L},
	ket::TangentMPS{L} = bra;
	alg::TreeEvalAlgorithm = LayeredTreeEval(),
	disk::Bool = false,
	maxsize = nothing,
	verbose::Integer = 0,
	showtimes = 10,
	GCspacing = 0,
	normalize::Bool = false,
	El = nothing,
	Er = nothing,
	kwargs...,
) where L
	_tree_options(kwargs, maxsize, GCspacing, showtimes)
	_observable_reset_refs!(tree)

	try
		FiniteMPS.merge!(tree)
		left_boundary = isnothing(El) ? _default_observable_left_boundary(bra, ket) : El
		right_boundary = isnothing(Er) ? _default_observable_right_boundary(bra, ket) : Er
		isnothing(left_boundary) && throw(ArgumentError(
			"bra and ket have different left boundary spaces; provide El explicitly",
		))
		isnothing(right_boundary) && throw(ArgumentError(
			"bra and ket have different right boundary spaces; provide Er explicitly",
		))
		left = observable_left_root(left_boundary)
		right = observable_right_root(right_boundary)

		function prepare(_, si)
			return (
				(bra.base.Al[si], bra.base.Ar[si], bra.B[si]),
				(ket.base.Al[si], ket.base.Ar[si], ket.B[si]),
			)
		end
		function pushenv(side, node, env, data)
			bra_site, ket_site = data
			op = deepcopy(tree.Ops[node.Op[1]][node.Op[2]])
			op.strength[] = 1.0
			if side && node.parent === tree.RootL &&
				env.e00 isa ObservableLeftEnv{1,1} &&
				isnothing(env.e10) && isnothing(env.e01) && isnothing(env.e11) &&
				!isunitspace(getLeftSpace(op))
				env = observable_seed_left_open(env, getLeftSpace(op))
			end
			return side ?
				observable_pushright(env, bra_site..., op, ket_site...) :
				observable_pushleft(env, bra_site..., op, ket_site...)
		end

		timer = _evaluate_tree!(tree, prepare, pushenv, left, right, alg;
			disk, maxsize, verbose, showtimes, GCspacing)
		if normalize
			factor = norm(bra) * norm(ket)
			iszero(factor) && throw(ArgumentError("cannot normalize a zero tangent vector"))
			for refs in values(tree.Refs), ref in values(refs)
				ref[] /= factor
			end
		end
		return timer
	catch
		_observable_reset_refs!(tree)
		rethrow()
	end
end

function _observable_reset_refs!(tree::ObservableTree)
	for refs in values(tree.Refs), ref in values(refs)
		ref[] = NaN
	end
	return nothing
end

function _default_observable_left_boundary(bra::TangentMPS, ket::TangentMPS)
	bra_space = codomain(bra.base.A[1])[1]
	ket_space = codomain(ket.base.A[1])[1]
	return bra_space == ket_space ? id(bra_space) : nothing
end

function _default_observable_right_boundary(bra::TangentMPS, ket::TangentMPS)
	ket_space = domain(ket.base.A[end], numin(ket.base.A[end]))
	bra_space = domain(bra.base.A[end], numin(bra.base.A[end]))
	return ket_space == bra_space ? id(ket_space) : nothing
end
