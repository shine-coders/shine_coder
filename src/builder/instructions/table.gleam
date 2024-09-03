import builder/expression_builder.{type ExpressionBuilder}
import internal/structure/types.{
  type ElemIDX, type TableIDX, TableCopy, TableFill, TableGet, TableGrow,
  TableInit, TableSet, TableSize,
}

pub fn get(builder: ExpressionBuilder, tidx: TableIDX) {
  builder
  |> expression_builder.push(TableGet(tidx))
}

pub fn set(builder: ExpressionBuilder, tidx: TableIDX) {
  builder
  |> expression_builder.push(TableSet(tidx))
}

pub fn size(builder: ExpressionBuilder, tidx: TableIDX) {
  builder
  |> expression_builder.push(TableSize(tidx))
}

pub fn grow(builder: ExpressionBuilder, tidx: TableIDX) {
  builder
  |> expression_builder.push(TableGrow(tidx))
}

pub fn fill(builder: ExpressionBuilder, tidx: TableIDX) {
  builder
  |> expression_builder.push(TableFill(tidx))
}

pub fn copy(builder: ExpressionBuilder, tidx1: TableIDX, tidx2: TableIDX) {
  builder
  |> expression_builder.push(TableCopy(tidx1, tidx2))
}

pub fn init(builder: ExpressionBuilder, elem: ElemIDX, tidx: TableIDX) {
  builder
  |> expression_builder.push(TableInit(elem, tidx))
}
