import internal/finger_tree
import internal/structure/types.{
  type FieldType, type StructType, type SubType, type ValType,
  ArrayCompositeType, ArrayType, FuncCompositeType, FuncType, RecType,
  StructCompositeType, StructType, SubType,
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

pub fn from_struct_type(struct_type: StructType) {
  RecType(
    finger_tree.from_list([
      SubType(True, finger_tree.new(), StructCompositeType(struct_type)),
    ]),
  )
}

pub fn array_type(element_type: FieldType) {
  RecType(
    finger_tree.from_list([
      SubType(
        True,
        finger_tree.new(),
        ArrayCompositeType(ArrayType(element_type)),
      ),
    ]),
  )
}
