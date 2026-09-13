using Test
using BenchmarkTools
using Random
using LinearAlgebra
using JSON3

include("../harness.jl")
using .BenchmarkHarness
include("test_metadata.jl")

function sum_case(id="test/sum-v1"; kwargs...)
    BenchmarkCase(id, rng -> begin
        data = rand(rng, 256)
        (; benchmark=(@benchmarkable sum($data)))
    end; seconds=0.2, samples=5, kwargs...)
end

@testset "Benchmark harness" begin
    @testset "Case registration validation" begin
        first_case = sum_case()
        second_case = sum_case("test/other-v1")
        cases = [first_case, second_case]
        @test BenchmarkHarness.validate_cases(cases) == cases
        @test_throws ArgumentError BenchmarkHarness.validate_cases([first_case, first_case])
        @test_throws ArgumentError BenchmarkHarness.validate_cases(BenchmarkCase[])
        @test_throws ArgumentError BenchmarkHarness.validate_cases([1])
        @test_throws ArgumentError BenchmarkCase("bad id", identity)
        @test_throws ArgumentError BenchmarkCase("bad", identity; mutates=true, evals=2)
        @test_throws ArgumentError BenchmarkCase("bad", identity; seconds=NaN)
        @test_throws ArgumentError BenchmarkCase("bad", identity; samples=1)
        @test_throws ArgumentError BenchmarkCase("bad", identity; parameters=Dict("opaque" => identity))
        @test_throws ArgumentError BenchmarkCase("bad", identity; parameters=Dict("bad" => Inf))
        @test_throws ArgumentError BenchmarkCase("bad", identity; seed=-1)
        @test_throws ArgumentError BenchmarkCase("bad", identity; warmup_group=" ")
        @test_throws ArgumentError BenchmarkCase("bad", identity; warmup_size=-1)
    end

    @testset "Default collection includes all registered cases" begin
        results = measure_suite([sum_case("default/first"),sum_case("default/second")];progress=devnull)
        @test Set(r["case_id"] for r in results)==Set(("default/first","default/second"))
    end

    @testset "Deterministic builders, budgets and real trials" begin
        observed = Float64[]
        make_seeded(id) = BenchmarkCase(id, rng -> begin
            data = rand(rng, 256)
            push!(observed, first(data))
            (; benchmark=(@benchmarkable sum($data) evals=99 samples=999 seconds=9))
        end; parameters=Dict("length" => 256), seed=42, seconds=0.2, samples=5, evals=2)
        first_case = make_seeded("test/seed-v1")
        second_case = make_seeded("test/seed-v2")
        result = measure_suite([first_case, second_case]; progress=devnull)
        @test length(observed) == 2
        @test all(==(first(rand(Xoshiro(42), 256))), observed)
        @test length(result) == 2
        @test Set(r["case_id"] for r in result) == Set((first_case.case_id, second_case.case_id))
        case = only(filter(r -> r["case_id"] == first_case.case_id, result))
        @test case["parameters"] == Dict("length" => 256)
        @test case["measurement_parameters"]["evals"] == 2
        @test case["measurement_parameters"]["samples_budget"] == 5
        @test case["measurement_parameters"]["seconds_budget"] == 0.2
        @test 2 <= case["samples"] <= 5
        @test isfinite(case["median_time_ns"]) && case["median_time_ns"] >= 0
        @test case["allocated_bytes"] >= 0 && case["allocations"] >= 0
    end

    @testset "One warmup and per-sample mutation reset" begin
        seen = Int[]
        function change!(data)
            length(data) == 3 || error("input was not reset between samples")
            push!(seen, length(data))
            push!(data, 4)
        end
        reset_case = BenchmarkCase("test/mutating-v1", _ -> begin
            initial = [1, 2, 3]
            (; benchmark=(@benchmarkable $change!(data) setup=(data=copy($initial))))
        end; mutates=true, samples=5, seconds=0.2)
        timings = Dict{String,Any}[]
        result = measure_suite([reset_case]; progress=devnull,timings)
        @test length(seen) == only(result)["samples"] + 1 # warmup plus actual samples
        @test all(==(3), seen)
        @test only(result)["measurement_parameters"]["evals"] == 1
        @test !only(result)["measurement_parameters"]["gctrial"]
        @test only(result)["measurement_parameters"]["gc_after_case"]
        @test !haskey(only(result)["measurement_parameters"],"gc_before_trial")
        @test only(timings)["case_id"]==reset_case.case_id
        @test all(only(timings)[key]>=0 for key in ("preparation_seconds","warmup_seconds",
            "garbage_collection_seconds","sampling_seconds","cleanup_seconds","total_seconds"))
    end

    @testset "Smallest input warmup is local to each suite invocation" begin
        calls = Tuple{String,Int,Int}[]
        builds = Tuple{String,Int}[]
        function operation!(kind,size,data)
            push!(calls,(kind,size,length(data)))
            push!(data,1)
            return sum(data)
        end
        make_case(kind,size) = BenchmarkCase("$kind/$size", _ -> begin
            push!(builds,(kind,size))
            initial = zeros(Int,size)
            (;benchmark=(@benchmarkable $operation!($kind,$size,data) setup=(data=copy($initial))))
        end;warmup_group=kind,warmup_size=size,mutates=true,samples=3,seconds=0.3)
        cases = [make_case("left",12),make_case("right",8),make_case("left",4),
                 make_case("left",8),make_case("right",4)]
        for _ in 1:2
            empty!(calls); empty!(builds)
            timings = Dict{String,Any}[]
            results = measure_suite(cases;progress=devnull,timings)
            @test builds==[("left",4),("left",12),("right",4),("right",8),("left",8)]
            @test length(results)==length(cases)
            @test count(r->r["measurement_parameters"]["warmup_samples"]==1,results)==2
            for result in results
                kind,size_text = split(result["case_id"],"/")
                size = parse(Int,size_text)
                @test count(call->call[1:2]==(kind,size),calls)==result["samples"]+Int(size==4)
                @test result["measurement_parameters"]["warmup_case_id"]=="$kind/4"
                @test result["measurement_parameters"]["warmup_samples"]==Int(size==4)
                @test all(call[3]==size for call in calls if call[1:2]==(kind,size))
                timing = only(t for t in timings if t["case_id"]==result["case_id"])
                size==4 || @test timing["warmup_seconds"]==0.0
            end
        end
        # Every registered case runs, so the warmup representative is the smallest
        # case in the group across the whole invocation, not a filtered subset.
        mixed = [make_case("mixed",2),make_case("mixed",4)]
        empty!(builds)
        results = measure_suite(mixed;progress=devnull)
        @test builds==[("mixed",2),("mixed",4)]
        @test Set(r["case_id"] for r in results)==Set(("mixed/2","mixed/4"))
        @test all(r["measurement_parameters"]["warmup_case_id"]=="mixed/2" for r in results)
        @test only(r for r in results if r["case_id"]=="mixed/2")["measurement_parameters"]["warmup_samples"]==1
        @test only(r for r in results if r["case_id"]=="mixed/4")["measurement_parameters"]["warmup_samples"]==0
    end

    @testset "Execution configuration and configuration-aware suites" begin
        @test ExecutionConfig(1).julia_threads == 1
        @test ExecutionConfig(4).gc_threads == 1
        @test_throws ArgumentError ExecutionConfig(3)
        @test_throws ArgumentError ExecutionConfig(2; blas_threads=2)
        @test_throws ArgumentError ExecutionConfig(2; gc_threads=2)
        original_blas = BLAS.get_num_threads()
        try
            BLAS.set_num_threads(1)
            @test validate_execution(ExecutionConfig()) isa ExecutionConfig
            @test_throws ErrorException validate_execution(ExecutionConfig(Threads.nthreads(:default)==1 ? 2 : 1))
        finally
            BLAS.set_num_threads(original_blas)
        end
        mktempdir() do dir
            path = joinpath(dir,"suite.jl")
            write(path,"benchmark_suite(config) = [BenchmarkCase(\"config/\" * string(config.julia_threads), identity)]\n")
            @test only(load_suite(path,ExecutionConfig(4))).case_id == "config/4"
            write(path,"benchmark_suite() = BenchmarkCase[]\n")
            @test isempty(load_suite(path,ExecutionConfig(1)))
        end
    end

    @testset "Per-case lifecycle and constructed metadata" begin
        events = String[]
        make_case(id) = BenchmarkCase(id, _ -> begin
            push!(events,"build/$id")
            data = [1,2,3]
            finalizer(_->push!(events,"gc/$id"),data)
            (; benchmark=(@benchmarkable sum($data)),
               parameters=(actual_D=3,bond_schedule=[Dict("full_dimension"=>3)]),
               cleanup=()->push!(events,"cleanup/$id"))
        end; parameters=(nominal_D=4,),seconds=0.2,samples=5)
        result=measure_suite([make_case("a"),make_case("b")];progress=devnull,samples=3,seconds=0.3)
        @test events == ["build/a","cleanup/a","gc/a","build/b","cleanup/b","gc/b"]
        @test first(result)["parameters"]["actual_D"] == 3
        @test first(result)["parameters"]["nominal_D"] == 4
        @test first(result)["measurement_parameters"]["samples_budget"] == 3
        @test first(result)["measurement_parameters"]["seconds_budget"] == 0.3
        @test_throws ArgumentError measure_suite([make_case("a")];samples=1,progress=devnull)
        @test_throws ArgumentError measure_suite([make_case("a")];seconds=Inf,progress=devnull)
        builds=Ref(0); cleanups=Ref(0)
        single_build=BenchmarkCase("single-build", _ -> begin
            builds[]+=1
            (;benchmark=(@benchmarkable sum([1,2])),
              parameters=(actual_D=builds[],),cleanup=()->(cleanups[]+=1))
        end;samples=3,seconds=0.2)
        @test only(measure_suite([single_build];progress=devnull))["parameters"]["actual_D"]==1
        @test builds[]==cleanups[]==1
        conflicting=BenchmarkCase("conflicting", _ ->
            (;benchmark=(@benchmarkable sum([1,2])),
              parameters=(actual_D=3,),cleanup=()->(cleanups[]+=1));parameters=(actual_D=3,))
        @test_throws ArgumentError measure_suite([conflicting];progress=devnull)
        @test cleanups[] == 2
        broken=BenchmarkCase("broken", _ ->
            (;benchmark=(@benchmarkable error("timed operation failed")),
              cleanup=()->(cleanups[]+=1)))
        @test_throws Exception measure_suite([broken];progress=devnull)
        @test cleanups[] == 3
        malformed=BenchmarkCase("malformed", _ ->
            (;benchmark=nothing,cleanup=()->(cleanups[]+=1)))
        @test_throws ArgumentError measure_suite([malformed];progress=devnull)
        @test cleanups[] == 4
    end

    @testset "Failures propagate without silently omitting cases" begin
        checks = Ref(0)
        unsupported_check = BenchmarkCase("test/unsupported-check", _ ->
            (; benchmark=(@benchmarkable sum([1, 2])), sanity=() -> (checks[]+=1;true)))
        @test_throws ArgumentError measure_suite([unsupported_check]; progress=devnull)
        @test checks[]==0
        @test_throws ArgumentError measure_suite([BenchmarkCase("test/bad", _ -> nothing)]; progress=devnull)
    end

    @testset "Suite loading and all-or-nothing output" begin
        # Infrastructure tests remain valid as package workloads are registered.
        @test BenchmarkHarness.validate_cases(load_suite(joinpath(@__DIR__, "..", "benchmarks.jl"))) isa AbstractVector
        withenv("GITHUB_ACTIONS" => "false") do
          mktempdir() do temp
            suite = joinpath(temp, "suite.jl")
            write(suite, "benchmark_suite() = BenchmarkCase[]\n")
            output = joinpath(temp, "output")
            @test run_benchmarks(; suite, output, package_version="0.1.0") === nothing
            @test JSON3.read(read(joinpath(output, "run-status.json")))["status"] == "empty"
            @test !isfile(joinpath(output, "report.json"))
            @test occursin("No benchmark cases configured", read(joinpath(output, "report.md"), String))
            # A builder-defined global is resolved in the suite module, including
            # code split into ordinary relative include files.
            write(joinpath(temp, "fixture.jl"), "make_data(rng) = rand(rng, 128)\n")
            write(suite, raw"""
                using LinearAlgebra
                BLAS.set_num_threads(3) # package imports may initialize a provider
                include("fixture.jl")
                function benchmark_suite()
                    [BenchmarkCase("test/external/d=128+v1", rng -> begin
                        data = make_data(rng)
                        (; benchmark=(@benchmarkable sum($data)))
                    end; seconds=0.2, samples=5, description="Sum a fixed random input")]
                end
                """)
            @test_throws ArgumentError run_benchmarks(; suite, output)
            report = run_benchmarks(; suite, output, package_version="0.1.0", packages=[BenchmarkTools])
            @test report["environment"]["runtime"]["julia_threads_default"] == 2
            @test report["environment"]["runtime"]["blas_threads"] == 1
            @test report["environment"]["package_versions"]["BenchmarkTools"] == string(pkgversion(BenchmarkTools))
            @test length(report["execution_timings"]["cases"])==1
            @test report["execution_timings"]["suite_seconds"]>=0
            @test JSON3.read(read(joinpath(output, "run-status.json")))["status"] == "measured"
            @test isfile(joinpath(output, "report.json"))
            saved_report = JSON3.read(read(joinpath(output, "report.json")))
            @test only(saved_report["cases"])["case_id"] == "test/external/d=128+v1"
            @test occursin("Sum a fixed random input", read(joinpath(output, "report.md"), String))
            @test report["source"]["working_tree_dirty"]
            @test report["source"]["suite_origin"] == "external"
            @test isnothing(report["source"]["suite_path"])
            @test occursin("Processor model", BenchmarkHarness.PerformanceReports.render_report(report))
            # A failed rerun must remove the preceding success artifacts.
            write(suite, "benchmark_suite() = error(\"bad suite\")\n")
            @test_throws ErrorException run_benchmarks(; suite, output, package_version="0.1.0")
            @test !isfile(joinpath(output, "report.json"))
            @test !isfile(joinpath(output, "report.md"))
            @test !isfile(joinpath(output, "run-status.json"))
            @test_throws ErrorException run_benchmarks(; suite, output, expected_sha=repeat("0", 40))
            write(suite, "nothing\n")
            @test_throws ArgumentError load_suite(suite)
          end
        end
    end
end
