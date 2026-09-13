# Performance report

Source commit: `4a22138d20c7bcd0e16c8622fdcf6d2dfc762ed6`

Julia uses 1, 2, or 4 compute threads; the linear algebra backend and garbage collector each use 1 thread.

| Thread configuration | Measurements | Measurement timestamp (UTC) | Detailed report |
| --- | ---: | --- | --- |
| 1 thread | 447 | 2026-09-13T13:14:23.706Z | [Input and sampling details](configurations/julia-1-blas-1/report.md) |
| 2 threads | 447 | 2026-09-13T14:13:10.595Z | [Input and sampling details](configurations/julia-2-blas-1/report.md) |
| 4 threads | 447 | 2026-09-13T14:59:22.679Z | [Input and sampling details](configurations/julia-4-blas-1/report.md) |

The tables show median execution times for each center bond dimension, including the full dimensions of symmetry multiplets.


## Sparse operator action on tangent vectors


### No symmetry


#### Sparse operator action · transverse-field Ising model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 63.851 milliseconds | 42.447 milliseconds | 44.477 milliseconds |
| 128 | 194.89 milliseconds | 121.71 milliseconds | 122.23 milliseconds |
| 256 | 455.72 milliseconds | 252.69 milliseconds | 249.36 milliseconds |

#### Sparse operator action · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 114.59 milliseconds | 74.359 milliseconds | 78.434 milliseconds |
| 128 | 412.89 milliseconds | 238.55 milliseconds | 240.25 milliseconds |
| 256 | 873.41 milliseconds | 492.79 milliseconds | 477.36 milliseconds |

#### Sparse operator action · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 204.49 milliseconds | 126.38 milliseconds | 132.19 milliseconds |
| 128 | 1.3853 seconds | 919.69 milliseconds | 639.98 milliseconds |
| 256 | 8.0157 seconds | 4.7825 seconds | 4.5888 seconds |

#### Sparse operator action · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 407.22 milliseconds | 252.2 milliseconds | 244.77 milliseconds |
| 128 | 2.5742 seconds | 1.5281 seconds | 1.5096 seconds |
| 256 | 16.133 seconds | 9.6439 seconds | 9.2837 seconds |

### U(1) symmetry


#### Sparse operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 57.088 milliseconds | 45.135 milliseconds | 45.668 milliseconds |
| 128 | 99.181 milliseconds | 63.023 milliseconds | 60.106 milliseconds |
| 256 | 117.03 milliseconds | 75.285 milliseconds | 70.618 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 73.829 milliseconds | 54.505 milliseconds | 55.948 milliseconds |
| 128 | 115.48 milliseconds | 82.519 milliseconds | 78.121 milliseconds |
| 256 | 129.96 milliseconds | 83.113 milliseconds | 90.37 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 131 milliseconds | 86.661 milliseconds | 86.274 milliseconds |
| 128 | 326.87 milliseconds | 181.47 milliseconds | 186.53 milliseconds |
| 256 | 1.2344 seconds | 799.4 milliseconds | 829.11 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 154.06 milliseconds | 100.72 milliseconds | 102.96 milliseconds |
| 128 | 441.7 milliseconds | 195.43 milliseconds | 197.92 milliseconds |
| 256 | 1.2604 seconds | 860.39 milliseconds | 854.5 milliseconds |

### SU(2) symmetry


#### Sparse operator action · Heisenberg spin model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 16.625 milliseconds | 17.358 milliseconds | 14.168 milliseconds |
| 128 | 18.909 milliseconds | 19.764 milliseconds | 19.092 milliseconds |
| 256 | 20.339 milliseconds | 19.79 milliseconds | 17.142 milliseconds |

#### Sparse operator action · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 36.858 milliseconds | 28.673 milliseconds | 26.466 milliseconds |
| 128 | 65.745 milliseconds | 76.2 milliseconds | 36.732 milliseconds |
| 256 | 66.449 milliseconds | 72.237 milliseconds | 74.389 milliseconds |

#### Sparse operator action · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 35.859 milliseconds | 25.046 milliseconds | 25.397 milliseconds |
| 128 | 58.371 milliseconds | 34.975 milliseconds | 34.011 milliseconds |
| 256 | 98.906 milliseconds | 73.03 milliseconds | 69.327 milliseconds |

#### Sparse operator action · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 96.158 milliseconds | 71.005 milliseconds | 65.021 milliseconds |
| 128 | 149.2 milliseconds | 93.165 milliseconds | 96.722 milliseconds |
| 256 | 731.71 milliseconds | 169.47 milliseconds | 161.87 milliseconds |

### U(1) × SU(2) symmetry


#### Sparse operator action · Hubbard fermion model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 109.07 milliseconds | 71.608 milliseconds | 64.747 milliseconds |
| 255 | 175.49 milliseconds | 103.63 milliseconds | 102.74 milliseconds |
| 511 | 336.17 milliseconds | 203.81 milliseconds | 186.99 milliseconds |

#### Sparse operator action · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.2015 seconds | 1.2728 seconds | 1.5967 seconds |
| 255 | 686.03 milliseconds | 200.21 milliseconds | 167.73 milliseconds |
| 511 | 1.0632 seconds | 390.22 milliseconds | 798.18 milliseconds |

#### Sparse operator action · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 425.12 milliseconds | 245.69 milliseconds | 225.26 milliseconds |
| 255 | 793.34 milliseconds | 467.33 milliseconds | 417.02 milliseconds |
| 511 | 1.9203 seconds | 842.9 milliseconds | 732.56 milliseconds |

