# Performance report

Source commit: `9f17e245d554734b3ff65513ffc9593821540e89`

Julia uses 1, 2, or 4 compute threads; the linear algebra backend and garbage collector each use 1 thread.

| Thread configuration | Measurements | Measurement timestamp (UTC) | Detailed report |
| --- | ---: | --- | --- |
| 1 thread | 447 | 2026-10-04T17:12:30.809Z | [Input and sampling details](configurations/julia-1-blas-1/report.md) |
| 2 threads | 447 | 2026-10-04T18:02:27.405Z | [Input and sampling details](configurations/julia-2-blas-1/report.md) |
| 4 threads | 447 | 2026-10-04T18:42:49.798Z | [Input and sampling details](configurations/julia-4-blas-1/report.md) |

The tables show median execution times for each center bond dimension, including the full dimensions of symmetry multiplets.


## Sparse operator action on tangent vectors


### No symmetry


#### Sparse operator action · transverse-field Ising model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 56.047 milliseconds | 37.4 milliseconds | 39.216 milliseconds |
| 128 | 175.87 milliseconds | 107.11 milliseconds | 114.35 milliseconds |
| 256 | 376.04 milliseconds | 226.17 milliseconds | 223.66 milliseconds |

#### Sparse operator action · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 99.059 milliseconds | 67.738 milliseconds | 69.352 milliseconds |
| 128 | 380.83 milliseconds | 217.44 milliseconds | 213.45 milliseconds |
| 256 | 776.11 milliseconds | 467.44 milliseconds | 428.62 milliseconds |

#### Sparse operator action · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 180.98 milliseconds | 114.57 milliseconds | 111.63 milliseconds |
| 128 | 1.2787 seconds | 879.78 milliseconds | 850.17 milliseconds |
| 256 | 7.2486 seconds | 4.4065 seconds | 4.2832 seconds |

#### Sparse operator action · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 363.48 milliseconds | 219.76 milliseconds | 211.92 milliseconds |
| 128 | 2.3051 seconds | 1.4515 seconds | 1.3764 seconds |
| 256 | 14.85 seconds | 9.0722 seconds | 8.5809 seconds |

### U(1) symmetry


#### Sparse operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 69.344 milliseconds | 52.117 milliseconds | 53.374 milliseconds |
| 128 | 105.44 milliseconds | 69.631 milliseconds | 67.964 milliseconds |
| 256 | 128.25 milliseconds | 82.904 milliseconds | 80.137 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 92.917 milliseconds | 62.397 milliseconds | 60.279 milliseconds |
| 128 | 130.92 milliseconds | 92.518 milliseconds | 92.735 milliseconds |
| 256 | 145.6 milliseconds | 97.203 milliseconds | 90.68 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 157.52 milliseconds | 97.306 milliseconds | 97.473 milliseconds |
| 128 | 312.44 milliseconds | 187.81 milliseconds | 182.76 milliseconds |
| 256 | 1.2642 seconds | 803.53 milliseconds | 808.34 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 165.46 milliseconds | 108.26 milliseconds | 113.15 milliseconds |
| 128 | 460.15 milliseconds | 204.96 milliseconds | 199.49 milliseconds |
| 256 | 1.2375 seconds | 810.89 milliseconds | 827.92 milliseconds |

### SU(2) symmetry


#### Sparse operator action · Heisenberg spin model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 24.352 milliseconds | 21.229 milliseconds | 21.242 milliseconds |
| 128 | 26.732 milliseconds | 21.789 milliseconds | 23.716 milliseconds |
| 256 | 27.234 milliseconds | 22.506 milliseconds | 23.164 milliseconds |

#### Sparse operator action · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 63.538 milliseconds | 51.039 milliseconds | 53.447 milliseconds |
| 128 | 62.447 milliseconds | 46.883 milliseconds | 44.771 milliseconds |
| 256 | 101.42 milliseconds | 50.46 milliseconds | 50.219 milliseconds |

#### Sparse operator action · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 57.787 milliseconds | 34.37 milliseconds | 39.031 milliseconds |
| 128 | 71.618 milliseconds | 40.793 milliseconds | 46.415 milliseconds |
| 256 | 105.58 milliseconds | 79.479 milliseconds | 78.601 milliseconds |

#### Sparse operator action · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 130.64 milliseconds | 86.884 milliseconds | 84.951 milliseconds |
| 128 | 170.59 milliseconds | 107.84 milliseconds | 114.82 milliseconds |
| 256 | 292.19 milliseconds | 184.52 milliseconds | 191.27 milliseconds |

### U(1) × SU(2) symmetry


#### Sparse operator action · Hubbard fermion model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 118.88 milliseconds | 76.185 milliseconds | 84.492 milliseconds |
| 255 | 164.94 milliseconds | 104.59 milliseconds | 116.68 milliseconds |
| 511 | 601.06 milliseconds | 186.84 milliseconds | 179.61 milliseconds |

#### Sparse operator action · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.1965 seconds | 884.15 milliseconds | 1.1675 seconds |
| 255 | 782.73 milliseconds | 214.68 milliseconds | 235.62 milliseconds |
| 511 | 591.71 milliseconds | 367.22 milliseconds | 823.99 milliseconds |

#### Sparse operator action · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 443.38 milliseconds | 261.26 milliseconds | 257.89 milliseconds |
| 255 | 1.1801 seconds | 452.65 milliseconds | 435.29 milliseconds |
| 511 | 1.7015 seconds | 1.2068 seconds | 1.2498 seconds |

