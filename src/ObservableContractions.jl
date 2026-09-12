"""
    ObservableEnv4(e00, e10, e01, e11)

Four-sector environment for the natural-isomorphism image of a tangent
vector. The two bits record whether the single tangent tensor has occurred in
the bra and ket layers. `nothing` denotes an unreachable sector.

All contractions in this file are explicit TensorOperations networks. A
FiniteMPS boundary wrapper may be unwrapped, but no FiniteMPS environment
push/leaf implementation is called.
"""
struct ObservableEnv4{E00,E10,E01,E11}
	e00::E00
	e10::E10
	e01::E01
	e11::E11
end

ObservableEnv4(e00) = ObservableEnv4(e00, nothing, nothing, nothing)

abstract type AbstractObservableLeftEnv end
abstract type AbstractObservableRightEnv end

# Nout/Nin merely mirror the TensorMap's native partition. Semantic order is
# fixed by the concrete sector type; there is no charge-mode or leg-role field.
# `BraOpen` and `KetOpen` describe the orientation of the one global charge
# leg at the cut, not which input tensor introduced it. In particular, a
# registered left-open operator string is seeded as `BraOpen` and may later be
# closed by a charged ket center.
struct ObservableLeftEnv{Nout,Nin,T<:AbstractTensorMap} <: AbstractObservableLeftEnv
	A::T
end
struct ObservableLeftBraOpen{Nout,Nin,T<:AbstractTensorMap} <: AbstractObservableLeftEnv
	A::T
end
struct ObservableLeftKetOpen{Nout,Nin,T<:AbstractTensorMap} <: AbstractObservableLeftEnv
	A::T
end
struct ObservableRightEnv{Nout,Nin,T<:AbstractTensorMap} <: AbstractObservableRightEnv
	A::T
end
struct ObservableRightBraOpen{Nout,Nin,T<:AbstractTensorMap} <: AbstractObservableRightEnv
	A::T
end
struct ObservableRightKetOpen{Nout,Nin,T<:AbstractTensorMap} <: AbstractObservableRightEnv
	A::T
end

ObservableLeftEnv(A::T) where {T<:AbstractTensorMap} =
	ObservableLeftEnv{numout(A),numin(A),T}(A)
ObservableLeftBraOpen(A::T) where {T<:AbstractTensorMap} =
	ObservableLeftBraOpen{numout(A),numin(A),T}(A)
ObservableLeftKetOpen(A::T) where {T<:AbstractTensorMap} =
	ObservableLeftKetOpen{numout(A),numin(A),T}(A)
ObservableRightEnv(A::T) where {T<:AbstractTensorMap} =
	ObservableRightEnv{numout(A),numin(A),T}(A)
ObservableRightBraOpen(A::T) where {T<:AbstractTensorMap} =
	ObservableRightBraOpen{numout(A),numin(A),T}(A)
ObservableRightKetOpen(A::T) where {T<:AbstractTensorMap} =
	ObservableRightKetOpen{numout(A),numin(A),T}(A)

"""
    observable_left_boundary(A)

Unwrap and retain the boundary's actual TensorMap partition. In particular,
rank-two scalar boundaries stay rank two, while a custom rank-three boundary
may keep its observable auxiliary in either codomain or domain.
"""
observable_left_boundary(A::AbstractTensorMap) = ObservableLeftEnv(A)
observable_left_boundary(A::FiniteMPS.LocalLeftTensor) = observable_left_boundary(A.A)

"""
    observable_right_boundary(A)

Right-boundary counterpart of [`observable_left_boundary`](@ref).
"""
observable_right_boundary(A::AbstractTensorMap) = ObservableRightEnv(A)
observable_right_boundary(A::FiniteMPS.LocalRightTensor) = observable_right_boundary(A.A)

observable_left_root(args...) = ObservableEnv4(observable_left_boundary(args...))
observable_right_root(args...) = ObservableEnv4(observable_right_boundary(args...))

