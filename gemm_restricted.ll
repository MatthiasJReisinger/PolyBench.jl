%jl_value_t = type { %jl_value_t* }

; Function Attrs: sspreq
define void @gemm_restricted(%jl_value_t*, %jl_value_t*, %jl_value_t*) {
top:
  %3 = bitcast %jl_value_t* %0 to float**
  %4 = load float*, float** %3, align 8
  %5 = getelementptr inbounds %jl_value_t, %jl_value_t* %0, i64 3, i32 0
  %6 = bitcast %jl_value_t** %5 to i64*
  %7 = load i64, i64* %6, align 8
  %8 = bitcast %jl_value_t* %1 to float**
  %9 = load float*, float** %8, align 8
  %10 = getelementptr inbounds %jl_value_t, %jl_value_t* %1, i64 3, i32 0
  %11 = bitcast %jl_value_t** %10 to i64*
  %12 = load i64, i64* %11, align 8
  %13 = bitcast %jl_value_t* %2 to float**
  %14 = load float*, float** %13, align 8
  %15 = getelementptr inbounds %jl_value_t, %jl_value_t* %2, i64 3, i32 0
  %16 = bitcast %jl_value_t** %15 to i64*
  %17 = load i64, i64* %16, align 8
  %18 = icmp sgt i64 %7, 0
  %19 = select i1 %18, i64 %7, i64 0
  br label %L

L:                                                ; preds = %L5, %top
  %"#temp#2.0" = phi i64 [ 1, %top ], [ %24, %L5 ]
  %20 = add i64 %19, 1
  %21 = icmp eq i64 %"#temp#2.0", %20
  br i1 %21, label %L10, label %if

L5:                                               ; preds = %L6, %if
  %"#temp#3.0" = phi i64 [ 1, %if ], [ %25, %L6 ]
  %22 = icmp eq i64 %"#temp#3.0", %20
  br i1 %22, label %L, label %if11

L6:                                               ; preds = %if12, %if11
  %"#temp#4.0" = phi i64 [ 1, %if11 ], [ %26, %if12 ]
  %23 = icmp eq i64 %"#temp#4.0", %20
  br i1 %23, label %L5, label %if12

L10:                                              ; preds = %L
  ret void

if:                                               ; preds = %L
  %24 = add i64 %"#temp#2.0", 1
  br label %L5

if11:                                             ; preds = %L5
  %25 = add i64 %"#temp#3.0", 1
  br label %L6

if12:                                             ; preds = %L6
  %26 = add i64 %"#temp#4.0", 1
  %27 = add i64 %"#temp#2.0", -1
  %28 = add i64 %"#temp#3.0", -1
  %29 = mul i64 %28, %17
  %30 = add i64 %27, %29
  %31 = getelementptr float, float* %14, i64 %30
  %32 = load float, float* %31, align 4
  %33 = add i64 %"#temp#4.0", -1
  %34 = mul i64 %33, %7
  %35 = add i64 %27, %34
  %36 = getelementptr float, float* %4, i64 %35
  %37 = load float, float* %36, align 4
  %38 = mul i64 %28, %12
  %39 = add i64 %38, -1
  %40 = add i64 %39, %"#temp#4.0"
  %41 = getelementptr float, float* %9, i64 %40
  %42 = load float, float* %41, align 4
  %43 = fmul float %37, %42
  %44 = fadd float %32, %43
  store float %44, float* %31, align 4
  br label %L6
}
