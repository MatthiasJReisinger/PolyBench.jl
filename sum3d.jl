@polly function sum3d!(A,B)
    m,n,o = size(A)
    @inbounds for i=1:m, j=1:m, k=1:m
        B[i,j] += A[i,j,k]
    end
end

N = 1024
M = 1024
O = 1024

A = zeros(Float32,M,N,O)
B = zeros(Float32,M,N)
time_start = time()
#for i=1:10
    sum3d!(A,B)
#end
time_end = time()

time_overall = time_end - time_start
println("Time: ", time_overall)
