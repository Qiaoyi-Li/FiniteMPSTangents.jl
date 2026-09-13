using Test
using JSON3

include(joinpath(@__DIR__, "..", "publish.jl"))
using .PerformancePublisher
using .PerformancePublisher.PerformanceReports
using .PerformancePublisher.PerformanceCollections

visible_text(html) = replace(replace(html, r"(?is)<(script|style)\b[^>]*>.*?</\1>" => " "), r"(?s)<[^>]*>" => " ")

"Synthetic publisher input only; this is never part of the measured package suite."
function fixture_report(; tag=nothing, run_number=1, run_attempt=1, sha=repeat("a", 40), prerelease=false,
                        ids=["test/workload-v1"], cpu="SYNTHETIC test CPU", time=1234.5)
    return Dict{String, Any}(
        "schema_version" => 1,
        "source" => Dict{String, Any}("repository" => "Qiaoyi-Li/FiniteMPSTangents.jl", "commit_sha" => sha,
            "tag" => tag, "package_version" => "0.1.0", "benchmark_source_sha" => repeat("b", 40),
            "prerelease" => prerelease, "working_tree_dirty" => false),
        "run" => Dict{String, Any}("measured_at_utc" => "2026-09-12T08:00:00Z", "event_name" => tag === nothing ? "push" : "release",
            "workflow" => "Performance", "run_id" => string(1000 + run_number),
            "run_number" => run_number, "run_attempt" => run_attempt, "run_url" => "https://github.com/Qiaoyi-Li/FiniteMPSTangents.jl/actions/runs/$(1000 + run_number)"),
        "environment" => Dict{String, Any}(
            "cpu" => Dict{String, Any}("cpu_models" => [cpu], "architecture" => "x86_64", "logical_cpus_visible" => 8,
                "physical_cores_visible" => 4, "affinity_cpu_list" => "0-3", "affinity_cpu_count" => 4),
            "system" => Dict{String, Any}("os" => "Linux", "kernel" => "SYNTHETIC 6.0", "memory_total_bytes_visible" => 16 * 1024^3),
            "runner" => Dict{String, Any}("label" => "ubuntu-24.04", "environment" => "github-hosted", "image_version" => nothing),
            "runtime" => Dict{String, Any}("julia_version" => "1.11.6", "julia_threads_default" => 2,
                "julia_threads_interactive" => 0, "julia_gc_threads" => nothing,
                "blas_configuration" => "SYNTHETIC test BLAS", "blas_threads" => 1),
            "package_versions" => Dict{String, Any}("FiniteMPSTangents" => "0.1.0", "BenchmarkTools" => "1.6.0")),
        "cases" => [Dict{String, Any}("case_id" => id, "description" => "SYNTHETIC publishing test",
            "parameters" => Dict{String, Any}("size" => 16), "measurement_parameters" => Dict{String, Any}(
                "seed" => 42, "evals" => 1, "seconds_budget" => 0.1, "samples_budget" => 10),
            "samples" => 10, "median_time_ns" => time, "allocated_bytes" => 0, "allocations" => 0) for id in ids])
end

@testset "Presentation ordering accepts custom workload parameters" begin
    report = fixture_report(ids=["custom/small","custom/numeric"])
    for (case,dimension) in zip(report["cases"],("small",16))
        case["parameters"]["nominal_D"] = dimension
    end
    original = deepcopy(report)
    @test validate_report(report) === report
    @test first(ordered_cases(report))["case_id"] == "custom/numeric"
    @test occursin("Performance measurement report",render_report(report))
    @test occursin("Performance measurement report",render_markdown(report))
    @test report == original
end

function snapshot(site)
    result = Dict{String, Vector{UInt8}}()
    for (directory, _, files) in walkdir(site)
        for name in files
            path = joinpath(directory, name)
            result[relpath(path, site)] = read(path)
        end
    end
    return result
end

function save_input(directory, report)
    path = joinpath(directory, "input.json")
    write_json(path, report)
    return path
end

