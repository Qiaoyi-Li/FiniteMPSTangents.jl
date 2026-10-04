# Performance report

Source commit: `1fdd5adfc06a044a8f2f0df561c0d68868fd639d`

Julia uses 1, 2, or 4 compute threads; the linear algebra backend and garbage collector each use 1 thread.

| Thread configuration | Measurements | Measurement timestamp (UTC) | Detailed report |
| --- | ---: | --- | --- |
| 1 thread | 447 | 2026-10-04T14:11:11.014Z | [Input and sampling details](configurations/julia-1-blas-1/report.md) |
| 2 threads | 447 | 2026-10-04T15:02:42.404Z | [Input and sampling details](configurations/julia-2-blas-1/report.md) |
| 4 threads | 447 | 2026-10-04T15:45:23.734Z | [Input and sampling details](configurations/julia-4-blas-1/report.md) |

The tables show median execution times for each center bond dimension, including the full dimensions of symmetry multiplets.


## Sparse operator action on tangent vectors


### No symmetry


#### Sparse operator action · transverse-field Ising model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 57.192 milliseconds | 38.536 milliseconds | 40.831 milliseconds |
| 128 | 183.53 milliseconds | 111.33 milliseconds | 115.46 milliseconds |
| 256 | 385.71 milliseconds | 226.29 milliseconds | 221.11 milliseconds |

#### Sparse operator action · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 109.77 milliseconds | 67.23 milliseconds | 69.996 milliseconds |
| 128 | 386.59 milliseconds | 215.36 milliseconds | 225.48 milliseconds |
| 256 | 787.88 milliseconds | 465.13 milliseconds | 468.23 milliseconds |

#### Sparse operator action · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 186.53 milliseconds | 117.73 milliseconds | 116.79 milliseconds |
| 128 | 1.3322 seconds | 903.85 milliseconds | 599.36 milliseconds |
| 256 | 7.349 seconds | 4.4859 seconds | 4.4647 seconds |

#### Sparse operator action · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 373.01 milliseconds | 224.07 milliseconds | 227.55 milliseconds |
| 128 | 2.4495 seconds | 1.4651 seconds | 1.4868 seconds |
| 256 | 15.216 seconds | 9.1474 seconds | 8.8345 seconds |

### U(1) symmetry


#### Sparse operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 73.53 milliseconds | 53.322 milliseconds | 53.402 milliseconds |
| 128 | 109.4 milliseconds | 65.002 milliseconds | 65.519 milliseconds |
| 256 | 127.02 milliseconds | 85.721 milliseconds | 79.191 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 90.173 milliseconds | 62.136 milliseconds | 60.031 milliseconds |
| 128 | 128.09 milliseconds | 81.988 milliseconds | 87.541 milliseconds |
| 256 | 142.81 milliseconds | 92.963 milliseconds | 88.604 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 153.82 milliseconds | 102.16 milliseconds | 93.463 milliseconds |
| 128 | 311.9 milliseconds | 198.91 milliseconds | 186.14 milliseconds |
| 256 | 1.2903 seconds | 867.24 milliseconds | 841.55 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 182.08 milliseconds | 113.63 milliseconds | 112.49 milliseconds |
| 128 | 457.15 milliseconds | 216.95 milliseconds | 215.72 milliseconds |
| 256 | 1.2463 seconds | 860.01 milliseconds | 924.08 milliseconds |

### SU(2) symmetry


#### Sparse operator action · Heisenberg spin model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 24.566 milliseconds | 23.009 milliseconds | 22.771 milliseconds |
| 128 | 26.931 milliseconds | 23.528 milliseconds | 27.897 milliseconds |
| 256 | 29.322 milliseconds | 22.997 milliseconds | 26.787 milliseconds |

#### Sparse operator action · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 65.971 milliseconds | 50.366 milliseconds | 39.377 milliseconds |
| 128 | 67.073 milliseconds | 45.574 milliseconds | 48.425 milliseconds |
| 256 | 74.527 milliseconds | 48.288 milliseconds | 53.089 milliseconds |

#### Sparse operator action · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 50.25 milliseconds | 49.932 milliseconds | 38.95 milliseconds |
| 128 | 73.553 milliseconds | 43.55 milliseconds | 45.991 milliseconds |
| 256 | 111.95 milliseconds | 77.657 milliseconds | 76.367 milliseconds |

#### Sparse operator action · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 133.57 milliseconds | 88.12 milliseconds | 88.251 milliseconds |
| 128 | 179.06 milliseconds | 131.53 milliseconds | 109 milliseconds |
| 256 | 304.79 milliseconds | 195.24 milliseconds | 193.35 milliseconds |

### U(1) × SU(2) symmetry


#### Sparse operator action · Hubbard fermion model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 121.32 milliseconds | 83.851 milliseconds | 83.526 milliseconds |
| 255 | 169.5 milliseconds | 109.59 milliseconds | 115.46 milliseconds |
| 511 | 354.35 milliseconds | 191.7 milliseconds | 180.05 milliseconds |

#### Sparse operator action · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.2847 seconds | 1.0343 seconds | 1.009 seconds |
| 255 | 854.39 milliseconds | 247.85 milliseconds | 227.91 milliseconds |
| 511 | 633.16 milliseconds | 414.47 milliseconds | 831.12 milliseconds |

#### Sparse operator action · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 468.46 milliseconds | 289.45 milliseconds | 268.44 milliseconds |
| 255 | 813.7 milliseconds | 485.84 milliseconds | 483.93 milliseconds |
| 511 | 1.814 seconds | 1.3896 seconds | 1.2522 seconds |

