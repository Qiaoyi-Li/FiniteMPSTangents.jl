using Test
using JSON3
using Base64

include(joinpath(@__DIR__, "..", "ci", "resolve_target.jl"))
include(joinpath(@__DIR__, "..", "ci", "check_run.jl"))
include(joinpath(@__DIR__, "..", "ci", "publish_site.jl"))

const PT = PerformanceTarget
const PC = PerformanceCompletion
const PS = PerformanceSite
const EVENT_SHA = repeat("a", 40)

writejson(path, value) = write(path, JSON3.write(value))

@testset "Performance workflow leaves benchmark tests manual" begin
    workflow=read(joinpath(@__DIR__,"..","..",".github","workflows","Performance.yml"),String)
    @test !occursin("benchmark/test/",workflow)
    @test !occursin("Pkg.test",workflow)
    @test occursin("benchmark/collect.jl",workflow)
    @test occursin("benchmark/ci/check_run.jl",workflow)
end

function fixture_git(repo, args...)
    command = Cmd(vcat(["git", "-C", repo], collect(args)))
    return strip(read(pipeline(command; stderr=devnull), String))
end

@testset "CI summaries stay compact with complete result artifacts" begin
    mktempdir() do temporary
        # Synthetic metadata only: exercise 729-point summary size without any
        # benchmark operation or timing data. Full details must remain untouched.
        details = "DETAILS_MUST_STAY_IN_ARTIFACT\n" * repeat("case parameters and bond sectors\n", 70_000)
        markdown = joinpath(temporary, "report.md")
        write(markdown, details)
        @test filesize(markdown) > 1024^2
        source = Dict("repository" => "owner/repo", "commit_sha" => EVENT_SHA, "tag" => "v1.2.3+build.1")
        run = Dict("run_url" => "https://github.com/owner/repo/actions/runs/123")
        report = Dict("schema_version" => 1, "source" => source, "run" => run,
            "cases" => [Dict("parameters" => Dict("details" => "PRIVATE_CASE_DETAILS")) for _ in 1:243],
            "environment" => Dict("runtime" => Dict("julia_threads_default" => 2,
                "blas_threads" => 1, "julia_gc_threads" => 1)))
        report_path = joinpath(temporary, "report.json")
        writejson(report_path, report)
        writejson(joinpath(temporary, "run-status.json"), Dict("status" => "measured", "case_count" => 243))
        output, summary = joinpath(temporary, "outputs"), joinpath(temporary, "summary")
        withenv("GITHUB_OUTPUT" => output, "GITHUB_STEP_SUMMARY" => summary) do
            PC.main([temporary, "--mode", "none"])
        end
        text = read(summary, String)
        @test ncodeunits(text) < 8192
        @test occursin("Cases per configuration | 243", text)
        @test occursin("Measurement points | 243", text)
        @test occursin("disabled for manual run-only", text)
        @test occursin("measured=true", read(output, String))
        @test !occursin("DETAILS_MUST_STAY_IN_ARTIFACT", text)
        @test !occursin("PRIVATE_CASE_DETAILS", text)

        configurations = [Dict("julia_threads" => n, "blas_threads" => 1, "gc_threads" => 1,
            "report_path" => "configurations/julia-$n-blas-1/report.json") for n in (1, 2, 4)]
        collection = Dict("kind" => "performance_collection", "source" => source, "run" => run,
            "configurations" => configurations)
        collection_path = joinpath(temporary, "collection.json")
        writejson(collection_path, collection)
        for configuration in configurations
            path = joinpath(temporary, configuration["report_path"])
            mkpath(dirname(path))
            writejson(path, report)
        end
        metadata = PS.PerformanceSummary.read_summary(collection_path)
        @test metadata.case_count == 243
        for status in ("published", "already-archived", "older-dev-skipped", "no-op"), changed in (false, true)
            text = sprint(io -> PS.PerformanceSummary.write_summary(io, metadata;
                publishing=status, git_push=changed, published_mode="release", env=Dict()))
            @test ncodeunits(text) < 8192
            @test occursin("Measurement points | 729", text)
            @test occursin("Measured configurations | 3", text)
            @test all(occursin("| <code>$n</code> | <code>1</code> | <code>1</code> |", text) for n in (1, 2, 4))
            @test occursin("Publishing: <code>$status</code>", text)
            @test occursin(changed ? "Git push: completed" : "Git push: no changes", text)
            @test occursin("/releases/v1.2.3%2Bbuild.1)", text)
            @test occursin("[Measured commit](https://github.com/owner/repo/commit/$EVENT_SHA)", text)
            @test occursin("[Workflow run](https://github.com/owner/repo/actions/runs/123)", text)
            @test !occursin("PRIVATE_CASE_DETAILS", text)
        end
        text = sprint(io -> PC.PerformanceSummary.write_summary(io, metadata;
            publishing="published", published_mode="dev", env=Dict()))
        @test occursin("/tree/gh-pages/performance/dev)", text)
        source["tag"] = repeat("<large|tag>\n", 200_000)
        writejson(collection_path, collection)
        metadata = PC.PerformanceSummary.read_summary(collection_path)
        text = sprint(io -> PC.PerformanceSummary.write_summary(io, metadata;
            publishing="published", published_mode="release", env=Dict()))
        @test ncodeunits(text) < 8192
        @test occursin("&lt;large&#124;tag&gt;", text)
        @test !occursin("[Archived files]", text)
        @test read(markdown, String) == details

        text = sprint(io -> PC.PerformanceSummary.write_summary(io, nothing;
            publishing="skipped — no cases configured",
            env=Dict("GITHUB_REPOSITORY" => "owner/repo", "GITHUB_RUN_ID" => "456")))
        @test occursin("empty — no cases configured", text)
        @test occursin("Measurement points | 0", text)
        @test occursin("/actions/runs/456)", text)
        @test !occursin("Measured commit", text)
    end
