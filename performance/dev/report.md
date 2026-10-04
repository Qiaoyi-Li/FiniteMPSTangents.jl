# Performance report

Source commit: `9f17e245d554734b3ff65513ffc9593821540e89`

Julia uses 1, 2, or 4 compute threads; the linear algebra backend and garbage collector each use 1 thread.

| Thread configuration | Measurements | Measurement timestamp (UTC) | Detailed report |
| --- | ---: | --- | --- |
| 1 thread | 447 | 2026-10-04T16:01:03.687Z | [Input and sampling details](configurations/julia-1-blas-1/report.md) |
| 2 threads | 447 | 2026-10-04T16:52:42.019Z | [Input and sampling details](configurations/julia-2-blas-1/report.md) |
| 4 threads | 447 | 2026-10-04T17:35:34.464Z | [Input and sampling details](configurations/julia-4-blas-1/report.md) |

The tables show median execution times for each center bond dimension, including the full dimensions of symmetry multiplets.


## Sparse operator action on tangent vectors


### No symmetry


#### Sparse operator action · transverse-field Ising model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 54.953 milliseconds | 35.37 milliseconds | 41.124 milliseconds |
| 128 | 182.91 milliseconds | 108.11 milliseconds | 109.26 milliseconds |
| 256 | 387.93 milliseconds | 223.54 milliseconds | 224.53 milliseconds |

#### Sparse operator action · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 105.07 milliseconds | 67.727 milliseconds | 66.938 milliseconds |
| 128 | 368.38 milliseconds | 211.46 milliseconds | 211.68 milliseconds |
| 256 | 768.26 milliseconds | 457.17 milliseconds | 432.9 milliseconds |

#### Sparse operator action · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 187.11 milliseconds | 111.01 milliseconds | 113.78 milliseconds |
| 128 | 1.3646 seconds | 840.83 milliseconds | 850.95 milliseconds |
| 256 | 7.3824 seconds | 4.4521 seconds | 4.2882 seconds |

#### Sparse operator action · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 379.17 milliseconds | 228.85 milliseconds | 216.58 milliseconds |
| 128 | 2.3532 seconds | 1.4604 seconds | 1.4072 seconds |
| 256 | 15.186 seconds | 9.1349 seconds | 8.6873 seconds |

### U(1) symmetry


#### Sparse operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 72.544 milliseconds | 52.235 milliseconds | 51.417 milliseconds |
| 128 | 108.51 milliseconds | 68.623 milliseconds | 69.412 milliseconds |
| 256 | 133.38 milliseconds | 81.646 milliseconds | 86.721 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 92.953 milliseconds | 62.118 milliseconds | 59.834 milliseconds |
| 128 | 125.67 milliseconds | 78.495 milliseconds | 91.152 milliseconds |
| 256 | 156.99 milliseconds | 92.867 milliseconds | 95.454 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 151.7 milliseconds | 97.596 milliseconds | 96.786 milliseconds |
| 128 | 319.74 milliseconds | 195.78 milliseconds | 192.34 milliseconds |
| 256 | 1.2344 seconds | 855.47 milliseconds | 857.65 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 170.36 milliseconds | 106.72 milliseconds | 112.94 milliseconds |
| 128 | 453.97 milliseconds | 206.21 milliseconds | 201.69 milliseconds |
| 256 | 1.2546 seconds | 824.54 milliseconds | 853.67 milliseconds |

### SU(2) symmetry


#### Sparse operator action · Heisenberg spin model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 24.603 milliseconds | 20.536 milliseconds | 22.703 milliseconds |
| 128 | 26.56 milliseconds | 21.33 milliseconds | 22.251 milliseconds |
| 256 | 27.598 milliseconds | 23.923 milliseconds | 25.049 milliseconds |

#### Sparse operator action · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 64.592 milliseconds | 34.376 milliseconds | 40.059 milliseconds |
| 128 | 80.487 milliseconds | 45.02 milliseconds | 46.859 milliseconds |
| 256 | 95.572 milliseconds | 49.713 milliseconds | 52.959 milliseconds |

#### Sparse operator action · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 55.675 milliseconds | 33.9 milliseconds | 38.244 milliseconds |
| 128 | 94.33 milliseconds | 43.769 milliseconds | 48.732 milliseconds |
| 256 | 117.94 milliseconds | 80.113 milliseconds | 80.161 milliseconds |

#### Sparse operator action · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 133.96 milliseconds | 84.312 milliseconds | 110.33 milliseconds |
| 128 | 182.08 milliseconds | 131.05 milliseconds | 133.84 milliseconds |
| 256 | 318.66 milliseconds | 204.4 milliseconds | 208.74 milliseconds |

### U(1) × SU(2) symmetry


#### Sparse operator action · Hubbard fermion model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 119.53 milliseconds | 72.662 milliseconds | 81.653 milliseconds |
| 255 | 168.42 milliseconds | 106.58 milliseconds | 120 milliseconds |
| 511 | 612.9 milliseconds | 195.77 milliseconds | 184.16 milliseconds |

#### Sparse operator action · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.3491 seconds | 942.51 milliseconds | 1.108 seconds |
| 255 | 843.85 milliseconds | 748.93 milliseconds | 254.41 milliseconds |
| 511 | 638.57 milliseconds | 845.68 milliseconds | 873.32 milliseconds |

#### Sparse operator action · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 452.36 milliseconds | 289.01 milliseconds | 272.02 milliseconds |
| 255 | 797.53 milliseconds | 499.41 milliseconds | 441.15 milliseconds |
| 511 | 1.8747 seconds | 1.4291 seconds | 1.2601 seconds |

