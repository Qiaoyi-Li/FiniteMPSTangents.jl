#        c d
#        |/
#     a--B--e
#        |
#        b
#        |
#     a--A--e
#        |
#        c
function inner(A::MPSTensor{3}, B::MPSTensor{4})
     @tensor tmp[d] := A.A'[e a b] * B.A[a b d e]
     return tmp
end
function inner(A::MPSTensor{4}, B::MPSTensor{5})
     @tensor tmp[d] := A.A'[c e a b] * B.A[a b c d e]
     return tmp
end
