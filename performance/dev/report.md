# Performance report

Source commit: `4a22138d20c7bcd0e16c8622fdcf6d2dfc762ed6`

Julia uses 1, 2, or 4 compute threads; the linear algebra backend and garbage collector each use 1 thread.

| Thread configuration | Measurements | Measurement timestamp (UTC) | Detailed report |
| --- | ---: | --- | --- |
| 1 thread | 447 | 2026-09-13T12:55:36.053Z | [Input and sampling details](configurations/julia-1-blas-1/report.md) |
| 2 threads | 447 | 2026-09-13T13:51:12.110Z | [Input and sampling details](configurations/julia-2-blas-1/report.md) |
| 4 threads | 447 | 2026-09-13T14:36:02.583Z | [Input and sampling details](configurations/julia-4-blas-1/report.md) |

The tables show median execution times for each center bond dimension, including the full dimensions of symmetry multiplets.


## Sparse operator action on tangent vectors


### No symmetry


#### Sparse operator action · transverse-field Ising model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 62.366 milliseconds | 47.691 milliseconds | 45.695 milliseconds |
| 128 | 179.23 milliseconds | 109.59 milliseconds | 117.15 milliseconds |
| 256 | 356.63 milliseconds | 216.9 milliseconds | 217.98 milliseconds |

#### Sparse operator action · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 117.96 milliseconds | 80.822 milliseconds | 88.642 milliseconds |
| 128 | 361.79 milliseconds | 229.25 milliseconds | 229.38 milliseconds |
| 256 | 719.74 milliseconds | 408.48 milliseconds | 403.03 milliseconds |

#### Sparse operator action · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 197.77 milliseconds | 126.69 milliseconds | 139.62 milliseconds |
| 128 | 1.2047 seconds | 809.35 milliseconds | 618.28 milliseconds |
| 256 | 6.2071 seconds | 3.8328 seconds | 3.7464 seconds |

#### Sparse operator action · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 393.3 milliseconds | 258.71 milliseconds | 257.36 milliseconds |
| 128 | 2.1592 seconds | 1.3673 seconds | 1.3344 seconds |
| 256 | 12.213 seconds | 7.6545 seconds | 7.312 seconds |

### U(1) symmetry


#### Sparse operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 63.281 milliseconds | 50.79 milliseconds | 49.434 milliseconds |
| 128 | 107.98 milliseconds | 76.143 milliseconds | 70.477 milliseconds |
| 256 | 129.05 milliseconds | 86.782 milliseconds | 82.165 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 87.435 milliseconds | 62.844 milliseconds | 62.847 milliseconds |
| 128 | 122.3 milliseconds | 95.726 milliseconds | 95.128 milliseconds |
| 256 | 149.09 milliseconds | 101.22 milliseconds | 96.944 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 158.13 milliseconds | 111.49 milliseconds | 108.68 milliseconds |
| 128 | 348.76 milliseconds | 204.03 milliseconds | 217.11 milliseconds |
| 256 | 1.3511 seconds | 906.5 milliseconds | 857.91 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 195.81 milliseconds | 125.84 milliseconds | 119.85 milliseconds |
| 128 | 504.27 milliseconds | 237.79 milliseconds | 242.29 milliseconds |
| 256 | 1.3915 seconds | 920.24 milliseconds | 884.61 milliseconds |

### SU(2) symmetry


#### Sparse operator action · Heisenberg spin model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 20.043 milliseconds | 22.799 milliseconds | 21.097 milliseconds |
| 128 | 22.471 milliseconds | 21.561 milliseconds | 23.03 milliseconds |
| 256 | 23.616 milliseconds | 24.214 milliseconds | 23.752 milliseconds |

#### Sparse operator action · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 43.626 milliseconds | 37.466 milliseconds | 34.113 milliseconds |
| 128 | 73.195 milliseconds | 77.374 milliseconds | 41.778 milliseconds |
| 256 | 75.6 milliseconds | 73.744 milliseconds | 78.704 milliseconds |

#### Sparse operator action · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 42.477 milliseconds | 33.519 milliseconds | 34.725 milliseconds |
| 128 | 70.296 milliseconds | 45.307 milliseconds | 49.125 milliseconds |
| 256 | 117.4 milliseconds | 92.618 milliseconds | 91.097 milliseconds |

#### Sparse operator action · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 115.29 milliseconds | 72.469 milliseconds | 81.626 milliseconds |
| 128 | 171.37 milliseconds | 122.14 milliseconds | 117.06 milliseconds |
| 256 | 701.59 milliseconds | 225.11 milliseconds | 214.93 milliseconds |

### U(1) × SU(2) symmetry


#### Sparse operator action · Hubbard fermion model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 119.49 milliseconds | 81.888 milliseconds | 79.726 milliseconds |
| 255 | 185.68 milliseconds | 122.74 milliseconds | 118.49 milliseconds |
| 511 | 371.94 milliseconds | 247.15 milliseconds | 221.9 milliseconds |

#### Sparse operator action · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.9601 seconds | 1.375 seconds | 1.2719 seconds |
| 255 | 384.19 milliseconds | 233.11 milliseconds | 223.11 milliseconds |
| 511 | 1.1815 seconds | 427.8 milliseconds | 741.3 milliseconds |

#### Sparse operator action · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 491.41 milliseconds | 313.37 milliseconds | 291.64 milliseconds |
| 255 | 889.82 milliseconds | 558.75 milliseconds | 518.02 milliseconds |
| 511 | 2.0665 seconds | 1.092 seconds | 903.91 milliseconds |

