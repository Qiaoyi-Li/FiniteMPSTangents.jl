# [Public API](@id public_api)

```@meta
CurrentModule = FiniteMPSTangents
```

## Types and construction

```@docs
BaseMPS
TangentMPS
TangentEnvironment
```

## Projection and operator action

```@docs
orth!
mul!
mul
```

## Tangent-vector algebra

These methods extend the corresponding `Base`, `LinearAlgebra`, or FiniteMPS
generic functions for `TangentMPS`.

```@docs
partialcopy
adjoint
similar
scalartype
norm
normalize!
inner
add!
rmul!
free!
```

## Observables

```@docs
calObs!
```