#### Sparse operator action · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.0948 seconds | 643.11 milliseconds | 623.41 milliseconds |
| 255 | 15.497 seconds | 11.507 seconds | 12.578 seconds |
| 511 | 21.26 seconds | 14.4 seconds | 14.984 seconds |

## Complete observable calculations


### No symmetry


#### Complete observable calculation · spin one-half · combined observables across different numbers of sites · ordinary MPS, no extra center legs


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 124.79 milliseconds | 58.513 milliseconds | 56.732 milliseconds |
| 128 | 447.19 milliseconds | 222.91 milliseconds | 214.8 milliseconds |
| 256 | 1.0508 seconds | 511.32 milliseconds | 490.11 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 34.318 milliseconds | 18.689 milliseconds | 17.892 milliseconds |
| 128 | 147.35 milliseconds | 66.492 milliseconds | 63.501 milliseconds |
| 256 | 296.69 milliseconds | 143.09 milliseconds | 137.57 milliseconds |

#### Complete observable calculation · spin one-half · single-site observables · ordinary MPS, no extra center legs


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 31.84 milliseconds | 17.347 milliseconds | 21.789 milliseconds |
| 128 | 127.26 milliseconds | 62.345 milliseconds | 67.735 milliseconds |
| 256 | 298.08 milliseconds | 139.85 milliseconds | 148.67 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 114.58 milliseconds | 47.374 milliseconds | 42.723 milliseconds |
| 128 | 374.84 milliseconds | 186.98 milliseconds | 181.09 milliseconds |
| 256 | 844.03 milliseconds | 419.63 milliseconds | 406.89 milliseconds |

### U(1) symmetry


#### Complete observable calculation · spinless fermions · combined observables across different numbers of sites · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 285.86 milliseconds | 151.3 milliseconds | 129.01 milliseconds |
| 128 | 500.18 milliseconds | 284.44 milliseconds | 235.99 milliseconds |
| 256 | 1.4525 seconds | 838.86 milliseconds | 744.6 milliseconds |

#### Complete observable calculation · spinless fermions · multisite correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 92.718 milliseconds | 52.614 milliseconds | 49.059 milliseconds |
| 128 | 174.9 milliseconds | 92.078 milliseconds | 85.241 milliseconds |
| 256 | 523.72 milliseconds | 315.18 milliseconds | 287.38 milliseconds |

#### Complete observable calculation · spinless fermions · single-site observables · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 73.445 milliseconds | 62.568 milliseconds | 73.625 milliseconds |
| 128 | 90.974 milliseconds | 61.654 milliseconds | 63.903 milliseconds |
| 256 | 279.77 milliseconds | 179.33 milliseconds | 174.86 milliseconds |

#### Complete observable calculation · spinless fermions · two-site correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 277.21 milliseconds | 176.65 milliseconds | 181.93 milliseconds |
| 128 | 462.07 milliseconds | 292.86 milliseconds | 272.61 milliseconds |
| 256 | 1.3345 seconds | 797.51 milliseconds | 738.4 milliseconds |

#### Complete observable calculation · spin one-half · combined observables across different numbers of sites · ordinary MPS, no extra center legs


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 81.119 milliseconds | 47.667 milliseconds | 42.83 milliseconds |
| 128 | 121.17 milliseconds | 65.785 milliseconds | 57.486 milliseconds |
| 256 | 178.81 milliseconds | 87.007 milliseconds | 85.693 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 17.542 milliseconds | 10.24 milliseconds | 10.221 milliseconds |
| 128 | 26.599 milliseconds | 15.005 milliseconds | 14.785 milliseconds |
| 256 | 35.556 milliseconds | 19.361 milliseconds | 19.951 milliseconds |

#### Complete observable calculation · spin one-half · single-site observables · ordinary MPS, no extra center legs


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 12.97 milliseconds | 8.1651 milliseconds | 8.2029 milliseconds |
| 128 | 17.788 milliseconds | 10.57 milliseconds | 10.258 milliseconds |
| 256 | 24.817 milliseconds | 14.159 milliseconds | 14.117 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 72.077 milliseconds | 46.304 milliseconds | 40.967 milliseconds |
| 128 | 122.39 milliseconds | 59.978 milliseconds | 55.273 milliseconds |
| 256 | 180.2 milliseconds | 79.809 milliseconds | 74.913 milliseconds |

### SU(2) symmetry


#### Complete observable calculation · spin one-half · combined two-site and four-site correlations · ordinary MPS, no extra center legs


Calculate the registered combined two-site and four-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 34.062 milliseconds | 20.761 milliseconds | 19.92 milliseconds |
| 128 | 43.013 milliseconds | 22.774 milliseconds | 21.779 milliseconds |
| 256 | 41.493 milliseconds | 23.985 milliseconds | 23.358 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 14.904 milliseconds | 8.4061 milliseconds | 8.6899 milliseconds |
| 128 | 16.539 milliseconds | 9.4578 milliseconds | 9.8177 milliseconds |
| 256 | 17.879 milliseconds | 10.086 milliseconds | 10.066 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 29.075 milliseconds | 17.072 milliseconds | 17.32 milliseconds |
| 128 | 35.951 milliseconds | 19.317 milliseconds | 18.755 milliseconds |
| 256 | 35.812 milliseconds | 20.739 milliseconds | 20.034 milliseconds |

#### Complete observable calculation · spin one-half · single-site matrix elements with an open spin channel · ordinary MPS, bra has no extra leg; ket has an extra charge leg


