import builder/expression.{type ExpressionBuilder}
import internal/structure/types.{type DataIDX, DataDrop}

pub fn drop(builder: ExpressionBuilder, data_idx: DataIDX) {
  builder
  |> expression.push(DataDrop(data_idx))
}