#### Sparse operator action · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 864.3 milliseconds | 575.12 milliseconds | 482.35 milliseconds |
| 255 | 22.676 seconds | 16.06 seconds | 15.054 seconds |
| 511 | 28.306 seconds | 19.257 seconds | 18.497 seconds |

## Complete observable calculations


### No symmetry


#### Complete observable calculation · spin one-half · combined observables across different numbers of sites · ordinary MPS, no extra center legs


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 132.22 milliseconds | 71.737 milliseconds | 70.268 milliseconds |
| 128 | 491.11 milliseconds | 270.57 milliseconds | 269.37 milliseconds |
| 256 | 1.0977 seconds | 599.75 milliseconds | 584.96 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 40.357 milliseconds | 26.684 milliseconds | 26.471 milliseconds |
| 128 | 141.78 milliseconds | 97.43 milliseconds | 97.329 milliseconds |
| 256 | 308.37 milliseconds | 225.74 milliseconds | 210.08 milliseconds |

#### Complete observable calculation · spin one-half · single-site observables · ordinary MPS, no extra center legs


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 38.364 milliseconds | 29.827 milliseconds | 30.73 milliseconds |
| 128 | 136.14 milliseconds | 116.39 milliseconds | 115.04 milliseconds |
| 256 | 322.68 milliseconds | 322.86 milliseconds | 258.2 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 107.15 milliseconds | 61.348 milliseconds | 55.446 milliseconds |
| 128 | 405.12 milliseconds | 228.39 milliseconds | 230.28 milliseconds |
| 256 | 919.74 milliseconds | 535.12 milliseconds | 495.35 milliseconds |

### U(1) symmetry


#### Complete observable calculation · spinless fermions · combined observables across different numbers of sites · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 296.06 milliseconds | 187.12 milliseconds | 134.51 milliseconds |
| 128 | 535.47 milliseconds | 300.77 milliseconds | 282.13 milliseconds |
| 256 | 1.7065 seconds | 1.1228 seconds | 906.67 milliseconds |

#### Complete observable calculation · spinless fermions · multisite correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 109.03 milliseconds | 52.181 milliseconds | 50.775 milliseconds |
| 128 | 209.18 milliseconds | 121.68 milliseconds | 123.92 milliseconds |
| 256 | 598.66 milliseconds | 345.08 milliseconds | 345.86 milliseconds |

#### Complete observable calculation · spinless fermions · single-site observables · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 39.999 milliseconds | 31.67 milliseconds | 32.425 milliseconds |
| 128 | 72.595 milliseconds | 60.69 milliseconds | 72.42 milliseconds |
| 256 | 281.46 milliseconds | 243.39 milliseconds | 236.93 milliseconds |

#### Complete observable calculation · spinless fermions · two-site correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 259.59 milliseconds | 178.58 milliseconds | 163.81 milliseconds |
| 128 | 500.94 milliseconds | 315.77 milliseconds | 311.02 milliseconds |
| 256 | 1.3657 seconds | 909.81 milliseconds | 904.42 milliseconds |

#### Complete observable calculation · spin one-half · combined observables across different numbers of sites · ordinary MPS, no extra center legs


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 68.973 milliseconds | 39.872 milliseconds | 37.269 milliseconds |
| 128 | 106.09 milliseconds | 61.67 milliseconds | 53.209 milliseconds |
| 256 | 165.19 milliseconds | 82.922 milliseconds | 77.528 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 14.294 milliseconds | 8.9659 milliseconds | 9.2975 milliseconds |
| 128 | 23.553 milliseconds | 14.589 milliseconds | 14.284 milliseconds |
| 256 | 32.508 milliseconds | 20.923 milliseconds | 20.081 milliseconds |

#### Complete observable calculation · spin one-half · single-site observables · ordinary MPS, no extra center legs


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 10.223 milliseconds | 8.7714 milliseconds | 9.3575 milliseconds |
| 128 | 16.391 milliseconds | 16.486 milliseconds | 15.501 milliseconds |
| 256 | 26.36 milliseconds | 20.536 milliseconds | 22.458 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 64.428 milliseconds | 38.248 milliseconds | 35.849 milliseconds |
| 128 | 102.66 milliseconds | 56.434 milliseconds | 52.805 milliseconds |
| 256 | 142.09 milliseconds | 77.548 milliseconds | 70.544 milliseconds |

### SU(2) symmetry


#### Complete observable calculation · spin one-half · combined two-site and four-site correlations · ordinary MPS, no extra center legs


Calculate the registered combined two-site and four-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 22.582 milliseconds | 14.125 milliseconds | 13.796 milliseconds |
| 128 | 27.15 milliseconds | 17.235 milliseconds | 15.814 milliseconds |
| 256 | 30.325 milliseconds | 18.874 milliseconds | 17.506 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 9.5362 milliseconds | 6.4166 milliseconds | 7.0415 milliseconds |
| 128 | 10.941 milliseconds | 7.7248 milliseconds | 7.8721 milliseconds |
| 256 | 12.394 milliseconds | 8.328 milliseconds | 8.3583 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 19.371 milliseconds | 12.328 milliseconds | 12.08 milliseconds |
| 128 | 24.198 milliseconds | 15.503 milliseconds | 14.149 milliseconds |
| 256 | 26.013 milliseconds | 16.644 milliseconds | 16.007 milliseconds |

#### Complete observable calculation · spin one-half · single-site matrix elements with an open spin channel · ordinary MPS, bra has no extra leg; ket has an extra charge leg


