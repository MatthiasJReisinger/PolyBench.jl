@polly function matrix_test(A,B)
    m = size(A)
    n,o = size(B)
    @inbounds for i=1:n, j=1:o
        A[i] += B[i,j]
    end
end

M = 1024
N = 1024
O = 1024

A = zeros(Float32,N)
B = zeros(Float32,M,O)

time_start = time()
matrix_test(A,B)
time_end = time()

time_overall = time_end - time_start
println("Time: ", time_overall)