Calculate the registered single-site matrix elements with an open spin channel over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 27.104 milliseconds | 17.86 milliseconds | 16.662 milliseconds |
| 128 | 29.618 milliseconds | 21.584 milliseconds | 19.319 milliseconds |
| 256 | 31.928 milliseconds | 23.554 milliseconds | 21.078 milliseconds |

#### Complete observable calculation · spin one-half · single-site matrix elements with an open spin channel · MPO with a purification leg, bra has no extra leg; ket has an extra charge leg


Calculate the registered single-site matrix elements with an open spin channel over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 62.538 milliseconds | 44.941 milliseconds | 39.512 milliseconds |
| 128 | 112.67 milliseconds | 103.59 milliseconds | 92.745 milliseconds |
| 256 | 172.11 milliseconds | 125.87 milliseconds | 117.29 milliseconds |

### U(1) × SU(2) symmetry


#### Complete observable calculation · spinful fermions · combined observables across different numbers of sites · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 24.555 seconds | 16.574 seconds | 16.967 seconds |
| 255 | 49.937 seconds | 32.597 seconds | 32.725 seconds |
| 511 | 61.513 seconds | 42.278 seconds | 42.455 seconds |

#### Complete observable calculation · spinful fermions · multisite correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 9.8329 seconds | 7.2476 seconds | 6.9447 seconds |
| 255 | 17.973 seconds | 13.308 seconds | 12.587 seconds |
| 511 | 22.234 seconds | 15.881 seconds | 15.455 seconds |

#### Complete observable calculation · spinful fermions · singlet pairing and spin-bond correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered singlet pairing and spin-bond correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 9.1832 seconds | 6.1828 seconds | 6.124 seconds |
| 255 | 16.532 seconds | 11.803 seconds | 11.419 seconds |
| 511 | 20.089 seconds | 14.52 seconds | 14.367 seconds |

#### Complete observable calculation · spinful fermions · single-site observables · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 377.11 milliseconds | 183.5 milliseconds | 186.58 milliseconds |
| 255 | 572.13 milliseconds | 394.39 milliseconds | 418.32 milliseconds |
| 511 | 922.73 milliseconds | 587.66 milliseconds | 534.5 milliseconds |

#### Complete observable calculation · spinful fermions · two-site correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 20.416 seconds | 13.812 seconds | 13.978 seconds |
| 255 | 40.599 seconds | 27.406 seconds | 27.747 seconds |
| 511 | 51.86 seconds | 35.234 seconds | 35.429 seconds |

## Supporting whole-chain operations


### No symmetry


#### Left and right canonicalization of base tensors · ordinary MPS


Construct the base tensor&#39;s canonical forms through left and right orthogonal factorizations and contractions, including the associated copying and memory allocation.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 8.0516 milliseconds | 8.0129 milliseconds | 7.9753 milliseconds |
| 128 | 26.252 milliseconds | 26.032 milliseconds | 26.195 milliseconds |
| 256 | 52.137 milliseconds | 51.192 milliseconds | 52.61 milliseconds |

#### Left orthogonal projection of a tangent vector · ordinary MPS, tangent center with no extra leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.4545 milliseconds | 810.16 microseconds | 841.78 microseconds |
| 128 | 5.0424 milliseconds | 2.8237 milliseconds | 2.6723 milliseconds |
| 256 | 11.087 milliseconds | 6.3801 milliseconds | 9.2496 milliseconds |

#### Left orthogonal projection of a tangent vector · MPO with a purification leg, tangent center with no extra leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.937 milliseconds | 2.5668 milliseconds | 2.5117 milliseconds |
| 128 | 28.298 milliseconds | 16.567 milliseconds | 14.528 milliseconds |
| 256 | 209.02 milliseconds | 111.64 milliseconds | 101.25 milliseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 31.669 microseconds | 78.155 microseconds | 238.83 microseconds |
| 128 | 101.58 microseconds | 119.35 microseconds | 193.89 microseconds |
| 256 | 125.24 microseconds | 287.92 microseconds | 300 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra component leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 360.03 microseconds | 291.4 microseconds | 422.71 microseconds |
| 128 | 1.0501 milliseconds | 714.1 microseconds | 1.3309 milliseconds |
| 256 | 4.585 milliseconds | 3.2123 milliseconds | 3.3109 milliseconds |

### U(1) symmetry


#### Left orthogonal projection of a tangent vector · ordinary MPS, tangent center with an extra charge leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 648.79 microseconds | 588.98 microseconds | 653.38 microseconds |
| 128 | 933.9 microseconds | 694.02 microseconds | 695.62 microseconds |
| 256 | 1.2054 milliseconds | 859.7 microseconds | 843.87 microseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 8.015 microseconds | 75.09 microseconds | 64.531 microseconds |
| 128 | 29.145 microseconds | 202.8 microseconds | 185.63 microseconds |
| 256 | 43.21 microseconds | 201.97 microseconds | 360.1 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 30.467 microseconds | 196.55 microseconds | 71.925 microseconds |
| 128 | 95.889 microseconds | 117.17 microseconds | 279.79 microseconds |
| 256 | 285.82 microseconds | 272.24 microseconds | 288.49 microseconds |

### SU(2) symmetry


#### Full-chain environment construction · Heisenberg spin model · MPO with a purification leg


Build left and right environments over the full chain from an MPO base and the Heisenberg operator, including contraction and allocation; environment cleanup is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 22.749 milliseconds | 13.952 milliseconds | 15.743 milliseconds |
| 128 | 28.57 milliseconds | 17.305 milliseconds | 19.534 milliseconds |
| 256 | 41.388 milliseconds | 24.843 milliseconds | 24.048 milliseconds |

