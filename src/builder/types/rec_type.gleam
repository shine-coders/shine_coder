import internal/structure/types.{
  type FieldType, type FuncType, type StructType, type SubType, type ValType,
  ArrayCompositeType, ArrayType, FuncCompositeType, FuncType, RecType,
  StructCompositeType, StructType, SubType,
}

pub fn from_sub_types(sub_types: List(SubType)) {
  RecType(sub_types)
}

pub fn from_func_type(func_type: FuncType) {
  RecType([SubType(True, [], FuncCompositeType(func_type))])
}

pub fn func_type(parameters: List(ValType), results: List(ValType)) {
  RecType([SubType(True, [], FuncCompositeType(FuncType(parameters, results)))])
}

pub fn from_struct_type(struct_type: StructType) {
  RecType([SubType(True, [], StructCompositeType(struct_type))])
}

pub fn array_type(element_type: FieldType) {
  RecType([SubType(True, [], ArrayCompositeType(ArrayType(element_type)))])
}
