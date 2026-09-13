# Performance report

Source commit: `2a8231b3f344edbea286cd8b635cf0ee314f35c4`

Julia uses 1, 2, or 4 compute threads; the linear algebra backend and garbage collector each use 1 thread.

| Thread configuration | Measurements | Measurement timestamp (UTC) | Detailed report |
| --- | ---: | --- | --- |
| 1 thread | 447 | 2026-09-13T09:58:15.295Z | [Input and sampling details](configurations/julia-1-blas-1/report.md) |
| 2 threads | 447 | 2026-09-13T10:52:16.841Z | [Input and sampling details](configurations/julia-2-blas-1/report.md) |
| 4 threads | 447 | 2026-09-13T11:35:35.059Z | [Input and sampling details](configurations/julia-4-blas-1/report.md) |

The tables show median execution times for each center bond dimension, including the full dimensions of symmetry multiplets.


## Sparse operator action on tangent vectors


### No symmetry


#### Sparse operator action · transverse-field Ising model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 60.856 milliseconds | 39.866 milliseconds | 44.076 milliseconds |
| 128 | 189.81 milliseconds | 112.17 milliseconds | 112.36 milliseconds |
| 256 | 406.78 milliseconds | 229.98 milliseconds | 231.86 milliseconds |

#### Sparse operator action · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 111.98 milliseconds | 71.838 milliseconds | 77.106 milliseconds |
| 128 | 377.39 milliseconds | 221.66 milliseconds | 226.05 milliseconds |
| 256 | 810.04 milliseconds | 457.32 milliseconds | 451.92 milliseconds |

#### Sparse operator action · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 197.55 milliseconds | 122.12 milliseconds | 123.89 milliseconds |
| 128 | 1.306 seconds | 815.24 milliseconds | 820.46 milliseconds |
| 256 | 7.3919 seconds | 4.3163 seconds | 4.2571 seconds |

#### Sparse operator action · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 413.6 milliseconds | 228.48 milliseconds | 234.18 milliseconds |
| 128 | 2.4249 seconds | 1.3964 seconds | 1.398 seconds |
| 256 | 15.16 seconds | 8.9369 seconds | 8.6006 seconds |

### U(1) symmetry


#### Sparse operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 60.111 milliseconds | 42.323 milliseconds | 44.023 milliseconds |
| 128 | 101.32 milliseconds | 63.361 milliseconds | 63.418 milliseconds |
| 256 | 118.58 milliseconds | 77.908 milliseconds | 71.409 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 77.917 milliseconds | 56.389 milliseconds | 58.422 milliseconds |
| 128 | 116.63 milliseconds | 85.826 milliseconds | 78.357 milliseconds |
| 256 | 137.33 milliseconds | 90.736 milliseconds | 87.279 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 136.94 milliseconds | 89.374 milliseconds | 85.707 milliseconds |
| 128 | 319.06 milliseconds | 190.29 milliseconds | 177.96 milliseconds |
| 256 | 1.1532 seconds | 780.11 milliseconds | 735.31 milliseconds |

#### Sparse operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 163.57 milliseconds | 105.39 milliseconds | 104.95 milliseconds |
| 128 | 447.07 milliseconds | 209.55 milliseconds | 191.92 milliseconds |
| 256 | 1.2565 seconds | 767.09 milliseconds | 764.63 milliseconds |

### SU(2) symmetry


#### Sparse operator action · Heisenberg spin model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 19.766 milliseconds | 19.73 milliseconds | 19.339 milliseconds |
| 128 | 23.316 milliseconds | 17.531 milliseconds | 18.983 milliseconds |
| 256 | 24.006 milliseconds | 18.435 milliseconds | 21.924 milliseconds |

#### Sparse operator action · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 40.645 milliseconds | 29.196 milliseconds | 31.596 milliseconds |
| 128 | 65.1 milliseconds | 71.349 milliseconds | 52.98 milliseconds |
| 256 | 68.787 milliseconds | 64.023 milliseconds | 52.393 milliseconds |

#### Sparse operator action · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 38.213 milliseconds | 27.391 milliseconds | 28.472 milliseconds |
| 128 | 62.381 milliseconds | 35.866 milliseconds | 36.557 milliseconds |
| 256 | 102.14 milliseconds | 69.586 milliseconds | 75.369 milliseconds |

#### Sparse operator action · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 99.53 milliseconds | 59.115 milliseconds | 60.439 milliseconds |
| 128 | 163.47 milliseconds | 98.168 milliseconds | 105.97 milliseconds |
| 256 | 595.52 milliseconds | 181.88 milliseconds | 167.67 milliseconds |

### U(1) × SU(2) symmetry


#### Sparse operator action · Hubbard fermion model · ordinary MPS, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 102.82 milliseconds | 72.256 milliseconds | 67.665 milliseconds |
| 255 | 160.75 milliseconds | 107.4 milliseconds | 102.95 milliseconds |
| 511 | 301.16 milliseconds | 194.44 milliseconds | 176.82 milliseconds |

#### Sparse operator action · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.8395 seconds | 1.1572 seconds | 1.1125 seconds |
| 255 | 301.05 milliseconds | 195.26 milliseconds | 190.26 milliseconds |
| 511 | 946.7 milliseconds | 341.49 milliseconds | 643.27 milliseconds |

#### Sparse operator action · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 422.29 milliseconds | 248.55 milliseconds | 245.46 milliseconds |
| 255 | 709.07 milliseconds | 441.39 milliseconds | 393.95 milliseconds |
| 511 | 1.7148 seconds | 819.16 milliseconds | 672.25 milliseconds |

#### Sparse operator action · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg


Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 858.05 milliseconds | 526.91 milliseconds | 493.46 milliseconds |
| 255 | 20.448 seconds | 14.146 seconds | 13.89 seconds |
| 511 | 25.438 seconds | 17.229 seconds | 16.866 seconds |

