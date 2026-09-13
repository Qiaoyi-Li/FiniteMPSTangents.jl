using FiniteMPSTangents
using FiniteMPSTangents.FiniteMPS
using .PerformanceFixtures

const _MS = FiniteMPSTangents

_ms_active(vector) = count(!isnothing, vector)

function _ms_incoming(fixture, cache, direction, site)
    base, tangent, H = fixture.base, fixture.tangent, fixture.H
    if direction == "right"
        incoming = Vector{Union{Nothing,BilayerLeftTensor}}(nothing,1)
        for i in 1:site-1
            incoming,_ = _MS._recurseEl(_MS._getEl(cache,i),incoming,
                base.Al[i]',H[i],tangent.B[i],i>1 ? base.Ar[i] : nothing)
        end
    else
        incoming = Vector{Union{Nothing,BilayerRightTensor}}(nothing,1)
        for i in length(tangent.B):-1:site+1
            incoming,_ = _MS._recurseEr(_MS._getEr(cache,i),incoming,
                base.Ar[i]',H[i],tangent.B[i],i<length(tangent.B) ? base.Al[i] : nothing)
        end
    end
    return incoming
end

function _ms_prepare(fixture, cache, stage, direction, site)
    base, tangent, H = fixture.base, fixture.tangent, fixture.H
    left, right = _MS._getEl(cache,site), _MS._getEr(cache,site)
    operator, center = H[site], tangent.B[site]
    metadata = Dict{String,Any}(
        "left_environment_channels"=>length(left),"right_environment_channels"=>length(right),
        "active_left_channels"=>_ms_active(left),"active_right_channels"=>_ms_active(right),
        "local_mpo_shape"=>collect(size(operator)),
        "local_mpo_nonempty_transitions"=>count(!isnothing,operator),
        "identity_transition_count"=>count(x->x isa IdentityOperator,operator),
        "local_operator_transition_count"=>count(x->x isa LocalOperator,operator),
        "local_center_rank"=>numind(center),
        "local_left_space"=>describe_space(codomain(center.A)[1]),
        "local_right_space"=>describe_space(domain(center.A)[end]),
        "local_center_leg_spaces"=>[describe_space(V) for V in [collect(codomain(center.A));collect(domain(center.A))]],
        "preparation_site_indices"=>stage=="effective_site_action" ? Int[] :
            direction=="right" ? collect(1:site-1) : collect(length(tangent.B):-1:site+1),
        "base_environment_preparation"=>"Both full-chain base environments are prepared outside timing",
    )
    if stage == "effective_site_action"
        arguments = (left,center,operator,right)
        operation = ()->_MS._action1(arguments...)
        metadata["reachable_transition_count"] = count(!isnothing(operator[i,j]) &&
            !isnothing(left[i]) && !isnothing(right[j]) for i in axes(operator,1), j in axes(operator,2))
        return (;operation,arguments,metadata)
    end
    incoming = _ms_incoming(fixture,cache,direction,site)
    arguments = direction=="right" ? (left,incoming,base.Al[site]',operator,center,base.Ar[site]) :
                                    (right,incoming,base.Ar[site]',operator,center,base.Al[site])
    recurse = direction=="right" ? _MS._recurseEl : _MS._recurseEr
    metadata["input_environment_channels"] = length(incoming)
    metadata["active_input_channels"] = _ms_active(incoming)
    metadata["input_bond_dimension"] = dim(direction=="right" ? codomain(center.A)[1] : domain(center.A)[end])
    metadata["output_bond_dimension"] = dim(direction=="right" ? domain(center.A)[end] : codomain(center.A)[1])
    metadata["reachable_transition_count"] = count(!isnothing(operator[i,j]) &&
        !isnothing(arguments[1][direction=="right" ? i : j]) for i in axes(operator,1), j in axes(operator,2))
    if stage == "tangent_recursion"
        output_channels = size(operator,direction=="right" ? 2 : 1)
        # Each reachable MPO path allocates both recursion outputs at its destination.
        destinations = Set(direction=="right" ? j : i for i in axes(operator,1), j in axes(operator,2)
            if !isnothing(operator[i,j]) && !isnothing(arguments[1][direction=="right" ? i : j]))
        metadata["output_environment_channels"] = output_channels
        metadata["active_output_channels"] = length(destinations)
        metadata["partial_environment_channels"] = output_channels
        metadata["active_partial_channels"] = length(destinations)
        metadata["active_channel_convention"] = "non-nothing sparse entries; output occupancy follows reachable MPO paths"
        operation = ()->recurse(arguments...)
        return (;operation,arguments,metadata)
    end
    _,partial = recurse(arguments...)
    reduction_arguments = direction=="right" ? (partial,right) : (left,partial)
    metadata["partial_environment_channels"] = length(partial)
    metadata["active_partial_channels"] = _ms_active(partial)
    metadata["active_reduction_channels"] = count(!isnothing(a) && !isnothing(b) for (a,b) in zip(reduction_arguments...))
    metadata["partial_preparation_site"] = site
    operation = ()->_MS._mul_LR(reduction_arguments...)
    return (;operation,arguments=reduction_arguments,metadata)
end

function _ms_model(symmetry)
    symmetry=="NoSym" && return "TFI",Dict("J1"=>1.0,"J2"=>0.2,"h"=>1.05)
    symmetry=="U1" && return "XXZ",Dict("J1"=>1.0,"J2"=>0.2,"Delta"=>0.7)
    symmetry=="SU2" && return "Heisenberg",Dict("J1"=>1.0,"J2"=>0.2)
    return "Hubbard",Dict("t1"=>1.0,"t2"=>0.5,"U"=>4.0,"mu"=>2.0)
end

function _ms_case(config, family, symmetry, D, rank, charged, direction)
    stages = Dict("SA"=>"effective_site_action","RA"=>"tangent_recursion","RC"=>"center_reduction")
    descriptions = Dict(
        "SA"=>"Apply the complete sparse effective one-site operator using both prebuilt environment vectors.",
        "RA"=>"Advance a complete tangent environment vector by one site, producing full and partial recursion outputs.",
        "RC"=>"Contract a precomputed partial environment vector with the opposing base environment vector and reduce all channels into a tangent center.")
    stage = stages[family]
    # This bulk site retains left-gauge freedom at the saturated spin bond dimension.
    site = 9
    model,model_parameters = _ms_model(symmetry)
    orientation = family=="SA" ? "site9" : "$(direction)/site$(site)"
    configuration = "$(stage)/base$(rank)-center$(rank+Int(charged))/$(model)-r1r2/$(orientation)"
    parameters = Dict{String,Any}("section"=>"basic","family"=>family,"stage"=>stage,
        "symmetry"=>symmetry,"configuration"=>configuration,"nominal_D"=>D,
        "base_rank"=>rank,"center_rank"=>rank+Int(charged),"local_site"=>site,
        "direction"=>family=="SA" ? nothing : direction,
        "execution"=>execution_parameters(config),"model"=>model,
        "model_parameters"=>model_parameters,"interaction_distances"=>[1,2],
        "operation_scope"=>"complete_sparse_site_stage")
    builder = function(rng)
        previous = configure_threads(config)
        cache = nothing
        try
            fixture = build_state(rng,symmetry,D,rank,charged)
            cache = TangentEnvironment(fixture.base,fixture.H;disk=false)
            prepared = _ms_prepare(fixture,cache,stage,direction,site)
            operation = prepared.operation
            benchmark = @benchmarkable $operation() setup=(configure_threads($config)) evals=1
            cleanup = ()->begin finalize(cache); restore_threads(previous); end
            return (;benchmark,parameters=merge(copy(fixture.parameters),prepared.metadata),cleanup)
        catch
            !isnothing(cache) && finalize(cache)
            restore_threads(previous)
            rethrow()
        end
    end
    return BenchmarkCase("basic/$(stage)/$(symmetry)/base$(rank)-center$(rank+Int(charged))/$(model)-r1r2/L16/$(orientation)/D$(D)/v1",
        builder;parameters,warmup_options(parameters)...,seconds=60,samples=5,evals=1,description=descriptions[family])
end

function mul_stage_cases(config)
    cases = BenchmarkCase[]
    for symmetry in ("NoSym","U1","SU2","U1xSU2"), rank in (3,4), charged in (false,true),
        D in dimensions(symmetry), family in ("SA","RA","RC")
        for direction in (family=="SA" ? ("right",) : ("right","left"))
            push!(cases,_ms_case(config,family,symmetry,D,rank,charged,direction))
        end
    end
    return cases
end
