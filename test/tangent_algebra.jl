@testset "Tangent construction and algebra" begin
    fixture = identity_fixture(3)
    base = fixture.base
    tangent = fixture.tangent

    @test inner(tangent, tangent) ≈ norm(tangent)^2

    original_norm = norm(tangent)
    scaled = partialcopy(tangent)
    rmul!(scaled, 2)
    @test norm(scaled) ≈ 2 * original_norm

    combined = partialcopy(tangent)
    add!(combined, scaled, 2, -1)
    @test tangent_difference_norm(combined, scaled_copy(tangent, 3)) < 1e-12

    normalized = partialcopy(scaled)
    normalize!(normalized)
    @test norm(normalized) ≈ 1

    projected = TangentMPS(base)
    orth!(projected; normalize=true)
    @test norm(projected) < 1e-12
end
