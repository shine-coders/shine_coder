import internal/structure/types.{type Expr, type ValType, Global, GlobalType, Const, Var}

pub fn new(type_: ValType, expr: Expr) {
  let type_ = GlobalType(type_, Const)
  Global(type_, expr)
}

pub fn new_mutable(type_: ValType, expr: Expr) {
  let type_ = GlobalType(type_, Var)
  Global(type_, expr)
}