#### Sparse operator action · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.1747 seconds | 694.53 milliseconds | 626.81 milliseconds |
| 255 | 15.976 seconds | 12.292 seconds | 12.778 seconds |
| 511 | 21.304 seconds | 15.481 seconds | 15.442 seconds |

## Complete observable calculations


### No symmetry


#### Complete observable calculation · spin one-half · combined observables across different numbers of sites · ordinary MPS, no extra center legs


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 132.33 milliseconds | 60.096 milliseconds | 56.402 milliseconds |
| 128 | 438.82 milliseconds | 229.88 milliseconds | 212.36 milliseconds |
| 256 | 1.0661 seconds | 521.78 milliseconds | 487.77 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 35.287 milliseconds | 19.077 milliseconds | 18.07 milliseconds |
| 128 | 151.1 milliseconds | 68.177 milliseconds | 64.337 milliseconds |
| 256 | 303.38 milliseconds | 170.69 milliseconds | 143.81 milliseconds |

#### Complete observable calculation · spin one-half · single-site observables · ordinary MPS, no extra center legs


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 32.907 milliseconds | 17.853 milliseconds | 19.565 milliseconds |
| 128 | 141.38 milliseconds | 64.352 milliseconds | 64.251 milliseconds |
| 256 | 309.88 milliseconds | 164.98 milliseconds | 146.22 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 117.39 milliseconds | 48.257 milliseconds | 43.331 milliseconds |
| 128 | 381.2 milliseconds | 199.3 milliseconds | 181.92 milliseconds |
| 256 | 855.19 milliseconds | 430.42 milliseconds | 408.97 milliseconds |

### U(1) symmetry


#### Complete observable calculation · spinless fermions · combined observables across different numbers of sites · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 304.39 milliseconds | 159.03 milliseconds | 137.33 milliseconds |
| 128 | 548.6 milliseconds | 307.41 milliseconds | 289.2 milliseconds |
| 256 | 1.7693 seconds | 936.31 milliseconds | 842.83 milliseconds |

#### Complete observable calculation · spinless fermions · multisite correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 106.76 milliseconds | 55.884 milliseconds | 52.048 milliseconds |
| 128 | 197.14 milliseconds | 98.443 milliseconds | 84.842 milliseconds |
| 256 | 583.56 milliseconds | 355.71 milliseconds | 313.94 milliseconds |

#### Complete observable calculation · spinless fermions · single-site observables · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 80.146 milliseconds | 64.295 milliseconds | 77.031 milliseconds |
| 128 | 101.96 milliseconds | 64.02 milliseconds | 65.253 milliseconds |
| 256 | 326.15 milliseconds | 197.49 milliseconds | 188.19 milliseconds |

#### Complete observable calculation · spinless fermions · two-site correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 298.44 milliseconds | 189.4 milliseconds | 180.51 milliseconds |
| 128 | 510.88 milliseconds | 321.09 milliseconds | 301.09 milliseconds |
| 256 | 1.5247 seconds | 868 milliseconds | 860.26 milliseconds |

#### Complete observable calculation · spin one-half · combined observables across different numbers of sites · ordinary MPS, no extra center legs


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 79.042 milliseconds | 48.833 milliseconds | 43.473 milliseconds |
| 128 | 120.15 milliseconds | 67.26 milliseconds | 59.342 milliseconds |
| 256 | 181 milliseconds | 99.582 milliseconds | 83.07 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 17.427 milliseconds | 10.807 milliseconds | 10.508 milliseconds |
| 128 | 26.106 milliseconds | 15.548 milliseconds | 14.882 milliseconds |
| 256 | 34.602 milliseconds | 20.205 milliseconds | 20.358 milliseconds |

#### Complete observable calculation · spin one-half · single-site observables · ordinary MPS, no extra center legs


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 13.487 milliseconds | 8.5985 milliseconds | 8.3768 milliseconds |
| 128 | 18.134 milliseconds | 11.22 milliseconds | 10.674 milliseconds |
| 256 | 24.799 milliseconds | 14.861 milliseconds | 13.799 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 73.043 milliseconds | 48.017 milliseconds | 40.553 milliseconds |
| 128 | 129.68 milliseconds | 63.548 milliseconds | 55.386 milliseconds |
| 256 | 179.24 milliseconds | 85.498 milliseconds | 74.106 milliseconds |

### SU(2) symmetry


#### Complete observable calculation · spin one-half · combined two-site and four-site correlations · ordinary MPS, no extra center legs


Calculate the registered combined two-site and four-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 33.467 milliseconds | 20.9 milliseconds | 20.141 milliseconds |
| 128 | 40.836 milliseconds | 23.992 milliseconds | 22.867 milliseconds |
| 256 | 43.159 milliseconds | 25.587 milliseconds | 24.727 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 14.136 milliseconds | 9.352 milliseconds | 8.478 milliseconds |
| 128 | 16.44 milliseconds | 11.077 milliseconds | 9.77 milliseconds |
| 256 | 17.022 milliseconds | 10.622 milliseconds | 10.385 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 28.039 milliseconds | 18.28 milliseconds | 17.837 milliseconds |
| 128 | 32.733 milliseconds | 22.216 milliseconds | 19.543 milliseconds |
| 256 | 35.289 milliseconds | 22.118 milliseconds | 21.019 milliseconds |

#### Complete observable calculation · spin one-half · single-site matrix elements with an open spin channel · ordinary MPS, bra has no extra leg; ket has an extra charge leg


