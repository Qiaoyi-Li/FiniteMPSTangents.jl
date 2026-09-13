using Test
using Random
using BenchmarkTools
using FiniteMPSTangents
using FiniteMPSTangents.FiniteMPS

include("../harness.jl")
using .BenchmarkHarness
include("../fixtures.jl")
include("../mul_stage_cases.jl")
include("mul_stage_checks.jl")
include("reduced_state_fixtures.jl")

function stage_input_snapshot(value)
    isnothing(value) && return nothing
    value isa AbstractTensorMap && return copy(value)
    value isa Union{Tuple,AbstractVector} && return map(stage_input_snapshot,value)
    value isa SparseMPOTensor && return [stage_input_snapshot(value[i,j]) for i in axes(value,1), j in axes(value,2)]
    value isa IdentityOperator && return (;strength=value.strength[])
    value isa LocalOperator && return (;tensor=copy(value.A),strength=value.strength[])
    return copy(value.A)
end

@testset "Sparse multiplication stages" begin
    @testset "Registration and thread-independent workload identities" begin
        reference = mul_stage_cases(ExecutionConfig(1))
        @test allunique(case.case_id for case in reference)
        for threads in (1,2,4)
            cases = mul_stage_cases(ExecutionConfig(threads))
            @test [case.case_id for case in cases] == [case.case_id for case in reference]
            for (case,expected) in zip(cases,reference)
                @test case.seed == expected.seed
                @test Dict(k=>v for (k,v) in case.parameters if k!="execution") ==
                      Dict(k=>v for (k,v) in expected.parameters if k!="execution")
                @test case.parameters["execution"]["julia_threads"] == threads
            end
            for family in ("SA","RA","RC"), symmetry in ("NoSym","U1","SU2","U1xSU2"),
                rank in (3,4), charged in (false,true)
                selected = filter(case->case.parameters["family"]==family && case.parameters["symmetry"]==symmetry &&
                    case.parameters["base_rank"]==rank && case.parameters["center_rank"]==rank+charged,cases)
                directions = family=="SA" ? (nothing,) : ("right","left")
                for direction in directions
                    oriented = filter(case->case.parameters["direction"]==direction,selected)
                    @test sort([case.parameters["nominal_D"] for case in oriented]) == collect(dimensions(symmetry))
                    @test all(case.parameters["local_site"]==9 for case in oriented)
                end
            end
        end
    end

    @testset "Aggregate stages against serial component sums" begin
        config = ExecutionConfig(Threads.nthreads(:default))
        previous = configure_threads(config)
        try
            for symmetry in ("NoSym","U1","SU2","U1xSU2"), rank in (3,4), charged in (false,true)
                @testset "$symmetry base rank $rank, center rank $(rank+charged)" begin
                    fixture = small_chain_fixture(symmetry,rank,charged)
                    cache = TangentEnvironment(fixture.base,fixture.H;disk=false)
                    try
                        for (stage,direction) in (("effective_site_action","right"),
                            ("tangent_recursion","right"),("tangent_recursion","left"),
                            ("center_reduction","right"),("center_reduction","left"))
                            site = 9
                            prepared = _ms_prepare(fixture,cache,stage,direction,site)
                            snapshot = stage_input_snapshot(prepared.arguments)
                            actual = prepared.operation()
                            @test check_mul_stage(prepared,stage,direction,fixture.tangent.B[site];actual)
                            @test stage_input_snapshot(prepared.arguments) == snapshot
                            @test FiniteMPS.get_num_threads_action() == config.julia_threads
                            if stage!="tangent_recursion"
                                @test numind(_ms_tensor(actual)) == rank+charged
                                @test space(_ms_tensor(actual)) == space(fixture.tangent.B[site].A)
                            end
                            @test prepared.metadata["local_center_rank"] == rank+charged
                            relative_center_norm = norm(fixture.tangent.B[site])/max(norm(fixture.tangent),eps(Float64))
                            @test isfinite(relative_center_norm) && relative_center_norm > 1e-10
                            if stage=="tangent_recursion"
                                @test prepared.metadata["output_environment_channels"]==length(actual[1])
                                @test prepared.metadata["active_output_channels"]==_ms_active(actual[1])
                                @test prepared.metadata["partial_environment_channels"]==length(actual[2])
                                @test prepared.metadata["active_partial_channels"]==_ms_active(actual[2])
                            end
                            @test prepared.metadata["local_mpo_nonempty_transitions"] == count(!isnothing,fixture.H[site])
                            @test prepared.metadata["reachable_transition_count"] > 1
                            if stage=="center_reduction"
                                @test prepared.metadata["active_reduction_channels"] > 1
                            end
                        end
                    finally
                        finalize(cache)
                    end
                end
            end
        finally
            restore_threads(previous)
        end
    end

    @testset "Builder cleanup restores thread settings" begin
        config = ExecutionConfig(Threads.nthreads(:default))
        previous = configure_threads(config)
        try
            FiniteMPS.set_num_threads_action(1)
            built = _ms_case(config,"RA","NoSym",first(dimensions("NoSym")),3,false,"right").build(Xoshiro(20260912))
            try
                @test FiniteMPS.get_num_threads_action() == config.julia_threads
                @test !haskey(built,:sanity)
                @test built.parameters["output_environment_channels"] > 1
                @test built.parameters["active_partial_channels"] > 1
            finally
                built.cleanup()
            end
            @test FiniteMPS.get_num_threads_action() == 1
            @test FiniteMPS.get_num_threads_mul() == 1
        finally
            restore_threads(previous)
        end
    end
end
