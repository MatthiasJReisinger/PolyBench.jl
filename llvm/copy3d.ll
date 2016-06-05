%jl_value_t = type { %jl_value_t* }

; Function Attrs: sspreq
define void @copy3d(%jl_value_t*, %jl_value_t*) {
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
  %15 = getelementptr inbounds %jl_value_t, %jl_value_t* %1, i64 4, i32 0
  %16 = bitcast %jl_value_t** %15 to i64*
  %17 = load i64, i64* %16, align 8
  %18 = getelementptr inbounds %jl_value_t, %jl_value_t* %0, i64 5, i32 0
  %19 = bitcast %jl_value_t** %18 to i64*
  %20 = load i64, i64* %19, align 8
  %21 = icmp sgt i64 %6, 0
  %22 = select i1 %21, i64 %6, i64 0
  br label %L

L:                                                ; preds = %L4, %top
  %"#temp#1.0" = phi i64 [ 1, %top ], [ %29, %L4 ]
  %23 = add i64 %22, 1
  %24 = icmp eq i64 %"#temp#1.0", %23
  br i1 %24, label %L9, label %if

L4:                                               ; preds = %L5, %if
  %"#temp#2.0" = phi i64 [ 1, %if ], [ %32, %L5 ]
  %25 = add i64 %31, 1
  %26 = icmp eq i64 %"#temp#2.0", %25
  br i1 %26, label %L, label %if20

L5:                                               ; preds = %if21, %if20
  %"#temp#3.0" = phi i64 [ 1, %if20 ], [ %35, %if21 ]
  %27 = add i64 %34, 1
  %28 = icmp eq i64 %"#temp#3.0", %27
  br i1 %28, label %L4, label %if21

L9:                                               ; preds = %L
  ret void

if:                                               ; preds = %L
  %29 = add i64 %"#temp#1.0", 1
  %30 = icmp sgt i64 %9, 0
  %31 = select i1 %30, i64 %9, i64 0
  br label %L4

if20:                                             ; preds = %L4
  %32 = add i64 %"#temp#2.0", 1
  %33 = icmp sgt i64 %20, 0
  %34 = select i1 %33, i64 %20, i64 0
  br label %L5

if21:                                             ; preds = %L5
  %35 = add i64 %"#temp#3.0", 1
  %36 = add i64 %"#temp#2.0", -1
  %37 = add i64 %"#temp#3.0", -1
  %38 = mul i64 %37, %17
  %tmp = add i64 %36, %38
  %tmp29 = mul i64 %tmp, %14
  %39 = add i64 %"#temp#1.0", -1
  %40 = add i64 %39, %tmp29
  %41 = getelementptr float, float* %11, i64 %40
  %42 = bitcast float* %41 to i32*
  %43 = load i32, i32* %42, align 4
  %44 = mul i64 %37, %9
  %tmp30 = add i64 %36, %44
  %tmp31 = mul i64 %tmp30, %6
  %45 = add i64 %39, %tmp31
  %46 = getelementptr float, float* %3, i64 %45
  %47 = bitcast float* %46 to i32*
  store i32 %43, i32* %47, align 4
  br label %L5
}

