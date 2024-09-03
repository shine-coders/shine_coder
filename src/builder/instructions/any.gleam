import builder/expression_builder.{type ExpressionBuilder}
import internal/structure/types.{AnyConvertExtern}

pub fn convert_extern(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(AnyConvertExtern)
}