## Complete observable calculations


### No symmetry


#### Complete observable calculation · spin one-half · combined observables across different numbers of sites · ordinary MPS, no extra center legs


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 119.11 milliseconds | 66.839 milliseconds | 65.327 milliseconds |
| 128 | 446.3 milliseconds | 248.61 milliseconds | 236.11 milliseconds |
| 256 | 988.81 milliseconds | 556.68 milliseconds | 566.93 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 36.624 milliseconds | 24.56 milliseconds | 26.652 milliseconds |
| 128 | 128.31 milliseconds | 85.118 milliseconds | 85.136 milliseconds |
| 256 | 310.99 milliseconds | 197.36 milliseconds | 181.59 milliseconds |

#### Complete observable calculation · spin one-half · single-site observables · ordinary MPS, no extra center legs


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 34.401 milliseconds | 28.018 milliseconds | 30.84 milliseconds |
| 128 | 122.85 milliseconds | 105.86 milliseconds | 101.67 milliseconds |
| 256 | 332.4 milliseconds | 275.64 milliseconds | 237.75 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 98.408 milliseconds | 55.736 milliseconds | 57.22 milliseconds |
| 128 | 364.63 milliseconds | 208.22 milliseconds | 202.75 milliseconds |
| 256 | 829.97 milliseconds | 470.19 milliseconds | 500.23 milliseconds |

### U(1) symmetry


#### Complete observable calculation · spinless fermions · combined observables across different numbers of sites · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 274.4 milliseconds | 181.81 milliseconds | 124.95 milliseconds |
| 128 | 474.88 milliseconds | 306.47 milliseconds | 271.14 milliseconds |
| 256 | 1.4613 seconds | 837.04 milliseconds | 845.61 milliseconds |

#### Complete observable calculation · spinless fermions · multisite correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 103.18 milliseconds | 52.427 milliseconds | 49.804 milliseconds |
| 128 | 185.45 milliseconds | 118.07 milliseconds | 110.86 milliseconds |
| 256 | 526.03 milliseconds | 325.37 milliseconds | 292.37 milliseconds |

#### Complete observable calculation · spinless fermions · single-site observables · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 37.158 milliseconds | 32.31 milliseconds | 31.422 milliseconds |
| 128 | 66.053 milliseconds | 59.278 milliseconds | 64.804 milliseconds |
| 256 | 248.86 milliseconds | 210.36 milliseconds | 221.2 milliseconds |

#### Complete observable calculation · spinless fermions · two-site correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 234.33 milliseconds | 166.08 milliseconds | 161.14 milliseconds |
| 128 | 437.93 milliseconds | 306.1 milliseconds | 278.26 milliseconds |
| 256 | 1.2023 seconds | 840.76 milliseconds | 769.22 milliseconds |

#### Complete observable calculation · spin one-half · combined observables across different numbers of sites · ordinary MPS, no extra center legs


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 64.096 milliseconds | 38.001 milliseconds | 37.99 milliseconds |
| 128 | 99.103 milliseconds | 58.323 milliseconds | 53.68 milliseconds |
| 256 | 148.68 milliseconds | 78.869 milliseconds | 75.37 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 13.203 milliseconds | 8.339 milliseconds | 9.6517 milliseconds |
| 128 | 20.927 milliseconds | 13.73 milliseconds | 13.259 milliseconds |
| 256 | 29.252 milliseconds | 19.708 milliseconds | 18.966 milliseconds |

#### Complete observable calculation · spin one-half · single-site observables · ordinary MPS, no extra center legs


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 9.0154 milliseconds | 8.4448 milliseconds | 8.6733 milliseconds |
| 128 | 14.852 milliseconds | 12.784 milliseconds | 14.616 milliseconds |
| 256 | 21.976 milliseconds | 18.247 milliseconds | 20.907 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 60.284 milliseconds | 37.637 milliseconds | 35.19 milliseconds |
| 128 | 93.74 milliseconds | 54.389 milliseconds | 50.164 milliseconds |
| 256 | 132.47 milliseconds | 71.867 milliseconds | 71.03 milliseconds |

### SU(2) symmetry


#### Complete observable calculation · spin one-half · combined two-site and four-site correlations · ordinary MPS, no extra center legs


Calculate the registered combined two-site and four-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 23.585 milliseconds | 13.905 milliseconds | 14.274 milliseconds |
| 128 | 26.712 milliseconds | 16.529 milliseconds | 16.582 milliseconds |
| 256 | 30.451 milliseconds | 18.415 milliseconds | 17.728 milliseconds |

#### Complete observable calculation · spin one-half · multisite correlations · ordinary MPS, no extra center legs


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 9.8304 milliseconds | 6.2734 milliseconds | 8.6615 milliseconds |
| 128 | 11.332 milliseconds | 7.2838 milliseconds | 8.31 milliseconds |
| 256 | 12.082 milliseconds | 7.9797 milliseconds | 8.5526 milliseconds |

#### Complete observable calculation · spin one-half · two-site correlations · ordinary MPS, no extra center legs


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 18.315 milliseconds | 12.217 milliseconds | 12.869 milliseconds |
| 128 | 22.878 milliseconds | 14.648 milliseconds | 14.952 milliseconds |
| 256 | 25.835 milliseconds | 16.21 milliseconds | 15.956 milliseconds |

#### Complete observable calculation · spin one-half · single-site matrix elements with an open spin channel · ordinary MPS, bra has no extra leg; ket has an extra charge leg


Calculate the registered single-site matrix elements with an open spin channel over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 16.853 milliseconds | 14.734 milliseconds | 70.817 milliseconds |
| 128 | 19.973 milliseconds | 19.1 milliseconds | 19.714 milliseconds |
| 256 | 23.028 milliseconds | 20.93 milliseconds | 22.363 milliseconds |