#### Sparse operator action · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.1829 seconds | 688.62 milliseconds | 633.76 milliseconds |
| 255 | 15.893 seconds | 12.436 seconds | 13.348 seconds |
| 511 | 20.811 seconds | 15.331 seconds | 15.904 seconds |

## Complete observable calculations


### No symmetry


#### Complete observable calculation · spin one-half · combined observables across different numbers of sites · ordinary MPS, no extra center legs


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 123.81 milliseconds | 77.418 milliseconds | 58.834 milliseconds |
| 128 | 449.49 milliseconds | 240.19 milliseconds | 216.74 milliseconds |
| 256 | 1.0121 seconds | 541.36 milliseconds | 492.61 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 35.093 milliseconds | 19.815 milliseconds | 18.996 milliseconds |
| 128 | 145.32 milliseconds | 70.164 milliseconds | 66.251 milliseconds |
| 256 | 295.91 milliseconds | 172.19 milliseconds | 146.09 milliseconds |

#### Complete observable calculation · spin one-half · single-site observables · ordinary MPS, no extra center legs


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 33.24 milliseconds | 18.29 milliseconds | 21.033 milliseconds |
| 128 | 124.56 milliseconds | 65.85 milliseconds | 70.482 milliseconds |
| 256 | 301.03 milliseconds | 173.26 milliseconds | 150.46 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 115.37 milliseconds | 60.236 milliseconds | 44.152 milliseconds |
| 128 | 370.33 milliseconds | 207.62 milliseconds | 182.99 milliseconds |
| 256 | 862.28 milliseconds | 438.65 milliseconds | 411.12 milliseconds |

### U(1) symmetry


#### Complete observable calculation · spinless fermions · combined observables across different numbers of sites · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 304.34 milliseconds | 141.53 milliseconds | 159.88 milliseconds |
| 128 | 531.49 milliseconds | 314.23 milliseconds | 266.7 milliseconds |
| 256 | 1.5714 seconds | 941.29 milliseconds | 850.03 milliseconds |

#### Complete observable calculation · spinless fermions · multisite correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 98.838 milliseconds | 56.443 milliseconds | 51.529 milliseconds |
| 128 | 192.71 milliseconds | 97.122 milliseconds | 88.428 milliseconds |
| 256 | 576.48 milliseconds | 353.73 milliseconds | 299.76 milliseconds |

#### Complete observable calculation · spinless fermions · single-site observables · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 78.02 milliseconds | 65.246 milliseconds | 23.164 milliseconds |
| 128 | 96.326 milliseconds | 66.471 milliseconds | 42.272 milliseconds |
| 256 | 305.38 milliseconds | 190.63 milliseconds | 166.26 milliseconds |

#### Complete observable calculation · spinless fermions · two-site correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 291.77 milliseconds | 189.01 milliseconds | 172.44 milliseconds |
| 128 | 509.17 milliseconds | 320.36 milliseconds | 289.3 milliseconds |
| 256 | 1.4079 seconds | 890.35 milliseconds | 751.38 milliseconds |

#### Complete observable calculation · spin one-half · combined observables across different numbers of sites · ordinary MPS, no extra center legs


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 84.005 milliseconds | 49.945 milliseconds | 44.711 milliseconds |
| 128 | 124.68 milliseconds | 69.525 milliseconds | 61.474 milliseconds |
| 256 | 186.19 milliseconds | 123.52 milliseconds | 91.538 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 18.682 milliseconds | 11.143 milliseconds | 10.522 milliseconds |
| 128 | 28.358 milliseconds | 16.18 milliseconds | 15.564 milliseconds |
| 256 | 36.07 milliseconds | 20.805 milliseconds | 20.359 milliseconds |

#### Complete observable calculation · spin one-half · single-site observables · ordinary MPS, no extra center legs


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 13.709 milliseconds | 8.7822 milliseconds | 9.0225 milliseconds |
| 128 | 18.67 milliseconds | 11.396 milliseconds | 11.294 milliseconds |
| 256 | 25.901 milliseconds | 15.301 milliseconds | 14.58 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 74.507 milliseconds | 48.694 milliseconds | 43.637 milliseconds |
| 128 | 128.48 milliseconds | 66.899 milliseconds | 57.537 milliseconds |
| 256 | 178.1 milliseconds | 116.18 milliseconds | 85.066 milliseconds |

### SU(2) symmetry


#### Complete observable calculation · spin one-half · combined two-site and four-site correlations · ordinary MPS, no extra center legs


Calculate the registered combined two-site and four-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 36.819 milliseconds | 21.026 milliseconds | 20.753 milliseconds |
| 128 | 43.85 milliseconds | 24.086 milliseconds | 23.102 milliseconds |
| 256 | 45.177 milliseconds | 25.43 milliseconds | 24.961 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 15.153 milliseconds | 8.9298 milliseconds | 9.0461 milliseconds |
| 128 | 16.585 milliseconds | 10.147 milliseconds | 10.338 milliseconds |
| 256 | 17.539 milliseconds | 10.888 milliseconds | 11.125 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 32.127 milliseconds | 18.064 milliseconds | 17.875 milliseconds |
| 128 | 35.004 milliseconds | 20.652 milliseconds | 19.793 milliseconds |
| 256 | 39.832 milliseconds | 21.674 milliseconds | 20.829 milliseconds |

#### Complete observable calculation · spin one-half · single-site matrix elements with an open spin channel · ordinary MPS, bra has no extra leg; ket has an extra charge leg


