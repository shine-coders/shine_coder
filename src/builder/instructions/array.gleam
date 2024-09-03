import builder/expression_builder.{type ExpressionBuilder}
import internal/structure/numbers.{type U32}
import internal/structure/types.{
  type DataIDX, type ElemIDX, type TypeIDX, ArrayCopy, ArrayFill, ArrayGet,
  ArrayGetS, ArrayGetU, ArrayInitData, ArrayInitElem, ArrayLen, ArrayNew,
  ArrayNewData, ArrayNewDefault, ArrayNewElem, ArrayNewFixed, ArraySet,
}

pub fn array_new(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression_builder.push(ArrayNew(idx))
}

pub fn array_new_default(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression_builder.push(ArrayNewDefault(idx))
}

pub fn array_new_data(builder: ExpressionBuilder, idx: TypeIDX, data: DataIDX) {
  builder
  |> expression_builder.push(ArrayNewData(idx, data))
}

pub fn array_new_elem(builder: ExpressionBuilder, idx: TypeIDX, elem: ElemIDX) {
  builder
  |> expression_builder.push(ArrayNewElem(idx, elem))
}

pub fn array_new_fixed(builder: ExpressionBuilder, idx: TypeIDX, size: U32) {
  builder
  |> expression_builder.push(ArrayNewFixed(idx, size))
}

pub fn array_get(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression_builder.push(ArrayGet(idx))
}

pub fn array_get_s(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression_builder.push(ArrayGetS(idx))
}

pub fn array_get_u(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression_builder.push(ArrayGetU(idx))
}

pub fn array_set(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression_builder.push(ArraySet(idx))
}

pub fn array_len(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(ArrayLen)
}

pub fn array_fill(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression_builder.push(ArrayFill(idx))
}

pub fn array_copy(builder: ExpressionBuilder, idx1: TypeIDX, idx2: TypeIDX) {
  builder
  |> expression_builder.push(ArrayCopy(idx1, idx2))
}

pub fn array_init_data(builder: ExpressionBuilder, idx: TypeIDX, data: DataIDX) {
  builder
  |> expression_builder.push(ArrayInitData(idx, data))
}

pub fn array_init_elem(builder: ExpressionBuilder, idx: TypeIDX, elem: ElemIDX) {
  builder
  |> expression_builder.push(ArrayInitElem(idx, elem))
}
