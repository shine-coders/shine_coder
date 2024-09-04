import builder/expression.{type ExpressionBuilder}
import internal/structure/types.{AnyConvertExtern}

pub fn convert_extern(builder: ExpressionBuilder) {
  builder
  |> expression.push(AnyConvertExtern)
}
