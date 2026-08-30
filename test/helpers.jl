function identity_fixture(L::Int; site::Int=cld(L, 2))
    physical = NoSymSpinOneHalf.pspace
    state = randMPS(ComplexF64, L, physical, ℂ^2)

    tree = InteractionTree(L)
    addIntr!(tree, id(physical), site, 1.0; name=:I)
    operator = AutomataMPO(tree)

    base = BaseMPS(state)
    tangent = TangentMPS(base)
    return (; state, operator, base, tangent)
end

function tangent_difference_norm(x::TangentMPS, y::TangentMPS)
    difference = partialcopy(x)
    add!(difference, y, -1, 1)
    return norm(difference)
end

function scaled_copy(x::TangentMPS, coefficient::Number)
    result = partialcopy(x)
    rmul!(result, coefficient)
    return result
end