end

function with_git_fixture(f)
    mktempdir() do temporary
        remote = mkdir(joinpath(temporary, "remote"))
        fixture_git(remote, "init", "-b", "main")
        fixture_git(remote, "config", "user.name", "Fixture")
        fixture_git(remote, "config", "user.email", "fixture@example.invalid")
        write(joinpath(remote, "README"), "fixture")
        fixture_git(remote, "add", "README")
        fixture_git(remote, "commit", "-m", "fixture")
        first_sha = fixture_git(remote, "rev-parse", "HEAD")
        fixture_git(remote, "tag", "v1.0.0")
        fixture_git(remote, "tag", "-a", "v1.1.0", "-m", "annotated fixture")
        annotated = fixture_git(remote, "rev-parse", "v1.1.0")
        write(joinpath(remote, "README"), "second")
        fixture_git(remote, "commit", "-am", "new main")
        clone = joinpath(temporary, "clone")
        run(pipeline(`git clone $remote $clone`; stdout=devnull, stderr=devnull))
        f((; temporary, remote, clone, first_sha, annotated))
    end
end

@testset "CI event policy" begin
    target = PT.select_target("push", Dict("ref" => "refs/heads/main", "after" => EVENT_SHA), repeat("b", 40), "")
    @test target["target_ref"] == EVENT_SHA
    @test target["publish_mode"] == "dev"
    for event in (Dict("ref" => "refs/tags/v1.2.3", "deleted" => true),
                  Dict("ref" => "refs/tags/vnightly"), Dict("ref" => "refs/heads/other"))
        @test !PT.select_target("push", event, EVENT_SHA, "")["should_run"]
    end
    release = Dict{String,Any}("tag_name" => "v1.2.3", "target_commitish" => "main", "prerelease" => true)
    event = Dict("action" => "published", "release" => release)
    target = PT.select_target("release", event, EVENT_SHA, "")
    @test target["target_ref"] == "refs/tags/v1.2.3"
    @test target["prerelease"]
    release["draft"] = true
    @test !PT.select_target("release", event, EVENT_SHA, "")["should_run"]

    for ref in (EVENT_SHA, "main", "feature/benchmark", "v1.2.3+build.01")
        target = PT.select_target("workflow_dispatch", Dict("inputs" => Dict("ref" => ref)), EVENT_SHA, "")
        @test target["publish_mode"] == "none"
        @test target["target_ref"] == ref
    end
    target = PT.select_target("workflow_dispatch", Dict("inputs" => Dict("ref" => "v1.2.3-rc.1", "mode" => "archive-release")), EVENT_SHA, "")
    @test (target["tag"], target["publish_mode"]) == ("v1.2.3-rc.1", "release")
    @test target["prerelease"]
    for ref in ("main", EVENT_SHA, "refs/tags/v1.2.3")
        @test_throws Exception PT.select_target("workflow_dispatch", Dict("inputs" => Dict("ref" => ref, "mode" => "archive-release")), EVENT_SHA, "")
    end
    for ref in ("--upload-pack=evil", "main;whoami", raw"$(whoami)", "foo\nbar", "main:refs/heads/a", "../main", "a.lock")
        @test_throws Exception PT.select_target("workflow_dispatch", Dict("inputs" => Dict("ref" => ref)), EVENT_SHA, "")
    end
    @test_throws Exception PT.select_target("workflow_dispatch", Dict("inputs" => Dict("mode" => "dev")), EVENT_SHA, "")
    for tag in ("v0.1.0", "v1.10.0", "v1.2.3-rc.1+test.002")
        @test PT.version_tag(tag)
    end
    for tag in ("1.2.3", "v01.2.3", "v1.2", "v1.2.3-01", "v1.2.3/../../dev", "v1.2.3\n")
        @test !PT.version_tag(tag)
    end