#### Complete observable calculation · spin one-half · single-site matrix elements with an open spin channel · MPO with a purification leg, bra has no extra leg; ket has an extra charge leg


Calculate the registered single-site matrix elements with an open spin channel over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 40.637 milliseconds | 36.889 milliseconds | 38.988 milliseconds |
| 128 | 99.199 milliseconds | 124.12 milliseconds | 121.61 milliseconds |
| 256 | 162.84 milliseconds | 137.36 milliseconds | 155.37 milliseconds |

### U(1) × SU(2) symmetry


#### Complete observable calculation · spinful fermions · combined observables across different numbers of sites · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered combined observables across different numbers of sites over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 31.748 seconds | 21.941 seconds | 22.392 seconds |
| 255 | 63.386 seconds | 43.765 seconds | 44.152 seconds |
| 511 | 79.414 seconds | 54.307 seconds | 54.761 seconds |

#### Complete observable calculation · spinful fermions · multisite correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered multisite correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 12.954 seconds | 8.9541 seconds | 5.5826 seconds |
| 255 | 23.816 seconds | 16.982 seconds | 14.829 seconds |
| 511 | 29.163 seconds | 20.314 seconds | 18.344 seconds |

#### Complete observable calculation · spinful fermions · singlet pairing and spin-bond correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered singlet pairing and spin-bond correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 11.249 seconds | 6.39 seconds | 4.417 seconds |
| 255 | 19.946 seconds | 14.653 seconds | 12.158 seconds |
| 511 | 24.851 seconds | 18.114 seconds | 15.933 seconds |

#### Complete observable calculation · spinful fermions · single-site observables · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered single-site observables over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 282.78 milliseconds | 213.68 milliseconds | 223.3 milliseconds |
| 255 | 476.36 milliseconds | 394.71 milliseconds | 843.21 milliseconds |
| 511 | 857.09 milliseconds | 654.5 milliseconds | 708.34 milliseconds |

#### Complete observable calculation · spinful fermions · two-site correlations · MPO with a purification leg, bra and ket each have an extra charge leg


Calculate the registered two-site correlations over the full chain, including observable-tree merging, environment contractions, and result storage.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 26.652 seconds | 19.014 seconds | 19.861 seconds |
| 255 | 53.539 seconds | 37.15 seconds | 39.456 seconds |
| 511 | 66.736 seconds | 45.846 seconds | 48.15 seconds |

## Supporting whole-chain operations


### No symmetry


#### Left and right canonicalization of base tensors · ordinary MPS


Construct the base tensor&#39;s canonical forms through left and right orthogonal factorizations and contractions, including the associated copying and memory allocation.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 8.8177 milliseconds | 8.0259 milliseconds | 7.9411 milliseconds |
| 128 | 29 milliseconds | 28.936 milliseconds | 25.58 milliseconds |
| 256 | 55.744 milliseconds | 55.918 milliseconds | 50.701 milliseconds |

#### Left orthogonal projection of a tangent vector · ordinary MPS, tangent center with no extra leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.5996 milliseconds | 1.0552 milliseconds | 1.073 milliseconds |
| 128 | 5.3005 milliseconds | 2.9134 milliseconds | 3.5613 milliseconds |
| 256 | 11.687 milliseconds | 6.7506 milliseconds | 9.4891 milliseconds |

#### Left orthogonal projection of a tangent vector · MPO with a purification leg, tangent center with no extra leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.2466 milliseconds | 2.9454 milliseconds | 2.7075 milliseconds |
| 128 | 28.977 milliseconds | 15.118 milliseconds | 14.817 milliseconds |
| 256 | 202.56 milliseconds | 103.9 milliseconds | 100.66 milliseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 38.623 microseconds | 233.58 microseconds | 88.136 microseconds |
| 128 | 100.97 microseconds | 130.54 microseconds | 245.3 microseconds |
| 256 | 148.6 microseconds | 217.01 microseconds | 313.65 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra component leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 268.34 microseconds | 304.21 microseconds | 479.23 microseconds |
| 128 | 1.0567 milliseconds | 885.96 microseconds | 728.6 microseconds |
| 256 | 4.2963 milliseconds | 3.4403 milliseconds | 3.4335 milliseconds |

### U(1) symmetry


#### Left orthogonal projection of a tangent vector · ordinary MPS, tangent center with an extra charge leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 540.32 microseconds | 495.37 microseconds | 543.89 microseconds |
| 128 | 846.81 microseconds | 699.58 microseconds | 620.27 microseconds |
| 256 | 1.1011 milliseconds | 861.07 microseconds | 786.16 microseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 7.894 microseconds | 63.479 microseconds | 71.815 microseconds |
| 128 | 23.515 microseconds | 96.512 microseconds | 226.46 microseconds |
| 256 | 34.215 microseconds | 83.147 microseconds | 157.94 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 24.025 microseconds | 68.108 microseconds | 93.225 microseconds |
| 128 | 79.299 microseconds | 280.52 microseconds | 268.11 microseconds |
| 256 | 297.2 microseconds | 476.36 microseconds | 296.89 microseconds |

### SU(2) symmetry


#### Full-chain environment construction · Heisenberg spin model · MPO with a purification leg


Build left and right environments over the full chain from an MPO base and the Heisenberg operator, including contraction and allocation; environment cleanup is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 20.375 milliseconds | 13.449 milliseconds | 12.72 milliseconds |
| 128 | 30.115 milliseconds | 19.709 milliseconds | 16.638 milliseconds |
| 256 | 56.395 milliseconds | 32.925 milliseconds | 22.525 milliseconds |

#### Left and right canonicalization of base tensors · MPO with a purification leg