function document_sentinels(site)
    sentinels = Dict("dev/index.html" => "original docs dev", "stable/index.html" => "original docs stable",
        "v1.0.0/index.html" => "original docs version", "index.html" => "original docs home",
        "CNAME" => "example.invalid", ".nojekyll" => "", "assets/logo.svg" => "original asset")
    for (path, content) in sentinels
        destination = joinpath(site, path)
        mkpath(dirname(destination))
        write(destination, content)
    end
    return sentinels
end

function fixture_collection(; kwargs...)
    reports = Any[]
    for threads in (1, 2, 4)
        report = fixture_report(; kwargs...)
        prototype = first(report["cases"])
        report["cases"] = Any[]
        for (section, family, symmetry, configuration, rank) in (
                ("basic", "CM", "NoSym", "pushright-rank3", 3),
                ("basic", "CM", "SU2", "pushright-rank4", 4),
                ("mul", "mulH", "U1", "rank3", 3),
                ("calobs", "calObs", "U1xSU2", "rank4", 4)), dimension in (8, 16, 32)
            case = deepcopy(prototype)
            case["case_id"] = "test/$section/$symmetry/$configuration/D=$dimension"
            case["parameters"] = Dict{String, Any}("section" => section, "family" => family,
                "symmetry" => symmetry, "configuration" => configuration, "nominal_D" => dimension,
                "actual_D" => dimension - 1, "base_rank" => rank, "center_rank" => rank + 1,
                "preset_id" => nothing, "bond_schedule" => [1, dimension - 1, 1],
                "execution" => Dict("julia_threads" => threads, "action_threads" => threads))
            case["median_time_ns"] = dimension == 8 ? 0.0 : 1000.0 * dimension / threads
            push!(report["cases"], case)
        end
        report["environment"]["runtime"]["julia_threads_default"] = threads
        report["environment"]["runtime"]["julia_gc_threads"] = 1
        report["run"]["measured_at_utc"] = "2026-09-12T08:00:0$(threads)Z"
        push!(reports, report)
    end
    index = Dict{String, Any}("schema_version" => 1, "kind" => "performance_collection", "status" => "complete",
        "source" => deepcopy(first(reports)["source"]), "run" => deepcopy(first(reports)["run"]),
        "configurations" => [Dict("julia_threads" => n, "blas_threads" => 1, "gc_threads" => 1,
            "report_path" => "configurations/julia-$n-blas-1/report.json") for n in (1, 2, 4)])
    return (index=index, reports=reports)
end

function save_collection(directory, bundle)
    for (configuration, report) in zip(bundle.index["configurations"], bundle.reports)
        path = joinpath(directory, configuration["report_path"])
        mkpath(dirname(path))
        write_json(path, report)
    end
    path = joinpath(directory, "collection.json")
    write_json(path, bundle.index)
    return path
end