#### Sparse operator action · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.0377 seconds | 604.41 milliseconds | 581.25 milliseconds |
| 255 | 22.086 seconds | 15.084 seconds | 15.218 seconds |
| 511 | 26.57 seconds | 18.535 seconds | 18.988 seconds |

## Complete observable calculations


### No symmetry


#### Complete observable calculation · spin one-half · combined observables across different numbers of sites · ordinary MPS, no extra center legs


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 123.38 milliseconds | 69.993 milliseconds | 66.508 milliseconds |
| 128 | 429.53 milliseconds | 240.1 milliseconds | 233.31 milliseconds |
| 256 | 920.02 milliseconds | 509.67 milliseconds | 503.72 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 38.64 milliseconds | 25.079 milliseconds | 26.271 milliseconds |
| 128 | 125.3 milliseconds | 82.999 milliseconds | 88.757 milliseconds |
| 256 | 258.56 milliseconds | 178.99 milliseconds | 176.05 milliseconds |

#### Complete observable calculation · spin one-half · single-site observables · ordinary MPS, no extra center legs


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 36.241 milliseconds | 29.427 milliseconds | 29.33 milliseconds |
| 128 | 119 milliseconds | 107.19 milliseconds | 102.39 milliseconds |
| 256 | 254.43 milliseconds | 266.33 milliseconds | 237.95 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 99.075 milliseconds | 61.268 milliseconds | 53.427 milliseconds |
| 128 | 350.06 milliseconds | 198.07 milliseconds | 196.4 milliseconds |
| 256 | 754.71 milliseconds | 437.43 milliseconds | 447.8 milliseconds |

### U(1) symmetry


#### Complete observable calculation · spinless fermions · combined observables across different numbers of sites · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 339.47 milliseconds | 217.8 milliseconds | 167.99 milliseconds |
| 128 | 665.45 milliseconds | 384.68 milliseconds | 337.72 milliseconds |
| 256 | 1.8796 seconds | 1.0261 seconds | 1.0302 seconds |

#### Complete observable calculation · spinless fermions · multisite correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 97.246 milliseconds | 57.973 milliseconds | 58.284 milliseconds |
| 128 | 242.84 milliseconds | 126.76 milliseconds | 122.17 milliseconds |
| 256 | 647.75 milliseconds | 410.16 milliseconds | 371.52 milliseconds |

#### Complete observable calculation · spinless fermions · single-site observables · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 43.292 milliseconds | 36.898 milliseconds | 38.278 milliseconds |
| 128 | 83.32 milliseconds | 74.472 milliseconds | 75.341 milliseconds |
| 256 | 298.56 milliseconds | 260.92 milliseconds | 265.3 milliseconds |

#### Complete observable calculation · spinless fermions · two-site correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 317.82 milliseconds | 204.75 milliseconds | 215.77 milliseconds |
| 128 | 589.45 milliseconds | 380.9 milliseconds | 375.3 milliseconds |
| 256 | 1.5706 seconds | 993.02 milliseconds | 969.24 milliseconds |

#### Complete observable calculation · spin one-half · combined observables across different numbers of sites · ordinary MPS, no extra center legs


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 75.13 milliseconds | 44.954 milliseconds | 42.474 milliseconds |
| 128 | 115.95 milliseconds | 67.987 milliseconds | 62.299 milliseconds |
| 256 | 183.09 milliseconds | 93.069 milliseconds | 86.936 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 15.83 milliseconds | 9.8997 milliseconds | 11.132 milliseconds |
| 128 | 24.636 milliseconds | 16.656 milliseconds | 15.817 milliseconds |
| 256 | 34.477 milliseconds | 23.211 milliseconds | 22.183 milliseconds |

#### Complete observable calculation · spin one-half · single-site observables · ordinary MPS, no extra center legs


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 10.886 milliseconds | 9.1684 milliseconds | 10.394 milliseconds |
| 128 | 16.624 milliseconds | 16.04 milliseconds | 16.215 milliseconds |
| 256 | 24.811 milliseconds | 23.28 milliseconds | 22.649 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 69.556 milliseconds | 42.34 milliseconds | 40.179 milliseconds |
| 128 | 107.41 milliseconds | 62.06 milliseconds | 59.166 milliseconds |
| 256 | 153.55 milliseconds | 86.842 milliseconds | 82.054 milliseconds |

### SU(2) symmetry


#### Complete observable calculation · spin one-half · combined two-site and four-site correlations · ordinary MPS, no extra center legs


Calculate the registered combined two-site and four-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 24.04 milliseconds | 16.467 milliseconds | 16.48 milliseconds |
| 128 | 29.545 milliseconds | 20.213 milliseconds | 19.063 milliseconds |
| 256 | 33.114 milliseconds | 21.67 milliseconds | 20.007 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 10.379 milliseconds | 7.498 milliseconds | 8.5141 milliseconds |
| 128 | 12.11 milliseconds | 8.8009 milliseconds | 9.1041 milliseconds |
| 256 | 13.47 milliseconds | 8.9267 milliseconds | 10.273 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 20.151 milliseconds | 14.063 milliseconds | 15.072 milliseconds |
| 128 | 25.278 milliseconds | 17.959 milliseconds | 16.876 milliseconds |
| 256 | 29.029 milliseconds | 19.271 milliseconds | 18.935 milliseconds |

#### Complete observable calculation · spin one-half · single-site matrix elements with an open spin channel · ordinary MPS, bra has no extra leg; ket has an extra charge leg


