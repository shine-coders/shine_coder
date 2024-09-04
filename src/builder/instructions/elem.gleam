import builder/expression.{type ExpressionBuilder}
import internal/structure/types.{type ElemIDX, ElemDrop}

pub fn drop(builder: ExpressionBuilder, elem_idx: ElemIDX) {
  builder
  |> expression.push(ElemDrop(elem_idx))
}
