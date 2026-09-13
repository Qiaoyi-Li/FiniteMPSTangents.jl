using Test
using JSON3
using LinearAlgebra

if !isdefined(@__MODULE__, :PerformanceMetadata)
    include("../metadata.jl")
end
using .PerformanceMetadata

@testset "Performance metadata" begin
    @testset "CPU list parsing" begin
        @test parse_cpu_list("0-3,8,10-11") == [0, 1, 2, 3, 8, 10, 11]
        @test length(parse_cpu_list("0-3,8,10-11")) == 7
        @test parse_cpu_list("8,0-2,1,8") == [0, 1, 2, 8]
        @test parse_cpu_list(" 0-0, 2 \n") == [0, 2]
        for invalid in ("", " ", "-1", "2-1", "a", "1-", "0,,2", "0,", "1-2-3", "92233720368547758080")
            @test_throws ArgumentError parse_cpu_list(invalid)
        end
    end

    @testset "Measuring process and serialization" begin
        # Read thread counts from the initialized runtime, not requested ENV values.
        withenv("JULIA_NUM_THREADS" => "999", "OPENBLAS_NUM_THREADS" => "999",
                "RUNNER_ENVIRONMENT" => nothing, "ImageVersion" => nothing, "GITHUB_ACTIONS" => nothing,
                "PERFORMANCE_METADATA_PRIVATE_TEST" => "must-not-be-published") do
            environment = collect_environment(; runner_label=nothing, packages=[LinearAlgebra])
            runtime = environment["runtime"]
            @test runtime["julia_version"] == string(VERSION)
            @test runtime["julia_threads_default"] == Threads.nthreads(:default)
            @test runtime["julia_threads_interactive"] == Threads.nthreads(:interactive)
            @test runtime["julia_gc_threads"] == Threads.ngcthreads()
            @test runtime["blas_threads"] == BLAS.get_num_threads()
            @test runtime["blas_configuration"] == sprint(show, BLAS.get_config())
            @test environment["package_versions"]["LinearAlgebra"] == string(Base.pkgversion(LinearAlgebra))
            @test environment["cpu"]["logical_cpus_visible"] == length(Sys.cpu_info())
            @test environment["system"]["memory_total_bytes_visible"] == Sys.total_memory()
            @test environment["runner"]["environment"] == "local"
            @test isnothing(environment["runner"]["label"])
            @test isnothing(environment["runner"]["image_version"])

            affinity = environment["cpu"]["affinity_cpu_list"]
            affinity_count = environment["cpu"]["affinity_cpu_count"]
            @test isnothing(affinity) ? isnothing(affinity_count) : affinity_count == length(parse_cpu_list(affinity))
            serialized = JSON3.write(environment)
            restored = JSON3.read(serialized, Dict{String,Any})
            @test restored == environment
            @test !occursin("must-not-be-published", serialized)
            @test !occursin("PERFORMANCE_METADATA_PRIVATE_TEST", serialized)

            # Optional hardware can remain absent even in a successful report.
            environment["cpu"]["physical_cores_visible"] = nothing
            environment["cpu"]["affinity_cpu_list"] = nothing
            environment["cpu"]["affinity_cpu_count"] = nothing
            optional_restored = JSON3.read(JSON3.write(environment), Dict{String,Any})
            @test isnothing(optional_restored["cpu"]["physical_cores_visible"])
            @test isnothing(optional_restored["cpu"]["affinity_cpu_count"])
        end
        withenv("RUNNER_ENVIRONMENT" => "", "ImageVersion" => "", "GITHUB_ACTIONS" => nothing) do
            runner = collect_environment(; runner_label="")["runner"]
            @test runner == Dict("label" => nothing, "environment" => "local", "image_version" => nothing)
        end
        # In CI an unset RUNNER_ENVIRONMENT must be JSON null, never a claim of "local".
        withenv("RUNNER_ENVIRONMENT" => nothing, "GITHUB_ACTIONS" => "true") do
            runner = collect_environment(; runner_label=nothing)["runner"]
            @test runner["environment"] === nothing
        end
    end
end
