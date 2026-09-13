using Test
using Random
using BenchmarkTools
using LinearAlgebra
using FiniteMPSTangents
using FiniteMPSTangents.FiniteMPS

include("../harness.jl")
using .BenchmarkHarness
include("../fixtures.jl")
include("../observable_cases.jl")
include("observable_checks.jl")
include("reduced_state_fixtures.jl")

@testset "Complete observable correctness is manual" begin
    config = ExecutionConfig(Threads.nthreads(:default))
    previous_blas = BLAS.get_num_threads()
    previous = configure_threads(config)
    try
        for (symmetry,spinless,purified_open) in (("NoSym",false,false),("U1",false,false),
            ("SU2",false,false),("U1xSU2",false,false),("U1",true,false),("SU2",false,true))
            rank = symmetry=="U1xSU2" || spinless || purified_open ? 4 : 3
            classes = purified_open ? ("onsite",) : symmetry=="U1xSU2" ?
                ("onsite","two-site","multisite","multisite-extra","mixed") :
                ("onsite","two-site","multisite","mixed")
            for klass in classes
                @testset "$symmetry spinless=$spinless base rank $rank $klass" begin
                    charged = symmetry=="U1xSU2" || spinless || (symmetry=="SU2" && klass=="onsite")
                    fixture = small_chain_fixture(symmetry,rank,charged;spinless)
                    prepared = _oc_prepare(fixture,symmetry,klass;spinless)
                    @test check_complete_observables(prepared,config,symmetry,klass;spinless)
                    @test prepared.parameters["observable_count"]>0
                    bra_rank = symmetry=="SU2" && klass=="onsite" ? rank : rank+charged
                    @test all(==(bra_rank),prepared.parameters["actual_bra_center_ranks"])
                    @test all(==(rank+charged),prepared.parameters["actual_ket_center_ranks"])
                end
            end
        end
        built = first(observable_cases(config)).build(Xoshiro(20260912))
        @test !haskey(built,:sanity)
        @test built.parameters["tree_reset"]=="deepcopy of unmerged template per sample"
    finally
        restore_threads(previous)
        BLAS.set_num_threads(previous_blas)
    end
end
