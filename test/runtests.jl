using FiniteMPSTangents
using FiniteMPS
using Random
using Test

FiniteMPS.set_num_threads_action(1)
Random.seed!(0x666d_7073)

include("helpers.jl")

@testset "FiniteMPSTangents.jl" begin
    include("tangent_algebra.jl")
    include("multiplication.jl")
    include("fermionic.jl")
end