#### Left and right canonicalization of base tensors · MPO with a purification leg


Construct the base tensor&#39;s canonical forms through left and right orthogonal factorizations and contractions, including the associated copying and memory allocation.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 3.6594 milliseconds | 3.7256 milliseconds | 3.6896 milliseconds |
| 128 | 5.3468 milliseconds | 5.4415 milliseconds | 5.3201 milliseconds |
| 256 | 9.5795 milliseconds | 9.3526 milliseconds | 9.2763 milliseconds |

#### Left orthogonal projection of a tangent vector · MPO with a purification leg, tangent center with an extra charge leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 2.1497 milliseconds | 1.4128 milliseconds | 1.2951 milliseconds |
| 128 | 2.7416 milliseconds | 1.7861 milliseconds | 1.5431 milliseconds |
| 256 | 4.8409 milliseconds | 2.6582 milliseconds | 2.3127 milliseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 67.446 microseconds | 96.661 microseconds | 122.03 microseconds |
| 128 | 128.09 microseconds | 122.38 microseconds | 121 microseconds |
| 256 | 131.64 microseconds | 168.58 microseconds | 130.64 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 112.89 microseconds | 144.12 microseconds | 165.36 microseconds |
| 128 | 224.37 microseconds | 203.04 microseconds | 185.51 microseconds |
| 256 | 294.67 microseconds | 247.39 microseconds | 434.77 microseconds |

### U(1) × SU(2) symmetry


#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 482.76 microseconds | 361.22 microseconds | 502.99 microseconds |
| 255 | 617.27 microseconds | 442.87 microseconds | 685.13 microseconds |
| 511 | 790.79 microseconds | 628.2 microseconds | 824.66 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 966.68 microseconds | 706.15 microseconds | 906.08 microseconds |
| 255 | 1.6474 milliseconds | 1.0696 milliseconds | 1.4496 milliseconds |
| 511 | 2.4531 milliseconds | 1.5908 milliseconds | 1.9188 milliseconds |

## Internal calculation stages


### No symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.6526 milliseconds | 1.5334 milliseconds | 1.5966 milliseconds |
| 128 | 17.081 milliseconds | 9.7273 milliseconds | 9.3596 milliseconds |
| 256 | 44.84 milliseconds | 24.763 milliseconds | 24.069 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.6221 milliseconds | 1.4933 milliseconds | 1.4894 milliseconds |
| 128 | 17.018 milliseconds | 9.3705 milliseconds | 9.2944 milliseconds |
| 256 | 54.559 milliseconds | 30.447 milliseconds | 29.895 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.3634 milliseconds | 3.2345 milliseconds | 3.067 milliseconds |
| 128 | 36.275 milliseconds | 20.05 milliseconds | 18.719 milliseconds |
| 256 | 104.12 milliseconds | 51.914 milliseconds | 48.715 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.1754 milliseconds | 2.9324 milliseconds | 2.8415 milliseconds |
| 128 | 33.875 milliseconds | 20.37 milliseconds | 18.844 milliseconds |
| 256 | 109.78 milliseconds | 62.406 milliseconds | 60.404 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.0698 milliseconds | 2.8134 milliseconds | 2.7272 milliseconds |
| 128 | 33.857 milliseconds | 19.102 milliseconds | 18.299 milliseconds |
| 256 | 267.16 milliseconds | 148.16 milliseconds | 136.06 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.9303 milliseconds | 4.4965 milliseconds | 2.5962 milliseconds |
| 128 | 43.272 milliseconds | 21.192 milliseconds | 18.131 milliseconds |
| 256 | 258.51 milliseconds | 146.18 milliseconds | 131.53 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 10.057 milliseconds | 5.7453 milliseconds | 5.304 milliseconds |
| 128 | 70.69 milliseconds | 43.706 milliseconds | 38.45 milliseconds |
| 256 | 548.13 milliseconds | 310.17 milliseconds | 303.59 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 12.979 milliseconds | 6.3632 milliseconds | 5.3361 milliseconds |
| 128 | 68.682 milliseconds | 38.351 milliseconds | 37.66 milliseconds |
| 256 | 537 milliseconds | 363.08 milliseconds | 292.62 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.806 milliseconds | 1.1081 milliseconds | 1.15 milliseconds |
| 128 | 11.775 milliseconds | 8.028 milliseconds | 6.4642 milliseconds |
| 256 | 32.787 milliseconds | 18.93 milliseconds | 18.341 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.4769 milliseconds | 1.959 milliseconds | 2.1724 milliseconds |
| 128 | 23.134 milliseconds | 13.242 milliseconds | 12.763 milliseconds |
| 256 | 82.53 milliseconds | 39.553 milliseconds | 36.394 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.516 milliseconds | 1.9722 milliseconds | 2.0305 milliseconds |
| 128 | 36.02 milliseconds | 16.199 milliseconds | 12.602 milliseconds |
| 256 | 176.84 milliseconds | 105.68 milliseconds | 99.573 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 6.7207 milliseconds | 3.7224 milliseconds | 3.7638 milliseconds |
| 128 | 71.05 milliseconds | 31.719 milliseconds | 25.854 milliseconds |
| 256 | 357.96 milliseconds | 203.38 milliseconds | 191.71 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.9653 milliseconds | 1.0965 milliseconds | 1.1232 milliseconds |
| 128 | 11.953 milliseconds | 6.7117 milliseconds | 6.3868 milliseconds |
| 256 | 33.706 milliseconds | 18.834 milliseconds | 18.777 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.0051 milliseconds | 1.126 milliseconds | 1.215 milliseconds |
| 128 | 12.145 milliseconds | 7.0102 milliseconds | 6.5791 milliseconds |
| 256 | 37.524 milliseconds | 19.415 milliseconds | 18.371 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.5906 milliseconds | 1.9592 milliseconds | 1.9733 milliseconds |
| 128 | 31.401 milliseconds | 13.839 milliseconds | 12.783 milliseconds |
| 256 | 179.64 milliseconds | 99.679 milliseconds | 93.544 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.0787 milliseconds | 2.2693 milliseconds | 2.07 milliseconds |
| 128 | 38.943 milliseconds | 16.656 milliseconds | 14.151 milliseconds |
| 256 | 192.59 milliseconds | 108.45 milliseconds | 105.09 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 446.17 microseconds | 308.35 microseconds | 282.23 microseconds |
| 128 | 3.1747 milliseconds | 1.6141 milliseconds | 1.5864 milliseconds |
| 256 | 12.005 milliseconds | 6.0389 milliseconds | 6.1368 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 448.46 microseconds | 408.05 microseconds | 301.74 microseconds |
| 128 | 3.1119 milliseconds | 1.6626 milliseconds | 1.754 milliseconds |
| 256 | 6.4014 milliseconds | 3.9479 milliseconds | 3.379 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 853.41 microseconds | 471.39 microseconds | 467.09 microseconds |
| 128 | 6.2751 milliseconds | 3.2775 milliseconds | 3.3742 milliseconds |
| 256 | 27.016 milliseconds | 12.062 milliseconds | 12.23 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 877.94 microseconds | 602.2 microseconds | 470.66 microseconds |
| 128 | 6.3875 milliseconds | 6.2457 milliseconds | 3.2024 milliseconds |
| 256 | 12.579 milliseconds | 6.5286 milliseconds | 6.3854 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 857.98 microseconds | 498.78 microseconds | 482.73 microseconds |
| 128 | 6.3406 milliseconds | 3.2857 milliseconds | 3.2804 milliseconds |
| 256 | 48.237 milliseconds | 27.725 milliseconds | 25.018 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 880.09 microseconds | 596.69 microseconds | 491.09 microseconds |
| 128 | 6.2139 milliseconds | 3.2443 milliseconds | 3.3575 milliseconds |
| 256 | 47.809 milliseconds | 24.167 milliseconds | 23.934 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.6603 milliseconds | 893.4 microseconds | 937.69 microseconds |
| 128 | 12.552 milliseconds | 6.3594 milliseconds | 6.4533 milliseconds |
| 256 | 94.547 milliseconds | 49.528 milliseconds | 51.952 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.7276 milliseconds | 1.7404 milliseconds | 1.1072 milliseconds |
| 128 | 12.817 milliseconds | 6.589 milliseconds | 7.5627 milliseconds |
| 256 | 103.24 milliseconds | 52.802 milliseconds | 51.589 milliseconds |