Construct the base tensor&#39;s canonical forms through left and right orthogonal factorizations and contractions, including the associated copying and memory allocation.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 2.763 milliseconds | 2.7062 milliseconds | 2.7692 milliseconds |
| 128 | 4.6205 milliseconds | 4.5886 milliseconds | 4.3788 milliseconds |
| 256 | 8.7977 milliseconds | 8.571 milliseconds | 8.2917 milliseconds |

#### Left orthogonal projection of a tangent vector · MPO with a purification leg, tangent center with an extra charge leg


Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.8293 milliseconds | 1.2169 milliseconds | 945.94 microseconds |
| 128 | 3.413 milliseconds | 2.0754 milliseconds | 1.3783 milliseconds |
| 256 | 6.7172 milliseconds | 3.8546 milliseconds | 2.0083 milliseconds |

#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 30.467 microseconds | 257.57 microseconds | 116.47 microseconds |
| 128 | 56.687 microseconds | 242.99 microseconds | 603.47 microseconds |
| 256 | 71.535 microseconds | 134.1 microseconds | 114.52 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 72.347 microseconds | 123.23 microseconds | 365.48 microseconds |
| 128 | 120.41 microseconds | 121.25 microseconds | 166.41 microseconds |
| 256 | 158.95 microseconds | 349.35 microseconds | 219.93 microseconds |

### U(1) × SU(2) symmetry


#### Whole-chain inner product of two tangent vectors · ordinary MPS, no extra center legs


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 228.83 microseconds | 316.3 microseconds | 434.35 microseconds |
| 255 | 295.07 microseconds | 372.41 microseconds | 535.89 microseconds |
| 511 | 434.62 microseconds | 669.23 microseconds | 669.68 microseconds |

#### Whole-chain inner product of two tangent vectors · MPO with a purification leg, bra and ket each have an extra charge leg


Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 552.69 microseconds | 621.92 microseconds | 967.19 microseconds |
| 255 | 989.57 microseconds | 907.66 microseconds | 1.4578 milliseconds |
| 511 | 1.4745 milliseconds | 1.7986 milliseconds | 1.8262 milliseconds |

## Internal calculation stages


### No symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.7919 milliseconds | 1.5856 milliseconds | 1.6615 milliseconds |
| 128 | 17.144 milliseconds | 10.587 milliseconds | 9.5161 milliseconds |
| 256 | 44.46 milliseconds | 25.326 milliseconds | 23.936 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.7631 milliseconds | 1.5612 milliseconds | 1.5377 milliseconds |
| 128 | 17.009 milliseconds | 9.6428 milliseconds | 9.484 milliseconds |
| 256 | 53.712 milliseconds | 30.566 milliseconds | 29.668 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.5496 milliseconds | 3.2425 milliseconds | 3.12 milliseconds |
| 128 | 35.525 milliseconds | 28.671 milliseconds | 19.316 milliseconds |
| 256 | 92.159 milliseconds | 52.558 milliseconds | 49.312 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.4577 milliseconds | 3.1972 milliseconds | 2.9446 milliseconds |
| 128 | 34.37 milliseconds | 19.796 milliseconds | 18.923 milliseconds |
| 256 | 109.51 milliseconds | 66.974 milliseconds | 59.582 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.1827 milliseconds | 4.8251 milliseconds | 2.9702 milliseconds |
| 128 | 34.201 milliseconds | 19.304 milliseconds | 18.219 milliseconds |
| 256 | 262.06 milliseconds | 150.68 milliseconds | 135.03 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 5.072 milliseconds | 2.8695 milliseconds | 2.8568 milliseconds |
| 128 | 39.543 milliseconds | 21.899 milliseconds | 18.637 milliseconds |
| 256 | 263.09 milliseconds | 149.01 milliseconds | 134.38 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 10.267 milliseconds | 5.8242 milliseconds | 5.5427 milliseconds |
| 128 | 70.107 milliseconds | 40.593 milliseconds | 38.788 milliseconds |
| 256 | 538.91 milliseconds | 376.1 milliseconds | 374.11 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 9.9934 milliseconds | 5.6929 milliseconds | 5.3626 milliseconds |
| 128 | 70.921 milliseconds | 39.536 milliseconds | 37.208 milliseconds |
| 256 | 519.89 milliseconds | 297.15 milliseconds | 302.16 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.962 milliseconds | 1.1351 milliseconds | 1.2595 milliseconds |
| 128 | 11.706 milliseconds | 8.6916 milliseconds | 6.6894 milliseconds |
| 256 | 33.275 milliseconds | 18.819 milliseconds | 18.836 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.7239 milliseconds | 2.1651 milliseconds | 2.0798 milliseconds |
| 128 | 23.388 milliseconds | 13.433 milliseconds | 13.145 milliseconds |
| 256 | 67.374 milliseconds | 39.075 milliseconds | 37.299 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.7053 milliseconds | 2.0918 milliseconds | 2.1273 milliseconds |
| 128 | 28.348 milliseconds | 13.487 milliseconds | 13.501 milliseconds |
| 256 | 175.38 milliseconds | 99.382 milliseconds | 99.259 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 7.036 milliseconds | 4.0002 milliseconds | 4.1823 milliseconds |
| 128 | 57.014 milliseconds | 37.252 milliseconds | 26.594 milliseconds |
| 256 | 356.71 milliseconds | 206.46 milliseconds | 199.11 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · transverse-field Ising model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.9315 milliseconds | 1.1302 milliseconds | 1.1015 milliseconds |
| 128 | 11.664 milliseconds | 6.6444 milliseconds | 6.6066 milliseconds |
| 256 | 33.007 milliseconds | 18.824 milliseconds | 19.053 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · transverse-field Ising model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.1169 milliseconds | 1.2938 milliseconds | 1.1413 milliseconds |
| 128 | 12.647 milliseconds | 7.0344 milliseconds | 6.739 milliseconds |
| 256 | 35.356 milliseconds | 20.37 milliseconds | 18.607 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · transverse-field Ising model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.5408 milliseconds | 2.1132 milliseconds | 2.0093 milliseconds |
| 128 | 22.937 milliseconds | 13.068 milliseconds | 12.452 milliseconds |
| 256 | 175.43 milliseconds | 99.6 milliseconds | 93.772 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · transverse-field Ising model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 4.0914 milliseconds | 2.4443 milliseconds | 2.1742 milliseconds |
| 128 | 25.479 milliseconds | 15.202 milliseconds | 13.659 milliseconds |
| 256 | 186.28 milliseconds | 107.87 milliseconds | 96.086 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 499.92 microseconds | 380.76 microseconds | 498.79 microseconds |
| 128 | 3.1655 milliseconds | 1.6614 milliseconds | 1.9386 milliseconds |
| 256 | 12.061 milliseconds | 6.3224 milliseconds | 6.4667 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 548.31 microseconds | 562.13 microseconds | 442.67 microseconds |
| 128 | 3.201 milliseconds | 3.2968 milliseconds | 1.9355 milliseconds |
| 256 | 6.3761 milliseconds | 3.5193 milliseconds | 3.6246 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 916.45 microseconds | 590.73 microseconds | 745.71 microseconds |
| 128 | 6.2888 milliseconds | 3.4742 milliseconds | 3.6661 milliseconds |
| 256 | 23.999 milliseconds | 12.313 milliseconds | 12.637 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · ordinary MPS, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 931.99 microseconds | 529.96 microseconds | 783.25 microseconds |
| 128 | 6.4021 milliseconds | 6.3402 milliseconds | 3.635 milliseconds |
| 256 | 12.889 milliseconds | 6.9406 milliseconds | 7.1176 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 901.81 microseconds | 913.02 microseconds | 575.73 microseconds |
| 128 | 6.3404 milliseconds | 7.5189 milliseconds | 3.6268 milliseconds |
| 256 | 47.885 milliseconds | 24.433 milliseconds | 24.605 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 924.17 microseconds | 531.4 microseconds | 588.36 microseconds |
| 128 | 6.3608 milliseconds | 3.4667 milliseconds | 3.7562 milliseconds |
| 256 | 48.039 milliseconds | 24.901 milliseconds | 24.635 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.748 milliseconds | 969.1 microseconds | 1.224 milliseconds |
| 128 | 12.701 milliseconds | 7.2969 milliseconds | 6.7374 milliseconds |
| 256 | 95.245 milliseconds | 48.913 milliseconds | 48.803 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · transverse-field Ising model · MPO with a purification leg, tangent center with an extra component leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.8171 milliseconds | 987.88 microseconds | 1.1803 milliseconds |
| 128 | 12.899 milliseconds | 6.9121 milliseconds | 7.0237 milliseconds |
| 256 | 103.53 milliseconds | 50.842 milliseconds | 50.889 milliseconds |

