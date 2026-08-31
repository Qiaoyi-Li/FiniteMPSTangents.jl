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
        FiniteMPS.merge!(tree)
        left_levels = FiniteMPSTangents._observable_levels(tree.RootL)
        right_levels = FiniteMPSTangents._observable_levels(tree.RootR)
        @test maximum(length, left_levels) > 1
        @test maximum(length, right_levels) > 1

        serial_timer = calObs!(tree, tangent; serial=true)
        serial_values = Dict(
            interaction_name => tree.Refs[string(interaction_name)][sites][]
            for (sites, interaction_name) in registrations
        )

        threaded_timer = calObs!(
            tree,
            tangent;
            serial=false,
            ntasks=max(2, Threads.nthreads()),
        )
        threaded_values = Dict(
            interaction_name => tree.Refs[string(interaction_name)][sites][]
            for (sites, interaction_name) in registrations
        )

        single_task_timer = calObs!(tree, tangent; serial=false, ntasks=1)
        single_task_values = Dict(
            interaction_name => tree.Refs[string(interaction_name)][sites][]
            for (sites, interaction_name) in registrations
        )

        default_timer = calObs!(tree, tangent)
        default_values = Dict(
            interaction_name => tree.Refs[string(interaction_name)][sites][]
            for (sites, interaction_name) in registrations
        )

        disk_serial_timer = calObs!(
            tree,
            tangent;
            disk=true,
            serial=true,
            maxsize=1,
        )
        disk_serial_values = Dict(
            interaction_name => tree.Refs[string(interaction_name)][sites][]
            for (sites, interaction_name) in registrations
        )

        disk_threaded_timer = calObs!(
            tree,
            tangent;
            disk=true,
            serial=false,
            ntasks=Threads.nthreads() + 2,
            maxsize=1,
        )
        disk_threaded_values = Dict(
            interaction_name => tree.Refs[string(interaction_name)][sites][]
            for (sites, interaction_name) in registrations
        )

        disk_default_timer = calObs!(tree, tangent; disk=true)
        disk_default_values = Dict(
            interaction_name => tree.Refs[string(interaction_name)][sites][]
            for (sites, interaction_name) in registrations
        )

        disk_uncached_timer = calObs!(
            tree,
            tangent;
            disk=true,
            serial=true,
            maxsize=0,
        )
        disk_uncached_values = Dict(
            interaction_name => tree.Refs[string(interaction_name)][sites][]
            for (sites, interaction_name) in registrations
        )

        @test serial_timer isa TimerOutput
        @test threaded_timer isa TimerOutput
        @test single_task_timer isa TimerOutput
        @test default_timer isa TimerOutput
        @test disk_serial_timer isa TimerOutput
        @test disk_threaded_timer isa TimerOutput
        @test disk_default_timer isa TimerOutput
        @test disk_uncached_timer isa TimerOutput
        @test all(
            threaded_values[name] ≈ serial_values[name]
            for (_, name) in registrations
        )
        @test all(
            single_task_values[name] ≈ serial_values[name]
            for (_, name) in registrations
        )
        @test all(
            default_values[name] ≈ serial_values[name]
            for (_, name) in registrations
        )
        @test all(
            disk_serial_values[name] ≈ serial_values[name]
            for (_, name) in registrations
        )
        @test all(
            disk_threaded_values[name] ≈ serial_values[name]
            for (_, name) in registrations
        )
        @test all(
            disk_default_values[name] ≈ serial_values[name]
            for (_, name) in registrations
        )
        @test all(
            disk_uncached_values[name] ≈ serial_values[name]
            for (_, name) in registrations
        )
        @test_throws ArgumentError calObs!(tree, tangent; ntasks=0)
        @test_throws ArgumentError calObs!(tree, tangent; disk=true, maxsize=-1)

        for (sites, interaction_name) in registrations
            oracle = _explicit_natural_observable(
                tangent,
                tangent,
                operators,
                sites;
                names=names,
                interaction_name=interaction_name,
            )
            @test default_values[interaction_name] ≈ oracle
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

        # The short hopping string propagates its auxiliary leg through
        # IdentityOperator sites. The equivalent long form makes that
        # propagation explicit with two nontrivial O22 operators, giving a
        # nonzero numerical oracle for the O22 kernels on rank-5 tangents.
        Fdag, F = U1SpinlessFermion.FdagF
        hopping_auxiliary = domain(Fdag)[end]
        auxiliary_identity = permute(
            id(physical ⊗ hopping_auxiliary),
            ((2, 1), (3, 4)),
        )
        propagated_hopping = (Fdag, auxiliary_identity, auxiliary_identity, F)
        @test map(
            operator -> (numout(operator), numin(operator)),
            propagated_hopping,
        ) == ((1, 2), (2, 2), (2, 2), (2, 1))
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

        for site in 1:L
            addObs!(tree, id(physical), site; name=Symbol("I$(site)"))
        end
        FiniteMPS.merge!(tree)
        @test all(>(1), treewidth(tree))

        snapshot() = (
            auxiliary=tree.Refs["ΔdagΔ"][sites][],
            hopping_short=tree.Refs["hopping_short"][(1, 4)][],
            hopping_O22=tree.Refs["hopping_O22"][sites][],
            identities=[tree.Refs["I$(site)"][(site,)][] for site in 1:L],
        )

        calObs!(tree, tangent; serial=true)
        serial_snapshot = snapshot()
        calObs!(tree, tangent)
        threaded_snapshot = snapshot()
        calObs!(tree, tangent; disk=true, serial=true, maxsize=1)
        disk_serial_snapshot = snapshot()
        calObs!(
            tree,
            tangent;
            disk=true,
            serial=false,
            ntasks=max(2, Threads.nthreads()),
            maxsize=1,
        )
        disk_threaded_snapshot = snapshot()

        @test serial_snapshot.auxiliary isa Number
        @test isfinite(abs(serial_snapshot.auxiliary))
        @test serial_snapshot.hopping_short ≈ -0.25
        @test serial_snapshot.hopping_O22 ≈ serial_snapshot.hopping_short
        @test all(value -> value ≈ inner(tangent, tangent), serial_snapshot.identities)
        for candidate in (
            threaded_snapshot,
            disk_serial_snapshot,
            disk_threaded_snapshot,
        )
            @test candidate.auxiliary ≈ serial_snapshot.auxiliary
            @test candidate.hopping_short ≈ serial_snapshot.hopping_short
            @test candidate.hopping_O22 ≈ serial_snapshot.hopping_O22
            @test all(isapprox.(candidate.identities, serial_snapshot.identities))
        end
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

        @test numind.(bra.base.Al) == fill(3, L)
        @test numind.(bra.base.Ar) == fill(3, L)
        @test numind.(bra.B) == fill(3, L)
        @test numind.(ket.base.Al) == fill(3, L)
        @test numind.(ket.base.Ar) == fill(3, L)
        @test numind.(ket.B) == fill(4, L)

        # A scalar branch has no nontrivial left auxiliary and therefore stays
        # on the original charged-bra/charged-ket state-machine path.
        scalar_tree = ObservableTree(L)
        addObs!(scalar_tree, id(physical), 1; name=:I)
        calObs!(scalar_tree, probes[1], probes[2]; serial=true)
        @test scalar_tree.Refs["I"][(1,)][] ≈ inner(probes[1], probes[2])

        tree = ObservableTree(L)
        for site in 1:L
            addObs!(tree, SU2Spin.SS[1], site; name=:S)
        end
        expected = [inner(probe, ket) for probe in probes]
        snapshot() = [tree.Refs["S"][(site,)][] for site in 1:L]

        # No El is supplied: addObs! has normalized the single unmatched
        # auxiliary to the left edge, and it must close against ket.B's charge.
        calObs!(tree, bra, ket; serial=true)
        serial_values = snapshot()
        calObs!(tree, bra, ket)
        threaded_values = snapshot()
        calObs!(tree, bra, ket; disk=true, serial=true, maxsize=1)
        disk_serial_values = snapshot()
        calObs!(tree, bra, ket; disk=true, maxsize=1)
        disk_threaded_values = snapshot()

        @test all(value -> value isa Number, serial_values)
        @test serial_values ≈ expected
        @test threaded_values ≈ expected
        @test disk_serial_values ≈ expected
        @test disk_threaded_values ≈ expected
        @test serial_values[ket_site] ≈ (3 / 4) * inner(bra, bra)

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
        FiniteMPS.calObs!(closed_tree, state; serial=true)
        for site in (1, 3, 4)
            sites = minmax(site, ket_site)
            @test serial_values[site] ≈ closed_tree.Refs["SS"][sites][]
        end

        # A momentum-space spin operator is a genuinely multi-term charged
        # MPO. Its complex Fourier phases must remain linear in the ket while
        # every registered real-space Sᵢ closes the same charge leg.
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
        @test numind.(momentum_ket.base.Al) == fill(3, L)
        @test numind.(momentum_ket.base.Ar) == fill(3, L)
        @test numind.(momentum_ket.B) == fill(4, L)

        explicit_momentum_ket = scaled_copy(probes[1], coefficients[1])
        for site in 2:L
            add!(explicit_momentum_ket, probes[site], coefficients[site])
        end
        @test tangent_difference_norm(momentum_ket, explicit_momentum_ket) < 1e-10

        momentum_expected = [
            sum(
                coefficients[source] * inner(probes[probe], probes[source])
                for source in 1:L
            )
            for probe in 1:L
        ]
        @test [inner(probe, momentum_ket) for probe in probes] ≈ momentum_expected
        calObs!(tree, bra, momentum_ket; serial=true)
        momentum_serial_values = snapshot()
        calObs!(tree, bra, momentum_ket; disk=true, maxsize=1)
        momentum_disk_threaded_values = snapshot()

        @test all(value -> value isa Number, momentum_serial_values)
        @test momentum_serial_values ≈ momentum_expected
        @test momentum_disk_threaded_values ≈ momentum_expected
        conjugated_oracle = [
            sum(
                conj(coefficients[source]) * inner(probes[probe], probes[source])
                for source in 1:L
            )
            for probe in 1:L
        ]
        @test maximum(abs.(momentum_serial_values .- conjugated_oracle)) > 1e-3
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

        @test numind.(bra.base.Al) == fill(4, L)
        @test numind.(bra.base.Ar) == fill(4, L)
        @test numind.(bra.B) == fill(4, L)
        @test numind.(ket.base.Al) == fill(4, L)
        @test numind.(ket.base.Ar) == fill(4, L)
        @test numind.(ket.B) == fill(5, L)

        tree = ObservableTree(L)
        for site in 1:L
            addObs!(tree, SU2Spin.SS[1], site; name=:S)
        end
        snapshot() = [tree.Refs["S"][(site,)][] for site in 1:L]

        calObs!(tree, bra, ket; serial=true)
        serial_values = snapshot()
        calObs!(tree, bra, ket; disk=true, maxsize=1)
        disk_threaded_values = snapshot()

        @test all(value -> value isa Number, serial_values)
        @test serial_values ≈ expected
        @test disk_threaded_values ≈ expected
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
        @test (numout(El), numin(El)) == (2, 1)

        bra = TangentMPS(BaseMPS(bra_state))
        ket = TangentMPS(BaseMPS(ket_state))

        dense_value = _dense_observable_value(
            bra_state,
            ket_state,
            SU2Spin.SS[1],
            1;
            name=:S,
            El=El,
            serial=true,
        )
        serial_tangent_value = _tangent_observable_value(
            bra,
            ket,
            SU2Spin.SS[1],
            1;
            name=:S,
            El=El,
            serial=true,
        )
        threaded_tangent_value = _tangent_observable_value(
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
        disk_boundary_value = _tangent_observable_value(
            bra,
            ket,
            SU2Spin.SS[1],
            1;
            name=:S,
            El=El,
            disk=true,
            maxsize=1,
        )
        explicit_value = _explicit_natural_observable(
            bra,
            ket,
            SU2Spin.SS[1],
            1;
            name=:S,
            El=El,
            serial=true,
        )

        @test serial_tangent_value ≈ dense_value
        @test serial_tangent_value ≈ explicit_value
        @test threaded_tangent_value ≈ serial_tangent_value
        @test wrapped_boundary_value ≈ serial_tangent_value
        @test disk_boundary_value ≈ serial_tangent_value
    end

    @testset "Ready-node scheduling and disk-store cleanup" begin
        oversubscribed_ntasks = Threads.nthreads() + 2
        expected_workers = oversubscribed_ntasks - 1
        oversubscribed_started = Threads.Atomic{Int}(0)
        oversubscribed_finished = Threads.Atomic{Int}(0)
        oversubscribed_process = function(label, emit_child)
            if label === :root
                for child in 1:expected_workers
                    emit_child(child)
                end
                return nothing
            end

            Threads.atomic_add!(oversubscribed_started, 1)
            deadline = time() + 5
            while oversubscribed_started[] < expected_workers
                time() > deadline && error(
                    "ntasks - 1 workers were not allowed to oversubscribe Julia threads",
                )
                yield()
            end
            Threads.atomic_add!(oversubscribed_finished, 1)
            return nothing
        end
        FiniteMPSTangents._observable_walk_ready!(
            oversubscribed_process,
            (_, _) -> nothing,
            :root,
            expected_workers + 1;
            threaded=true,
            ntasks=oversubscribed_ntasks,
        )
        @test oversubscribed_started[] == expected_workers
        @test oversubscribed_finished[] == expected_workers

        if Threads.nthreads() > 1
            slow_started = Threads.Atomic{Bool}(false)
            slow_finished = Threads.Atomic{Bool}(false)
            crossed_early = Threads.Atomic{Bool}(false)
            process_node = function(label, emit_child)
                if label === :root
                    emit_child(:fast)
                    emit_child(:slow)
                elseif label === :fast
                    emit_child(:grandchild)
                elseif label === :slow
                    slow_started[] = true
                    deadline = time() + 5
                    while !crossed_early[]
                        time() > deadline && error("grandchild waited for its slow uncle")
                        yield()
                    end
                    slow_finished[] = true
                elseif label === :grandchild
                    deadline = time() + 5
                    while !slow_started[]
                        time() > deadline && error("slow sibling did not start")
                        yield()
                    end
                    !slow_finished[] && (crossed_early[] = true)
                end
                return nothing
            end
            FiniteMPSTangents._observable_walk_ready!(
                process_node,
                (_, _) -> nothing,
                :root,
                4;
                threaded=true,
                ntasks=3,
            )

            @test slow_finished[]
            @test crossed_early[]
        end

        tree = ObservableTree(3)
        physical = NoSymSpinOneHalf.pspace
        for site in 1:3
            addObs!(tree, id(physical), site; name=Symbol("cache_I$(site)"))
        end
        FiniteMPS.merge!(tree)
        left_levels = FiniteMPSTangents._observable_levels(tree.RootL)
        right_levels = FiniteMPSTangents._observable_levels(tree.RootR)
        left_nodes = vcat(left_levels...)
        right_nodes = vcat(right_levels...)
        @test length(left_nodes) >= 5
        @test length(right_nodes) >= 2

        normal_directory = Ref("")
        FiniteMPSTangents._observable_with_store(
            left_levels,
            right_levels;
            disk=true,
            maxsize=2,
        ) do store
            normal_directory[] = store.directory
            @test isdir(store.directory)

            a, b, c, d, e = left_nodes[1:5]
            FiniteMPSTangents._observable_store!(
                store,
                a,
                FiniteMPSTangents.ObservableEnv4(:a),
            )
            FiniteMPSTangents._observable_store!(
                store,
                b,
                FiniteMPSTangents.ObservableEnv4(:b),
            )
            @test !ispath(store.paths[a])
            @test !ispath(store.paths[b])

            # A hit refreshes a, so inserting c evicts b rather than a.
            @test FiniteMPSTangents._observable_load(store, a).e00 === :a
            FiniteMPSTangents._observable_store!(
                store,
                c,
                FiniteMPSTangents.ObservableEnv4(:c),
            )
            @test isfile(store.paths[b])
            @test !ispath(store.paths[a])
            @test !ispath(store.paths[c])
            @test haskey(store.cacheL.values, a)
            @test haskey(store.cacheL.values, c)

            # Reloading b evicts cache-only a. The backing file for b remains
            # authoritative while b is resident again.
            b_path = store.paths[b]
            @test FiniteMPSTangents._observable_load(store, b).e00 === :b
            @test isfile(store.paths[a])
            @test haskey(store.cacheL.values, b)
            @test haskey(store.cacheL.values, c)

            FiniteMPSTangents._observable_store!(
                store,
                d,
                FiniteMPSTangents.ObservableEnv4(:d),
            )
            @test isfile(store.paths[c])
            @test haskey(store.cacheL.values, b)
            @test haskey(store.cacheL.values, d)

            # Evicting clean, reloaded b must not touch its existing file. An
            # invalid temporary mapping makes any accidental rewrite fail.
            try
                store.paths[b] = joinpath(store.directory, "missing", "b.bin")
                FiniteMPSTangents._observable_store!(
                    store,
                    e,
                    FiniteMPSTangents.ObservableEnv4(:e),
                )
            finally
                store.paths[b] = b_path
            end
            @test isfile(b_path)
            @test haskey(store.cacheL.values, d)
            @test haskey(store.cacheL.values, e)

            # Taking disk-only a is a terminal read and must not admit a just
            # to evict one of the live cache-only entries.
            @test FiniteMPSTangents._observable_take!(store, a).e00 === :a
            @test !ispath(store.paths[a])
            @test haskey(store.cacheL.values, d)
            @test haskey(store.cacheL.values, e)
            @test !ispath(store.paths[d])
            @test !ispath(store.paths[e])
            @test isempty(store.cacheR.values)
        end
        @test !ispath(normal_directory[])

        split_directory = Ref("")
        FiniteMPSTangents._observable_with_store(
            left_levels,
            right_levels;
            disk=true,
            maxsize=1,
        ) do store
            split_directory[] = store.directory
            left_1, left_2 = left_nodes[1:2]
            right_1, right_2 = right_nodes[1:2]
            FiniteMPSTangents._observable_store!(
                store,
                left_1,
                FiniteMPSTangents.ObservableEnv4(:left_1),
            )
            FiniteMPSTangents._observable_store!(
                store,
                right_1,
                FiniteMPSTangents.ObservableEnv4(:right_1),
            )
            @test !ispath(store.paths[left_1])
            @test !ispath(store.paths[right_1])

            FiniteMPSTangents._observable_store!(
                store,
                right_2,
                FiniteMPSTangents.ObservableEnv4(:right_2),
            )
            @test isfile(store.paths[right_1])
            @test !ispath(store.paths[right_2])
            @test !ispath(store.paths[left_1])
            @test haskey(store.cacheL.values, left_1)

            FiniteMPSTangents._observable_store!(
                store,
                left_2,
                FiniteMPSTangents.ObservableEnv4(:left_2),
            )
            @test isfile(store.paths[left_1])
            @test !ispath(store.paths[left_2])
            @test !ispath(store.paths[right_2])
            @test haskey(store.cacheR.values, right_2)

            # A logical drop suppresses writeback for a cache-only entry.
            FiniteMPSTangents._observable_drop!(store, right_2)
            @test !ispath(store.paths[right_2])
            @test isempty(store.cacheR.values)
        end
        @test !ispath(split_directory[])

        race_directory = Ref("")
        FiniteMPSTangents._observable_with_store(
            left_levels,
            right_levels;
            disk=true,
            maxsize=1,
        ) do store
            race_directory[] = store.directory
            a, b = left_nodes[1:2]
            FiniteMPSTangents._observable_store!(
                store,
                a,
                FiniteMPSTangents.ObservableEnv4(:race_a),
            )

            cache = store.cacheL
            original_finalizer = cache.values.finalizer
            entered_writeback = Channel{Nothing}(1)
            release_writeback = Channel{Nothing}(1)
            cache.values.finalizer = (node, environment) -> begin
                if node === a
                    put!(entered_writeback, nothing)
                    take!(release_writeback)
                end
                return original_finalizer(node, environment)
            end

            writer = @async FiniteMPSTangents._observable_store!(
                store,
                b,
                FiniteMPSTangents.ObservableEnv4(:race_b),
            )
            take!(entered_writeback)

            reader_started = Channel{Nothing}(1)
            reader = @async begin
                put!(reader_started, nothing)
                return FiniteMPSTangents._observable_load(store, a)
            end
            take!(reader_started)
            yield()
            @test !istaskdone(reader)

            put!(release_writeback, nothing)
            wait(writer)
            @test fetch(reader).e00 === :race_a
            @test isfile(store.paths[a])
            cache.values.finalizer = original_finalizer
        end
        @test !ispath(race_directory[])

        uncached_directory = Ref("")
        FiniteMPSTangents._observable_with_store(
            left_levels,
            right_levels;
            disk=true,
            maxsize=0,
        ) do store
            uncached_directory[] = store.directory
            FiniteMPSTangents._observable_store!(
                store,
                tree.RootL,
                FiniteMPSTangents.ObservableEnv4(:uncached),
            )
            FiniteMPSTangents._observable_store!(
                store,
                tree.RootR,
                FiniteMPSTangents.ObservableEnv4(:uncached_right),
            )
            @test isfile(store.paths[tree.RootL])
            @test isfile(store.paths[tree.RootR])
            @test isempty(store.cacheL.values)
            @test isempty(store.cacheR.values)
            @test FiniteMPSTangents._observable_load(store, tree.RootL).e00 ===
                  :uncached
            @test FiniteMPSTangents._observable_load(store, tree.RootR).e00 ===
                  :uncached_right
            @test isempty(store.cacheL.values)
            @test isempty(store.cacheR.values)
        end
        @test !ispath(uncached_directory[])

        ready_directory = Ref("")
        tangent = TangentMPS(BaseMPS(identityMPO(ComplexF64, 3, physical)))
        right_uses = FiniteMPSTangents._observable_right_use_counts(left_levels)
        FiniteMPSTangents._observable_with_store(
            left_levels,
            right_levels;
            disk=true,
            maxsize=0,
        ) do store
            ready_directory[] = store.directory
            right_boundary = FiniteMPSTangents._default_observable_right_boundary(
                tangent,
                tangent,
            )
            FiniteMPSTangents._observable_store!(
                store,
                tree.RootR,
                FiniteMPSTangents.ObservableEnv4(
                    FiniteMPSTangents.observable_right_boundary(right_boundary),
                ),
            )

            published = Ref(0)
            emit_child = child -> begin
                @test haskey(store.cacheR.persisted, child)
                @test isfile(store.paths[child])
                @test FiniteMPSTangents._observable_load(store, child) isa
                      FiniteMPSTangents.ObservableEnv4
                published[] += 1
                return nothing
            end
            FiniteMPSTangents._observable_right_node(
                store,
                right_uses,
                tree,
                tangent,
                tangent,
                tree.RootR,
                emit_child,
            )
            @test !isempty(tree.RootR.children)
            @test published[] == length(tree.RootR.children)
        end
        @test !ispath(ready_directory[])

        failing_directory = Ref("")
        cleanup_error = try
            FiniteMPSTangents._observable_with_store(
                left_levels,
                right_levels;
                disk=true,
                maxsize=1,
            ) do store
                failing_directory[] = store.directory
                FiniteMPSTangents._observable_store!(
                    store,
                    tree.RootL,
                    FiniteMPSTangents.ObservableEnv4(current_task()),
                )
                @test !ispath(store.paths[tree.RootL])
                error("disk cleanup probe")
            end
            nothing
        catch exception
            exception
        end
        @test cleanup_error isa ErrorException
        @test occursin("disk cleanup probe", sprint(showerror, cleanup_error))
        @test !ispath(failing_directory[])

        atomic_directory = Ref("")
        FiniteMPSTangents._observable_with_store(
            left_levels,
            right_levels;
            disk=true,
            maxsize=0,
        ) do store
            atomic_directory[] = store.directory
            path = store.paths[tree.RootL]
            side_directory = dirname(path)
            files_before = Set(readdir(side_directory))
            @test_throws Exception FiniteMPSTangents._observable_store!(
                store,
                tree.RootL,
                FiniteMPSTangents.ObservableEnv4(current_task()),
            )
            @test Set(readdir(side_directory)) == files_before
            @test !ispath(path)
            @test isempty(store.cacheL.values)
        end
        @test !ispath(atomic_directory[])

        if Threads.nthreads() > 1
            worker_directory = Ref("")
            worker_finished = Threads.Atomic{Bool}(false)
            entered = Threads.Atomic{Int}(0)
            @test_throws Exception FiniteMPSTangents._observable_with_store(
                left_levels,
                right_levels;
                disk=true,
                maxsize=1,
            ) do store
                worker_directory[] = store.directory
                process_node = function(label, emit_child)
                    if label === :root
                        emit_child(:fail)
                        emit_child(:slow)
                        return nothing
                    end
                    Threads.atomic_add!(entered, 1)
                    while entered[] < 2
                        yield()
                    end
                    if label === :fail
                        error("worker failure probe")
                    end
                    sleep(0.02)
                    FiniteMPSTangents._observable_atomic_serialize(
                        joinpath(store.directory, "late-worker.bin"),
                        FiniteMPSTangents.ObservableEnv4(:late),
                    )
                    worker_finished[] = true
                    return nothing
                end
                FiniteMPSTangents._observable_walk_ready!(
                    process_node,
                    (_, _) -> nothing,
                    :root,
                    3;
                    threaded=true,
                    ntasks=3,
                )
            end
            @test worker_finished[]
            @test !ispath(worker_directory[])
        end

        L = 3
        physical = NoSymSpinOneHalf.pspace
        tangent = TangentMPS(BaseMPS(identityMPO(ComplexF64, L, physical)))
        invalid_operator = TensorMap(randn, ComplexF64, ℂ^3, ℂ^3)
        failing_tree = ObservableTree(L)
        addObs!(failing_tree, id(physical), 1; name=:good)
        addObs!(
            failing_tree,
            invalid_operator,
            2;
            pspace=physical,
            name=:bad,
        )

        observable_tempdirs() = Set(
            path
            for path in readdir(tempdir(); join=true)
            if startswith(
                basename(path),
                FiniteMPSTangents._OBSERVABLE_TEMP_PREFIX,
            )
        )
        directories_before = observable_tempdirs()
        @test_throws Exception calObs!(
            failing_tree,
            tangent;
            disk=true,
            serial=false,
            ntasks=max(2, Threads.nthreads()),
            maxsize=1,
        )
        @test all(
            isnan(ref[])
            for refs in values(failing_tree.Refs)
            for ref in values(refs)
        )
        @test observable_tempdirs() == directories_before

        recovery_tree = ObservableTree(L)
        addObs!(recovery_tree, id(physical), 2; name=:I)
        calObs!(
            recovery_tree,
            tangent;
            disk=true,
            serial=false,
            ntasks=max(2, Threads.nthreads()),
            maxsize=1,
        )
        @test recovery_tree.Refs["I"][(2,)][] ≈ inner(tangent, tangent)
        @test observable_tempdirs() == directories_before
    end
end
