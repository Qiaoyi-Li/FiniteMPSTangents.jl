"""
    TangentEnvironment(base::BaseMPS, H::SparseMPO; disk=false, maxsize=disk ? 2 : L)

Cache the left and right environments used to apply `H` in the tangent space at
`base`. With `disk=true`, evicted environments are serialized to a temporary
directory; `maxsize` controls the number retained in memory. An environment is
tied to both `base` and `H` and must not be reused with different objects.
"""
mutable struct TangentEnvironment{L}
	const base::BaseMPS{L}
	const H::SparseMPO{L}
	const El::LRU{Int64, Vector{Union{Nothing, BilayerLeftTensor}}}
	const Er::LRU{Int64, Vector{Union{Nothing, BilayerRightTensor}}}
	const dir::String

	# finalizer requires mutable struct
	function TangentEnvironment(Ψ::BaseMPS{L}, H::SparseMPO{L};
		disk::Bool = false,
		maxsize::Int64 = disk ? 2 : L,
		timer::Union{Nothing, TimerOutput} = nothing,
	) where L
		Timer_environment = isnothing(timer) ? TimerOutput() : timer
		@timeit Timer_environment "TangentEnvironment" begin

		if disk
			dir = mktempdir()
			# finalizer
			function f_disk(k::Int64, v)
				# save to disk when an entry is removed
				head = isa(v, Vector{Union{Nothing, BilayerLeftTensor}}) ? "El" : "Er"
				filename = joinpath(dir, "$(head)_$(k).bin")
				serialize(filename, v)
				return nothing
			end
			El = LRU{Int64, Vector{Union{Nothing, BilayerLeftTensor}}}(; maxsize = maxsize, finalizer = f_disk)
			Er = LRU{Int64, Vector{Union{Nothing, BilayerRightTensor}}}(; maxsize = maxsize, finalizer = f_disk)
		else
			dir = ""
			maxsize = max(maxsize, L) # ensure at least L entries
			function f(k::Int64, v)
				# remember to use empty!(cache.dict) instead of empty!(cache) to avoid triggering the finalizer
				@show k, v
				return @error "an entry is removed from LRU cache without disk storage!"
			end
			El = LRU{Int64, Vector{Union{Nothing, BilayerLeftTensor}}}(; maxsize = maxsize, finalizer = f)
			Er = LRU{Int64, Vector{Union{Nothing, BilayerRightTensor}}}(; maxsize = maxsize, finalizer = f)
		end
		obj = new{L}(Ψ, H, El, Er, dir)

		_setEl!(obj, Vector{Union{Nothing, BilayerLeftTensor}}(undef, 1), 1)
		_getEl(obj, 1)[1] = id(codomain(Ψ.A[1])[1])
		for si in 1:(L-1)
			@timeit Timer_environment "_pushright" begin
			_setEl!(obj, _pushright(
					_getEl(obj, si),
					Ψ.Al[si]', H[si], Ψ.Al[si]; timer = Timer_environment,
					tree_point = ["TangentEnvironment", "_pushright"]), si + 1)
			end
		end
		_setEr!(obj, Vector{Union{Nothing, BilayerRightTensor}}(undef, 1), L)
		_getEr(obj, L)[1] = id(domain(Ψ.A[end])[end])

		for si in reverse(2:L)
			@timeit Timer_environment "_pushleft" begin
			_setEr!(obj, _pushleft(
					_getEr(obj, si),
					Ψ.Ar[si]', H[si], Ψ.Ar[si]; timer = Timer_environment,
					tree_point = ["TangentEnvironment", "_pushleft"]), si - 1)
			end
		end

		# clean
		finalizer(obj) do o
			empty!(o.El.dict)
			empty!(o.Er.dict)
			if disk
				rm(o.dir; force = true, recursive = true)
			end
			return nothing
		end

		return obj
		end
	end
end