@testset "Report validation and rendering" begin
    report = fixture_report()
    @test validate_report(report) === report
    html, markdown = render_report(report), render_markdown(report)
    for text in ("SYNTHETIC test CPU", "Visible logical processors", "Processors available to this process", "0-3",
                 "Julia computation threads", "Julia interactive threads", "Matrix computation threads", "SYNTHETIC test BLAS",
                 "1.11.6", "ubuntu-24.04", repeat("a", 40), "2026-09-12T08:00:00Z", "Not recorded", "Uncommitted changes")
        @test occursin(text, html)
        @test occursin(text, markdown)
    end
    @test occursin("report.json", html)
    @test occursin("not peak process memory", html)
    @test occursin("<summary>Additional run metadata</summary>", html)
    suite_report = deepcopy(report)
    suite_report["source"]["suite_path"] = "benchmark/benchmarks.jl"
    suite_report["source"]["suite_origin"] = "checkout"
    @test occursin("Benchmark definition file", render_report(suite_report))
    @test occursin("benchmark/benchmarks.jl", render_report(suite_report))
    @test occursin("Benchmark definition source", render_markdown(suite_report))
    @test !occursin("<script", html)
    optional = deepcopy(report)
    optional["environment"]["system"]["kernel"] = nothing
    optional["environment"]["cpu"]["physical_cores_visible"] = nothing
    optional["environment"]["cpu"]["affinity_cpu_count"] = nothing
    optional["environment"]["cpu"]["affinity_cpu_list"] = nothing
    optional["environment"]["package_versions"]["unknown-package"] = nothing
    @test validate_report(optional) === optional
    @test occursin("Not recorded", render_report(optional))
    injected = deepcopy(report)
    injected["environment"]["cpu"]["cpu_models"] = ["<script>alert('CPU')</script>"]
    injected["cases"][1]["description"] = "</pre><script>alert('description')</script>"
    injected["cases"][1]["parameters"]["message"] = "<img src=x onerror=alert(1)> | table\nbreak"
    injected["cases"][1]["parameters"]["display_title"] = "<img src=x onerror=alert(1)> | table\nbreak"
    @test !occursin("<script>", render_report(injected))
    @test occursin("&lt;script&gt;", render_report(injected))
    @test !occursin("<script>", render_markdown(injected))
    @test occursin("\\|", render_markdown(injected))
    for mutate in (
        r -> r["schema_version"] = 2,
        r -> delete!(r["environment"]["runtime"], "blas_threads"),
        r -> r["cases"] = [],
        r -> push!(r["cases"], deepcopy(r["cases"][1])),
        r -> r["cases"][1]["median_time_ns"] = NaN,
        r -> r["cases"][1]["median_time_ns"] = Inf,
        r -> r["cases"][1]["allocations"] = -1,
        r -> r["cases"][1]["allocated_bytes"] = 0.5,
        r -> r["cases"][1]["samples"] = 0,
        r -> r["cases"][1]["samples"] = 1,
        r -> r["cases"][1]["samples"] = 11,
        r -> r["cases"][1]["measurement_parameters"]["samples_budget"] = 1,
        r -> r["cases"][1]["measurement_parameters"]["evals"] = 0,
        r -> r["cases"][1]["case_id"] = "<script>",
        r -> r["run"]["run_url"] = "javascript:alert(1)",
        r -> r["run"]["measured_at_utc"] = "2026-99-12T08:00:00Z",
        r -> r["source"]["commit_sha"] = "../../outside",
        r -> r["source"]["repository"] = "https://token@github.com/user/repo",
        r -> r["source"]["tag"] = "../../outside")
        invalid = deepcopy(report)
        mutate(invalid)
        @test_throws Exception validate_report(invalid)
    end
    @test version_tag("v1.10.0") > version_tag("v1.9.0")
    @test version_tag("v1.0.0-rc.1+build.002") == v"1.0.0-rc.1+build.002"
    for tag in ("v1", "v1.0", "1.0.0", "v01.0.0", "v1.0.0-01", "v1.0.0-rc..1", "v1.0.0/other")
        @test_throws Exception version_tag(tag)
    end
end

