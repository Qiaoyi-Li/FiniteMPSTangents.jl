using FiniteMPSTangents
using FiniteMPSTangents.FiniteMPS
using .PerformanceFixtures

const _OC = FiniteMPSTangents

function _oc_activate(config)
    PerformanceFixtures.configure_threads(config)
end

_oc_execution(config; tree=false) = Dict{String,Any}(
    "julia_threads" => config.julia_threads, "blas_threads" => 1,
    "action_threads" => config.julia_threads, "sector_mul_threads" => 1,
    "svd_threads" => 1, "eig_threads" => 1,
    "serial" => tree ? config.julia_threads == 1 : nothing,
    "ntasks" => tree ? (config.julia_threads == 1 ? 1 : config.julia_threads+1) : nothing,
    "contraction_workers" => tree ? (config.julia_threads == 1 ? 0 : config.julia_threads) : 0)

function _oc_parameters(config, family, symmetry, configuration, D, base_rank, center_rank)
    return Dict{String,Any}("section" => family == "CO" ? "calobs" : "basic",
        "family" => family, "symmetry" => symmetry, "configuration" => configuration,
        "nominal_D" => D, "base_rank" => base_rank, "center_rank" => center_rank,
        "execution" => _oc_execution(config; tree=family == "CO"))
end

_oc_spec(name,operators,names;fermionic=ntuple(_ -> false,length(operators)),Z=nothing) =
    (;name,operators,names,fermionic,Z)

function _oc_specs(symmetry,klass;spinless=false,extras=false)
    onsite,two,multi = Any[],Any[],Any[]
    if symmetry == "NoSym"
        F = NoSymSpinOneHalf
        onsite = [_oc_spec("Sz",(F.Sz,),(:Sz,)),_oc_spec("Sx",(F.Sx,),(:Sx,))]
        two = [_oc_spec("SzSz",(F.Sz,F.Sz),(:Sz,:Sz)),
               _oc_spec("SpSm",(F.S₊,F.S₋),(:Sp,:Sm))]
        multi = [_oc_spec("SzSzSz",(F.Sz,F.Sz,F.Sz),(:Sz,:Sz,:Sz)),
                 _oc_spec("SzSzSzSz",(F.Sz,F.Sz,F.Sz,F.Sz),(:Sz,:Sz,:Sz,:Sz))]
    elseif symmetry == "U1" && !spinless
        F = U1Spin
        onsite = [_oc_spec("Sz",(F.Sz,),(:Sz,))]
        two = [_oc_spec("SpSm",F.S₊₋,(:Sp,:Sm)),_oc_spec("SmSp",F.S₋₊,(:Sm,:Sp)),
               _oc_spec("SzSz",(F.Sz,F.Sz),(:Sz,:Sz))]
        multi = [_oc_spec("SpSpSmSm",F.S₊₊₋₋,(:Sp,:SpSp,:SmSm,:Sm))]
    elseif symmetry == "SU2"
        F = SU2Spin
        onsite = [_oc_spec("S",(F.SS[1],),(:S,))]
        two = [_oc_spec("SS",F.SS,(:SL,:SR))]
        multi = [_oc_spec("SSSS",(F.SS...,F.SS...),(:SL,:SR,:SL,:SR))]
    elseif symmetry == "U1xSU2"
        F = U1SU2Fermion
        onsite = [_oc_spec("n",(F.n,),(:n,)),_oc_spec("nd",(F.nd,),(:nd,))]
        two = [_oc_spec("FdagF",F.FdagF,(:Fdag,:F);fermionic=(true,true),Z=F.Z),
               _oc_spec("FFdag",F.FFdag,(:F,:Fdag);fermionic=(true,true),Z=F.Z),
               _oc_spec("SS",F.SS,(:SL,:SR)),_oc_spec("CpCm",F.CpCm,(:Cp,:Cm))]
        multi = [_oc_spec("SSS",F.SSS,(:SL,:SM,:SR)),
                 _oc_spec("TripletPair",F.ΔₜdagΔₜ,(:Fdag,:TripletCreate,:TripletDestroy,:F);
                          fermionic=(true,true,true,true),Z=F.Z)]
        if extras
            append!(multi,[_oc_spec("SingletPair",F.ΔₛdagΔₛ,(:Fdag,:SingletCreate,:SingletDestroy,:F);
                                   fermionic=(true,true,true,true),Z=F.Z),
                           _oc_spec("SBSB",F.SBSB,(:Fdag,:SBLeft,:SBRight,:F);
                                   fermionic=(true,true,true,true),Z=F.Z)])
        end
    elseif symmetry == "U1" && spinless
        F = U1SpinlessFermion
        onsite = [_oc_spec("n",(F.n,),(:n,))]
        two = [_oc_spec("FdagF",F.FdagF,(:Fdag,:F);fermionic=(true,true),Z=F.Z),
               _oc_spec("FFdag",F.FFdag,(:F,:Fdag);fermionic=(true,true),Z=F.Z)]
        multi = [_oc_spec("Pair",F.ΔdagΔ,(:Fdag,:PairCreate,:PairDestroy,:F);
                          fermionic=(true,true,true,true),Z=F.Z),
                 _oc_spec("FdagNF",(F.FdagF[1],F.n,F.FdagF[2]),(:Fdag,:n,:F);
                          fermionic=(true,false,true),Z=F.Z)]
    end
    klass == "onsite" && return onsite
    klass == "two-site" && return two
    klass == "multisite" && return multi
    klass == "multisite-extra" && return multi[3:end]
    klass == "mixed" && return symmetry == "SU2" ? vcat(two,multi) : vcat(onsite,two,multi)
    error("unknown observable class $klass")
