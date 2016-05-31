%jl_value_t = type { %jl_value_t* }

; Function Attrs: sspreq
define void @sum3d(%jl_value_t*, %jl_value_t*) {
top:
  %2 = bitcast %jl_value_t* %0 to float**
  %3 = load float*, float** %2, align 8
  %4 = getelementptr inbounds %jl_value_t, %jl_value_t* %0, i64 3, i32 0
  %5 = bitcast %jl_value_t** %4 to i64*
  %6 = load i64, i64* %5, align 8
  %7 = getelementptr inbounds %jl_value_t, %jl_value_t* %0, i64 4, i32 0
  %8 = bitcast %jl_value_t** %7 to i64*
  %9 = load i64, i64* %8, align 8
  %10 = bitcast %jl_value_t* %1 to float**
  %11 = load float*, float** %10, align 8
  %12 = getelementptr inbounds %jl_value_t, %jl_value_t* %1, i64 3, i32 0
  %13 = bitcast %jl_value_t** %12 to i64*
  %14 = load i64, i64* %13, align 8
  %15 = icmp sgt i64 %6, 0
  %16 = select i1 %15, i64 %6, i64 0
  br label %L

L:                                                ; preds = %L4, %top
  %"#temp#1.0" = phi i64 [ 1, %top ], [ %21, %L4 ]
  %17 = add i64 %16, 1
  %18 = icmp eq i64 %"#temp#1.0", %17
  br i1 %18, label %L9, label %if

L4:                                               ; preds = %L5, %if
  %"#temp#2.0" = phi i64 [ 1, %if ], [ %22, %L5 ]
  %19 = icmp eq i64 %"#temp#2.0", %17
  br i1 %19, label %L, label %if20

L5:                                               ; preds = %if21, %if20
  %"#temp#3.0" = phi i64 [ 1, %if20 ], [ %23, %if21 ]
  %20 = icmp eq i64 %"#temp#3.0", %17
  br i1 %20, label %L4, label %if21

L9:                                               ; preds = %L
  ret void

if:                                               ; preds = %L
  %21 = add i64 %"#temp#1.0", 1
  br label %L4

if20:                                             ; preds = %L4
  %22 = add i64 %"#temp#2.0", 1
  br label %L5

if21:                                             ; preds = %L5
  %23 = add i64 %"#temp#3.0", 1
  %24 = add i64 %"#temp#1.0", -1
  %25 = add i64 %"#temp#2.0", -1
  %26 = mul i64 %25, %14
  %27 = add i64 %24, %26
  %28 = getelementptr float, float* %11, i64 %27
  %29 = load float, float* %28, align 4
  %30 = add i64 %"#temp#3.0", -1
  %31 = mul i64 %30, %9
  %tmp = add i64 %25, %31
  %tmp32 = mul i64 %tmp, %6
  %32 = add i64 %24, %tmp32
  %33 = getelementptr float, float* %3, i64 %32
  %34 = load float, float* %33, align 4
  %35 = fadd float %29, %34
  store float %35, float* %28, align 4
  br label %L5
}