Calculate the registered single-site matrix elements with an open spin channel over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 65.545 milliseconds | 17.024 milliseconds | 18.507 milliseconds |
| 128 | 23.389 milliseconds | 20.127 milliseconds | 22.784 milliseconds |
| 256 | 26.976 milliseconds | 23.88 milliseconds | 26.762 milliseconds |

#### Complete observable calculation · spin one-half · single-site matrix elements with an open spin channel · MPO with a purification leg, bra has no extra leg; ket has an extra charge leg


Calculate the registered single-site matrix elements with an open spin channel over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 48.273 milliseconds | 42.49 milliseconds | 43.542 milliseconds |
| 128 | 119.22 milliseconds | 61.846 milliseconds | 61.955 milliseconds |
| 256 | 180.76 milliseconds | 158.44 milliseconds | 193.39 milliseconds |

### U(1) × SU(2) symmetry


#### Complete observable calculation · spinful fermions · combined observables across different numbers of sites · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 36.367 seconds | 24.904 seconds | 25.144 seconds |
| 255 | 70.843 seconds | 49.216 seconds | 49.577 seconds |
| 511 | 88.455 seconds | 59.972 seconds | 61.715 seconds |

#### Complete observable calculation · spinful fermions · multisite correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 14.73 seconds | 10.039 seconds | 5.8278 seconds |
| 255 | 26.451 seconds | 18.005 seconds | 16.624 seconds |
| 511 | 32.312 seconds | 21.852 seconds | 20.275 seconds |

#### Complete observable calculation · spinful fermions · singlet pairing and spin-bond correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered singlet pairing and spin-bond correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 12.61 seconds | 7.0015 seconds | 4.7454 seconds |
| 255 | 21.824 seconds | 15.9 seconds | 13.286 seconds |
| 511 | 26.719 seconds | 19.505 seconds | 16.511 seconds |

#### Complete observable calculation · spinful fermions · single-site observables · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 307.98 milliseconds | 264.19 milliseconds | 278.7 milliseconds |
| 255 | 592.17 milliseconds | 576.92 milliseconds | 988.06 milliseconds |
| 511 | 1.0956 seconds | 1.0882 seconds | 886.86 milliseconds |

#### Complete observable calculation · spinful fermions · two-site correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 29.241 seconds | 20.941 seconds | 21.545 seconds |
| 255 | 57.894 seconds | 41.256 seconds | 42.458 seconds |
| 511 | 72.675 seconds | 51.098 seconds | 53.126 seconds |

## Supporting whole-chain operations


### No symmetry


#### Left and right canonicalization of base tensors · ordinary MPS


Construct the base tensor&#39;s canonical forms through left and right orthogonal factorizations and contractions, including the associated copying and memory allocation.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 8.7455 milliseconds | 8.6763 milliseconds | 8.7351 milliseconds |
| 128 | 24.975 milliseconds | 25.31 milliseconds | 25.179 milliseconds |
| 256 | 47.398 milliseconds | 48.097 milliseconds | 48.434 milliseconds |

#### Left orthogonal projection of a tangent vector · ordinary MPS, tangent center with no extra leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.5751 milliseconds | 1.3858 milliseconds | 1.0846 milliseconds |
| 128 | 4.711 milliseconds | 2.9102 milliseconds | 2.9609 milliseconds |
| 256 | 10.074 milliseconds | 6.0936 milliseconds | 8.4591 milliseconds |

#### Left orthogonal projection of a tangent vector · MPO with a purification leg, tangent center with no extra leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.9779 milliseconds | 3.0489 milliseconds | 2.7172 milliseconds |
| 128 | 25.214 milliseconds | 13.241 milliseconds | 13.068 milliseconds |
| 256 | 164.36 milliseconds | 86.252 milliseconds | 82.172 milliseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 36.537 microseconds | 74.505 microseconds | 153.17 microseconds |
| 128 | 111.64 microseconds | 394.64 microseconds | 131.38 microseconds |
| 256 | 175.94 microseconds | 425.34 microseconds | 437.35 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra component leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 332.29 microseconds | 230.99 microseconds | 499.42 microseconds |
| 128 | 1.8951 milliseconds | 1.1689 milliseconds | 1.3077 milliseconds |
| 256 | 9.2847 milliseconds | 6.7754 milliseconds | 5.0287 milliseconds |

### U(1) symmetry


#### Left orthogonal projection of a tangent vector · ordinary MPS, tangent center with an extra charge leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 581.96 microseconds | 701.09 microseconds | 928.04 microseconds |
| 128 | 876.58 microseconds | 1.0571 milliseconds | 1.0765 milliseconds |
| 256 | 1.2496 milliseconds | 1.1678 milliseconds | 1.1213 milliseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.375 microseconds | 64.017 microseconds | 120.58 microseconds |
| 128 | 20.369 microseconds | 70.511 microseconds | 82.796 microseconds |
| 256 | 40.061 microseconds | 92.679 microseconds | 394.22 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 14.323 microseconds | 128.88 microseconds | 90.83 microseconds |
| 128 | 105.15 microseconds | 112.56 microseconds | 371.48 microseconds |
| 256 | 556.45 microseconds | 742.27 microseconds | 575.43 microseconds |

### SU(2) symmetry


#### Full-chain environment construction · Heisenberg spin model · MPO with a purification leg


Build left and right environments over the full chain from an MPO base and the Heisenberg operator, including contraction and allocation; environment cleanup is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 19.164 milliseconds | 14.038 milliseconds | 14.848 milliseconds |
| 128 | 26.119 milliseconds | 16.578 milliseconds | 20.551 milliseconds |
| 256 | 41.215 milliseconds | 25.587 milliseconds | 26.27 milliseconds |