Calculate the registered single-site matrix elements with an open spin channel over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 16.437 milliseconds | 15.731 milliseconds | 16.584 milliseconds |
| 128 | 20.663 milliseconds | 18.533 milliseconds | 20.384 milliseconds |
| 256 | 22.63 milliseconds | 20.815 milliseconds | 22.284 milliseconds |

#### Complete observable calculation · spin one-half · single-site matrix elements with an open spin channel · MPO with a purification leg, bra has no extra leg; ket has an extra charge leg


Calculate the registered single-site matrix elements with an open spin channel over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 39.999 milliseconds | 35.795 milliseconds | 36.786 milliseconds |
| 128 | 109.05 milliseconds | 109.76 milliseconds | 55.532 milliseconds |
| 256 | 151.43 milliseconds | 123.93 milliseconds | 176.26 milliseconds |

### U(1) × SU(2) symmetry


#### Complete observable calculation · spinful fermions · combined observables across different numbers of sites · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 37.404 seconds | 25.001 seconds | 23.767 seconds |
| 255 | 74.439 seconds | 48.205 seconds | 46.349 seconds |
| 511 | 91.196 seconds | 61.127 seconds | 59.668 seconds |

#### Complete observable calculation · spinful fermions · multisite correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 15.158 seconds | 10.267 seconds | 7.7183 seconds |
| 255 | 27.817 seconds | 18.662 seconds | 16.707 seconds |
| 511 | 33.749 seconds | 22.885 seconds | 19.759 seconds |

#### Complete observable calculation · spinful fermions · singlet pairing and spin-bond correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered singlet pairing and spin-bond correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 13.236 seconds | 9.2925 seconds | 4.7098 seconds |
| 255 | 23.399 seconds | 16.571 seconds | 14.166 seconds |
| 511 | 28.473 seconds | 20.488 seconds | 16.692 seconds |

#### Complete observable calculation · spinful fermions · single-site observables · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 282.52 milliseconds | 241.86 milliseconds | 248.43 milliseconds |
| 255 | 522.87 milliseconds | 431.63 milliseconds | 902.95 milliseconds |
| 511 | 966.86 milliseconds | 825.17 milliseconds | 678.81 milliseconds |

#### Complete observable calculation · spinful fermions · two-site correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 30.621 seconds | 21.416 seconds | 21.072 seconds |
| 255 | 62.542 seconds | 41.155 seconds | 40.087 seconds |
| 511 | 76.136 seconds | 50.471 seconds | 50.569 seconds |

## Supporting whole-chain operations


### No symmetry


#### Left and right canonicalization of base tensors · ordinary MPS


Construct the base tensor&#39;s canonical forms through left and right orthogonal factorizations and contractions, including the associated copying and memory allocation.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 8.9823 milliseconds | 8.4516 milliseconds | 9.3971 milliseconds |
| 128 | 31.483 milliseconds | 31.666 milliseconds | 34.111 milliseconds |
| 256 | 61.687 milliseconds | 62.29 milliseconds | 62.507 milliseconds |

#### Left orthogonal projection of a tangent vector · ordinary MPS, tangent center with no extra leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.6958 milliseconds | 947.55 microseconds | 1.009 milliseconds |
| 128 | 5.648 milliseconds | 3.1097 milliseconds | 2.9089 milliseconds |
| 256 | 12.641 milliseconds | 7.4376 milliseconds | 8.2629 milliseconds |

#### Left orthogonal projection of a tangent vector · MPO with a purification leg, tangent center with no extra leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.8129 milliseconds | 4.956 milliseconds | 2.6862 milliseconds |
| 128 | 31.549 milliseconds | 16.493 milliseconds | 15.857 milliseconds |
| 256 | 221.62 milliseconds | 113.6 milliseconds | 109.63 milliseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 36.464 microseconds | 89.454 microseconds | 103.97 microseconds |
| 128 | 76.786 microseconds | 192.55 microseconds | 298.83 microseconds |
| 256 | 142.78 microseconds | 370.11 microseconds | 228.15 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra component leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 208.02 microseconds | 183.35 microseconds | 324.48 microseconds |
| 128 | 1.1718 milliseconds | 742.09 microseconds | 804.13 microseconds |
| 256 | 4.3887 milliseconds | 3.4208 milliseconds | 3.6956 milliseconds |

### U(1) symmetry


#### Left orthogonal projection of a tangent vector · ordinary MPS, tangent center with an extra charge leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 524.74 microseconds | 541.87 microseconds | 519.87 microseconds |
| 128 | 906.09 microseconds | 702.57 microseconds | 675.94 microseconds |
| 256 | 1.198 milliseconds | 874.52 microseconds | 715.37 microseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 6.09 microseconds | 170.71 microseconds | 74.542 microseconds |
| 128 | 16.505 microseconds | 87.772 microseconds | 263.87 microseconds |
| 256 | 27.511 microseconds | 89.294 microseconds | 225.09 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 17.977 microseconds | 76.826 microseconds | 80.341 microseconds |
| 128 | 80.942 microseconds | 106.88 microseconds | 217.44 microseconds |
| 256 | 212.05 microseconds | 255.38 microseconds | 321.32 microseconds |

### SU(2) symmetry


#### Full-chain environment construction · Heisenberg spin model · MPO with a purification leg


Build left and right environments over the full chain from an MPO base and the Heisenberg operator, including contraction and allocation; environment cleanup is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 19.074 milliseconds | 12.089 milliseconds | 13.509 milliseconds |
| 128 | 29.544 milliseconds | 19.195 milliseconds | 18.969 milliseconds |
| 256 | 58.483 milliseconds | 33.74 milliseconds | 31.694 milliseconds |