end

function _oc_patterns(L,n)
    n == 1 && return [(i,) for i in 1:L]
    n == 2 && return [(i,i+r) for r in (1,2,4) for i in 1:(L-r)]
    offsets = n == 3 ? ((0,1,2),(0,2,4)) : ((0,1,2,3),(0,2,4,6))
    [Tuple(i+x for x in o) for o in offsets for i in 1:4:(L-last(o))]
end

function _oc_tree(symmetry,klass;spinless=false)
    specs = _oc_specs(symmetry,klass;spinless,extras=klass in ("multisite-extra","mixed"))
    tree = ObservableTree(16)
    definitions = Dict{String,Any}[]
    for spec in specs, sites in _oc_patterns(16,length(spec.operators))
        addObs!(tree,spec.operators,sites,spec.fermionic;Z=spec.Z,name=spec.names,IntrName=spec.name)
        push!(definitions,Dict("name"=>spec.name,"sites"=>collect(sites),
            "operator_names"=>string.(collect(spec.names)),"fermionic"=>collect(spec.fermionic),
            "tensor_partitions"=>[[numout(A),numin(A)] for A in spec.operators],
            "tensor_spaces"=>[string(space(A)) for A in spec.operators]))
    end
    parameters = Dict{String,Any}("observable_definitions"=>definitions,
        "observable_count"=>sum(length,values(tree.Refs)),
        "tree_reset"=>"deepcopy of unmerged template per sample",
        "normalize"=>false,"disk"=>false)
    return tree,parameters
end

function _oc_calobs(tree,bra,ket,config)
    _OC.calObs!(tree,bra,ket;normalize=false,disk=false,
        serial=config.julia_threads == 1,
        ntasks=config.julia_threads == 1 ? 1 : config.julia_threads+1)
end

function _oc_prepare(fixture, symmetry, klass; spinless=false)
    open = symmetry == "SU2" && klass == "onsite"
    bra = fixture.tangent
    ket = bra
    if open
        bra = TangentMPS(fixture.base)
        action = InteractionTree(16)
        for i in 1:16
            addIntr!(action,SU2Spin.SS[2],i,cos(2π*i/16)+0.3sin(6π*i/16);name=:S)
        end
        ket = TangentMPS(AutomataMPO(action),fixture.base)
    end
    template,tree_parameters = _oc_tree(symmetry,klass;spinless)
    parameters = merge(copy(fixture.parameters),tree_parameters,
        Dict("actual_bra_center_ranks"=>numind.(bra.B),
             "actual_ket_center_ranks"=>numind.(ket.B),
             "charged_ket_preparation"=>open ? "nonuniform SU2Spin.SS[2] action" : "seeded random tensors"))
    return (;fixture,bra,ket,template,parameters)
end

function _oc_co_case(config,symmetry,D,klass;spinless=false,purified_open=false)
    open = symmetry == "SU2" && klass == "onsite"
    rank = symmetry == "U1xSU2" || spinless || purified_open ? 4 : 3
    charged = symmetry == "U1xSU2" || spinless || open
    label = spinless ? "U1Fermion" : symmetry == "U1" ? "U1Spin" : symmetry
    configuration = "$label/base$rank-center$(rank+charged)/$klass"
    params = _oc_parameters(config,"CO",symmetry,configuration,D,rank,rank+charged)
    params["operator_class"] = klass
    params["local_space_preset"] = label
    builder = function(rng)
        fixture = PerformanceFixtures.build_state(rng,symmetry,D,rank,charged;spinless)
        prepared = _oc_prepare(fixture,symmetry,klass;spinless)
        bra,ket,template,parameters = prepared.bra,prepared.ket,prepared.template,prepared.parameters
        benchmark = @benchmarkable _oc_calobs(work,$bra,$ket,$config) setup=(previous=_oc_activate($config);work=deepcopy($template)) teardown=(PerformanceFixtures.restore_threads(previous)) evals=1
        return (;benchmark,parameters)
    end
    BenchmarkCase("calobs/$configuration/L16/D$D/v1",builder;parameters=params,warmup_options(params)...,
        seconds=60,samples=5,evals=1,mutates=true,
        description="Complete calObs! including tree merge and environment/store lifecycle")
end

function _oc_complete_cases(config)
    cases = BenchmarkCase[]
    for symmetry in ("NoSym","U1","SU2","U1xSU2"),
        klass in ("onsite","two-site","multisite","mixed"),
        D in PerformanceFixtures.dimensions(symmetry)
        push!(cases,_oc_co_case(config,symmetry,D,klass))
    end
    for klass in ("onsite","two-site","multisite","mixed"), D in PerformanceFixtures.dimensions("U1")
        push!(cases,_oc_co_case(config,"U1",D,klass;spinless=true))
    end
    for D in PerformanceFixtures.dimensions("U1xSU2")
        push!(cases,_oc_co_case(config,"U1xSU2",D,"multisite-extra"))
    end
    for D in PerformanceFixtures.dimensions("SU2")
        push!(cases,_oc_co_case(config,"SU2",D,"onsite";purified_open=true))
    end
    return cases
end

"Complete observable calculations at all three prescribed bond dimensions."
observable_cases(config) = _oc_complete_cases(config)
