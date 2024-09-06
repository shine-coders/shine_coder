import internal/finger_tree
import internal/structure/types.{
  type FieldType, type FuncType, type StructType, type ValType,
  ArrayCompositeType, ArrayType, FuncCompositeType, FuncType,
  StructCompositeType, StructType,
}

pub fn from_func_type(func_type: FuncType) {
  FuncCompositeType(func_type)
}

pub fn func_type(parameters: List(ValType), results: List(ValType)) {
  FuncCompositeType(FuncType(
    finger_tree.from_list(parameters),
    finger_tree.from_list(results),
  ))
}

pub fn struct_type(fields: List(FieldType)) {
  StructCompositeType(StructType(finger_tree.from_list(fields)))
}

pub fn from_struct_type(struct_type: StructType) {
  StructCompositeType(struct_type)
}

pub fn array_type(element_type: FieldType) {
  ArrayCompositeType(ArrayType(element_type))
}