@testset "Dev lifecycle, dry run, and document preservation" begin
    mktempdir() do temporary
        site = mkpath(joinpath(temporary, "site"))
        sentinels = document_sentinels(site)
        report = fixture_report(; run_number=9)
        input = save_input(temporary, report)
        before = snapshot(site)
        @test publish_report(input, site; mode="dev", dry_run=true) == "published"
        @test snapshot(site) == before
        @test publish_report(input, site; mode="dev", expected_sha=repeat("a", 40)) == "published"
        first_snapshot = snapshot(site)
        @test occursin("No successful release measurements have been archived yet.", read(joinpath(site, "performance/trend/index.html"), String))
        @test isempty(JSON3.read(read(joinpath(site, "performance/trend/data.json"), String))["releases"])
        @test publish_report(input, site; mode="dev") == "no-op"
        @test snapshot(site) == first_snapshot
        newer = fixture_report(; run_number=10, sha=repeat("c", 40), cpu="new runner CPU")
        @test publish_report(save_input(temporary, newer), site; mode="dev") == "published"
        newest_snapshot = snapshot(site)
        @test publish_report(save_input(temporary, report), site; mode="dev") == "older-dev-skipped"
        @test snapshot(site) == newest_snapshot
        retry = fixture_report(; run_number=10, run_attempt=2, sha=repeat("c", 40), cpu="retry CPU")
        @test publish_report(save_input(temporary, retry), site; mode="dev") == "published"
        @test read_report(joinpath(site, "performance/dev/report.json"))["environment"]["cpu"]["cpu_models"] == ["retry CPU"]
        retry_snapshot = snapshot(site)
        @test publish_report(save_input(temporary, newer), site; mode="dev") == "older-dev-skipped"
        @test snapshot(site) == retry_snapshot
        changed_attempt = deepcopy(retry)
        changed_attempt["cases"][1]["median_time_ns"] = 9999
        @test_throws Exception publish_report(save_input(temporary, changed_attempt), site; mode="dev")
        @test snapshot(site) == retry_snapshot
        for mutate in (r -> r["run"]["workflow"] = "Other workflow", r -> r["run"]["run_id"] = "another-run",
                       r -> r["source"]["commit_sha"] = repeat("d", 40), r -> r["run"]["event_name"] = "workflow_dispatch")
            invalid = deepcopy(retry)
            mutate(invalid)
            @test_throws Exception publish_report(save_input(temporary, invalid), site; mode="dev")
            @test snapshot(site) == retry_snapshot
        end
        @test sort(readdir(joinpath(site, "performance/dev"))) == ["index.html", "report.json"]
        for (path, content) in sentinels
            @test read(joinpath(site, path), String) == content
        end
    end
end

@testset "Release archives, SemVer stable, and trend gaps" begin
    mktempdir() do temporary
        site = mkpath(joinpath(temporary, "site"))
        sentinels = document_sentinels(site)
        first = fixture_report(; tag="v1.9.0", ids=["test/common", "test/removed"])
        input = save_input(temporary, first)
        @test publish_report(input, site; mode="release", expected_tag="v1.9.0") == "published"
        archive = joinpath(site, "performance/releases/v1.9.0")
        archived_bytes = snapshot(archive)
        @test occursin("../releases/v1.9.0/", read(joinpath(site, "performance/stable/index.html"), String))
        trend = JSON3.read(read(joinpath(site, "performance/trend/data.json"), String), Dict{String, Any})
        @test length(trend["releases"]) == 1
        @test trend["cases"][1]["points"][1]["allocations"] == 0
        @test occursin("<circle", read(joinpath(site, "performance/trend/index.html"), String))
        duplicate = fixture_report(; tag="v1.9.0", cpu="replacement CPU", time=999999)
        entire_snapshot = snapshot(site)
        @test publish_report(save_input(temporary, duplicate), site; mode="release") == "already-archived"
        @test snapshot(site) == entire_snapshot
        @test snapshot(archive) == archived_bytes
        moved = fixture_report(; tag="v1.9.0", sha=repeat("d", 40))
        @test_throws Exception publish_report(save_input(temporary, moved), site; mode="release")
        @test snapshot(site) == entire_snapshot
        for report in (fixture_report(; tag="v1.10.0", ids=["test/common", "test/added"]),
                       fixture_report(; tag="v2.0.0-rc.1"), fixture_report(; tag="v3.0.0", prerelease=true),
                       fixture_report(; tag="v1.8.1"))
            @test publish_report(save_input(temporary, report), site; mode="release") == "published"
        end
        @test snapshot(archive) == archived_bytes
        @test occursin("../releases/v1.10.0/", read(joinpath(site, "performance/stable/index.html"), String))
        trend = JSON3.read(read(joinpath(site, "performance/trend/data.json"), String), Dict{String, Any})
        @test [r["tag"] for r in trend["releases"]] == ["v1.8.1", "v1.9.0", "v1.10.0", "v2.0.0-rc.1", "v3.0.0"]
        @test [r["prerelease"] for r in trend["releases"]] == [false, false, false, true, true]
        added = only(filter(c -> c["case_id"] == "test/added", trend["cases"]))
        removed = only(filter(c -> c["case_id"] == "test/removed", trend["cases"]))
        @test added["points"][2] === nothing
        @test added["points"][3]["allocated_bytes"] == 0
        @test removed["points"][2]["allocations"] == 0
        @test removed["points"][3] === nothing
        html = read(joinpath(site, "performance/trend/index.html"), String)
        @test occursin("<svg", html)
        @test occursin("id=\"case\"", html)
        @test occursin("id=\"metric\"", html)
        @test occursin("No measurement", html)
        @test occursin("Prerelease", html)
        @test all(!occursin(case["case_id"], visible_text(html)) for case in trend["cases"])
        @test !occursin("https://cdn", html)
        @test !occursin("<script src=", html)
        for (path, content) in sentinels
            @test read(joinpath(site, path), String) == content
        end
        before_failure = snapshot(site)
        candidate = fixture_report(; tag="v4.0.0")
        @test_throws Exception publish_report(save_input(temporary, candidate), site; mode="release", expected_sha=repeat("f", 40))
        @test_throws Exception publish_report(save_input(temporary, candidate), site; mode="release", expected_tag="v4.0.1")
        @test snapshot(site) == before_failure
        # A corrupt historical archive is skipped with a warning; the new archive
        # and derived pages are still published from the readable history.
        archived_json = joinpath(archive, "report.json")
        write(archived_json, "{broken")
        @test publish_report(save_input(temporary, candidate), site; mode="release") == "published"
        @test isfile(joinpath(site, "performance/releases/v4.0.0/report.json"))
    end