# save and load functions
function _getEl(obj::TangentEnvironment, si::Int64)
	return _getindex_disk(obj.El, si, x -> deserialize(joinpath(obj.dir, "El_$(x).bin")))
end
function _getEr(obj::TangentEnvironment, si::Int64)
	return _getindex_disk(obj.Er, si, x -> deserialize(joinpath(obj.dir, "Er_$(x).bin")))
end
function _setEl!(obj::TangentEnvironment, El::Vector{Union{Nothing, BilayerLeftTensor}}, si::Int64)
	_setindex_disk!(obj.El, El, si)
end
function _setEr!(obj::TangentEnvironment, Er::Vector{Union{Nothing, BilayerRightTensor}}, si::Int64)
	_setindex_disk!(obj.Er, Er, si)
end

# ========================= pushleft =========================
#       e f a--
#       |/     |
#   i---B-- b--Er
#      g|      |
#   j---H-- c--
#      h|      |
#   k--A*-- d--
#       |\
#       e f
function _pushleft(Er::Vector{Union{Nothing, BilayerRightTensor}}, A::AdjointMPSTensor, H::SparseMPOTensor, B::MPSTensor;
	timer::Union{Nothing, TimerOutput} = nothing,
	tree_point::Vector{String} = ["_pushleft"])

	Er_new = Vector{Union{Nothing, BilayerRightTensor}}(nothing, size(H, 1))

	if FiniteMPS.get_num_threads_action() > 1

		idx_valid = [(i, j) for i in 1:size(H, 1), j in 1:size(H, 2) if !isnothing(H[i, j])]

		Lock = ReentrantLock()
		Threads.@threads :greedy for (i, j) in idx_valid
			tmp, to = _pushleft(Er[j], A, H[i, j], B, true)

			lock(Lock)
			try
				if isnothing(Er_new[i])
					Er_new[i] = tmp
				else
					Er_new[i] = add!!(Er_new[i], tmp)
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
				tmp, to = _pushleft(Er[j], A, H[i, j], B, true)
				if isnothing(Er_new[i])
					Er_new[i] = tmp
				else
					Er_new[i] = add!!(Er_new[i], tmp)
				end
				!isnothing(timer) && merge!(timer, to; tree_point = tree_point)
			end
		end
	end

	return Er_new
end

function _pushleft(Er::BilayerRightTensor{N₁,N₂}, A::AdjointMPSTensor{N₃}, H::IdentityOperator,
	B::MPSTensor{N₄}, timeit::Bool) where {N₁,N₂,N₃,N₄}
	!timeit && return _pushleft(Er, A, H, B), TimerOutput()
	LocalTimer = TimerOutput()
	name = "_pushleft_$(N₁)_$(N₂)_0_$(N₃)_$(N₄)"
	@timeit LocalTimer name tmp = _pushleft(Er, A, H, B)
	return tmp, LocalTimer
end

function _pushleft(Er::BilayerRightTensor{N₁,N₂}, A::AdjointMPSTensor{N₃}, H::LocalOperator{N₄,N₅},
	B::MPSTensor{N₆}, timeit::Bool) where {N₁,N₂,N₃,N₄,N₅,N₆}
	!timeit && return _pushleft(Er, A, H, B), TimerOutput()
	LocalTimer = TimerOutput()
	name = "_pushleft_$(N₁)_$(N₂)_$(N₄)$(N₅)_$(N₃)_$(N₆)"
	@timeit LocalTimer name tmp = _pushleft(Er, A, H, B)
	return tmp, LocalTimer
end

function _pushleft(Er::BilayerRightTensor{1, 1}, A::AdjointMPSTensor{3}, H::IdentityOperator, B::MPSTensor{3})::BilayerRightTensor{1, 1}
	c = H.strength[]
	return @tensor tmp[i; k] := c * (B.A[i g b] * Er.A[b d]) * A.A[d k g]
end

