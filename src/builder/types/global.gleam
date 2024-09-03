//// https://webassembly.github.io/gc/core/syntax/modules.html#globals

import internal/structure/types.{
  type Expr, type ValType, Const, Global, GlobalType, Var,
}

/// Create an immutable `Global` with the given `ValType` and init `Expr`
pub fn new(type_: ValType, expr: Expr) {
  let type_ = GlobalType(type_, Const)
  Global(type_, expr)
}

/// Create a mutable `Global` with the given `ValType` and init `Expr`
pub fn new_mutable(type_: ValType, expr: Expr) {
  let type_ = GlobalType(type_, Var)
  Global(type_, expr)
}
