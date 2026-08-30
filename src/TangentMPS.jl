"""
	 struct BaseMPS{L}
		  A::Vector{MPSTensor}
		  Al::Vector{MPSTensor}
		  Ar::Vector{MPSTensor}
		  S::Vector{MPSTensor}
	 end

The base point of a tangent space on MPS manifold. For any site `i`, the site-canonical form is represented as `Al[1:i-1]`, `A[i]`, `Ar[i+1:L]` and the bond-canonical form (`i`-`i+1`) is represented as `Al[1:i]`, `S[i]`, `Ar[i+1:L]`.
"""
struct BaseMPS{L}
	A::Vector{MPSTensor}
	Al::Vector{MPSTensor}
	Ar::Vector{MPSTensor}
	S::Vector{MPSTensor}
end

function BaseMPS(Ψ::DenseMPS{L};
	Z::Union{Nothing, AbstractTensorMap, Vector{<:AbstractTensorMap}} = nothing) where L

	@assert Center(Ψ) == [1, 1]

	obj = BaseMPS{L}(Array{MPSTensor}(undef, L),
		Array{MPSTensor}(undef, L),
		Array{MPSTensor}(undef, L),
		Array{MPSTensor}(undef, L - 1))

	# initialize
	obj.A[1] = deepcopy(Ψ[1])

	# left to right sweep
	for si in 1:(L-1)
		obj.Al[si], obj.S[si] = leftorth(obj.A[si])
		obj.A[si+1] = obj.S[si] * Ψ[si+1]
	end
	obj.Al[L], _ = leftorth(obj.A[L])

	for si in reverse(2:L)
		obj.S[si-1], obj.Ar[si] = rightorth(obj.A[si])
		obj.A[si-1] = obj.Al[si-1] * obj.S[si-1]
	end
	_, obj.Ar[1] = rightorth(obj.A[1])

	if !isnothing(Z)
		_addZ!(obj, Z)
	end

	return obj
end

function _addZ!(obj::BaseMPS{L}, Z::Union{Nothing, AbstractTensorMap, Vector{<:AbstractTensorMap}}) where L
	for si in 1:L
		Zi = _getZ(Z, si)
		_addZ!(obj.Ar[si], Zi)
	end
	return obj
end

function _addZ!(A::MPSTensor{3}, Z::AbstractTensorMap)
	@tensor tmp[c a; d] := Z[a b] * A.A[c b d]
	add!(A.A, tmp, 1.0, 0.0)
	return A
end
function _addZ!(A::MPSTensor{4}, Z::AbstractTensorMap)
	@tensor tmp[a e; c d] := Z[e b] * A.A[a b c d]
	add!(A.A, tmp, 1.0, 0.0)
	return A
end
_addZ!(A::MPSTensor, ::Nothing) = A