function _pushleft(Er::BilayerRightTensor{1, 1},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{4})::BilayerRightTensor{1, 1}
	c = H.strength[]
	return @tensor tmp[i; k] := c * (B.A[i g e b] * Er.A[b d]) * A.A[e d k g]
end

function _pushleft(Er::BilayerRightTensor{1, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{3})::BilayerRightTensor{1, 1}
	c = H.strength[]
	return @tensor tmp[i; k] := c * (B.A[i g b] * Er.A[b d]) * H.A[h g] * A.A[d k h]
end

function _pushleft(Er::BilayerRightTensor{1, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{4})::BilayerRightTensor{1, 1}
	c = H.strength[]
	return @tensor tmp[i; k] := c * (B.A[i g e b] * Er.A[b d]) * H.A[h g] * A.A[e d k h]
end

function _pushleft(Er::BilayerRightTensor{1, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 1},
	B::MPSTensor{3})::BilayerRightTensor{1, 2}
	c = H.strength[]
	return @tensor tmp[i; j k] := c * ((B.A[i g b] * Er.A[b d]) * H.A[j h g]) * A.A[d k h]
end

function _pushleft(Er::BilayerRightTensor{1, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 1},
	B::MPSTensor{4})::BilayerRightTensor{1, 2}
	c = H.strength[]
	return @tensor tmp[i; j k] := c * ((B.A[i g e b] * Er.A[b d]) * H.A[j h g]) * A.A[e d k h]
end

function _pushleft(Er::BilayerRightTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{3})::BilayerRightTensor{1, 2}
	c = H.strength[]
	return @tensor tmp[i; c k] := c * (B.A[i g b] * Er.A[b c d]) * A.A[d k g]
end

function _pushleft(Er::BilayerRightTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{4})::BilayerRightTensor{1, 2}
	c = H.strength[]
	return @tensor tmp[i; c k] := c * (B.A[i g e b] * Er.A[b c d]) * A.A[e d k g]
end

function _pushleft(Er::BilayerRightTensor{2, 1},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{4})::BilayerRightTensor{2, 1}
	c = H.strength[]
	return @tensor tmp[a i; k] := c * (B.A[i g e b] * Er.A[a b d]) * A.A[e d k g]
end

function _pushleft(Er::BilayerRightTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{3})::BilayerRightTensor{1, 2}
	c = H.strength[]
	return @tensor tmp[i; c k] := c * ((B.A[i g b] * H.A[h g]) * Er.A[b c d]) * A.A[d k h]
end

function _pushleft(Er::BilayerRightTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{4})::BilayerRightTensor{1, 2}
	c = H.strength[]
	return @tensor tmp[i; c k] := c * ((B.A[i g e b] * H.A[h g]) * Er.A[b c d]) * A.A[e d k h]
end

function _pushleft(Er::BilayerRightTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 2},
	B::MPSTensor{3})::BilayerRightTensor{1, 2}
	c = H.strength[]
	return @tensor tmp[i; j k] := c * ((B.A[i g b] * Er.A[b c d]) * H.A[j h g c]) * A.A[d k h]
end

function _pushleft(Er::BilayerRightTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 2},
	B::MPSTensor{4})::BilayerRightTensor{1, 2}
	c = H.strength[]
	return @tensor tmp[i; j k] := c * ((B.A[i g e b] * Er.A[b c d]) * H.A[j h g c]) * A.A[e d k h]
end

function _pushleft(Er::BilayerRightTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 2},
	B::MPSTensor{3})::BilayerRightTensor{1, 1}
	c = H.strength[]
	return @tensor tmp[i; k] := c * ((B.A[i g b] * Er.A[b c d]) * H.A[h g c]) * A.A[d k h]
end

function _pushleft(Er::BilayerRightTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 2},
	B::MPSTensor{4})::BilayerRightTensor{1, 1}
	c = H.strength[]
	return @tensor tmp[i; k] := c * ((B.A[i g e b] * Er.A[b c d]) * H.A[h g c]) * A.A[e d k h]
end

