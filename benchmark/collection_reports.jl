module PerformanceCollections

include("reports.jl")
using .PerformanceReports
using JSON3

export read_collection, validate_collection, render_collection, render_collection_markdown,
       build_collection, configuration_id, collection_record, collection_files

configuration_id(threads::Integer) = "julia-$threads-blas-1"
const THREADS = (1, 2, 4)
const SECTIONS = ("mul" => "Complete mul!", "calobs" => "Complete calObs!",
                  "basic" => "Supporting whole-chain operations", "stages" => "Internal calculation stages")
const SYMMETRIES = ("NoSym", "U1", "SU2", "U1xSU2")
check(condition, message) = condition || error(message)
positive_int(value) = value isa Integer && !(value isa Bool) && value > 0
section_label(section) = section_name(section)
section_anchor(section) = section in first.(SECTIONS) ? "section-$section" : "section-other-$(bytes2hex(codeunits(section)))"
symmetry_anchor(section, symmetry) = section_anchor(section) * "-" *
    (symmetry in SYMMETRIES ? symmetry : "other-$(bytes2hex(codeunits(symmetry)))")
group_order(value, preferred) = (something(findfirst(==(value), preferred), length(preferred) + 1), value)

function validate_index(index)
    check(index isa AbstractDict, "Collection must be a JSON object")
    check(get(index, "schema_version", nothing) === 1 && get(index, "kind", nothing) == "performance_collection",
          "Unsupported collection schema")
    check(get(index, "status", nothing) == "complete", "Collection is not complete")
    check(get(index, "source", nothing) isa AbstractDict && get(index, "run", nothing) isa AbstractDict,
          "Collection must preserve source and run identity")
    configurations = get(index, "configurations", nothing)
    check(configurations isa AbstractVector && length(configurations) == 3, "Collection requires exactly Julia 1, 2, and 4 configurations")
    for (configuration, threads) in zip(configurations, THREADS)
        check(configuration isa AbstractDict, "Configuration must be an object")
        check(get(configuration, "julia_threads", nothing) === threads, "Configurations must be ordered Julia 1, 2, 4")
        check(get(configuration, "blas_threads", nothing) === 1 && get(configuration, "gc_threads", nothing) === 1,
              "Collection requires BLAS 1 and GC 1")
        check(get(configuration, "report_path", nothing) == "configurations/$(configuration_id(threads))/report.json",
              "Configuration report path must match its thread configuration")
    end
    return index
end

function validate_workload(case)
    parameters = case["parameters"]
    for key in ("section", "family", "symmetry", "configuration", "nominal_D", "actual_D", "base_rank", "center_rank", "preset_id", "bond_schedule")
        check(haskey(parameters, key), "$(case["case_id"]) lacks presentation/workload parameter $key")
    end
    for key in ("section", "symmetry", "family", "configuration")
        check(parameters[key] isa AbstractString && !isempty(strip(parameters[key])), "Invalid workload $key")
    end
    check(positive_int(parameters["nominal_D"]) && positive_int(parameters["actual_D"]), "Workload dimensions must be positive integers")
    check(parameters["actual_D"] <= parameters["nominal_D"], "Actual D cannot exceed its nominal cap")
    check(positive_int(parameters["base_rank"]) && positive_int(parameters["center_rank"]),
          "Base and center ranks must be positive integers")
    check(parameters["preset_id"] === nothing || parameters["preset_id"] isa AbstractString, "Invalid preset ID")
    check(parameters["bond_schedule"] isa AbstractVector && !isempty(parameters["bond_schedule"]), "Bond schedule must be a nonempty vector")
    check(!haskey(parameters, "execution") || parameters["execution"] isa AbstractDict, "Execution parameters must be an object")
end

without(object, keys) = Dict(key => value for (key, value) in object if key ∉ keys)
function case_definition(case)
    result = without(case, ("samples", "median_time_ns", "allocated_bytes", "allocations"))
    result["parameters"] = without(case["parameters"], ("execution",))
    return result
end

group_key(case) = let p = case["parameters"]
    (presentation_section(case), p["symmetry"], p["family"], p["configuration"], p["base_rank"], p["center_rank"])
end

