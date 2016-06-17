module MicroBenchmarks

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

end # module