#### Left and right canonicalization of base tensors · MPO with a purification leg


Construct the base tensor&#39;s canonical forms through left and right orthogonal factorizations and contractions, including the associated copying and memory allocation.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 2.6593 milliseconds | 2.6418 milliseconds | 2.6029 milliseconds |
| 128 | 4.4248 milliseconds | 4.5408 milliseconds | 4.4269 milliseconds |
| 256 | 9.0673 milliseconds | 8.7132 milliseconds | 9.3949 milliseconds |

#### Left orthogonal projection of a tangent vector · MPO with a purification leg, tangent center with an extra charge leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.7892 milliseconds | 1.0742 milliseconds | 946.42 microseconds |
| 128 | 3.4181 milliseconds | 1.9869 milliseconds | 1.6214 milliseconds |
| 256 | 6.8612 milliseconds | 3.8382 milliseconds | 3.1532 milliseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 33.811 microseconds | 96.175 microseconds | 188.94 microseconds |
| 128 | 59.73 microseconds | 169.65 microseconds | 201.17 microseconds |
| 256 | 67.201 microseconds | 165.72 microseconds | 130.05 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 68.583 microseconds | 140.15 microseconds | 190.75 microseconds |
| 128 | 131.02 microseconds | 237.73 microseconds | 179.27 microseconds |
| 256 | 143.32 microseconds | 202.81 microseconds | 203.3 microseconds |

### U(1) × SU(2) symmetry


#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 242.76 microseconds | 328.32 microseconds | 484.18 microseconds |
| 255 | 324.36 microseconds | 392.56 microseconds | 562.42 microseconds |
| 511 | 437.79 microseconds | 493.09 microseconds | 727.2 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 570.02 microseconds | 625.16 microseconds | 989.63 microseconds |
| 255 | 961.29 microseconds | 1.065 milliseconds | 1.4535 milliseconds |
| 511 | 1.66 milliseconds | 1.8931 milliseconds | 1.9098 milliseconds |

## Internal calculation stages


### No symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.0358 milliseconds | 1.6995 milliseconds | 1.7253 milliseconds |
| 128 | 18.987 milliseconds | 10.68 milliseconds | 10.135 milliseconds |
| 256 | 48.439 milliseconds | 27.443 milliseconds | 26.08 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.9937 milliseconds | 1.6482 milliseconds | 1.6037 milliseconds |
| 128 | 18.657 milliseconds | 10.66 milliseconds | 10.188 milliseconds |
| 256 | 59.36 milliseconds | 33.693 milliseconds | 32.289 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 6.0751 milliseconds | 3.446 milliseconds | 3.211 milliseconds |
| 128 | 38.95 milliseconds | 21.709 milliseconds | 20.354 milliseconds |
| 256 | 107.32 milliseconds | 56.476 milliseconds | 53.767 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.8795 milliseconds | 5.0745 milliseconds | 3.0308 milliseconds |
| 128 | 37.444 milliseconds | 21.515 milliseconds | 20.214 milliseconds |
| 256 | 120.02 milliseconds | 68.125 milliseconds | 64.011 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.6059 milliseconds | 3.0898 milliseconds | 3.0738 milliseconds |
| 128 | 37.365 milliseconds | 20.838 milliseconds | 19.894 milliseconds |
| 256 | 287.92 milliseconds | 164.94 milliseconds | 144.36 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.4714 milliseconds | 4.6197 milliseconds | 2.9713 milliseconds |
| 128 | 37.519 milliseconds | 20.436 milliseconds | 19.651 milliseconds |
| 256 | 286.47 milliseconds | 163.05 milliseconds | 149.43 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 11.067 milliseconds | 6.1417 milliseconds | 5.8873 milliseconds |
| 128 | 75.662 milliseconds | 43.387 milliseconds | 40.546 milliseconds |
| 256 | 574.57 milliseconds | 377.3 milliseconds | 331.95 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 10.778 milliseconds | 6.0196 milliseconds | 5.5462 milliseconds |
| 128 | 74.668 milliseconds | 44.031 milliseconds | 39.987 milliseconds |
| 256 | 574.57 milliseconds | 334.36 milliseconds | 331.41 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.1443 milliseconds | 1.2215 milliseconds | 1.1247 milliseconds |
| 128 | 12.943 milliseconds | 7.3722 milliseconds | 7.0486 milliseconds |
| 256 | 36.305 milliseconds | 20.595 milliseconds | 19.944 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.1091 milliseconds | 2.1974 milliseconds | 2.158 milliseconds |
| 128 | 25.612 milliseconds | 14.254 milliseconds | 14.311 milliseconds |
| 256 | 73.719 milliseconds | 40.826 milliseconds | 39.062 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.0214 milliseconds | 2.2172 milliseconds | 2.2067 milliseconds |
| 128 | 25.274 milliseconds | 14.149 milliseconds | 13.552 milliseconds |
| 256 | 196.94 milliseconds | 108.24 milliseconds | 105.2 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 7.6341 milliseconds | 4.2049 milliseconds | 4.102 milliseconds |
| 128 | 51.758 milliseconds | 33.747 milliseconds | 28.699 milliseconds |
| 256 | 388.83 milliseconds | 221.05 milliseconds | 215.83 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.0412 milliseconds | 1.1603 milliseconds | 1.1273 milliseconds |
| 128 | 12.824 milliseconds | 7.3198 milliseconds | 7.2391 milliseconds |
| 256 | 36.155 milliseconds | 20.577 milliseconds | 19.475 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.2528 milliseconds | 1.4567 milliseconds | 1.223 milliseconds |
| 128 | 13.618 milliseconds | 7.7252 milliseconds | 7.2323 milliseconds |
| 256 | 38.563 milliseconds | 21.119 milliseconds | 20.911 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.8447 milliseconds | 2.1713 milliseconds | 2.1297 milliseconds |
| 128 | 25.257 milliseconds | 14.064 milliseconds | 13.406 milliseconds |
| 256 | 194.62 milliseconds | 107.15 milliseconds | 102.02 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.5721 milliseconds | 2.4054 milliseconds | 2.3051 milliseconds |
| 128 | 28.085 milliseconds | 15.833 milliseconds | 14.268 milliseconds |
| 256 | 206.41 milliseconds | 116.85 milliseconds | 103.05 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 522.53 microseconds | 321.54 microseconds | 336.34 microseconds |
| 128 | 3.566 milliseconds | 3.4378 milliseconds | 1.9612 milliseconds |
| 256 | 13.289 milliseconds | 6.8535 milliseconds | 7.0109 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 531.44 microseconds | 330.71 microseconds | 333.25 microseconds |
| 128 | 3.5314 milliseconds | 1.925 milliseconds | 2.0085 milliseconds |
| 256 | 8.4283 milliseconds | 3.7536 milliseconds | 3.8625 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 975.31 microseconds | 551.13 microseconds | 585.47 microseconds |
| 128 | 7.0379 milliseconds | 3.7074 milliseconds | 3.7568 milliseconds |
| 256 | 26.937 milliseconds | 13.677 milliseconds | 13.71 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.0118 milliseconds | 649.16 microseconds | 628.26 microseconds |
| 128 | 7.0898 milliseconds | 7.049 milliseconds | 3.8988 milliseconds |
| 256 | 14.052 milliseconds | 7.1726 milliseconds | 7.6286 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 985.36 microseconds | 539.34 microseconds | 601.98 microseconds |
| 128 | 6.9475 milliseconds | 3.8157 milliseconds | 3.8026 milliseconds |
| 256 | 52.849 milliseconds | 27.23 milliseconds | 26.709 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.0158 milliseconds | 577.34 microseconds | 618.67 microseconds |
| 128 | 7.0678 milliseconds | 3.6883 milliseconds | 3.9989 milliseconds |
| 256 | 53.418 milliseconds | 27.08 milliseconds | 26.839 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.9138 milliseconds | 1.0159 milliseconds | 1.1561 milliseconds |
| 128 | 14.268 milliseconds | 7.6953 milliseconds | 7.3239 milliseconds |
| 256 | 105.77 milliseconds | 55.477 milliseconds | 77.135 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.9739 milliseconds | 1.0669 milliseconds | 1.1962 milliseconds |
| 128 | 14.328 milliseconds | 7.4015 milliseconds | 7.5333 milliseconds |
| 256 | 110.81 milliseconds | 53.956 milliseconds | 53.677 milliseconds |

