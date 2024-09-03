import internal/finger_tree
import internal/structure/types.{type ValType, FuncType}

pub fn new(param_types: List(ValType), result_types: List(ValType)) {
  FuncType(
    finger_tree.from_list(param_types),
    finger_tree.from_list(result_types),
  )
}
