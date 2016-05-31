using BenchmarkTools

@polly function sum3d!(A,B)
    m,n,o = size(A)
    @inbounds for i=1:m, j=1:m, k=1:m
        B[i,j] += A[i,j,k]
    end
end

M = 1024
N = 1024
O = 1024

A = zeros(Float32,M,N,O)
B = zeros(Float32,M,N)

println(time(@benchmark sum3d!(A,B) samples=1 evals=5))