"""
    observable_seed_left_open(E, space)

Lift a neutral rank-two left root through the identity on a registered
operator string's nontrivial left auxiliary space. The codomain copy is the
string's single global open leg; the domain copy starts the ordinary
horizontal bond propagated and ultimately consumed by the left-to-right
operator transitions. Keeping both in `ObservableLeftBraOpen` lets a charged
ket center close the global leg while the horizontal bond continues
independently.
"""
function observable_seed_left_open(
	E::ObservableEnv4{<:ObservableLeftEnv{1,1},Nothing,Nothing,Nothing},
	space,
)
	bridge = id(space)
	@tensor tmp[b q; k x] := E.e00.A[b, k] * bridge[q, x]
	return ObservableEnv4(ObservableLeftBraOpen(tmp))
end

# ---------------------------------------------------------------------------
# Lazy local rung and generated explicit attach kernels
# ---------------------------------------------------------------------------

# This descriptor is lazy: it stores only the three local inputs. The attach
# kernel below expands to one @tensor network, so no D^4 four-bond transfer is
# ever materialized. Its fields carry no charge/leg role metadata.
struct _ObservableRung{B,O,K}
	bra::B
	op::O
	ket::K
end

_observable_rung(bra, op, ket) = _ObservableRung(bra, op, ket)

_observable_operator_tensor(O::LocalOperator) = isnothing(O.A) ?
	throw(ArgumentError("observable contraction requires a materialized local operator tensor")) : O.A

struct _ObservableHalf{Side,Role,Place,Rank,T<:AbstractTensorMap}
	A::T
end

_ObservableHalf{S,R,P,N}(A::T) where {S,R,P,N,T<:AbstractTensorMap} =
	_ObservableHalf{S,R,P,N,T}(A)

function _observable_accumulator(A::AbstractTensorMap, ::Type{T}) where T
	U = TensorOperations.promote_add(scalartype(A), T)
	return U <: scalartype(A) ? A : copy!(similar(A, U), A)
end