</details>


### U(1) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.9567 milliseconds | 1.1009 milliseconds | 1.0128 milliseconds |
| 128 | 4.6728 milliseconds | 2.8684 milliseconds | 2.2405 milliseconds |
| 256 | 8.1996 milliseconds | 4.1163 milliseconds | 3.8825 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.1037 milliseconds | 1.1214 milliseconds | 1.2144 milliseconds |
| 128 | 6.3973 milliseconds | 3.8786 milliseconds | 2.4187 milliseconds |
| 256 | 9.8527 milliseconds | 4.6929 milliseconds | 4.1192 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.4005 milliseconds | 1.4612 milliseconds | 1.4011 milliseconds |
| 128 | 5.3413 milliseconds | 4.2655 milliseconds | 2.3396 milliseconds |
| 256 | 8.5919 milliseconds | 4.7918 milliseconds | 4.2473 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.6919 milliseconds | 1.4285 milliseconds | 1.3907 milliseconds |
| 128 | 5.2878 milliseconds | 2.7627 milliseconds | 2.527 milliseconds |
| 256 | 10.107 milliseconds | 4.9726 milliseconds | 4.2955 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.3708 milliseconds | 1.8434 milliseconds | 1.8963 milliseconds |
| 128 | 9.1512 milliseconds | 4.6388 milliseconds | 4.2385 milliseconds |
| 256 | 46.495 milliseconds | 21.515 milliseconds | 15.71 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.1711 milliseconds | 2.745 milliseconds | 1.7214 milliseconds |
| 128 | 8.371 milliseconds | 4.5045 milliseconds | 4.0991 milliseconds |
| 256 | 34.496 milliseconds | 16.029 milliseconds | 15.138 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.9036 milliseconds | 3.3569 milliseconds | 2.001 milliseconds |
| 128 | 9.9213 milliseconds | 4.9784 milliseconds | 4.2487 milliseconds |
| 256 | 38.341 milliseconds | 16.763 milliseconds | 14.674 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.1676 milliseconds | 2.2462 milliseconds | 2.0346 milliseconds |
| 128 | 9.5767 milliseconds | 4.8426 milliseconds | 3.9008 milliseconds |
| 256 | 34.265 milliseconds | 16.279 milliseconds | 14.401 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.6388 milliseconds | 822.04 microseconds | 752.85 microseconds |
| 128 | 4.6299 milliseconds | 1.777 milliseconds | 1.7457 milliseconds |
| 256 | 11.677 milliseconds | 4.7844 milliseconds | 2.831 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.5242 milliseconds | 1.4077 milliseconds | 914.56 microseconds |
| 128 | 3.3381 milliseconds | 2.6723 milliseconds | 1.6983 milliseconds |
| 256 | 6.2622 milliseconds | 3.0524 milliseconds | 3.3542 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.2679 milliseconds | 1.3112 milliseconds | 1.3916 milliseconds |
| 128 | 6.4057 milliseconds | 4.0126 milliseconds | 3.7888 milliseconds |
| 256 | 22.112 milliseconds | 11.346 milliseconds | 9.6469 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.303 milliseconds | 1.2772 milliseconds | 1.3556 milliseconds |
| 128 | 5.8506 milliseconds | 3.4906 milliseconds | 3.0245 milliseconds |
| 256 | 20.483 milliseconds | 16.113 milliseconds | 8.9297 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.4101 milliseconds | 1.2957 milliseconds | 841.79 microseconds |
| 128 | 3.245 milliseconds | 1.7542 milliseconds | 1.8309 milliseconds |
| 256 | 5.7634 milliseconds | 3.0205 milliseconds | 2.8066 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.4827 milliseconds | 881.08 microseconds | 969.11 microseconds |
| 128 | 3.3958 milliseconds | 1.8941 milliseconds | 1.6489 milliseconds |
| 256 | 6.0097 milliseconds | 3.1378 milliseconds | 2.9079 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.2171 milliseconds | 1.3267 milliseconds | 1.2896 milliseconds |
| 128 | 6.0388 milliseconds | 3.8287 milliseconds | 2.9628 milliseconds |
| 256 | 21.704 milliseconds | 11.051 milliseconds | 9.7714 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.2244 milliseconds | 1.2818 milliseconds | 1.3096 milliseconds |
| 128 | 6.2867 milliseconds | 3.5718 milliseconds | 2.8767 milliseconds |
| 256 | 21.408 milliseconds | 11.041 milliseconds | 10.303 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 243.19 microseconds | 170.19 microseconds | 168.58 microseconds |
| 128 | 780.79 microseconds | 434.09 microseconds | 372.9 microseconds |
| 256 | 1.8305 milliseconds | 940.12 microseconds | 1.0917 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 196.69 microseconds | 199.34 microseconds | 122.57 microseconds |
| 128 | 634.47 microseconds | 574.95 microseconds | 348.41 microseconds |
| 256 | 920.14 microseconds | 859.55 microseconds | 640.02 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 232.96 microseconds | 263.16 microseconds | 279.22 microseconds |
| 128 | 664.6 microseconds | 417.15 microseconds | 574.54 microseconds |
| 256 | 1.5561 milliseconds | 878.2 microseconds | 837.74 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 251.68 microseconds | 175.78 microseconds | 168.2 microseconds |
| 128 | 666.49 microseconds | 610.61 microseconds | 478.07 microseconds |
| 256 | 1.0928 milliseconds | 618.14 microseconds | 635.18 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 357.95 microseconds | 248.29 microseconds | 250.96 microseconds |
| 128 | 1.2719 milliseconds | 687.89 microseconds | 636.43 microseconds |
| 256 | 5.6344 milliseconds | 3.1027 milliseconds | 2.7226 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 396.01 microseconds | 277.74 microseconds | 266.41 microseconds |
| 128 | 1.35 milliseconds | 713.14 microseconds | 787.27 microseconds |
| 256 | 5.4052 milliseconds | 2.9244 milliseconds | 2.6081 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 355.7 microseconds | 230.46 microseconds | 292.47 microseconds |
| 128 | 1.2082 milliseconds | 1.0667 milliseconds | 559.75 microseconds |
| 256 | 5.1554 milliseconds | 2.7078 milliseconds | 2.4065 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 370.87 microseconds | 251.46 microseconds | 271.86 microseconds |
| 128 | 1.2384 milliseconds | 694.61 microseconds | 613.18 microseconds |
| 256 | 5.2741 milliseconds | 2.5682 milliseconds | 2.2944 milliseconds |

