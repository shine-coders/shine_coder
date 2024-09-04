import builder/expression.{type ExpressionBuilder}
import internal/structure/types.{
  type FieldIDX, type TypeIDX, StructGet, StructGetS, StructGetU, StructNew,
  StructNewDefault, StructSet,
}

pub fn new(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression.push(StructNew(idx))
}

pub fn new_default(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression.push(StructNewDefault(idx))
}

pub fn get(builder: ExpressionBuilder, tidx: TypeIDX, fidx: FieldIDX) {
  builder
  |> expression.push(StructGet(tidx, fidx))
}

pub fn get_s(builder: ExpressionBuilder, tidx: TypeIDX, fidx: FieldIDX) {
  builder
  |> expression.push(StructGetS(tidx, fidx))
}

pub fn get_u(builder: ExpressionBuilder, tidx: TypeIDX, fidx: FieldIDX) {
  builder
  |> expression.push(StructGetU(tidx, fidx))
}

pub fn set(builder: ExpressionBuilder, tidx: TypeIDX, fidx: FieldIDX) {
  builder
  |> expression.push(StructSet(tidx, fidx))
}
