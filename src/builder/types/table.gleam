import gleam/option.{None, Some}
import internal/structure/types.{
  type Expr, type Limits, type RefType, type Table, Table, TableType,
}

pub fn new(ref_type: RefType, limits: Limits) {
  let type_ = TableType(ref_type, limits)
  Table(type_, None)
}

pub fn new_with_initializer(ref_type: RefType, limits: Limits, expr: Expr) {
  let type_ = TableType(ref_type, limits)
  Table(type_, Some(expr))
}
