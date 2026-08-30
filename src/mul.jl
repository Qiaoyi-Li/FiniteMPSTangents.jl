"""
    mul!(C::TangentMPS, A::SparseMPO, B::TangentMPS,
         α=1.0, β=0.0; normalize=false, GCstep=false,
         disk=false, cache=TangentEnvironment(C.base, A; disk))

Compute `C ← α * P A B + β * C`, where `P` is the tangent-space projector at
`C.base`. Set `normalize=true` to additionally remove the component parallel to
the normalized base MPS. Reusing `cache` avoids rebuilding base environments.
"""
function mul!(C::TangentMPS{L}, A::SparseMPO{L}, B::TangentMPS{L}, α::Tα = 1.0, β::Number = 0.0;
	normalize::Bool = false,
	GCstep::Bool = false,
	disk::Bool = false,
	cache::TangentEnvironment{L} = TangentEnvironment(C.base, A; disk = disk),
	timer::Union{Nothing, TimerOutput} = nothing,
	timer_path::Vector{String} = String[],
) where {L, Tα <: Number}

	@assert !(C === B)

	Timer_mul = isnothing(timer) ? TimerOutput() : timer
	mul_path = vcat(timer_path, ["mul!"])
	@timeit Timer_mul "mul!" begin
	# C -> β * C first
	if β != 1.0
		rmul!(C, β)
	end

	# C -> C + α A * B
	El = Vector{Union{Nothing, BilayerLeftTensor}}(nothing, 1)
	for si in 1:L
		@timeit Timer_mul "left aggregation" El, El_partial = _recurseEl(_getEl(cache, si),
			El,
			cache.base.Al[si]',
			A[si],
			B.B[si],
			si > 1 ? cache.base.Ar[si] : nothing; timer = Timer_mul, tree_point = vcat(mul_path, ["left aggregation"])
		)
		@timeit Timer_mul "left contraction" B_add = _mul_LR(El_partial, _getEr(cache, si); timer = Timer_mul, tree_point = vcat(mul_path, ["left contraction"]))
		if !isassigned(C.B, si)
			C.B[si] = α * B_add
		else
			C.B[si] = add!!(C.B[si], B_add, α)
		end

		GCstep && GC.gc()
	end

	Er = Vector{Union{Nothing, BilayerRightTensor}}(nothing, 1)
	for si in reverse(1:L)
		@timeit Timer_mul "right aggregation" Er, Er_partial = _recurseEr(_getEr(cache, si),
			Er,
			cache.base.Ar[si]',
			A[si],
			B.B[si],
			si < L ? cache.base.Al[si] : nothing; timer = Timer_mul, tree_point = vcat(mul_path, ["right aggregation"])
		)
		@timeit Timer_mul "right contraction" B_add = _mul_LR(_getEl(cache, si), Er_partial; timer = Timer_mul, tree_point = vcat(mul_path, ["right contraction"]))
		C.B[si] = add!!(C.B[si], B_add, α)

		# subtract double counted on-site terms
		@timeit Timer_mul "_action1" Ai = _action1(_getEl(cache, si), B.B[si], A[si], _getEr(cache, si); timer = Timer_mul, tree_point = vcat(mul_path, ["_action1"]))
		C.B[si] = add!!(C.B[si], Ai, -α)


		GCstep && GC.gc()
	end

	# left orthogonalize
	orth!(C; normalize = normalize)
	end

	return C
end

"""
    mul(A::SparseMPO, B::TangentMPS, α=1.0;
        isfermionic=false, Z=nothing, kwargs...)

Return the projected product `α * P A B` as a new tangent MPS.

For a fermionic action, set `isfermionic=true` and provide the parity operator
`Z`. Any remaining keywords are forwarded to [`mul!`](@ref).
"""
function mul(A::SparseMPO{L}, B::TangentMPS{L}, α::Tα = 1.0;
	isfermionic::Bool = false,
	Z = nothing,
	kwargs...) where {L, Tα <: Number}

	if isfermionic
		@assert !isnothing(Z) "Parity operator Z must be provided for fermionic systems."
		base = deepcopy(B.base)
		_addZ!(base, Z)
	else
		base = B.base
	end

	C = TangentMPS{L}(base, Vector{MPSTensor}(undef, L))
	mul!(C, A, B, α, 0.0; kwargs...)

	return C
end

*(A::SparseMPO{L}, B::TangentMPS{L}) where {L} = mul(A, B)

function _mul_LR(El0::Vector{Union{Nothing, BilayerLeftTensor}},
	Er_partial::Vector{Union{Nothing, AbstractTensorMap}};
	timer::Union{Nothing, TimerOutput} = nothing, tree_point::Vector{String} = ["_mul_LR"])::MPSTensor

	@assert length(El0) == length(Er_partial)
	A = nothing
	if FiniteMPS.get_num_threads_action() > 1
		Lock = ReentrantLock()
		Threads.@threads :greedy for i in 1:length(El0)
			A_i, to = _mul_LR(El0[i], Er_partial[i], true)

			lock(Lock)
			try
				if isnothing(A)
					A = A_i
				else
					A = add!!(A, A_i)
				end
				!isnothing(timer) && merge!(timer, to; tree_point = tree_point)
			catch e
				rethrow(e)
			finally
				unlock(Lock)
			end
		end
	else
		# serial
		for i in 1:length(El0)
			A_i, to = _mul_LR(El0[i], Er_partial[i], true)
			if isnothing(A)
				A = A_i
			else
				A = add!!(A, A_i)
			end
			!isnothing(timer) && merge!(timer, to; tree_point = tree_point)
		end
	end
	return A
end

function _mul_LR(El0::BilayerLeftTensor{1, 1},
	Er_partial::AbstractTensorMap)::MPSTensor
	r = (numout(Er_partial), numin(Er_partial))
	if r[1] == 1
		return El0.A * Er_partial
	else
		@assert r[1] == 2 # rank-n MPS to rank-(n+1) MPS
		perms = ((2,), Tuple(vcat(3:r[2]+1, 1, r[2] + 2)))
		return El0.A * permute(Er_partial, perms)
	end
end


function _mul_LR(El0::BilayerLeftTensor{2, 1},
	Er_partial::AbstractTensorMap)::MPSTensor
	r = (numout(Er_partial), numin(Er_partial))
	@assert r[1] == 2
	return permute(El0.A, ((1,), (2, 3))) * Er_partial