</details>


### U(1) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.6105 milliseconds | 985.7 microseconds | 868.6 microseconds |
| 128 | 4.4517 milliseconds | 2.4226 milliseconds | 1.9832 milliseconds |
| 256 | 7.7901 milliseconds | 4.2798 milliseconds | 3.8089 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.7108 milliseconds | 1.0047 milliseconds | 933.65 microseconds |
| 128 | 4.753 milliseconds | 2.5118 milliseconds | 2.3872 milliseconds |
| 256 | 9.4212 milliseconds | 4.7554 milliseconds | 4.3292 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.0245 milliseconds | 1.2476 milliseconds | 1.0564 milliseconds |
| 128 | 5.0459 milliseconds | 2.7891 milliseconds | 2.2942 milliseconds |
| 256 | 8.5229 milliseconds | 6.9302 milliseconds | 3.8127 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.1936 milliseconds | 1.8527 milliseconds | 1.0653 milliseconds |
| 128 | 5.0807 milliseconds | 4.1704 milliseconds | 2.4162 milliseconds |
| 256 | 9.6301 milliseconds | 5.1039 milliseconds | 4.6368 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.0159 milliseconds | 1.6565 milliseconds | 1.5872 milliseconds |
| 128 | 9.0388 milliseconds | 4.864 milliseconds | 4.251 milliseconds |
| 256 | 37.658 milliseconds | 17.417 milliseconds | 22.378 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.9326 milliseconds | 1.6603 milliseconds | 1.5008 milliseconds |
| 128 | 8.9644 milliseconds | 4.6958 milliseconds | 4.06 milliseconds |
| 256 | 37.234 milliseconds | 17.011 milliseconds | 16.125 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.4349 milliseconds | 2.0241 milliseconds | 1.8491 milliseconds |
| 128 | 9.3467 milliseconds | 7.635 milliseconds | 4.2776 milliseconds |
| 256 | 37.86 milliseconds | 17.045 milliseconds | 15.498 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.4119 milliseconds | 1.9239 milliseconds | 1.7588 milliseconds |
| 128 | 9.2675 milliseconds | 4.941 milliseconds | 4.3786 milliseconds |
| 256 | 34.659 milliseconds | 17.853 milliseconds | 14.563 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.2636 milliseconds | 743.04 microseconds | 653.09 microseconds |
| 128 | 3.2861 milliseconds | 1.7986 milliseconds | 1.8789 milliseconds |
| 256 | 6.1404 milliseconds | 3.2709 milliseconds | 2.855 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.339 milliseconds | 1.2631 milliseconds | 703.23 microseconds |
| 128 | 3.3793 milliseconds | 1.878 milliseconds | 1.726 milliseconds |
| 256 | 6.0775 milliseconds | 3.2202 milliseconds | 2.9065 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.1249 milliseconds | 1.1847 milliseconds | 1.1607 milliseconds |
| 128 | 6.4544 milliseconds | 5.3057 milliseconds | 3.1119 milliseconds |
| 256 | 24.293 milliseconds | 12.219 milliseconds | 10.57 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.1587 milliseconds | 1.2923 milliseconds | 1.0804 milliseconds |
| 128 | 6.0248 milliseconds | 9.3553 milliseconds | 8.6998 milliseconds |
| 256 | 22.534 milliseconds | 11.049 milliseconds | 9.8253 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.1996 milliseconds | 703.79 microseconds | 649.35 microseconds |
| 128 | 3.3243 milliseconds | 1.7726 milliseconds | 1.5265 milliseconds |
| 256 | 5.8473 milliseconds | 3.1269 milliseconds | 3.0163 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.3186 milliseconds | 755.02 microseconds | 737.78 microseconds |
| 128 | 3.7524 milliseconds | 1.8811 milliseconds | 1.5943 milliseconds |
| 256 | 6.4546 milliseconds | 3.4302 milliseconds | 2.9087 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.045 milliseconds | 1.7811 milliseconds | 1.0717 milliseconds |
| 128 | 6.1564 milliseconds | 5.016 milliseconds | 2.9444 milliseconds |
| 256 | 23.684 milliseconds | 11.568 milliseconds | 9.6132 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.1017 milliseconds | 1.1676 milliseconds | 1.0272 milliseconds |
| 128 | 6.2594 milliseconds | 3.5702 milliseconds | 2.8694 milliseconds |
| 256 | 23.862 milliseconds | 12.272 milliseconds | 10.297 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 267.7 microseconds | 204.21 microseconds | 162.9 microseconds |
| 128 | 832.38 microseconds | 801.69 microseconds | 487.68 microseconds |
| 256 | 1.9021 milliseconds | 1.0196 milliseconds | 1.0385 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 205.55 microseconds | 151.86 microseconds | 134.06 microseconds |
| 128 | 663.88 microseconds | 412.6 microseconds | 422.26 microseconds |
| 256 | 1.0706 milliseconds | 729.8 microseconds | 664.65 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 259.85 microseconds | 231.48 microseconds | 161.14 microseconds |
| 128 | 793.22 microseconds | 478.91 microseconds | 407.82 microseconds |
| 256 | 1.7181 milliseconds | 921.84 microseconds | 1.0527 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 250.64 microseconds | 183.89 microseconds | 172.81 microseconds |
| 128 | 780.98 microseconds | 441.84 microseconds | 416.47 microseconds |
| 256 | 1.2685 milliseconds | 689.93 microseconds | 729.24 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 420.48 microseconds | 269.14 microseconds | 225.8 microseconds |
| 128 | 1.5327 milliseconds | 829.92 microseconds | 718.33 microseconds |
| 256 | 6.4549 milliseconds | 3.3453 milliseconds | 3.1463 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 420.11 microseconds | 285.43 microseconds | 237.07 microseconds |
| 128 | 1.6457 milliseconds | 817.67 microseconds | 839.7 microseconds |
| 256 | 6.0766 milliseconds | 3.3252 milliseconds | 3.0482 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 392.09 microseconds | 268.3 microseconds | 298.02 microseconds |
| 128 | 1.3271 milliseconds | 724.01 microseconds | 808.59 microseconds |
| 256 | 5.8192 milliseconds | 3.4189 milliseconds | 2.877 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 401.36 microseconds | 245.22 microseconds | 234.77 microseconds |
| 128 | 1.3159 milliseconds | 759.14 microseconds | 776.15 microseconds |
| 256 | 5.6234 milliseconds | 4.7003 milliseconds | 2.7044 milliseconds |

