@testset "Rank-five identity action preserves purification and charge" begin
    M = FiniteMPSTangents
    rng = MersenneTwister(20260913)
    fixtures = (
        (P=ℂ^2,Q=ℂ^2,X=ℂ^3,VL=ℂ^3,VR=ℂ^4,WL=ℂ^2,WR=ℂ^5),
        (P=U1Spin.pspace,Q=Rep[U₁](1=>1),X=Rep[U₁](1=>1,2=>1),
         VL=Rep[U₁](q=>2 for q in -2:2),VR=Rep[U₁](q=>1 for q in -2:2),
         WL=Rep[U₁](q=>1 for q in -2:2),WR=Rep[U₁](q=>3 for q in -2:2)),
        (P=SU2Spin.pspace,Q=Rep[SU₂](1=>1),X=Rep[SU₂](1//2=>1,1=>1),
         VL=Rep[SU₂](j=>2 for j in 0:1//2:1),VR=Rep[SU₂](j=>1 for j in 0:1//2:1),
         WL=Rep[SU₂](j=>1 for j in 0:1//2:1),WR=Rep[SU₂](j=>3 for j in 0:1//2:1)),
    )
    function random_map(cod,dom)
        A=TensorMap{ComplexF64}(undef,cod,dom)
        for (_,block) in blocks(A)
            randn!(rng,block)
        end
        return A
    end
    for f in fixtures
        El=BilayerLeftTensor(random_map(f.WL⊗f.X,f.VL))
        Er=BilayerRightTensor(random_map(f.VR,f.X⊗f.WR))
        T=MPSTensor(random_map(f.VL⊗f.P,f.P⊗f.Q⊗f.VR))
        physical_identity=LocalOperator(id(ComplexF64,f.P),:identity,1,false,1.0)
        reference=M._action1(El,T,physical_identity,Er)
        @test norm(reference)>0
        @test space(reference.A)==(f.WL⊗f.P←f.P⊗f.Q⊗f.WR)
        for coefficient in (1.0,-0.3+0.7im,0.0)
            H=IdentityOperator(f.P,f.X,1,coefficient)
            result=M._action1(El,T,H,Er)
            @test numind(result)==5
            @test space(result.A)==space(reference.A)
            @test isapprox(result.A,coefficient*reference.A;atol=2e-12,rtol=2e-12)
            timed,_=M._action1(El,T,H,Er,true)
            @test isapprox(timed.A,result.A;atol=2e-12,rtol=2e-12)
        end
    end
end
