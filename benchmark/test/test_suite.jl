using Test
using Random
using TOML
using FiniteMPSTangents
using FiniteMPSTangents.FiniteMPS

include("../harness.jl")
using .BenchmarkHarness
include("../fixtures.jl")
const SuiteFixtures = PerformanceFixtures
const SUITE_SYMMETRIES = ("NoSym","U1","SU2","U1xSU2")

without_execution(parameters) = Dict(k=>v for (k,v) in parameters if k!="execution")

@testset "Registered performance suite" begin
    suites=[load_suite(joinpath(@__DIR__,"..","benchmarks.jl"),ExecutionConfig(n)) for n in (1,2,4)]
    reference=first(suites)
    @test !isempty(reference)
    ids=[case.case_id for case in reference]
    @test allunique(ids)
    for (n,cases) in zip((1,2,4),suites)
        @test [case.case_id for case in cases]==ids
        for (expected,case) in zip(reference,cases)
            @test case.seed==expected.seed
            @test (case.warmup_group,case.warmup_size)==(expected.warmup_group,expected.warmup_size)
            @test without_execution(case.parameters)==without_execution(expected.parameters)
            @test (case.evals,case.mutates,case.seconds,case.samples,case.description)==
                  (expected.evals,expected.mutates,expected.seconds,expected.samples,expected.description)
            @test case.parameters["execution"]["julia_threads"]==n
            @test case.parameters["execution"]["blas_threads"]==1
        end
        @testset "Julia $n coverage" begin
            selected=BenchmarkHarness.validate_cases(cases)
            expected_matrix=Set((sym,rank,rank+Int(charged)) for sym in SUITE_SYMMETRIES
                                for rank in (3,4) for charged in (false,true))
            measured_matrix=Set((case.parameters["symmetry"],case.parameters["base_rank"],case.parameters["center_rank"])
                                for case in selected if case.parameters["family"]=="CM")
            @test issubset(expected_matrix,measured_matrix)
            environment_matrix=Set((case.parameters["symmetry"],case.parameters["base_rank"],case.parameters["direction"])
                                   for case in selected if case.parameters["family"]=="EP")
            @test environment_matrix==Set((sym,rank,direction) for sym in SUITE_SYMMETRIES
                                          for rank in (3,4) for direction in ("left","right"))
            @test all(case->!(case.parameters["family"] in ("LP","QH","QL")),selected)
            inner_matrix=Set((case.parameters["symmetry"],case.parameters["base_rank"],case.parameters["center_rank"])
                             for case in selected if case.parameters["family"]=="IP")
            @test inner_matrix==Set((sym,rank,center) for sym in SUITE_SYMMETRIES
                                   for (rank,center) in ((3,3),(4,5)))
            for family in ("SA","RA","RC")
                stage_matrix=Set((case.parameters["symmetry"],case.parameters["base_rank"],case.parameters["center_rank"])
                                 for case in selected if case.parameters["family"]==family)
                required=expected_matrix
                @test stage_matrix==required
                directions=family=="SA" ? (nothing,) : ("left","right")
                oriented=Set((case.parameters["symmetry"],case.parameters["base_rank"],
                              case.parameters["center_rank"],case.parameters["direction"])
                             for case in selected if case.parameters["family"]==family)
                @test oriented==Set((sym,rank,center,direction) for (sym,rank,center) in required
                                     for direction in directions)
            end
            # Group by operation configuration; adding cases never requires a total-count update.
            groups=Dict{Any,Vector{Int}}()
            for case in selected
                p=case.parameters
                key=(p["section"],p["family"],p["symmetry"],p["configuration"],p["base_rank"],p["center_rank"])
                push!(get!(groups,key,Int[]),p["nominal_D"])
            end
            for (configuration,Ds) in groups
                @test sort(Ds)==collect(SuiteFixtures.dimensions(configuration[3]))
            end
            plan = BenchmarkHarness.measurement_plan(selected)
            @test Set(entry.case.case_id for entry in plan)==Set(case.case_id for case in selected)
            @test length(plan)==length(selected)
            warmed = Set{String}()
            for (case,warmup_case) in plan
                p = case.parameters
                @test case.warmup_size==p["nominal_D"]
                @test warmup_case.warmup_size==first(SuiteFixtures.dimensions(p["symmetry"]))
                for key in ("section","family","symmetry","configuration","base_rank","center_rank")
                    @test warmup_case.parameters[key]==p[key]
                end
                if case.case_id==warmup_case.case_id
                    @test case.warmup_group ∉ warmed
                    push!(warmed,case.warmup_group)
                else
                    @test case.warmup_group ∈ warmed
                end
            end
            @test length(warmed)==length(groups)
            for sym in SUITE_SYMMETRIES,kind in ("onsite","two-site","multisite")
                @test any(case->case.parameters["family"]=="CO" && case.parameters["symmetry"]==sym &&
                          occursin(kind,case.parameters["configuration"]),selected)
            end
        end
    end