</details>


### SU(2) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 405.53 microseconds | 294.51 microseconds | 320.45 microseconds |
| 128 | 683.86 microseconds | 593.39 microseconds | 532.85 microseconds |
| 256 | 900.1 microseconds | 613.04 microseconds | 670.55 microseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 445.16 microseconds | 302.96 microseconds | 353.39 microseconds |
| 128 | 733.56 microseconds | 513.06 microseconds | 543.06 microseconds |
| 256 | 986.14 microseconds | 694.24 microseconds | 666.13 microseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.0451 milliseconds | 769.32 microseconds | 820 microseconds |
| 128 | 2.1125 milliseconds | 1.4668 milliseconds | 1.4454 milliseconds |
| 256 | 2.8281 milliseconds | 1.9128 milliseconds | 1.8806 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.0509 milliseconds | 724.13 microseconds | 848.99 microseconds |
| 128 | 2.0595 milliseconds | 1.3415 milliseconds | 1.4295 milliseconds |
| 256 | 2.9571 milliseconds | 1.9281 milliseconds | 1.6655 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 799.36 microseconds | 554.3 microseconds | 603.25 microseconds |
| 128 | 1.3295 milliseconds | 912.72 microseconds | 868.89 microseconds |
| 256 | 2.5462 milliseconds | 1.6624 milliseconds | 1.6214 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 802.96 microseconds | 557.93 microseconds | 579.82 microseconds |
| 128 | 1.3413 milliseconds | 875.42 microseconds | 974.34 microseconds |
| 256 | 2.5928 milliseconds | 1.7276 milliseconds | 1.5801 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.8952 milliseconds | 1.2629 milliseconds | 1.2892 milliseconds |
| 128 | 3.5015 milliseconds | 2.3177 milliseconds | 3.2591 milliseconds |
| 256 | 7.3306 milliseconds | 4.7221 milliseconds | 4.5791 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.9613 milliseconds | 1.2364 milliseconds | 1.3943 milliseconds |
| 128 | 3.7227 milliseconds | 2.3307 milliseconds | 2.3283 milliseconds |
| 256 | 7.973 milliseconds | 5.0048 milliseconds | 4.39 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 290.8 microseconds | 206.77 microseconds | 216.46 microseconds |
| 128 | 507.82 microseconds | 353.99 microseconds | 400.59 microseconds |
| 256 | 681.89 microseconds | 455.27 microseconds | 463.74 microseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 636.73 microseconds | 456.81 microseconds | 455.17 microseconds |
| 128 | 1.1978 milliseconds | 810.23 microseconds | 779.81 microseconds |
| 256 | 1.686 milliseconds | 1.1093 milliseconds | 1.0382 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 526.08 microseconds | 386.61 microseconds | 447.04 microseconds |
| 128 | 931.41 microseconds | 920.9 microseconds | 644.04 microseconds |
| 256 | 1.7284 milliseconds | 1.2693 milliseconds | 1.2521 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.0662 milliseconds | 845.36 microseconds | 860.33 microseconds |
| 128 | 2.1081 milliseconds | 1.4166 milliseconds | 1.2924 milliseconds |
| 256 | 4.5563 milliseconds | 3.0471 milliseconds | 2.7703 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 324.31 microseconds | 230.29 microseconds | 276.25 microseconds |
| 128 | 524.43 microseconds | 370.98 microseconds | 427.29 microseconds |
| 256 | 706.34 microseconds | 479.81 microseconds | 625.09 microseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 332.17 microseconds | 277.35 microseconds | 254.28 microseconds |
| 128 | 527.41 microseconds | 445.81 microseconds | 332.86 microseconds |
| 256 | 678.19 microseconds | 430.49 microseconds | 399.55 microseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 555.77 microseconds | 389.54 microseconds | 426.18 microseconds |
| 128 | 938.18 microseconds | 709.79 microseconds | 577.08 microseconds |
| 256 | 1.7569 milliseconds | 1.1697 milliseconds | 1.788 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 547.06 microseconds | 370.72 microseconds | 412.08 microseconds |
| 128 | 940.99 microseconds | 582.14 microseconds | 520.63 microseconds |
| 256 | 1.8148 milliseconds | 1.5842 milliseconds | 947.29 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 61.713 microseconds | 71.859 microseconds | 84.868 microseconds |
| 128 | 129.86 microseconds | 114.56 microseconds | 215.44 microseconds |
| 256 | 195.38 microseconds | 166.21 microseconds | 126.32 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 67.482 microseconds | 75.153 microseconds | 105.15 microseconds |
| 128 | 146.22 microseconds | 121.43 microseconds | 79.72 microseconds |
| 256 | 137.36 microseconds | 113.94 microseconds | 218.95 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 107.26 microseconds | 139.61 microseconds | 96.576 microseconds |
| 128 | 212.89 microseconds | 171.31 microseconds | 142.22 microseconds |
| 256 | 373.45 microseconds | 239.14 microseconds | 245.95 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 108.08 microseconds | 95.104 microseconds | 106.18 microseconds |
| 128 | 215.81 microseconds | 256.66 microseconds | 139.19 microseconds |
| 256 | 351.42 microseconds | 268.08 microseconds | 207.06 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 94.042 microseconds | 98.598 microseconds | 88.893 microseconds |
| 128 | 177.25 microseconds | 319.39 microseconds | 127.75 microseconds |
| 256 | 408.92 microseconds | 294.19 microseconds | 332.58 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 91.117 microseconds | 104.4 microseconds | 86.129 microseconds |
| 128 | 171.27 microseconds | 156.06 microseconds | 365.84 microseconds |
| 256 | 381.42 microseconds | 269.5 microseconds | 246.3 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 172.56 microseconds | 143.36 microseconds | 132.45 microseconds |
| 128 | 396.85 microseconds | 257.16 microseconds | 316.45 microseconds |
| 256 | 931.42 microseconds | 537.77 microseconds | 569.87 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 174.76 microseconds | 167.69 microseconds | 130.23 microseconds |
| 128 | 381.38 microseconds | 271.99 microseconds | 333.08 microseconds |
| 256 | 888.58 microseconds | 632.13 microseconds | 609.34 microseconds |