end

function _mul_LR(El0::BilayerLeftTensor{1, 2},
	Er_partial::AbstractTensorMap)::MPSTensor
	@assert numout(Er_partial) == 1
	if numind(Er_partial) == 3 # rank-3 MPS
		return @tensor tmp[a d; c e] := El0.A[a b c] * Er_partial[b d e]
	else # rank-4 MPS
		@assert numind(Er_partial) == 4
		return @tensor tmp[a d; f c e] := El0.A[a b c] * Er_partial[b d f e]
	end
end

function _mul_LR(El0::BilayerLeftTensor{2, 2},
	Er_partial::AbstractTensorMap)::MPSTensor
	@assert numout(Er_partial) == 2
	if numind(Er_partial) == 4 # rank-3 MPS
		return @tensor tmp[a h; f d] := El0.A[a j i f] * Er_partial[j i h d]
	else # rank-4 MPS
		@assert numind(Er_partial) == 5
		return @tensor tmp[a h; e f d] := El0.A[a j i f] * Er_partial[j i h e d]
	end
end

function _mul_LR(El_partial::Vector{Union{Nothing, AbstractTensorMap}},
	Er0::Vector{Union{Nothing, BilayerRightTensor}};
	timer::Union{Nothing, TimerOutput} = nothing, tree_point::Vector{String} = ["_mul_LR"])::MPSTensor

	@assert length(El_partial) == length(Er0)

	A = nothing

	if FiniteMPS.get_num_threads_action() > 1
		Lock = ReentrantLock()
		Threads.@threads :greedy for i in 1:length(Er0)
			A_i, to = _mul_LR(El_partial[i], Er0[i], true)

			lock(Lock)
			try
				if isnothing(A)
					A = A_i
				else
					A = add!!(A, A_i)
				end
				!isnothing(timer) && merge!(timer, to; tree_point = tree_point)
			catch e
				rethrow(e)
			finally
				unlock(Lock)
			end
		end

	else # serial
		for i in 1:length(Er0)
			A_i, to = _mul_LR(El_partial[i], Er0[i], true)
			if isnothing(A)
				A = A_i
			else
				A = add!!(A, A_i)
			end
			!isnothing(timer) && merge!(timer, to; tree_point = tree_point)
		end
	end
	return A
end

function _mul_LR(El_partial::AbstractTensorMap,
	Er0::BilayerRightTensor{1, 1})::MPSTensor
	r = (numout(El_partial), numin(El_partial))
	if r[2] == 1
		return El_partial * Er0.A
	else
		@assert r[2] == 2 # rank-n MPS to rank-(n+1) MPS
		perms = (Tuple(vcat(1:r[1], r[1] + 2)), (r[1] + 1,))
		return permute(El_partial, perms) * Er0.A
	end
end

function _mul_LR(El_partial::AbstractTensorMap,
	Er0::BilayerRightTensor{1, 2})::MPSTensor
	r = (numout(El_partial), numin(El_partial))
	if r[2] == 2
		return El_partial * permute(Er0.A, ((1, 2), (3,)))
	else
		@assert r[2] == 1 # rank-n MPS to rank-(n+1) MPS
		return El_partial * permute(Er0.A, ((1,), (2, 3)))
	end
end

function _mul_LR(El0::BilayerLeftTensor{N₁,N₂}, Er_partial::AbstractTensorMap, timeit::Bool;
	kwargs...) where {N₁,N₂}
	!timeit && return _mul_LR(El0, Er_partial), TimerOutput()
	LocalTimer = TimerOutput()
	r = (numout(Er_partial), numin(Er_partial))
	name = "_mul_LR_left_$(N₁)_$(N₂)_$(r[1])_$(r[2])"
	@timeit LocalTimer name A = _mul_LR(El0, Er_partial)
	return A, LocalTimer
end

function _mul_LR(El_partial::AbstractTensorMap, Er0::BilayerRightTensor{N₁,N₂}, timeit::Bool;
	kwargs...) where {N₁,N₂}
	!timeit && return _mul_LR(El_partial, Er0), TimerOutput()
	LocalTimer = TimerOutput()
	r = (numout(El_partial), numin(El_partial))
	name = "_mul_LR_right_$(r[1])_$(r[2])_$(N₁)_$(N₂)"
	@timeit LocalTimer name A = _mul_LR(El_partial, Er0)
	return A, LocalTimer
end


# ====================== recurseEl ======================
#          e f                  e
#          |/           f       |
#    ---c--B---g         \ --c--Br--g
#   |      |d             |     |d
#  El0--b--H---h    +    El--b--H---h
#   |      |j             |     |j
#    ---a--A*--i           --a--A*--i
#          |                    |
#          e                    e
function _recurseEl(El0::Vector{Union{Nothing, BilayerLeftTensor}},
	El::Vector{Union{Nothing, BilayerLeftTensor}},
	A::AdjointMPSTensor,
	H::SparseMPOTensor,
	B::MPSTensor,
	Br::Union{MPSTensor, Nothing}; timer::Union{Nothing, TimerOutput} = nothing,
	tree_point::Vector{String} = ["_recurseEl"])

	El_new = Vector{Union{Nothing, BilayerLeftTensor}}(nothing, size(H, 2))
	# partial contraction results, without A*
	El_partial = Vector{Union{Nothing, AbstractTensorMap}}(nothing, size(H, 2))

	if FiniteMPS.get_num_threads_action() > 1
		idx_valid = [(i, j) for i in 1:size(H, 1), j in 1:size(H, 2) if !isnothing(H[i, j])]

		Lock = ReentrantLock()
		Threads.@threads :greedy for (i, j) in idx_valid
			a, b, to = _recurseEl(El0[i], El[i], A, H[i, j], B, Br, true)

			lock(Lock)
			try
				if isnothing(El_new[j])
					El_new[j] = a
					El_partial[j] = b
				else
					El_new[j] = add!!(El_new[j].A, a)
					El_partial[j] = add!!(El_partial[j], b)
				end
				!isnothing(timer) && merge!(timer, to; tree_point = tree_point)
			catch e
				rethrow(e)
			finally
				unlock(Lock)
			end
		end
	else
		# serial version
		for j in 1:size(H, 2)
			for i in 1:size(H, 1)
				isnothing(H[i, j]) && continue
				a, b, to = _recurseEl(El0[i], El[i], A, H[i, j], B, Br, true)
				if isnothing(El_new[j])
					El_new[j] = a
					El_partial[j] = b
				else
					El_new[j] = add!!(El_new[j].A, a)
					El_partial[j] = add!!(El_partial[j], b)
				end
				!isnothing(timer) && merge!(timer, to; tree_point = tree_point)
			end
		end
	end

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{N₁,N₂}, El::Union{Nothing,BilayerLeftTensor},
	A::AdjointMPSTensor{N₃}, H::IdentityOperator, B::MPSTensor{N₄}, Br::Union{MPSTensor,Nothing},
	timeit::Bool) where {N₁,N₂,N₃,N₄}
	!timeit && return _recurseEl(El0, El, A, H, B, Br), TimerOutput()
	LocalTimer = TimerOutput()
	elrank = isnothing(El) ? "N" : "$(typeof(El).parameters[1])_$(typeof(El).parameters[2])"
	brrank = isnothing(Br) ? "N" : "$(typeof(Br).parameters[1])"
	name = "_recurseEl_$(N₁)_$(N₂)_El$(elrank)_0_A$(N₃)_B$(N₄)_Br$(brrank)"
	@timeit LocalTimer name a, b = _recurseEl(El0, El, A, H, B, Br)
	return a, b, LocalTimer