end

@testset "Prerelease empty stable and path protection" begin
    mktempdir() do temporary
        site = mkpath(joinpath(temporary, "site"))
        input = save_input(temporary, fixture_report(; tag="v1.0.0-rc.1"))
        @test publish_report(input, site; mode="release") == "published"
        @test occursin("No stable release measurements have been archived yet.", read(joinpath(site, "performance/stable/index.html"), String))
        outside = mkpath(joinpath(temporary, "outside"))
        write(joinpath(outside, "sentinel"), "preserve")
        linkedsite = mkpath(joinpath(temporary, "linked-site"))
        symlink(outside, joinpath(linkedsite, "performance"))
        @test_throws Exception publish_report(input, linkedsite; mode="release")
        @test read(joinpath(outside, "sentinel"), String) == "preserve"
        @test readdir(outside) == ["sentinel"]
        symlink(outside, joinpath(site, "performance/trend/escape"))
        before = snapshot(outside)
        @test_throws Exception publish_report(input, site; mode="release")
        @test snapshot(outside) == before
        collision = mkpath(joinpath(temporary, "collision"))
        mkpath(joinpath(collision, "performance"))
        write(joinpath(collision, "performance/trend"), "not a directory")
        unchanged = snapshot(collision)
        @test_throws Exception publish_report(input, collision; mode="release")
        @test snapshot(collision) == unchanged
    end
end

@testset "CLI failure exit code" begin
    mktempdir() do temporary
        input = save_input(temporary, fixture_report())
        script = normpath(joinpath(@__DIR__, "..", "publish.jl"))
        project = normpath(joinpath(@__DIR__, ".."))
        command = `$(Base.julia_cmd()) --startup-file=no --project=$project $script --report $input --site $temporary --mode release`
        result = run(pipeline(ignorestatus(command); stdout=devnull, stderr=devnull))
        @test result.exitcode != 0
    end
end