</details>


### U(1) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.6609 milliseconds | 1.5668 milliseconds | 979.15 microseconds |
| 128 | 4.2592 milliseconds | 2.3761 milliseconds | 2.3783 milliseconds |
| 256 | 7.4881 milliseconds | 4.3041 milliseconds | 3.6875 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.7492 milliseconds | 1.0584 milliseconds | 1.1985 milliseconds |
| 128 | 4.5486 milliseconds | 2.6526 milliseconds | 2.2796 milliseconds |
| 256 | 8.7157 milliseconds | 7.0482 milliseconds | 4.2224 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.0922 milliseconds | 1.973 milliseconds | 1.1904 milliseconds |
| 128 | 4.9685 milliseconds | 2.9045 milliseconds | 2.4531 milliseconds |
| 256 | 8.0828 milliseconds | 4.7582 milliseconds | 4.0574 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.1481 milliseconds | 1.2695 milliseconds | 1.2154 milliseconds |
| 128 | 5.3266 milliseconds | 2.7784 milliseconds | 2.754 milliseconds |
| 256 | 9.1655 milliseconds | 5.018 milliseconds | 4.4577 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.958 milliseconds | 2.6643 milliseconds | 1.7264 milliseconds |
| 128 | 8.6152 milliseconds | 5.0025 milliseconds | 3.9492 milliseconds |
| 256 | 34.125 milliseconds | 16.888 milliseconds | 15.623 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.9478 milliseconds | 2.6255 milliseconds | 1.5452 milliseconds |
| 128 | 8.312 milliseconds | 5.0103 milliseconds | 4.0384 milliseconds |
| 256 | 34.417 milliseconds | 20.955 milliseconds | 15.355 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.461 milliseconds | 3.1337 milliseconds | 1.9985 milliseconds |
| 128 | 8.9147 milliseconds | 5.4232 milliseconds | 4.1048 milliseconds |
| 256 | 34.428 milliseconds | 17.048 milliseconds | 14.45 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 3.4968 milliseconds | 2.0371 milliseconds | 1.9762 milliseconds |
| 128 | 8.6353 milliseconds | 5.0795 milliseconds | 4.2477 milliseconds |
| 256 | 34.938 milliseconds | 16.991 milliseconds | 14.08 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.2647 milliseconds | 783.11 microseconds | 885.46 microseconds |
| 128 | 3.1443 milliseconds | 1.7654 milliseconds | 1.7427 milliseconds |
| 256 | 6.154 milliseconds | 3.3415 milliseconds | 2.8901 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.3954 milliseconds | 881.63 microseconds | 815.14 microseconds |
| 128 | 3.2361 milliseconds | 2.915 milliseconds | 2.2492 milliseconds |
| 256 | 5.9717 milliseconds | 3.2764 milliseconds | 2.8898 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.2414 milliseconds | 1.9827 milliseconds | 1.2761 milliseconds |
| 128 | 6.0231 milliseconds | 3.7712 milliseconds | 4.0593 milliseconds |
| 256 | 22.289 milliseconds | 11.626 milliseconds | 10.31 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.1557 milliseconds | 1.3123 milliseconds | 1.2632 milliseconds |
| 128 | 5.7371 milliseconds | 9.5111 milliseconds | 9.4632 milliseconds |
| 256 | 20.572 milliseconds | 10.451 milliseconds | 9.4784 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · anisotropic Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.2572 milliseconds | 1.1784 milliseconds | 701.9 microseconds |
| 128 | 3.2341 milliseconds | 2.5619 milliseconds | 1.5822 milliseconds |
| 256 | 5.7504 milliseconds | 4.782 milliseconds | 2.8024 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · anisotropic Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 1.3318 milliseconds | 1.2162 milliseconds | 778.53 microseconds |
| 128 | 3.6251 milliseconds | 1.9285 milliseconds | 1.5908 milliseconds |
| 256 | 6.3129 milliseconds | 3.3281 milliseconds | 2.8598 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · anisotropic Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.0814 milliseconds | 1.9121 milliseconds | 1.1048 milliseconds |
| 128 | 5.9103 milliseconds | 4.9204 milliseconds | 2.9475 milliseconds |
| 256 | 20.844 milliseconds | 10.812 milliseconds | 9.7396 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · anisotropic Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 2.1297 milliseconds | 1.2067 milliseconds | 1.1155 milliseconds |
| 128 | 5.9113 milliseconds | 3.4499 milliseconds | 2.7603 milliseconds |
| 256 | 22.163 milliseconds | 11.212 milliseconds | 10.18 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 246.65 microseconds | 189.87 microseconds | 171.41 microseconds |
| 128 | 795.07 microseconds | 488.51 microseconds | 562.77 microseconds |
| 256 | 1.8016 milliseconds | 1.666 milliseconds | 943.73 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 188.19 microseconds | 213.43 microseconds | 169.33 microseconds |
| 128 | 653.52 microseconds | 626.14 microseconds | 402.1 microseconds |
| 256 | 965.67 microseconds | 568.94 microseconds | 670.16 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 238.64 microseconds | 176.24 microseconds | 202.26 microseconds |
| 128 | 720.07 microseconds | 435.85 microseconds | 562.25 microseconds |
| 256 | 1.569 milliseconds | 965.33 microseconds | 883.73 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 244.14 microseconds | 218.05 microseconds | 249.61 microseconds |
| 128 | 751.5 microseconds | 604.69 microseconds | 552.25 microseconds |
| 256 | 1.1562 milliseconds | 703.1 microseconds | 811.22 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 391.84 microseconds | 408.64 microseconds | 230.86 microseconds |
| 128 | 1.3057 milliseconds | 759.39 microseconds | 853.06 microseconds |
| 256 | 5.7062 milliseconds | 3.2421 milliseconds | 2.9352 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 414.72 microseconds | 392.81 microseconds | 257.46 microseconds |
| 128 | 1.4159 milliseconds | 772.37 microseconds | 734.47 microseconds |
| 256 | 5.6269 milliseconds | 3.2847 milliseconds | 3.1001 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 385.88 microseconds | 404.45 microseconds | 256.47 microseconds |
| 128 | 1.1918 milliseconds | 1.146 milliseconds | 757.53 microseconds |
| 256 | 5.3094 milliseconds | 2.8944 milliseconds | 2.7515 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · anisotropic Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 64 | 404.65 microseconds | 406.34 microseconds | 238.79 microseconds |
| 128 | 1.2075 milliseconds | 873.41 microseconds | 669.37 microseconds |
| 256 | 5.1841 milliseconds | 2.6722 milliseconds | 2.7827 milliseconds |

