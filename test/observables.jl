function _natural_state_term(Φ::TangentMPS{L}, insertion::Int) where L
    tensors = MPSTensor[
        deepcopy(
            site < insertion ? Φ.base.Al[site] :
            site == insertion ? Φ.B[site] : Φ.base.Ar[site],
        )
        for site in 1:L
    ]

    T = scalartype(Φ)
    rank = numind(tensors[1])
    @assert all(tensor -> numind(tensor) == rank, tensors)
    if rank == 3
        return MPS(tensors, [1, L], one(T))
    elseif rank == 4
        return MPO(tensors, [1, L], one(T))
    else
        error("the explicit natural-state oracle only supports rank-3 and rank-4 terms")
    end
end

function _dense_observable_value(
    bra::DenseMPS{L},
    ket::DenseMPS{L},
    operator::AbstractTensorMap,
    site::Int;
    name::Symbol,
    kwargs...,
) where L
    tree = ObservableTree(L)
    addObs!(tree, operator, site; name=name)
    calObs!(tree, bra, ket; kwargs...)
    return tree.Refs[string(name)][(site,)][]
end

function _dense_observable_value(
    bra::DenseMPS{L},
    ket::DenseMPS{L},
    operators::NTuple{N,AbstractTensorMap},
    sites::NTuple{N,Int};
    names::NTuple{N,Symbol},
    interaction_name::Symbol,
    kwargs...,
) where {L,N}
    tree = ObservableTree(L)
    addObs!(
        tree,
        operators,
        sites,
        ntuple(_ -> false, N);
        name=names,
        IntrName=interaction_name,
    )
    calObs!(tree, bra, ket; kwargs...)
    return tree.Refs[string(interaction_name)][sites][]
end

function _explicit_natural_observable(
    bra::TangentMPS{L},
    ket::TangentMPS{L},
    operator::AbstractTensorMap,
    site::Int;
    name::Symbol,
    kwargs...,
) where L
    value = zero(promote_type(scalartype(bra), scalartype(ket)))
    for bra_insertion in 1:L, ket_insertion in 1:L
        bra_term = _natural_state_term(bra, bra_insertion)
        ket_term = _natural_state_term(ket, ket_insertion)
        value += _dense_observable_value(
            bra_term,
            ket_term,
            operator,
            site;
            name=name,
            kwargs...,
        )
    end
    return value
end

function _explicit_natural_observable(
    bra::TangentMPS{L},
    ket::TangentMPS{L},
    operators::NTuple{N,AbstractTensorMap},
    sites::NTuple{N,Int};
    names::NTuple{N,Symbol},
    interaction_name::Symbol,
    kwargs...,
) where {L,N}
    value = zero(promote_type(scalartype(bra), scalartype(ket)))
    for bra_insertion in 1:L, ket_insertion in 1:L
        bra_term = _natural_state_term(bra, bra_insertion)
        ket_term = _natural_state_term(ket, ket_insertion)
        value += _dense_observable_value(
            bra_term,
            ket_term,
            operators,
            sites;
            names=names,
            interaction_name=interaction_name,
            kwargs...,
        )
    end
    return value
end

function _tangent_observable_value(
    bra::TangentMPS{L},
    ket::TangentMPS{L},
    operator::AbstractTensorMap,
    site::Int;
    name::Symbol,
    kwargs...,
) where L
    tree = ObservableTree(L)
    addObs!(tree, operator, site; name=name)
    if bra === ket
        calObs!(tree, bra; kwargs...)
    else
        calObs!(tree, bra, ket; kwargs...)
    end
    return tree.Refs[string(name)][(site,)][]
end