Calculate the registered single-site matrix elements with an open spin channel over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 24.89 milliseconds | 18.187 milliseconds | 18.028 milliseconds |
| 128 | 30.548 milliseconds | 22.422 milliseconds | 21.531 milliseconds |
| 256 | 33.874 milliseconds | 25.525 milliseconds | 22.726 milliseconds |

#### Complete observable calculation · spin one-half · single-site matrix elements with an open spin channel · MPO with a purification leg, bra has no extra leg; ket has an extra charge leg


Calculate the registered single-site matrix elements with an open spin channel over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 65.455 milliseconds | 46.443 milliseconds | 42.024 milliseconds |
| 128 | 125.75 milliseconds | 100.27 milliseconds | 58.304 milliseconds |
| 256 | 183.77 milliseconds | 135.72 milliseconds | 142.81 milliseconds |

### U(1) × SU(2) symmetry


#### Complete observable calculation · spinful fermions · combined observables across different numbers of sites · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 25.082 seconds | 18.246 seconds | 17.063 seconds |
| 255 | 49.756 seconds | 34.45 seconds | 34.571 seconds |
| 511 | 64.823 seconds | 43.754 seconds | 44.4 seconds |

#### Complete observable calculation · spinful fermions · multisite correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 10.314 seconds | 7.7272 seconds | 7.3455 seconds |
| 255 | 19.188 seconds | 14.07 seconds | 13.162 seconds |
| 511 | 23.303 seconds | 17.086 seconds | 16.131 seconds |

#### Complete observable calculation · spinful fermions · singlet pairing and spin-bond correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered singlet pairing and spin-bond correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 9.466 seconds | 7.1286 seconds | 6.8265 seconds |
| 255 | 17.252 seconds | 12.031 seconds | 12.32 seconds |
| 511 | 20.175 seconds | 15.083 seconds | 15.578 seconds |

#### Complete observable calculation · spinful fermions · single-site observables · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 388.51 milliseconds | 206.4 milliseconds | 217 milliseconds |
| 255 | 586.54 milliseconds | 368.74 milliseconds | 433.58 milliseconds |
| 511 | 1.0074 seconds | 576.78 milliseconds | 610.1 milliseconds |

#### Complete observable calculation · spinful fermions · two-site correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 21.467 seconds | 14.51 seconds | 15.371 seconds |
| 255 | 43.451 seconds | 28.62 seconds | 29.155 seconds |
| 511 | 54.704 seconds | 37.672 seconds | 38.085 seconds |

## Supporting whole-chain operations


### No symmetry


#### Left and right canonicalization of base tensors · ordinary MPS


Construct the base tensor&#39;s canonical forms through left and right orthogonal factorizations and contractions, including the associated copying and memory allocation.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 8.1725 milliseconds | 8.2868 milliseconds | 8.289 milliseconds |
| 128 | 26.188 milliseconds | 26.787 milliseconds | 26.563 milliseconds |
| 256 | 51.822 milliseconds | 52.351 milliseconds | 53.194 milliseconds |

#### Left orthogonal projection of a tangent vector · ordinary MPS, tangent center with no extra leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.4223 milliseconds | 1.2559 milliseconds | 1.0306 milliseconds |
| 128 | 4.9132 milliseconds | 3.2579 milliseconds | 2.8851 milliseconds |
| 256 | 11.069 milliseconds | 6.6824 milliseconds | 7.2729 milliseconds |

#### Left orthogonal projection of a tangent vector · MPO with a purification leg, tangent center with no extra leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.9235 milliseconds | 2.8768 milliseconds | 2.5165 milliseconds |
| 128 | 28.365 milliseconds | 17.222 milliseconds | 14.028 milliseconds |
| 256 | 205.72 milliseconds | 104.27 milliseconds | 102.29 milliseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 38.311 microseconds | 81.803 microseconds | 258.7 microseconds |
| 128 | 99.286 microseconds | 299.25 microseconds | 339.94 microseconds |
| 256 | 159.97 microseconds | 422.47 microseconds | 514.38 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra component leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 256.72 microseconds | 457.88 microseconds | 292.81 microseconds |
| 128 | 1.2146 milliseconds | 948.66 microseconds | 589.56 microseconds |
| 256 | 4.5178 milliseconds | 4.0177 milliseconds | 4.1528 milliseconds |

### U(1) symmetry


#### Left orthogonal projection of a tangent vector · ordinary MPS, tangent center with an extra charge leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 666.05 microseconds | 973.5 microseconds | 710.87 microseconds |
| 128 | 967.55 microseconds | 987.9 microseconds | 844.92 microseconds |
| 256 | 1.3924 milliseconds | 982.56 microseconds | 857.97 microseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 7.975 microseconds | 241.84 microseconds | 76.122 microseconds |
| 128 | 26.008 microseconds | 216.97 microseconds | 92.783 microseconds |
| 256 | 47.618 microseconds | 86.18 microseconds | 240.5 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 28.764 microseconds | 71.192 microseconds | 71.624 microseconds |
| 128 | 104.96 microseconds | 251.07 microseconds | 343.04 microseconds |
| 256 | 329.68 microseconds | 320.47 microseconds | 319.99 microseconds |

### SU(2) symmetry


#### Full-chain environment construction · Heisenberg spin model · MPO with a purification leg


Build left and right environments over the full chain from an MPO base and the Heisenberg operator, including contraction and allocation; environment cleanup is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 22.974 milliseconds | 16.005 milliseconds | 17.823 milliseconds |
| 128 | 27.65 milliseconds | 18.562 milliseconds | 20.834 milliseconds |
| 256 | 42.288 milliseconds | 29.418 milliseconds | 25.323 milliseconds |