Calculate the registered single-site matrix elements with an open spin channel over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 27.158 milliseconds | 18.751 milliseconds | 16.948 milliseconds |
| 128 | 29.988 milliseconds | 21.06 milliseconds | 19.927 milliseconds |
| 256 | 32.142 milliseconds | 23.706 milliseconds | 21.384 milliseconds |

#### Complete observable calculation · spin one-half · single-site matrix elements with an open spin channel · MPO with a purification leg, bra has no extra leg; ket has an extra charge leg


Calculate the registered single-site matrix elements with an open spin channel over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 64.92 milliseconds | 45.851 milliseconds | 41.442 milliseconds |
| 128 | 123.51 milliseconds | 116.62 milliseconds | 53.894 milliseconds |
| 256 | 189.47 milliseconds | 139.92 milliseconds | 147.32 milliseconds |

### U(1) × SU(2) symmetry


#### Complete observable calculation · spinful fermions · combined observables across different numbers of sites · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 25.455 seconds | 17.253 seconds | 17.89 seconds |
| 255 | 51.273 seconds | 34.555 seconds | 35.455 seconds |
| 511 | 64.835 seconds | 43.924 seconds | 45.634 seconds |

#### Complete observable calculation · spinful fermions · multisite correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 10.17 seconds | 7.3924 seconds | 7.087 seconds |
| 255 | 18.549 seconds | 13.76 seconds | 13.605 seconds |
| 511 | 22.871 seconds | 16.585 seconds | 16.855 seconds |

#### Complete observable calculation · spinful fermions · singlet pairing and spin-bond correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered singlet pairing and spin-bond correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 9.4391 seconds | 6.8512 seconds | 6.726 seconds |
| 255 | 16.932 seconds | 12.067 seconds | 12.452 seconds |
| 511 | 20.998 seconds | 14.667 seconds | 15.666 seconds |

#### Complete observable calculation · spinful fermions · single-site observables · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 358.58 milliseconds | 232.38 milliseconds | 204.23 milliseconds |
| 255 | 561.98 milliseconds | 400.25 milliseconds | 388.9 milliseconds |
| 511 | 933.61 milliseconds | 581.51 milliseconds | 631.1 milliseconds |

#### Complete observable calculation · spinful fermions · two-site correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 20.777 seconds | 15.175 seconds | 14.648 seconds |
| 255 | 42.299 seconds | 28.548 seconds | 30.034 seconds |
| 511 | 54.195 seconds | 36.982 seconds | 38.325 seconds |

## Supporting whole-chain operations


### No symmetry


#### Left and right canonicalization of base tensors · ordinary MPS


Construct the base tensor&#39;s canonical forms through left and right orthogonal factorizations and contractions, including the associated copying and memory allocation.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 8.1948 milliseconds | 8.2157 milliseconds | 8.2173 milliseconds |
| 128 | 26.484 milliseconds | 26.455 milliseconds | 26.39 milliseconds |
| 256 | 51.61 milliseconds | 53.238 milliseconds | 52.897 milliseconds |

#### Left orthogonal projection of a tangent vector · ordinary MPS, tangent center with no extra leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.4489 milliseconds | 1.1309 milliseconds | 909.84 microseconds |
| 128 | 5.0637 milliseconds | 5.111 milliseconds | 2.8653 milliseconds |
| 256 | 10.892 milliseconds | 6.4987 milliseconds | 7.2313 milliseconds |

#### Left orthogonal projection of a tangent vector · MPO with a purification leg, tangent center with no extra leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.8287 milliseconds | 2.6241 milliseconds | 2.4998 milliseconds |
| 128 | 29.547 milliseconds | 14.592 milliseconds | 14.403 milliseconds |
| 256 | 207.97 milliseconds | 103.08 milliseconds | 100.49 milliseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 28.584 microseconds | 115.01 microseconds | 296.21 microseconds |
| 128 | 100.03 microseconds | 187.13 microseconds | 290.58 microseconds |
| 256 | 147.86 microseconds | 329.84 microseconds | 179.73 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra component leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 286.39 microseconds | 275.27 microseconds | 275.81 microseconds |
| 128 | 1.1975 milliseconds | 791.36 microseconds | 825.98 microseconds |
| 256 | 4.7651 milliseconds | 3.5754 milliseconds | 3.4694 milliseconds |

### U(1) symmetry


#### Left orthogonal projection of a tangent vector · ordinary MPS, tangent center with an extra charge leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 715.4 microseconds | 590.61 microseconds | 665.53 microseconds |
| 128 | 985.94 microseconds | 813.22 microseconds | 754.07 microseconds |
| 256 | 1.2625 milliseconds | 962.52 microseconds | 898.85 microseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 7.274 microseconds | 228.23 microseconds | 62.367 microseconds |
| 128 | 19.257 microseconds | 88.286 microseconds | 217.36 microseconds |
| 256 | 36.529 microseconds | 215.63 microseconds | 86.783 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 27.552 microseconds | 79.059 microseconds | 261.1 microseconds |
| 128 | 99.878 microseconds | 110.24 microseconds | 449.55 microseconds |
| 256 | 264.18 microseconds | 352.98 microseconds | 420 microseconds |

### SU(2) symmetry


#### Full-chain environment construction · Heisenberg spin model · MPO with a purification leg


Build left and right environments over the full chain from an MPO base and the Heisenberg operator, including contraction and allocation; environment cleanup is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 23.545 milliseconds | 15.682 milliseconds | 15.813 milliseconds |
| 128 | 28.384 milliseconds | 18.376 milliseconds | 19.319 milliseconds |
| 256 | 43.429 milliseconds | 27.906 milliseconds | 24.401 milliseconds |