</details>


### SU(2) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 510.07 microseconds | 332.53 microseconds | 374.3 microseconds |
| 128 | 714.13 microseconds | 517.65 microseconds | 704.65 microseconds |
| 256 | 968.34 microseconds | 649.85 microseconds | 719.09 microseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 507.12 microseconds | 347.76 microseconds | 493.99 microseconds |
| 128 | 803.93 microseconds | 576.07 microseconds | 717.39 microseconds |
| 256 | 1.0662 milliseconds | 705.81 microseconds | 673.84 microseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.1395 milliseconds | 829.52 microseconds | 889.59 microseconds |
| 128 | 2.0963 milliseconds | 1.4895 milliseconds | 1.7009 milliseconds |
| 256 | 2.8836 milliseconds | 1.9948 milliseconds | 1.8447 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.1491 milliseconds | 935.53 microseconds | 890.87 microseconds |
| 128 | 2.1297 milliseconds | 1.4339 milliseconds | 1.4363 milliseconds |
| 256 | 3.1989 milliseconds | 2.0233 milliseconds | 2.1078 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 830.5 microseconds | 595.84 microseconds | 691.94 microseconds |
| 128 | 1.4438 milliseconds | 1.3463 milliseconds | 1.072 milliseconds |
| 256 | 2.5706 milliseconds | 1.6792 milliseconds | 1.6682 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 851.86 microseconds | 908.84 microseconds | 648.69 microseconds |
| 128 | 1.4571 milliseconds | 958.96 microseconds | 1.0826 milliseconds |
| 256 | 2.698 milliseconds | 1.7519 milliseconds | 1.6394 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 2.0084 milliseconds | 1.3191 milliseconds | 1.2987 milliseconds |
| 128 | 3.617 milliseconds | 2.5685 milliseconds | 2.3623 milliseconds |
| 256 | 7.5477 milliseconds | 5.4747 milliseconds | 4.9267 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 2.0573 milliseconds | 1.3749 milliseconds | 1.3017 milliseconds |
| 128 | 3.8758 milliseconds | 2.768 milliseconds | 2.2617 milliseconds |
| 256 | 8.376 milliseconds | 5.7948 milliseconds | 4.8137 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 345.18 microseconds | 288.26 microseconds | 280.64 microseconds |
| 128 | 553.88 microseconds | 377.64 microseconds | 416.82 microseconds |
| 256 | 680.19 microseconds | 725.22 microseconds | 631.59 microseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 692.77 microseconds | 666.66 microseconds | 547.82 microseconds |
| 128 | 1.2728 milliseconds | 1.2197 milliseconds | 799.97 microseconds |
| 256 | 1.7164 milliseconds | 1.199 milliseconds | 1.2044 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 585.18 microseconds | 430.52 microseconds | 656 microseconds |
| 128 | 1.0205 milliseconds | 666.47 microseconds | 790.97 microseconds |
| 256 | 1.768 milliseconds | 1.3074 milliseconds | 1.2038 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 1.1364 milliseconds | 768 microseconds | 993.35 microseconds |
| 128 | 2.2045 milliseconds | 1.4378 milliseconds | 1.3653 milliseconds |
| 256 | 4.724 milliseconds | 3.1909 milliseconds | 2.8891 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 343.46 microseconds | 408.78 microseconds | 320.78 microseconds |
| 128 | 566.43 microseconds | 433.43 microseconds | 607.73 microseconds |
| 256 | 773.55 microseconds | 502.28 microseconds | 584.77 microseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Heisenberg spin model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 378.88 microseconds | 373.65 microseconds | 247.74 microseconds |
| 128 | 565.41 microseconds | 606.83 microseconds | 348.46 microseconds |
| 256 | 790.6 microseconds | 442.6 microseconds | 449.68 microseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 654.2 microseconds | 391.83 microseconds | 563.19 microseconds |
| 128 | 972.43 microseconds | 794.71 microseconds | 795.02 microseconds |
| 256 | 1.8495 milliseconds | 1.195 milliseconds | 1.1591 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Heisenberg spin model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 604.35 microseconds | 396.38 microseconds | 613 microseconds |
| 128 | 993.72 microseconds | 901.17 microseconds | 973.07 microseconds |
| 256 | 1.8294 milliseconds | 1.1516 milliseconds | 1.059 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 77.646 microseconds | 111.72 microseconds | 85.169 microseconds |
| 128 | 116.36 microseconds | 318.65 microseconds | 134.87 microseconds |
| 256 | 176.53 microseconds | 140.5 microseconds | 135.11 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 43.351 microseconds | 88.346 microseconds | 67.437 microseconds |
| 128 | 88.677 microseconds | 120.1 microseconds | 84.419 microseconds |
| 256 | 120.5 microseconds | 109.54 microseconds | 281.09 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 107.64 microseconds | 151.44 microseconds | 111.08 microseconds |
| 128 | 212.63 microseconds | 142.75 microseconds | 150.98 microseconds |
| 256 | 356.57 microseconds | 222.65 microseconds | 441.29 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 106.86 microseconds | 143.22 microseconds | 101.56 microseconds |
| 128 | 208.67 microseconds | 169.48 microseconds | 317.12 microseconds |
| 256 | 300.87 microseconds | 386.31 microseconds | 303.85 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 100.32 microseconds | 116.48 microseconds | 114.07 microseconds |
| 128 | 175.14 microseconds | 194.81 microseconds | 149.54 microseconds |
| 256 | 380.98 microseconds | 239.58 microseconds | 257.44 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 104.33 microseconds | 91.743 microseconds | 93.646 microseconds |
| 128 | 178.11 microseconds | 174.55 microseconds | 130.14 microseconds |
| 256 | 362.99 microseconds | 356.03 microseconds | 262.17 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 179.83 microseconds | 142.81 microseconds | 159.25 microseconds |
| 128 | 380.62 microseconds | 235.55 microseconds | 373.68 microseconds |
| 256 | 896.89 microseconds | 544.36 microseconds | 552.88 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Heisenberg spin model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 60 | 171.11 microseconds | 204.84 microseconds | 280.22 microseconds |
| 128 | 358.06 microseconds | 385.66 microseconds | 260.51 microseconds |
| 256 | 873.77 microseconds | 633.23 microseconds | 664.28 microseconds |

