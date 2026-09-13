module ObservableLocalFixtures

using FiniteMPSTangents
using FiniteMPSTangents.FiniteMPS
using LinearAlgebra: norm, rmul!
using Random

include("../fixtures.jl")

export local_fixture, reference_environment, equal_environment,
       half_environments, environment_fixture, auxiliary_space, virtual_space

const Contractions = FiniteMPSTangents

function random_map(rng, cod, dom)
    A = TensorMap{ComplexF64}(undef, cod, dom)
    for (_, block) in blocks(A)
        randn!(rng, block)
    end
    norm(A) > 0 || error("The fixture has no nonzero symmetry-compatible blocks")
    rmul!(A, inv(norm(A)))
    return A
end

function virtual_space(symmetry)
    symmetry == "NoSym" && return ℂ^3
    reference = PerformanceFixtures.center_space(symmetry, first(PerformanceFixtures.dimensions(symmetry)))
    rows = [sector => 1 for sector in sectors(reference)]
    return PerformanceFixtures._rep(symmetry, rows)
end

function auxiliary_space(symmetry; dual_probe=false)
    symmetry == "NoSym" && return ℂ^2
    symmetry == "U1" && return dual_probe ? Rep[U₁](1=>1) : Rep[U₁](0=>1, 1=>1)
    symmetry == "SU2" && return Rep[SU₂](1=>1)
    symmetry == "U1xSU2" && return Rep[U₁×SU₂]((0,1)=>1)
    error("Unknown observable symmetry $symmetry")
end

function environment_fixture(rng, side, role, place, bra_space, ket_space, Q, X)
    cod, dom = side == :left ? ([bra_space], [ket_space]) : ([ket_space], [bra_space])
    role == :bra && push!(cod, Q)
    role == :ket && pushfirst!(dom, Q)
    if place == :C
        insert!(cod, role == :bra ? length(cod) : length(cod)+1, X)
    elseif place == :D
        insert!(dom, side == :left ? length(dom)+1 : role == :ket ? 2 : 1, X)
    end
    wrappers = side == :left ?
        (Contractions.ObservableLeftEnv, Contractions.ObservableLeftBraOpen, Contractions.ObservableLeftKetOpen) :
        (Contractions.ObservableRightEnv, Contractions.ObservableRightBraOpen, Contractions.ObservableRightKetOpen)
    wrapper = wrappers[role == :neutral ? 1 : role == :bra ? 2 : 3]
    return wrapper(random_map(rng, prod(cod), prod(dom)))
end

function local_fixture(rng, symmetry, base_rank, charged, kind, side, place; dual_probe=false)
    P = PerformanceFixtures.physical_space(symmetry)
    Q = PerformanceFixtures.charge_space(symmetry)
    X = auxiliary_space(symmetry; dual_probe)
    VL = virtual_space(symmetry)
    VR = base_rank == 3 ? fuse(VL ⊗ P) : VL
    function site(extra)
        dom = extra ? Q ⊗ VR : VR
        base_rank == 4 && (dom = P ⊗ dom)
        return MPSTensor(random_map(rng, VL ⊗ P, dom))
    end
    braAl, braAr, braB = site(false), site(false), site(charged[1])
    ketAl, ketAr, ketB = site(false), site(false), site(charged[2])
    operator = if kind == :I
        IdentityOperator(P, trivial(P), 9, 1.0)
    else
        cod = kind in (:O21, :O22) ? X ⊗ P : P
        dom = kind in (:O12, :O22) ? P ⊗ X : P
        LocalOperator(random_map(rng, cod, dom), :probe, 9, false)
    end
    roles = (:neutral, charged[1] ? :bra : :neutral,
             charged[2] ? :ket : :neutral,
             charged[1] == charged[2] ? :neutral : charged[1] ? :bra : :ket)
    V = side == :left ? VL : VR
    incoming = (side == :left && place == :C && kind in (:O21, :O22)) ||
               (side == :right && place == :D && kind in (:O12, :O22)) ? X' : X
    E = Contractions.ObservableEnv4(map(role -> environment_fixture(rng, side, role, place, V, V, Q, incoming), roles)...)
    arguments = (E, braAl, braAr, braB, operator, ketAl, ketAr, ketB)
    return (; arguments, VL, VR, P, Q, X, incoming)
end

function reference_environment(side, E, braAl, braAr, braB, operator, ketAl, ketAr, ketB)
    contract = side == :left ? Contractions._left_contract : Contractions._right_contract
    b0, b1 = side == :left ? (braAl, braAr) : (braAr, braAl)
    k0, k1 = side == :left ? (ketAl, ketAr) : (ketAr, ketAl)
    return Contractions.ObservableEnv4(contract(E.e00, b0, operator, k0),
        Contractions._observable_sum(contract(E.e10, b1, operator, k0), contract(E.e00, braB, operator, k0)),
        Contractions._observable_sum(contract(E.e01, b0, operator, k1), contract(E.e00, b0, operator, ketB)),
        Contractions._observable_sum(contract(E.e11, b1, operator, k1), contract(E.e10, b1, operator, ketB),
            contract(E.e01, braB, operator, k1), contract(E.e00, braB, operator, ketB)))
end

function equal_environment(actual, expected)
    return all(1:4) do i
        x, y = getfield(actual, i), getfield(expected, i)
        !isnothing(x) && !isnothing(y) && isfinite(norm(x.A)) && norm(x.A)>0 &&
            isapprox(x.A, y.A; atol=1e-11, rtol=1e-9)
    end
end

function half_environments(arguments, base_rank)
    E, braAl, braAr, braB = arguments[1:4]
    base = Val(base_rank)
    f00 = Contractions._observable_first!(nothing, E.e00, braAl, base)
    f10 = Contractions._observable_first!(nothing, E.e10, braAr, base)
    f10 = Contractions._observable_first!(f10, E.e00, braB, base)
    f01 = Contractions._observable_first!(nothing, E.e01, braAl, base)
    f11 = Contractions._observable_first!(nothing, E.e11, braAr, base)
    f11 = Contractions._observable_first!(f11, E.e01, braB, base)
    return (f00, f10, f01, f11)
end

end
