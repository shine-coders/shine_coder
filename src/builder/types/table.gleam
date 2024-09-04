import gleam/option.{None, Some}
import internal/structure/types.{
  type Expr, type Limits, type RefType, type Table, Table, TableType,
}

/// Create a new Table with the given `RefType` classifier and `Limits`
pub fn new(ref_type: RefType, limits: Limits) {
  let type_ = TableType(ref_type, limits)
  Table(type_, None)
}

/// Create a new Table with the given `RefType` classifier, `Limits` and init `Expr`
pub fn new_with_initializer(ref_type: RefType, limits: Limits, expr: Expr) {
  let type_ = TableType(ref_type, limits)
  Table(type_, Some(expr))
}
