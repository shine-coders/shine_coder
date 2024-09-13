import internal/structure/types.{
  type FieldType, type FuncType, type StructType, type ValType,
  ArrayCompositeType, ArrayType, FuncCompositeType, FuncType,
  StructCompositeType, StructType,
}
import shine_tree

pub fn from_func_type(func_type: FuncType) {
  FuncCompositeType(func_type)
}

pub fn func_type(parameters: List(ValType), results: List(ValType)) {
  FuncCompositeType(FuncType(
    shine_tree.from_list(parameters),
    shine_tree.from_list(results),
  ))
}

pub fn struct_type(fields: List(FieldType)) {
  StructCompositeType(StructType(shine_tree.from_list(fields)))
}

pub fn from_struct_type(struct_type: StructType) {
  StructCompositeType(struct_type)
}

pub fn array_type(element_type: FieldType) {
  ArrayCompositeType(ArrayType(element_type))
}
