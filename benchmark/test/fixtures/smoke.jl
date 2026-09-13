# Infrastructure demonstration only. This is not a FiniteMPSTangents workload
# and is never included by benchmark/benchmarks.jl or the publishing workflow.
function benchmark_suite()
    return [
        BenchmarkCase("scaffold/sum-v1", rng -> begin
            data = rand(rng, 256)
            (; benchmark=(@benchmarkable sum($data)))
        end; parameters=Dict("length" => 256), seconds=0.1, samples=20,
             description="Infrastructure smoke: sum a fixed input"),
        BenchmarkCase("scaffold/sort-v1", rng -> begin
            initial = rand(rng, 512)
            (; benchmark=(@benchmarkable sort!(data) setup=(data=copy($initial))))
        end; parameters=Dict("length" => 512),
             mutates=true, seconds=0.1, samples=20,
             description="Infrastructure smoke: reset mutable input per sample"),
    ]
end