</details>


### U(1) × SU(2) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.0833 milliseconds | 1.2067 milliseconds | 1.1865 milliseconds |
| 255 | 3.5961 milliseconds | 1.9791 milliseconds | 1.9138 milliseconds |
| 511 | 9.5786 milliseconds | 7.9129 milliseconds | 4.2776 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.2657 milliseconds | 1.3225 milliseconds | 1.2802 milliseconds |
| 255 | 4.0506 milliseconds | 2.2138 milliseconds | 2.0073 milliseconds |
| 511 | 10.498 milliseconds | 5.779 milliseconds | 4.3406 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 4.7812 milliseconds | 2.5467 milliseconds | 2.3848 milliseconds |
| 255 | 8.2563 milliseconds | 4.5757 milliseconds | 3.993 milliseconds |
| 511 | 21.217 milliseconds | 10.915 milliseconds | 47.838 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 4.7295 milliseconds | 2.9165 milliseconds | 2.7405 milliseconds |
| 255 | 8.5793 milliseconds | 4.8933 milliseconds | 4.0127 milliseconds |
| 511 | 21.295 milliseconds | 11.89 milliseconds | 9.3257 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 7.9076 milliseconds | 4.2628 milliseconds | 3.6902 milliseconds |
| 255 | 14.979 milliseconds | 8.2459 milliseconds | 6.9009 milliseconds |
| 511 | 60.614 milliseconds | 20.419 milliseconds | 43.296 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 8.0203 milliseconds | 4.3914 milliseconds | 3.7398 milliseconds |
| 255 | 55.637 milliseconds | 8.4365 milliseconds | 26.282 milliseconds |
| 511 | 57.054 milliseconds | 55.09 milliseconds | 46.271 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 18.111 milliseconds | 9.3705 milliseconds | 7.8208 milliseconds |
| 255 | 58.523 milliseconds | 51.887 milliseconds | 16.303 milliseconds |
| 511 | 101.36 milliseconds | 44.377 milliseconds | 78.286 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 17.82 milliseconds | 9.7667 milliseconds | 8.4154 milliseconds |
| 255 | 32.445 milliseconds | 45.789 milliseconds | 15.549 milliseconds |
| 511 | 102.18 milliseconds | 60.618 milliseconds | 60.192 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.5063 milliseconds | 921.81 microseconds | 820.12 microseconds |
| 255 | 2.6307 milliseconds | 1.5287 milliseconds | 1.2883 milliseconds |
| 511 | 6.8514 milliseconds | 3.7357 milliseconds | 3.4024 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.9919 milliseconds | 1.7527 milliseconds | 1.5618 milliseconds |
| 255 | 5.232 milliseconds | 2.9867 milliseconds | 2.6849 milliseconds |
| 511 | 12.811 milliseconds | 7.1807 milliseconds | 5.8094 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 5.6374 milliseconds | 3.1761 milliseconds | 2.6891 milliseconds |
| 255 | 10.715 milliseconds | 5.5736 milliseconds | 4.7575 milliseconds |
| 511 | 35.655 milliseconds | 14.157 milliseconds | 11.232 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 11.237 milliseconds | 5.5038 milliseconds | 5.0558 milliseconds |
| 255 | 49.07 milliseconds | 78.078 milliseconds | 9.4384 milliseconds |
| 511 | 70.02 milliseconds | 47.06 milliseconds | 48.341 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.5226 milliseconds | 1.41 milliseconds | 923.44 microseconds |
| 255 | 2.6428 milliseconds | 1.4629 milliseconds | 1.4591 milliseconds |
| 511 | 6.9523 milliseconds | 3.7197 milliseconds | 3.193 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.6032 milliseconds | 989.22 microseconds | 1.027 milliseconds |
| 255 | 3.3946 milliseconds | 1.5646 milliseconds | 1.4522 milliseconds |
| 511 | 7.1604 milliseconds | 3.8384 milliseconds | 3.227 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 5.7629 milliseconds | 2.8983 milliseconds | 2.8958 milliseconds |
| 255 | 9.7091 milliseconds | 7.9485 milliseconds | 4.5548 milliseconds |
| 511 | 34.645 milliseconds | 13.521 milliseconds | 10.75 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 5.7405 milliseconds | 3.0533 milliseconds | 2.5382 milliseconds |
| 255 | 10.124 milliseconds | 5.1764 milliseconds | 4.2466 milliseconds |
| 511 | 25.031 milliseconds | 13.575 milliseconds | 10.614 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 259.97 microseconds | 287.98 microseconds | 186.86 microseconds |
| 255 | 534.01 microseconds | 335.46 microseconds | 361.19 microseconds |
| 511 | 1.6547 milliseconds | 993.53 microseconds | 958.49 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 162.04 microseconds | 139.17 microseconds | 111.22 microseconds |
| 255 | 338.46 microseconds | 223.89 microseconds | 300.68 microseconds |
| 511 | 1.2034 milliseconds | 747.86 microseconds | 747.26 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 387.93 microseconds | 267.59 microseconds | 329.99 microseconds |
| 255 | 820.57 microseconds | 550.11 microseconds | 547.23 microseconds |
| 511 | 2.5167 milliseconds | 1.4363 milliseconds | 3.2196 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 398.15 microseconds | 420.55 microseconds | 290.8 microseconds |
| 255 | 800.94 microseconds | 480.21 microseconds | 598.79 microseconds |
| 511 | 2.4808 milliseconds | 2.1607 milliseconds | 1.3635 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 785.24 microseconds | 482.54 microseconds | 478.99 microseconds |
| 255 | 1.5349 milliseconds | 1.0215 milliseconds | 1.0049 milliseconds |
| 511 | 5.0242 milliseconds | 2.6598 milliseconds | 2.5955 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 766.11 microseconds | 465.63 microseconds | 572.39 microseconds |
| 255 | 1.6085 milliseconds | 1.3607 milliseconds | 945.42 microseconds |
| 511 | 4.9241 milliseconds | 2.5387 milliseconds | 2.4588 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.4935 milliseconds | 818.13 microseconds | 927.5 microseconds |
| 255 | 2.5606 milliseconds | 2.2738 milliseconds | 1.6589 milliseconds |
| 511 | 8.4601 milliseconds | 4.4036 milliseconds | 4.4228 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.486 milliseconds | 813.42 microseconds | 850.59 microseconds |
| 255 | 2.689 milliseconds | 1.554 milliseconds | 1.6603 milliseconds |
| 511 | 7.9188 milliseconds | 4.2417 milliseconds | 4.2086 milliseconds |

</details>

