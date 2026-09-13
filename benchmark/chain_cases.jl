using FiniteMPSTangents
using FiniteMPSTangents.FiniteMPS
using .PerformanceFixtures

function _chain_parameters(config,family,sym,rank,charged,configuration;extra=Dict{String,Any}())
    return merge(Dict{String,Any}("section"=>family=="CM" ? "mul" : "basic",
        "family"=>family,"symmetry"=>sym,"configuration"=>configuration,
        "base_rank"=>rank,"center_rank"=>rank+Int(charged),
        "execution"=>execution_parameters(config)),extra)
end

function _mul_case(config,sym,D,rank,charged)
    center_rank = rank+Int(charged)
    model = Dict("NoSym"=>"TFI","U1"=>"XXZ","SU2"=>"Heisenberg","U1xSU2"=>"Hubbard")[sym]
    configuration = "base$(rank)-center$(center_rank)/$(model)-r1r2/cached"
    params = _chain_parameters(config,"CM",sym,rank,charged,configuration;
        extra=Dict("nominal_D"=>D,"model"=>model,"interaction_distances"=>[1,2],
            "model_parameters"=>sym=="U1xSU2" ? Dict("t1"=>1.0,"t2"=>0.5,"U"=>4.0,"mu"=>2.0) :
                sym=="U1" ? Dict("J1"=>1.0,"J2"=>0.2,"Delta"=>0.7) :
                sym=="NoSym" ? Dict("J1"=>1.0,"J2"=>0.2,"h"=>1.05) : Dict("J1"=>1.0,"J2"=>0.2)))
    return BenchmarkCase("mul/$sym/base$(rank)-center$(center_rank)/$(model)-r1r2/L16/D$D/v1",rng->begin
        old = configure_threads(config)
        fixture = build_state(rng,sym,D,rank,charged)
        B,H = fixture.tangent,fixture.H
        cache = TangentEnvironment(fixture.base,H;disk=false)
        benchmark = @benchmarkable mul!(C,$H,$B,1.0,0.0;cache=$cache,normalize=false,GCstep=false,disk=false) setup=(C=partialcopy($B);configure_threads($config))
        cleanup = ()->begin finalize(cache); restore_threads(old); end
        (;benchmark,parameters=fixture.parameters,cleanup)
    end; parameters=params,warmup_options(params)...,seconds=60.0,samples=5,evals=1,mutates=true,
        description="Complete cached SparseMPO action, including both aggregation sweeps and final tangent projection.")
end

function _orth_case(config,sym,D,rank,charged)
    configuration = "orth/base$(rank)-center$(rank+Int(charged))"
    params = _chain_parameters(config,"OR",sym,rank,charged,configuration;extra=Dict("nominal_D"=>D))
    return BenchmarkCase("basic/orth/$sym/base$(rank)-center$(rank+Int(charged))/L16/D$D/v1",rng->begin
        old = configure_threads(config)
        f = build_state(rng,sym,D,rank,charged)
        raw = random_tangent(rng,f.base;charged,Q=charge_space(sym),project=false)
        benchmark = @benchmarkable orth!(B;normalize=false) setup=(B=partialcopy($raw);configure_threads($config))
        (;benchmark,parameters=f.parameters,cleanup=()->restore_threads(old))
    end;parameters=params,warmup_options(params)...,seconds=60.0,samples=5,evals=1,mutates=true,
        description="Full-chain left-gauge orthogonal projection from a freshly reset non-projected tangent.")
end

