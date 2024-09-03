import internal/structure/types.{type FieldType, ArrayType}

pub fn new(field_type: FieldType) {
  ArrayType(field_type)
}
