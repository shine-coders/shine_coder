import builder/expression_builder.{type ExpressionBuilder}
import internal/structure/types.{type DataIDX, DataDrop}

pub fn drop(builder: ExpressionBuilder, data_idx: DataIDX) {
  builder
  |> expression_builder.push(DataDrop(data_idx))
}
