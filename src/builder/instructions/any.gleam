import builder/expression.{type ExpressionBuilder}
import internal/structure/types.{AnyConvertExtern}

/// Convert an external value to an anyref
pub fn convert_extern(builder: ExpressionBuilder) {
  builder
  |> expression.push(AnyConvertExtern)
}