#### Left and right canonicalization of base tensors · MPO with a purification leg


Construct the base tensor&#39;s canonical forms through left and right orthogonal factorizations and contractions, including the associated copying and memory allocation.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 3.1538 milliseconds | 3.2485 milliseconds | 3.1591 milliseconds |
| 128 | 5.5013 milliseconds | 5.6244 milliseconds | 5.5362 milliseconds |
| 256 | 10.772 milliseconds | 10.475 milliseconds | 10.844 milliseconds |

#### Left orthogonal projection of a tangent vector · MPO with a purification leg, tangent center with an extra charge leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.7251 milliseconds | 1.248 milliseconds | 1.187 milliseconds |
| 128 | 2.9063 milliseconds | 1.8611 milliseconds | 1.5979 milliseconds |
| 256 | 4.9944 milliseconds | 3.1735 milliseconds | 2.5027 milliseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 29.671 microseconds | 126.75 microseconds | 137.88 microseconds |
| 128 | 50.258 microseconds | 109.9 microseconds | 392.55 microseconds |
| 256 | 57.219 microseconds | 232.56 microseconds | 204.06 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 70.937 microseconds | 128.61 microseconds | 232.28 microseconds |
| 128 | 89.617 microseconds | 151.15 microseconds | 447.57 microseconds |
| 256 | 227.59 microseconds | 189.94 microseconds | 263.59 microseconds |

### U(1) × SU(2) symmetry


#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 232.1 microseconds | 368.73 microseconds | 505.34 microseconds |
| 255 | 320.07 microseconds | 491.54 microseconds | 536.84 microseconds |
| 511 | 476.75 microseconds | 736.74 microseconds | 690.58 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 580.48 microseconds | 723.97 microseconds | 919.32 microseconds |
| 255 | 1.0968 milliseconds | 1.6373 milliseconds | 1.7482 milliseconds |
| 511 | 1.9762 milliseconds | 1.3633 milliseconds | 2.1031 milliseconds |

## Internal calculation stages


### No symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.014 milliseconds | 1.569 milliseconds | 1.6022 milliseconds |
| 128 | 16.203 milliseconds | 10.432 milliseconds | 8.8689 milliseconds |
| 256 | 38.806 milliseconds | 21.419 milliseconds | 20.921 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.9371 milliseconds | 1.5128 milliseconds | 1.5414 milliseconds |
| 128 | 16.146 milliseconds | 9.2993 milliseconds | 8.4101 milliseconds |
| 256 | 48.236 milliseconds | 26.904 milliseconds | 26.454 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 6.1803 milliseconds | 3.3446 milliseconds | 3.1498 milliseconds |
| 128 | 33.414 milliseconds | 18.62 milliseconds | 17.133 milliseconds |
| 256 | 81.351 milliseconds | 45.294 milliseconds | 41.216 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 6.1898 milliseconds | 5.4307 milliseconds | 3.2643 milliseconds |
| 128 | 34.632 milliseconds | 19.467 milliseconds | 17.525 milliseconds |
| 256 | 100.97 milliseconds | 68.66 milliseconds | 53.177 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.5032 milliseconds | 4.7983 milliseconds | 2.8583 milliseconds |
| 128 | 30.791 milliseconds | 16.722 milliseconds | 16.395 milliseconds |
| 256 | 216.86 milliseconds | 122.85 milliseconds | 110.19 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.2396 milliseconds | 4.6271 milliseconds | 2.8285 milliseconds |
| 128 | 38.959 milliseconds | 17.173 milliseconds | 16.439 milliseconds |
| 256 | 229.78 milliseconds | 127.23 milliseconds | 117.92 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 11.097 milliseconds | 5.9797 milliseconds | 5.7825 milliseconds |
| 128 | 64.604 milliseconds | 36.121 milliseconds | 34.736 milliseconds |
| 256 | 442.29 milliseconds | 259.45 milliseconds | 211.57 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 11.182 milliseconds | 6.5525 milliseconds | 5.8059 milliseconds |
| 128 | 67.8 milliseconds | 38.915 milliseconds | 34.974 milliseconds |
| 256 | 466.2 milliseconds | 361.28 milliseconds | 261.55 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.9373 milliseconds | 1.1722 milliseconds | 1.1332 milliseconds |
| 128 | 10.618 milliseconds | 6.101 milliseconds | 5.8321 milliseconds |
| 256 | 29.2 milliseconds | 17.016 milliseconds | 15.792 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.8872 milliseconds | 2.189 milliseconds | 2.0346 milliseconds |
| 128 | 21.567 milliseconds | 12.352 milliseconds | 11.433 milliseconds |
| 256 | 58.123 milliseconds | 35.088 milliseconds | 30.967 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.8419 milliseconds | 2.0541 milliseconds | 2.4274 milliseconds |
| 128 | 21.476 milliseconds | 11.927 milliseconds | 11.03 milliseconds |
| 256 | 150.59 milliseconds | 84.047 milliseconds | 78.381 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 7.0682 milliseconds | 4.1963 milliseconds | 3.9723 milliseconds |
| 128 | 52.822 milliseconds | 32.919 milliseconds | 21.905 milliseconds |
| 256 | 295.21 milliseconds | 168.56 milliseconds | 157.1 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.8368 milliseconds | 1.1015 milliseconds | 1.0615 milliseconds |
| 128 | 10.87 milliseconds | 6.0817 milliseconds | 6.4178 milliseconds |
| 256 | 28.019 milliseconds | 16.284 milliseconds | 15.314 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.0023 milliseconds | 1.4237 milliseconds | 1.3781 milliseconds |
| 128 | 11.541 milliseconds | 6.7696 milliseconds | 6.1626 milliseconds |
| 256 | 30.516 milliseconds | 17.275 milliseconds | 16.148 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.4195 milliseconds | 1.9355 milliseconds | 2.1339 milliseconds |
| 128 | 20.091 milliseconds | 11.171 milliseconds | 11.11 milliseconds |
| 256 | 143.66 milliseconds | 78.689 milliseconds | 75.966 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.2312 milliseconds | 2.4389 milliseconds | 2.6275 milliseconds |
| 128 | 22.893 milliseconds | 13.06 milliseconds | 11.739 milliseconds |
| 256 | 158.03 milliseconds | 90.414 milliseconds | 83.853 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 463.52 microseconds | 280.36 microseconds | 558.79 microseconds |
| 128 | 2.9597 milliseconds | 1.5982 milliseconds | 1.8491 milliseconds |
| 256 | 10.289 milliseconds | 5.4613 milliseconds | 5.837 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 495.53 microseconds | 401.61 microseconds | 364.51 microseconds |
| 128 | 3.0126 milliseconds | 3.4808 milliseconds | 2.32 milliseconds |
| 256 | 5.4482 milliseconds | 3.001 milliseconds | 3.2505 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 924.23 microseconds | 531.76 microseconds | 553.95 microseconds |
| 128 | 5.8024 milliseconds | 3.4088 milliseconds | 3.3965 milliseconds |
| 256 | 21.098 milliseconds | 11.604 milliseconds | 10.868 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 922.87 microseconds | 560.02 microseconds | 904.96 microseconds |
| 128 | 5.4478 milliseconds | 2.8114 milliseconds | 3.2202 milliseconds |
| 256 | 10.361 milliseconds | 6.0673 milliseconds | 5.9823 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 856.84 microseconds | 501.26 microseconds | 619.66 microseconds |
| 128 | 5.8109 milliseconds | 5.5461 milliseconds | 3.6221 milliseconds |
| 256 | 40.741 milliseconds | 21.855 milliseconds | 21.188 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 949.04 microseconds | 533.51 microseconds | 853.41 microseconds |
| 128 | 5.44 milliseconds | 3.1568 milliseconds | 3.1543 milliseconds |
| 256 | 36.43 milliseconds | 19.551 milliseconds | 19.422 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.8149 milliseconds | 1.2153 milliseconds | 1.4798 milliseconds |
| 128 | 11.6 milliseconds | 6.2514 milliseconds | 6.4547 milliseconds |
| 256 | 80.957 milliseconds | 48.97 milliseconds | 41.966 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.6427 milliseconds | 960.93 microseconds | 1.3179 milliseconds |
| 128 | 10.358 milliseconds | 7.2096 milliseconds | 6.0933 milliseconds |
| 256 | 74.378 milliseconds | 39.502 milliseconds | 38.454 milliseconds |