#### Left and right canonicalization of base tensors · MPO with a purification leg


Construct the base tensor&#39;s canonical forms through left and right orthogonal factorizations and contractions, including the associated copying and memory allocation.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 3.7831 milliseconds | 3.9114 milliseconds | 3.728 milliseconds |
| 128 | 5.6096 milliseconds | 5.5709 milliseconds | 5.3445 milliseconds |
| 256 | 9.8038 milliseconds | 9.69 milliseconds | 9.339 milliseconds |

#### Left orthogonal projection of a tangent vector · MPO with a purification leg, tangent center with an extra charge leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 2.1674 milliseconds | 1.34 milliseconds | 1.3501 milliseconds |
| 128 | 3.0485 milliseconds | 2.3276 milliseconds | 1.6562 milliseconds |
| 256 | 4.9275 milliseconds | 2.7629 milliseconds | 2.2983 milliseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 65.123 microseconds | 134.55 microseconds | 149.35 microseconds |
| 128 | 96.863 microseconds | 139.5 microseconds | 293.52 microseconds |
| 256 | 98.335 microseconds | 219.09 microseconds | 121.01 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 118.76 microseconds | 279.61 microseconds | 184.98 microseconds |
| 128 | 147.89 microseconds | 197.21 microseconds | 305.56 microseconds |
| 256 | 217.6 microseconds | 248.7 microseconds | 383.9 microseconds |

### U(1) × SU(2) symmetry


#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 484.43 microseconds | 400.06 microseconds | 517.53 microseconds |
| 255 | 600.98 microseconds | 885.58 microseconds | 725.92 microseconds |
| 511 | 789.98 microseconds | 912.99 microseconds | 916.42 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 997.37 microseconds | 685.39 microseconds | 1.0572 milliseconds |
| 255 | 1.5703 milliseconds | 1.235 milliseconds | 1.6744 milliseconds |
| 511 | 2.565 milliseconds | 2.3567 milliseconds | 1.9547 milliseconds |

## Internal calculation stages


### No symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.6993 milliseconds | 1.5153 milliseconds | 1.5102 milliseconds |
| 128 | 17.574 milliseconds | 10.174 milliseconds | 9.4761 milliseconds |
| 256 | 55.137 milliseconds | 25.223 milliseconds | 24.058 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.7194 milliseconds | 1.4933 milliseconds | 1.6574 milliseconds |
| 128 | 17.487 milliseconds | 9.5322 milliseconds | 9.5702 milliseconds |
| 256 | 64.769 milliseconds | 31.099 milliseconds | 29.523 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.4959 milliseconds | 3.0521 milliseconds | 2.9922 milliseconds |
| 128 | 35.966 milliseconds | 20.191 milliseconds | 18.987 milliseconds |
| 256 | 113.9 milliseconds | 52.296 milliseconds | 52.312 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.2361 milliseconds | 4.347 milliseconds | 2.7942 milliseconds |
| 128 | 35.559 milliseconds | 22.757 milliseconds | 19.373 milliseconds |
| 256 | 110.09 milliseconds | 62.994 milliseconds | 67.414 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.1108 milliseconds | 2.8602 milliseconds | 2.9313 milliseconds |
| 128 | 35.67 milliseconds | 19.595 milliseconds | 18.088 milliseconds |
| 256 | 265.1 milliseconds | 149.95 milliseconds | 133.31 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.991 milliseconds | 2.7863 milliseconds | 2.936 milliseconds |
| 128 | 44.39 milliseconds | 22.879 milliseconds | 18.552 milliseconds |
| 256 | 266.67 milliseconds | 152.05 milliseconds | 133.75 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 16.91 milliseconds | 6.9467 milliseconds | 6.2 milliseconds |
| 128 | 71.79 milliseconds | 40.145 milliseconds | 36.79 milliseconds |
| 256 | 551.76 milliseconds | 338.56 milliseconds | 275.88 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 11.4 milliseconds | 8.6613 milliseconds | 6.4805 milliseconds |
| 128 | 69.561 milliseconds | 39.938 milliseconds | 37.321 milliseconds |
| 256 | 539.07 milliseconds | 304.92 milliseconds | 298.83 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.8853 milliseconds | 1.0841 milliseconds | 1.0381 milliseconds |
| 128 | 11.988 milliseconds | 9.5802 milliseconds | 6.4314 milliseconds |
| 256 | 40.147 milliseconds | 19.712 milliseconds | 18.301 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.6671 milliseconds | 1.9435 milliseconds | 1.963 milliseconds |
| 128 | 23.728 milliseconds | 13.2 milliseconds | 12.752 milliseconds |
| 256 | 87.905 milliseconds | 39.744 milliseconds | 36.229 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.5412 milliseconds | 2.0429 milliseconds | 2.0735 milliseconds |
| 128 | 36.197 milliseconds | 16.916 milliseconds | 12.794 milliseconds |
| 256 | 177.95 milliseconds | 97.794 milliseconds | 99.063 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 6.848 milliseconds | 3.7392 milliseconds | 3.9151 milliseconds |
| 128 | 70.143 milliseconds | 37.578 milliseconds | 24.557 milliseconds |
| 256 | 362.05 milliseconds | 206.86 milliseconds | 185.8 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.016 milliseconds | 1.2389 milliseconds | 1.0536 milliseconds |
| 128 | 12.235 milliseconds | 6.7644 milliseconds | 6.7183 milliseconds |
| 256 | 42.531 milliseconds | 21.482 milliseconds | 18.185 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.0153 milliseconds | 1.2333 milliseconds | 1.1242 milliseconds |
| 128 | 12.379 milliseconds | 7.6396 milliseconds | 6.5486 milliseconds |
| 256 | 46.563 milliseconds | 21.207 milliseconds | 18.446 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.5639 milliseconds | 1.9949 milliseconds | 2.1759 milliseconds |
| 128 | 30.994 milliseconds | 14.6 milliseconds | 13.117 milliseconds |
| 256 | 179.58 milliseconds | 99.108 milliseconds | 93.759 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.2546 milliseconds | 2.2778 milliseconds | 2.1889 milliseconds |
| 128 | 39.137 milliseconds | 20.588 milliseconds | 13.561 milliseconds |
| 256 | 189.3 milliseconds | 111.96 milliseconds | 103.54 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 538.06 microseconds | 291.44 microseconds | 319.45 microseconds |
| 128 | 3.129 milliseconds | 1.8289 milliseconds | 1.6392 milliseconds |
| 256 | 12.088 milliseconds | 6.9028 milliseconds | 6.2437 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 525.99 microseconds | 593.11 microseconds | 441.85 microseconds |
| 128 | 3.1675 milliseconds | 3.2061 milliseconds | 1.6757 milliseconds |
| 256 | 7.407 milliseconds | 6.2413 milliseconds | 3.3761 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 873.3 microseconds | 855.65 microseconds | 549.92 microseconds |
| 128 | 6.3551 milliseconds | 6.16 milliseconds | 3.3628 milliseconds |
| 256 | 27.033 milliseconds | 12.312 milliseconds | 12.164 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 930.65 microseconds | 529.97 microseconds | 618.92 microseconds |
| 128 | 6.3181 milliseconds | 6.2816 milliseconds | 3.3493 milliseconds |
| 256 | 12.83 milliseconds | 6.5878 milliseconds | 6.4506 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 860.26 microseconds | 500.64 microseconds | 484.4 microseconds |
| 128 | 6.3874 milliseconds | 6.1629 milliseconds | 3.2176 milliseconds |
| 256 | 48.739 milliseconds | 24.126 milliseconds | 24.296 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 884.56 microseconds | 481.89 microseconds | 544.48 microseconds |
| 128 | 6.5061 milliseconds | 4.2717 milliseconds | 3.4391 milliseconds |
| 256 | 50.71 milliseconds | 24.888 milliseconds | 24.45 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.6919 milliseconds | 1.7421 milliseconds | 918.48 microseconds |
| 128 | 12.674 milliseconds | 12.36 milliseconds | 6.4144 milliseconds |
| 256 | 95.594 milliseconds | 48.588 milliseconds | 48.41 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.7397 milliseconds | 1.7317 milliseconds | 1.1286 milliseconds |
| 128 | 12.747 milliseconds | 6.839 milliseconds | 6.8258 milliseconds |
| 256 | 103.25 milliseconds | 51.443 milliseconds | 52.009 milliseconds |

