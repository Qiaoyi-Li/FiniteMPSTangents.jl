using Test
using Random
using LinearAlgebra
using FiniteMPSTangents
using FiniteMPSTangents.FiniteMPS
include("../harness.jl")
using .BenchmarkHarness
include("../fixtures.jl")
include("../environment_cases.jl")
include("environment_checks.jl")

@testset "Sparse environment-vector coverage" begin
    suites = [environment_cases(ExecutionConfig(n)) for n in (1,2,4)]
    reference = first(suites)
    expected = Set((sym,rank,direction,D) for sym in ("NoSym","U1","SU2","U1xSU2")
                   for rank in (3,4) for direction in ("right","left") for D in dimensions(sym))
    @test allunique(c.case_id for c in reference)
    for (n,cases) in zip((1,2,4),suites)
        @test Set((c.parameters["symmetry"],c.parameters["base_rank"],c.parameters["direction"],c.parameters["nominal_D"])
                  for c in cases)==expected
        @test [c.case_id for c in cases]==[c.case_id for c in reference]
        for (case,baseline) in zip(cases,reference)
            p = case.parameters
            @test case.evals==1 && !case.mutates
            @test case.seed==baseline.seed
            @test Dict(k=>v for (k,v) in p if k!="execution")==
                  Dict(k=>v for (k,v) in baseline.parameters if k!="execution")
            @test p["execution"]["action_threads"]==p["execution"]["julia_threads"]==n
            @test p["base_rank"]==p["center_rank"]
            @test p["local_site"]==(p["direction"]=="right" ? 8 : 9)
            @test p["interaction_distances"]==[1,2]
            @test startswith(case.case_id,"basic/environment-step/") && endswith(case.case_id,"/v1")
        end
    end
end

@testset "Real central environment-vector propagation" begin
    config = ExecutionConfig(Threads.nthreads(:default))
    selected = filter(c->c.parameters["nominal_D"]==first(dimensions(c.parameters["symmetry"])),environment_cases(config))
    for case in selected
        p = case.parameters
        @testset "$(p["symmetry"]) base $(p["base_rank"]) $(p["direction"])" begin
            println("Checking ",case.case_id)
            flush(stdout)
            previous = (action=FiniteMPS.get_num_threads_action(),mul=FiniteMPS.get_num_threads_mul(),
                        svd=FiniteMPS.get_num_threads_svd(),eig=FiniteMPS.get_num_threads_eig(),blas=BLAS.get_num_threads())
            configure_threads(config)
            cache = nothing
            try
                state = build_state(Xoshiro(case.seed),p["symmetry"],p["nominal_D"],p["base_rank"],false)
                cache = TangentEnvironment(state.base,state.H;disk=false)
                prepared = _ep_prepare(state,cache,p["direction"],p["local_site"])
                extra = merge(copy(state.parameters),prepared.metadata)
                delete!(extra,"charge_space")
                merged = merge(p,extra)
                expected_output = p["direction"]=="right" ?
                    FiniteMPSTangents._getEl(cache,p["local_site"]+1) :
                    FiniteMPSTangents._getEr(cache,p["local_site"]-1)
                @test merged["actual_D"]==merged["output_bond_dimension"]<=p["nominal_D"]
                input_cut = p["direction"]=="right" ? 7 : 9
                @test extra["input_bond_dimension"]==extra["bond_schedule"][input_cut+1]["full_dimension"]
                @test extra["active_input_channels"]>1 && extra["active_output_channels"]>1
                @test extra["active_input_channels"]<=extra["input_environment_channels"]
                @test extra["active_output_channels"]<=extra["output_environment_channels"]
                @test 1<extra["reachable_transition_count"]<=extra["local_mpo_nonempty_transitions"]
                @test extra["identity_transition_count"]>0 && extra["local_operator_transition_count"]>0
                @test extra["identity_transition_count"]+extra["local_operator_transition_count"]==extra["reachable_transition_count"]
                @test !haskey(extra,"charge_space")
                # Manual checks compare cached/serial references and input preservation.
                @test check_environment_step(prepared,expected_output;
                    expected_rank=p["base_rank"],expected_output_dimension=state.parameters["actual_D"])
                @test FiniteMPS.get_num_threads_action()==config.julia_threads
                FiniteMPS.set_num_threads_action(1)
                @test check_environment_step(prepared,expected_output;
                    expected_rank=p["base_rank"],expected_output_dimension=state.parameters["actual_D"])
                @test FiniteMPS.get_num_threads_action()==1
                println("  channels ",extra["active_input_channels"]," -> ",extra["active_output_channels"],
                        "; transitions ",extra["reachable_transition_count"],"; dimensions ",
                        extra["input_bond_dimension"]," -> ",extra["output_bond_dimension"])
            finally
                isnothing(cache) || finalize(cache)
                restore_threads(previous)
                BLAS.set_num_threads(previous.blas)
            end
            @test (action=FiniteMPS.get_num_threads_action(),mul=FiniteMPS.get_num_threads_mul(),
                   svd=FiniteMPS.get_num_threads_svd(),eig=FiniteMPS.get_num_threads_eig(),blas=BLAS.get_num_threads())==previous
        end
        GC.gc()
    end
end

@testset "Environment builder cleanup" begin
    config = ExecutionConfig(Threads.nthreads(:default))
    previous = (action=FiniteMPS.get_num_threads_action(),mul=FiniteMPS.get_num_threads_mul(),
                svd=FiniteMPS.get_num_threads_svd(),eig=FiniteMPS.get_num_threads_eig(),blas=BLAS.get_num_threads())
    built = first(environment_cases(config)).build(Xoshiro(20260912))
    try
        @test !haskey(built,:sanity)
        @test !haskey(built.parameters,"charge_space")
        @test built.parameters["active_output_channels"]>1
    finally
        built.cleanup()
    end
    @test (action=FiniteMPS.get_num_threads_action(),mul=FiniteMPS.get_num_threads_mul(),
           svd=FiniteMPS.get_num_threads_svd(),eig=FiniteMPS.get_num_threads_eig(),blas=BLAS.get_num_threads())==previous
end