# Expansion-time description of every supported fixed index order. Generated
# kernels use explicit @tensor networks for full or half contractions.
# Observable auxiliary legs are native too: O12.y stays a domain leg in a
# left environment; O21.x stays a codomain leg in a right environment.
#
# Flat cut layouts (N=no observable aux, C=codomain, D=domain):
#
#   left 00/11: N [b,k],       C [b,x,k],       D [b,k,x]
#   left 10:    N [b,q,k],     C [b,x,q,k],     D [b,q,k,x]
#   left 01:    N [b,q,k],     C [b,x,q,k],     D [b,q,k,x]
#   right 00/11:N [k,b],       C [k,x,b],       D [k,x,b]
#   right 10:   N [k,q,b],     C [k,x,q,b],     D [k,q,x,b]
#   right 01:   N [k,q,b],     C [k,x,q,b],     D [k,q,x,b]
#
# The wrappers' native partition distinguishes rows with the same flat list.
# In particular, right C is ket-first, matching FiniteMPS.LocalRightTensor.
macro _define_observable_attach_kernels()
	defs = Expr(:block)

	wrappers = Dict(
		(:left, :neutral) => "ObservableLeftEnv",
		(:left, :bra) => "ObservableLeftBraOpen",
		(:left, :ket) => "ObservableLeftKetOpen",
		(:right, :neutral) => "ObservableRightEnv",
		(:right, :bra) => "ObservableRightBraOpen",
		(:right, :ket) => "ObservableRightKetOpen",
	)
	shapes = Dict(
		(:neutral, :N) => (1, 1), (:neutral, :C) => (2, 1), (:neutral, :D) => (1, 2),
		(:bra, :N) => (2, 1), (:bra, :C) => (3, 1), (:bra, :D) => (2, 2),
		(:ket, :N) => (1, 2), (:ket, :C) => (2, 2), (:ket, :D) => (1, 3),
	)

	function charge_result(envrole, localrole)
		envrole == :neutral && return localrole
		localrole == :neutral && return envrole
		envrole == :bra && localrole == :ket && return :neutral
		envrole == :ket && localrole == :bra && return :neutral
		return nothing
	end

	function flat_environment(side, role, place, aux)
		if side == :left
			base = role == :neutral ? ["lb", "lk"] : ["lb", "q", "lk"]
			place == :N && return base
			place == :C && return role == :neutral ? ["lb", aux, "lk"] : ["lb", aux, "q", "lk"]
			return role == :neutral ? ["lb", "lk", aux] : ["lb", "q", "lk", aux]
		else
			base = role == :neutral ? ["rk", "rb"] : ["rk", "q", "rb"]
			place == :N && return base
			place == :C && return role == :neutral ? ["rk", aux, "rb"] : ["rk", aux, "q", "rb"]
			return role == :neutral ? ["rk", aux, "rb"] : ["rk", "q", aux, "rb"]
		end
	end

	function result_partition(side, role, place, aux)
		if side == :left
			if role == :neutral
				cod, dom = ["rb"], ["rk"]
			elseif role == :bra
				cod, dom = ["rb", "q"], ["rk"]
			else
				cod, dom = ["rb"], ["q", "rk"]
			end
			place == :C && insert!(cod, role == :bra ? length(cod) : length(cod) + 1, aux)
			place == :D && push!(dom, aux)
		else
			if role == :neutral
				cod, dom = ["lk"], ["lb"]
			elseif role == :bra
				cod, dom = ["lk", "q"], ["lb"]
			else
				cod, dom = ["lk"], ["q", "lb"]
			end
			place == :C && insert!(cod, role == :bra ? length(cod) : length(cod) + 1, aux)
			place == :D && insert!(dom, role == :ket ? 2 : 1, aux)
		end
		return cod, dom
	end

	function transitions(side, opkind)
		if opkind in (:I, :O11)
			return [(p, p, "x", "x") for p in (:N, :C, :D)]
		elseif side == :left && opkind == :O12
			return [(:N, :D, "", "y")]
		elseif side == :left && opkind == :O21
			return [(:C, :N, "x", ""), (:D, :N, "x", "")]
		elseif side == :left && opkind == :O22
			return [(:C, :D, "x", "y"), (:D, :D, "x", "y")]
		elseif side == :right && opkind == :O21
			return [(:N, :C, "", "x")]
		elseif side == :right && opkind == :O12
			return [(:C, :N, "y", ""), (:D, :N, "y", "")]
		else # right O22
			return [(:C, :C, "y", "x"), (:D, :C, "y", "x")]
		end
	end

	function bra_indices(rank, phys, localrole)
		rank == 3 && return ["rb", "lb", phys]
		rank == 4 && return [localrole == :bra ? "q" : "s", "rb", "lb", phys]
		return ["s", "q", "rb", "lb", phys]
	end
	function ket_indices(rank, phys, localrole)
		rank == 3 && return ["lk", phys, "rk"]
		rank == 4 && return ["lk", phys, localrole == :ket ? "q" : "s", "rk"]
		return ["lk", phys, "s", "q", "rk"]
	end
	joininds(xs) = join(xs, ",")

	ops = (
		(:I, "IdentityOperator"),
		(:O11, "LocalOperator{1,1}"),
		(:O12, "LocalOperator{1,2}"),
		(:O21, "LocalOperator{2,1}"),
		(:O22, "LocalOperator{2,2}"),
	)
	localmodes = (
		(3, 3, :neutral),
		(4, 3, :bra),
		(3, 4, :ket),
		(4, 4, :neutral),
		(5, 4, :bra),
		(4, 5, :ket),
		(5, 5, :neutral),
	)

	for side in (:left, :right), envrole in (:neutral, :bra, :ket),
		(brank, krank, localrole) in localmodes, (opkind, optype) in ops
		# A rank-5/rank-5 rung closes its own q and is only a same-site
		# pair transition out of a neutral sector.
		brank == 5 && krank == 5 && envrole != :neutral && continue
		outrole = charge_result(envrole, localrole)
		isnothing(outrole) && continue

		for (pin, pout, incomingaux, outgoingaux) in transitions(side, opkind)
			Ein = wrappers[(side, envrole)]
			Eout = wrappers[(side, outrole)]
			nout, nin = shapes[(envrole, pin)]
			envinds = flat_environment(side, envrole, pin, incomingaux)
			cod, dom = result_partition(side, outrole, pout, outgoingaux)
			# TensorOperations' partition syntax uses whitespace-separated
			# indices on either side of `;` (Julia's comma parser treats the
			# single-codomain case as an array concatenation expression).
			lhs = "tmp[" * join(cod, " ") * ";" * join(dom, " ") * "]"
			envterm = "E.A[" * joininds(envinds) * "]"

			if opkind == :I
				bterm = "bra.A'[" * joininds(bra_indices(brank, "p", localrole)) * "]"
				kterm = "ket.A[" * joininds(ket_indices(krank, "p", localrole)) * "]"
				rhs = side == :left ? "(($envterm * $bterm) * $kterm)" : "(($kterm * $envterm) * $bterm)"
				setup = ""
			else
				bterm = "bra.A'[" * joininds(bra_indices(brank, "pb", localrole)) * "]"
				kterm = "ket.A[" * joininds(ket_indices(krank, "pk", localrole)) * "]"
				oinds = opkind == :O11 ? ["pb", "pk"] :
					opkind == :O12 ? ["pb", "pk", "y"] :
					opkind == :O21 ? ["x", "pb", "pk"] : ["x", "pb", "pk", "y"]
				oterm = "A[" * joininds(oinds) * "]"
				rhs = side == :left ? "((($envterm * $bterm) * $oterm) * $kterm)" :
					"((($kterm * $envterm) * $oterm) * $bterm)"
				setup = "A = _observable_operator_tensor(R.op)"
			end

			fname = side == :left ? "_left_apply" : "_right_apply"
			source = """
			function $fname(E::$Ein{$nout,$nin}, R::_ObservableRung{B,O,K}) where {B<:MPSTensor{$brank},O<:$optype,K<:MPSTensor{$krank}}
			    bra, ket = R.bra, R.ket
			    $setup
			    @tensor $lhs := $rhs
			    return $Eout(tmp)
			end
			"""
			push!(defs.args, Meta.parse(source))
		end
	end

	function half_partition(side, role, place, base, aux)
		cod, dom = result_partition(side, role, place, aux)
		if side == :left
			dom = replace(dom, "rk" => "lk")
			push!(dom, "p")
			base == 4 && pushfirst!(cod, "s")
		else
			dom = replace(dom, "lb" => "rb")
			push!(cod, "p")
			base == 4 && pushfirst!(dom, "s")
		end
		return cod, dom
	end
	partition(cod, dom) = "tmp[" * join(cod, " ") * ";" * join(dom, " ") * "]"
	half_type(side, role, place, base) = "_ObservableHalf{:$side,:$role,:$place,$base}"
	function accumulation(lhs, rhs, result, types)
		return """
		if isnothing(dst)
		    @tensor $lhs := $rhs
		else
		    tmp = _observable_accumulator(dst.A, TensorOperations.promote_contract($types))
		    @tensor $lhs += $rhs
		end
		return $result(tmp)
		"""
	end

	for side in (:left, :right), role in (:neutral, :bra, :ket),
		place in (:N, :C, :D), base in (3, 4)
		H = half_type(side, role, place, base)
		hcod, hdom = half_partition(side, role, place, base, "x")
		hinds = vcat(hcod, hdom)
		for rank in (base, base + 1)
			firstrole = rank == base ? :neutral : side == :left ? :bra : :ket
			outrole = charge_result(role, firstrole)
			if !isnothing(outrole)
				Ein = wrappers[(side, role)]
				nout, nin = shapes[(role, place)]
				Hout = half_type(side, outrole, place, base)
				cod, dom = half_partition(side, outrole, place, base, "x")
				einds = flat_environment(side, role, place, "x")
				xinds = side == :left ? bra_indices(rank, "p", firstrole) : ket_indices(rank, "p", firstrole)
				xterm = (side == :left ? "X'[" : "X[") * joininds(xinds) * "]"
				eterm = "E.A[" * joininds(einds) * "]"
				rhs = side == :left ? "$eterm * $xterm" : "$xterm * $eterm"
				body = accumulation(partition(cod, dom), rhs, Hout, "scalartype(E.A), scalartype(X)")
				push!(defs.args, Meta.parse("""
				function _observable_first!(dst::Union{Nothing,$Hout}, E::$Ein{$nout,$nin},
				                            X::AbstractTensorMap, ::Val{($base,$rank)})
				    $body
				end
				"""))
			end

			lastrole = rank == base ? :neutral : side == :left ? :ket : :bra
			outrole = charge_result(role, lastrole)
			if !isnothing(outrole)
				Eout = wrappers[(side, outrole)]
				cod, dom = result_partition(side, outrole, place, "x")
				xinds = side == :left ? ket_indices(rank, "p", lastrole) : bra_indices(rank, "p", lastrole)
				xterm = (side == :left ? "X[" : "X'[") * joininds(xinds) * "]"
				rhs = "F.A[" * joininds(hinds) * "] * $xterm"
				body = accumulation(partition(cod, dom), rhs, Eout, "scalartype(F.A), scalartype(X)")
				push!(defs.args, Meta.parse("""
				function _observable_second!(dst::Union{Nothing,$Eout}, F::$H,
				                             X::AbstractTensorMap, ::Val{$rank})
				    $body
				end
				"""))
			end
		end

		for (opkind, _) in ops
			opkind == :I && continue
			for (pin, pout, incomingaux, outgoingaux) in transitions(side, opkind)
				pin == place || continue
				icod, idom = half_partition(side, role, pin, base, incomingaux)
				cod, dom = half_partition(side, role, pout, base, outgoingaux)
				finds = replace(vcat(icod, idom), "p" => side == :left ? "pb" : "pk")
				cod = replace(cod, "p" => side == :left ? "pk" : "pb")
				dom = replace(dom, "p" => side == :left ? "pk" : "pb")
				oinds = opkind == :O11 ? ["pb", "pk"] :
					opkind == :O12 ? ["pb", "pk", "y"] :
					opkind == :O21 ? ["x", "pb", "pk"] : ["x", "pb", "pk", "y"]
				shape = opkind == :O11 ? (1, 1) : opkind == :O12 ? (1, 2) : opkind == :O21 ? (2, 1) : (2, 2)
				Hout = half_type(side, role, pout, base)
				lhs = partition(cod, dom)
				rhs = "F.A[" * joininds(finds) * "] * A[" * joininds(oinds) * "]"
				push!(defs.args, Meta.parse("""
				function _observable_half_operator(F::$H, A::AbstractTensorMap, ::Val{$shape})
				    @tensor $lhs := $rhs
				    return $Hout(tmp)
				end
				"""))
			end
		end
	end
	return esc(defs)