</details>


### U(1) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.9065 milliseconds | 1.1444 milliseconds | 1.1383 milliseconds |
| 128 | 5.0272 milliseconds | 2.9648 milliseconds | 2.4723 milliseconds |
| 256 | 9.2826 milliseconds | 4.8817 milliseconds | 4.3073 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.932 milliseconds | 1.2163 milliseconds | 1.3492 milliseconds |
| 128 | 5.4591 milliseconds | 2.9727 milliseconds | 2.6239 milliseconds |
| 256 | 10.317 milliseconds | 5.5512 milliseconds | 5.0326 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.579 milliseconds | 2.2974 milliseconds | 1.271 milliseconds |
| 128 | 5.9649 milliseconds | 3.502 milliseconds | 3.2096 milliseconds |
| 256 | 10.042 milliseconds | 5.771 milliseconds | 4.5366 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.5851 milliseconds | 1.517 milliseconds | 1.3524 milliseconds |
| 128 | 6.2102 milliseconds | 3.3024 milliseconds | 3.014 milliseconds |
| 256 | 10.732 milliseconds | 6.2834 milliseconds | 5.004 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.5474 milliseconds | 2.0894 milliseconds | 2.0173 milliseconds |
| 128 | 10.831 milliseconds | 8.3914 milliseconds | 5.3928 milliseconds |
| 256 | 42.111 milliseconds | 24.696 milliseconds | 15.936 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.6161 milliseconds | 2.0708 milliseconds | 1.8441 milliseconds |
| 128 | 10.859 milliseconds | 8.7645 milliseconds | 4.8727 milliseconds |
| 256 | 42.985 milliseconds | 20.674 milliseconds | 16.661 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.2976 milliseconds | 2.5499 milliseconds | 2.2289 milliseconds |
| 128 | 11.115 milliseconds | 7.4178 milliseconds | 4.9232 milliseconds |
| 256 | 43.385 milliseconds | 26.9 milliseconds | 16.405 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.3562 milliseconds | 3.8091 milliseconds | 2.2112 milliseconds |
| 128 | 11.174 milliseconds | 5.6576 milliseconds | 5.057 milliseconds |
| 256 | 45.915 milliseconds | 21.97 milliseconds | 16.544 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.3502 milliseconds | 847.53 microseconds | 753 microseconds |
| 128 | 3.4757 milliseconds | 1.9966 milliseconds | 1.811 milliseconds |
| 256 | 6.2085 milliseconds | 3.2998 milliseconds | 3.0661 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.567 milliseconds | 1.5335 milliseconds | 867.9 microseconds |
| 128 | 3.7111 milliseconds | 3.1523 milliseconds | 2.3411 milliseconds |
| 256 | 6.3609 milliseconds | 5.4181 milliseconds | 3.0202 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.4705 milliseconds | 1.427 milliseconds | 1.747 milliseconds |
| 128 | 6.8826 milliseconds | 5.8155 milliseconds | 3.301 milliseconds |
| 256 | 24.127 milliseconds | 11.98 milliseconds | 11.807 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.522 milliseconds | 1.5151 milliseconds | 1.5727 milliseconds |
| 128 | 6.4768 milliseconds | 4.1498 milliseconds | 3.3453 milliseconds |
| 256 | 22.822 milliseconds | 12.143 milliseconds | 10.767 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.2808 milliseconds | 1.2853 milliseconds | 772.04 microseconds |
| 128 | 3.2607 milliseconds | 1.7593 milliseconds | 1.8248 milliseconds |
| 256 | 5.9963 milliseconds | 3.6258 milliseconds | 3.0332 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.4541 milliseconds | 915.46 microseconds | 822.41 microseconds |
| 128 | 3.6674 milliseconds | 2.083 milliseconds | 1.9709 milliseconds |
| 256 | 6.5442 milliseconds | 3.9603 milliseconds | 2.9383 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.2545 milliseconds | 1.3454 milliseconds | 1.2134 milliseconds |
| 128 | 6.4306 milliseconds | 5.3149 milliseconds | 3.0336 milliseconds |
| 256 | 22.775 milliseconds | 11.931 milliseconds | 10.403 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.3155 milliseconds | 1.4035 milliseconds | 1.2833 milliseconds |
| 128 | 6.7912 milliseconds | 3.7562 milliseconds | 3.1998 milliseconds |
| 256 | 23.59 milliseconds | 12.618 milliseconds | 10.414 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 280.75 microseconds | 203.13 microseconds | 196.31 microseconds |
| 128 | 892.6 microseconds | 542.62 microseconds | 523.89 microseconds |
| 256 | 1.9776 milliseconds | 1.0576 milliseconds | 1.0247 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 196.92 microseconds | 159.65 microseconds | 443.24 microseconds |
| 128 | 710.59 microseconds | 401.92 microseconds | 419.22 microseconds |
| 256 | 1.1865 milliseconds | 1.1707 milliseconds | 701.06 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 253.64 microseconds | 201.4 microseconds | 199.02 microseconds |
| 128 | 822.46 microseconds | 742.19 microseconds | 733.74 microseconds |
| 256 | 1.7193 milliseconds | 1.0014 milliseconds | 1.1488 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 286.26 microseconds | 319.81 microseconds | 336.11 microseconds |
| 128 | 804.38 microseconds | 487.43 microseconds | 698.78 microseconds |
| 256 | 1.3516 milliseconds | 742.27 microseconds | 865.68 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 482 microseconds | 311.17 microseconds | 286.31 microseconds |
| 128 | 1.6961 milliseconds | 913.39 microseconds | 849.28 microseconds |
| 256 | 6.0263 milliseconds | 3.1964 milliseconds | 3.3863 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 464.16 microseconds | 295.91 microseconds | 358.89 microseconds |
| 128 | 1.5976 milliseconds | 860.11 microseconds | 821.76 microseconds |
| 256 | 5.9259 milliseconds | 4.0051 milliseconds | 3.3189 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 481.46 microseconds | 304.91 microseconds | 271.95 microseconds |
| 128 | 1.5207 milliseconds | 1.5234 milliseconds | 765.86 microseconds |
| 256 | 5.4336 milliseconds | 2.9994 milliseconds | 2.9977 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 495.68 microseconds | 296.31 microseconds | 314.76 microseconds |
| 128 | 1.5934 milliseconds | 825.32 microseconds | 926.09 microseconds |
| 256 | 5.3375 milliseconds | 3.3314 milliseconds | 2.8924 milliseconds |

