module PerformanceFixtures

using FiniteMPSTangents
using FiniteMPSTangents.FiniteMPS
using Random, TOML

export dimensions, center_space, physical_space, charge_space, bond_spaces,
       build_state, random_tangent, hamiltonian, configure_threads, restore_threads,
       describe_space, random_map, canonical_symmetry, execution_parameters, warmup_options

const CHAIN_LENGTH = 16
const PRESETS = TOML.parsefile(joinpath(@__DIR__, "presets", "bond_sectors.toml"))
canonical_symmetry(sym) = string(sym) in ("U1SU2", "U1xSU2") ? "U1xSU2" : string(sym)
dimensions(sym) = canonical_symmetry(sym) == "U1xSU2" ? (128,256,512) : (64,128,256)

warmup_options(parameters) = (
    warmup_group=join((parameters[key] for key in
        ("section","family","symmetry","configuration","base_rank","center_rank")), "/"),
    warmup_size=parameters["nominal_D"])

function physical_space(sym; spinless=false)
    sym = canonical_symmetry(sym)
    spinless && return U1SpinlessFermion.pspace
    sym == "NoSym" && return NoSymSpinOneHalf.pspace
    sym == "U1" && return U1Spin.pspace
    sym == "SU2" && return SU2Spin.pspace
    sym == "U1xSU2" && return U1SU2Fermion.pspace
    error("Unknown symmetry: $sym")
end

