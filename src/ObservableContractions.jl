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

# Expansion-time description of every supported fixed index order. The
# generated methods themselves each contain a single direct @tensor network.
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

	function bra_indices(rank, phys)
		rank == 3 && return ["rb", "lb", phys]
		rank == 4 && return ["s", "rb", "lb", phys]
		return ["s", "q", "rb", "lb", phys]
	end
	function ket_indices(rank, phys)
		rank == 3 && return ["lk", phys, "rk"]
		rank == 4 && return ["lk", phys, "s", "rk"]
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
				bterm = "bra.A'[" * joininds(bra_indices(brank, "p")) * "]"
				kterm = "ket.A[" * joininds(ket_indices(krank, "p")) * "]"
				rhs = side == :left ? "(($envterm * $bterm) * $kterm)" : "(($kterm * $envterm) * $bterm)"
				setup = ""
			else
				bterm = "bra.A'[" * joininds(bra_indices(brank, "pb")) * "]"
				kterm = "ket.A[" * joininds(ket_indices(krank, "pk")) * "]"
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
	return esc(defs)
end

@_define_observable_attach_kernels

_left_contract(::Nothing, args...) = nothing
_left_contract(E, bra, O, ket) = _left_apply(E, _observable_rung(bra, O, ket))
_right_contract(::Nothing, args...) = nothing
_right_contract(E, bra, O, ket) = _right_apply(E, _observable_rung(bra, O, ket))

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

