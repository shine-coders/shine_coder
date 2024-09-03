import internal/finger_tree
import internal/structure/types.{
  type SubType, type ValType, FuncCompositeType, FuncType, RecType, SubType,
}

pub fn from_sub_types(sub_types: List(SubType)) {
  RecType(sub_types |> finger_tree.from_list)
}

pub fn func_type(parameters: List(ValType), results: List(ValType)) {
  RecType(
    finger_tree.from_list([
      SubType(
        True,
        finger_tree.new(),
        FuncCompositeType(FuncType(
          finger_tree.from_list(parameters),
          finger_tree.from_list(results),
        )),
      ),
    ]),
  )
}