#### Left and right canonicalization of base tensors · MPO with a purification leg


Construct the base tensor&#39;s canonical forms through left and right orthogonal factorizations and contractions, including the associated copying and memory allocation.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 3.7169 milliseconds | 3.8319 milliseconds | 3.8458 milliseconds |
| 128 | 5.3933 milliseconds | 5.5517 milliseconds | 5.4009 milliseconds |
| 256 | 9.5939 milliseconds | 9.5557 milliseconds | 9.3846 milliseconds |

#### Left orthogonal projection of a tangent vector · MPO with a purification leg, tangent center with an extra charge leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 2.0959 milliseconds | 1.5465 milliseconds | 1.3295 milliseconds |
| 128 | 2.8263 milliseconds | 1.9984 milliseconds | 1.6663 milliseconds |
| 256 | 4.5782 milliseconds | 3.2675 milliseconds | 2.4381 milliseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 65.892 microseconds | 99.365 microseconds | 207.18 microseconds |
| 128 | 79.809 microseconds | 138.56 microseconds | 453.25 microseconds |
| 256 | 103.74 microseconds | 146.76 microseconds | 310.2 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 129.04 microseconds | 283.7 microseconds | 168.22 microseconds |
| 128 | 171.5 microseconds | 155.71 microseconds | 153.43 microseconds |
| 256 | 195.56 microseconds | 288.28 microseconds | 507.19 microseconds |

### U(1) × SU(2) symmetry


#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 490.12 microseconds | 395.39 microseconds | 527.57 microseconds |
| 255 | 598.17 microseconds | 679.29 microseconds | 775.09 microseconds |
| 511 | 787.78 microseconds | 743.84 microseconds | 762.94 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.0193 milliseconds | 862.05 microseconds | 975.94 microseconds |
| 255 | 1.6709 milliseconds | 1.6196 milliseconds | 1.5731 milliseconds |
| 511 | 2.3065 milliseconds | 1.5857 milliseconds | 1.832 milliseconds |

## Internal calculation stages


### No symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.7595 milliseconds | 1.5795 milliseconds | 1.616 milliseconds |
| 128 | 17.585 milliseconds | 9.9234 milliseconds | 9.2479 milliseconds |
| 256 | 44.241 milliseconds | 25.724 milliseconds | 24.507 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.8397 milliseconds | 1.5765 milliseconds | 1.6373 milliseconds |
| 128 | 17.396 milliseconds | 10.397 milliseconds | 9.47 milliseconds |
| 256 | 54.953 milliseconds | 31.051 milliseconds | 29.451 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.7427 milliseconds | 3.151 milliseconds | 3.085 milliseconds |
| 128 | 37.282 milliseconds | 20.606 milliseconds | 18.931 milliseconds |
| 256 | 111.62 milliseconds | 62.582 milliseconds | 49.961 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.2437 milliseconds | 3.1015 milliseconds | 2.8988 milliseconds |
| 128 | 35.647 milliseconds | 19.961 milliseconds | 19.082 milliseconds |
| 256 | 112.3 milliseconds | 63.64 milliseconds | 62.318 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.1411 milliseconds | 4.8189 milliseconds | 2.8836 milliseconds |
| 128 | 45.18 milliseconds | 20.448 milliseconds | 18.486 milliseconds |
| 256 | 266.69 milliseconds | 152.05 milliseconds | 135.29 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.0285 milliseconds | 4.5752 milliseconds | 2.8897 milliseconds |
| 128 | 43.541 milliseconds | 22.347 milliseconds | 18.288 milliseconds |
| 256 | 264.13 milliseconds | 148.16 milliseconds | 147.45 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 17.05 milliseconds | 5.7669 milliseconds | 5.3487 milliseconds |
| 128 | 72.239 milliseconds | 40.32 milliseconds | 37.551 milliseconds |
| 256 | 556.4 milliseconds | 318.34 milliseconds | 311.35 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 15.608 milliseconds | 8.0194 milliseconds | 5.7777 milliseconds |
| 128 | 69.711 milliseconds | 39.394 milliseconds | 37.312 milliseconds |
| 256 | 552.68 milliseconds | 311.32 milliseconds | 302.01 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.8888 milliseconds | 1.1369 milliseconds | 1.0258 milliseconds |
| 128 | 11.812 milliseconds | 7.1849 milliseconds | 6.4852 milliseconds |
| 256 | 34.377 milliseconds | 19.775 milliseconds | 18.649 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.7158 milliseconds | 2.0687 milliseconds | 2.1818 milliseconds |
| 128 | 23.83 milliseconds | 13.985 milliseconds | 12.734 milliseconds |
| 256 | 90.277 milliseconds | 45.969 milliseconds | 38.857 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.5899 milliseconds | 3.4209 milliseconds | 2.0611 milliseconds |
| 128 | 36.445 milliseconds | 16.428 milliseconds | 12.647 milliseconds |
| 256 | 179.87 milliseconds | 97.765 milliseconds | 97.857 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 6.9372 milliseconds | 3.9407 milliseconds | 3.6349 milliseconds |
| 128 | 72.276 milliseconds | 36.189 milliseconds | 25.287 milliseconds |
| 256 | 358.5 milliseconds | 207.33 milliseconds | 197.91 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.9446 milliseconds | 1.1317 milliseconds | 1.1744 milliseconds |
| 128 | 11.987 milliseconds | 9.1456 milliseconds | 6.6086 milliseconds |
| 256 | 34.138 milliseconds | 19.648 milliseconds | 18.111 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.0618 milliseconds | 1.2186 milliseconds | 1.148 milliseconds |
| 128 | 12.216 milliseconds | 7.0825 milliseconds | 6.5616 milliseconds |
| 256 | 42.469 milliseconds | 21.462 milliseconds | 18.842 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.7379 milliseconds | 2.0655 milliseconds | 2.2774 milliseconds |
| 128 | 30.939 milliseconds | 13.8 milliseconds | 13.082 milliseconds |
| 256 | 181.13 milliseconds | 104.8 milliseconds | 93.806 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.1145 milliseconds | 2.418 milliseconds | 2.2944 milliseconds |
| 128 | 38.884 milliseconds | 17.786 milliseconds | 13.82 milliseconds |
| 256 | 191.76 milliseconds | 109.22 milliseconds | 103.24 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 478.5 microseconds | 352.75 microseconds | 341.07 microseconds |
| 128 | 3.2174 milliseconds | 1.6723 milliseconds | 1.6404 milliseconds |
| 256 | 12.224 milliseconds | 6.2686 milliseconds | 6.1194 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 481.84 microseconds | 403.22 microseconds | 321.03 microseconds |
| 128 | 3.1816 milliseconds | 1.6944 milliseconds | 1.6336 milliseconds |
| 256 | 7.3979 milliseconds | 3.3679 milliseconds | 3.2532 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 884.65 microseconds | 513.58 microseconds | 502.46 microseconds |
| 128 | 6.3901 milliseconds | 3.3182 milliseconds | 3.3436 milliseconds |
| 256 | 27.582 milliseconds | 13.904 milliseconds | 12.23 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 920.75 microseconds | 515.21 microseconds | 525 microseconds |
| 128 | 6.4372 milliseconds | 3.2984 milliseconds | 3.2642 milliseconds |
| 256 | 12.826 milliseconds | 10.782 milliseconds | 6.6065 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 870.76 microseconds | 863.39 microseconds | 713.33 microseconds |
| 128 | 8.1534 milliseconds | 7.2559 milliseconds | 3.3941 milliseconds |
| 256 | 48.259 milliseconds | 25.855 milliseconds | 24.222 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 902.95 microseconds | 520.17 microseconds | 494.59 microseconds |
| 128 | 8.1868 milliseconds | 3.3967 milliseconds | 3.3994 milliseconds |
| 256 | 48.662 milliseconds | 24.573 milliseconds | 24.707 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.8103 milliseconds | 941.82 microseconds | 909.75 microseconds |
| 128 | 13.257 milliseconds | 6.8804 milliseconds | 6.7461 milliseconds |
| 256 | 95.36 milliseconds | 49.071 milliseconds | 50.095 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.7622 milliseconds | 984.76 microseconds | 1.0442 milliseconds |
| 128 | 13.076 milliseconds | 6.7131 milliseconds | 6.4725 milliseconds |
| 256 | 103.73 milliseconds | 53.298 milliseconds | 51.869 milliseconds |

