import internal/structure/types.{type ValType, FuncType}

/// Create a FuncType from the given list of parameter types and result types
/// https://webassembly.github.io/gc/core/syntax/types.html#function-types
pub fn new(param_types: List(ValType), result_types: List(ValType)) {
  FuncType(param_types, result_types)
}