@testset "Collection identity, workloads, and grouped HTML" begin
    bundle = fixture_collection()
    @test validate_collection(bundle.index, bundle.reports).index == bundle.index
    html = render_collection(bundle)
    for label in (section_name("basic"), section_name("mul"), section_name("calobs"),
                  symmetry_name("NoSym"), symmetry_name("U1"), symmetry_name("SU2"), symmetry_name("U1xSU2"),
                  "Center bond dimension", "1 thread", "2 threads", "4 threads",
                  "0 nanoseconds", "16 microseconds", "Speedup relative to one thread", "Total allocated bytes", "Memory allocation count", "collection.json")
        @test occursin(label, html)
    end
    @test length(collect(eachmatch(r"<table>", html))) == 4
    @test length(collect(eachmatch(r"data-time=", html))) == 36
    jumps = [m.captures[1] for m in eachmatch(r"href=\"#([^\"]+)\"", html)]
    anchors = [m.captures[1] for m in eachmatch(r"id=\"([^\"]+)\"", html)]
    @test Set(jumps) == Set(["section-basic", "section-mul", "section-calobs",
                            "section-basic-NoSym", "section-basic-SU2", "section-mul-U1", "section-calobs-U1xSU2"])
    @test all(target -> count(==(target), anchors) == 1, jumps)
    @test first(findfirst("<h2 id=\"section-mul\"",html)) < first(findfirst("<h2 id=\"section-calobs\"",html)) <
          first(findfirst("<h2 id=\"section-basic\"",html))
    staged = deepcopy(bundle)
    for report in staged.reports, case in report["cases"]
        case["parameters"]["symmetry"]=="NoSym" && (case["parameters"]["family"]="EP")
    end
    staged_html = render_collection(staged)
    @test occursin("<details class=\"workload-stage\"><summary>",staged_html)
    @test !occursin(r"<details[^>]*workload-stage[^>]*\bopen\b",staged_html)
    @test first(findfirst("<h2 id=\"section-basic\"",staged_html)) < first(findfirst("<h2 id=\"section-stages\"",staged_html))
    @test presentation_section(first(ordered_cases(first(staged.reports))))=="mul"
    extended = deepcopy(bundle)
    for report in extended.reports
        p = report["cases"][1]["parameters"]
        merge!(p, Dict("section" => "Future <\"&> section", "symmetry" => "Custom/ℤ₂",
                       "base_rank" => 6, "center_rank" => 9))
        report["cases"][2]["parameters"]["symmetry"] = "Another symmetry"
    end
    @test validate_collection(extended.index, extended.reports).index == extended.index
    extended_html = render_collection(extended)
    @test occursin("Future &lt;&quot;&amp;&gt; section", extended_html)
    @test occursin("Custom/ℤ₂", extended_html)
    @test !occursin("ranks 6/9", extended_html)
    @test last(findfirst("<h2 id=\"section-calobs\"", extended_html)) < first(findfirst("<h2 id=\"section-other-", extended_html))
    @test last(findfirst("<h3 id=\"section-basic-SU2\"", extended_html)) < first(findfirst("<h3 id=\"section-basic-other-", extended_html))
    extended_jumps = [m.captures[1] for m in eachmatch(r"href=\"#([^\"]+)\"", extended_html)]
    extended_anchors = [m.captures[1] for m in eachmatch(r"id=\"([^\"]+)\"", extended_html)]
    @test length(extended_jumps) == 10
    @test all(target -> count(==(target), extended_anchors) == 1, extended_jumps)
    for (key, value) in (("section", " "), ("symmetry", ""), ("base_rank", 0),
                         ("center_rank", false), ("center_rank", 2.5))
        invalid = deepcopy(bundle)
        for report in invalid.reports
            report["cases"][1]["parameters"][key] = value
        end
        @test_throws Exception validate_collection(invalid.index, invalid.reports)
    end
    @test !occursin(r"<(script|link)[^>]+(src|href)=\"https?://", html)
    @test occursin("Unavailable (measured time is zero)", html)
    @test occursin("data-bytes=\"0\"", html)
    @test occursin("Input and sampling details", render_collection_markdown(bundle))
    for mutation in (
        b -> pop!(b.index["configurations"]),
        b -> (b.index["configurations"][1]["report_path"] = "../report.json"),
        b -> (b.index["status"] = "failed"),
        b -> (b.index["configurations"][2]["julia_threads"] = 1),
        b -> (b.reports[2]["source"]["commit_sha"] = repeat("c", 40)),
        b -> (b.reports[2]["environment"]["runtime"]["blas_threads"] = 2),
        b -> (b.reports[2]["environment"]["runtime"]["julia_gc_threads"] = 2),
        b -> (b.reports[2]["environment"]["runtime"]["julia_threads_default"] = 4),
        b -> (b.reports[2]["environment"]["cpu"]["cpu_models"] = ["changed machine"]),
        b -> pop!(b.reports[2]["cases"]),
        b -> (b.reports[2]["cases"][1]["parameters"]["actual_D"] = 6),
        b -> (b.reports[2]["cases"][1]["parameters"]["bond_schedule"] = [1, 6, 1]),
        b -> (b.reports[2]["cases"][1]["measurement_parameters"]["seed"] = 43),
        b -> (b.reports[2]["cases"][1]["measurement_parameters"]["samples_budget"] = 11),
        b -> (b.reports[2]["run"]["run_attempt"] = 2))
        invalid = deepcopy(bundle)
        mutation(invalid)
        @test_throws Exception validate_collection(invalid.index, invalid.reports)
    end
    escaped = deepcopy(bundle)
    for report in escaped.reports
        report["cases"][1]["parameters"]["display_title"] = "</script><script>alert(1)</script>"
    end
    @test occursin("&lt;/script&gt;", render_collection(escaped))
    @test !occursin("<script>alert(1)</script>", render_collection(escaped))
    duplicate_row = deepcopy(bundle)
    for report in duplicate_row.reports
        extra = deepcopy(first(report["cases"]))
        extra["case_id"] *= "-duplicate"
        push!(report["cases"], extra)
    end
    @test_throws Exception validate_collection(duplicate_row.index, duplicate_row.reports)
