@testset "Rank-four identity environments preserve auxiliary bonds" begin
    M = FiniteMPSTangents
    rng = MersenneTwister(0x1de4_2026)
    fixtures = (
        (name="U1", physical=Rep[U₁](-1//2 => 1, 1//2 => 1),
         left_a=Rep[U₁](-1 => 2, 0 => 3, 1 => 1), right_a=Rep[U₁](-1 => 1, 0 => 1, 1 => 1, 2 => 1),
         left_b=Rep[U₁](-2 => 1, -1 => 1, 0 => 1, 1 => 2), right_b=Rep[U₁](-1 => 1, 0 => 2, 1 => 2, 2 => 2),
         auxiliary=Rep[U₁](1 => 1, 2 => 1)),
        (name="SU2", physical=Rep[SU₂](1//2 => 1),
         left_a=Rep[SU₂](0 => 2, 1//2 => 1), right_a=Rep[SU₂](0 => 1, 1//2 => 2, 1 => 1),
         left_b=Rep[SU₂](0 => 1, 1//2 => 1, 1 => 1), right_b=Rep[SU₂](0 => 2, 1//2 => 1, 1 => 2),
         auxiliary=Rep[SU₂](1//2 => 1, 1 => 1)))
    for f in fixtures
        @testset "$(f.name)" begin
            P, Q, X = f.physical, f.physical, f.auxiliary
            @test dim(f.left_a) != dim(f.right_a)
            @test dim(f.left_b) != dim(f.right_b)
            f.name == "U1" && @test X != dual(X)
            function random_map(cod, dom)
                tensor = TensorMap(zeros, ComplexF64, cod, dom)
                for (_, block) in blocks(tensor)
                    randn!(rng, block)
                end
                return tensor
            end
            A = MPSTensor(random_map(f.left_a ⊗ P, Q ⊗ f.right_a))
            B = MPSTensor(random_map(f.left_b ⊗ P, Q ⊗ f.right_b))
            environments = (
                (push=M._pushright, env=BilayerLeftTensor(random_map(f.left_a ⊗ X, f.left_b)),
                 expected=f.right_a ⊗ X ← f.right_b),
                (push=M._pushright, env=BilayerLeftTensor(random_map(f.left_a, f.left_b ⊗ X)),
                 expected=f.right_a ← f.right_b ⊗ X),
                (push=M._pushleft, env=BilayerRightTensor(random_map(X ⊗ f.right_b, f.right_a)),
                 expected=X ⊗ f.left_b ← f.left_a),
                (push=M._pushleft, env=BilayerRightTensor(random_map(f.right_b, X ⊗ f.right_a)),
                 expected=f.left_b ← X ⊗ f.left_a))
            physical_identity = IdentityOperator(P, X, 1, 1.0)
            purification_identity = IdentityOperator(Q, oneunit(Q), 1, 1.0)
            for entry in environments
                @test norm(entry.env.A) > 0
                # The upstream two-layer contraction applies a separate identity
                # to the physical and purification legs, keeping the open MPO bond.
                oracle = entry.push(entry.env, A', physical_identity, B, purification_identity).A
                @test norm(oracle) > 0
                @test space(oracle) == entry.expected
                for coefficient in (1.0, -0.37 + 0.61im, 0.0)
                    H = IdentityOperator(P, X, 1, coefficient)
                    result = entry.push(entry.env, A', H, B)
                    @test space(result.A) == entry.expected
                    @test isapprox(result.A, coefficient * oracle; rtol=2e-12, atol=2e-12)
                end
                timed, _ = entry.push(entry.env, A', physical_identity, B, true)
                @test isapprox(timed.A, oracle; rtol=2e-12, atol=2e-12)
            end
        end
    end
end