</details>


### U(1) × SU(2) symmetry


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.2261 milliseconds | 1.304 milliseconds | 1.2758 milliseconds |
| 255 | 3.716 milliseconds | 3.1957 milliseconds | 1.8601 milliseconds |
| 511 | 9.1094 milliseconds | 5.4386 milliseconds | 4.3349 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 2.4521 milliseconds | 1.437 milliseconds | 1.4545 milliseconds |
| 255 | 3.9834 milliseconds | 2.2678 milliseconds | 2.1643 milliseconds |
| 511 | 9.9803 milliseconds | 8.2888 milliseconds | 4.6872 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 4.7364 milliseconds | 2.5366 milliseconds | 2.5873 milliseconds |
| 255 | 8.079 milliseconds | 4.2877 milliseconds | 4.1475 milliseconds |
| 511 | 19.435 milliseconds | 10.097 milliseconds | 42.643 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 4.8622 milliseconds | 2.9863 milliseconds | 2.8418 milliseconds |
| 255 | 8.0412 milliseconds | 4.4946 milliseconds | 4.3789 milliseconds |
| 511 | 19.8 milliseconds | 11.215 milliseconds | 10.064 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 7.6191 milliseconds | 4.1699 milliseconds | 3.856 milliseconds |
| 255 | 13.967 milliseconds | 7.7215 milliseconds | 6.7219 milliseconds |
| 511 | 55.126 milliseconds | 19.461 milliseconds | 43.182 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 7.6745 milliseconds | 4.3618 milliseconds | 3.9931 milliseconds |
| 255 | 14.256 milliseconds | 7.7768 milliseconds | 31.24 milliseconds |
| 511 | 51.343 milliseconds | 47.544 milliseconds | 15.773 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site leftward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 18.178 milliseconds | 9.6256 milliseconds | 8.6771 milliseconds |
| 255 | 50.415 milliseconds | 42.378 milliseconds | 14.741 milliseconds |
| 511 | 91.051 milliseconds | 85.465 milliseconds | 35.84 milliseconds |