# ========================= pushright =========================
#   --d   e f
#  |      |/
#   --c --B--k
#  |      |g
# El--b --H--j
#  |      |h
#   --a --A--i
#         |\
#         e f

function _pushright(El::Vector{Union{Nothing, BilayerLeftTensor}},
	A::AdjointMPSTensor,
	H::SparseMPOTensor,
	B::MPSTensor;
	timer::Union{Nothing, TimerOutput} = nothing,
	tree_point::Vector{String} = ["_pushright"])

	El_new = Vector{Union{Nothing, BilayerLeftTensor}}(nothing, size(H, 2))

	if FiniteMPS.get_num_threads_action() > 1
		idx_valid = [(i, j) for i in 1:size(H, 1), j in 1:size(H, 2) if !isnothing(H[i, j])]

		Lock = ReentrantLock()
		Threads.@threads :greedy for (i, j) in idx_valid
			tmp, to = _pushright(El[i], A, H[i, j], B, true)

			lock(Lock)
			try
				if isnothing(El_new[j])
					El_new[j] = tmp
				else
					El_new[j] = add!!(El_new[j], tmp)
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
				tmp, to = _pushright(El[i], A, H[i, j], B, true)
				if isnothing(El_new[j])
					El_new[j] = tmp
				else
					El_new[j] = add!!(El_new[j], tmp)
				end
				!isnothing(timer) && merge!(timer, to; tree_point = tree_point)
			end
		end
	end
	return El_new
end

function _pushright(El::BilayerLeftTensor{N₁,N₂}, A::AdjointMPSTensor{N₃}, H::IdentityOperator,
	B::MPSTensor{N₄}, timeit::Bool) where {N₁,N₂,N₃,N₄}
	!timeit && return _pushright(El, A, H, B), TimerOutput()
	LocalTimer = TimerOutput()
	name = "_pushright_$(N₁)_$(N₂)_0_$(N₃)_$(N₄)"
	@timeit LocalTimer name tmp = _pushright(El, A, H, B)
	return tmp, LocalTimer
end

function _pushright(El::BilayerLeftTensor{N₁,N₂}, A::AdjointMPSTensor{N₃}, H::LocalOperator{N₄,N₅},
	B::MPSTensor{N₆}, timeit::Bool) where {N₁,N₂,N₃,N₄,N₅,N₆}
	!timeit && return _pushright(El, A, H, B), TimerOutput()
	LocalTimer = TimerOutput()
	name = "_pushright_$(N₁)_$(N₂)_$(N₄)$(N₅)_$(N₃)_$(N₆)"
	@timeit LocalTimer name tmp = _pushright(El, A, H, B)
	return tmp, LocalTimer
end

function _pushright(El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{3})::BilayerLeftTensor{1, 1}
	c = H.strength[]
	return @tensor tmp[i; k] := c * (El.A[a c] * A.A[i a h]) * B.A[c h k]
end

function _pushright(El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{4})::BilayerLeftTensor{1, 1}
	c = H.strength[]
	return @tensor tmp[i; k] := c * (El.A[a c] * A.A[e i a h]) * B.A[c h e k]
end

function _pushright(El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{3})::BilayerLeftTensor{1, 1}
	c = H.strength[]
	return @tensor tmp[i; k] := c * ((El.A[a c] * B.A[c g k]) * H.A[h g]) * A.A[i a h]
end

function _pushright(El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{4})::BilayerLeftTensor{1, 1}
	c = H.strength[]
	return @tensor tmp[i; k] := c * ((El.A[a c] * B.A[c g e k]) * H.A[h g]) * A.A[e i a h]
end

function _pushright(El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 2},
	B::MPSTensor{3})::BilayerLeftTensor{2, 2}
	c = H.strength[]
	return @tensor tmp[i j; k b] := c * ((El.A[a c] * B.A[c g k]) * H.A[b h g j]) * A.A[i a h]
end