</details>


### U(1) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.0786 milliseconds | 1.0938 milliseconds | 1.2033 milliseconds |
| 128 | 4.7632 milliseconds | 3.9866 milliseconds | 2.3632 milliseconds |
| 256 | 7.9692 milliseconds | 6.4275 milliseconds | 3.9495 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.2484 milliseconds | 1.1713 milliseconds | 1.1855 milliseconds |
| 128 | 6.0073 milliseconds | 4.0027 milliseconds | 2.2013 milliseconds |
| 256 | 9.9523 milliseconds | 5.2471 milliseconds | 4.1088 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.4552 milliseconds | 2.3189 milliseconds | 1.2777 milliseconds |
| 128 | 5.178 milliseconds | 3.0512 milliseconds | 2.7435 milliseconds |
| 256 | 8.7048 milliseconds | 5.0575 milliseconds | 4.0548 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.5933 milliseconds | 2.2874 milliseconds | 1.3033 milliseconds |
| 128 | 5.496 milliseconds | 2.8315 milliseconds | 2.3914 milliseconds |
| 256 | 9.3961 milliseconds | 7.3499 milliseconds | 4.2408 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.513 milliseconds | 2.0456 milliseconds | 1.9145 milliseconds |
| 128 | 9.1656 milliseconds | 7.3954 milliseconds | 4.382 milliseconds |
| 256 | 44.004 milliseconds | 16.995 milliseconds | 22.411 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.2681 milliseconds | 3.0221 milliseconds | 1.7864 milliseconds |
| 128 | 8.6813 milliseconds | 4.7502 milliseconds | 4.0801 milliseconds |
| 256 | 34.434 milliseconds | 16.779 milliseconds | 14.337 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.911 milliseconds | 2.2753 milliseconds | 2.1187 milliseconds |
| 128 | 10.213 milliseconds | 5.4188 milliseconds | 4.3164 milliseconds |
| 256 | 38.63 milliseconds | 17.802 milliseconds | 15.176 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.9401 milliseconds | 2.2159 milliseconds | 2.1257 milliseconds |
| 128 | 9.506 milliseconds | 7.2504 milliseconds | 4.3578 milliseconds |
| 256 | 31.709 milliseconds | 17.483 milliseconds | 16.022 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.5178 milliseconds | 878.41 microseconds | 833.77 microseconds |
| 128 | 5.343 milliseconds | 2.8359 milliseconds | 1.714 milliseconds |
| 256 | 11.787 milliseconds | 3.3257 milliseconds | 2.8434 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.5473 milliseconds | 935.23 microseconds | 872.73 microseconds |
| 128 | 3.3246 milliseconds | 1.8947 milliseconds | 2.0762 milliseconds |
| 256 | 6.1109 milliseconds | 3.3385 milliseconds | 2.8051 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.3092 milliseconds | 1.3363 milliseconds | 1.311 milliseconds |
| 128 | 6.228 milliseconds | 3.8207 milliseconds | 3.5683 milliseconds |
| 256 | 22.179 milliseconds | 11.293 milliseconds | 10.12 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.4083 milliseconds | 2.0826 milliseconds | 1.28 milliseconds |
| 128 | 5.9495 milliseconds | 3.4954 milliseconds | 3.5304 milliseconds |
| 256 | 19.815 milliseconds | 10.704 milliseconds | 9.591 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.4345 milliseconds | 897.56 microseconds | 754.36 microseconds |
| 128 | 3.1533 milliseconds | 1.9279 milliseconds | 1.6208 milliseconds |
| 256 | 5.7339 milliseconds | 3.3521 milliseconds | 2.9792 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.5274 milliseconds | 1.4394 milliseconds | 799.92 microseconds |
| 128 | 3.3051 milliseconds | 3.1127 milliseconds | 1.5915 milliseconds |
| 256 | 5.9619 milliseconds | 5.3606 milliseconds | 2.6855 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.3512 milliseconds | 1.3561 milliseconds | 1.1646 milliseconds |
| 128 | 6.1762 milliseconds | 3.531 milliseconds | 3.2723 milliseconds |
| 256 | 22.119 milliseconds | 11.634 milliseconds | 9.7606 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.3893 milliseconds | 1.3437 milliseconds | 1.1367 milliseconds |
| 128 | 6.2689 milliseconds | 4.2398 milliseconds | 3.4821 milliseconds |
| 256 | 22.037 milliseconds | 11.792 milliseconds | 10.337 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 234.98 microseconds | 173.54 microseconds | 166.5 microseconds |
| 128 | 761.44 microseconds | 568.22 microseconds | 747.72 microseconds |
| 256 | 1.721 milliseconds | 1.1333 milliseconds | 1.1189 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 178.3 microseconds | 139.25 microseconds | 124.46 microseconds |
| 128 | 576.34 microseconds | 377.24 microseconds | 310.74 microseconds |
| 256 | 902.7 microseconds | 855.54 microseconds | 616.41 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 235.9 microseconds | 202.59 microseconds | 301.11 microseconds |
| 128 | 701.21 microseconds | 794.39 microseconds | 379.44 microseconds |
| 256 | 1.5317 milliseconds | 897.61 microseconds | 994.82 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 246.16 microseconds | 282.98 microseconds | 152.62 microseconds |
| 128 | 724.2 microseconds | 570.08 microseconds | 510.63 microseconds |
| 256 | 1.0845 milliseconds | 653.5 microseconds | 736.54 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 389.42 microseconds | 241.01 microseconds | 297.27 microseconds |
| 128 | 1.2856 milliseconds | 719.88 microseconds | 781.87 microseconds |
| 256 | 5.5308 milliseconds | 2.8918 milliseconds | 2.7151 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 407.31 microseconds | 431.85 microseconds | 226.02 microseconds |
| 128 | 1.3597 milliseconds | 698.12 microseconds | 636.04 microseconds |
| 256 | 5.5952 milliseconds | 4.7057 milliseconds | 2.8375 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 358.32 microseconds | 381.69 microseconds | 226.15 microseconds |
| 128 | 1.2118 milliseconds | 661.18 microseconds | 564.49 microseconds |
| 256 | 5.121 milliseconds | 2.8362 milliseconds | 2.2943 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 383.08 microseconds | 398.48 microseconds | 204.26 microseconds |
| 128 | 1.2416 milliseconds | 667.94 microseconds | 728.33 microseconds |
| 256 | 5.1115 milliseconds | 2.6419 milliseconds | 2.3081 milliseconds |

