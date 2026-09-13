using Test
using Random
using BenchmarkTools
using FiniteMPSTangents
using FiniteMPSTangents.FiniteMPS
include("../harness.jl")
using .BenchmarkHarness
include("../fixtures.jl")
include("../chain_cases.jl")
include("chain_case_checks.jl")

@testset "Chain fixture builder contract" begin
    config = ExecutionConfig(Threads.nthreads(:default))
    case = _inner_case(config,"NoSym",first(dimensions("NoSym")),3,false)
    previous = FiniteMPS.get_num_threads_action()
    built = BenchmarkHarness.build_case(case)
    try
        @test built.benchmark isa BenchmarkTools.Benchmark
        @test !haskey(built,:sanity)
        @test built.parameters["stored_tensor_entries_per_vector"]>0
        parameters = BenchmarkHarness.built_parameters(case,built)
        @test parameters["actual_D"]<=parameters["nominal_D"]
        @test parameters["execution"]["julia_threads"]==config.julia_threads
    finally
        BenchmarkHarness.cleanup_fixture(built)
    end
    @test FiniteMPS.get_num_threads_action()==previous
end

@testset "Manual whole-chain workload correctness" begin
    config = ExecutionConfig(Threads.nthreads(:default))
    cases = chain_cases(config)
    @test count(c->c.parameters["family"]=="IP",cases)==24
    # Every registered layout uses its smallest prescribed dimension. Frozen
    # sector schedules at all three dimensions are covered by test_suite.jl.
    selected = filter(c->c.parameters["nominal_D"]==first(dimensions(c.parameters["symmetry"])),cases)
    @test Set(c.parameters["family"] for c in selected)==Set(("CM","OR","EC","BC","IP"))
    for case in selected
        p = case.parameters
        @testset "$(p["family"]) $(p["symmetry"]) rank $(p["base_rank"])/$(p["center_rank"])" begin
            previous = FiniteMPS.get_num_threads_action()
            check_chain_case(case,config)
            @test FiniteMPS.get_num_threads_action()==previous
        end
    end
end

@testset "Manual spinless fixture correctness" begin
    config = ExecutionConfig(Threads.nthreads(:default))
    previous = configure_threads(config)
    try
        D = first(dimensions("U1"))
        fixture = build_state(Xoshiro(20260912),"U1",D,4,true;spinless=true)
        check_chain_state(fixture,"U1",D,4;spinless=true)
    finally
        restore_threads(previous)
    end
end
