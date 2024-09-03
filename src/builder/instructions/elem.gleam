import builder/expression_builder.{type ExpressionBuilder}
import internal/structure/types.{type ElemIDX, ElemDrop}

pub fn drop(builder: ExpressionBuilder, elem_idx: ElemIDX) {
  builder
  |> expression_builder.push(ElemDrop(elem_idx))
}
