using BenchmarkTools

@polly function gemm_restricted!(A,B,C)
    n,o = size(A)
    m,o = size(B)
    @inbounds for i=1:n, j=1:n, k=1:n
        C[i,j] += A[i,k] * B[k,j]
    end
end

N = 1024
M = 1024
O = 1024

A = zeros(Float32,N,O)
B = zeros(Float32,M,O)
C = zeros(Float32,N,M)

println(time(@benchmark gemm_restricted!(A,B,C) samples=1 evals=5))
