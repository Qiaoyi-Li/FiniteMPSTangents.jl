include("fixtures.jl")
include("chain_cases.jl")
include("observable_cases.jl")
include("environment_cases.jl")
include("mul_stage_cases.jl")

function benchmark_suite(config)
    return vcat(chain_cases(config),environment_cases(config),mul_stage_cases(config),observable_cases(config))
end
