using BenchmarkTools

@polly function row_sum!(A,B)
    m = size(A)
    n,o = size(B)
    @inbounds for i=1:n, j=1:o
        A[i] += B[i,j]
    end
end

M = 1024
N = 1024
O = 1024

A = zeros(Float32,M)
B = zeros(Float32,N,O)

println(mean(@benchmark row_sum!(A,B) samples=1 evals=5))