</details>


### SU(2) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 492.28 microseconds | 364.92 microseconds | 728.72 microseconds |
| 128 | 859.49 microseconds | 653.98 microseconds | 653.78 microseconds |
| 256 | 1.063 milliseconds | 815.77 microseconds | 863.45 microseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 525.39 microseconds | 376.41 microseconds | 416.17 microseconds |
| 128 | 897.61 microseconds | 642.46 microseconds | 633.96 microseconds |
| 256 | 1.2412 milliseconds | 1.1912 milliseconds | 821.62 microseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.3086 milliseconds | 932.2 microseconds | 994.94 microseconds |
| 128 | 2.6273 milliseconds | 1.786 milliseconds | 1.6319 milliseconds |
| 256 | 3.6466 milliseconds | 3.2225 milliseconds | 2.5438 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.3104 milliseconds | 1.3107 milliseconds | 1 milliseconds |
| 128 | 2.558 milliseconds | 1.7932 milliseconds | 1.9288 milliseconds |
| 256 | 3.8402 milliseconds | 2.4762 milliseconds | 2.2193 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 960.73 microseconds | 1.0531 milliseconds | 946.02 microseconds |
| 128 | 1.612 milliseconds | 1.5648 milliseconds | 1.5343 milliseconds |
| 256 | 3.236 milliseconds | 2.1419 milliseconds | 2.2827 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 988.83 microseconds | 713.66 microseconds | 986.59 microseconds |
| 128 | 1.6332 milliseconds | 1.1514 milliseconds | 1.1577 milliseconds |
| 256 | 3.3233 milliseconds | 2.0909 milliseconds | 2.1135 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 2.4582 milliseconds | 1.601 milliseconds | 1.6053 milliseconds |
| 128 | 4.4716 milliseconds | 2.9382 milliseconds | 2.9668 milliseconds |
| 256 | 10.437 milliseconds | 6.837 milliseconds | 5.7183 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 2.4639 milliseconds | 1.6189 milliseconds | 1.5555 milliseconds |
| 128 | 4.8936 milliseconds | 4.2579 milliseconds | 2.9497 milliseconds |
| 256 | 11.231 milliseconds | 6.9304 milliseconds | 6.0824 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 344.36 microseconds | 274.66 microseconds | 327.53 microseconds |
| 128 | 610.69 microseconds | 464.52 microseconds | 795.28 microseconds |
| 256 | 787.64 microseconds | 807.1 microseconds | 548.77 microseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 806.95 microseconds | 511.31 microseconds | 583.96 microseconds |
| 128 | 1.4103 milliseconds | 1.0066 milliseconds | 1.3755 milliseconds |
| 256 | 1.9483 milliseconds | 1.6235 milliseconds | 1.2249 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 666.34 microseconds | 490.15 microseconds | 547.62 microseconds |
| 128 | 1.1751 milliseconds | 1.85 milliseconds | 1.1418 milliseconds |
| 256 | 2.0685 milliseconds | 1.378 milliseconds | 1.4565 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.3709 milliseconds | 902.3 microseconds | 1.1541 milliseconds |
| 128 | 2.7384 milliseconds | 1.7166 milliseconds | 1.7021 milliseconds |
| 256 | 5.8804 milliseconds | 3.651 milliseconds | 3.0358 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 360.19 microseconds | 278.76 microseconds | 323.15 microseconds |
| 128 | 584.74 microseconds | 443.35 microseconds | 645.78 microseconds |
| 256 | 809.77 microseconds | 551.52 microseconds | 628.6 microseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 392.13 microseconds | 276.9 microseconds | 282.75 microseconds |
| 128 | 653.04 microseconds | 436.95 microseconds | 683.46 microseconds |
| 256 | 816.16 microseconds | 488.91 microseconds | 542.71 microseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 686.16 microseconds | 468.64 microseconds | 597.4 microseconds |
| 128 | 1.0673 milliseconds | 771.34 microseconds | 1.0167 milliseconds |
| 256 | 2.0819 milliseconds | 1.3947 milliseconds | 1.5078 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 663.38 microseconds | 464.36 microseconds | 748.98 microseconds |
| 128 | 1.1083 milliseconds | 673.56 microseconds | 631.68 microseconds |
| 256 | 1.9985 milliseconds | 1.1114 milliseconds | 1.014 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 63.545 microseconds | 78.724 microseconds | 73.308 microseconds |
| 128 | 124.28 microseconds | 130.88 microseconds | 344.66 microseconds |
| 256 | 190.39 microseconds | 145.05 microseconds | 175.64 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 46.666 microseconds | 114.18 microseconds | 71.162 microseconds |
| 128 | 98.775 microseconds | 242.71 microseconds | 354.81 microseconds |
| 256 | 102.8 microseconds | 229.31 microseconds | 115.39 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 115.64 microseconds | 108.03 microseconds | 116.14 microseconds |
| 128 | 257.28 microseconds | 202.39 microseconds | 503.73 microseconds |
| 256 | 413.52 microseconds | 280.55 microseconds | 240.85 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 122.33 microseconds | 111.35 microseconds | 128.8 microseconds |
| 128 | 217.26 microseconds | 269.69 microseconds | 222.35 microseconds |
| 256 | 328.57 microseconds | 291.56 microseconds | 523.07 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 98.149 microseconds | 156.94 microseconds | 107.2 microseconds |
| 128 | 197.7 microseconds | 164.52 microseconds | 470.35 microseconds |
| 256 | 432.15 microseconds | 298.39 microseconds | 301.11 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 103.09 microseconds | 135.69 microseconds | 129.98 microseconds |
| 128 | 206.16 microseconds | 342.53 microseconds | 195.54 microseconds |
| 256 | 414.53 microseconds | 308.76 microseconds | 366.04 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 196.47 microseconds | 156.74 microseconds | 182.51 microseconds |
| 128 | 485.92 microseconds | 437.86 microseconds | 272.99 microseconds |
| 256 | 1.0478 milliseconds | 601.82 microseconds | 750.65 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 204.25 microseconds | 154.01 microseconds | 147.94 microseconds |
| 128 | 447.67 microseconds | 323.98 microseconds | 303.42 microseconds |
| 256 | 1.0045 milliseconds | 963.63 microseconds | 851.81 microseconds |

