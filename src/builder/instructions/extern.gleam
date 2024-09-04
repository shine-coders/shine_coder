import builder/expression.{type ExpressionBuilder}
import internal/structure/types.{ExternConvertAny}

pub fn convert_any(builder: ExpressionBuilder) {
  builder
  |> expression.push(ExternConvertAny)
}