end

@_define_observable_attach_kernels

_left_contract(::Nothing, args...) = nothing
_left_contract(E, bra, O, ket) = _left_apply(E, _observable_rung(bra, O, ket))
_right_contract(::Nothing, args...) = nothing
_right_contract(E, bra, O, ket) = _right_apply(E, _observable_rung(bra, O, ket))

_observable_first!(dst, ::Nothing, X::MPSTensor, base::Val) = dst
_observable_first!(dst, E, X::MPSTensor{N}, ::Val{B}) where {N,B} =
	_observable_first!(dst, E, X.A, Val((B, N)))
_observable_second!(dst, ::Nothing, X::MPSTensor) = dst
_observable_second!(dst, F, X::MPSTensor{N}) where N =
	_observable_second!(dst, F, X.A, Val(N))
_observable_half_operator(::Nothing, O) = nothing
_observable_half_operator(F::_ObservableHalf, ::IdentityOperator) = F
_observable_half_operator(F::_ObservableHalf, O::LocalOperator{N,M}) where {N,M} =
	_observable_half_operator(F, _observable_operator_tensor(O), Val((N, M)))

function _observable_pushright(E, braAl, braAr, braB, O, ketAl, ketAr, ketB, base)
	f00 = _observable_first!(nothing, E.e00, braAl, base)
	f10 = _observable_first!(nothing, E.e10, braAr, base)
	f10 = _observable_first!(f10, E.e00, braB, base)
	f01 = _observable_first!(nothing, E.e01, braAl, base)
	f11 = _observable_first!(nothing, E.e11, braAr, base)
	f11 = _observable_first!(f11, E.e01, braB, base)
	g00 = _observable_half_operator(f00, O)
	g10 = _observable_half_operator(f10, O)
	g01 = _observable_half_operator(f01, O)
	g11 = _observable_half_operator(f11, O)
	e00 = _observable_second!(nothing, g00, ketAl)
	e10 = _observable_second!(nothing, g10, ketAl)
	e01 = _observable_second!(nothing, g01, ketAr)
	e01 = _observable_second!(e01, g00, ketB)
	e11 = _observable_second!(nothing, g11, ketAr)
	e11 = _observable_second!(e11, g10, ketB)
	return ObservableEnv4(e00, e10, e01, e11)
