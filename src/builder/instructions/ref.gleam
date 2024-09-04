import builder/expression.{type ExpressionBuilder}
import internal/structure/types.{
  type FuncIDX, type HeapType, RefAsNonNull, RefCast, RefCastNullable, RefEq,
  RefFunc, RefI31, RefIsNull, RefNull, RefTest, RefTestNullable,
}

pub fn as_non_null(builder: ExpressionBuilder) {
  builder
  |> expression.push(RefAsNonNull)
}

pub fn cast(builder: ExpressionBuilder, heap_type: HeapType) {
  builder
  |> expression.push(RefCast(heap_type))
}

pub fn cast_nullable(builder: ExpressionBuilder, heap_type: HeapType) {
  builder
  |> expression.push(RefCastNullable(heap_type))
}

pub fn eq(builder: ExpressionBuilder) {
  builder
  |> expression.push(RefEq)
}

pub fn func(builder: ExpressionBuilder, idx: FuncIDX) {
  builder
  |> expression.push(RefFunc(idx))
}

pub fn i31(builder: ExpressionBuilder) {
  builder
  |> expression.push(RefI31)
}

pub fn is_null(builder: ExpressionBuilder) {
  builder
  |> expression.push(RefIsNull)
}

pub fn null(builder: ExpressionBuilder, ht: HeapType) {
  builder
  |> expression.push(RefNull(ht))
}

pub fn test_(builder: ExpressionBuilder, heap_type: HeapType) {
  builder
  |> expression.push(RefTest(heap_type))
}

pub fn test_nullable(builder: ExpressionBuilder, heap_type: HeapType) {
  builder
  |> expression.push(RefTestNullable(heap_type))
}
