# FiniteMPSTangents.jl

```@meta
CurrentModule = FiniteMPSTangents
```

FiniteMPSTangents.jl provides tangent-space types and operations for finite
matrix-product states (MPS) from
[`FiniteMPS.jl`](https://github.com/Qiaoyi-Li/FiniteMPS.jl).

## Quick start

As a minimal example, we first construct a tangent MPS from a dense MPS object
via the natural isomorphism. Then, we use the FiniteMPS API to construct a
one-site sparse MPO and apply it to the tangent vector. Finally, we use the
in-place `add!` function to demonstrate a linear combination.

```@example quickstart
using FiniteMPSTangents
using FiniteMPSTangents.FiniteMPS
using Random

Random.seed!(1234)

L = 4
physical_space = NoSymSpinOneHalf.pspace
state = randMPS(ComplexF64, L, physical_space, ℂ^2)

base = BaseMPS(state)
tangent = TangentMPS(base)

operator_tree = InteractionTree(L)
addIntr!(operator_tree, NoSymSpinOneHalf.Sz, 2, 1.0; name=:Sz)
operator = AutomataMPO(operator_tree)
product = operator * tangent

combination = partialcopy(tangent)
add!(combination, product, 0.5, 1.0)

(norm(tangent), norm(product), norm(combination))
```

Here `combination` is ``0.5(\mathrm{operator} * \mathrm{tangent}) +
\mathrm{tangent}``. `partialcopy` copies the tangent tensors while retaining
the common base point.

See the [Public API](@ref public_api) for the exported interface.

```@contents
Pages = ["api.md"]
Depth = 2
```