function charge_space(sym)
    sym = canonical_symmetry(sym)
    sym == "NoSym" && return ℂ^2
    sym == "U1" && return Rep[U₁](1=>1)
    sym == "SU2" && return Rep[SU₂](1=>1)
    sym == "U1xSU2" && return Rep[U₁×SU₂]((1,1//2)=>1)
    error("Unknown symmetry: $sym")
end

function _rep(sym, rows)
    sym == "U1" && return Rep[U₁](rows)
    sym == "SU2" && return Rep[SU₂](rows)
    sym == "U1xSU2" && return Rep[U₁×SU₂](rows)
    error("Sector representation requires a symmetry")
end

function _preset(sym,D)
    sym = canonical_symmetry(sym)
    model = sym == "U1" ? "u1_xxz" : sym == "SU2" ? "su2_heisenberg" : "u1su2_hubbard"
    return only(p for p in PRESETS["presets"] if p["model"] == model && p["requested_dimension_cap"] == D)
end

function center_space(sym,D)
    sym = canonical_symmetry(sym)
    D in dimensions(sym) || throw(ArgumentError("Unsupported dimension $D for $sym"))
    sym == "NoSym" && return ℂ^D
    p = _preset(sym,D)
    V = if sym == "U1"
        Rep[U₁](r["charge_twice"]//2=>r["multiplicity"] for r in p["sectors"])
    elseif sym == "SU2"
        Rep[SU₂](r["spin_twice"]//2=>r["multiplicity"] for r in p["sectors"])
    else
        Rep[U₁×SU₂]((r["charge_twice"]//2,r["spin_twice"]//2)=>r["multiplicity"] for r in p["sectors"])
    end
    return V
end

function describe_space(V)
    rows = Dict{String,Any}[]
    for c in sectors(V)
        row = Dict{String,Any}("multiplicity"=>Int(dim(V,c)), "irrep_dimension"=>Int(dim(c)))
        if c isa Irrep[U₁]
            row["charge_twice"] = Int(2c.charge)
        elseif c isa Irrep[SU₂]
            row["spin_twice"] = Int(2c.j)
        elseif c isa Irrep[U₁×SU₂]
            row["charge_twice"] = Int(2c[1].charge)
            row["spin_twice"] = Int(2c[2].j)
        end
        push!(rows,row)
    end
    sort!(rows; by=r->(get(r,"charge_twice",0),get(r,"spin_twice",0)))
    return Dict("full_dimension"=>Int(dim(V)), "multiplet_count"=>sum(r["multiplicity"] for r in rows), "sectors"=>rows)
end

function _dual_space(sym,V)
    labels = [sym == "U1" ? Irrep[U₁](-c.charge) : sym == "SU2" ? c :
              Irrep[U₁×SU₂](-c[1].charge,c[2].j) for c in sectors(V)]
    return _rep(sym, (d=>dim(V,c) for (c,d) in zip(sectors(V),labels)))
end

function _previous_space(sym,R,P,capacity,cap)
    available = fuse(R ⊗ P')
    candidates = sort!(collect(sectors(capacity)); by=string)
    limits = [min(dim(capacity,c),dim(available,c)) for c in candidates]
    targets = collect(sectors(R))
    demand = [dim(R,c) for c in targets]
    transition = [dim(fuse(_rep(sym,[c=>1]) ⊗ P), r) for r in targets, c in candidates]
    chosen = zeros(Int,length(candidates))
    costs = Int.(dim.(candidates))
    full = 0
    while any(>(0),demand)
        scores = [chosen[j]<limits[j] && full+costs[j]<=cap ?
            sum(min(max(demand[i],0),transition[i,j])*dim(targets[i]) for i in eachindex(targets))/costs[j] : 0.0
            for j in eachindex(candidates)]
        score,j = findmax(scores)
        score > 0 || error("Cannot support center preset within dimension cap $cap at preceding bond")
        chosen[j] += 1
        full += costs[j]
        demand .-= transition[:,j]
    end
    # Fill remaining capacity in proportion to the compatible sector inventory.
    while true
        scores = [chosen[j]<limits[j] && full+costs[j]<=cap ? limits[j]/(chosen[j]+1) : 0.0 for j in eachindex(candidates)]
        score,j = findmax(scores)
        score > 0 || break
        chosen[j] += 1
        full += costs[j]
    end
    V = _rep(sym,(c=>m for (c,m) in zip(candidates,chosen) if m>0))
    return V
end

function bond_spaces(sym,D,base_rank; spinless=false)
    sym = canonical_symmetry(sym)
    base_rank in (3,4) || throw(ArgumentError("Base rank must be 3 or 4"))
    spinless && base_rank != 4 && throw(ArgumentError("Spinless fixtures use purified rank-4 bases"))
    P = physical_space(sym;spinless)
    effective = base_rank == 3 ? P : fuse(P ⊗ P')
    if sym == "NoSym"
        return [ℂ^min(D,dim(effective)^min(k,CHAIN_LENGTH-k)) for k in 0:CHAIN_LENGTH]
    end
    center = center_space(sym,D)
    half = Vector{typeof(center)}(undef,9)
    half[9] = center
    capacities = [trivial(effective)]
    for k in 1:7
        push!(capacities,fuse(capacities[end]⊗effective))
    end
    for k in 7:-1:0
        half[k+1] = _previous_space(sym,half[k+2],effective,capacities[k+1],D)
    end
    spaces = vcat(half,[_dual_space(sym,half[k+1]) for k in 7:-1:0])
    return spaces
end

function random_map(rng,cod,dom)
    A = TensorMap{ComplexF64}(undef,cod,dom)
    for (_,block) in blocks(A)
        randn!(rng,block)
    end
    return A
end

function hamiltonian(sym; L=CHAIN_LENGTH)
    sym = canonical_symmetry(sym)
    tree = InteractionTree(L)
    if sym == "NoSym"
        for i in 1:L
            addIntr!(tree,NoSymSpinOneHalf.Sx,i,-1.05;name=:Sx)
        end
        for (r,J) in ((1,1.0),(2,0.2)), i in 1:L-r
            addIntr!(tree,(NoSymSpinOneHalf.Sz,NoSymSpinOneHalf.Sz),(i,i+r),(false,false),-J;name=(:Sz,:Sz))
        end
    elseif sym == "U1"
        for (r,J) in ((1,1.0),(2,0.2)), i in 1:L-r
            addIntr!(tree,U1Spin.S₊₋,(i,i+r),(false,false),J/2;name=(:Sp,:Sm))
            addIntr!(tree,U1Spin.S₋₊,(i,i+r),(false,false),J/2;name=(:Sm,:Sp))
            addIntr!(tree,(U1Spin.Sz,U1Spin.Sz),(i,i+r),(false,false),0.7J;name=(:Sz,:Sz))
        end
    elseif sym == "SU2"
        for (r,J) in ((1,1.0),(2,0.2)), i in 1:L-r
            addIntr!(tree,SU2Spin.SS,(i,i+r),(false,false),J;name=(:S,:S))
        end
    elseif sym == "U1xSU2"
        F = U1SU2Fermion
        for i in 1:L
            addIntr!(tree,F.nd,i,4.0;name=:nd)
            addIntr!(tree,F.n,i,-2.0;name=:n)
        end
        for (r,t) in ((1,1.0),(2,0.5)), i in 1:L-r
            addIntr!(tree,F.FdagF,(i,i+r),(true,true),-t;Z=F.Z,name=(:Fdag,:F))
            addIntr!(tree,F.FFdag,(i,i+r),(true,true),t;Z=F.Z,name=(:F,:Fdag))
        end
    end
    return AutomataMPO(tree)
end

function configure_threads(config)
    old = (action=FiniteMPS.get_num_threads_action(),mul=FiniteMPS.get_num_threads_mul(),
           svd=FiniteMPS.get_num_threads_svd(),eig=FiniteMPS.get_num_threads_eig())
    BLAS.set_num_threads(1)
    FiniteMPS.set_num_threads_action(config.julia_threads)
    FiniteMPS.set_num_threads_mul(1)
    FiniteMPS.set_num_threads_svd(1)
    FiniteMPS.set_num_threads_eig(1)
    return old
end

function restore_threads(old)
    FiniteMPS.set_num_threads_action(old.action)
    FiniteMPS.set_num_threads_mul(old.mul)
    FiniteMPS.set_num_threads_svd(old.svd)
    FiniteMPS.set_num_threads_eig(old.eig)
    return nothing
end

execution_parameters(config) = Dict("julia_threads"=>config.julia_threads,"blas_threads"=>1,
    "action_threads"=>config.julia_threads,"sector_mul_threads"=>1,"svd_threads"=>1,"eig_threads"=>1)

function random_tangent(rng,base::BaseMPS{L}; charged=false,Q=nothing,project=true) where L
    tensors = MPSTensor[]
    for A in base.A
        domains = collect(domain(A.A))
        if charged
            isnothing(Q) && throw(ArgumentError("Charged tangent requires Q"))
            insert!(domains,length(domains),Q)
        end
        push!(tensors,MPSTensor(random_map(rng,codomain(A.A),prod(domains))))
    end
    B = TangentMPS{L}(base,tensors)
    project && orth!(B;normalize=false)
    normalize!(B)
    return B
end

function build_state(rng,sym,D,base_rank,charged;spinless=false)
    sym = canonical_symmetry(sym)
    P = physical_space(sym;spinless)
    spaces = bond_spaces(sym,D,base_rank;spinless)
    tensors = MPSTensor[]
    for i in 1:CHAIN_LENGTH
        dom = base_rank == 3 ? spaces[i+1] : P⊗spaces[i+1]
        A = random_map(rng,spaces[i]⊗P,dom)
        push!(tensors,MPSTensor(A/norm(A)))
    end
    psi = MPS(tensors)
    canonicalize!(psi,1)
    normalize!(psi)
    base = BaseMPS(psi)
    actual = [codomain(base.A[1].A)[1]; [domain(A.A)[end] for A in base.A]]
    Q = charged ? charge_space(sym) : trivial(P)
    tangent = random_tangent(rng,base;charged,Q)
    H = spinless ? nothing : hamiltonian(sym)
    parameters = Dict{String,Any}(
        "actual_D"=>Int(dim(actual[9])),
        "preset_id"=>sym == "NoSym" ? "nosym_L16_D$(D)_v1" : _preset(sym,D)["id"],
        "bond_schedule"=>[merge(Dict("cut_after_site"=>i-1),describe_space(V)) for (i,V) in enumerate(actual)],
        "physical_space"=>describe_space(P),"charge_space"=>describe_space(Q),
        "purification_space"=>base_rank==4 ? describe_space(P) : nothing,
        "length"=>CHAIN_LENGTH,"scalar_type"=>"ComplexF64",
        "bond_allocation"=>"center-fixed-fusion-cover-v1",
        "base_convention"=>"canonical-untwisted",
    )
    if spinless || sym=="U1xSU2"
        parameters["fermionic_strings"] = "LocalSpace Z on fermionic operator strings"
    end
    if H !== nothing
        parameters["mpo_channel_shapes"] = [collect(size(H[i])) for i in 1:CHAIN_LENGTH]
        parameters["mpo_nonempty_transitions"] = [count(!isnothing,H[i]) for i in 1:CHAIN_LENGTH]
    end
    return (;base,tangent,H,psi,parameters)
end

end
