import internal/structure/types.{
  type RefType, type TypeIDX, ConcreteHeapType, Const, F32ValType, F64ValType,
  FieldType, HeapTypeRefType, I16StorageType, I32ValType, I64ValType,
  I8StorageType, RefTypeValType, TypeIDX, V128ValType, ValTypeStorageType, Var,
}

pub const i8 = FieldType(I8StorageType, Const)

pub const i8_mut = FieldType(I8StorageType, Var)

pub const i16 = FieldType(I16StorageType, Const)

pub const i16_mut = FieldType(I16StorageType, Var)

pub const i32 = FieldType(ValTypeStorageType(I32ValType), Const)

pub const i32_mut = FieldType(ValTypeStorageType(I32ValType), Var)

pub const i64 = FieldType(ValTypeStorageType(I64ValType), Const)

pub const i64_mut = FieldType(ValTypeStorageType(I64ValType), Var)

pub const f32 = FieldType(ValTypeStorageType(F32ValType), Const)

pub const f32_mut = FieldType(ValTypeStorageType(F32ValType), Var)

pub const f64 = FieldType(ValTypeStorageType(F64ValType), Const)

pub const f64_mut = FieldType(ValTypeStorageType(F64ValType), Var)

pub const v128 = FieldType(ValTypeStorageType(V128ValType), Const)

pub const v128_mut = FieldType(ValTypeStorageType(V128ValType), Var)

pub fn from_ref_type(ref_type: RefType) {
  FieldType(ValTypeStorageType(RefTypeValType(ref_type)), Const)
}

pub fn from_ref_type_mut(ref_type: RefType) {
  FieldType(ValTypeStorageType(RefTypeValType(ref_type)), Var)
}

pub fn from_type_index(type_idx: TypeIDX) {
  FieldType(
    ValTypeStorageType(
      RefTypeValType(HeapTypeRefType(ConcreteHeapType(type_idx), False)),
    ),
    Const,
  )
}

pub fn from_type_index_mut(type_idx: TypeIDX) {
  FieldType(
    ValTypeStorageType(
      RefTypeValType(HeapTypeRefType(ConcreteHeapType(type_idx), False)),
    ),
    Var,
  )
}

pub fn from_type_index_nullable(type_idx: TypeIDX) {
  FieldType(
    ValTypeStorageType(
      RefTypeValType(HeapTypeRefType(ConcreteHeapType(type_idx), True)),
    ),
    Const,
  )
}

pub fn from_type_index_nullable_mut(type_idx: TypeIDX) {
  FieldType(
    ValTypeStorageType(
      RefTypeValType(HeapTypeRefType(ConcreteHeapType(type_idx), True)),
    ),
    Var,
  )
}
