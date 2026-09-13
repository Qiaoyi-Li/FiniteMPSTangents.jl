using Test
using JSON3
include(joinpath(@__DIR__, "..", "collect.jl"))
using .PerformanceCollectionRunner
include(joinpath(@__DIR__, "..", "ci", "check_run.jl"))

readjson(path)=JSON3.read(read(path,String),Dict{String,Any})
writejson(path,value)=PerformanceCollectionRunner.write_json(path,value)
argument(command,key)=command.exec[findfirst(==(key),command.exec)+1]

@testset "Sequential independent process collection" begin
    command=configuration_command(4,"/private/tmp/example-result";samples=3,seconds=60)
    @test "--threads=4" in command.exec
    @test "--gcthreads=1" in command.exec
    @test argument(command,"--julia-threads")=="4"
    @test argument(command,"--samples")=="3"
    withenv("GITHUB_ACTIONS"=>"false") do
      mktempdir() do temporary
        suite=joinpath(temporary,"suite.jl")
        write(suite,raw"""
        function benchmark_suite(config)
            [BenchmarkCase("test/collection-sum/D$D/v1", rng -> begin
                data=rand(rng,D)
                (;benchmark=(@benchmarkable sum($data)))
            end; parameters=(section="basic",family="CN",symmetry="NoSym",
                 configuration="rank3",nominal_D=D,actual_D=D,base_rank=3,center_rank=3,
                 preset_id=nothing,bond_schedule=[Dict("cut"=>1,"full_dimension"=>D)],
                 execution=Dict("julia_threads"=>config.julia_threads,"blas_threads"=>config.blas_threads,"gc_threads"=>config.gc_threads)),
                 warmup_group="collection-sum",warmup_size=D,samples=5,seconds=0.5) for D in (4,2,8)]
        end
        """)
        output=joinpath(temporary,"result")
        order=Int[]
        runner=command->begin
            push!(order,parse(Int,argument(command,"--julia-threads")))
            run(command)
        end
        rendered=Tuple{String,String,Int}[]
        renderer=(path,destination)->begin
            push!(rendered,(path,destination,getpid()))
            PerformanceCollectionRunner.PerformanceCollections.build_collection(path;output=destination)
        end
        bundle=collect_reports(;output,suite,samples=3,seconds=0.3,
                               run_child=runner,build_site=renderer,progress=devnull)
        @test order==[1,2,4]
        @test rendered==[(joinpath(output,"collection.json"),output,getpid())]
        @test isfile(joinpath(output,"collection.json"))
        @test isfile(joinpath(output,"index.html"))
        @test !isfile(joinpath(output,"report.json"))
        @test readjson(joinpath(output,"run-status.json"))==Dict("status"=>"measured","case_count"=>3,"configuration_count"=>3)
        @test PerformanceCompletion.check_run(output)
        @test [r["environment"]["runtime"]["julia_threads_default"] for r in bundle.reports]==[1,2,4]
        @test all(r["environment"]["runtime"]["julia_threads_interactive"]==0 for r in bundle.reports)
        @test all(r["environment"]["runtime"]["julia_gc_threads"]==1 for r in bundle.reports)
        @test all(r["environment"]["runtime"]["blas_threads"]==1 for r in bundle.reports)
        @test all(c["measurement_parameters"]["samples_budget"]==3 for r in bundle.reports for c in r["cases"])
        @test all(c["measurement_parameters"]["seconds_budget"]==0.3 for r in bundle.reports for c in r["cases"])
        @test all([c["parameters"]["nominal_D"] for c in r["cases"]]==[2,4,8] for r in bundle.reports)
        @test all([c["measurement_parameters"]["warmup_samples"] for c in r["cases"]]==[1,0,0] for r in bundle.reports)
        # Preserve actual measured fixture reports solely for offline failure tests.
        templates=joinpath(temporary,"templates")
        cp(joinpath(output,"configurations"),templates)
        function copy_child(command)
            n=parse(Int,argument(command,"--julia-threads"))
            directory=argument(command,"--output")
            mkpath(dirname(directory))
            cp(joinpath(templates,"julia-$n-blas-1"),directory)
            return nothing
        end
        collect_reports(;output,suite,run_child=copy_child,progress=devnull)
        @test isfile(joinpath(output,"index.html"))
        @test isfile(joinpath(output,"report.md"))
        @test PerformanceCompletion.check_run(output)
        failing=command->begin
            argument(command,"--julia-threads")=="2" && error("injected subprocess failure")
            copy_child(command)
        end
        @test_throws ErrorException collect_reports(;output,suite,run_child=failing,progress=devnull)
        @test readjson(joinpath(output,"run-status.json"))["status"]=="failed"
        @test readjson(joinpath(output,"run-status.json"))["completed_configurations"]==1
        @test !isfile(joinpath(output,"collection.json"))
        @test !isfile(joinpath(output,"index.html"))
        @test !isfile(joinpath(output,"report.md"))
        @test isfile(joinpath(output,"configurations","julia-1-blas-1","report.json"))
        @test_throws Exception PerformanceCompletion.check_run(output)
        @test_throws ErrorException collect_reports(;output,suite,run_child=copy_child,
                      build_site=(_,_) -> error("injected HTML failure"),progress=devnull)
        @test readjson(joinpath(output,"run-status.json"))["completed_configurations"]==3
        @test !isfile(joinpath(output,"collection.json"))
        drifting=command->begin
            copy_child(command)
            if argument(command,"--julia-threads")=="4"
                path=joinpath(argument(command,"--output"),"report.json")
                report=readjson(path)
                first(report["cases"])["parameters"]["nominal_D"]=4
                writejson(path,report)
            end
        end
        @test_throws Exception collect_reports(;output,suite,run_child=drifting,progress=devnull)
        @test !isfile(joinpath(output,"collection.json"))
        @test readjson(joinpath(output,"run-status.json"))["status"]=="failed"
        empty_child=command->begin
            directory=argument(command,"--output")
            mkpath(directory)
            write(joinpath(directory,"report.md"),"No benchmark cases configured.\n")
            writejson(joinpath(directory,"run-status.json"),Dict("status"=>"empty","case_count"=>0))
        end
        @test collect_reports(;output,suite,run_child=empty_child,progress=devnull)===nothing
        @test readjson(joinpath(output,"run-status.json"))["status"]=="empty"
        @test !isfile(joinpath(output,"collection.json"))
        @test !PerformanceCompletion.check_run(output)
      end
    end
end