function _environment_case(config,D)
    params = _chain_parameters(config,"EC","SU2",4,true,"TangentEnvironment/base4/Heisenberg-r1r2";extra=Dict("nominal_D"=>D))
    return BenchmarkCase("basic/environment/SU2/base4/Heisenberg-r1r2/L16/D$D/v1",rng->begin
        old = configure_threads(config)
        f = build_state(rng,"SU2",D,4,true)
        base,H = f.base,f.H
        benchmark = @benchmarkable retained[]=TangentEnvironment($base,$H;disk=false) setup=(retained=Ref{Any}();configure_threads($config)) teardown=(finalize(retained[]))
        (;benchmark,parameters=f.parameters,cleanup=()->restore_threads(old))
    end;parameters=params,warmup_options(params)...,seconds=60.0,samples=5,evals=1,
        description="Construct both full-chain base environments for the Heisenberg SparseMPO; finalization is outside timing.")
end

function _canonicalization_case(config,sym,D,rank)
    params = _chain_parameters(config,"BC",sym,rank,false,"BaseMPS/base$rank";extra=Dict("nominal_D"=>D))
    return BenchmarkCase("basic/canonicalization/$sym/base$rank/L16/D$D/v1",rng->begin
        old = configure_threads(config)
        f = build_state(rng,sym,D,rank,false)
        psi = f.psi
        benchmark = @benchmarkable BaseMPS($psi) setup=(configure_threads($config))
        (;benchmark,parameters=f.parameters,cleanup=()->restore_threads(old))
    end;parameters=params,warmup_options(params)...,seconds=60.0,samples=5,evals=1,
        description="Complete BaseMPS canonicalization, including its QR sweeps, contractions, copies, and allocations.")
end

function _inner_case(config,sym,D,rank,charged)
    center_rank = rank + Int(charged)
    configuration = "inner/base$(rank)-center$(center_rank)/independent-vectors"
    params = _chain_parameters(config,"IP",sym,rank,charged,configuration;
        extra=Dict("nominal_D"=>D,"operation_scope"=>"full_chain","vector_count"=>2,
            "reduction_sites"=>16,
            "tangent_pair_preparation"=>"independent seeded random tangents on a shared base",
            "inner_product_convention"=>"left-orthogonal tangent gauge"))
    return BenchmarkCase("basic/inner/$sym/base$(rank)-center$(center_rank)/L16/D$D/v1",rng->begin
        old = configure_threads(config)
        try
            f = build_state(rng,sym,D,rank,charged)
            left = f.tangent
            right = random_tangent(rng,f.base;charged,Q=charge_space(sym))
            parameters = copy(f.parameters)
            delete!(parameters,"mpo_channel_shapes")
            delete!(parameters,"mpo_nonempty_transitions")
            parameters["stored_tensor_entries_per_vector"] =
                sum(sum(length(block) for (_,block) in blocks(A.A)) for A in left.B)
            benchmark = @benchmarkable inner($left,$right) setup=(configure_threads($config))
            (;benchmark,parameters,cleanup=()->restore_threads(old))
        catch
            restore_threads(old)
            rethrow()
        end
    end;parameters=params,warmup_options(params)...,seconds=60.0,samples=5,evals=1,
        description="Whole-chain inner product of independent tangent vectors on the same base, including site dispatch and reduction.")
end

function chain_cases(config)
    cases = BenchmarkCase[]
    for sym in ("NoSym","U1","SU2","U1xSU2"),rank in (3,4),charged in (false,true),D in dimensions(sym)
        push!(cases,_mul_case(config,sym,D,rank,charged))
    end
    for (sym,rank,charged) in (("NoSym",3,false),("U1",3,true),
                               ("NoSym",4,false),("SU2",4,true)),D in dimensions(sym)
        push!(cases,_orth_case(config,sym,D,rank,charged))
    end
    append!(cases,[_environment_case(config,D) for D in dimensions("SU2")])
    for (sym,rank) in (("NoSym",3),("SU2",4)),D in dimensions(sym)
        push!(cases,_canonicalization_case(config,sym,D,rank))
    end
    for sym in ("NoSym","U1","SU2","U1xSU2"),(rank,charged) in ((3,false),(4,true)),D in dimensions(sym)
        push!(cases,_inner_case(config,sym,D,rank,charged))
    end
    return cases
end