end

function _recurseEl(El0::BilayerLeftTensor{N₁,N₂}, El::Union{Nothing,BilayerLeftTensor},
	A::AdjointMPSTensor{N₃}, H::LocalOperator{N₄,N₅}, B::MPSTensor{N₆}, Br::Union{MPSTensor,Nothing},
	timeit::Bool) where {N₁,N₂,N₃,N₄,N₅,N₆}
	!timeit && return _recurseEl(El0, El, A, H, B, Br), TimerOutput()
	LocalTimer = TimerOutput()
	elrank = isnothing(El) ? "N" : "$(typeof(El).parameters[1])_$(typeof(El).parameters[2])"
	brrank = isnothing(Br) ? "N" : "$(typeof(Br).parameters[1])"
	name = "_recurseEl_$(N₁)_$(N₂)_El$(elrank)_$(N₄)$(N₅)_A$(N₃)_B$(N₆)_Br$(brrank)"
	@timeit LocalTimer name a, b = _recurseEl(El0, El, A, H, B, Br)
	return a, b, LocalTimer
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::Nothing,
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{3},
	Br::Nothing)
	# left boundary case

	c = H.strength[]
	@tensor El_partial[a d; g] := c * El0.A[a c] * B.A[c d g]
	@tensor El_new[i; g] := El_partial[a d g] * A.A[i a d]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::Nothing,
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{4},
	Br::Nothing)
	# left boundary case

	c = H.strength[]
	@tensor El_partial[a d e; g] := c * El0.A[a c] * B.A[c d e g]
	@tensor El_new[i; g] := El_partial[a d e g] * A.A[e i a d]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::Nothing,
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{4},
	Br::Nothing)
	# left boundary case

	c = H.strength[]
	@tensor El_partial[a d f; g] := c * El0.A[a c] * B.A[c d f g]
	@tensor El_new[i; g f] := El_partial[a d f g] * A.A[i a d]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::Nothing,
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{5},
	Br::Nothing)
	# left boundary case

	c = H.strength[]
	@tensor El_partial[a d e f; g] := c * El0.A[a c] * B.A[c d e f g]
	@tensor El_new[i; g f] := El_partial[a d e f g] * A.A[e i a d]

	return El_new, El_partial
end


