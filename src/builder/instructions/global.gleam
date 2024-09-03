import builder/expression_builder.{type ExpressionBuilder}
import internal/structure/types.{type GlobalIDX, GlobalGet, GlobalSet}

pub fn get(builder: ExpressionBuilder, global_idx: GlobalIDX) {
  builder
  |> expression_builder.push(GlobalGet(global_idx))
}

pub fn set(builder: ExpressionBuilder, global_idx: GlobalIDX) {
  builder
  |> expression_builder.push(GlobalSet(global_idx))
}