@testset "Tangent observables" begin
    @testset "Rank-4 MPO as a purified state" begin
        L = 2
        physical = NoSymSpinOneHalf.pspace
        state = identityMPO(ComplexF64, L, physical)
        tangent = TangentMPS(BaseMPS(state))

        identity_operator = id(physical)
        projector_up = TensorMap(
            ComplexF64[1 0; 0 0],
            physical,
            physical,
        )

        identity_value = _tangent_observable_value(
            tangent,
            tangent,
            identity_operator,
            2;
            name=:I,
        )
        identity_oracle = _explicit_natural_observable(
            tangent,
            tangent,
            identity_operator,
            2;
            name=:I,
        )
        @test identity_value ≈ identity_oracle
        @test identity_value ≈ inner(tangent, tangent)
        normalized_identity_value = _tangent_observable_value(
            tangent,
            tangent,
            identity_operator,
            2;
            name=:I,
            normalize=true,
        )
        @test normalized_identity_value ≈ identity_value / norm(tangent)^2

        projector_value = _tangent_observable_value(
            tangent,
            tangent,
            projector_up,
            2;
            name=:Pup,
        )
        projector_oracle = _explicit_natural_observable(
            tangent,
            tangent,
            projector_up,
            2;
            name=:Pup,
        )
        @test projector_value ≈ projector_oracle
        @test projector_value / identity_value ≈ 1 / 2
    end

    @testset "ObservableTree shared prefixes and suffixes" begin
        L = 3
        physical = NoSymSpinOneHalf.pspace
        tangent = TangentMPS(BaseMPS(identityMPO(ComplexF64, L, physical)))
        for site in 1:L
            reference = tangent.B[site].A
            tangent.B[site] = MPSTensor(TensorMap(
                randn,
                ComplexF64,
                codomain(reference),
                domain(reference),
            ))
        end
        orth!(tangent)

        operators = (NoSymSpinOneHalf.Sz, NoSymSpinOneHalf.Sz)
        names = (:Sz, :Sz)
        registrations = (
            ((1, 2), :Sz12),
            ((1, 3), :Sz13),
            ((2, 3), :Sz23),
        )

        tree = ObservableTree(L)
        for (sites, interaction_name) in registrations
            addObs!(
                tree,
                operators,
                sites,
                (false, false);
                name=names,
                IntrName=interaction_name,
            )
        end
        calObs!(tree, tangent)

        for (sites, interaction_name) in registrations
            oracle = _explicit_natural_observable(
                tangent,
                tangent,
                operators,
                sites;
                names=names,
                interaction_name=interaction_name,
            )
            @test tree.Refs[string(interaction_name)][sites][] ≈ oracle
        end
    end

    @testset "Rank-5 U(1) charge and nontrivial observable auxiliary" begin
        L = 4
        physical = U1SpinlessFermion.pspace
        state = identityMPO(ComplexF64, L, physical)
        base = BaseMPS(state; Z=U1SpinlessFermion.Z)

        interaction_tree = InteractionTree(L)
        addIntr!(
            interaction_tree,
            (U1SpinlessFermion.FdagF[2],),
            (1,),
            (true,),
            1.0;
            Z=U1SpinlessFermion.Z,
            name=(:F,),
        )
        tangent = TangentMPS(AutomataMPO(interaction_tree), base)
        @test all(tensor -> numind(tensor) == 5, tangent.B)

        value = _tangent_observable_value(
            tangent,
            tangent,
            id(physical),
            1;
            name=:I,
        )
        @test value ≈ inner(tangent, tangent)

        operators = U1SpinlessFermion.ΔdagΔ
        @test map(operator -> (numout(operator), numin(operator)), operators) ==
              ((1, 2), (2, 2), (2, 2), (2, 1))
        @test !istrivial(domain(operators[1])[end])

        sites = (1, 2, 3, 4)
        tree = ObservableTree(L)
        addObs!(
            tree,
            operators,
            sites,
            (true, true, true, true);
            Z=U1SpinlessFermion.Z,
            name=(:Δdag₁, :Δdag₂, :Δ₁, :Δ₂),
            IntrName=:ΔdagΔ,
        )
        registered_partitions = map(tree.Ops) do site_operators
            operator = only(site_operators)
            (numout(operator.A), numin(operator.A))
        end
        @test registered_partitions == [(1, 2), (2, 2), (2, 2), (2, 1)]
        calObs!(tree, tangent)
        auxiliary_value = tree.Refs["ΔdagΔ"][sites][]

        @test auxiliary_value isa Number
        @test isfinite(abs(auxiliary_value))
    end

    @testset "Different SU(2) bra and ket with a fused left boundary" begin
        L = 2
        physical = SU2Spin.pspace
        bulk_space = Rep[SU₂](spin => 1 for spin in 0:1//2:1)

        bra_state = randMPS(ComplexF64, L, physical, bulk_space)
        operator_space = codomain(SU2Spin.SS[2])[1]
        bra_boundary_space = codomain(bra_state[1])[1]
        ket_boundary_space = fuse(operator_space, bra_boundary_space)
        ket_state = randMPS(
            ComplexF64,
            fill(physical, L),
            vcat(ket_boundary_space, fill(bulk_space, L - 1)),
        )

        fusion_isometry = isometry(
            ket_boundary_space,
            operator_space ⊗ bra_boundary_space,
        )
        El = permute(fusion_isometry', ((2, 1), (3,)))

        bra = TangentMPS(BaseMPS(bra_state))
        ket = TangentMPS(BaseMPS(ket_state))

        dense_value = _dense_observable_value(
            bra_state,
            ket_state,
            SU2Spin.SS[1],
            1;
            name=:S,
            El=El,
        )
        tangent_value = _tangent_observable_value(
            bra,
            ket,
            SU2Spin.SS[1],
            1;
            name=:S,
            El=El,
        )
        wrapped_boundary_value = _tangent_observable_value(
            bra,
            ket,
            SU2Spin.SS[1],
            1;
            name=:S,
            El=LocalLeftTensor(El),
        )
        explicit_value = _explicit_natural_observable(
            bra,
            ket,
            SU2Spin.SS[1],
            1;
            name=:S,
            El=El,
        )

        @test tangent_value ≈ dense_value
        @test tangent_value ≈ explicit_value
        @test wrapped_boundary_value ≈ tangent_value
    end
end
