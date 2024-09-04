import internal/structure/types.{type FieldType, ArrayType}

/// Create a new ArrayType that holds values of the type specified by field_type
pub fn new(field_type: FieldType) {
  ArrayType(field_type)
}