</details>


### U(1) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.974 milliseconds | 1.7625 milliseconds | 1.085 milliseconds |
| 128 | 4.8806 milliseconds | 3.7894 milliseconds | 2.4178 milliseconds |
| 256 | 8.4398 milliseconds | 4.3176 milliseconds | 3.8473 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.0984 milliseconds | 1.1562 milliseconds | 1.1147 milliseconds |
| 128 | 6.8553 milliseconds | 3.9437 milliseconds | 2.3089 milliseconds |
| 256 | 10.473 milliseconds | 4.7469 milliseconds | 4.7191 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.5657 milliseconds | 1.5313 milliseconds | 1.2858 milliseconds |
| 128 | 5.3503 milliseconds | 2.9612 milliseconds | 2.7108 milliseconds |
| 256 | 9.2541 milliseconds | 4.7901 milliseconds | 4.4422 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.8616 milliseconds | 1.3966 milliseconds | 1.3427 milliseconds |
| 128 | 5.7046 milliseconds | 2.7627 milliseconds | 2.5315 milliseconds |
| 256 | 10.44 milliseconds | 4.9597 milliseconds | 4.8252 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.4717 milliseconds | 2.0514 milliseconds | 1.8458 milliseconds |
| 128 | 9.2757 milliseconds | 4.8388 milliseconds | 4.2142 milliseconds |
| 256 | 37.348 milliseconds | 22.095 milliseconds | 16.528 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.2959 milliseconds | 1.8177 milliseconds | 1.6489 milliseconds |
| 128 | 8.7717 milliseconds | 4.5022 milliseconds | 4.1781 milliseconds |
| 256 | 36.619 milliseconds | 17.243 milliseconds | 16.219 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.084 milliseconds | 3.3754 milliseconds | 2.1513 milliseconds |
| 128 | 9.5754 milliseconds | 5.3982 milliseconds | 4.4721 milliseconds |
| 256 | 36.489 milliseconds | 18.345 milliseconds | 15.289 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.4004 milliseconds | 2.1203 milliseconds | 2.2665 milliseconds |
| 128 | 9.9759 milliseconds | 4.9341 milliseconds | 4.6301 milliseconds |
| 256 | 37.92 milliseconds | 17.825 milliseconds | 16.141 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.5839 milliseconds | 876.92 microseconds | 997.01 microseconds |
| 128 | 5.8402 milliseconds | 2.7835 milliseconds | 1.7519 milliseconds |
| 256 | 12.609 milliseconds | 3.2885 milliseconds | 3.1857 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.5781 milliseconds | 917.37 microseconds | 956.88 microseconds |
| 128 | 3.6715 milliseconds | 1.9156 milliseconds | 1.8937 milliseconds |
| 256 | 6.8052 milliseconds | 3.1322 milliseconds | 3.1719 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.404 milliseconds | 1.4079 milliseconds | 1.4194 milliseconds |
| 128 | 6.3671 milliseconds | 4.0348 milliseconds | 3.6991 milliseconds |
| 256 | 22.305 milliseconds | 11.46 milliseconds | 10.63 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.333 milliseconds | 1.2927 milliseconds | 1.3764 milliseconds |
| 128 | 6.3992 milliseconds | 3.9941 milliseconds | 3.18 milliseconds |
| 256 | 19.997 milliseconds | 10.504 milliseconds | 9.4474 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.4452 milliseconds | 855.87 microseconds | 812.07 microseconds |
| 128 | 3.2758 milliseconds | 1.985 milliseconds | 1.6994 milliseconds |
| 256 | 6.177 milliseconds | 3.281 milliseconds | 3.0554 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.5092 milliseconds | 977.62 microseconds | 841.99 microseconds |
| 128 | 3.5332 milliseconds | 1.9848 milliseconds | 1.6355 milliseconds |
| 256 | 6.483 milliseconds | 3.4231 milliseconds | 3.1174 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.4028 milliseconds | 2.1464 milliseconds | 1.3859 milliseconds |
| 128 | 6.5001 milliseconds | 5.3222 milliseconds | 3.5029 milliseconds |
| 256 | 21.937 milliseconds | 11.886 milliseconds | 10.168 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.3764 milliseconds | 1.3583 milliseconds | 1.2206 milliseconds |
| 128 | 6.2503 milliseconds | 3.9461 milliseconds | 3.7773 milliseconds |
| 256 | 26.73 milliseconds | 11.792 milliseconds | 10.451 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 243.7 microseconds | 270.2 microseconds | 197.41 microseconds |
| 128 | 786.41 microseconds | 691.76 microseconds | 481.42 microseconds |
| 256 | 1.8459 milliseconds | 958.93 microseconds | 884.74 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 202.33 microseconds | 204.76 microseconds | 129.96 microseconds |
| 128 | 640.84 microseconds | 341.4 microseconds | 328.07 microseconds |
| 256 | 1.0426 milliseconds | 551.21 microseconds | 624.19 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 248.44 microseconds | 174.91 microseconds | 198.72 microseconds |
| 128 | 720.92 microseconds | 435.62 microseconds | 600.04 microseconds |
| 256 | 1.7183 milliseconds | 852.47 microseconds | 969.84 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 253.44 microseconds | 177.58 microseconds | 333.82 microseconds |
| 128 | 754.48 microseconds | 402.05 microseconds | 562.59 microseconds |
| 256 | 1.2386 milliseconds | 628.32 microseconds | 602.52 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 386.12 microseconds | 242.1 microseconds | 259.79 microseconds |
| 128 | 1.3271 milliseconds | 1.1323 milliseconds | 644.01 microseconds |
| 256 | 5.8818 milliseconds | 2.937 milliseconds | 2.9737 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 410.5 microseconds | 325.13 microseconds | 398.64 microseconds |
| 128 | 1.341 milliseconds | 746.19 microseconds | 935.09 microseconds |
| 256 | 5.7046 milliseconds | 3.0914 milliseconds | 2.5917 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 375.15 microseconds | 236.56 microseconds | 258.75 microseconds |
| 128 | 1.2844 milliseconds | 1.0638 milliseconds | 601.28 microseconds |
| 256 | 5.221 milliseconds | 2.8169 milliseconds | 2.8444 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 395.92 microseconds | 297.53 microseconds | 221.18 microseconds |
| 128 | 1.2029 milliseconds | 884.64 microseconds | 686.72 microseconds |
| 256 | 5.4388 milliseconds | 2.7614 milliseconds | 2.4515 milliseconds |

