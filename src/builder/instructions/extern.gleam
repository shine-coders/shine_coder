import builder/expression_builder.{type ExpressionBuilder}
import internal/structure/types.{ExternConvertAny}

pub fn convert_any(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(ExternConvertAny)
}
