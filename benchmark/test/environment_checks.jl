using LinearAlgebra: norm

_ep_finite(entry) = isnothing(entry) || all(pair->all(isfinite,last(pair)),blocks(entry.A))
_ep_active(entry) = !isnothing(entry) && _ep_finite(entry) && norm(entry.A)>0

function _ep_agrees(actual,expected)
    length(actual)==length(expected) || return false
    return all(zip(actual,expected)) do (a,b)
        if isnothing(a) || isnothing(b)
            return isnothing(a) && isnothing(b)
        end
        return space(a.A)==space(b.A) && _ep_finite(a) &&
            isapprox(a.A,b.A;atol=1e-11,rtol=1e-9)
    end
end

function _ep_serial(propagate,incoming,A,H,B)
    previous = FiniteMPS.get_num_threads_action()
    try
        FiniteMPS.set_num_threads_action(1)
        return propagate(incoming,A,H,B)
    finally
        FiniteMPS.set_num_threads_action(previous)
    end
end

function check_environment_step(prepared, expected; expected_rank, expected_output_dimension)
    incoming, adjoint_tensor, local_H, tensor = prepared.arguments
    original_input = deepcopy(incoming)
    actual = prepared.operation()
    serial = _ep_serial(prepared.propagate,incoming,adjoint_tensor,local_H,tensor)
    return numind(tensor.A)==expected_rank &&
        prepared.metadata["output_bond_dimension"]==expected_output_dimension &&
        all(_ep_finite,incoming) && all(_ep_finite,expected) && all(_ep_finite,actual) &&
        count(_ep_active,incoming)>1 && count(_ep_active,expected)>1 &&
        count(_ep_active,actual)==prepared.metadata["active_output_channels"] &&
        _ep_agrees(actual,expected) && _ep_agrees(actual,serial) &&
        _ep_agrees(incoming,original_input)
end