function _pushright(El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 2},
	B::MPSTensor{4})::BilayerLeftTensor{2, 2}
	c = H.strength[]
	return @tensor tmp[i j; k b] := c * ((El.A[a c] * B.A[c g e k]) * H.A[b h g j]) * A.A[e i a h]
end

function _pushright(El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 1},
	B::MPSTensor{3})::BilayerLeftTensor{1, 2}
	c = H.strength[]
	return @tensor tmp[i; k b] := c * ((El.A[a c] * B.A[c g k]) * H.A[b h g]) * A.A[i a h]
end

function _pushright(El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 1},
	B::MPSTensor{4})::BilayerLeftTensor{1, 2}
	c = H.strength[]
	return @tensor tmp[i; k b] := c * ((El.A[a c] * B.A[c g e k]) * H.A[b h g]) * A.A[e i a h]
end

function _pushright(El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{3})::BilayerLeftTensor{1, 2}
	c = H.strength[]
	return @tensor tmp[i; k d] := c * (El.A[a c d] * B.A[c g k]) * A.A[i a g]
end

function _pushright(El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{4})::BilayerLeftTensor{1, 2}
	c = H.strength[]
	return @tensor tmp[i; k d] := c * (El.A[a c d] * B.A[c g e k]) * A.A[e i a g]
end

function _pushright(El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{3})::BilayerLeftTensor{1, 2}
	c = H.strength[]
	return @tensor tmp[i; k d] := c * ((El.A[a c d] * B.A[c g k]) * H.A[h g]) * A.A[i a h]
end

function _pushright(El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{4})::BilayerLeftTensor{1, 2}
	c = H.strength[]
	return @tensor tmp[i; k d] := c * ((El.A[a c d] * B.A[c g e k]) * H.A[h g]) * A.A[e i a h]
end

function _pushright(El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 2},
	B::MPSTensor{3})::BilayerLeftTensor{2, 2}
	c = H.strength[]
	return @tensor tmp[i j; k d] := c * ((El.A[a c d] * B.A[c g k]) * H.A[h g j]) * A.A[i a h]
end

function _pushright(El::BilayerLeftTensor{1, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 2},
	B::MPSTensor{4})::BilayerLeftTensor{2, 2}
	c = H.strength[]
	return @tensor tmp[i j; k d] := c * ((El.A[a c d] * B.A[c g e k]) * H.A[h g j]) * A.A[e i a h]
end

function _pushright(El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 2},
	B::MPSTensor{3})::BilayerLeftTensor{2, 1}
	c = H.strength[]
	return @tensor tmp[i j; k] := c * ((El.A[a c] * B.A[c g k]) * H.A[h g j]) * A.A[i a h]
end

function _pushright(El::BilayerLeftTensor{1, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 2},
	B::MPSTensor{4})::BilayerLeftTensor{2, 1}
	c = H.strength[]
	return @tensor tmp[i j; k] := c * ((El.A[a c] * B.A[c g e k]) * H.A[h g j]) * A.A[e i a h]
end

function _pushright(El::BilayerLeftTensor{2, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 1},
	B::MPSTensor{3})::BilayerLeftTensor{1, 1}
	c = H.strength[]
	return @tensor tmp[i; k] := c * ((El.A[a b c] * B.A[c g k]) * H.A[b h g]) * A.A[i a h]
end

function _pushright(El::BilayerLeftTensor{2, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 1},
	B::MPSTensor{4})::BilayerLeftTensor{1, 1}
	c = H.strength[]
	return @tensor tmp[i; k] := c * ((El.A[a b c] * B.A[c g e k]) * H.A[b h g]) * A.A[e i a h]
end


function _pushright(El::BilayerLeftTensor{2, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 2},
	B::MPSTensor{3})::BilayerLeftTensor{2, 1}
	c = H.strength[]
	return @tensor tmp[i j; k] := c * ((El.A[a b c] * B.A[c g k]) * H.A[b h g j]) * A.A[i a h]
end