end

@testset "CI coverage is independent of publication mode" begin
    events = [
        ("push",Dict("ref"=>"refs/heads/main","after"=>EVENT_SHA),"dev"),
        ("push",Dict("ref"=>"refs/tags/v1.2.3","after"=>EVENT_SHA),"release"),
        ("release",Dict("action"=>"published","release"=>Dict("tag_name"=>"v1.2.3")),"release"),
        ("workflow_dispatch",Dict("inputs"=>Dict("ref"=>"main","mode"=>"run-only")),"none"),
        ("workflow_dispatch",Dict("inputs"=>Dict("ref"=>"v1.2.3","mode"=>"archive-release")),"release"),
    ]
    for (name,event,mode) in events
        target = PT.select_target(name,event,EVENT_SHA,"")
        @test target["should_run"]
        @test target["publish_mode"]==mode
    end
end

@testset "CI optional release metadata" begin
    @test !PT.release_prerelease("owner/repo", "v1.0.0"; request_json=(url, headers) -> (404, Dict()))
    @test isnothing(PT.release_prerelease("owner/repo", "v1.0.0"; request_json=(url, headers) -> (403, Dict())))
    @test isnothing(PT.release_prerelease("owner/repo", "v1.0.0"; request_json=(url, headers) -> (500, Dict())))
    @test PT.release_prerelease("owner/repo", "v1.0.0"; request_json=(url, headers) -> (200, Dict("prerelease" => true)))
    @test !PT.release_prerelease("owner/repo", "v1.0.0"; request_json=(url, headers) -> (200, Dict("prerelease" => false)))
    @test isnothing(PT.release_prerelease("owner/repo", "v1.0.0"; request_json=(url, headers) -> error("offline transport failure")))
    PT.release_prerelease("owner/repo", "v1.0.0+build.1"; request_json=(url, headers) -> begin
        @test endswith(url, "/repos/owner/repo/releases/tags/v1.0.0%2Bbuild.1")
        @test haskey(headers, "Accept")
        (200, Dict("prerelease" => false))
    end)
