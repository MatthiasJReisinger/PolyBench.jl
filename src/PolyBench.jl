module PolyBench

##############
# datamining #
##############

@polly function kernel_correlation(float_n, data, corr, mean, stddev)
    n,m = size(data)
    eps = 0.1;

    for j = 1:m
        mean[j] = zero(eltype(mean))
        for i = 1:n
            mean[j] += data[i,j]
        end
        mean[j] /= float_n
    end

    for j = 1:m
        stddev[j] = zero(eltype(stddev))
        for i = 1:n
            stddev[j] += (data[i,j] - mean[j]) * (data[i,j] - mean[j])
        end
        stddev[j] /= float_n
        stddev[j] = sqrt(stddev[j])
        stddev[j] = stddev[j] <= eps ? one(eltype(stddev)) : stddev[j]
    end

    # Center and reduce the column vectors.
    for i = 1:n, j = 1:m
        data[i,j] -= mean[j]
        data[i,j] /= sqrt(float_n) * stddev[j]
    end

    # Calculate the m * m correlation matrix.
    for i = 1:(m-1)
        corr[i,i] = one(eltype(corr))
        for j = (i+1):m
            corr[i,j] = one(eltype(corr))
            for k = 1:n
                corr[i,j] += (data[k,i] * data[k,j])
            end
            corr[j,i] = corr[i,j]
        end
    end

    corr[m-1,m-1] = one(eltype(corr))
end

@polly function kernel_covariance(float_n, data, cov, mean)
    n,m = size(data)

    for j = 1:m
        mean[j] = zero(eltype(mean))
        for i = 1:n
            mean[j] += data[i,j]
        end
        mean[j] /= float_n
    end

    for i = 1:n, j = 1:m
        data[i,j] -= mean[j]
    end

    for i = 1:m, j = i:m
        cov[i,j] = zero(eltype(cov))
        for k = 1:n
            cov[i,j] += data[k,i] * data[k,j]
        end
        cov[i,j] /= (float_n - one(eltype(cov)))
        cov[j,i] = cov[i,j]
    end
end

##########################
# linear-algebra/kernels #
##########################

# D := alpha*A*B*C + beta*D
@polly function kernel_2mm(alpha, beta, tmp, A, B, C, D)
    ni,nk = size(A)
    nj,nl = size(C)
    for i = 1:ni, j = 1:nj
        tmp[i,j] = zero(eltype(tmp))
        for k = 1:nk
            tmp[i,j] += alpha * A[i,k] * B[k,j]
        end
    end

    for i = 1:ni, j = 1:nl
        D[i,j] *= beta
        for k = 1:nj
            D[i,j] += tmp[i,k] * C[k,j]
        end
    end
end

# G = (A*B) * (C*D)
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
    n = size(A,1)
    for i = 1:n
        # j < i
        for j = 1:(i-1)
            for k = 1:(j-1)
                A[k,j] -= A[i,k] * A[j,k]
            end
            A[i,j] /= A[j,j]
        end
        # i == j case
        for k = 1:(i-1)
            A[i,i] -= A[i,k] * A[i,k]
        end
        A[i,i] = sqrt(A[i,i])
    end
end

@polly function kernel_durbin(r, y)
    n = size(r,1)
    z = zeros(eltype(r),n)
    y[1] = -r[1]
    beta = one(eltype(y))
    alpha = -r[1]

    for k = 2:n
        beta = (1 - alpha * alpha) * beta
        sum = zero(eltype(y))
        for i = 1:(k-1)
            sum += r[k-i] * y[i]
        end
        alpha = - (r[k] + sum)/beta

        for i = 1:(k-1)
            z[i] = y[i] + alpha * y[k-i]
        end
        for i = 1:(k-1)
            y[i] = z[i]
        end
        y[k] = alpha
    end
end

@polly function kernel_gramschmidt(A,R,Q)
    m,n = size(A)
    for k = 1:n
        nrm = zero(eltype(A))
        for i = 1:m
            nrm += A[i,k] * A[i,k]
        end
        R[k,k] = sqrt(nrm)
        for i = 1:m
            Q[i,k] = A[i,k] / R[k,k]
        end
        for j = (k+1):n
            R[k,j] = zero(eltype(R))
            for i = 1:m
                R[k,j] += Q[i,k] * A[i,j]
            end
            for i = 1:m
                A[i,j] = A[i,j] - Q[i,k] * R[k,j]
            end
        end
    end
end

@polly function kernel_lu(A)
    n = size(A,1)
    for i = 1:n
        for j = 1:(i-1)
            for k = 1:(j-1)
                A[i,j] -= A[i,k] * A[k,j]
            end
            A[i,j] /= A[j,j]
        end
        for j = i:n, k = 1:(i-1)
            A[i,j] -= A[i,k] * A[k,j]
        end
    end
end

