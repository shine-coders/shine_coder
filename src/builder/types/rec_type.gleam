import internal/structure/types.{
  type FieldType, type FuncType, type StructType, type SubType, type ValType,
  ArrayCompositeType, ArrayType, FuncCompositeType, FuncType, RecType,
  StructCompositeType, StructType, SubType,
}
import shine_tree

pub fn from_sub_types(sub_types: List(SubType)) {
  RecType(sub_types |> shine_tree.from_list)
}

pub fn from_func_type(func_type: FuncType) {
  RecType(
    shine_tree.from_list([
      SubType(True, shine_tree.empty, FuncCompositeType(func_type)),
    ]),
  )
}

pub fn func_type(parameters: List(ValType), results: List(ValType)) {
  RecType(
    shine_tree.from_list([
      SubType(
        True,
        shine_tree.empty,
        FuncCompositeType(FuncType(
          shine_tree.from_list(parameters),
          shine_tree.from_list(results),
        )),
      ),
    ]),
  )
}

pub fn from_struct_type(struct_type: StructType) {
  RecType(
    shine_tree.from_list([
      SubType(True, shine_tree.empty, StructCompositeType(struct_type)),
    ]),
  )
}

pub fn array_type(element_type: FieldType) {
  RecType(
    shine_tree.from_list([
      SubType(
        True,
        shine_tree.empty,
        ArrayCompositeType(ArrayType(element_type)),
      ),
    ]),
  )
}
