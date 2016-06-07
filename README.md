# PollyBenchmarks

The goal that I have in mind for this package is to provide a collection of benchmarks that evaluate the profitability of my Google Summer of Code project [Enabling Polyhedral Optimizations in Julia](https://docs.google.com/document/d/1s5mmSW965qmOEbHiM3O4XFz-Vd7cy9TxX9RQaTK_SQo/edit?usp=sharing). At the moment, however, it is a (more or less unstructured) "playground" were I gather code snippets that might be useful for experimental purposes.

## Benchmark Overview

| Benchmark         | Description                                            |
| ----------------- | ------------------------------------------------------ |
| `gemm`            | General matrix multiplication                          |
| `sqmm`            | Matrix multiplication restricted to square matrices    |
| `row_sum`         | Sum of rows in a matrix                                |
| `sum3d`           | Sum of elements in a 3d array                          |
| `sum3d_cube`      | Sum of elements in a 3d cubic array                    |
| `sum2d`           | Sum of elements in a matrix                            |
| `sum2d_squre`     | Sum of elements in a square matrix                     |
| `copy3d`          | Copying a 3d array                                     |
| `copy3d_cube`     | Copying a 3d cubic array                               |
| `copy2d`          | Copying a matrix                                       |
| `copy2d_square`   | Copying a square matrix                                |