function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::Nothing,
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 2},
	B::MPSTensor{3},
	Br::Nothing)
	# left boundary case

	c = H.strength[]
	@tensor El_partial[a j; g h] := c * (El0.A[a c] * B.A[c d g]) * H.A[j d h]
	@tensor El_new[i h; g] := El_partial[a j g h] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::Nothing,
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 2},
	B::MPSTensor{4},
	Br::Nothing)
	# left boundary case

	c = H.strength[]
	@tensor El_partial[a j e; g h] := c * (El0.A[a c] * B.A[c d e g]) * H.A[j d h]
	@tensor El_new[i h; g] := El_partial[a j e g h] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::Nothing,
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{3},
	Br::Nothing)
	# left boundary case

	c = H.strength[]
	@tensor El_partial[a j; g] := c * (El0.A[a c] * B.A[c d g]) * H.A[j d]
	@tensor El_new[i; g] := El_partial[a j g] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::Nothing,
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{4},
	Br::Nothing)
	# left boundary case

	c = H.strength[]
	@tensor El_partial[a j e; g] := c * (El0.A[a c] * B.A[c d e g]) * H.A[j d]
	@tensor El_new[i; g] := El_partial[a j e g] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::Nothing,
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 1},
	B::MPSTensor{3},
	Br::Nothing)
	# left boundary case

	c = H.strength[]
	@tensor El_partial[a j b; g] := c * (El0.A[a c] * B.A[c d g]) * H.A[b j d]
	@tensor El_new[i; g b] := El_partial[a j b g] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::Nothing,
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 1},
	B::MPSTensor{4},
	Br::Nothing)
	# left boundary case

	c = H.strength[]
	@tensor El_partial[a j e b; g] := c * (El0.A[a c] * B.A[c d e g]) * H.A[b j d]
	@tensor El_new[i; g b] := El_partial[a j e b g] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::Nothing,
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 2},
	B::MPSTensor{3},
	Br::Nothing)
	# left boundary case

	c = H.strength[]
	@tensor El_partial[a j b; g h] := c * (El0.A[a c] * B.A[c d g]) * H.A[b j d h]
	@tensor El_new[i h; g b] := El_partial[a j b g h] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::Nothing,
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 2},
	B::MPSTensor{4},
	Br::Nothing)
	# left boundary case

	c = H.strength[]
	@tensor El_partial[a j e b; g h] := c * (El0.A[a c] * B.A[c d e g]) * H.A[b j d h]
	@tensor El_new[i h; g b] := El_partial[a j e b g h] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::Nothing,
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{4},
	Br::Nothing)
	# left boundary case

	c = H.strength[]
	@tensor El_partial[a j f; g] := c * (El0.A[a c] * B.A[c d f g]) * H.A[j d]
	@tensor El_new[i; g f] := El_partial[a j f g] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::Nothing,
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{5},
	Br::Nothing)
	# left boundary case

	c = H.strength[]
	@tensor El_partial[a j e f; g] := c * (El0.A[a c] * B.A[c d e f g]) * H.A[j d]
	@tensor El_new[i; g f] := El_partial[a j e f g] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::Nothing,
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 2},
	B::MPSTensor{4},
	Br::Nothing)
	# left boundary case

	c = H.strength[]
	@tensor El_partial[a j f; g h] := c * (El0.A[a c] * B.A[c d f g]) * H.A[j d h]
	@tensor El_new[i h; g f] := El_partial[a j f g h] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::Nothing,
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 2},
	B::MPSTensor{5},
	Br::Nothing)
	# left boundary case

	c = H.strength[]
	@tensor El_partial[a j e f; g h] := c * (El0.A[a c] * B.A[c d e f g]) * H.A[j d h]
	@tensor El_new[i h; g f] := El_partial[a j e f g h] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{4},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a d f; g] := c * (El0.A[a c] * B.A[c d f g] + El.A[a c f] * Br.A[c d g])
	@tensor El_new[i; g f] := El_partial[a d f g] * A.A[i a d]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{5},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a d e f; g] := c * (El0.A[a c] * B.A[c d e f g] + El.A[a c f] * Br.A[c d e g])
	@tensor El_new[i; g f] := El_partial[a d e f g] * A.A[e i a d]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{3},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a d; g] := c * (El0.A[a c] * B.A[c d g] + El.A[a c] * Br.A[c d g])
	@tensor El_new[i; g] := El_partial[a d g] * A.A[i a d]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{4},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a d e; g] := c * (El0.A[a c] * B.A[c d e g] + El.A[a c] * Br.A[c d e g])
	@tensor El_new[i; g] := El_partial[a d e g] * A.A[e i a d]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 2},
	El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{4},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a d e f; g] := c * (El0.A[a c f] * B.A[c d e g] + El.A[a c f] * Br.A[c d e g])
	@tensor El_new[i; g f] := El_partial[a d e f g] * A.A[e i a d]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 2},
	El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{3},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a d f; g] := c * (El0.A[a c f] * B.A[c d g] + El.A[a c f] * Br.A[c d g])
	@tensor El_new[i; g f] := El_partial[a d f g] * A.A[i a d]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 2},
	El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{3},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a j f; g] := c * (El0.A[a c f] * B.A[c d g] + El.A[a c f] * Br.A[c d g]) * H.A[j d]
	@tensor El_new[i; g f] := El_partial[a j f g] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 2},
	El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{4},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a j e f; g] := c * (El0.A[a c f] * B.A[c d e g] + El.A[a c f] * Br.A[c d e g]) * H.A[j d]
	@tensor El_new[i; g f] := El_partial[a j e f g] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 2},
	El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 2},
	B::MPSTensor{3},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a j f; g h] := c * (El0.A[a c f] * B.A[c d g] + El.A[a c f] * Br.A[c d g]) * H.A[j d h]
	@tensor El_new[i h; g f] := El_partial[a j f g h] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 2},
	El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 2},
	B::MPSTensor{4},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a j e f; g h] := c * (El0.A[a c f] * B.A[c d e g] + El.A[a c f] * Br.A[c d e g]) * H.A[j d h]
	@tensor El_new[i h; g f] := El_partial[a j e f g h] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{3},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a j; g] := c * (El0.A[a c] * B.A[c d g] + El.A[a c] * Br.A[c d g]) * H.A[j d]
	@tensor El_new[i; g] := El_partial[a j g] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{4},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a j e; g] := c * (El0.A[a c] * B.A[c d e g] + El.A[a c] * Br.A[c d e g]) * H.A[j d]
	@tensor El_new[i; g] := El_partial[a j e g] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 1},
	B::MPSTensor{3},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a j b; g] := c * (El0.A[a c] * B.A[c d g] + El.A[a c] * Br.A[c d g]) * H.A[b j d]
	@tensor El_new[i; g b] := El_partial[a j b g] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 1},
	B::MPSTensor{4},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a j e b; g] := c * (El0.A[a c] * B.A[c d e g] + El.A[a c] * Br.A[c d e g]) * H.A[b j d]
	@tensor El_new[i; g b] := El_partial[a j e b g] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{4},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a j f; g] := c * (El0.A[a c] * B.A[c d f g] + El.A[a c f] * Br.A[c d g]) * H.A[j d]
	@tensor El_new[i; g f] := El_partial[a j f g] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{5},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a j e f; g] := c * (El0.A[a c] * B.A[c d e f g] + El.A[a c f] * Br.A[c d e g]) * H.A[j d]
	@tensor El_new[i; g f] := El_partial[a j e f g] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 2},
	B::MPSTensor{3},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a j; g h] := c * (El0.A[a c] * B.A[c d g] + El.A[a c] * Br.A[c d g]) * H.A[j d h]
	@tensor El_new[i h; g] := El_partial[a j g h] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 2},
	B::MPSTensor{4},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a j e; g h] := c * (El0.A[a c] * B.A[c d e g] + El.A[a c] * Br.A[c d e g]) * H.A[j d h]
	@tensor El_new[i h; g] := El_partial[a j e g h] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 2},
	B::MPSTensor{3},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a j b; g h] := c * (El0.A[a c] * B.A[c d g] + El.A[a c] * Br.A[c d g]) * H.A[b j d h]
	@tensor El_new[i h; g b] := El_partial[a j b g h] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 2},
	B::MPSTensor{4},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a j e b; g h] := c * (El0.A[a c] * B.A[c d e g] + El.A[a c] * Br.A[c d e g]) * H.A[b j d h]
	@tensor El_new[i h; g b] := El_partial[a j e b g h] * A.A[e i a j]

	return El_new, El_partial
end


