module PollyBenchmarks

include("MicroBenchmarks.jl")
include("PolyBench.jl")

# Prints the time needed to execute `ex` in microseconds.
macro benchmark(ex, evals)
    quote
        $(esc(ex)) # force compilation
        total_time = 0
        for i = 1:$evals
            start_time = time_ns()
            $(esc(ex))
            end_time = time_ns()
            total_time += (end_time - start_time)
        end
        println(round(Int, total_time / 10^3 / $evals))
    end
end

function run()

    # Input data for the benchmarks

    big_dim = 1024
    small_dim = 256

    big1d1 = zeros(Float32,big_dim)
    big1d2 = zeros(Float32,big_dim)
    big1d3 = zeros(Float32,big_dim)
    big1d4 = zeros(Float32,big_dim)
    big1d5 = zeros(Float32,big_dim)
    big1d6 = zeros(Float32,big_dim)
    big1d7 = zeros(Float32,big_dim)
    big1d8 = zeros(Float32,big_dim)
    big2d1 = zeros(Float32,big_dim,big_dim)
    big2d2 = zeros(Float32,big_dim,big_dim)
    big2d3 = zeros(Float32,big_dim,big_dim)
    big2d4 = zeros(Float32,big_dim,big_dim)
    big2d5 = zeros(Float32,big_dim,big_dim)
    big2d6 = zeros(Float32,big_dim,big_dim)
    big2d7 = zeros(Float32,big_dim,big_dim)
    big3d = zeros(Float32,big_dim,big_dim,big_dim)

    small1d1 = zeros(Float32,small_dim)
    small2d1 = zeros(Float32,small_dim,small_dim)
    small3d1 = zeros(Float32,small_dim,small_dim,small_dim)
    small3d2 = zeros(Float32,small_dim,small_dim,small_dim)

    upperTriangular = UpperTriangular(zeros(Float32,big_dim,big_dim))

    # Miscellaneous micro benchmarks

    @benchmark(MicroBenchmarks.gemm!(big2d1,big2d2,big2d3),3)
    @benchmark(MicroBenchmarks.sqmm!(big2d1,big2d2,big2d3),3)
    @benchmark(MicroBenchmarks.copy3d!(small3d1,small3d2),1)
    @benchmark(MicroBenchmarks.copy3d_cube!(small3d1,small3d2),1)
    @benchmark(MicroBenchmarks.copy2d!(big2d1,big2d2),1000)
    @benchmark(MicroBenchmarks.copy2d!(big2d1,upperTriangular),1000)
    @benchmark(MicroBenchmarks.copy2d_triangular!(big2d1,upperTriangular),1000)
    @benchmark(MicroBenchmarks.copy2d_square!(big2d1,big2d2),1000)
    @benchmark(MicroBenchmarks.for_step_2_up(big1d1), 1)
    @benchmark(MicroBenchmarks.for_step_parametric(big1d1,1), 1)
    @benchmark(MicroBenchmarks.for_step_1_down(big1d1), 1)
    @benchmark(MicroBenchmarks.for_step_2_nested(big2d1), 1)

    # PolyBench datamining

    @benchmark(PolyBench.kernel_correlation(1.0,big2d1,big2d2,big1d1,big1d1),1)
    @benchmark(PolyBench.kernel_covariance(1.0,big2d1,big2d2,big1d1),1)

    # PolyBench linear-algebra/kernels

    @benchmark(PolyBench.kernel_2mm(1.0,1.0,big2d1,big2d2,big2d3,big2d4,big2d5),1)
    @benchmark(PolyBench.kernel_3mm(big2d1,big2d2,big2d3,big2d4,big2d5,big2d6,big2d7),1)
    @benchmark(PolyBench.kernel_atax(big2d1,big1d1,big1d2,big1d3),1)
    @benchmark(PolyBench.kernel_bicg(big2d1,big1d1,big1d2,big1d3,big1d4),1)
    @benchmark(PolyBench.kernel_doitgen(small3d1,small2d1,small1d1),1)
    @benchmark(PolyBench.kernel_mvt(big1d1,big1d2,big1d3,big1d4,big2d1),1)

    # PolyBench linear-algebra/blas

    @benchmark(PolyBench.kernel_gemm(1,1,big2d1,big2d2,big2d3),1)
    @benchmark(PolyBench.kernel_gemver(1,1,big2d1,big1d1,big1d2,big1d3,big1d4,big1d5,big1d6,big1d7,big1d8),1)
    @benchmark(PolyBench.kernel_gesummv(1,1,big2d1,big2d2,big1d1,big1d2,big1d3),1)
    @benchmark(PolyBench.kernel_symm(1,1,big2d1,big2d2,big2d3),1)
    @benchmark(PolyBench.kernel_syr2k(1,1,big2d1,big2d2,big2d3),1)
    @benchmark(PolyBench.kernel_syrk(1,1,big2d1,big2d2),1)
    @benchmark(PolyBench.kernel_trmm(1,big2d1,big2d2),1)

    # PolyBench linear-algebra/solvers

    @benchmark(PolyBench.kernel_cholesky(big2d1),1)
    @benchmark(PolyBench.kernel_durbin(big1d1,big1d2),1)
    @benchmark(PolyBench.kernel_gramschmidt(big2d1,big2d2,big2d3),1)
    @benchmark(PolyBench.kernel_lu(big2d1),1)
    @benchmark(PolyBench.kernel_ludcmp(big2d1,big1d1,big1d2,big1d3),1)
    @benchmark(PolyBench.kernel_trisolv(big2d1,big1d1,big1d2),1)

    # PolyBench medley

    @benchmark(PolyBench.kernel_deriche(1.0,big2d1,big2d2,big2d3,big2d4),1)
    @benchmark(PolyBench.kernel_floyd_warshall(big2d1),1)
    @benchmark(PolyBench.kernel_nussinov(big1d1,big2d1),1)

    # PolyBench stencils

    @benchmark(PolyBench.kernel_adi(100,big2d1,big2d2,big2d3,big2d4),1)
    @benchmark(PolyBench.kernel_fdtd_2d(big2d1,big2d2,big2d3,big1d1),1)
    @benchmark(PolyBench.kernel_heat_3d(1,small3d1,small3d2),1)
    @benchmark(PolyBench.kernel_jacobi_1d(100,big1d1,big1d2),1)
    @benchmark(PolyBench.kernel_jacobi_2d(100,big2d1,big2d2),1)
    @benchmark(PolyBench.kernel_seidel_2d(100,big2d1),1)
end

end # module
