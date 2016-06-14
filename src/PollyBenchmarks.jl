module PollyBenchmarks

#############################
# Methods to be benchmarked #
#############################

@polly function gemm!(A,B,C)
    m,n = size(A)
    n,o = size(B)
    @inbounds for i=1:m, j=1:o, k=1:n
        C[i,j] += A[i,k] * B[k,j]
    end
end

@polly function sqmm!(A,B,C)
    n,n = size(A)
    @inbounds for i=1:n, j=1:n, k=1:n
        C[i,j] += A[i,k] * B[k,j]
    end
end

@polly function row_sum!(A,B)
    m,n = size(B)
    @inbounds for i=1:m, j=1:n
        A[i] += B[i,j]
    end
end

@polly function sum3d(A)
    a = zero(eltype(A))
    m,n,o = size(A)
    @inbounds for k=1:o, j=1:n, i=1:m
        a += A[i,j,k]
    end
    return a
end

@polly function sum3d_cube(A)
    a = zero(eltype(A))
    m,n,o = size(A)
    @inbounds for k=1:m, j=1:m, i=1:m
        a += A[i,j,k]
    end
    return a
end

@polly function sum2d(A)
    a = zero(eltype(A))
    m,n = size(A)
    @inbounds for i=1:m, j=1:n
        a += A[i,j]
    end
    return a
end

@polly function sum2d_square(A)
    a = zero(eltype(A))
    m,n = size(A)
    @inbounds for i=1:m, j=1:m
        a += A[i,j]
    end
    return a
end

@polly function copy3d!(A,B)
    m,n,o = size(A)
    @inbounds for i=1:m, j=1:n, k=1:o
        A[i,j,k] = B[i,j,k]
    end
end

@polly function copy3d_cube!(A,B)
    m,n,o = size(A)
    @inbounds for i=1:m, j=1:m, k=1:m
        A[i,j,k] = B[i,j,k]
    end
end

@polly function copy2d!(A,B)
    m,n = size(A)
    @inbounds for i=1:m, j=1:n
        A[i,j] = B[i,j]
    end
end

@polly function copy2d_square!(A,B)
    m,n = size(A)
    @inbounds for i=1:m, j=1:m
        A[i,j] = B[i,j]
    end
end

@polly function vector_sum!(A,B)
    n = size(A,1)
    @inbounds for i = 1:n
        B[0] += A[i]
    end
end

@polly function vector_sum2!(A,B)
    @inbounds for x in A
        B[0] += x
    end
end

@polly function copy3d_subrange!(A,B)
    m,n,o = size(A)
    for i=1:m, j=1:m
        for k=i:m
            A[i,j,k] = B[i,j,k]
        end
    end
end

include("PolyBench.jl")

#######################
# Actual benchmarking #
#######################

macro benchmark(ex, evals)
    quote
#        $(esc(ex)) # force compilation
        start_time = time()
        for i = 1:$evals
            $(esc(ex))
        end
        end_time = time()
        total_time = end_time - start_time
        println(total_time)
    end
end

function run()

    # Input data for the benchmarks

    big_dim = 1024
    small_dim = 256

    big1d1 = zeros(Float32,1024)
    big1d2 = zeros(Float32,1024)
    big1d3 = zeros(Float32,1024)
    big1d4 = zeros(Float32,1024)
    big1d5 = zeros(Float32,1024)
    big1d6 = zeros(Float32,1024)
    big1d7 = zeros(Float32,1024)
    big1d8 = zeros(Float32,1024)
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

    # Miscellaneous micro benchmarks

#    @benchmark(gemm!(big2d1,big2d2,big2d3), 3)
#    @benchmark(sqmm!(big2d1,big2d2,big2d3), 3)
#    @benchmark(row_sum!(big2d1,big2d2), 1000)
#    @benchmark(sum3d(big3d), 1)
#    @benchmark(sum3d_cube(big3d), 1)
#    @benchmark(sum2d(big2d1), 100)
#    @benchmark(sum2d_square(big2d1), 100)
#    @benchmark(copy3d!(small3d1,small3d2), 1)
#    @benchmark(copy3d_cube!(small3d1,small3d2), 1)
#    @benchmark(copy3d_subrange!(small3d1,small3d2), 1)
#    @benchmark(copy2d!(big2d1,big2d2), 1000)
#    @benchmark(copy2d_square!(big2d1,big2d2), 1000)
#    @benchmark(vector_sum!(big1d1,big1d1), 100000)
#    @benchmark(vector_sum2!(big1d1,big1d1), 100000)

    # PolyBench linear-algebra/kernels

#    @benchmark(PolyBench.kernel_2mm(1.0,1.0,big2d1,big2d2,big2d3,big2d4,big2d5), 1)
#    @benchmark(PolyBench.kernel_3mm(big2d1,big2d2,big2d3,big2d4,big2d5,big2d6,big2d7), 1)
#    @benchmark(PolyBench.kernel_atax(big2d1,big1d1,big1d2,big1d3), 1000)
#    @benchmark(PolyBench.kernel_bicg(big2d1,big1d1,big1d2,big1d3,big1d4), 1000)
#    @benchmark(PolyBench.kernel_doitgen(small3d1,small2d1,small1d1), 1)
#    @benchmark(PolyBench.kernel_mvt(big1d1,big1d2,big1d3,big1d4,big2d1), 1000)

    # PolyBench linear-algebra/blas

#    @benchmark(PolyBench.kernel_gemm(1, 1, big2d1, big2d2, big2d3), 1)
#    @benchmark(PolyBench.kernel_gemver(1, 1, big2d1, big1d1, big1d2, big1d3, big1d4, big1d5, big1d6, big1d7, big1d8), 1)
#    @benchmark(PolyBench.kernel_gesummv(1, 1, big2d1, big2d2, big1d1, big1d2, big1d3), 1)
#    @benchmark(PolyBench.kernel_symm(1, 1, big2d1, big2d2, big2d3), 1)
#    @benchmark(PolyBench.kernel_syr2k(1, 1, big2d1, big2d2, big2d3), 1)
#    @benchmark(PolyBench.kernel_syrk(1, 1, big2d1, big2d2), 1)
#    @benchmark(PolyBench.kernel_trmm(big_dim, big_dim, 1, big2d1, big2d2), 1)
    @benchmark(PolyBench.kernel_trmm(1, big2d1, big2d2), 1)

    # PolyBench linear-algebra/solvers


end

end # module
