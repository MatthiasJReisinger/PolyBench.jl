include("MicroBenchmarks.jl")
include("PolyBench.jl")

module PollyBenchmarks

using BenchmarkTools
using MicroBenchmarks
using PolyBench

const SUITE = BenchmarkGroup()
const MICRO_GROUP = addgroup!(SUITE, "micro")
const POLY_GROUP = addgroup!(SUITE, "poly")

const TYPE = Float32 # TODO make configurable
const DIMENSION = 1024 # TODO make configurable
get_zero_1d() = zeros(TYPE,DIMENSION)
get_zero_2d() = zeros(TYPE,DIMENSION,DIMENSION)
get_zero_3d() = zeros(TYPE,DIMENSION,DIMENSION,DIMENSION)

# PolyBench datamining

POLY_GROUP["correlation"] = @benchmarkable PolyBench.kernel_correlation(1.0,$(get_zero_2d()),$(get_zero_2d()),$(get_zero_1d()),$(get_zero_1d()))
POLY_GROUP["covariance"] = @benchmarkable PolyBench.kernel_covariance(1.0,$(get_zero_2d()),$(get_zero_2d()),$(get_zero_1d()))

# PolyBench linear-algebra/kernels

POLY_GROUP["2mm"] = @benchmarkable PolyBench.kernel_2mm(1.0,1.0,$(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()))
POLY_GROUP["3mm"] = @benchmarkable PolyBench.kernel_3mm($(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()))
POLY_GROUP["atax"] = @benchmarkable PolyBench.kernel_atax($(get_zero_2d()),$(get_zero_1d()),$(get_zero_1d()),$(get_zero_1d()))
POLY_GROUP["bicg"] = @benchmarkable PolyBench.kernel_bicg($(get_zero_2d()),$(get_zero_1d()),$(get_zero_1d()),$(get_zero_1d()),$(get_zero_1d()))
POLY_GROUP["doitgen"] = @benchmarkable PolyBench.kernel_doitgen($(get_zero_3d()),$(get_zero_2d()),$(get_zero_1d()))
POLY_GROUP["mvt"] = @benchmarkable PolyBench.kernel_mvt($(get_zero_1d()),$(get_zero_1d()),$(get_zero_1d()),$(get_zero_1d()),$(get_zero_2d()))

# PolyBench linear-algebra/blas

POLY_GROUP["gemm"] = @benchmarkable PolyBench.kernel_gemm(1,1,$(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()))
POLY_GROUP["gemver"] = @benchmarkable PolyBench.kernel_gemver(1,1,$(get_zero_2d()),$(get_zero_1d()),$(get_zero_1d()),$(get_zero_1d()),$(get_zero_1d()),$(get_zero_1d()),$(get_zero_1d()),$(get_zero_1d()),$(get_zero_1d()))
POLY_GROUP["gesummv"] = @benchmarkable PolyBench.kernel_gesummv(1,1,$(get_zero_2d()),$(get_zero_2d()),$(get_zero_1d()),$(get_zero_1d()),$(get_zero_1d()))
POLY_GROUP["symm"] = @benchmarkable PolyBench.kernel_symm(1,1,$(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()))
POLY_GROUP["syr2k"] = @benchmarkable PolyBench.kernel_syr2k(1,1,$(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()))
POLY_GROUP["syrk"] = @benchmarkable PolyBench.kernel_syrk(1,1,$(get_zero_2d()),$(get_zero_2d()))
POLY_GROUP["trmm"] = @benchmarkable PolyBench.kernel_trmm(1,$(get_zero_2d()),$(get_zero_2d()))

# PolyBench linear-algebra/solvers

POLY_GROUP["cholesky"] = @benchmarkable PolyBench.kernel_cholesky($(get_zero_2d()))
POLY_GROUP["durbin"] = @benchmarkable PolyBench.kernel_durbin($(get_zero_1d()),$(get_zero_1d()))
POLY_GROUP["gramschmidt"] = @benchmarkable PolyBench.kernel_gramschmidt($(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()))
POLY_GROUP["lu"] = @benchmarkable PolyBench.kernel_lu($(get_zero_2d()))
POLY_GROUP["ludcmp"] = @benchmarkable PolyBench.kernel_ludcmp($(get_zero_2d()),$(get_zero_1d()),$(get_zero_1d()),$(get_zero_1d()))
POLY_GROUP["trisolv"] = @benchmarkable PolyBench.kernel_trisolv($(get_zero_2d()),$(get_zero_1d()),$(get_zero_1d()))

# PolyBench medley

POLY_GROUP["deriche"] = @benchmarkable PolyBench.kernel_deriche(1.0,$(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()))
POLY_GROUP["floyd_warshall"] = @benchmarkable PolyBench.kernel_floyd_warshall($(get_zero_2d()))
POLY_GROUP["nussinov"] = @benchmarkable PolyBench.kernel_nussinov($(get_zero_1d()),$(get_zero_2d()))

# PolyBench stencils

POLY_GROUP["adi"] = @benchmarkable PolyBench.kernel_adi(100,$(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()))
POLY_GROUP["fdtd_2d"] = @benchmarkable PolyBench.kernel_fdtd_2d($(get_zero_2d()),$(get_zero_2d()),$(get_zero_2d()),$(get_zero_1d()))
POLY_GROUP["head_3d"] = @benchmarkable PolyBench.kernel_head_3d(1,$(get_zero_3d()),$(get_zero_3d()))
POLY_GROUP["jacobi_1d"] = @benchmarkable PolyBench.kernel_jacobi_1d(100,$(get_zero_1d()),$(get_zero_1d()))
POLY_GROUP["jacobi_2d"] = @benchmarkable PolyBench.kernel_jacobi_2d(100,$(get_zero_2d()),$(get_zero_2d()))
POLY_GROUP["seidel_2d"] = @benchmarkable PolyBench.kernel_seidel_2d(100,$(get_zero_2d()))

end # module