</details>


### U(1) × SU(2) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.4501 milliseconds | 1.5 milliseconds | 1.5807 milliseconds |
| 255 | 4.3123 milliseconds | 2.4742 milliseconds | 2.4703 milliseconds |
| 511 | 11.203 milliseconds | 6.3014 milliseconds | 5.2984 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.7628 milliseconds | 2.7423 milliseconds | 1.8938 milliseconds |
| 255 | 4.7058 milliseconds | 2.739 milliseconds | 2.7438 milliseconds |
| 511 | 12.409 milliseconds | 9.2462 milliseconds | 6.2442 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 6.1879 milliseconds | 3.121 milliseconds | 3.2044 milliseconds |
| 255 | 9.9685 milliseconds | 5.453 milliseconds | 4.6638 milliseconds |
| 511 | 25.162 milliseconds | 13.78 milliseconds | 47.032 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 6.1704 milliseconds | 3.7199 milliseconds | 3.4733 milliseconds |
| 255 | 10.087 milliseconds | 5.6911 milliseconds | 5.206 milliseconds |
| 511 | 26.051 milliseconds | 13.553 milliseconds | 11.887 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 9.2832 milliseconds | 5.2605 milliseconds | 5.0363 milliseconds |
| 255 | 18.734 milliseconds | 10.318 milliseconds | 8.7357 milliseconds |
| 511 | 55.998 milliseconds | 50.16 milliseconds | 49.641 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 9.6091 milliseconds | 5.237 milliseconds | 5.308 milliseconds |
| 255 | 18.711 milliseconds | 10.132 milliseconds | 8.6372 milliseconds |
| 511 | 62.164 milliseconds | 57.254 milliseconds | 51.386 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 22.604 milliseconds | 12.781 milliseconds | 10.552 milliseconds |
| 255 | 38.998 milliseconds | 51.167 milliseconds | 17.664 milliseconds |
| 511 | 109.9 milliseconds | 46.307 milliseconds | 74.565 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 22.781 milliseconds | 13.575 milliseconds | 9.9098 milliseconds |
| 255 | 38.265 milliseconds | 22.458 milliseconds | 44.866 milliseconds |
| 511 | 108.95 milliseconds | 72.293 milliseconds | 65.239 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.8469 milliseconds | 1.0791 milliseconds | 1.2397 milliseconds |
| 255 | 3.0999 milliseconds | 2.6172 milliseconds | 1.9395 milliseconds |
| 511 | 7.5394 milliseconds | 4.5462 milliseconds | 3.8288 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 3.6982 milliseconds | 2.0724 milliseconds | 1.9427 milliseconds |
| 255 | 6.1389 milliseconds | 3.6632 milliseconds | 3.2462 milliseconds |
| 511 | 14.622 milliseconds | 8.25 milliseconds | 7.4875 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 6.4237 milliseconds | 3.7711 milliseconds | 3.4751 milliseconds |
| 255 | 11.68 milliseconds | 6.5471 milliseconds | 5.5431 milliseconds |
| 511 | 48.609 milliseconds | 15.761 milliseconds | 12.966 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 12.709 milliseconds | 7.3327 milliseconds | 7.6753 milliseconds |
| 255 | 23.59 milliseconds | 12.813 milliseconds | 11.919 milliseconds |
| 511 | 66.769 milliseconds | 56.981 milliseconds | 58.362 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.9292 milliseconds | 1.1078 milliseconds | 1.3544 milliseconds |
| 255 | 3.026 milliseconds | 1.9416 milliseconds | 1.64 milliseconds |
| 511 | 7.4022 milliseconds | 4.12 milliseconds | 3.8189 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.0388 milliseconds | 1.445 milliseconds | 1.2347 milliseconds |
| 255 | 3.1963 milliseconds | 2.1044 milliseconds | 1.9104 milliseconds |
| 511 | 7.5978 milliseconds | 4.5056 milliseconds | 5.0227 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 6.4981 milliseconds | 3.5002 milliseconds | 3.5603 milliseconds |
| 255 | 11.418 milliseconds | 6.073 milliseconds | 5.9146 milliseconds |
| 511 | 28.046 milliseconds | 15.659 milliseconds | 12.299 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 6.3438 milliseconds | 3.7016 milliseconds | 3.6615 milliseconds |
| 255 | 11.924 milliseconds | 7.7061 milliseconds | 5.3533 milliseconds |
| 511 | 37.684 milliseconds | 17.339 milliseconds | 12.499 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 320.02 microseconds | 192.37 microseconds | 230.95 microseconds |
| 255 | 587.92 microseconds | 374.17 microseconds | 399.45 microseconds |
| 511 | 1.7522 milliseconds | 991.5 microseconds | 1.1688 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 174.64 microseconds | 412.19 microseconds | 161.43 microseconds |
| 255 | 384.14 microseconds | 403.25 microseconds | 530.33 microseconds |
| 511 | 1.317 milliseconds | 750.84 microseconds | 753.04 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 455.37 microseconds | 460.32 microseconds | 374.13 microseconds |
| 255 | 985.58 microseconds | 856.07 microseconds | 617.7 microseconds |
| 511 | 2.6965 milliseconds | 2.8278 milliseconds | 1.6515 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 453.08 microseconds | 308.73 microseconds | 353.28 microseconds |
| 255 | 956.19 microseconds | 583.18 microseconds | 586.06 microseconds |
| 511 | 2.626 milliseconds | 1.3803 milliseconds | 1.553 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 853.37 microseconds | 804.97 microseconds | 584.2 microseconds |
| 255 | 1.7329 milliseconds | 1.7829 milliseconds | 1.102 milliseconds |
| 511 | 5.4558 milliseconds | 4.7463 milliseconds | 3.0826 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 804.37 microseconds | 858.4 microseconds | 867.82 microseconds |
| 255 | 1.6673 milliseconds | 983.33 microseconds | 1.0425 milliseconds |
| 511 | 4.7453 milliseconds | 3.0566 milliseconds | 2.6753 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.6598 milliseconds | 940.39 microseconds | 1.0718 milliseconds |
| 255 | 3.1442 milliseconds | 2.1512 milliseconds | 1.9432 milliseconds |
| 511 | 9.5371 milliseconds | 5.2877 milliseconds | 4.4547 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.7212 milliseconds | 944.5 microseconds | 1.1048 milliseconds |
| 255 | 2.9612 milliseconds | 1.7755 milliseconds | 1.9775 milliseconds |
| 511 | 8.9306 milliseconds | 5.0463 milliseconds | 5.0321 milliseconds |

</details>

