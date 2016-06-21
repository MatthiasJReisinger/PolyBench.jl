module MicroBenchmarks

@polly function gemm!(A,B,C)
    m,n = size(A)
    n,o = size(B)
    for i=1:m, j=1:o, k=1:n
        C[i,j] += A[i,k] * B[k,j]
    end
end

@polly function sqmm!(A,B,C)
    n,n = size(A)
    for i=1:n, j=1:n, k=1:n
        C[i,j] += A[i,k] * B[k,j]
    end
end

@polly function copy3d!(A,B)
    m,n,o = size(A)
    for i=1:m, j=1:n, k=1:o
        A[i,j,k] = B[i,j,k]
    end
end

@polly function copy3d_cube!(A,B)
    m,n,o = size(A)
    for i=1:m, j=1:m, k=1:m
        A[i,j,k] = B[i,j,k]
    end
end

@polly function copy2d!(A,B)
    m,n = size(A)
    for i=1:m, j=1:n
        A[i,j] = B[i,j]
    end
end

@polly function copy2d_triangular!(A,B::UpperTriangular)
    m,n = size(A)
    for i=1:m, j=1:n
        A[i,j] = B.data[i,j]
    end
end

@polly function copy2d_square!(A,B)
    m,n = size(A)
    for i=1:m, j=1:m
        A[i,j] = B[i,j]
    end
end

@polly function for_step_2_up(A)
    for i = 1:2:1024
        A[i] = 0
    end
end

@polly function for_step_parametric(A,s)
    n = size(A,1)
    for i = 1:s:1024
        A[i] = 0
    end
end

@polly function for_step_1_down(A)
    n = size(A,1)
    for i = 1024:-1:1
        A[i] = 0
    end
end

@polly function for_step_2_nested(A)
    for i = 1:1024, j = 1:2:1024
        A[i,j] = 0
    end
end

end # module