end

function _observable_pushleft(E, braAl, braAr, braB, O, ketAl, ketAr, ketB, base)
	f00 = _observable_first!(nothing, E.e00, ketAr, base)
	f10 = _observable_first!(nothing, E.e10, ketAr, base)
	f01 = _observable_first!(nothing, E.e01, ketAl, base)
	f01 = _observable_first!(f01, E.e00, ketB, base)
	f11 = _observable_first!(nothing, E.e11, ketAl, base)
	f11 = _observable_first!(f11, E.e10, ketB, base)
	g00 = _observable_half_operator(f00, O)
	g10 = _observable_half_operator(f10, O)
	g01 = _observable_half_operator(f01, O)
	g11 = _observable_half_operator(f11, O)
	e00 = _observable_second!(nothing, g00, braAr)
	e10 = _observable_second!(nothing, g10, braAl)
	e10 = _observable_second!(e10, g00, braB)
	e01 = _observable_second!(nothing, g01, braAr)
	e11 = _observable_second!(nothing, g11, braAl)
	e11 = _observable_second!(e11, g01, braB)
	return ObservableEnv4(e00, e10, e01, e11)
end

# ---------------------------------------------------------------------------
# Four-sector recurrences
# ---------------------------------------------------------------------------

_observable_add(::Nothing, ::Nothing) = nothing
_observable_add(::Nothing, y) = y
_observable_add(x, ::Nothing) = x

