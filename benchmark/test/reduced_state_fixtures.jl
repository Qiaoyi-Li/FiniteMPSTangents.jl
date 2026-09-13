function small_chain_fixture(symmetry,rank,charged;spinless=false)
    rng = Xoshiro(20260912)
    P = physical_space(symmetry;spinless)
    template = bond_spaces(symmetry,first(dimensions(symmetry)),rank;spinless)
    # Preserve fusion support while reducing multiplicities for correctness checks.
    spaces = [symmetry=="NoSym" ? ℂ^min(dim(V),4) :
              PerformanceFixtures._rep(symmetry,[c=>1 for c in sectors(V)]) for V in template]
    tensors = [MPSTensor(PerformanceFixtures.random_map(rng,spaces[i]⊗P,
        rank==3 ? spaces[i+1] : P⊗spaces[i+1])) for i in 1:16]
    psi = MPS(tensors)
    canonicalize!(psi,1)
    normalize!(psi)
    base = BaseMPS(psi)
    tangent = random_tangent(rng,base;charged,Q=charge_space(symmetry))
    return (;base,tangent,H=spinless ? nothing : hamiltonian(symmetry),parameters=Dict{String,Any}())
end