function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 2},
	B::MPSTensor{4},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a j f; g h] := c * (El0.A[a c] * B.A[c d f g] + El.A[a c f] * Br.A[c d g]) * H.A[j d h]
	@tensor El_new[i h; g f] := El_partial[a j f g h] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{1, 1},
	El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 2},
	B::MPSTensor{5},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a j e f; g h] := c * (El0.A[a c] * B.A[c d e f g] + El.A[a c f] * Br.A[c d e g]) * H.A[j d h]
	@tensor El_new[i h; g f] := El_partial[a j e f g h] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 1},
	El::BilayerLeftTensor{2, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 1},
	B::MPSTensor{3},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a j; g] := c * (El0.A[a b c] * B.A[c d g] + El.A[a b c] * Br.A[c d g]) * H.A[b j d]
	@tensor El_new[i; g] := El_partial[a j g] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 1},
	El::BilayerLeftTensor{2, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 1},
	B::MPSTensor{4},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a j e; g] := c * (El0.A[a b c] * B.A[c d e g] + El.A[a b c] * Br.A[c d e g]) * H.A[b j d]
	@tensor El_new[i; g] := El_partial[a j e g] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 2},
	El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 1},
	B::MPSTensor{3},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a j f; g] := c * (El0.A[a b c f] * B.A[c d g] + El.A[a b c f] * Br.A[c d g]) * H.A[b j d]
	@tensor El_new[i; g f] := El_partial[a j f g] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 2},
	El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 1},
	B::MPSTensor{4},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a j e f; g] := c * (El0.A[a b c f] * B.A[c d e g] + El.A[a b c f] * Br.A[c d e g]) * H.A[b j d]
	@tensor El_new[i; g f] := El_partial[a j e f g] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 1},
	El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 1},
	B::MPSTensor{4},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a j f; g] := c * (El0.A[a b c] * B.A[c d f g] + El.A[a b c f] * Br.A[c d g]) * H.A[b j d]
	@tensor El_new[i; g f] := El_partial[a j f g] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 1},
	El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 1},
	B::MPSTensor{5},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a j e f; g] := c * (El0.A[a b c] * B.A[c d e f g] + El.A[a b c f] * Br.A[c d e g]) * H.A[b j d]
	@tensor El_new[i; g f] := El_partial[a j e f g] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 1},
	El::BilayerLeftTensor{2, 1},
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{3},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a d; g b] := c * (El0.A[a b c] * B.A[c d g] + El.A[a b c] * Br.A[c d g])
	@tensor El_new[i b; g] := El_partial[a d g b] * A.A[i a d]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 1},
	El::BilayerLeftTensor{2, 1},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{4},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a d e; g b] := c * (El0.A[a b c] * B.A[c d e g] + El.A[a b c] * Br.A[c d e g])
	@tensor El_new[i b; g] := El_partial[a d e g b] * A.A[e i a d]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 1},
	El::BilayerLeftTensor{2, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{3},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a j; g b] := c * (El0.A[a b c] * B.A[c d g] + El.A[a b c] * Br.A[c d g]) * H.A[j d]
	@tensor El_new[i b; g] := El_partial[a j g b] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 1},
	El::BilayerLeftTensor{2, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{4},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a j e; g b] := c * (El0.A[a b c] * B.A[c d e g] + El.A[a b c] * Br.A[c d e g]) * H.A[j d]
	@tensor El_new[i b; g] := El_partial[a j e g b] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 1},
	El::BilayerLeftTensor{2, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 2},
	B::MPSTensor{3},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a j; g h] := c * (El0.A[a b c] * B.A[c d g] + El.A[a b c] * Br.A[c d g]) * H.A[b j d h]
	@tensor El_new[i h; g] := El_partial[a j g h] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 1},
	El::BilayerLeftTensor{2, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 2},
	B::MPSTensor{4},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a j e; g h] := c * (El0.A[a b c] * B.A[c d e g] + El.A[a b c] * Br.A[c d e g]) * H.A[b j d h]
	@tensor El_new[i h; g] := El_partial[a j e g h] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 2},
	El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{3},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a d f; g b] := c * (El0.A[a b c f] * B.A[c d g] + El.A[a b c f] * Br.A[c d g])
	@tensor El_new[i b; g f] := El_partial[a d f g b] * A.A[i a d]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 2},
	El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{4},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a d e f; g b] := c * (El0.A[a b c f] * B.A[c d e g] + El.A[a b c f] * Br.A[c d e g])
	@tensor El_new[i b; g f] := El_partial[a d e f g b] * A.A[e i a d]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 2},
	El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{3},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a j f; g b] := c * (El0.A[a b c f] * B.A[c d g] + El.A[a b c f] * Br.A[c d g]) * H.A[j d]
	@tensor El_new[i b; g f] := El_partial[a j f g b] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 2},
	El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{4},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a j e f; g b] := c * (El0.A[a b c f] * B.A[c d e g] + El.A[a b c f] * Br.A[c d e g]) * H.A[j d]
	@tensor El_new[i b; g f] := El_partial[a j e f g b] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 2},
	El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 2},
	B::MPSTensor{3},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a j f; g h] := c * (El0.A[a b c f] * B.A[c d g] + El.A[a b c f] * Br.A[c d g]) * H.A[b j d h]
	@tensor El_new[i h; g f] := El_partial[a j f g h] * A.A[i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 2},
	El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 2},
	B::MPSTensor{4},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a j e f; g h] := c * (El0.A[a b c f] * B.A[c d e g] + El.A[a b c f] * Br.A[c d e g]) * H.A[b j d h]
	@tensor El_new[i h; g f] := El_partial[a j e f g h] * A.A[e i a j]

	return El_new, El_partial
end


function _recurseEl(El0::BilayerLeftTensor{2, 1},
	El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{4},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a j f; g b] := c * (El0.A[a b c] * B.A[c d f g] + El.A[a b c f] * Br.A[c d g]) * H.A[j d]
	@tensor El_new[i b; g f] := El_partial[a j f g b] * A.A[i a j]

	return El_new, El_partial
end


function _recurseEl(El0::BilayerLeftTensor{2, 1},
	El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{5},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a j e f; g b] := c * (El0.A[a b c] * B.A[c d e f g] + El.A[a b c f] * Br.A[c d e g]) * H.A[j d]
	@tensor El_new[i b; g f] := El_partial[a j e f g b] * A.A[e i a j]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 1},
	El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{4},
	Br::MPSTensor{3})

	c = H.strength[]
	@tensor El_partial[a d f; g b] := c * (El0.A[a b c] * B.A[c d f g] + El.A[a b c f] * Br.A[c d g])
	@tensor El_new[i b; g f] := El_partial[a d f g b] * A.A[i a d]

	return El_new, El_partial
end

function _recurseEl(El0::BilayerLeftTensor{2, 1},
	El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{5},
	Br::MPSTensor{4})

	c = H.strength[]
	@tensor El_partial[a d e f; g b] := c * (El0.A[a b c] * B.A[c d e f g] + El.A[a b c f] * Br.A[c d e g])
	@tensor El_new[i b; g f] := El_partial[a d e f g b] * A.A[e i a d]

	return El_new, El_partial
