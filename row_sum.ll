%jl_value_t = type { %jl_value_t* }

; Function Attrs: sspreq
define void @row_sum(%jl_value_t*, %jl_value_t*) {
top:
  %2 = bitcast %jl_value_t* %1 to float**
  %3 = load float*, float** %2, align 8
  %4 = getelementptr inbounds %jl_value_t, %jl_value_t* %1, i64 3, i32 0
  %5 = bitcast %jl_value_t** %4 to i64*
  %6 = load i64, i64* %5, align 8
  %7 = getelementptr inbounds %jl_value_t, %jl_value_t* %1, i64 4, i32 0
  %8 = bitcast %jl_value_t** %7 to i64*
  %9 = load i64, i64* %8, align 8
  %10 = icmp sgt i64 %6, 0
  %11 = select i1 %10, i64 %6, i64 0
  br label %L

L:                                                ; preds = %L3, %top
  %"#temp#1.0" = phi i64 [ 1, %top ], [ %16, %L3 ]
  %12 = add i64 %11, 1
  %13 = icmp eq i64 %"#temp#1.0", %12
  br i1 %13, label %L6, label %if

L3:                                               ; preds = %if7, %if
  %"#temp#2.0" = phi i64 [ 1, %if ], [ %19, %if7 ]
  %14 = add i64 %18, 1
  %15 = icmp eq i64 %"#temp#2.0", %14
  br i1 %15, label %L, label %if7

L6:                                               ; preds = %L
  ret void

if:                                               ; preds = %L
  %16 = add i64 %"#temp#1.0", 1
  %17 = icmp sgt i64 %9, 0
  %18 = select i1 %17, i64 %9, i64 0
  br label %L3

if7:                                              ; preds = %L3
  %19 = add i64 %"#temp#2.0", 1
  %20 = add i64 %"#temp#1.0", -1
  %21 = bitcast %jl_value_t* %0 to float**
  %22 = load float*, float** %21, align 8
  %23 = getelementptr float, float* %22, i64 %20
  %24 = load float, float* %23, align 4
  %25 = add i64 %"#temp#2.0", -1
  %26 = mul i64 %25, %6
  %27 = add i64 %20, %26
  %28 = getelementptr float, float* %3, i64 %27
  %29 = load float, float* %28, align 4
  %30 = fadd float %24, %29
  store float %30, float* %23, align 4
  br label %L3
}
