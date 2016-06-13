%jl_value_t = type { %jl_value_t* }

; Function Attrs: sspreq
define void @kernel_trmm(i64, %jl_value_t*, %jl_value_t*) {
top:
  br label %top.split

top.split:                                        ; preds = %top
  %3 = bitcast %jl_value_t* %1 to float**
  %4 = load float*, float** %3, align 8
  %5 = getelementptr inbounds %jl_value_t, %jl_value_t* %1, i64 3, i32 0
  %6 = bitcast %jl_value_t** %5 to i64*
  %7 = load i64, i64* %6, align 8
  %8 = bitcast %jl_value_t* %2 to float**
  %9 = load float*, float** %8, align 8
  %10 = getelementptr inbounds %jl_value_t, %jl_value_t* %2, i64 3, i32 0
  %11 = bitcast %jl_value_t** %10 to i64*
  %12 = load i64, i64* %11, align 8
  %13 = getelementptr inbounds %jl_value_t, %jl_value_t* %2, i64 4, i32 0
  %14 = bitcast %jl_value_t** %13 to i64*
  %15 = load i64, i64* %14, align 8
  %16 = icmp sgt i64 %12, 0
  %17 = select i1 %16, i64 %12, i64 0
  %18 = add i64 %17, 1
  %19 = icmp eq i64 1, %18
  br i1 %19, label %L10, label %if.lr.ph

if.lr.ph:                                         ; preds = %top.split
  br label %if

L4.L.loopexit_crit_edge:                          ; preds = %L7
  br label %L.loopexit

L.loopexit:                                       ; preds = %L4.L.loopexit_crit_edge, %if
  %20 = icmp eq i64 %30, %18
  br i1 %20, label %L.L10_crit_edge, label %if

L5.L7_crit_edge:                                  ; preds = %if12
  br label %L7

L7:                                               ; preds = %L5.L7_crit_edge, %if11
  %21 = add i64 %"#temp#1.030", -1
  %22 = add i64 %"#temp#2.029", -1
  %23 = mul i64 %22, %12
  %24 = add i64 %21, %23
  %25 = getelementptr float, float* %9, i64 %24
  %26 = load float, float* %25, align 4
  %27 = sitofp i64 %0 to float
  %28 = fmul float %27, %26
  store float %28, float* %25, align 4
  %29 = icmp eq i64 %35, %33
  br i1 %29, label %L4.L.loopexit_crit_edge, label %if11

L.L10_crit_edge:                                  ; preds = %L.loopexit
  br label %L10

L10:                                              ; preds = %L.L10_crit_edge, %top.split
  ret void

if:                                               ; preds = %if.lr.ph, %L.loopexit
  %"#temp#1.030" = phi i64 [ 1, %if.lr.ph ], [ %30, %L.loopexit ]
  %30 = add i64 %"#temp#1.030", 1
  %31 = icmp sgt i64 %15, 0
  %32 = select i1 %31, i64 %15, i64 0
  %33 = add i64 %32, 1
  %34 = icmp eq i64 1, %33
  br i1 %34, label %L.loopexit, label %if11.lr.ph

if11.lr.ph:                                       ; preds = %if
  br label %if11

if11:                                             ; preds = %if11.lr.ph, %L7
  %"#temp#2.029" = phi i64 [ 1, %if11.lr.ph ], [ %35, %L7 ]
  %35 = add i64 %"#temp#2.029", 1
  %36 = icmp sgt i64 %30, %12
  %37 = select i1 %36, i64 %"#temp#1.030", i64 %12
  %38 = add i64 %37, 1
  %39 = icmp eq i64 %30, %38
  br i1 %39, label %L7, label %if12.lr.ph

if12.lr.ph:                                       ; preds = %if11
  br label %if12

if12:                                             ; preds = %if12.lr.ph, %if12
  %"#temp#3.028" = phi i64 [ %30, %if12.lr.ph ], [ %40, %if12 ]
  %40 = add i64 %"#temp#3.028", 1
  %41 = add i64 %"#temp#1.030", -1
  %42 = add i64 %"#temp#2.029", -1
  %43 = mul i64 %42, %12
  %44 = add i64 %41, %43
  %45 = getelementptr float, float* %9, i64 %44
  %46 = load float, float* %45, align 4
  %47 = mul i64 %41, %7
  %48 = add i64 %47, -1
  %49 = add i64 %48, %"#temp#3.028"
  %50 = getelementptr float, float* %4, i64 %49
  %51 = load float, float* %50, align 4
  %52 = add i64 %43, -1
  %53 = add i64 %52, %"#temp#3.028"
  %54 = getelementptr float, float* %9, i64 %53
  %55 = load float, float* %54, align 4
  %56 = fmul float %51, %55
  %57 = fadd float %46, %56
  store float %57, float* %45, align 4
  %58 = icmp eq i64 %40, %38
  br i1 %58, label %L5.L7_crit_edge, label %if12
}