</details>


### SU(2) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 609.66 microseconds | 413.75 microseconds | 499.05 microseconds |
| 128 | 884.62 microseconds | 660.77 microseconds | 779.04 microseconds |
| 256 | 1.0941 milliseconds | 1.3058 milliseconds | 754.89 microseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 651.12 microseconds | 414.88 microseconds | 632.42 microseconds |
| 128 | 927.72 microseconds | 634.92 microseconds | 914.38 microseconds |
| 256 | 1.242 milliseconds | 847.09 microseconds | 872.6 microseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.518 milliseconds | 1.5598 milliseconds | 1.0369 milliseconds |
| 128 | 2.5712 milliseconds | 2.4236 milliseconds | 1.7281 milliseconds |
| 256 | 3.4112 milliseconds | 2.2323 milliseconds | 2.1891 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.5433 milliseconds | 1.545 milliseconds | 1.0252 milliseconds |
| 128 | 2.5811 milliseconds | 2.3789 milliseconds | 1.8129 milliseconds |
| 256 | 3.5178 milliseconds | 2.328 milliseconds | 2.1367 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.1002 milliseconds | 770.04 microseconds | 919.22 microseconds |
| 128 | 1.724 milliseconds | 1.1916 milliseconds | 1.0404 milliseconds |
| 256 | 3.042 milliseconds | 2.1602 milliseconds | 1.7103 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.0974 milliseconds | 767.44 microseconds | 767.96 microseconds |
| 128 | 1.7078 milliseconds | 1.1419 milliseconds | 1.0718 milliseconds |
| 256 | 3.0077 milliseconds | 1.9006 milliseconds | 1.9492 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 2.7853 milliseconds | 1.8563 milliseconds | 1.9498 milliseconds |
| 128 | 4.7352 milliseconds | 4.6137 milliseconds | 2.8856 milliseconds |
| 256 | 10.44 milliseconds | 6.021 milliseconds | 5.5814 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 2.9199 milliseconds | 1.9 milliseconds | 1.8861 milliseconds |
| 128 | 4.7793 milliseconds | 4.3983 milliseconds | 3.0344 milliseconds |
| 256 | 9.7526 milliseconds | 6.3847 milliseconds | 6.0667 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 491.78 microseconds | 342.43 microseconds | 407.14 microseconds |
| 128 | 599.87 microseconds | 446.44 microseconds | 643.96 microseconds |
| 256 | 987.9 microseconds | 819.99 microseconds | 724.08 microseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 895.34 microseconds | 974.66 microseconds | 696.35 microseconds |
| 128 | 1.5371 milliseconds | 1.476 milliseconds | 954.22 microseconds |
| 256 | 2.0492 milliseconds | 1.2911 milliseconds | 1.3195 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 744.54 microseconds | 549.43 microseconds | 591.28 microseconds |
| 128 | 1.1458 milliseconds | 1.2253 milliseconds | 815.86 microseconds |
| 256 | 1.9375 milliseconds | 1.536 milliseconds | 1.3202 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.6088 milliseconds | 1.0539 milliseconds | 1.1103 milliseconds |
| 128 | 2.7149 milliseconds | 2.5787 milliseconds | 1.884 milliseconds |
| 256 | 5.3793 milliseconds | 3.4049 milliseconds | 3.2938 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 449.35 microseconds | 308.45 microseconds | 374.57 microseconds |
| 128 | 613.99 microseconds | 456.4 microseconds | 501.35 microseconds |
| 256 | 782.68 microseconds | 578.69 microseconds | 564.95 microseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 461.15 microseconds | 497.39 microseconds | 443.64 microseconds |
| 128 | 638.99 microseconds | 483.04 microseconds | 408.85 microseconds |
| 256 | 781.74 microseconds | 521.63 microseconds | 605.6 microseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 758.9 microseconds | 877.89 microseconds | 590.33 microseconds |
| 128 | 1.1319 milliseconds | 1.2103 milliseconds | 837.01 microseconds |
| 256 | 1.9499 milliseconds | 1.3487 milliseconds | 1.3557 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 777.47 microseconds | 483.41 microseconds | 549.76 microseconds |
| 128 | 1.1566 milliseconds | 689.54 microseconds | 778 microseconds |
| 256 | 1.9692 milliseconds | 1.1049 milliseconds | 1.0827 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 63.318 microseconds | 93.424 microseconds | 101.36 microseconds |
| 128 | 113.51 microseconds | 134.9 microseconds | 137.32 microseconds |
| 256 | 170.61 microseconds | 147.88 microseconds | 333.56 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 80.841 microseconds | 78.056 microseconds | 68.899 microseconds |
| 128 | 120.78 microseconds | 93.905 microseconds | 91.782 microseconds |
| 256 | 148.08 microseconds | 147.16 microseconds | 108.94 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 129.16 microseconds | 179.44 microseconds | 112.79 microseconds |
| 128 | 239.48 microseconds | 256.25 microseconds | 150.39 microseconds |
| 256 | 356.06 microseconds | 265.46 microseconds | 215.05 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 132.46 microseconds | 162.22 microseconds | 104.86 microseconds |
| 128 | 255.4 microseconds | 261.09 microseconds | 145.34 microseconds |
| 256 | 334.44 microseconds | 204.79 microseconds | 186.16 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 102.65 microseconds | 148.92 microseconds | 95.969 microseconds |
| 128 | 178.53 microseconds | 418.99 microseconds | 140.81 microseconds |
| 256 | 397.77 microseconds | 246.33 microseconds | 233.58 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 112.55 microseconds | 174.53 microseconds | 132.49 microseconds |
| 128 | 205.9 microseconds | 164.03 microseconds | 288.62 microseconds |
| 256 | 375.15 microseconds | 296.5 microseconds | 401.59 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 223.97 microseconds | 155.99 microseconds | 328.81 microseconds |
| 128 | 433.08 microseconds | 452.4 microseconds | 260.11 microseconds |
| 256 | 971.68 microseconds | 548.6 microseconds | 566.89 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 226.17 microseconds | 199.04 microseconds | 290.38 microseconds |
| 128 | 437.81 microseconds | 377.64 microseconds | 285.87 microseconds |
| 256 | 1.008 milliseconds | 757.53 microseconds | 742.47 microseconds |

