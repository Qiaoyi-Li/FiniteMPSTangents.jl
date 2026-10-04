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
        @test identity_value ≈ inner(tangent, tangent)
        projector_value = _tangent_observable_value(
            tangent,
            tangent,
            projector_up,
            2;
            name=:Pup,
        )
        @test projector_value / identity_value ≈ 1 / 2
    end

    @testset "ObservableTree shared prefixes and suffixes" begin
        L = 3
        physical = NoSymSpinOneHalf.pspace
        tangent = TangentMPS(BaseMPS(identityMPO(ComplexF64, L, physical)))
        for site in 1:L
            reference = tangent.B[site].A
            tangent.B[site] = MPSTensor(randn(ComplexF64, codomain(reference), domain(reference)))
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
        expected = Dict(
            interaction_name => _explicit_natural_observable(
                tangent, tangent, operators, sites; names=names,
                interaction_name=interaction_name,
            )
            for (sites, interaction_name) in registrations
        )
        execution_options = (
            (; alg=LayeredTreeEval(ntasks=1)),
            (; disk=true, maxsize=1),
            (; disk=true, maxsize=0),
        )
        for options in execution_options
            calObs!(tree, tangent; options...)
            for (sites, interaction_name) in registrations
                @test tree.Refs[string(interaction_name)][sites][] ≈ expected[interaction_name]
            end
        end
    end

    @testset "Rank-5 U(1) charge and nontrivial observable auxiliary" begin
        L = 4
        physical = U1SpinlessFermion.pspace
        state = identityMPO(ComplexF64, L, physical)
        base = BaseMPS(state; Z=U1SpinlessFermion.Z)

        interaction_tree = InteractionTree(L)
        for (site, name) in ((1, :F1), (4, :F4))
            addIntr!(
                interaction_tree,
                (U1SpinlessFermion.FdagF[2],),
                (site,),
                (true,),
                1.0;
                Z=U1SpinlessFermion.Z,
                name=(name,),
            )
        end
        tangent = TangentMPS(AutomataMPO(interaction_tree), base)

        value = _tangent_observable_value(
            tangent,
            tangent,
            id(physical),
            1;
            name=:I,
        )
        @test value ≈ inner(tangent, tangent)

        operators = U1SpinlessFermion.ΔdagΔ

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
        # The short hopping string propagates its auxiliary leg through
        # IdentityOperator sites. The equivalent long form makes that
        # propagation explicit with two nontrivial O22 operators, giving a
        # nonzero numerical oracle for the O22 kernels on rank-5 tangents.
        Fdag, F = U1SpinlessFermion.FdagF
        hopping_auxiliary = domain(Fdag, numin(Fdag))
        auxiliary_identity = permute(
            id(physical ⊗ hopping_auxiliary),
            ((2, 1), (3, 4)),
        )
        propagated_hopping = (Fdag, auxiliary_identity, auxiliary_identity, F)
        addObs!(
            tree,
            U1SpinlessFermion.FdagF,
            (1, 4),
            (true, true);
            Z=U1SpinlessFermion.Z,
            name=(:Fdag, :F),
            IntrName=:hopping_short,
        )
        addObs!(
            tree,
            propagated_hopping,
            sites,
            (true, false, false, true);
            Z=U1SpinlessFermion.Z,
            name=(:Fdag, :aux2, :aux3, :F),
            IntrName=:hopping_O22,
        )

        addObs!(tree, U1SpinlessFermion.FFdag, (4, 1), (true, true);
            Z=U1SpinlessFermion.Z, name=(:F, :Fdag), IntrName=:reversed_hopping)

        calObs!(tree, tangent)
        @test isapprox(tree.Refs["ΔdagΔ"][sites][], 0; atol=1e-12)
        @test tree.Refs["hopping_short"][(1, 4)][] ≈ -0.25
        @test tree.Refs["hopping_O22"][sites][] ≈ -0.25
        @test tree.Refs["reversed_hopping"][(4, 1)][] ≈ 0.25
    end

    @testset "SU(2) tangent-center charge closes a left-open observable" begin
        L = 4
        physical = SU2Spin.pspace
        boundary_space = Rep[SU₂](0 => 1)
        bulk_space = Rep[SU₂](spin => 1 for spin in 0:1//2:1)
        state = randMPS(
            ComplexF64,
            fill(physical, L),
            vcat(boundary_space, fill(bulk_space, L - 1)),
        )
        base = BaseMPS(state)
        bra = TangentMPS(base)

        function spin_tangent(site)
            action_tree = InteractionTree(L)
            addIntr!(
                action_tree,
                SU2Spin.SS[2],
                site,
                1.0;
                name=:S,
            )
            return TangentMPS(AutomataMPO(action_tree), base)
        end

        ket_site = 2
        ket = spin_tangent(ket_site)
        probes = [spin_tangent(site) for site in 1:L]

        # A scalar branch has no nontrivial left auxiliary and therefore stays
        # on the original charged-bra/charged-ket state-machine path.
        scalar_tree = ObservableTree(L)
        addObs!(scalar_tree, id(physical), 1; name=:I)
        calObs!(scalar_tree, probes[1], probes[2]; alg=LayeredTreeEval(ntasks=1))
        @test scalar_tree.Refs["I"][(1,)][] ≈ inner(probes[1], probes[2])

        tree = ObservableTree(L)
        for site in 1:L
            addObs!(tree, SU2Spin.SS[1], site; name=:S)
        end
        snapshot() = [tree.Refs["S"][(site,)][] for site in 1:L]

        # No El is supplied: addObs! has normalized the single unmatched
        # auxiliary to the left edge, and it must close against ket.B's charge.
        calObs!(tree, bra, ket)
        values = snapshot()
        @test values[ket_site] ≈ (3 / 4) * inner(bra, bra)

        # For distinct sites the same scalar is the ordinary closed SS
        # expectation value, giving an oracle independent of tangent calObs!.
        closed_tree = ObservableTree(L)
        for site in (1, 3, 4)
            sites = minmax(site, ket_site)
            addObs!(
                closed_tree,
                SU2Spin.SS,
                sites,
                (false, false);
                name=(:S, :S),
            )
        end
        FiniteMPS.calObs!(closed_tree, state; alg=LayeredTreeEval(ntasks=1))
        for site in (1, 3, 4)
            sites = minmax(site, ket_site)
            @test values[site] ≈ closed_tree.Refs["SS"][sites][]
        end

        # Complex Fourier coefficients must remain linear in the ket.
        momentum = 2π / 5
        coefficients = [
            cis(momentum * site) / sqrt(L)
            for site in 1:L
        ]
        momentum_tree = InteractionTree(L)
        for site in 1:L
            addIntr!(
                momentum_tree,
                SU2Spin.SS[2],
                site,
                coefficients[site];
                name=:S,
                IntrName=:Sk,
            )
        end
        momentum_ket = TangentMPS(AutomataMPO(momentum_tree), base)

        momentum_expected = [
            sum(
                coefficients[source] * inner(probes[probe], probes[source])
                for source in 1:L
            )
            for probe in 1:L
        ]
        calObs!(tree, bra, momentum_ket; disk=true, maxsize=1)
        @test snapshot() ≈ momentum_expected
    end

    @testset "Rank-5 tangent-center charge closes a left-open observable" begin
        L = 2
        physical = SU2Spin.pspace
        base = BaseMPS(identityMPO(ComplexF64, L, physical))
        bra = TangentMPS(base)

        function spin_tangent(site)
            action_tree = InteractionTree(L)
            addIntr!(
                action_tree,
                SU2Spin.SS[2],
                site,
                1.0;
                name=:S,
            )
            return TangentMPS(AutomataMPO(action_tree), base)
        end

        ket = spin_tangent(1)
        probes = [spin_tangent(site) for site in 1:L]
        expected = [inner(probe, ket) for probe in probes]

        tree = ObservableTree(L)
        for site in 1:L
            addObs!(tree, SU2Spin.SS[1], site; name=:S)
        end
        snapshot() = [tree.Refs["S"][(site,)][] for site in 1:L]

        calObs!(tree, bra, ket)
        @test snapshot() ≈ expected
    end

    @testset "Explicit fused SU(2) left-boundary compatibility" begin
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

        tangent_value = _tangent_observable_value(
            bra,
            ket,
            SU2Spin.SS[1],
            1;
            name=:S,
            El=El,
            alg=LayeredTreeEval(ntasks=1),
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
            alg=LayeredTreeEval(ntasks=1),
        )

        @test tangent_value ≈ explicit_value
        @test wrapped_boundary_value ≈ tangent_value
    end

    @testset "Complex bra/ket and natural-state reference" begin
        for L in (1, 3), purified in (false, true)
            physical = NoSymSpinOneHalf.pspace
            make_state(T) = purified ? identityMPO(T, L, physical) :
                randMPS(T, L, physical, ℂ^2)
            bra_type = L == 3 && !purified ? Float64 : ComplexF64
            ket_type = L == 3 && purified ? Float64 : ComplexF64
            bra = TangentMPS(BaseMPS(make_state(bra_type)))
            ket = TangentMPS(BaseMPS(make_state(ket_type)))
            for tangent in (bra, ket), site in 1:L
                tensor = tangent.B[site].A
                tangent.B[site] = MPSTensor(randn(scalartype(tangent), codomain(tensor), domain(tensor)))
            end
            operator = NoSymSpinOneHalf.Sz
            expected = _explicit_natural_observable(bra, ket, operator, 1; name=:Sz)
            actual = _tangent_observable_value(bra, ket, operator, 1; name=:Sz)
            @test isapprox(actual, expected; atol=1e-12, rtol=1e-10)
            if L == 3 && purified
                normalized = _tangent_observable_value(bra, ket, operator, 1;
                                                       name=:Sz, normalize=true)
                @test isapprox(normalized, expected / (norm(bra) * norm(ket));
                               atol=1e-12, rtol=1e-10)
            end
        end
    end

    @testset "Failed observable evaluation invalidates results" begin
        L = 3
        physical = NoSymSpinOneHalf.pspace
        tangent = TangentMPS(BaseMPS(identityMPO(ComplexF64, L, physical)))
        invalid_operator = randn(ComplexF64, ℂ^3, ℂ^3)
        tree = ObservableTree(L)
        addObs!(tree, id(physical), 1; name=:good)
        calObs!(tree, tangent)
        addObs!(tree, invalid_operator, 2; pspace=physical, name=:bad)

        @test_throws Exception calObs!(tree, tangent; disk=true, maxsize=1)
        @test all(isnan(ref[]) for refs in values(tree.Refs) for ref in values(refs))
    end
end
