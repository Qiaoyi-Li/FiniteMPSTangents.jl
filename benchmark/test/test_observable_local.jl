using Test
using Random
using LinearAlgebra
using FiniteMPSTangents
using FiniteMPSTangents.FiniteMPS

include("observable_local_fixtures.jl")
using .ObservableLocalFixtures

const LocalContractions = FiniteMPSTangents

@testset "Local observable contractions" begin
    previous_blas = BLAS.get_num_threads()
    previous_mul = FiniteMPS.get_num_threads_mul()
    BLAS.set_num_threads(1)
    FiniteMPS.set_num_threads_mul(1)
    try
        @testset "Single-site propagation against full-rung contractions" begin
            for (symmetry, rank, charged, kinds) in (
                ("NoSym", 3, (false,false), (:I,:O11)),
                ("NoSym", 4, (false,false), (:I,:O11)),
                ("U1", 3, (true,true), (:O22,)),
                ("U1", 4, (true,true), (:O22,)),
                ("SU2", 3, (true,true), (:O22,)),
                ("SU2", 4, (true,true), (:O22,)),
                ("U1", 3, (true,false), (:O12,:O21)),
                ("SU2", 4, (false,true), (:O12,:O21)),
                ("U1xSU2", 3, (true,true), (:O22,)),
                ("U1xSU2", 4, (true,true), (:O22,))),
                kind in kinds, side in (:left,:right)
                @testset "$symmetry base rank $rank, charged $charged, $kind from $side" begin
                    opening = (side == :left && kind == :O12) || (side == :right && kind == :O21)
                    place = kind in (:I,:O11) || opening ? :N : side == :left ? :D : :C
                    fixture = local_fixture(Xoshiro(20260912), symmetry, rank, charged, kind, side, place)
                    arguments = fixture.arguments
                    propagate = side == :left ? LocalContractions.observable_pushright : LocalContractions.observable_pushleft
                    @test numind(arguments[4]) == rank + charged[1]
                    @test numind(arguments[8]) == rank + charged[2]
                    @test equal_environment(propagate(arguments...), reference_environment(side, arguments...))
                end
            end
        end

        @testset "Non-self-dual auxiliary orientation" begin
            for side in (:left,:right), place in (:C,:D)
                fixture = local_fixture(Xoshiro(20260912), "U1", 3, (true,true), :O22, side, place; dual_probe=true)
                conjugated = (side == :left && place == :C) || (side == :right && place == :D)
                @test fixture.X != fixture.X'
                @test fixture.incoming == (conjugated ? fixture.X' : fixture.X)
                propagate = side == :left ? LocalContractions.observable_pushright : LocalContractions.observable_pushleft
                @test equal_environment(propagate(fixture.arguments...), reference_environment(side, fixture.arguments...))
            end
        end

        @testset "Operator action on half-environments" begin
            for (symmetry, charged) in (("NoSym",false), ("SU2",true))
                fixture = local_fixture(Xoshiro(20260912), symmetry, 4, (charged,charged), :O22, :left, :D)
                halves = half_environments(fixture.arguments, 4)
                results = map(F -> LocalContractions._observable_half_operator(F, fixture.arguments[5]), halves)
                @test all(x -> isfinite(norm(x.A)) && norm(x.A)>0, results)
                @test equal_environment(LocalContractions.observable_pushright(fixture.arguments...),
                                        reference_environment(:left, fixture.arguments...))
            end
        end

        @testset "Complementary environment closure" begin
            for (symmetry, charged) in (("U1",false), ("SU2",true))
                rng = Xoshiro(20260912)
                V = virtual_space(symmetry)
                Q = ObservableLocalFixtures.PerformanceFixtures.charge_space(symmetry)
                X = auxiliary_space(symmetry)
                roles = (:neutral, charged ? :bra : :neutral, charged ? :ket : :neutral, :neutral)
                left = LocalContractions.ObservableEnv4(map(r -> environment_fixture(rng, :left, r, :D, V, V, Q, X), roles)...)
                right = LocalContractions.ObservableEnv4(map(r -> environment_fixture(rng, :right, r, :C, V, V, Q, X), roles)...)
                pairs = ((1,4), (4,1), (2,3), (3,2))
                terms = map(pairs) do (i,j)
                    LocalContractions._join_compatible(getfield(left,i), getfield(right,j))
                end
                @test all(isfinite, terms)
                @test all(x -> abs(x)>0, terms)
                @test isapprox(LocalContractions.observable_leaf(left,right), sum(terms); atol=1e-11, rtol=1e-9)
                for ((i,j), term) in zip(pairs, terms)
                    isolated_left = deepcopy(left)
                    isolated_right = deepcopy(right)
                    for k in 1:4
                        k!=i && rmul!(getfield(isolated_left,k).A,0)
                        k!=j && rmul!(getfield(isolated_right,k).A,0)
                    end
                    @test isapprox(LocalContractions.observable_leaf(isolated_left,isolated_right), term; atol=1e-11, rtol=1e-9)
                end
            end
        end
    finally
        BLAS.set_num_threads(previous_blas)
        FiniteMPS.set_num_threads_mul(previous_mul)
    end
end