function validate_collection(index, reports::AbstractVector)
    validate_index(index)
    check(length(reports) == 3, "Collection must have three measured reports")
    foreach(validate_report, reports)
    first_report = first(reports)
    check(index["source"] == first_report["source"] && index["run"] == first_report["run"],
          "Collection identity must equal the first measuring process report")
    reference_cases = Dict(case["case_id"] => case_definition(case) for case in first_report["cases"])
    for (report, threads) in zip(reports, THREADS)
        check(report["source"] == index["source"], "Collection source identity differs between configurations")
        check(without(report["run"], ("measured_at_utc",)) == without(index["run"], ("measured_at_utc",)),
              "Collection run identity differs between configurations")
        environment = report["environment"]
        reference_environment = first_report["environment"]
        check(without(environment, ("runtime",)) == without(reference_environment, ("runtime",)),
              "Collection machine/package metadata differs between configurations")
        runtime = environment["runtime"]
        check(runtime["julia_threads_default"] == threads && runtime["julia_threads_interactive"] == 0 &&
              runtime["julia_gc_threads"] == 1 && runtime["blas_threads"] == 1,
              "Actual Julia/interactive/GC/BLAS configuration differs from declaration")
        check(without(runtime, ("julia_threads_default",)) == without(reference_environment["runtime"], ("julia_threads_default",)),
              "Undeclared runtime configuration differs between reports")
        foreach(validate_workload, report["cases"])
        actual_cases = Dict(case["case_id"] => case_definition(case) for case in report["cases"])
        check(actual_cases == reference_cases, "Collection case IDs, definitions, dimensions, seeds, or measurement parameters differ")
    end
    row_keys = [(group_key(case), case["parameters"]["nominal_D"]) for case in first_report["cases"]]
    check(length(unique(row_keys)) == length(row_keys), "Several cases map to the same configuration/D row; use distinct configuration labels")
    return (index=index, reports=reports)
end

function read_collection(path::AbstractString)
    islink(path) && error("Collection index cannot be a symbolic link")
    index = validate_index(JSON3.read(read(path, String), Dict{String, Any}))
    root = realpath(dirname(abspath(path)))
    reports = Any[]
    for configuration in index["configurations"]
        relative = configuration["report_path"]
        current = root
        for part in split(relative, '/')
            current = joinpath(current, part)
            islink(current) && error("Configuration reports cannot follow symbolic links")
        end
        push!(reports, read_report(current))
    end
    validate_collection(index, reports)
    return (index=index, reports=reports, root=root)
end

function collection_record(bundle)
    validate_collection(bundle.index, bundle.reports)
    # Internal history view only: each thread/case pair remains its own series.
    cases = Any[]
    for (report, threads) in zip(bundle.reports, THREADS), case in report["cases"]
        item = deepcopy(case)
        item["case_id"] = "$(configuration_id(threads))/$(case["case_id"])"
        push!(cases, item)
    end
    return Dict("source" => bundle.index["source"], "run" => bundle.index["run"], "cases" => cases,
                "kind" => "performance_collection")
end

time_text(value) = time_value(value)

function ordered_groups(report)
    groups = Dict{Any, Vector{Any}}()
    for case in report["cases"]
        push!(get!(groups, group_key(case), Any[]), case)
    end
    keys_ordered = sort!(collect(keys(groups)); by=key -> presentation_key(first(groups[key])))
    for rows in values(groups)
        sort!(rows; by=case -> case["parameters"]["nominal_D"])
    end
    return [(key, groups[key]) for key in keys_ordered]
end

const METRIC_SCRIPT = raw"""
<script>
(() => {
  const selector = document.getElementById('metric');
  function show() {
    document.querySelectorAll('td[data-time]').forEach(cell => {
      const time = Number(cell.dataset.time), reference = Number(cell.dataset.reference);
      if (selector.value === 'speedup') cell.textContent = time > 0 ? (reference / time).toPrecision(4) + ' ×' : 'Unavailable (measured time is zero)';
      else if (selector.value === 'bytes') cell.textContent = cell.dataset.bytes + ' bytes';
      else if (selector.value === 'allocations') cell.textContent = cell.dataset.allocations + ' allocations';
      else {
        const divisor = time >= 1e9 ? 1e9 : time >= 1e6 ? 1e6 : time >= 1e3 ? 1e3 : 1;
        const unit = divisor === 1e9 ? 'seconds' : divisor === 1e6 ? 'milliseconds' : divisor === 1e3 ? 'microseconds' : 'nanoseconds';
        cell.textContent = Number((time / divisor).toPrecision(5)).toString() + ' ' + unit;
      }
    });
  }
  selector.addEventListener('change', show);
})();
</script>
"""

function render_facts(io, rows)
    println(io, "<dl>")
    for (label, value) in rows
        println(io, "<dt>", html_escape(label), "</dt><dd>", html_escape(display_value(value)), "</dd>")
    end
    println(io, "</dl>")
end