end

@testset "Offline collection builds and path preflight" begin
    mktempdir() do temporary
        bundle = fixture_collection()
        input = save_collection(joinpath(temporary, "input"), bundle)
        loaded = read_collection(input)
        @test loaded.reports == bundle.reports
        output = joinpath(temporary, "html")
        @test build_collection(input; output) == joinpath(output, "index.html")
        @test read_collection(joinpath(output, "collection.json")).index == bundle.index
        for threads in (1, 2, 4)
            @test isfile(joinpath(output, "configurations/julia-$threads-blas-1/index.html"))
            @test occursin("report.json", read(joinpath(output, "configurations/julia-$threads-blas-1/index.html"), String))
        end
        @test isfile(joinpath(output, "report.md"))
        outside = mkpath(joinpath(temporary, "outside"))
        collision = mkpath(joinpath(temporary, "collision"))
        symlink(outside, joinpath(collision, "configurations"))
        before = snapshot(collision)
        @test_throws Exception build_collection(input; output=collision)
        @test snapshot(collision) == before
        @test isempty(readdir(outside))
        linked_input = save_collection(joinpath(temporary, "linked-input"), bundle)
        child = joinpath(dirname(linked_input), "configurations/julia-2-blas-1/report.json")
        rm(child)
        symlink(joinpath(output, "configurations/julia-2-blas-1/report.json"), child)
        @test_throws Exception read_collection(linked_input)
        script = normpath(joinpath(@__DIR__, "..", "build.jl"))
        project = normpath(joinpath(@__DIR__, ".."))
        cli_output = joinpath(temporary, "cli-html")
        @test success(pipeline(`$(Base.julia_cmd()) --startup-file=no --project=$project $script --collection $input --output $cli_output`; stdout=devnull))
        @test isfile(joinpath(cli_output, "index.html"))
    end
end