for T in (
	:ObservableLeftEnv,
	:ObservableLeftBraOpen,
	:ObservableLeftKetOpen,
	:ObservableRightEnv,
	:ObservableRightBraOpen,
	:ObservableRightKetOpen,
)
	@eval function _observable_add(x::$T, y::$T)
		return $T(x.A + y.A)
	end
end

function _observable_sum(xs...)
	out = nothing
	for x in xs
		out = _observable_add(out, x)
	end
	return out
end

const _ObservableSiteOperator = Union{
	IdentityOperator,
	LocalOperator{1,1},
	LocalOperator{1,2},
	LocalOperator{2,1},
	LocalOperator{2,2},
}

"""
    observable_pushright(E, braAl, braAr, braB, O,
                         ketAl, ketAr, ketB)

Advance a shared ObservableTree prefix by one site. Rank-3 base isometries use
rank-3 neutral or rank-4 charged MPS centers. Rank-4 base isometries use rank-4
neutral or rank-5 charged purified-MPO centers. Bra and ket centers may select
those paths independently; no charge flag is needed.
"""
function observable_pushright(
	E::ObservableEnv4,
	braAl::MPSTensor{3}, braAr::MPSTensor{3}, braB::MPSTensor{3},
	O::_ObservableSiteOperator,
	ketAl::MPSTensor{3}, ketAr::MPSTensor{3}, ketB::MPSTensor{3},
)
	return _observable_pushright(E, braAl, braAr, braB, O, ketAl, ketAr, ketB, Val(3))
end