end

@testset "CI target resolution keeps tag-derived prerelease without release metadata" begin
    with_git_fixture() do fixture
        (; remote, clone, temporary) = fixture
        fixture_git(remote, "tag", "v1.2.3-rc.1")
        object_sha = fixture_git(remote, "rev-parse", "v1.2.3-rc.1")
        event_path = joinpath(temporary, "prerelease-event.json")
        writejson(event_path, Dict("ref" => "refs/tags/v1.2.3-rc.1", "after" => object_sha))
        # GITHUB_REPOSITORY is unset: the tag-derived prerelease flag must suppress the
        # metadata lookup entirely, so this resolution never touches the network.
        withenv("GITHUB_EVENT_PATH" => event_path, "GITHUB_EVENT_NAME" => "push",
                "GITHUB_OUTPUT" => joinpath(temporary, "prerelease-output"),
                "GITHUB_STEP_SUMMARY" => joinpath(temporary, "prerelease-summary"),
                "GITHUB_REPOSITORY" => nothing) do
            result = PT.main(["--repo", clone])
            @test result["should_run"]
            @test result["prerelease"]
            @test result["target_sha"] == object_sha
        end
    end
end

@testset "CI exact Git targets and site isolation" begin
    with_git_fixture() do fixture
        (; remote, clone, first_sha, annotated, temporary) = fixture
        target = PT.select_target("push", Dict("ref" => "refs/heads/main", "after" => first_sha), "", "")
        @test PT.resolve(target, clone)["target_sha"] == first_sha
        event_path = joinpath(temporary, "event.json")
        output_path, summary_path = joinpath(temporary, "target-output"), joinpath(temporary, "target-summary")
        writejson(event_path, Dict("ref" => "refs/heads/main", "after" => first_sha))
        withenv("GITHUB_EVENT_PATH" => event_path, "GITHUB_EVENT_NAME" => "push",
                "GITHUB_OUTPUT" => output_path, "GITHUB_STEP_SUMMARY" => summary_path) do
            result = PT.main(["--repo", clone])
            @test result["target_sha"] == first_sha
            @test occursin("target_sha=$first_sha\n", read(output_path, String))
            @test occursin("should_run=true\n", read(output_path, String))
            writejson(event_path, Dict("ref" => "refs/heads/other"))
            @test !PT.main(["--repo", clone])["should_run"]
            @test occursin("Performance run skipped:", read(summary_path, String))
        end
        for (tag, object) in (("v1.0.0", first_sha), ("v1.1.0", annotated), ("v1.1.0", first_sha))
            target = PT.select_target("push", Dict("ref" => "refs/tags/$tag", "after" => object), "", "")
            @test PT.resolve(target, clone)["target_sha"] == first_sha
        end
        target = PT.select_target("push", Dict("ref" => "refs/tags/v1.0.0", "after" => first_sha), "", "")
        fixture_git(remote, "tag", "-f", "v1.0.0")
        @test_throws Exception PT.resolve(target, clone)
        target = PT.select_target("workflow_dispatch", Dict("inputs" => Dict("ref" => "absent")), "", "")
        @test_throws Exception PT.resolve(target, clone)

        empty_site = joinpath(temporary, "empty-site")
        PS.prepare_site(empty_site, remote)
        mkpath(joinpath(empty_site, "performance"))
        write(joinpath(empty_site, "performance/index.html"), "test-only report")
        @test PS.commit_site(empty_site, "first fixture")
        @test fixture_git(empty_site, "branch", "--show-current") == "gh-pages"
        @test !PS.commit_site(empty_site, "same fixture")

        fixture_git(remote, "checkout", "--orphan", "gh-pages")
        fixture_git(remote, "rm", "-rf", ".")
        write(joinpath(remote, "CNAME"), "docs.example.invalid")
        mkpath(joinpath(remote, "dev"))
        write(joinpath(remote, "dev/index.html"), "documentation sentinel")
        fixture_git(remote, "add", ".")
        fixture_git(remote, "commit", "-m", "docs fixture")
        site = joinpath(temporary, "site")
        PS.prepare_site(site, remote)
        mkpath(joinpath(site, "performance"))
        write(joinpath(site, "performance/index.html"), "test-only report")
        @test PS.commit_site(site, "fixture")
        @test !PS.commit_site(site, "fixture")
        @test read(joinpath(site, "CNAME"), String) == "docs.example.invalid"
        @test read(joinpath(site, "dev/index.html"), String) == "documentation sentinel"
        write(joinpath(site, "performance/index.html"), "test-only updated report")
        @test PS.commit_site(site, "modified fixture")
        fixture_git(site, "mv", "performance/index.html", "performance/moved.html")
        @test PS.commit_site(site, "rename within performance")
        fixture_git(site, "mv", "performance/moved.html", "outside.html")
        @test_throws Exception PS.commit_site(site, "rename outside performance")
        fixture_git(site, "reset", "--hard", "HEAD")
        fixture_git(site, "mv", "CNAME", "performance/CNAME")
        @test_throws Exception PS.commit_site(site, "rename docs into performance")
        fixture_git(site, "reset", "--hard", "HEAD")
        write(joinpath(site, "CNAME"), "unexpected")
        @test_throws Exception PS.commit_site(site, "should fail")
    end