function _pushright(El::BilayerLeftTensor{2, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 2},
	B::MPSTensor{4})::BilayerLeftTensor{2, 1}
	c = H.strength[]
	return @tensor tmp[i j; k] := c * ((El.A[a b c] * B.A[c g e k]) * H.A[b h g j]) * A.A[e i a h]
end

function _pushright(El::BilayerLeftTensor{2, 1},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{3})::BilayerLeftTensor{2, 1}
	c = H.strength[]
	return @tensor tmp[i b; k] := c * (El.A[a b c] * (B.A[c g k] * H.A[h g])) * A.A[i a h]
end

function _pushright(El::BilayerLeftTensor{2, 1},
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{3})::BilayerLeftTensor{2, 1}

	c = H.strength[]
	return @tensor tmp[i b; k] := c * (El.A[a b c] * B.A[c g k]) * A.A[i a g]

end

function _pushright(El::BilayerLeftTensor{2, 1},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{4})::BilayerLeftTensor{2, 1}
	c = H.strength[]
	return @tensor tmp[i b; k] := c * (El.A[a b c] * B.A[c g e k]) * A.A[e i a g]
end

function _pushright(El::BilayerLeftTensor{2, 1},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{4})::BilayerLeftTensor{2, 1}
	c = H.strength[]
	return @tensor tmp[i b; k] := c * (El.A[a b c] * (B.A[c g e k] * H.A[h g])) * A.A[e i a h]
end

function _pushright(El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 1},
	B::MPSTensor{3})::BilayerLeftTensor{1, 2}
	c = H.strength[]
	return @tensor tmp[i; k d] := c * ((B.A[c g k] * H.A[b h g]) * El.A[a b c d]) * A.A[i a h]
end

function _pushright(El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 1},
	B::MPSTensor{4})::BilayerLeftTensor{1, 2}
	c = H.strength[]
	return @tensor tmp[i; k d] := c * ((B.A[c g e k] * H.A[b h g]) * El.A[a b c d]) * A.A[e i a h]
end

function _pushright(El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{2, 2},
	B::MPSTensor{3})::BilayerLeftTensor{2, 2}
	c = H.strength[]
	return @tensor tmp[i j; k d] := c * ((B.A[c g k] * H.A[b h g j]) * El.A[a b c d]) * A.A[i a h]
end

function _pushright(El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{2, 2},
	B::MPSTensor{4})::BilayerLeftTensor{2, 2}
	c = H.strength[]
	return @tensor tmp[i j; k d] := c * ((B.A[c g e k] * H.A[b h g j]) * El.A[a b c d]) * A.A[e i a h]
end

function _pushright(El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{3},
	H::LocalOperator{1, 1},
	B::MPSTensor{3})::BilayerLeftTensor{2, 2}
	c = H.strength[]
	return @tensor tmp[i b; k d] := c * ((B.A[c g k] * H.A[h g]) * El.A[a b c d]) * A.A[i a h]
end

function _pushright(El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{4},
	H::LocalOperator{1, 1},
	B::MPSTensor{4})::BilayerLeftTensor{2, 2}
	c = H.strength[]
	return @tensor tmp[i b; k d] := c * ((B.A[c g e k] * H.A[h g]) * El.A[a b c d]) * A.A[e i a h]
end


function _pushright(El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{3},
	H::IdentityOperator,
	B::MPSTensor{3})::BilayerLeftTensor{2, 2}
	c = H.strength[]
	return @tensor tmp[i b; k d] := c * (B.A[c g k] * El.A[a b c d]) * A.A[i a g]
end

function _pushright(El::BilayerLeftTensor{2, 2},
	A::AdjointMPSTensor{4},
	H::IdentityOperator,
	B::MPSTensor{4})::BilayerLeftTensor{2, 2}
	c = H.strength[]
	return @tensor tmp[i b; k d] := c * (B.A[c g e k] * El.A[a b c d]) * A.A[e i a g]
end