Advance a shared ObservableTree prefix by one site. Rank-3 inputs implement a
neutral MPS tangent; rank-4 inputs implement a neutral purified-MPO tangent;
rank-5 `braB`/`ketB` select the charged purified-MPO path. No charge flag is
needed.
"""
function observable_pushright(
	E::ObservableEnv4,
	braAl::MPSTensor{3}, braAr::MPSTensor{3}, braB::MPSTensor{3},
	O::_ObservableSiteOperator,
	ketAl::MPSTensor{3}, ketAr::MPSTensor{3}, ketB::MPSTensor{3},
)
	e00 = _left_contract(E.e00, braAl, O, ketAl)
	e10 = _observable_sum(
		_left_contract(E.e10, braAr, O, ketAl),
		_left_contract(E.e00, braB, O, ketAl),
	)
	e01 = _observable_sum(
		_left_contract(E.e01, braAl, O, ketAr),
		_left_contract(E.e00, braAl, O, ketB),
	)
	e11 = _observable_sum(
		_left_contract(E.e11, braAr, O, ketAr),
		_left_contract(E.e10, braAr, O, ketB),
		_left_contract(E.e01, braB, O, ketAr),
		_left_contract(E.e00, braB, O, ketB),
	)
	return ObservableEnv4(e00, e10, e01, e11)
end

function observable_pushright(
	E::ObservableEnv4,
	braAl::MPSTensor{4}, braAr::MPSTensor{4}, braB::MPSTensor{4},
	O::_ObservableSiteOperator,
	ketAl::MPSTensor{4}, ketAr::MPSTensor{4}, ketB::MPSTensor{4},
)
	e00 = _left_contract(E.e00, braAl, O, ketAl)
	e10 = _observable_sum(
		_left_contract(E.e10, braAr, O, ketAl),
		_left_contract(E.e00, braB, O, ketAl),
	)
	e01 = _observable_sum(
		_left_contract(E.e01, braAl, O, ketAr),
		_left_contract(E.e00, braAl, O, ketB),
	)
	e11 = _observable_sum(
		_left_contract(E.e11, braAr, O, ketAr),
		_left_contract(E.e10, braAr, O, ketB),
		_left_contract(E.e01, braB, O, ketAr),
		_left_contract(E.e00, braB, O, ketB),
	)
	return ObservableEnv4(e00, e10, e01, e11)
end

function observable_pushright(
	E::ObservableEnv4,
	braAl::MPSTensor{4}, braAr::MPSTensor{4}, braB::MPSTensor{5},
	O::_ObservableSiteOperator,
	ketAl::MPSTensor{4}, ketAr::MPSTensor{4}, ketB::MPSTensor{5},
)
	e00 = _left_contract(E.e00, braAl, O, ketAl)
	e10 = _observable_sum(
		_left_contract(E.e10, braAr, O, ketAl),
		_left_contract(E.e00, braB, O, ketAl),
	)
	e01 = _observable_sum(
		_left_contract(E.e01, braAl, O, ketAr),
		_left_contract(E.e00, braAl, O, ketB),
	)
	e11 = _observable_sum(
		_left_contract(E.e11, braAr, O, ketAr),
		_left_contract(E.e10, braAr, O, ketB),
		_left_contract(E.e01, braB, O, ketAr),
		_left_contract(E.e00, braB, O, ketB),
	)
	return ObservableEnv4(e00, e10, e01, e11)
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
	e00 = _right_contract(E.e00, braAr, O, ketAr)
	e10 = _observable_sum(
		_right_contract(E.e10, braAl, O, ketAr),
		_right_contract(E.e00, braB, O, ketAr),
	)
	e01 = _observable_sum(
		_right_contract(E.e01, braAr, O, ketAl),
		_right_contract(E.e00, braAr, O, ketB),
	)
	e11 = _observable_sum(
		_right_contract(E.e11, braAl, O, ketAl),
		_right_contract(E.e10, braAl, O, ketB),
		_right_contract(E.e01, braB, O, ketAl),
		_right_contract(E.e00, braB, O, ketB),
	)
	return ObservableEnv4(e00, e10, e01, e11)
end

function observable_pushleft(
	E::ObservableEnv4,
	braAl::MPSTensor{4}, braAr::MPSTensor{4}, braB::MPSTensor{4},
	O::_ObservableSiteOperator,
	ketAl::MPSTensor{4}, ketAr::MPSTensor{4}, ketB::MPSTensor{4},
)
	e00 = _right_contract(E.e00, braAr, O, ketAr)
	e10 = _observable_sum(
		_right_contract(E.e10, braAl, O, ketAr),
		_right_contract(E.e00, braB, O, ketAr),
	)
	e01 = _observable_sum(
		_right_contract(E.e01, braAr, O, ketAl),
		_right_contract(E.e00, braAr, O, ketB),
	)
	e11 = _observable_sum(
		_right_contract(E.e11, braAl, O, ketAl),
		_right_contract(E.e10, braAl, O, ketB),
		_right_contract(E.e01, braB, O, ketAl),
		_right_contract(E.e00, braB, O, ketB),
	)
	return ObservableEnv4(e00, e10, e01, e11)
end

function observable_pushleft(
	E::ObservableEnv4,
	braAl::MPSTensor{4}, braAr::MPSTensor{4}, braB::MPSTensor{5},
	O::_ObservableSiteOperator,
	ketAl::MPSTensor{4}, ketAr::MPSTensor{4}, ketB::MPSTensor{5},
)
	e00 = _right_contract(E.e00, braAr, O, ketAr)
	e10 = _observable_sum(
		_right_contract(E.e10, braAl, O, ketAr),
		_right_contract(E.e00, braB, O, ketAr),
	)
	e01 = _observable_sum(
		_right_contract(E.e01, braAr, O, ketAl),
		_right_contract(E.e00, braAr, O, ketB),
	)
	e11 = _observable_sum(
		_right_contract(E.e11, braAl, O, ketAl),
		_right_contract(E.e10, braAl, O, ketB),
		_right_contract(E.e01, braB, O, ketAl),
		_right_contract(E.e00, braB, O, ketB),
	)
	return ObservableEnv4(e00, e10, e01, e11)
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

_join_00_11(L, R) = _join_neutral(L, R)
_join_11_00(L, R) = _join_neutral(L, R)

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

"""
    observable_leaf(L, R)

Close only complementary insertion sectors: `00/11`, `11/00`, `10/01`, and
`01/10`. The charged joins are deliberately role-specific, so self-dual
representations cannot make a bra-bra or ket-ket connection look valid.
"""
function observable_leaf(L::ObservableEnv4, R::ObservableEnv4)
	terms = (
		_join_00_11(L.e00, R.e11),
		_join_11_00(L.e11, R.e00),
		_join_10_01(L.e10, R.e01),
		_join_01_10(L.e01, R.e10),
	)
	value = nothing
	for term in terms
		isnothing(term) && continue
		value = isnothing(value) ? term : value + term
	end
	isnothing(value) && throw(ArgumentError("no compatible observable leaf sectors to close"))
	return value
end
