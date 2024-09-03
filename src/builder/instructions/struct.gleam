import builder/expression_builder.{type ExpressionBuilder}
import internal/structure/types.{
  type FieldIDX, type TypeIDX, StructGet, StructGetS, StructGetU, StructNew,
  StructNewDefault, StructSet,
}

pub fn new(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression_builder.push(StructNew(idx))
}

pub fn new_default(builder: ExpressionBuilder, idx: TypeIDX) {
  builder
  |> expression_builder.push(StructNewDefault(idx))
}

pub fn get(builder: ExpressionBuilder, tidx: TypeIDX, fidx: FieldIDX) {
  builder
  |> expression_builder.push(StructGet(tidx, fidx))
}

pub fn get_s(builder: ExpressionBuilder, tidx: TypeIDX, fidx: FieldIDX) {
  builder
  |> expression_builder.push(StructGetS(tidx, fidx))
}

pub fn get_u(builder: ExpressionBuilder, tidx: TypeIDX, fidx: FieldIDX) {
  builder
  |> expression_builder.push(StructGetU(tidx, fidx))
}

pub fn set(builder: ExpressionBuilder, tidx: TypeIDX, fidx: FieldIDX) {
  builder
  |> expression_builder.push(StructSet(tidx, fidx))
}