function render_collection(bundle)
    validate_collection(bundle.index, bundle.reports)
    first_report = first(bundle.reports)
    groups = ordered_groups(first_report)
    source, run = bundle.index["source"], bundle.index["run"]
    io = IOBuffer()
    println(io, "<h1>Performance report</h1><p><strong>", html_escape(something(source["tag"], "Development or local build")),
        "</strong></p>")
    println(io, "<p>This report contains ", length(groups), " comparison tables and ", sum(length(report["cases"]) for report in bundle.reports), " measurements. Select an operation category and symmetry below to find the calculation you want to compare.</p>")
    println(io, "<p>First measurement timestamp (UTC): ", html_escape(run["measured_at_utc"]), ". Julia uses 1, 2, or 4 compute threads; the linear algebra backend and garbage collector each use 1 thread.</p>")
    get(source, "working_tree_dirty", false) && println(io, "<p class=\"notice\">These measurements include uncommitted changes in the source checkout.</p>")
    println(io, "<nav><a href=\"collection.json\">Download the raw data index</a>")
    for threads in THREADS
        id = configuration_id(threads)
        println(io, "<a href=\"configurations/$id/index.html\">Detailed report: $threads ", threads == 1 ? "thread" : "threads", "</a>")
    end
    println(io, "</nav><p><label for=\"metric\">Display metric: </label><select id=\"metric\"><option value=\"time\">Median execution time</option><option value=\"speedup\">Speedup relative to one thread</option><option value=\"bytes\">Total allocated bytes</option><option value=\"allocations\">Memory allocation count</option></select></p>")
    println(io, "<p class=\"muted\">Each row is a center bond dimension, including the full dimensions of symmetry multiplets, and each column is a thread configuration. Speedup compares the same operation and bond dimension against its single-thread measurement. Allocated bytes measure cumulative allocation, not peak memory.</p>")
    println(io, "<p>An ordinary matrix product state (MPS) has base tensors with 3 legs. A base in matrix product operator (MPO) form has 4 legs; these benchmarks use its additional local leg for purification. A tangent center may carry one further charge or component leg. Each operation below describes the tensor layout and operators it actually uses.</p>")
    cpu = first_report["environment"]["cpu"]
    println(io, "<p>Processor: ", html_escape(join(cpu["cpu_models"], ", ")),
        "; visible logical processors: ", cpu["logical_cpus_visible"], ".</p>")
    println(io, "<details><summary>Source version, hardware, and runtime settings</summary>")
    for (report, threads) in zip(bundle.reports, THREADS)
        println(io, "<h3>Runtime with $threads ", threads == 1 ? "thread" : "threads", "</h3>")
        render_facts(io, metadata_rows(report))
    end
    println(io, "<h3>Software versions</h3>")
    render_facts(io, package_rows(first_report))
    println(io, "</details>")
    println(io, "<nav aria-label=\"Operation categories\">")
    for section in unique(group[1][1] for group in groups)
        println(io, "<a href=\"#", section_anchor(section), "\">", html_escape(section_label(section)), "</a>")
    end
    println(io, "</nav>")
    lookups = [Dict(case["case_id"] => case for case in report["cases"]) for report in bundle.reports]
    last_section = last_symmetry = nothing
    for (key, cases) in groups
        section, symmetry, family, configuration, base_rank, center_rank = key
        if section != last_section
            println(io, "<h2 id=\"", section_anchor(section), "\">", html_escape(section_label(section)), "</h2><nav aria-label=\"Symmetries for ", html_escape(section_label(section)), "\">")
            for target in unique(group[1][2] for group in groups if group[1][1] == section)
                println(io, "<a href=\"#", symmetry_anchor(section, target), "\">", html_escape(symmetry_name(target)), "</a>")
            end
            println(io, "</nav>")
            last_section, last_symmetry = section, nothing
        end
        if symmetry != last_symmetry
            println(io, "<h3 id=\"", symmetry_anchor(section, symmetry), "\">", html_escape(symmetry_name(symmetry)), "</h3>")
            last_symmetry = symmetry
        end
        if section == "stages"
            println(io, "<details class=\"workload-stage\"><summary>", html_escape(workload_title(first(cases))), "</summary>")
        else
            println(io, "<h4>", html_escape(workload_title(first(cases))), "</h4>")
        end
        println(io, "<p>", html_escape(workload_description(first(cases))), "</p>")
        println(io, "<table><thead><tr><th>Center bond dimension</th><th>1 thread</th><th>2 threads</th><th>4 threads</th></tr></thead><tbody>")
        for case in cases
            p, id = case["parameters"], case["case_id"]
            println(io, "<tr><td>", p["actual_D"], "</td>")
            reference = case["median_time_ns"]
            for lookup in lookups
                value = get(lookup, id, nothing)
                if value === nothing
                    println(io, "<td>Not measured</td>")
                else
                    println(io, "<td data-time=\"", value["median_time_ns"], "\" data-reference=\"", reference,
                        "\" data-bytes=\"", value["allocated_bytes"], "\" data-allocations=\"", value["allocations"], "\">", time_text(value["median_time_ns"]), "</td>")
                end
            end
            println(io, "</tr>")
        end
        println(io, "</tbody></table><details><summary>Tensor layouts, dimensions, and sampling settings for all three input sizes</summary>")
        for case in cases
            println(io, "<h5>Center bond dimension = ", case["parameters"]["actual_D"], "</h5>")
            render_facts(io, workload_facts(case))
            for (lookup, threads) in zip(lookups, THREADS)
                measured = get(lookup, case["case_id"], nothing)
                measured === nothing && continue
                println(io, "<h5>Sampling with $threads ", threads == 1 ? "thread" : "threads", "</h5>")
                render_facts(io, measurement_rows(measured))
            end
        end
        println(io, "</details>")
        section == "stages" && println(io, "</details>")
    end
    return page("Performance report", String(take!(io)); script=METRIC_SCRIPT)