</details>


### SU(2) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 607.76 microseconds | 456.39 microseconds | 530.76 microseconds |
| 128 | 920.41 microseconds | 628.67 microseconds | 746.74 microseconds |
| 256 | 1.0835 milliseconds | 706.16 microseconds | 835.2 microseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 716.94 microseconds | 447.13 microseconds | 524.87 microseconds |
| 128 | 909.2 microseconds | 965.7 microseconds | 839.23 microseconds |
| 256 | 1.3653 milliseconds | 765.27 microseconds | 813.48 microseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.5544 milliseconds | 1.0446 milliseconds | 1.1839 milliseconds |
| 128 | 2.6665 milliseconds | 1.6531 milliseconds | 1.7477 milliseconds |
| 256 | 3.8175 milliseconds | 2.3752 milliseconds | 2.2425 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.5248 milliseconds | 1.0531 milliseconds | 1.1986 milliseconds |
| 128 | 2.5597 milliseconds | 1.8293 milliseconds | 1.8523 milliseconds |
| 256 | 3.4367 milliseconds | 2.1873 milliseconds | 2.1361 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.1321 milliseconds | 790.81 microseconds | 934.94 microseconds |
| 128 | 1.675 milliseconds | 1.1333 milliseconds | 1.1858 milliseconds |
| 256 | 2.9847 milliseconds | 2.1379 milliseconds | 1.7681 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.2714 milliseconds | 1.1954 milliseconds | 917.59 microseconds |
| 128 | 1.7761 milliseconds | 1.3758 milliseconds | 1.1827 milliseconds |
| 256 | 2.9294 milliseconds | 2.1126 milliseconds | 1.8629 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 2.7639 milliseconds | 1.806 milliseconds | 1.8605 milliseconds |
| 128 | 4.8823 milliseconds | 3.5486 milliseconds | 3.0761 milliseconds |
| 256 | 10.227 milliseconds | 6.3669 milliseconds | 5.7063 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 2.89 milliseconds | 1.9697 milliseconds | 1.92 milliseconds |
| 128 | 4.7773 milliseconds | 4.816 milliseconds | 3.2571 milliseconds |
| 256 | 9.7331 milliseconds | 8.0414 milliseconds | 5.3983 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 526.96 microseconds | 351.16 microseconds | 602.61 microseconds |
| 128 | 626.6 microseconds | 673.29 microseconds | 503.26 microseconds |
| 256 | 1.1144 milliseconds | 617.24 microseconds | 775.69 microseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 942.74 microseconds | 634.62 microseconds | 725.12 microseconds |
| 128 | 1.4586 milliseconds | 1.2781 milliseconds | 1.0666 milliseconds |
| 256 | 1.9256 milliseconds | 2.0368 milliseconds | 1.5612 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 776.86 microseconds | 577.12 microseconds | 722.73 microseconds |
| 128 | 1.6183 milliseconds | 961.92 microseconds | 1.086 milliseconds |
| 256 | 2.0326 milliseconds | 1.5934 milliseconds | 1.3386 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.6315 milliseconds | 1.1687 milliseconds | 1.1267 milliseconds |
| 128 | 2.7532 milliseconds | 1.7451 milliseconds | 1.6856 milliseconds |
| 256 | 5.3524 milliseconds | 3.418 milliseconds | 3.3646 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 496.62 microseconds | 328.69 microseconds | 332.28 microseconds |
| 128 | 680.47 microseconds | 570.25 microseconds | 487.38 microseconds |
| 256 | 849.71 microseconds | 616.7 microseconds | 533.58 microseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 460.18 microseconds | 309.49 microseconds | 298.03 microseconds |
| 128 | 681.69 microseconds | 536.47 microseconds | 390.64 microseconds |
| 256 | 800.96 microseconds | 485.31 microseconds | 486.63 microseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 797.85 microseconds | 880.72 microseconds | 695.61 microseconds |
| 128 | 1.2133 milliseconds | 1.1909 milliseconds | 800.07 microseconds |
| 256 | 2.1555 milliseconds | 1.4448 milliseconds | 1.3657 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 768.98 microseconds | 483.88 microseconds | 462.7 microseconds |
| 128 | 1.1885 milliseconds | 1.0171 milliseconds | 739.57 microseconds |
| 256 | 2.0762 milliseconds | 1.1986 milliseconds | 1.1224 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 67.337 microseconds | 149.46 microseconds | 110.13 microseconds |
| 128 | 119.62 microseconds | 140.88 microseconds | 342.36 microseconds |
| 256 | 159.46 microseconds | 133.81 microseconds | 289.35 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 79.449 microseconds | 73.729 microseconds | 73.679 microseconds |
| 128 | 113.59 microseconds | 113.77 microseconds | 80.963 microseconds |
| 256 | 98.025 microseconds | 112.39 microseconds | 246.7 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 127.51 microseconds | 111.94 microseconds | 104.79 microseconds |
| 128 | 271.55 microseconds | 187.4 microseconds | 160.23 microseconds |
| 256 | 414.91 microseconds | 396.56 microseconds | 215.92 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 135.9 microseconds | 160.68 microseconds | 109.95 microseconds |
| 128 | 247 microseconds | 304.22 microseconds | 160.14 microseconds |
| 256 | 327.76 microseconds | 214.11 microseconds | 174.13 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 109.94 microseconds | 154.71 microseconds | 107.24 microseconds |
| 128 | 205.85 microseconds | 160.58 microseconds | 181.91 microseconds |
| 256 | 385.32 microseconds | 313.1 microseconds | 249.08 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 110.97 microseconds | 102.82 microseconds | 245 microseconds |
| 128 | 207.71 microseconds | 196.98 microseconds | 160.44 microseconds |
| 256 | 387.51 microseconds | 492.38 microseconds | 393.29 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 238.07 microseconds | 257.11 microseconds | 186.3 microseconds |
| 128 | 428.48 microseconds | 289.33 microseconds | 254.39 microseconds |
| 256 | 992.92 microseconds | 557.04 microseconds | 557.63 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 254.77 microseconds | 180.57 microseconds | 179.34 microseconds |
| 128 | 425.82 microseconds | 609.38 microseconds | 433.21 microseconds |
| 256 | 999.53 microseconds | 689.59 microseconds | 513.71 microseconds |

