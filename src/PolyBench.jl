module PolyBench

##########################
# linear-algebra/kernels #
##########################

# D := alpha*A*B*C + beta*D
@polly function kernel_2mm(alpha, beta, tmp, A, B, C, D)
#function kernel_2mm(ni, nj, nk, nl,
#        alpha, beta, tmp, A, B, C, D)
    ni,nk = size(A)
    nj,nl = size(C)
    for i = 1:ni, j = 1:nj
        tmp[i,j] = zero(eltype(tmp))
#        tmp[i,j] = 0
        for k = 1:nk
            tmp[i,j] += alpha * A[i,k] * B[k,j]
        end
    end

    for i = 1:ni, j = 1:nl
        D[i,j] *= beta;
        for k = 1:nj
            D[i,j] += tmp[i,k] * C[k,j];
        end
    end
end

# G = (A*B) * (C*D)
#function kernel_3mm(ni, nj, nk, nl, nm,
#        E, A, B, F, C, D, G)
@polly function kernel_3mm(E, A, B, F, C, D, G)
    ni,nk = size(A)
    nk,nj = size(B)
    nj,nm = size(C)
    nm,nl = size(D)

    # E := A*B
    for i = 1:ni, j = 1:nj
        E[i,j] = zero(eltype(E))
        for k = 1:nk
            E[i,j] += A[i,k] * B[k,j]
        end
    end

    # F := C*D
    for i = 1:nj, j = 1:nl
        F[i,j] = zero(eltype(F))
        for k = 1:nm
            F[i,j] += C[i,k] * D[k,j]
        end
    end

    # G := E*F
    for i = 1:ni, j = 1:nl
        G[i,j] = zero(eltype(G))
        for k = 1:nj
            G[i,j] += E[i,k] * F[k,j]
        end
    end
end

@polly function kernel_atax(A, x, y, tmp)
    m,n = size(A)

    for i = 1:n
        y[i] = 0
    end

    for i = 1:m
        tmp[i] = zero(eltype(tmp))

        for j = 1:n
            tmp[i] = tmp[i] + A[i,j] * x[j]
        end

        for j = 1:n
            y[j] = y[j] + A[i,j] * tmp[i]
        end
    end
end

@polly function kernel_bicg(A,s,q,p,r)
    n,m = size(A)

    for i = 1:m
        s[i] = zero(eltype(s))
    end

    for i = 1:n
        q[i] = zero(eltype(q));
        for j = 1:m
            s[j] = s[j] + r[i] * A[i,j]
            q[i] = q[i] + A[i,j] * p[j]
        end
    end
end

@polly function kernel_doitgen(A,C4,sum)
    nr,nq,np = size(A)

    for r = 1:nr, q = 1:nq
        for p = 1:np
            sum[p] = zero(eltype(sum))
            for s = 1:np
                sum[p] += A[r,q,s] * C4[s,p]
            end
        end
        for p = 1:np
            A[r,q,p] = sum[p]
        end
    end
end

@polly function kernel_mvt(x1, x2, y1, y2, A)
    n = size(x1,1)
    for i = 1:n, j = 1:n
        x1[i] = x1[i] + A[i,j] * y1[j]
    end
    for i = 1:n, j = 1:n
        x2[i] = x2[i] + A[j,i] * y2[j]
    end
end

#######################
# linear-algebra/blas #
#######################

@polly function kernel_gemm(alpha, beta, C, A, B)
    ni,nk = size(A)
    nk,nj = size(B)
    for i = 1:ni
        for j = 1:nj
            C[i,j] *= beta
        end
        for k = 1:nk, j = 1:nj
            C[i,j] += alpha * A[i,k] * B[k,j]
        end
    end
end

@polly function kernel_gemver(alpha, beta, A, u1, v1, u2, v2, w, x, y, z)
    n = size(u1,1)
    for i = 1:n, j = 1:n
        A[i,j] = A[i,j] + u1[i] * v1[j] + u2[i] * v2[j]
    end

    for i = 1:n, j = 1:n
        x[i] = x[i] + beta * A[j,i] * y[j]
    end

    for i = 1:n
        x[i] = x[i] + z[i]
    end

    for i = 1:n, j = 1:n
        w[i] = w[i] + alpha * A[i,j] * x[j]
    end
end

@polly function kernel_gesummv(alpha, beta, A, B, tmp, x, y)
    n = size(tmp,1)
    for i = 1:n
        tmp[i] = zero(eltype(tmp))
        y[i] = zero(eltype(tmp))
        for j = 1:n
            tmp[i] = A[i,j] * x[j] + tmp[i]
            y[i] = B[i,j] * x[j] + y[i]
        end
        y[i] = alpha * tmp[i] + beta * y[i]
    end
end

@polly function kernel_symm(alpha, beta, C, A, B)
    m,n = size(C)
    for i = 1:m, j = 1:n
        temp2 = zero(eltype(C))
        for k = 1:(i-1)
            C[k,j] += alpha * B[i,j] * A[i,k]
            temp2 += B[k,j] * A[i,k]
        end
        C[i,j] = beta * C[i,j] + alpha * B[i,j] * A[i,i] + alpha * temp2
    end
end

@polly function kernel_syr2k(alpha, beta, C, A, B)
    n,m = size(A)
    for i = 1:n
        for j = 1:i
            C[i,j] += beta
        end
        for k = 1:m, j =1:i
            C[i,j] += A[j,k] * alpha * B[i,k] + B[j,k] * alpha * A[i,k]
        end
    end
end

@polly function kernel_syrk(alpha, beta, C, A)
    n,m = size(A)
    for i = 1:n
        for j = 1:i
            C[i,j] *= beta
        end
        for k = 1:m, j = 1:i
            C[i,j] += alpha * A[i,k] * A[j,k]
        end
    end
end

@polly function kernel_trmm(alpha, A, B)
    m,n = size(B)
    for i = 1:m, j = 1:n
        for k = (i+1):m
            B[i,j] += A[k,i] * B[k,j]
        end
        B[i,j] = alpha * B[i,j]
    end
end

##########################
# linear-algebra/solvers #
##########################

@polly function kernel_cholesky(A)
    n,n = size(A)
    for i = 1:n
        for j = 1:(i-1)
            for k = 1:(j-1)
            end
        end
    end
end

end # module