</details>


<details><summary>Recursive tangent environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Propagate the complete recursive tangent environment vector one site rightward, combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 17.995 milliseconds | 10.762 milliseconds | 9.5754 milliseconds |
| 255 | 33.748 milliseconds | 18.553 milliseconds | 14.83 milliseconds |
| 511 | 93.893 milliseconds | 67.315 milliseconds | 50.546 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.5471 milliseconds | 1.5177 milliseconds | 1.0294 milliseconds |
| 255 | 2.692 milliseconds | 1.5539 milliseconds | 1.4129 milliseconds |
| 511 | 6.4599 milliseconds | 3.8773 milliseconds | 3.5922 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 3.1118 milliseconds | 1.8701 milliseconds | 1.7266 milliseconds |
| 255 | 5.1431 milliseconds | 3.0693 milliseconds | 2.5799 milliseconds |
| 511 | 12.497 milliseconds | 7.1182 milliseconds | 6.1061 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 5.5179 milliseconds | 2.9352 milliseconds | 2.658 milliseconds |
| 255 | 9.7956 milliseconds | 5.1821 milliseconds | 4.4876 milliseconds |
| 511 | 42.291 milliseconds | 43.854 milliseconds | 11.411 milliseconds |

</details>


<details><summary>Complete effective single-site operator action · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 11.187 milliseconds | 5.5629 milliseconds | 4.9467 milliseconds |
| 255 | 19.532 milliseconds | 10.462 milliseconds | 72.825 milliseconds |
| 511 | 62.511 milliseconds | 45.653 milliseconds | 37.382 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Hubbard fermion model · ordinary MPS</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.6354 milliseconds | 1.5446 milliseconds | 1.0204 milliseconds |
| 255 | 2.7347 milliseconds | 2.4626 milliseconds | 1.5998 milliseconds |
| 511 | 6.3047 milliseconds | 3.932 milliseconds | 3.3807 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Hubbard fermion model · ordinary MPS</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.728 milliseconds | 1.0554 milliseconds | 1.0577 milliseconds |
| 255 | 2.9624 milliseconds | 1.6116 milliseconds | 1.6104 milliseconds |
| 511 | 7.2911 milliseconds | 3.9127 milliseconds | 3.3202 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · leftward · Hubbard fermion model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site leftward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 5.6994 milliseconds | 3.0689 milliseconds | 2.6352 milliseconds |
| 255 | 9.7839 milliseconds | 5.4896 milliseconds | 4.5515 milliseconds |
| 511 | 24.04 milliseconds | 13.023 milliseconds | 10.442 milliseconds |

</details>


<details><summary>Complete sparse environment-vector propagation · rightward · Hubbard fermion model · MPO with a purification leg</summary>


Advance the complete sparse environment vector one site rightward using the base tensor and the model&#39;s sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 5.8818 milliseconds | 4.7488 milliseconds | 2.6121 milliseconds |
| 255 | 10.078 milliseconds | 5.4168 milliseconds | 4.9059 milliseconds |
| 511 | 24.652 milliseconds | 13.154 milliseconds | 10.624 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 274.42 microseconds | 287.99 microseconds | 200.04 microseconds |
| 255 | 529.27 microseconds | 317.8 microseconds | 392.9 microseconds |
| 511 | 1.4876 milliseconds | 1.3798 milliseconds | 876.41 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · ordinary MPS, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 190.73 microseconds | 131.79 microseconds | 131.34 microseconds |
| 255 | 333.14 microseconds | 349.46 microseconds | 343.16 microseconds |
| 511 | 1.1047 milliseconds | 601.95 microseconds | 767.54 microseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 389.18 microseconds | 371.89 microseconds | 306.9 microseconds |
| 255 | 747.6 microseconds | 491.87 microseconds | 481.12 microseconds |
| 511 | 2.3023 milliseconds | 1.2869 milliseconds | 1.3607 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · ordinary MPS, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 390.94 microseconds | 263.5 microseconds | 298.74 microseconds |
| 255 | 798 microseconds | 610.35 microseconds | 736 microseconds |
| 511 | 2.3651 milliseconds | 2.0525 milliseconds | 1.4887 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 731.09 microseconds | 469.39 microseconds | 471.55 microseconds |
| 255 | 1.3801 milliseconds | 984.87 microseconds | 1.0434 milliseconds |
| 511 | 4.5148 milliseconds | 2.42 milliseconds | 2.4406 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with no extra leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 756.42 microseconds | 492.48 microseconds | 559.9 microseconds |
| 255 | 1.3771 milliseconds | 862.09 microseconds | 867.8 microseconds |
| 511 | 4.2413 milliseconds | 2.3229 milliseconds | 2.3829 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · leftward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.3845 milliseconds | 955.28 microseconds | 938.82 microseconds |
| 255 | 2.5041 milliseconds | 1.3891 milliseconds | 1.5226 milliseconds |
| 511 | 7.6959 milliseconds | 4.1884 milliseconds | 3.7654 milliseconds |

</details>


<details><summary>Contraction and reduction of recursive environments into a tangent center · rightward · Hubbard fermion model · MPO with a purification leg, tangent center with an extra charge leg</summary>


Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region.

| Center bond dimension | 1 thread | 2 threads | 4 threads |
| ---: | ---: | ---: | ---: |
| 126 | 1.4151 milliseconds | 820.49 microseconds | 1.0483 milliseconds |
| 255 | 2.5709 milliseconds | 2.3254 milliseconds | 1.4848 milliseconds |
| 511 | 7.423 milliseconds | 4.1259 milliseconds | 4.3253 milliseconds |

</details>

