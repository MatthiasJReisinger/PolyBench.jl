%jl_value_t = type { %jl_value_t* }

; Function Attrs: sspreq
define void @gemm(%jl_value_t*, %jl_value_t*, %jl_value_t*) {
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
  %18 = getelementptr inbounds %jl_value_t, %jl_value_t* %1, i64 4, i32 0
  %19 = bitcast %jl_value_t** %18 to i64*
  %20 = load i64, i64* %19, align 8
  %21 = icmp sgt i64 %7, 0
  %22 = select i1 %21, i64 %7, i64 0
  br label %L

L:                                                ; preds = %L5, %top
  %"#temp#2.0" = phi i64 [ 1, %top ], [ %29, %L5 ]
  %23 = add i64 %22, 1
  %24 = icmp eq i64 %"#temp#2.0", %23
  br i1 %24, label %L10, label %if

L5:                                               ; preds = %L6, %if
  %"#temp#3.0" = phi i64 [ 1, %if ], [ %32, %L6 ]
  %25 = add i64 %31, 1
  %26 = icmp eq i64 %"#temp#3.0", %25
  br i1 %26, label %L, label %if11

L6:                                               ; preds = %if12, %if11
  %"#temp#4.0" = phi i64 [ 1, %if11 ], [ %35, %if12 ]
  %27 = add i64 %34, 1
  %28 = icmp eq i64 %"#temp#4.0", %27
  br i1 %28, label %L5, label %if12

L10:                                              ; preds = %L
  ret void

if:                                               ; preds = %L
  %29 = add i64 %"#temp#2.0", 1
  %30 = icmp sgt i64 %12, 0
  %31 = select i1 %30, i64 %12, i64 0
  br label %L5

if11:                                             ; preds = %L5
  %32 = add i64 %"#temp#3.0", 1
  %33 = icmp sgt i64 %20, 0
  %34 = select i1 %33, i64 %20, i64 0
  br label %L6

if12:                                             ; preds = %L6
  %35 = add i64 %"#temp#4.0", 1
  %36 = add i64 %"#temp#2.0", -1
  %37 = add i64 %"#temp#3.0", -1
  %38 = mul i64 %37, %17
  %39 = add i64 %36, %38
  %40 = getelementptr float, float* %14, i64 %39
  %41 = load float, float* %40, align 4
  %42 = add i64 %"#temp#4.0", -1
  %43 = mul i64 %42, %7
  %44 = add i64 %36, %43
  %45 = getelementptr float, float* %4, i64 %44
  %46 = load float, float* %45, align 4
  %47 = mul i64 %37, %12
  %48 = add i64 %47, -1
  %49 = add i64 %48, %"#temp#4.0"
  %50 = getelementptr float, float* %9, i64 %49
  %51 = load float, float* %50, align 4
  %52 = fmul float %46, %51
  %53 = fadd float %41, %52
  store float %53, float* %40, align 4
  br label %L6
}