</details>


### SU(2) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 641.03 microseconds | 686.63 microseconds | 579.83 microseconds |
| 128 | 868.4 microseconds | 863.88 microseconds | 637.85 microseconds |
| 256 | 1.1456 milliseconds | 1.0137 milliseconds | 949.73 microseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 680.75 microseconds | 690.86 microseconds | 459.71 microseconds |
| 128 | 898.01 microseconds | 937.56 microseconds | 732.89 microseconds |
| 256 | 1.408 milliseconds | 1.1102 milliseconds | 994.08 microseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.5176 milliseconds | 993.29 microseconds | 1.069 milliseconds |
| 128 | 2.5412 milliseconds | 2.3375 milliseconds | 1.7281 milliseconds |
| 256 | 3.5495 milliseconds | 2.924 milliseconds | 2.1218 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.5381 milliseconds | 987.96 microseconds | 1.0993 milliseconds |
| 128 | 2.7651 milliseconds | 2.3506 milliseconds | 1.7571 milliseconds |
| 256 | 3.6899 milliseconds | 3.0592 milliseconds | 2.0259 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.1605 milliseconds | 746.34 microseconds | 895.88 microseconds |
| 128 | 2.1571 milliseconds | 1.0638 milliseconds | 1.1991 milliseconds |
| 256 | 2.9376 milliseconds | 2.6516 milliseconds | 1.8382 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.1196 milliseconds | 737.76 microseconds | 886.47 microseconds |
| 128 | 1.7056 milliseconds | 1.6016 milliseconds | 1.1787 milliseconds |
| 256 | 3.0995 milliseconds | 2.6427 milliseconds | 2.2053 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 2.9083 milliseconds | 2.7301 milliseconds | 1.8117 milliseconds |
| 128 | 4.5829 milliseconds | 2.9593 milliseconds | 3.0168 milliseconds |
| 256 | 10.47 milliseconds | 7.4466 milliseconds | 5.6824 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 2.9774 milliseconds | 2.7544 milliseconds | 1.9363 milliseconds |
| 128 | 4.8419 milliseconds | 3.4314 milliseconds | 2.9136 milliseconds |
| 256 | 9.4893 milliseconds | 7.833 milliseconds | 5.3717 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 502.42 microseconds | 313.82 microseconds | 366.19 microseconds |
| 128 | 604.66 microseconds | 669.53 microseconds | 479.6 microseconds |
| 256 | 957.69 microseconds | 524.12 microseconds | 587.44 microseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 879.94 microseconds | 582.77 microseconds | 687.93 microseconds |
| 128 | 1.5482 milliseconds | 1.0595 milliseconds | 1.1394 milliseconds |
| 256 | 1.9693 milliseconds | 1.7576 milliseconds | 1.1446 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 854.49 microseconds | 512.28 microseconds | 549.6 microseconds |
| 128 | 1.1855 milliseconds | 1.2787 milliseconds | 861.08 microseconds |
| 256 | 2.0992 milliseconds | 1.9466 milliseconds | 1.43 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.7569 milliseconds | 1.5561 milliseconds | 1.1723 milliseconds |
| 128 | 2.64 milliseconds | 1.7787 milliseconds | 1.7505 milliseconds |
| 256 | 5.3669 milliseconds | 3.4596 milliseconds | 3.0806 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 450.36 microseconds | 292.85 microseconds | 315.9 microseconds |
| 128 | 634.78 microseconds | 703.74 microseconds | 462.08 microseconds |
| 256 | 768.17 microseconds | 547.47 microseconds | 603.15 microseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 469.87 microseconds | 275.26 microseconds | 302.24 microseconds |
| 128 | 664.15 microseconds | 448.79 microseconds | 378.75 microseconds |
| 256 | 778.65 microseconds | 565.12 microseconds | 547.66 microseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 776.3 microseconds | 524.97 microseconds | 591.54 microseconds |
| 128 | 1.0957 milliseconds | 744.37 microseconds | 810.29 microseconds |
| 256 | 1.883 milliseconds | 1.2485 milliseconds | 1.2386 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 778.47 microseconds | 456.9 microseconds | 623.58 microseconds |
| 128 | 1.0942 milliseconds | 684.99 microseconds | 729.38 microseconds |
| 256 | 1.8956 milliseconds | 1.0832 milliseconds | 1.1301 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 63.599 microseconds | 75.251 microseconds | 69.861 microseconds |
| 128 | 118.16 microseconds | 101.59 microseconds | 106.62 microseconds |
| 256 | 267.83 microseconds | 209.47 microseconds | 131.48 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 45.706 microseconds | 82.535 microseconds | 74.088 microseconds |
| 128 | 94.737 microseconds | 99.115 microseconds | 89.136 microseconds |
| 256 | 96.189 microseconds | 100.43 microseconds | 74.78 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 127.96 microseconds | 102.79 microseconds | 99.837 microseconds |
| 128 | 240.51 microseconds | 168.44 microseconds | 197.87 microseconds |
| 256 | 376.05 microseconds | 333.68 microseconds | 360.18 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 129.57 microseconds | 115.67 microseconds | 122.23 microseconds |
| 128 | 227.33 microseconds | 237.01 microseconds | 147.54 microseconds |
| 256 | 338.56 microseconds | 292.61 microseconds | 295.41 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 101.71 microseconds | 148.49 microseconds | 103.48 microseconds |
| 128 | 185.86 microseconds | 358.54 microseconds | 420.72 microseconds |
| 256 | 413.56 microseconds | 401.08 microseconds | 440.66 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 107.83 microseconds | 82.744 microseconds | 112.63 microseconds |
| 128 | 192.71 microseconds | 198.71 microseconds | 123 microseconds |
| 256 | 391.1 microseconds | 382.31 microseconds | 329.48 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 212.09 microseconds | 264.1 microseconds | 160.31 microseconds |
| 128 | 417.15 microseconds | 246.96 microseconds | 376.49 microseconds |
| 256 | 978.26 microseconds | 522.7 microseconds | 682.56 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 220.66 microseconds | 257.23 microseconds | 165.97 microseconds |
| 128 | 439.53 microseconds | 330.14 microseconds | 248.8 microseconds |
| 256 | 1.0165 milliseconds | 1.0572 milliseconds | 561.1 microseconds |