end



# ====================== recurseEr ======================
#       e f                  e
#       |/                   |         f
#   i---B-- b--          i--Bl-- b-- /
#      g|      |            g|      |
#   j---H-- c--Er0   +   j---H-- c--Er
#      h|      |            h|      |
#   k--A*-- d--          k--A*-- d--
#       |                    |
#       e                    e
function _recurseEr(Er0::Vector{Union{Nothing, BilayerRightTensor}},
	Er::Vector{Union{Nothing, BilayerRightTensor}},
	A::AdjointMPSTensor,
	H::SparseMPOTensor,
	B::MPSTensor,
	Bl::Union{MPSTensor, Nothing}; timer::Union{Nothing, TimerOutput} = nothing,
	tree_point::Vector{String} = ["_recurseEr"])

	Er_new = Vector{Union{Nothing, BilayerRightTensor}}(nothing, size(H, 1))
	# partial contraction results, without A*
	Er_partial = Vector{Union{Nothing, AbstractTensorMap}}(nothing, size(H, 1))

	if FiniteMPS.get_num_threads_action() > 1
		idx_valid = [(i, j) for i in 1:size(H, 1), j in 1:size(H, 2) if !isnothing(H[i, j])]

		Lock = ReentrantLock()
		Threads.@threads :greedy for (i, j) in idx_valid
			a, b, to = _recurseEr(Er0[j], Er[j], A, H[i, j], B, Bl, true)

			lock(Lock)
			try
				if isnothing(Er_new[i])
					Er_new[i] = a
					Er_partial[i] = b
				else
					Er_new[i] =  add!!(Er_new[i].A, a)
					Er_partial[i] = add!!(Er_partial[i], b)
				end
				!isnothing(timer) && merge!(timer, to; tree_point = tree_point)
			catch e
				rethrow(e)
			finally
				unlock(Lock)
			end
		end

	else
		# serial version
		for i in 1:size(H, 1)
			for j in 1:size(H, 2)
				isnothing(H[i, j]) && continue
				a, b, to = _recurseEr(Er0[j], Er[j], A, H[i, j], B, Bl, true)
				if isnothing(Er_new[i])
					Er_new[i] = a
					Er_partial[i] = b
				else
					Er_new[i] =  add!!(Er_new[i].A, a)
					Er_partial[i] = add!!(Er_partial[i], b)
				end
				!isnothing(timer) && merge!(timer, to; tree_point = tree_point)
			end
		end
	end

	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{N₁,N₂}, Er::Union{Nothing,BilayerRightTensor},
	A::AdjointMPSTensor{N₃}, H::IdentityOperator, B::MPSTensor{N₄}, Bl::Union{MPSTensor,Nothing},
	timeit::Bool) where {N₁,N₂,N₃,N₄}
	!timeit && return _recurseEr(Er0, Er, A, H, B, Bl), TimerOutput()
	LocalTimer = TimerOutput()
	errk = isnothing(Er) ? "N" : "$(typeof(Er).parameters[1])_$(typeof(Er).parameters[2])"
	blrank = isnothing(Bl) ? "N" : "$(typeof(Bl).parameters[1])"
	name = "_recurseEr_$(N₁)_$(N₂)_Er$(errk)_0_A$(N₃)_B$(N₄)_Bl$(blrank)"
	@timeit LocalTimer name a, b = _recurseEr(Er0, Er, A, H, B, Bl)
	return a, b, LocalTimer
end

function _recurseEr(Er0::BilayerRightTensor{N₁,N₂}, Er::Union{Nothing,BilayerRightTensor},
	A::AdjointMPSTensor{N₃}, H::LocalOperator{N₄,N₅}, B::MPSTensor{N₆}, Bl::Union{MPSTensor,Nothing},
	timeit::Bool) where {N₁,N₂,N₃,N₄,N₅,N₆}
	!timeit && return _recurseEr(Er0, Er, A, H, B, Bl), TimerOutput()
	LocalTimer = TimerOutput()
	errk = isnothing(Er) ? "N" : "$(typeof(Er).parameters[1])_$(typeof(Er).parameters[2])"
	blrank = isnothing(Bl) ? "N" : "$(typeof(Bl).parameters[1])"
	name = "_recurseEr_$(N₁)_$(N₂)_Er$(errk)_$(N₄)$(N₅)_A$(N₃)_B$(N₆)_Bl$(blrank)"
	@timeit LocalTimer name a, b = _recurseEr(Er0, Er, A, H, B, Bl)
	return a, b, LocalTimer
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::Nothing,
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{3},
	Bl::Nothing)
	# right boundary case

	c = H.strength[]
	@tensor Er_partial[i; g d] := c * B.A[i g b] * Er0.A[b d]
	@tensor Er_new[i; k] := Er_partial[i g d] * A.A[d k g]

	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::Nothing,
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{4},
	Bl::Nothing)
	# right boundary case

	c = H.strength[]
	@tensor Er_partial[i; g e d] := c * B.A[i g e b] * Er0.A[b d]
	@tensor Er_new[i; k] := Er_partial[i g e d] * A.A[e d k g]

	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::Nothing,
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{3},
	Bl::Nothing)
	# right boundary case

	c = H.strength[]
	@tensor Er_partial[i; h d] := c * (B.A[i g b] * Er0.A[b d]) * H.A[h g]
	@tensor Er_new[i; k] := Er_partial[i h d] * A.A[d k h]

	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::Nothing,
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{4},
	Bl::Nothing)
	# right boundary case

	c = H.strength[]
	@tensor Er_partial[i; h e d] := c * (B.A[i g e b] * Er0.A[b d]) * H.A[h g]
	@tensor Er_new[i; k] := Er_partial[i h e d] * A.A[e d k h]

	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::Nothing,
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{4},
	Bl::Nothing)
	# right boundary case

	c = H.strength[]
	@tensor Er_partial[i; g f d] := c * B.A[i g f b] * Er0.A[b d]
	@tensor Er_new[f i; k] := Er_partial[i g f d] * A.A[d k g]

	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::Nothing,
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{5},
	Bl::Nothing)
	# right boundary case

	c = H.strength[]
	@tensor Er_partial[i; g e f d] := c * B.A[i g e f b] * Er0.A[b d]
	@tensor Er_new[f i; k] := Er_partial[i g e f d] * A.A[e d k g]

	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::Nothing,
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{4},
	Bl::Nothing)
	# right boundary case

	c = H.strength[]
	@tensor Er_partial[i; h f d] := c * (B.A[i g f b] * Er0.A[b d]) * H.A[h g]
	@tensor Er_new[f i; k] := Er_partial[i h f d] * A.A[d k h]

	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::Nothing,
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{5},
	Bl::Nothing)
	# right boundary case

	c = H.strength[]
	@tensor Er_partial[i; h e f d] := c * (B.A[i g e f b] * Er0.A[b d]) * H.A[h g]
	@tensor Er_new[f i; k] := Er_partial[i h e f d] * A.A[e d k h]

	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::Nothing,
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 1},
	B::MPSTensor{3},
	Bl::Nothing)
	# right boundary case

	c = H.strength[]
	@tensor Er_partial[j i; h d] := c * (B.A[i g b] * Er0.A[b d]) * H.A[j h g]
	@tensor Er_new[i; j k] := Er_partial[j i h d] * A.A[d k h]

	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::Nothing,
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 1},
	B::MPSTensor{4},
	Bl::Nothing)
	# right boundary case

	c = H.strength[]
	@tensor Er_partial[j i; h e d] := c * (B.A[i g e b] * Er0.A[b d]) * H.A[j h g]
	@tensor Er_new[i; j k] := Er_partial[j i h e d] * A.A[e d k h]

	return Er_new, Er_partial
