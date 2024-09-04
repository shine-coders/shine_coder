import builder/expression.{type ExpressionBuilder}
import internal/structure/types.{
  type ElemIDX, type TableIDX, TableCopy, TableFill, TableGet, TableGrow,
  TableInit, TableSet, TableSize,
}

pub fn get(builder: ExpressionBuilder, tidx: TableIDX) {
  builder
  |> expression.push(TableGet(tidx))
}

pub fn set(builder: ExpressionBuilder, tidx: TableIDX) {
  builder
  |> expression.push(TableSet(tidx))
}

pub fn size(builder: ExpressionBuilder, tidx: TableIDX) {
  builder
  |> expression.push(TableSize(tidx))
}

pub fn grow(builder: ExpressionBuilder, tidx: TableIDX) {
  builder
  |> expression.push(TableGrow(tidx))
}

pub fn fill(builder: ExpressionBuilder, tidx: TableIDX) {
  builder
  |> expression.push(TableFill(tidx))
}

pub fn copy(builder: ExpressionBuilder, tidx1: TableIDX, tidx2: TableIDX) {
  builder
  |> expression.push(TableCopy(tidx1, tidx2))
}

pub fn init(builder: ExpressionBuilder, elem: ElemIDX, tidx: TableIDX) {
  builder
  |> expression.push(TableInit(elem, tidx))
}