</details>


### U(1) × SU(2) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.456 milliseconds | 1.3785 milliseconds | 1.4369 milliseconds |
| 255 | 3.8864 milliseconds | 2.1311 milliseconds | 2.3072 milliseconds |
| 511 | 9.4697 milliseconds | 5.2299 milliseconds | 4.3835 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.6957 milliseconds | 1.572 milliseconds | 1.528 milliseconds |
| 255 | 4.2821 milliseconds | 2.3757 milliseconds | 2.2842 milliseconds |
| 511 | 10.472 milliseconds | 5.5069 milliseconds | 4.7519 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 7.7886 milliseconds | 3.851 milliseconds | 3.5187 milliseconds |
| 255 | 9.875 milliseconds | 5.0833 milliseconds | 4.7449 milliseconds |
| 511 | 90.209 milliseconds | 11.388 milliseconds | 10.328 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 7.5587 milliseconds | 3.8483 milliseconds | 3.55 milliseconds |
| 255 | 9.6195 milliseconds | 5.4975 milliseconds | 4.8247 milliseconds |
| 511 | 22.36 milliseconds | 12.494 milliseconds | 10.685 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 9.7132 milliseconds | 4.8288 milliseconds | 5.4638 milliseconds |
| 255 | 18.317 milliseconds | 8.5412 milliseconds | 44.978 milliseconds |
| 511 | 51.287 milliseconds | 19.939 milliseconds | 55.028 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 10.961 milliseconds | 5.2424 milliseconds | 5.591 milliseconds |
| 255 | 15.735 milliseconds | 8.5445 milliseconds | 7.303 milliseconds |
| 511 | 54.208 milliseconds | 19.372 milliseconds | 53.714 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 24.881 milliseconds | 14.163 milliseconds | 12.458 milliseconds |
| 255 | 45.797 milliseconds | 20.232 milliseconds | 85.052 milliseconds |
| 511 | 126.8 milliseconds | 41.52 milliseconds | 128.35 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 24.034 milliseconds | 13.636 milliseconds | 12.603 milliseconds |
| 255 | 360.51 milliseconds | 21.442 milliseconds | 21.032 milliseconds |
| 511 | 108.94 milliseconds | 168.41 milliseconds | 34.829 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.0363 milliseconds | 1.1036 milliseconds | 1.2135 milliseconds |
| 255 | 3.0131 milliseconds | 2.4089 milliseconds | 1.57 milliseconds |
| 511 | 6.6926 milliseconds | 3.6232 milliseconds | 3.124 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 3.9955 milliseconds | 2.2679 milliseconds | 2.1003 milliseconds |
| 255 | 6.0185 milliseconds | 3.1952 milliseconds | 3.0105 milliseconds |
| 511 | 13.575 milliseconds | 7.4559 milliseconds | 6.1601 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 6.2669 milliseconds | 3.66 milliseconds | 3.0899 milliseconds |
| 255 | 10.366 milliseconds | 5.8569 milliseconds | 5.2689 milliseconds |
| 511 | 37.444 milliseconds | 68.862 milliseconds | 10.776 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 17.263 milliseconds | 8.7687 milliseconds | 7.3859 milliseconds |
| 255 | 22.997 milliseconds | 19.328 milliseconds | 11.906 milliseconds |
| 511 | 92.887 milliseconds | 84.728 milliseconds | 106.88 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.0894 milliseconds | 1.1193 milliseconds | 1.1491 milliseconds |
| 255 | 3.0411 milliseconds | 1.7292 milliseconds | 1.6136 milliseconds |
| 511 | 6.3543 milliseconds | 3.6798 milliseconds | 3.0542 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.2226 milliseconds | 1.1878 milliseconds | 1.2392 milliseconds |
| 255 | 2.898 milliseconds | 1.5843 milliseconds | 1.6905 milliseconds |
| 511 | 6.7812 milliseconds | 3.6666 milliseconds | 3.1022 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 7.1662 milliseconds | 3.4726 milliseconds | 3.1478 milliseconds |
| 255 | 10.61 milliseconds | 5.5965 milliseconds | 5.1515 milliseconds |
| 511 | 32.54 milliseconds | 12.918 milliseconds | 10.885 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 6.207 milliseconds | 3.2848 milliseconds | 3.0693 milliseconds |
| 255 | 9.9648 milliseconds | 6.0827 milliseconds | 4.67 milliseconds |
| 511 | 30.2 milliseconds | 17.017 milliseconds | 11.331 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 252.39 microseconds | 289.44 microseconds | 176.24 microseconds |
| 255 | 465.14 microseconds | 309.31 microseconds | 309.54 microseconds |
| 511 | 1.4092 milliseconds | 900.09 microseconds | 945.64 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 165.89 microseconds | 139.57 microseconds | 136.37 microseconds |
| 255 | 304.15 microseconds | 195.37 microseconds | 274.69 microseconds |
| 511 | 1.0599 milliseconds | 939.68 microseconds | 693.31 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 425.88 microseconds | 283.98 microseconds | 446.02 microseconds |
| 255 | 764.97 microseconds | 447.94 microseconds | 664.35 microseconds |
| 511 | 2.285 milliseconds | 1.2554 milliseconds | 1.3192 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 454.34 microseconds | 278.58 microseconds | 601.41 microseconds |
| 255 | 795.81 microseconds | 476.37 microseconds | 520.78 microseconds |
| 511 | 2.3589 milliseconds | 1.3045 milliseconds | 1.2822 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 867.55 microseconds | 486.91 microseconds | 497.21 microseconds |
| 255 | 1.5725 milliseconds | 821.77 microseconds | 890.13 microseconds |
| 511 | 4.5236 milliseconds | 2.3718 milliseconds | 2.4869 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 906.34 microseconds | 531.53 microseconds | 498.65 microseconds |
| 255 | 1.3754 milliseconds | 805.65 microseconds | 1.059 milliseconds |
| 511 | 4.3182 milliseconds | 3.6132 milliseconds | 2.2683 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.9038 milliseconds | 1.122 milliseconds | 1.0573 milliseconds |
| 255 | 2.9316 milliseconds | 1.6674 milliseconds | 1.7341 milliseconds |
| 511 | 7.9851 milliseconds | 4.4277 milliseconds | 3.8477 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.9103 milliseconds | 1.2221 milliseconds | 1.0719 milliseconds |
| 255 | 3.0435 milliseconds | 1.6583 milliseconds | 1.8672 milliseconds |
| 511 | 7.7649 milliseconds | 16.86 milliseconds | 3.9958 milliseconds |

</details>

