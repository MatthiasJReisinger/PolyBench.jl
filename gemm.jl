@polly function gemm(A,B,C)
    n,o = size(A)
    m,o = size(B)
    @inbounds for i=1:n, j=1:m, k=1:o
        C[i,j] += A[i,k] * B[k,j]
    end
end

N = 1024
M = 1024
O = 1024

A = zeros(Float32,N,O)
B = zeros(Float32,M,O)
C = zeros(Float32,N,M)

time_start = time()
gemm(A,B,C)
time_end = time()

time_overall = time_end - time_start
println("Time: ", time_overall)
