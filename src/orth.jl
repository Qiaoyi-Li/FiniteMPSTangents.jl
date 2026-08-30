# left orthogonalization
#       c d
#       |/
#  a -- A -- e
#  |    |
#  |    b
#  |    |
#  a---Al*---f
#       |    |
#       c    |
#            |
#       i    |
#       |    |
#   g---Al---f
#       |
#       h
function _LeftOrthProj!(A::MPSTensor{4}, Al::MPSTensor{3})::MPSTensor{4}
     @tensor tmp[g h; d e] := (A.A[a b d e] * Al.A'[f a b]) * Al.A[g h f]
     add!(A.A, tmp, -1.0)
     return A
end

function _LeftOrthProj!(A::MPSTensor{3}, Al::MPSTensor{3})::MPSTensor{3}
     @tensor tmp[g h; e] := (A.A[a b e] * Al.A'[f a b]) * Al.A[g h f]
     add!(A.A, tmp, -1.0)
     return A
end

function _LeftOrthProj!(A::MPSTensor{4}, Al::MPSTensor{4})::MPSTensor{4}
     @tensor tmp[g h; i e] := (A.A[a b c e] * Al.A'[c f a b]) * Al.A[g h i f]
     add!(A.A, tmp, -1.0)
     return A
end

function _LeftOrthProj!(A::MPSTensor{5}, Al::MPSTensor{4})::MPSTensor{5}
     @tensor tmp[g h; i d e] := (A.A[a b c d e] * Al.A'[c f a b]) * Al.A[g h i f]
     add!(A.A, tmp, -1.0)
     return A
end