function observable_pushright(
	E::ObservableEnv4,
	braAl::MPSTensor{4}, braAr::MPSTensor{4}, braB::MPSTensor{4},
	O::_ObservableSiteOperator,
	ketAl::MPSTensor{4}, ketAr::MPSTensor{4}, ketB::MPSTensor{4},
)
	return _observable_pushright(E, braAl, braAr, braB, O, ketAl, ketAr, ketB, Val(4))
end

function observable_pushright(
	E::ObservableEnv4,
	braAl::MPSTensor{4}, braAr::MPSTensor{4}, braB::MPSTensor{5},
	O::_ObservableSiteOperator,
	ketAl::MPSTensor{4}, ketAr::MPSTensor{4}, ketB::MPSTensor{5},
)
	return _observable_pushright(E, braAl, braAr, braB, O, ketAl, ketAr, ketB, Val(4))
end

function observable_pushright(
	E::ObservableEnv4,
	braAl::MPSTensor{3}, braAr::MPSTensor{3},
	braB::Union{MPSTensor{3},MPSTensor{4}},
	O::_ObservableSiteOperator,
	ketAl::MPSTensor{3}, ketAr::MPSTensor{3},
	ketB::Union{MPSTensor{3},MPSTensor{4}},
)
	return _observable_pushright(E, braAl, braAr, braB, O, ketAl, ketAr, ketB, Val(3))
end

function observable_pushright(
	E::ObservableEnv4,
	braAl::MPSTensor{4}, braAr::MPSTensor{4},
	braB::Union{MPSTensor{4},MPSTensor{5}},
	O::_ObservableSiteOperator,
	ketAl::MPSTensor{4}, ketAr::MPSTensor{4},
	ketB::Union{MPSTensor{4},MPSTensor{5}},
)
	return _observable_pushright(E, braAl, braAr, braB, O, ketAl, ketAr, ketB, Val(4))
end

"""
    observable_pushleft(E, braAl, braAr, braB, O,
                        ketAl, ketAr, ketB)

Advance a shared ObservableTree suffix by one site from right to left.
"""
function observable_pushleft(
	E::ObservableEnv4,
	braAl::MPSTensor{3}, braAr::MPSTensor{3}, braB::MPSTensor{3},
	O::_ObservableSiteOperator,
	ketAl::MPSTensor{3}, ketAr::MPSTensor{3}, ketB::MPSTensor{3},
)
	return _observable_pushleft(E, braAl, braAr, braB, O, ketAl, ketAr, ketB, Val(3))
end

function observable_pushleft(
	E::ObservableEnv4,
	braAl::MPSTensor{4}, braAr::MPSTensor{4}, braB::MPSTensor{4},
	O::_ObservableSiteOperator,
	ketAl::MPSTensor{4}, ketAr::MPSTensor{4}, ketB::MPSTensor{4},
)
	return _observable_pushleft(E, braAl, braAr, braB, O, ketAl, ketAr, ketB, Val(4))
end

function observable_pushleft(
	E::ObservableEnv4,
	braAl::MPSTensor{4}, braAr::MPSTensor{4}, braB::MPSTensor{5},
	O::_ObservableSiteOperator,
	ketAl::MPSTensor{4}, ketAr::MPSTensor{4}, ketB::MPSTensor{5},
)
	return _observable_pushleft(E, braAl, braAr, braB, O, ketAl, ketAr, ketB, Val(4))
end

function observable_pushleft(
	E::ObservableEnv4,
	braAl::MPSTensor{3}, braAr::MPSTensor{3},
	braB::Union{MPSTensor{3},MPSTensor{4}},
	O::_ObservableSiteOperator,
	ketAl::MPSTensor{3}, ketAr::MPSTensor{3},
	ketB::Union{MPSTensor{3},MPSTensor{4}},
)
	return _observable_pushleft(E, braAl, braAr, braB, O, ketAl, ketAr, ketB, Val(3))
end

function observable_pushleft(
	E::ObservableEnv4,
	braAl::MPSTensor{4}, braAr::MPSTensor{4},
	braB::Union{MPSTensor{4},MPSTensor{5}},
	O::_ObservableSiteOperator,
	ketAl::MPSTensor{4}, ketAr::MPSTensor{4},
	ketB::Union{MPSTensor{4},MPSTensor{5}},
)
	return _observable_pushleft(E, braAl, braAr, braB, O, ketAl, ketAr, ketB, Val(4))