</details>


### U(1) × SU(2) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.4188 milliseconds | 1.4213 milliseconds | 1.4757 milliseconds |
| 255 | 3.8633 milliseconds | 3.8946 milliseconds | 2.3743 milliseconds |
| 511 | 9.4782 milliseconds | 5.305 milliseconds | 4.5278 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.8089 milliseconds | 1.5439 milliseconds | 1.5127 milliseconds |
| 255 | 4.4209 milliseconds | 3.6802 milliseconds | 2.1497 milliseconds |
| 511 | 10.753 milliseconds | 8.3774 milliseconds | 5.1563 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 7.3933 milliseconds | 4.0265 milliseconds | 3.7216 milliseconds |
| 255 | 9.8367 milliseconds | 5.7103 milliseconds | 5.4199 milliseconds |
| 511 | 93.42 milliseconds | 12.24 milliseconds | 10.125 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 7.1101 milliseconds | 4.0462 milliseconds | 3.5721 milliseconds |
| 255 | 9.8254 milliseconds | 6.2178 milliseconds | 5.5441 milliseconds |
| 511 | 74.171 milliseconds | 12.532 milliseconds | 10.619 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 9.1189 milliseconds | 5.3228 milliseconds | 5.5616 milliseconds |
| 255 | 18.034 milliseconds | 8.9478 milliseconds | 8.432 milliseconds |
| 511 | 55.513 milliseconds | 21.137 milliseconds | 17.236 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 10.243 milliseconds | 5.6264 milliseconds | 5.7758 milliseconds |
| 255 | 16.337 milliseconds | 8.5697 milliseconds | 7.6882 milliseconds |
| 511 | 49.934 milliseconds | 52.652 milliseconds | 51.78 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 24.11 milliseconds | 14.756 milliseconds | 12.185 milliseconds |
| 255 | 77.689 milliseconds | 22.348 milliseconds | 19.151 milliseconds |
| 511 | 135.79 milliseconds | 452.07 milliseconds | 66.234 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 24.628 milliseconds | 15.439 milliseconds | 12.987 milliseconds |
| 255 | 45.851 milliseconds | 67.952 milliseconds | 52.587 milliseconds |
| 511 | 114.67 milliseconds | 196.78 milliseconds | 42.699 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.9508 milliseconds | 1.0878 milliseconds | 1.0618 milliseconds |
| 255 | 2.7934 milliseconds | 1.7298 milliseconds | 1.4654 milliseconds |
| 511 | 6.7323 milliseconds | 5.5868 milliseconds | 3.2361 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 3.938 milliseconds | 2.2387 milliseconds | 2.1029 milliseconds |
| 255 | 5.791 milliseconds | 3.5318 milliseconds | 3.0879 milliseconds |
| 511 | 13.732 milliseconds | 7.721 milliseconds | 6.2807 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 5.8178 milliseconds | 3.4486 milliseconds | 3.325 milliseconds |
| 255 | 10.55 milliseconds | 6.1177 milliseconds | 5.5922 milliseconds |
| 511 | 35.023 milliseconds | 13.274 milliseconds | 10.698 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 16.164 milliseconds | 9.0256 milliseconds | 7.3079 milliseconds |
| 255 | 23.196 milliseconds | 14.277 milliseconds | 12.383 milliseconds |
| 511 | 94.453 milliseconds | 27.772 milliseconds | 29.444 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.1063 milliseconds | 1.2235 milliseconds | 1.1634 milliseconds |
| 255 | 3.1181 milliseconds | 1.8501 milliseconds | 1.6708 milliseconds |
| 511 | 6.6825 milliseconds | 3.6814 milliseconds | 4.0924 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.1642 milliseconds | 1.1747 milliseconds | 1.2523 milliseconds |
| 255 | 3.0828 milliseconds | 1.656 milliseconds | 1.6847 milliseconds |
| 511 | 7.1574 milliseconds | 5.8823 milliseconds | 3.3359 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 6.9967 milliseconds | 3.4926 milliseconds | 3.2443 milliseconds |
| 255 | 11.556 milliseconds | 5.8458 milliseconds | 4.9067 milliseconds |
| 511 | 24.812 milliseconds | 13.08 milliseconds | 11.217 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 6.3058 milliseconds | 3.4231 milliseconds | 3.3222 milliseconds |
| 255 | 10.775 milliseconds | 7.5725 milliseconds | 4.8271 milliseconds |
| 511 | 32.154 milliseconds | 13.768 milliseconds | 11 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 246.85 microseconds | 199.56 microseconds | 210.73 microseconds |
| 255 | 524.03 microseconds | 306.49 microseconds | 332 microseconds |
| 511 | 1.4136 milliseconds | 889.08 microseconds | 1.0191 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 168.89 microseconds | 145.44 microseconds | 116.32 microseconds |
| 255 | 337.7 microseconds | 357.65 microseconds | 197.81 microseconds |
| 511 | 1.0199 milliseconds | 757.64 microseconds | 588.28 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 467.22 microseconds | 300.99 microseconds | 313.03 microseconds |
| 255 | 796.55 microseconds | 476.35 microseconds | 489.53 microseconds |
| 511 | 2.2379 milliseconds | 1.9614 milliseconds | 1.4403 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 476.88 microseconds | 453.24 microseconds | 297.82 microseconds |
| 255 | 805.61 microseconds | 486.45 microseconds | 614.44 microseconds |
| 511 | 2.3726 milliseconds | 1.2187 milliseconds | 1.6432 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 856.59 microseconds | 774.49 microseconds | 485.38 microseconds |
| 255 | 1.4482 milliseconds | 946.8 microseconds | 963.27 microseconds |
| 511 | 4.5273 milliseconds | 2.3407 milliseconds | 2.0296 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 901.88 microseconds | 576.34 microseconds | 552.77 microseconds |
| 255 | 1.5119 milliseconds | 847.59 microseconds | 1.1711 milliseconds |
| 511 | 4.3536 milliseconds | 2.339 milliseconds | 2.1596 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.9664 milliseconds | 1.5566 milliseconds | 1.0225 milliseconds |
| 255 | 2.9306 milliseconds | 1.8464 milliseconds | 2.0403 milliseconds |
| 511 | 7.8504 milliseconds | 4.4445 milliseconds | 23.913 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.9518 milliseconds | 1.158 milliseconds | 1.0797 milliseconds |
| 255 | 3.0632 milliseconds | 1.6824 milliseconds | 2.0293 milliseconds |
| 511 | 7.9685 milliseconds | 4.6546 milliseconds | 4.1892 milliseconds |

</details>

