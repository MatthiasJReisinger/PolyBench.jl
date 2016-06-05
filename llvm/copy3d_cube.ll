%jl_value_t = type { %jl_value_t* }

; Function Attrs: sspreq
define void @copy3d_cube(%jl_value_t*, %jl_value_t*) {
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
  %18 = icmp sgt i64 %6, 0
  %19 = select i1 %18, i64 %6, i64 0
  br label %L

L:                                                ; preds = %L4, %top
  %"#temp#1.0" = phi i64 [ 1, %top ], [ %24, %L4 ]
  %20 = add i64 %19, 1
  %21 = icmp eq i64 %"#temp#1.0", %20
  br i1 %21, label %L9, label %if

L4:                                               ; preds = %L5, %if
  %"#temp#2.0" = phi i64 [ 1, %if ], [ %25, %L5 ]
  %22 = icmp eq i64 %"#temp#2.0", %20
  br i1 %22, label %L, label %if20

L5:                                               ; preds = %if21, %if20
  %"#temp#3.0" = phi i64 [ 1, %if20 ], [ %26, %if21 ]
  %23 = icmp eq i64 %"#temp#3.0", %20
  br i1 %23, label %L4, label %if21

L9:                                               ; preds = %L
  ret void

if:                                               ; preds = %L
  %24 = add i64 %"#temp#1.0", 1
  br label %L4

if20:                                             ; preds = %L4
  %25 = add i64 %"#temp#2.0", 1
  br label %L5

if21:                                             ; preds = %L5
  %26 = add i64 %"#temp#3.0", 1
  %27 = add i64 %"#temp#2.0", -1
  %28 = add i64 %"#temp#3.0", -1
  %29 = mul i64 %28, %17
  %tmp = add i64 %27, %29
  %tmp30 = mul i64 %tmp, %14
  %30 = add i64 %"#temp#1.0", -1
  %31 = add i64 %30, %tmp30
  %32 = getelementptr float, float* %11, i64 %31
  %33 = bitcast float* %32 to i32*
  %34 = load i32, i32* %33, align 4
  %35 = mul i64 %28, %9
  %tmp31 = add i64 %27, %35
  %tmp32 = mul i64 %tmp31, %6
  %36 = add i64 %30, %tmp32
  %37 = getelementptr float, float* %3, i64 %36
  %38 = bitcast float* %37 to i32*
  store i32 %34, i32* %38, align 4
  br label %L5
}

