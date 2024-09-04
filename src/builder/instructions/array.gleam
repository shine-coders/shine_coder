import builder/expression.{type ExpressionBuilder}
import internal/structure/numbers.{type U32}
import internal/structure/types.{
  type DataIDX, type ElemIDX, type TypeIDX, ArrayCopy, ArrayFill, ArrayGet,
  ArrayGetS, ArrayGetU, ArrayInitData, ArrayInitElem, ArrayLen, ArrayNew,
  ArrayNewData, ArrayNewDefault, ArrayNewElem, ArrayNewFixed, ArraySet,
}

pub fn array_new(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression.push(ArrayNew(idx))
}

pub fn array_new_default(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression.push(ArrayNewDefault(idx))
}

pub fn array_new_data(builder: ExpressionBuilder, idx: TypeIDX, data: DataIDX) {
  builder
  |> expression.push(ArrayNewData(idx, data))
}

pub fn array_new_elem(builder: ExpressionBuilder, idx: TypeIDX, elem: ElemIDX) {
  builder
  |> expression.push(ArrayNewElem(idx, elem))
}

pub fn array_new_fixed(builder: ExpressionBuilder, idx: TypeIDX, size: U32) {
  builder
  |> expression.push(ArrayNewFixed(idx, size))
}

pub fn array_get(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression.push(ArrayGet(idx))
}

pub fn array_get_s(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression.push(ArrayGetS(idx))
}

pub fn array_get_u(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression.push(ArrayGetU(idx))
}

pub fn array_set(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression.push(ArraySet(idx))
}

pub fn array_len(builder: ExpressionBuilder) {
  builder
  |> expression.push(ArrayLen)
}

pub fn array_fill(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression.push(ArrayFill(idx))
}

pub fn array_copy(builder: ExpressionBuilder, idx1: TypeIDX, idx2: TypeIDX) {
  builder
  |> expression.push(ArrayCopy(idx1, idx2))
}

pub fn array_init_data(builder: ExpressionBuilder, idx: TypeIDX, data: DataIDX) {
  builder
  |> expression.push(ArrayInitData(idx, data))
}

pub fn array_init_elem(builder: ExpressionBuilder, idx: TypeIDX, elem: ElemIDX) {
  builder
  |> expression.push(ArrayInitElem(idx, elem))
}
