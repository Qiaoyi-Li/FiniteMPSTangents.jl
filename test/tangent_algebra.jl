@testset "Tangent construction and algebra" begin
    fixture = identity_fixture(3)
    state = fixture.state
    base = fixture.base
    tangent = fixture.tangent

    @test Center(state) == [1, 1]
    @test length(base.A) == length(base.Al) == length(base.Ar) == 3
    @test length(base.S) == 2
    @test tangent.base === base
    @test isassigned(tangent)
    @test norm(tangent) ≈ 1
    @test inner(tangent, tangent) ≈ norm(tangent)^2
    @test scalartype(tangent) === ComplexF64

    copied = partialcopy(tangent)
    @test copied.base === tangent.base
    @test all(copied.B[i] !== tangent.B[i] for i in eachindex(tangent.B))
    @test tangent_difference_norm(copied, tangent) < 1e-12

    allocated = similar(tangent)
    real_allocated = similar(tangent, Float64)
    @test allocated.base === tangent.base
    @test size(allocated.B) == size(tangent.B)
    @test scalartype(allocated) === ComplexF64
    @test scalartype(real_allocated) === Float64

    scaled = partialcopy(tangent)
    rmul!(scaled, 2)
    @test norm(scaled) ≈ 2 * norm(tangent)

    combined = partialcopy(tangent)
    add!(combined, scaled, 2, -1)
    @test tangent_difference_norm(combined, scaled_copy(tangent, 3)) < 1e-12

    normalized = partialcopy(scaled)
    normalize!(normalized)
    @test norm(normalized) ≈ 1

    projected = TangentMPS(base)
    orth!(projected; normalize=true)
    @test norm(projected) < 1e-12

    released = partialcopy(tangent)
    @test free!(released) === nothing
    @test !isassigned(released)
end