@polly function kernel_ludcmp(A, b, x, y)
    n = size(A,1)

    for i = 1:n
        for j = 1:(i-1)
            w = A[i,j]
            for k = 1:(j-1)
                w -= A[i,k] * A[k,j]
            end
            A[i,j] = w / A[j,j]
        end
        for j = i:n
            w = A[i,j]
            for k = 1:(i-1)
                w -= A[i,k] * A[k,j]
            end
            A[i,j] = w
        end
    end

    for i = 1:n
        w = b[i]
        for j = 1:(i-1)
            w -= A[i,j] * y[j]
        end
        y[i] = w
    end

    for i = n:-1:1
        w = y[i]
        for j = (i+1):n
            w -= A[i,j] * x[j]
        end
        x[i] = w / A[i,i]
    end
end

@polly function kernel_trisolv(L, x, b)
    n = size(L,1)
    for i = 1:n
        x[i] = b[i]
        for j = 1:(i-1)
            x[i] -= L[i,j] * x[j]
        end
        x[i] = x[i] / L[i,i]
    end
end

##########
# medely #
##########

@polly function kernel_deriche(alpha, imgIn, imgOut, y1, y2)
    w,h = size(imgIn)

    k = (1.0-exp(-alpha))*(1.0-exp(-alpha))/(1.0+2.0*alpha*exp(-alpha)-exp(2.0*alpha))
    a1 = a5 = k
    a2 = a6 = k*exp(-alpha)*(alpha-1.0)
    a3 = a7 = k*exp(-alpha)*(alpha+1.0)
    a4 = a8 = -k*exp(-2.0*alpha)
    b1 = 2.0^(-alpha)
    b2 = -exp(-2.0*alpha)
    c1 = c2 = 1

    for i = 1:w
        ym1 = 0.0;
        ym2 = 0.0;
        xm1 = 0.0;
        for j = 1:h
            y1[i,j] = a1*imgIn[i,j] + a2*xm1 + b1*ym1 + b2*ym2
            xm1 = imgIn[i,j]
            ym2 = ym1
            ym1 = y1[i,j]
        end
    end

    for i = 1:w
        yp1 = 0.0
        yp2 = 0.0
        xp1 = 0.0
        xp2 = 0.0
        for j = h:-1:1
            y2[i,j] = a3*xp1 + a4*xp2 + b1*yp1 + b2*yp2
            xp2 = xp1
            xp1 = imgIn[i,j]
            yp2 = yp1
            yp1 = y2[i,j]
        end
    end

    for i = 1:w, j = 1:h
        imgOut[i,j] = c1 * (y1[i,j] + y2[i,j])
    end

    for j = 1:h
        tm1 = 0.0
        ym1 = 0.0
        ym2 = 0.0
        for i = 1:w
            y1[i,j] = a5*imgOut[i,j] + a6*tm1 + b1*ym1 + b2*ym2
            tm1 = imgOut[i,j]
            ym2 = ym1
            ym1 = y1[i,j]
        end
    end


    for j = 1:h
        tp1 = 0.0
        tp2 = 0.0
        yp1 = 0.0
        yp2 = 0.0
        for i = w:-1:1
            y2[i,j] = a7*tp1 + a8*tp2 + b1*yp1 + b2*yp2
            tp2 = tp1
            tp1 = imgOut[i,j]
            yp2 = yp1
            yp1 = y2[i,j]
        end
    end

    for i=1:w, j=1:h
        imgOut[i,j] = c2*(y1[i,j] + y2[i,j])
    end
end

@polly function kernel_floyd_warshall(path)
    n = size(path,1)
    for k = 1:n, i = 1:n, j = 1:n
        path[i,j] = path[i,j] < path[i,k] + path[k,j] ? path[i,j] : path[i,k] + path[k,j]
    end
end

@polly function kernel_nussinov(seq, table)
    n = size(seq,1)

    for i = n:-1:1, j = i+1:n
        if (j-1) >= 1
            table[i,j] = max(table[i,j], table[i,j-1])
        end

        if (i+1) <= n
            table[i,j] = max(table[i,j], table[i+1,j])
        end

        if (j-1) >= 1 && (i+1) <= n
            # don't allow adjacent elements to bond */
            if (i < j-1)
                table[i,j] = max(table[i,j], table[i+1,j-1] + (seq[i] + seq[j] == 3 ? 1 : 0))
            else
                table[i,j] = max(table[i,j], table[i+1,j-1])
            end
        end

        for k = (i+1):(j-1)
            table[i,j] = max(table[i,j], table[i,k] + table[k+1,j])
        end
    end
end

############
# stencils #
############