end

function frozen_center(sym,D,presets)
    sym=="NoSym" && return ℂ^D
    model=Dict("U1"=>"u1_xxz","SU2"=>"su2_heisenberg","U1xSU2"=>"u1su2_hubbard")[sym]
    preset=only(p for p in presets["presets"] if p["model"]==model && p["requested_dimension_cap"]==D)
    rows=preset["sectors"]
    V=sym=="U1" ? Rep[U₁](r["charge_twice"]//2=>r["multiplicity"] for r in rows) :
      sym=="SU2" ? Rep[SU₂](r["spin_twice"]//2=>r["multiplicity"] for r in rows) :
      Rep[U₁×SU₂]((r["charge_twice"]//2,r["spin_twice"]//2)=>r["multiplicity"] for r in rows)
    @test dim(V)==preset["actual_full_dimension"]
    return V
end

function check_description(V)
    description=SuiteFixtures.describe_space(V)
    rows=description["sectors"]
    @test description["full_dimension"]==dim(V)
    @test description["multiplet_count"]==sum(row["multiplicity"] for row in rows)
    @test dim(V)==sum(row["multiplicity"]*row["irrep_dimension"] for row in rows)
    @test all(row["multiplicity"]>0 && row["irrep_dimension"]>0 for row in rows)
    return description
end

function check_schedule(sym,rank,D,presets;spinless=false)
    P=SuiteFixtures.physical_space(sym;spinless)
    effective=rank==3 ? P : fuse(P⊗P')
    spaces=SuiteFixtures.bond_spaces(sym,D,rank;spinless)
    @test length(spaces)==17
    @test first(spaces)==last(spaces)==trivial(P)
    @test spaces[9]==frozen_center(sym,D,presets)
    @test all(0<dim(V)<=D for V in spaces)
    for site in 1:16
        left,right=spaces[site],spaces[site+1]
        forward=fuse(left⊗effective)
        backward=fuse(right⊗effective')
        @test all(dim(right,c)<=dim(forward,c) for c in sectors(right))
        @test all(dim(left,c)<=dim(backward,c) for c in sectors(left))
    end
    return [check_description(V) for V in spaces]
end

@testset "Frozen center and local fusion contracts" begin
    presets=TOML.parsefile(joinpath(@__DIR__,"..","presets","bond_sectors.toml"))
    @test SuiteFixtures.CHAIN_LENGTH==presets["length"]==16
    @test presets["cut_after_site"]==8
    for sym in SUITE_SYMMETRIES,rank in (3,4)
        @testset "$sym base rank $rank" begin
            schedules=[check_schedule(sym,rank,D,presets) for D in SuiteFixtures.dimensions(sym)]
            @test all(schedules[i]!=schedules[j] for i in eachindex(schedules) for j in i+1:length(schedules))
        end
    end
    @testset "U1 spinless purified bases" begin
        schedules=[check_schedule("U1",4,D,presets;spinless=true) for D in SuiteFixtures.dimensions("U1")]
        @test all(schedules[i]!=schedules[j] for i in eachindex(schedules) for j in i+1:length(schedules))
    end
end

@testset "Small random TensorMap reproducibility" begin
    for sym in SUITE_SYMMETRIES
        P=SuiteFixtures.physical_space(sym)
        cod=dom=P⊗P
        A=SuiteFixtures.random_map(Xoshiro(20260912),cod,dom)
        B=SuiteFixtures.random_map(Xoshiro(20260912),cod,dom)
        C=SuiteFixtures.random_map(Xoshiro(20260913),cod,dom)
        valuesA=Dict(c=>copy(block) for (c,block) in blocks(A))
        valuesB=Dict(c=>copy(block) for (c,block) in blocks(B))
        valuesC=Dict(c=>copy(block) for (c,block) in blocks(C))
        @test valuesA==valuesB
        @test valuesA!=valuesC
        @test codomain(A)==cod && domain(A)==dom
        @test all(all(isfinite,block) for (_,block) in blocks(A))
        @test norm(A)>0
        check_description(P)
    end
end