end

@testset "CI result and key contracts" begin
    mktempdir() do temporary
        write(joinpath(temporary, "report.md"), "No cases configured")
        status = joinpath(temporary, "run-status.json")
        writejson(status, Dict("status" => "empty", "case_count" => 0))
        @test !PC.check_run(temporary)
        write(joinpath(temporary, "report.json"), "{}")
        @test_throws Exception PC.check_run(temporary)
        writejson(status, Dict("status" => "measured", "case_count" => 2))
        @test_throws Exception PC.check_run(temporary)
        writejson(joinpath(temporary, "report.json"), Dict("schema_version" => 1, "cases" => [Dict(), Dict()]))
        @test PC.check_run(temporary)
        for value in (Dict("status" => "measured", "case_count" => 0), Dict("status" => "empty", "case_count" => 1),
                      Dict("status" => "failed", "case_count" => 0), Dict("status" => "measured", "case_count" => true))
            writejson(status, value)
            @test_throws Exception PC.check_run(temporary)
        end
        rm(joinpath(temporary, "report.json"))
        writejson(status, Dict("status" => "empty", "case_count" => 0))
        output, summary = joinpath(temporary, "outputs"), joinpath(temporary, "summary")
        withenv("GITHUB_OUTPUT" => output, "GITHUB_STEP_SUMMARY" => summary) do
            PC.main([temporary, "--mode", "dev"])
        end
        @test occursin("measured=false", read(output, String))
        @test occursin("no cases", lowercase(read(summary, String)))
    end
    raw_key = "-----BEGIN OPENSSH PRIVATE KEY-----\ntest fixture only\n-----END OPENSSH PRIVATE KEY-----\n"
    @test PS.decode_key(base64encode(raw_key)) == collect(codeunits(raw_key))
    @test PS.decode_key("\n" * base64encode(raw_key) * "\n") == collect(codeunits(raw_key))
    for invalid in ("", "raw-key", base64encode("not a key"))
        @test_throws Exception PS.decode_key(invalid)
    end
    withenv("DOCUMENTER_KEY" => base64encode(raw_key)) do
        sandbox = Module(:PublisherImportFixture)
        Base.include(sandbox, joinpath(@__DIR__, "..", "ci", "publish_site.jl"))
        @test ENV["DOCUMENTER_KEY"] == base64encode(raw_key)
        @test_throws ErrorException Base.invokelatest(sandbox.PerformanceSite.main, String[])
        @test !haskey(ENV, "DOCUMENTER_KEY")
    end
end