end


function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::Nothing,
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 1},
	B::MPSTensor{4},
	Bl::Nothing)
	# right boundary case

	c = H.strength[]
	@tensor Er_partial[j i; h f d] := c * (B.A[i g f b] * Er0.A[b d]) * H.A[j h g]
	@tensor Er_new[f i; j k] := Er_partial[j i h f d] * A.A[d k h]

	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::Nothing,
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 1},
	B::MPSTensor{5},
	Bl::Nothing)
	# right boundary case

	c = H.strength[]
	@tensor Er_partial[j i; h e f d] := c * (B.A[i g e f b] * Er0.A[b d]) * H.A[j h g]
	@tensor Er_new[f i; j k] := Er_partial[j i h e f d] * A.A[e d k h]

	return Er_new, Er_partial
end


function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::BilayerRightTensor{1, 1},
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{3},
	Bl::MPSTensor{3})

	c = H.strength[]
	@tensor Er_partial[i; g d] := c * (B.A[i g b] * Er0.A[b d] + Bl.A[i g b] * Er.A[b d])
	@tensor Er_new[i; k] := Er_partial[i g d] * A.A[d k g]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::BilayerRightTensor{1, 1},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{4},
	Bl::MPSTensor{4})

	c = H.strength[]
	@tensor Er_partial[i; g e d] := c * (B.A[i g e b] * Er0.A[b d] + Bl.A[i g e b] * Er.A[b d])
	@tensor Er_new[i; k] := Er_partial[i g e d] * A.A[e d k g]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::BilayerRightTensor{2, 1},
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{4},
	Bl::MPSTensor{3})

	c = H.strength[]
	@tensor Er_partial[i; g f d] := c * (B.A[i g f b] * Er0.A[b d] + Bl.A[i g b] * Er.A[f b d])
	@tensor Er_new[f i; k] := Er_partial[i g f d] * A.A[d k g]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::BilayerRightTensor{2, 1},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{5},
	Bl::MPSTensor{4})

	c = H.strength[]
	@tensor Er_partial[i; g e f d] := c * (B.A[i g e f b] * Er0.A[b d] + Bl.A[i g e b] * Er.A[f b d])
	@tensor Er_new[f i; k] := Er_partial[i g e f d] * A.A[e d k g]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::BilayerRightTensor{1, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{3},
	Bl::MPSTensor{3})

	c = H.strength[]
	@tensor Er_partial[i; h d] := c * (B.A[i g b] * Er0.A[b d] + Bl.A[i g b] * Er.A[b d]) * H.A[h g]
	@tensor Er_new[i; k] := Er_partial[i h d] * A.A[d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::BilayerRightTensor{1, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{4},
	Bl::MPSTensor{4})

	c = H.strength[]
	@tensor Er_partial[i; h e d] := c * (B.A[i g e b] * Er0.A[b d] + Bl.A[i g e b] * Er.A[b d]) * H.A[h g]
	@tensor Er_new[i; k] := Er_partial[i h e d] * A.A[e d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::BilayerRightTensor{2, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{4},
	Bl::MPSTensor{3})

	c = H.strength[]
	@tensor Er_partial[i; h f d] := c * (B.A[i g f b] * Er0.A[b d] + Bl.A[i g b] * Er.A[f b d]) * H.A[h g]
	@tensor Er_new[f i; k] := Er_partial[i h f d] * A.A[d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::BilayerRightTensor{2, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{5},
	Bl::MPSTensor{4})

	c = H.strength[]
	@tensor Er_partial[i; h e f d] := c * (B.A[i g e f b] * Er0.A[b d] + Bl.A[i g e b] * Er.A[f b d]) * H.A[h g]
	@tensor Er_new[f i; k] := Er_partial[i h e f d] * A.A[e d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 2},
	Er::BilayerRightTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 2},
	B::MPSTensor{3},
	Bl::MPSTensor{3})

	c = H.strength[]
	@tensor Er_partial[i; h d] := c * (B.A[i g b] * Er0.A[b c d] + Bl.A[i g b] * Er.A[b c d]) * H.A[h g c]
	@tensor Er_new[i; k] := Er_partial[i h d] * A.A[d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 2},
	Er::BilayerRightTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 2},
	B::MPSTensor{4},
	Bl::MPSTensor{4})

	c = H.strength[]
	@tensor Er_partial[i; h e d] := c * (B.A[i g e b] * Er0.A[b c d] + Bl.A[i g e b] * Er.A[b c d]) * H.A[h g c]
	@tensor Er_new[i; k] := Er_partial[i h e d] * A.A[e d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 2},
	Er::BilayerRightTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 2},
	B::MPSTensor{3},
	Bl::MPSTensor{3})

	c = H.strength[]
	@tensor Er_partial[j i; h d] := c * (B.A[i g b] * Er0.A[b c d] + Bl.A[i g b] * Er.A[b c d]) * H.A[j h g c]
	@tensor Er_new[i; j k] := Er_partial[j i h d] * A.A[d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 2},
	Er::BilayerRightTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 2},
	B::MPSTensor{4},
	Bl::MPSTensor{4})

	c = H.strength[]
	@tensor Er_partial[j i; h e d] := c * (B.A[i g e b] * Er0.A[b c d] + Bl.A[i g e b] * Er.A[b c d]) * H.A[j h g c]
	@tensor Er_new[i; j k] := Er_partial[j i h e d] * A.A[e d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 2},
	Er::BilayerRightTensor{2, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 2},
	B::MPSTensor{4},
	Bl::MPSTensor{3})

	c = H.strength[]
	@tensor Er_partial[i; h f d] := c * (B.A[i g f b] * Er0.A[b c d] + Bl.A[i g b] * Er.A[f b c d]) * H.A[h g c]
	@tensor Er_new[f i; k] := Er_partial[i h f d] * A.A[d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 2},
	Er::BilayerRightTensor{2, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 2},
	B::MPSTensor{5},
	Bl::MPSTensor{4})

	c = H.strength[]
	@tensor Er_partial[i; h e f d] := c * (B.A[i g e f b] * Er0.A[b c d] + Bl.A[i g e b] * Er.A[f b c d]) * H.A[h g c]
	@tensor Er_new[f i; k] := Er_partial[i h e f d] * A.A[e d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 2},
	Er::BilayerRightTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{3},
	Bl::MPSTensor{3})

	c = H.strength[]
	@tensor Er_partial[c i; h d] := c * (B.A[i g b] * Er0.A[b c d] + Bl.A[i g b] * Er.A[b c d]) * H.A[h g]
	@tensor Er_new[i; c k] := Er_partial[c i h d] * A.A[d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 2},
	Er::BilayerRightTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{4},
	Bl::MPSTensor{4})

	c = H.strength[]
	@tensor Er_partial[c i; h e d] := c * (B.A[i g e b] * Er0.A[b c d] + Bl.A[i g e b] * Er.A[b c d]) * H.A[h g]
	@tensor Er_new[i; c k] := Er_partial[c i h e d] * A.A[e d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 2},
	Er::BilayerRightTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{3},
	Bl::MPSTensor{3})

	c = H.strength[]
	@tensor Er_partial[c i; g d] := c * (B.A[i g b] * Er0.A[b c d] + Bl.A[i g b] * Er.A[b c d])
	@tensor Er_new[i; c k] := Er_partial[c i g d] * A.A[d k g]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 2},
	Er::BilayerRightTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{4},
	Bl::MPSTensor{4})

	c = H.strength[]
	@tensor Er_partial[c i; g e d] := c * (B.A[i g e b] * Er0.A[b c d] + Bl.A[i g e b] * Er.A[b c d])
	@tensor Er_new[i; c k] := Er_partial[c i g e d] * A.A[e d k g]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 2},
	Er::BilayerRightTensor{2, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{4},
	Bl::MPSTensor{3})

	c = H.strength[]
	@tensor Er_partial[c i; h f d] := c * (B.A[i g f b] * Er0.A[b c d] + Bl.A[i g b] * Er.A[f b c d]) * H.A[h g]
	@tensor Er_new[f i; c k] := Er_partial[c i h f d] * A.A[d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 2},
	Er::BilayerRightTensor{2, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{5},
	Bl::MPSTensor{4})

	c = H.strength[]
	@tensor Er_partial[c i; h e f d] := c * (B.A[i g e f b] * Er0.A[b c d] + Bl.A[i g e b] * Er.A[f b c d]) * H.A[h g]
	@tensor Er_new[f i; c k] := Er_partial[c i h e f d] * A.A[e d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 2},
	Er::BilayerRightTensor{2, 2},
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{4},
	Bl::MPSTensor{3})

	c = H.strength[]
	@tensor Er_partial[c i; g f d] := c * (B.A[i g f b] * Er0.A[b c d] + Bl.A[i g b] * Er.A[f b c d])
	@tensor Er_new[f i; c k] := Er_partial[c i g f d] * A.A[d k g]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 2},
	Er::BilayerRightTensor{2, 2},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{5},
	Bl::MPSTensor{4})

	c = H.strength[]
	@tensor Er_partial[c i; g e f d] := c * (B.A[i g e f b] * Er0.A[b c d] + Bl.A[i g e b] * Er.A[f b c d])
	@tensor Er_new[f i; c k] := Er_partial[c i g e f d] * A.A[e d k g]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::BilayerRightTensor{1, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 1},
	B::MPSTensor{3},
	Bl::MPSTensor{3})

	c = H.strength[]
	@tensor Er_partial[j i; h d] := c * (B.A[i g b] * Er0.A[b d] + Bl.A[i g b] * Er.A[b d]) * H.A[j h g]
	@tensor Er_new[i; j k] := Er_partial[j i h d] * A.A[d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::BilayerRightTensor{1, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 1},
	B::MPSTensor{4},
	Bl::MPSTensor{4})

	c = H.strength[]
	@tensor Er_partial[j i; h e d] := c * (B.A[i g e b] * Er0.A[b d] + Bl.A[i g e b] * Er.A[b d]) * H.A[j h g]
	@tensor Er_new[i; j k] := Er_partial[j i h e d] * A.A[e d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::BilayerRightTensor{2, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 1},
	B::MPSTensor{4},
	Bl::MPSTensor{3})

	c = H.strength[]
	@tensor Er_partial[j i; h f d] := c * (B.A[i g f b] * Er0.A[b d] + Bl.A[i g b] * Er.A[f b d]) * H.A[j h g]
	@tensor Er_new[f i; j k] := Er_partial[j i h f d] * A.A[d k h]
	return Er_new, Er_partial
end

function _recurseEr(Er0::BilayerRightTensor{1, 1},
	Er::BilayerRightTensor{2, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 1},
	B::MPSTensor{5},
	Bl::MPSTensor{4})

	c = H.strength[]
	@tensor Er_partial[j i; h e f d] := c * (B.A[i g e f b] * Er0.A[b d] + Bl.A[i g e b] * Er.A[f b d]) * H.A[j h g]
	@tensor Er_new[f i; j k] := Er_partial[j i h e f d] * A.A[e d k h]
	return Er_new, Er_partial
end