end

# ---------------------------------------------------------------------------
# Four complementary leaf joins
# ---------------------------------------------------------------------------

_join_neutral(::Nothing, _) = nothing
_join_neutral(_, ::Nothing) = nothing
function _join_neutral(L::ObservableLeftEnv{1,1}, R::ObservableRightEnv{1,1})
	@tensor z[] := L.A[b, k] * R.A[k, b]
	return scalar(z)
end
function _join_neutral(L::ObservableLeftEnv{2,1}, R::ObservableRightEnv{1,2})
	@tensor z[] := L.A[b, x, k] * R.A[k, x, b]
	return scalar(z)
end
function _join_neutral(L::ObservableLeftEnv{1,2}, R::ObservableRightEnv{2,1})
	@tensor z[] := L.A[b, k, x] * R.A[k, x, b]
	return scalar(z)
end

_join_10_01(::Nothing, _) = nothing
_join_10_01(_, ::Nothing) = nothing
_join_10_01(L::ObservableLeftEnv, R::ObservableRightEnv) = _join_neutral(L, R)
function _join_10_01(L::ObservableLeftBraOpen{2,1}, R::ObservableRightKetOpen{1,2})
	@tensor z[] := L.A[b, q, k] * R.A[k, q, b]
	return scalar(z)
end
function _join_10_01(L::ObservableLeftBraOpen{3,1}, R::ObservableRightKetOpen{1,3})
	@tensor z[] := L.A[b, x, q, k] * R.A[k, q, x, b]
	return scalar(z)
end
function _join_10_01(L::ObservableLeftBraOpen{2,2}, R::ObservableRightKetOpen{2,2})
	@tensor z[] := L.A[b, q, k, x] * R.A[k, x, q, b]
	return scalar(z)
end

_join_01_10(::Nothing, _) = nothing
_join_01_10(_, ::Nothing) = nothing
_join_01_10(L::ObservableLeftEnv, R::ObservableRightEnv) = _join_neutral(L, R)
function _join_01_10(L::ObservableLeftKetOpen{1,2}, R::ObservableRightBraOpen{2,1})
	@tensor z[] := L.A[b, q, k] * R.A[k, q, b]
	return scalar(z)
end
function _join_01_10(L::ObservableLeftKetOpen{2,2}, R::ObservableRightBraOpen{2,2})
	@tensor z[] := L.A[b, x, q, k] * R.A[k, q, x, b]
	return scalar(z)
end
function _join_01_10(L::ObservableLeftKetOpen{1,3}, R::ObservableRightBraOpen{3,1})
	@tensor z[] := L.A[b, q, k, x] * R.A[k, x, q, b]
	return scalar(z)
end

_join_compatible(::Nothing, _) = nothing
_join_compatible(_, ::Nothing) = nothing
_join_compatible(L::ObservableLeftEnv, R::ObservableRightEnv) = _join_neutral(L, R)
_join_compatible(L::ObservableLeftBraOpen, R::ObservableRightKetOpen) =
	_join_10_01(L, R)
_join_compatible(L::ObservableLeftKetOpen, R::ObservableRightBraOpen) =
	_join_01_10(L, R)

"""
    observable_leaf(L, R)

Close only complementary insertion sectors: `00/11`, `11/00`, `10/01`, and
`01/10`. The charged joins are deliberately role-specific, so self-dual
representations cannot make a bra-bra or ket-ket connection look valid.
"""
function observable_leaf(L::ObservableEnv4, R::ObservableEnv4)
	terms = (
		_join_compatible(L.e00, R.e11),
		_join_compatible(L.e11, R.e00),
		_join_compatible(L.e10, R.e01),
		_join_compatible(L.e01, R.e10),
	)
	value = nothing
	for term in terms
		isnothing(term) && continue
		value = isnothing(value) ? term : value + term
	end
	isnothing(value) && throw(ArgumentError("no compatible observable leaf sectors to close"))
	return value
end
