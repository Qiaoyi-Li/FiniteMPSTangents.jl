@testset "Fermionic Z and mixed-rank behavior" begin
    L = 2
    physical = U1SpinlessFermion.pspace
    state = identityMPO(ComplexF64, L, physical)

    base = BaseMPS(state)
    base_with_z = BaseMPS(state; Z=U1SpinlessFermion.Z)
    base_with_z_vector = BaseMPS(state; Z=fill(U1SpinlessFermion.Z, L))
    @test all(
        norm(base_with_z.Ar[i] - base_with_z_vector.Ar[i]) < 1e-12
        for i in 1:L
    )

    tree = InteractionTree(L)
    addIntr!(
        tree,
        (U1SpinlessFermion.FdagF[2],),
        (1,),
        (true,),
        1.0;
        Z=U1SpinlessFermion.Z,
        name=(:F,),
    )
    operator = AutomataMPO(tree)

    rank_four = TangentMPS(base)
    rank_five = TangentMPS(operator, base_with_z)
    @test numind.(rank_four.B) == [4, 4]
    @test numind.(rank_five.B) == [5, 5]

    allocating_product = mul(
        operator,
        rank_four;
        isfermionic=true,
        Z=U1SpinlessFermion.Z,
    )
    @test tangent_difference_norm(allocating_product, rank_five) < 1e-12

    mixed_inner = inner(rank_four, rank_five)
    @test !(mixed_inner isa Number)
    @test numind(mixed_inner) == 1

    adjoint_base = adjoint(base_with_z)
    round_trip = adjoint(
        adjoint(rank_five; base=adjoint_base);
        base=base_with_z,
    )
    @test tangent_difference_norm(round_trip, rank_five) < 1e-12
end