@testset "Collection publication and mixed immutable history" begin
    mktempdir() do temporary
        site = mkpath(joinpath(temporary, "site"))
        sentinels = document_sentinels(site)
        legacy = save_input(temporary, fixture_report(; tag="v1.9.0"))
        @test publish_report(legacy, site; mode="release") == "published"
        legacy_bytes = snapshot(joinpath(site, "performance/releases/v1.9.0"))
        bundle = fixture_collection(; tag="v1.10.0")
        input = save_collection(joinpath(temporary, "release"), bundle)
        before = snapshot(site)
        @test publish_collection(input, site; mode="release", dry_run=true) == "published"
        @test snapshot(site) == before
        @test publish_collection(input, site; mode="release", expected_sha=repeat("a", 40), expected_tag="v1.10.0") == "published"
        @test snapshot(joinpath(site, "performance/releases/v1.9.0")) == legacy_bytes
        @test read_collection(joinpath(site, "performance/releases/v1.10.0/collection.json")).reports == bundle.reports
        @test occursin("v1.10.0", read(joinpath(site, "performance/stable/index.html"), String))
        trend = JSON3.read(read(joinpath(site, "performance/trend/data.json"), String), Dict{String, Any})
        @test [r["tag"] for r in trend["releases"]] == ["v1.9.0", "v1.10.0"]
        @test length(trend["cases"]) == 37
        series = only(filter(c -> c["case_id"] == "julia-1-blas-1/test/basic/NoSym/pushright-rank3/D=8", trend["cases"]))
        @test series["points"][1] === nothing
        @test series["points"][2]["median_time_ns"] == 0
        before = snapshot(site)
        @test publish_collection(input, site; mode="release") == "already-archived"
        @test snapshot(site) == before
        moved = save_collection(joinpath(temporary, "moved"), fixture_collection(; tag="v1.10.0", sha=repeat("c", 40)))
        @test_throws Exception publish_collection(moved, site; mode="release")
        @test snapshot(site) == before
        dev_single = save_input(temporary, fixture_report())
        @test publish_report(dev_single, site; mode="dev") == "published"
        dev_input = save_collection(joinpath(temporary, "dev"), fixture_collection(; run_number=2))
        @test publish_collection(dev_input, site; mode="dev") == "published"
        @test !isfile(joinpath(site, "performance/dev/report.json"))
        @test isfile(joinpath(site, "performance/dev/collection.json"))
        before = snapshot(site)
        @test publish_collection(dev_input, site; mode="dev") == "no-op"
        @test publish_report(dev_single, site; mode="dev") == "older-dev-skipped"
        @test snapshot(site) == before
        latest = save_input(temporary, fixture_report(; run_number=3))
        @test publish_report(latest, site; mode="dev") == "published"
        @test !ispath(joinpath(site, "performance/dev/configurations"))
        @test !isfile(joinpath(site, "performance/dev/collection.json"))
        @test isfile(joinpath(site, "performance/dev/report.json"))
        for (path, content) in sentinels
            @test read(joinpath(site, path), String) == content
        end
        # A corrupt historical archive is skipped, so an unrelated new dev update proceeds.
        historic = joinpath(site, "performance/releases/v1.10.0/configurations/julia-4-blas-1/report.json")
        write(historic, "{}")
        @test publish_report(save_input(temporary, fixture_report(; run_number=4)), site; mode="dev") == "published"
    end
end

# Opt-in, local-only HTML fixtures for browser QA. CI does not set this variable,
# and these synthetic reports are never registered as benchmark cases.
if haskey(ENV, "PERFORMANCE_TEST_PREVIEW_DIR")
    destination = abspath(ENV["PERFORMANCE_TEST_PREVIEW_DIR"])
    ispath(destination) && error("Preview destination must not already exist")
    site = mkpath(joinpath(destination, "site"))
    document_sentinels(site)
    for (index, report) in enumerate((
        fixture_report(; tag="v1.9.0", ids=["test/common", "test/removed"], time=3200.0),
        fixture_report(; tag="v1.10.0", ids=["test/common", "test/added"], time=2100.0),
        fixture_report(; tag="v1.11.0-rc.1", ids=["test/common", "test/removed"], time=2700.0)))
        report["cases"][1]["allocated_bytes"] = (index - 1) * 32
        report["cases"][1]["allocations"] = index - 1
        preview_input = joinpath(destination, "synthetic-input-$index.json")
        write_json(preview_input, report)
        publish_report(preview_input, site; mode="release")
    end
    dev_input = joinpath(destination, "synthetic-dev.json")
    write_json(dev_input, fixture_report())
    publish_report(dev_input, site; mode="dev")
    println("Synthetic browser QA preview: ", joinpath(site, "performance/index.html"))
    collection_input = save_collection(joinpath(destination, "synthetic-collection"), fixture_collection())
    println("Synthetic collection preview: ", build_collection(collection_input))
end