@polly function kernel_adi(tsteps, u, v, p, q)
    n = size(u,1)

    DX = 1.0 / n
    DY = 1.0 / n
    DT = 1.0 / tsteps
    B1 = 2.0
    B2 = 1.0
    mul1 = B1 * DT / (DX * DX)
    mul2 = B2 * DT / (DY * DY)

    a = -mul1 /  2.0;
    b = 1.0 + mul1
    c = a
    d = -mul2 / 2.0
    _e = 1.0 + mul2
    f = d

    for t = 1:tsteps
        # Column Sweep
        for i = 2:(n-1)
            v[1,i] = 1.0
            p[i,1] = 0.0
            q[i,1] = v[1,i]
            for j = 2:(n-1)
                p[i,j] = -c / (a * p[i,j-1] + b)
                q[i,j] = (-d*u[j,i-1]+(1.0+2.0*d)*u[j,i] - f*u[j,i+1]-a*q[i,j-1])/(a*p[i,j-1]+b)
            end

            v[n,i] = 1.0
            for j = (n-1):-1:2
                v[j,i] = p[i,j] * v[j+1,i] + q[i,j]
            end
        end

        # Row Sweep
        for i = 2:(n-1)
            u[i,1] = 1.0
            p[i,1] = 0.0
            q[i,1] = u[i,1]
            for j = 2:(n-1)
                p[i,j] = -f / (d*p[i,j-1] + _e)
                q[i,j] = (-a*v[i-1,j]+(1.0+2.0*a)*v[i,j] - c*v[i+1,j]-d*q[i,j-1])/(d*p[i,j-1]+_e)
            end

            u[i,n] = 1.0
            for j = (n-1):-1:2
                u[i,j] = p[i,j] * u[i,j+1] + q[i,j]
            end
        end
    end
end

@polly function kernel_fdtd_2d(ex, ey, hz, _fict_)
    nx,ny = size(ex)
    tmax = size(_fict_,1)

    for t = 1:tmax
        for j = 1:ny
            ey[1,j] = _fict_[t]
        end
        for i = 2:nx, j = 1:ny
            ey[i,j] = ey[i,j] - 0.5 * (hz[i,j] - hz[i-1,j])
        end
        for i = 1:nx, j = 2:ny
            ex[i,j] = ex[i,j] - 0.5 * (hz[i,j] - hz[i,j-1])
        end
        for i = 1:(nx - 1), j = 1:(ny - 1)
            hz[i,j] = hz[i,j] - 0.7 * (ex[i,j+1] - ex[i,j] + ey[i+1,j] - ey[i,j])
        end
    end
end

@polly function kernel_hea3_3d(tsteps, A, B)
    n = size(A,1)

    for t = 1:tsteps
        for i = 2:(n-1), j = 2:(n-1), k = 2:(n-1)
            B[i,j,k] =   0.125 * (A[i+1,j,k] - 2.0 * A[i,j,k] + A[i-1,j,k]) +
                         0.125 * (A[i,j+1,k] - 2.0 * A[i,j,k] + A[i,j-1,k]) +
                         0.125 * (A[i,j,k+1] - 2.0 * A[i,j,k] + A[i,j,k-1]) +
                         A[i,j,k]
        end
        for i = 2:(n-1), j = 2:(n-1), k = 2:(n-1)
            A[i,j,k] =   0.125 * (B[i+1,j,k] - 2.0 * B[i,j,k] + B[i-1,j,k]) +
                         0.125 * (B[i,j+1,k] - 2.0 * B[i,j,k] + B[i,j-1,k]) +
                         0.125 * (B[i,j,k+1] - 2.0 * B[i,j,k] + B[i,j,k-1]) +
                         B[i,j,k]
        end
    end
end

@polly function kernel_jacobi_1d(tsteps, A, B)
    n = size(A,1)

    for t = 1:tsteps
        for i = 2:(n-1)
            B[i] = 0.33333 * (A[i-1] + A[i] + A[i + 1])
        end
        for i = 2:(n-1)
            A[i] = 0.33333 * (B[i-1] + B[i] + B[i + 1])
        end
    end
end

@polly function kernel_jacobi_2d(tsteps, A, B)
    n = size(A,1)

    for t = 1:tsteps
        for i = 2:(n-1), j = 2:(n-1)
            B[i,j] = 0.2 * (A[i,j] + A[i,j-1] + A[i,1+j] + A[1+i,j] + A[i-1,j])
        end
        for i = 2:(n-1), j = 2:(n-1)
            A[i,j] = 0.2 * (B[i,j] + B[i,j-1] + B[i,1+j] + B[1+i,j] + B[i-1,j])
        end
    end
end

@polly function kernel_seidel_2d(tsteps, A)
    n = size(A,1)

    for t = 1:tsteps, i = 2:(n-2), j = 2:(n-2)
        A[i,j] = (A[i-1,j-1] + A[i-1,j] + A[i-1,j+1] + A[i,j-1] + A[i,j] + A[i,j+1] + A[i+1,j-1] + A[i+1,j] + A[i+1,j+1])/9.0
    end
end

end # module
