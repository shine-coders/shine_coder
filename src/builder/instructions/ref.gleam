import builder/expression_builder.{type ExpressionBuilder}
import internal/structure/types.{
  type FuncIDX, type HeapType, RefAsNonNull, RefCast, RefCastNullable, RefEq,
  RefFunc, RefI31, RefIsNull, RefNull, RefTest, RefTestNullable,
}

pub fn as_non_null(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(RefAsNonNull)
}

pub fn cast(builder: ExpressionBuilder, heap_type: HeapType) {
  builder
  |> expression_builder.push(RefCast(heap_type))
}

pub fn cast_nullable(builder: ExpressionBuilder, heap_type: HeapType) {
  builder
  |> expression_builder.push(RefCastNullable(heap_type))
}

pub fn eq(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(RefEq)
}

pub fn func(builder: ExpressionBuilder, idx: FuncIDX) {
  builder
  |> expression_builder.push(RefFunc(idx))
}

pub fn i31(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(RefI31)
}

pub fn is_null(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(RefIsNull)
}

pub fn null(builder: ExpressionBuilder, ht: HeapType) {
  builder
  |> expression_builder.push(RefNull(ht))
}

pub fn test_(builder: ExpressionBuilder, heap_type: HeapType) {
  builder
  |> expression_builder.push(RefTest(heap_type))
}

pub fn test_nullable(builder: ExpressionBuilder, heap_type: HeapType) {
  builder
  |> expression_builder.push(RefTestNullable(heap_type))
}