"""
    adjoint(Φ::BaseMPS)
    adjoint(Φ::TangentMPS; base=Φ.base')

Take the Hermitian adjoint of an operator-valued base or tangent MPS. The
tangent method accepts a precomputed adjoint `base` for repeated right actions.
"""
function adjoint(Φ::BaseMPS{L}) where L
	# make sure each A is rank-4
	@assert all(si -> numind(Φ.A[si]) == 4, 1:L)

	A = Vector{MPSTensor}(undef, L)
	Al = Vector{MPSTensor}(undef, L)
	Ar = Vector{MPSTensor}(undef, L)
	for (Ap, A0) in zip([A, Al, Ar], [Φ.A, Φ.Al, Φ.Ar])
		for si in 1:L
			Ap[si] = permute(A0[si].A', ((3, 1), (4, 2)))
		end
	end

	S = Vector{MPSTensor}(undef, L - 1)
	for si in 1:L-1
		S[si] = Φ.S[si].A'
	end

	return BaseMPS{L}(A, Al, Ar, S)
end

"""
	struct TangentMPS{L}
		base::BaseMPS{L}
		B::Vector{MPSTensor}
	end

MPS tangent vector in the left-orthogonal gauge.

# Constructors
	TangentMPS(Φ::BaseMPS)
The base point itself viewed as a tangent vector via the isomorphism `T_ΦH ≃ H`.

	TangentMPS(F::SparseMPO, Φ::BaseMPS)
Apply an operator `F` to the base MPS `Φ`, return the projected tangent vector `PF|Φ⟩` as a `TangentMPS` object.
"""
struct TangentMPS{L}
	base::BaseMPS{L}
	B::Vector{MPSTensor}
end

function TangentMPS(Φ::BaseMPS{L}) where L

	obj = TangentMPS{L}(Φ, Vector{MPSTensor}(undef, L))
	for si in 1:L
		if si < L
			obj.B[si] = Φ.A[si] - MPSTensor(Φ.Al[si] * Φ.S[si])
		else
			obj.B[si] = deepcopy(Φ.A[si])
		end
	end

	return obj
end

function TangentMPS(F::SparseMPO{L}, Φ::BaseMPS{L};
	disk::Bool = false,
) where L
	return mul(F, TangentMPS(Φ); disk = disk)
end

function adjoint(Φ::TangentMPS{L}; base::BaseMPS{L} = Φ.base') where L
	@assert all(si -> numind(Φ.B[si]) ≥ 4, 1:L)

	B = Vector{MPSTensor}(undef, L)
	for si in 1:L
		if numind(Φ.B[si]) == 4
			B[si] = permute(Φ.B[si].A', ((3, 1), (4, 2)))
		elseif numind(Φ.B[si]) == 5
			B[si] = permute(Φ.B[si].A', ((4, 1), (5, 2, 3)))
		else
			error("invalid usage!")
		end
	end
	return TangentMPS{L}(base, B)
end


"""
	orth!(Φ::TangentMPS{L};
		normalize::Bool = false) -> Φ::TangentMPS{L}

Left-orthogonalize the tangent MPS `Φ`. If `normalize = true`, we consider the tangent space of normalized MPS, thus the component along the base MPS are also projected out.
"""
function orth!(Φ::TangentMPS{L}; normalize::Bool = false) where L

	lssi = normalize ? (1:L) : (1:(L-1))
	if FiniteMPS.get_num_threads_action() > 1
		Threads.@threads :greedy for si in lssi
			_LeftOrthProj!(Φ.B[si], Φ.base.Al[si])
		end
	else
		for si in lssi
			_LeftOrthProj!(Φ.B[si], Φ.base.Al[si])
		end
	end
	return Φ
end

"""
    partialcopy(Φ::TangentMPS)

Copy the tangent tensors of `Φ` while sharing its immutable base point.
"""
function partialcopy(Φ::TangentMPS{L}) where L
	return TangentMPS{L}(Φ.base, deepcopy.(Φ.B))
end

"""
    similar(Φ::TangentMPS[, T])

Allocate an uninitialized tangent MPS with the same tensor spaces and shared
base point as `Φ`, optionally changing the scalar type to `T`.
"""
function similar(Φ::TangentMPS{L}) where L
	return TangentMPS{L}(Φ.base, map(x -> similar(x), Φ.B))
end

function similar(Φ::TangentMPS{L}, ::Type{T}) where {L, T}
	return TangentMPS{L}(Φ.base, map(x -> similar(x, T), Φ.B))
end

"""
    scalartype(Φ::TangentMPS)

Return the promoted scalar type of all local tangent tensors in `Φ`.
"""
function scalartype(Φ::TangentMPS{L}) where L
	return mapreduce(scalartype, promote_type, Φ.B)
end

function isassigned(Φ::TangentMPS, si::Int64)
	return isassigned(Φ.B, si)
end
isassigned(Φ::TangentMPS{L}) where L = all(si -> isassigned(Φ, si), 1:L)

# linear algebra operations
"""
    norm(Φ::TangentMPS)

Return the square root of the sum of local tensor norm squares in the
left-orthogonal tangent gauge.
"""
function norm(Φ::TangentMPS{L}) where L
	!isassigned(Φ) && return 0.0
	return sqrt(sum(norm.(Φ.B) .^ 2))
end

"""
    normalize!(Φ::TangentMPS)

Scale `Φ` in place to unit tangent-space norm.
"""
function normalize!(Φ::TangentMPS{L}) where L
	nrm = norm(Φ)
	iszero(nrm) && return @error "zero norm"

	for si in 1:L
		scale!(Φ.B[si], 1 / nrm)
	end
	return Φ
end

"""
    inner(Φ1::TangentMPS, Φ2::TangentMPS)

Return the tangent-space inner product as the sum of local tensor inner
products in the left-orthogonal gauge. For supported mixed-rank tangents, the
result is a rank-one tensor map carrying the open external index rather than a
scalar.
"""
function inner(Φ1::TangentMPS{L}, Φ2::TangentMPS{L}) where L

	!isassigned(Φ1) && return 0.0
	!isassigned(Φ2) && return 0.0

	if FiniteMPS.get_num_threads_action() > 1
		s = nothing
		Lock = ReentrantLock()
		Threads.@threads :greedy for si in 1:L
			tmp = inner(Φ1.B[si], Φ2.B[si])
			lock(Lock) do
				if isnothing(s)
					s = tmp
				elseif isa(s, Number)
					s += tmp
				else
					add!(s, tmp)
				end
			end
		end
		return s

	else
		return sum(si -> inner(Φ1.B[si], Φ2.B[si]), 1:L)
	end
end

"""
    add!(Φ1::TangentMPS, Φ2::TangentMPS, α=1.0, β=1.0)

Update `Φ1 ← α * Φ2 + β * Φ1`. The vectors must have compatible base points
and must be distinct objects.
"""
function add!(Φ1::TangentMPS{L}, Φ2::TangentMPS{L}, α::Number = 1.0, β::Number = 1.0) where L
	@assert !(Φ1 === Φ2)

	# deal with empty case
	!isassigned(Φ2) && return rmul!(Φ1, β)
	if !isassigned(Φ1)
		if FiniteMPS.get_num_threads_action() > 1
			Threads.@threads :greedy for si in 1:L
				Φ1.B[si] = α * Φ2.B[si]
			end
		else
			for si in 1:L
				Φ1.B[si] = α * Φ2.B[si]
			end
		end
		return Φ1
	end

	if FiniteMPS.get_num_threads_action() > 1
		Threads.@threads :greedy for si in 1:L
			Φ1.B[si] = add!!(Φ1.B[si], Φ2.B[si], α, β)
		end
	else
		for si in 1:L
			Φ1.B[si] = add!!(Φ1.B[si], Φ2.B[si], α, β)
		end
	end
	return Φ1
end

"""
    rmul!(Φ::TangentMPS, α)

Scale all local tangent tensors of `Φ` in place by `α`.
"""
function rmul!(Φ::TangentMPS{L}, α::Number) where L
	# deal with empty case
	!isassigned(Φ) && return Φ

	if FiniteMPS.get_num_threads_action() > 1
		Threads.@threads :greedy for si in 1:L
			rmul!(Φ.B[si], α)
		end
	else
		for si in 1:L
			rmul!(Φ.B[si], α)
		end
	end
	return Φ
end


"""
    free!(Φ::TangentMPS)

Release the local tangent tensors held by `Φ`. The emptied object is a
released handle: `Φ.base` is retained, but `Φ.B` has length zero and no longer
represents a tangent vector or a reusable uninitialized destination. Return
`nothing`.
"""
function free!(Φ::TangentMPS{L}) where L
	empty!(Φ.B)
	return nothing
end