end

function render_collection_markdown(bundle)
    validate_collection(bundle.index, bundle.reports)
    io = IOBuffer()
    println(io, "# Performance report\n\nSource commit: `", bundle.index["source"]["commit_sha"], "`\n\nJulia uses 1, 2, or 4 compute threads; the linear algebra backend and garbage collector each use 1 thread.\n")
    println(io, "| Thread configuration | Measurements | Measurement timestamp (UTC) | Detailed report |\n| --- | ---: | --- | --- |")
    for (report, threads) in zip(bundle.reports, THREADS)
        println(io, "| $threads ", threads == 1 ? "thread" : "threads", " | ", length(report["cases"]), " | ", report["run"]["measured_at_utc"], " | [Input and sampling details](configurations/$(configuration_id(threads))/report.md) |")
    end
    println(io, "\nThe tables show median execution times for each center bond dimension, including the full dimensions of symmetry multiplets.\n")
    lookups = [Dict(case["case_id"]=>case for case in report["cases"]) for report in bundle.reports]
    last_section = last_symmetry = nothing
    escape = PerformanceReports.markdown_escape
    for (key, cases) in ordered_groups(first(bundle.reports))
        section, symmetry = key[1:2]
        if section != last_section
            println(io, "\n## ", escape(section_label(section)), "\n")
            last_section, last_symmetry = section, nothing
        end
        if symmetry != last_symmetry
            println(io, "\n### ", escape(symmetry_name(symmetry)), "\n")
            last_symmetry = symmetry
        end
        if section == "stages"
            println(io, "\n<details><summary>", html_escape(workload_title(first(cases))), "</summary>\n")
        else
            println(io, "\n#### ", escape(workload_title(first(cases))), "\n")
        end
        println(io, "\n", escape(workload_description(first(cases))), "\n")
        println(io, "| Center bond dimension | 1 thread | 2 threads | 4 threads |\n| ---: | ---: | ---: | ---: |")
        for case in cases
            p, id = case["parameters"], case["case_id"]
            values = [time_text(lookup[id]["median_time_ns"]) for lookup in lookups]
            println(io, "| ", p["actual_D"], " | ", join(values, " | "), " |")
        end
        section == "stages" && println(io, "\n</details>\n")
    end
    return String(take!(io))
end

function collection_files(bundle)
    validate_collection(bundle.index, bundle.reports)
    files = Dict("collection.json" => json_text(bundle.index), "index.html" => render_collection(bundle),
                 "report.md" => render_collection_markdown(bundle))
    for (configuration, report) in zip(bundle.index["configurations"], bundle.reports)
        path = configuration["report_path"]
        files[path] = json_text(report)
        files[joinpath(dirname(path), "index.html")] = render_report(report)
        files[joinpath(dirname(path), "report.md")] = render_markdown(report)
    end
    return files
end

function build_collection(path; output=dirname(abspath(path)))
    bundle = read_collection(path)
    files = collection_files(bundle)
    return write_build_files(files, output)
end

function write_build_files(files, output)
    # Preflight all owned output paths before writing. The input directory can be
    # reused, or JSON and self-contained HTML can be copied to a fresh output.
    output = abspath(output)
    islink(output) && error("HTML output root cannot be a symbolic link")
    isdir(output) && (output = realpath(output))
    for relative in keys(files)
        destination = abspath(joinpath(output, relative))
        current = destination
        while current != dirname(output)
            islink(current) && error("HTML output cannot follow symbolic links")
            ispath(current) && (current == destination ? !isfile(current) : !isdir(current)) && error("HTML output path collision")
            parent = dirname(current)
            parent == current && break
            current = parent
        end
    end
    for (relative, content) in files
        destination = joinpath(output, relative)
        mkpath(dirname(destination))
        write(destination, content)
    end
    return joinpath(abspath(output), "index.html")
end

end # module
