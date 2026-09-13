using LinearAlgebra: norm

_ms_tensor(A::AbstractTensorMap) = A
_ms_tensor(A) = A.A

function _ms_finite(value)
    isnothing(value) && return true
    value isa Union{Tuple,AbstractVector} && return all(_ms_finite, value)
    return isfinite(norm(_ms_tensor(value)))
end

function _ms_nonzero(value)
    isnothing(value) && return false
    value isa Union{Tuple,AbstractVector} && return any(_ms_nonzero, value)
    return norm(_ms_tensor(value)) > 0
end

function _ms_equal(actual, expected)
    (isnothing(actual) || isnothing(expected)) && return isnothing(actual) && isnothing(expected)
    if actual isa Union{Tuple,AbstractVector}
        return length(actual)==length(expected) && all(_ms_equal(a,b) for (a,b) in zip(actual,expected))
    end
    A, B = _ms_tensor(actual), _ms_tensor(expected)
    return space(A)==space(B) && isapprox(A,B; atol=1e-10,rtol=1e-8)
end

_ms_add(accumulator, value) = isnothing(accumulator) ? _ms_tensor(value) : accumulator + _ms_tensor(value)
_ms_add(accumulator, ::Nothing) = accumulator

function _ms_component_reference(stage, direction, arguments)
    if stage == "effective_site_action"
        left, center, operator, right = arguments
        result = nothing
        for i in axes(operator,1), j in axes(operator,2)
            any(isnothing, (left[i],operator[i,j],right[j])) && continue
            result = _ms_add(result, _MS._action1(left[i],center,operator[i,j],right[j]))
        end
        return result
    elseif stage == "center_reduction"
        first_vector, second_vector = arguments
        result = nothing
        for (left,right) in zip(first_vector,second_vector)
            (isnothing(left) || isnothing(right)) && continue
            result = _ms_add(result, _MS._mul_LR(left,right))
        end
        return result
    end
    base_environment, incoming, bra, operator, center, base_ket = arguments
    output_length = direction == "right" ? size(operator,2) : size(operator,1)
    full = Any[nothing for _ in 1:output_length]
    partial = Any[nothing for _ in 1:output_length]
    recurse = direction == "right" ? _MS._recurseEl : _MS._recurseEr
    for i in axes(operator,1), j in axes(operator,2)
        isnothing(operator[i,j]) && continue
        input_index, output_index = direction == "right" ? (i,j) : (j,i)
        a,b = recurse(base_environment[input_index],incoming[input_index],bra,
                      operator[i,j],center,base_ket)
        full[output_index] = _ms_add(full[output_index],a)
        partial[output_index] = _ms_add(partial[output_index],b)
    end
    return full,partial
end


function check_mul_stage(prepared, stage, direction, expected_center; actual=prepared.operation())
    _ms_finite(actual) && _ms_nonzero(actual) || return false
    previous_action = FiniteMPS.get_num_threads_action()
    try
        FiniteMPS.set_num_threads_action(1)
        serial = prepared.operation()
        reference = _ms_component_reference(stage,direction,prepared.arguments)
        _ms_equal(actual,serial) && _ms_equal(serial,reference) || return false
    finally
        FiniteMPS.set_num_threads_action(previous_action)
    end
    if stage != "tangent_recursion"
        space(_ms_tensor(actual))==space(expected_center.A) || return false
        numind(_ms_tensor(actual))==numind(expected_center) || return false
    end
    return true
end