</details>


### U(1) × SU(2) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.4857 milliseconds | 1.3793 milliseconds | 1.4699 milliseconds |
| 255 | 3.9522 milliseconds | 2.4783 milliseconds | 2.2124 milliseconds |
| 511 | 9.5088 milliseconds | 7.9743 milliseconds | 4.6447 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.6907 milliseconds | 1.717 milliseconds | 1.4838 milliseconds |
| 255 | 4.3123 milliseconds | 4.1564 milliseconds | 2.3663 milliseconds |
| 511 | 10.32 milliseconds | 7.7091 milliseconds | 5.1648 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 7.1262 milliseconds | 3.9715 milliseconds | 3.7644 milliseconds |
| 255 | 9.5007 milliseconds | 5.5899 milliseconds | 5.3362 milliseconds |
| 511 | 22.703 milliseconds | 12.444 milliseconds | 10.71 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 7.0055 milliseconds | 4.2594 milliseconds | 3.9339 milliseconds |
| 255 | 9.5018 milliseconds | 5.9045 milliseconds | 5.593 milliseconds |
| 511 | 71.755 milliseconds | 13.33 milliseconds | 10.993 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 9.1826 milliseconds | 5.2612 milliseconds | 5.4468 milliseconds |
| 255 | 17.958 milliseconds | 9.0138 milliseconds | 8.6047 milliseconds |
| 511 | 50.695 milliseconds | 32.934 milliseconds | 17.505 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 10.522 milliseconds | 5.1099 milliseconds | 5.558 milliseconds |
| 255 | 16.34 milliseconds | 9.2337 milliseconds | 7.8289 milliseconds |
| 511 | 54.154 milliseconds | 57.993 milliseconds | 53.953 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 23.265 milliseconds | 14.9 milliseconds | 12.524 milliseconds |
| 255 | 95.28 milliseconds | 24.553 milliseconds | 19.493 milliseconds |
| 511 | 142.76 milliseconds | 450.24 milliseconds | 145.35 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 24.283 milliseconds | 16.206 milliseconds | 13.338 milliseconds |
| 255 | 43.597 milliseconds | 25.51 milliseconds | 22.539 milliseconds |
| 511 | 124.74 milliseconds | 186.01 milliseconds | 41.683 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.013 milliseconds | 1.8257 milliseconds | 1.1052 milliseconds |
| 255 | 2.9969 milliseconds | 1.8168 milliseconds | 1.5314 milliseconds |
| 511 | 6.6876 milliseconds | 3.9501 milliseconds | 3.3344 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 3.9939 milliseconds | 2.273 milliseconds | 2.296 milliseconds |
| 255 | 6.0133 milliseconds | 3.638 milliseconds | 3.3347 milliseconds |
| 511 | 13.518 milliseconds | 8.0943 milliseconds | 6.0964 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 6.0154 milliseconds | 3.3322 milliseconds | 3.3394 milliseconds |
| 255 | 10.682 milliseconds | 6.6342 milliseconds | 45.073 milliseconds |
| 511 | 34.182 milliseconds | 14.075 milliseconds | 10.841 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 16.061 milliseconds | 9.0774 milliseconds | 7.9347 milliseconds |
| 255 | 97.868 milliseconds | 14.65 milliseconds | 12.878 milliseconds |
| 511 | 77.22 milliseconds | 100.97 milliseconds | 115.59 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.0218 milliseconds | 1.1359 milliseconds | 1.1453 milliseconds |
| 255 | 3.1117 milliseconds | 1.8648 milliseconds | 1.7118 milliseconds |
| 511 | 6.654 milliseconds | 3.7141 milliseconds | 3.2396 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.227 milliseconds | 1.2951 milliseconds | 1.2874 milliseconds |
| 255 | 2.902 milliseconds | 1.7932 milliseconds | 1.5351 milliseconds |
| 511 | 7.0472 milliseconds | 3.9479 milliseconds | 3.5664 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 6.8542 milliseconds | 3.5485 milliseconds | 3.3907 milliseconds |
| 255 | 10.329 milliseconds | 6.0353 milliseconds | 5.3372 milliseconds |
| 511 | 27.02 milliseconds | 14.119 milliseconds | 11.818 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 5.8813 milliseconds | 3.3852 milliseconds | 3.2881 milliseconds |
| 255 | 10.439 milliseconds | 6.0783 milliseconds | 5.1642 milliseconds |
| 511 | 24.438 milliseconds | 13.682 milliseconds | 10.941 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 251.13 microseconds | 287.43 microseconds | 192.48 microseconds |
| 255 | 498.32 microseconds | 346.74 microseconds | 585.06 microseconds |
| 511 | 1.4496 milliseconds | 836.1 microseconds | 1.1909 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 162.35 microseconds | 136.34 microseconds | 116.31 microseconds |
| 255 | 329.82 microseconds | 312.54 microseconds | 213.62 microseconds |
| 511 | 1.0289 milliseconds | 645.54 microseconds | 643.57 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 420.34 microseconds | 452.71 microseconds | 353.54 microseconds |
| 255 | 849.04 microseconds | 504.51 microseconds | 562.36 microseconds |
| 511 | 2.2519 milliseconds | 1.3633 milliseconds | 1.3034 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 454.8 microseconds | 471.44 microseconds | 475.41 microseconds |
| 255 | 822.19 microseconds | 543.2 microseconds | 628.38 microseconds |
| 511 | 2.3318 milliseconds | 1.3989 milliseconds | 1.499 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 846.84 microseconds | 495.94 microseconds | 499.85 microseconds |
| 255 | 1.3937 milliseconds | 1.2916 milliseconds | 886.88 microseconds |
| 511 | 5.2905 milliseconds | 2.4594 milliseconds | 2.3081 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 844.9 microseconds | 493.52 microseconds | 504.65 microseconds |
| 255 | 1.4354 milliseconds | 821.82 microseconds | 1.0557 milliseconds |
| 511 | 4.3638 milliseconds | 2.4011 milliseconds | 2.7475 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.8845 milliseconds | 1.1466 milliseconds | 1.0517 milliseconds |
| 255 | 2.9943 milliseconds | 1.5934 milliseconds | 1.5292 milliseconds |
| 511 | 8.2238 milliseconds | 18.023 milliseconds | 4.0238 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.942 milliseconds | 1.0565 milliseconds | 1.074 milliseconds |
| 255 | 3.0542 milliseconds | 2.5533 milliseconds | 2.0596 milliseconds |
| 511 | 7.9785 milliseconds | 4.928 milliseconds | 4.5886 milliseconds |

</details>

