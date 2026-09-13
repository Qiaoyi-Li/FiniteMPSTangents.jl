using BenchmarkTools
using LinearAlgebra
using FiniteMPSTangents
using FiniteMPSTangents.FiniteMPS
using .PerformanceFixtures

function _ep_prepare(fixture, cache, direction, site)
    local_H = fixture.H[site]
    if direction=="right"
        incoming = FiniteMPSTangents._getEl(cache,site)
        tensor = fixture.base.Al[site]
        propagate = FiniteMPSTangents._pushright
    else
        incoming = FiniteMPSTangents._getEr(cache,site)
        tensor = fixture.base.Ar[site]
        propagate = FiniteMPSTangents._pushleft
    end
    adjoint_tensor = tensor'
    left_space,right_space = codomain(tensor.A)[1],domain(tensor.A)[end]
    input_dimension,output_dimension = direction=="right" ?
        (dim(left_space),dim(right_space)) : (dim(right_space),dim(left_space))
    transitions = [(i,j) for i in axes(local_H,1),j in axes(local_H,2) if !isnothing(local_H[i,j])]
    reachable = [(i,j) for (i,j) in transitions if !isnothing(incoming[direction=="right" ? i : j])]
    output_channels = size(local_H,direction=="right" ? 2 : 1)
    active_output = length(Set(direction=="right" ? j : i for (i,j) in reachable))
    metadata = Dict{String,Any}(
        "input_bond_dimension"=>Int(input_dimension),"output_bond_dimension"=>Int(output_dimension),
        "input_environment_channels"=>length(incoming),"output_environment_channels"=>output_channels,
        "active_input_channels"=>count(!isnothing,incoming),"active_output_channels"=>active_output,
        "active_channel_convention"=>"non-nothing sparse entries; output occupancy follows reachable MPO paths",
        "local_mpo_nonempty_transitions"=>length(transitions),"reachable_transition_count"=>length(reachable),
        "identity_transition_count"=>count(ij->local_H[ij...] isa IdentityOperator,reachable),
        "local_operator_transition_count"=>count(ij->local_H[ij...] isa LocalOperator,reachable),
        "local_left_space"=>describe_space(left_space),"local_right_space"=>describe_space(right_space))
    arguments = (incoming,adjoint_tensor,local_H,tensor)
    operation = ()->propagate(arguments...)
    return (;operation,propagate,arguments,metadata)
end

function _environment_step_case(config,sym,D,rank,direction)
    direction in ("right","left") || throw(ArgumentError("Unknown environment propagation direction"))
    model = Dict("NoSym"=>"TFI","U1"=>"XXZ","SU2"=>"Heisenberg","U1xSU2"=>"Hubbard")[sym]
    site = direction=="right" ? 8 : 9
    configuration = "base$(rank)/$(model)-r1r2/$direction"
    parameters = Dict{String,Any}(
        "section"=>"basic","family"=>"EP","symmetry"=>sym,"configuration"=>configuration,
        "nominal_D"=>D,"base_rank"=>rank,"center_rank"=>rank,
        "execution"=>execution_parameters(config),"direction"=>direction,"local_site"=>site,
        "operation_scope"=>"single sparse environment-vector propagation",
        "model"=>model,"interaction_distances"=>[1,2],
        "model_parameters"=>sym=="U1xSU2" ? Dict("t1"=>1.0,"t2"=>0.5,"U"=>4.0,"mu"=>2.0) :
            sym=="U1" ? Dict("J1"=>1.0,"J2"=>0.2,"Delta"=>0.7) :
            sym=="NoSym" ? Dict("J1"=>1.0,"J2"=>0.2,"h"=>1.05) : Dict("J1"=>1.0,"J2"=>0.2))
    return BenchmarkCase("basic/environment-step/$sym/$configuration/L16/D$D/v1",rng->begin
        previous_blas = BLAS.get_num_threads()
        previous = configure_threads(config)
        cache = nothing
        released = false
        cleanup = ()->begin
            released && return nothing
            released = true
            try
                isnothing(cache) || finalize(cache)
            finally
                restore_threads(previous)
                BLAS.set_num_threads(previous_blas)
            end
            return nothing
        end
        try
            fixture = build_state(rng,sym,D,rank,false)
            cache = TangentEnvironment(fixture.base,fixture.H;disk=false)
            prepared = _ep_prepare(fixture,cache,direction,site)
            extra = copy(fixture.parameters)
            # This operation contracts base tensors; no tangent charge leg is an input.
            delete!(extra,"charge_space")
            merge!(extra,prepared.metadata)
            operation = prepared.operation
            benchmark = @benchmarkable $operation() setup=(configure_threads($config))
            return (;benchmark,parameters=extra,cleanup)
        catch
            cleanup()
            rethrow()
        end
    end;parameters,warmup_options(parameters)...,seconds=60.0,samples=5,evals=1,
        description="Propagate one full sparse base-environment vector through a central site of the range-one and range-two model, including output allocation, channel accumulation, dispatch, and contraction timers.")
end

function environment_cases(config)
    return BenchmarkCase[_environment_step_case(config,sym,D,rank,direction)
        for sym in ("NoSym","U1","SU2","U1xSU2") for rank in (3,4)
        for direction in ("right","left") for D in dimensions(sym)]
end
