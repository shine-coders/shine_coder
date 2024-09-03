//// https://webassembly.github.io/gc/core/syntax/types.html#syntax-fieldtype

import internal/structure/types.{
  type RefType, type TypeIDX, ConcreteHeapType, Const, F32ValType, F64ValType,
  FieldType, HeapTypeRefType, I16StorageType, I32ValType, I64ValType,
  I8StorageType, RefTypeValType, TypeIDX, V128ValType, ValTypeStorageType, Var,
}

/// An immutable i8 type
pub const i8 = FieldType(I8StorageType, Const)

/// A mutable i8 type
pub const i8_mut = FieldType(I8StorageType, Var)

/// An immutable i16 type
pub const i16 = FieldType(I16StorageType, Const)

/// A mutable i16 type
pub const i16_mut = FieldType(I16StorageType, Var)

/// An immutable i32 type
pub const i32 = FieldType(ValTypeStorageType(I32ValType), Const)

/// A mutable i32 type
pub const i32_mut = FieldType(ValTypeStorageType(I32ValType), Var)

/// An immutable i64 type
pub const i64 = FieldType(ValTypeStorageType(I64ValType), Const)

/// A mutable i64 type
pub const i64_mut = FieldType(ValTypeStorageType(I64ValType), Var)

/// An immutable f32 type
pub const f32 = FieldType(ValTypeStorageType(F32ValType), Const)

/// A mutable f32 type
pub const f32_mut = FieldType(ValTypeStorageType(F32ValType), Var)

/// An immutable f64 type
pub const f64 = FieldType(ValTypeStorageType(F64ValType), Const)

/// A mutable f64 type
pub const f64_mut = FieldType(ValTypeStorageType(F64ValType), Var)

/// An immutable v128 type
pub const v128 = FieldType(ValTypeStorageType(V128ValType), Const)

/// A mutable v128 type
pub const v128_mut = FieldType(ValTypeStorageType(V128ValType), Var)

/// Create an immutable FieldType from the given RefType classifier
pub fn from_ref_type(ref_type: RefType) {
  FieldType(ValTypeStorageType(RefTypeValType(ref_type)), Const)
}

/// Create a mutable FieldType from the given RefType classifier
pub fn from_ref_type_mut(ref_type: RefType) {
  FieldType(ValTypeStorageType(RefTypeValType(ref_type)), Var)
}

/// Create an immutable non-nullable field of type indexed by type_idx
///
/// Note: The TypeIDX cannot be a RecTypeIDX or DefTypeReference
pub fn from_type_index(type_idx: TypeIDX) {
  FieldType(
    ValTypeStorageType(
      RefTypeValType(HeapTypeRefType(ConcreteHeapType(type_idx), False)),
    ),
    Const,
  )
}

/// Create a mutable non-nullable field of type indexed by type_idx
///
/// Note: The TypeIDX cannot be a RecTypeIDX or DefTypeReference
pub fn from_type_index_mut(type_idx: TypeIDX) {
  FieldType(
    ValTypeStorageType(
      RefTypeValType(HeapTypeRefType(ConcreteHeapType(type_idx), False)),
    ),
    Var,
  )
}

/// Create an immutable nullable field of type indexed by type_idx
///
/// Note: The TypeIDX cannot be a RecTypeIDX or DefTypeReference
pub fn from_type_index_nullable(type_idx: TypeIDX) {
  FieldType(
    ValTypeStorageType(
      RefTypeValType(HeapTypeRefType(ConcreteHeapType(type_idx), True)),
    ),
    Const,
  )
}

/// Create a mutable nullable field of type indexed by type_idx
///
/// Note: The TypeIDX cannot be a RecTypeIDX or DefTypeReference
pub fn from_type_index_nullable_mut(type_idx: TypeIDX) {
  FieldType(
    ValTypeStorageType(
      RefTypeValType(HeapTypeRefType(ConcreteHeapType(type_idx), True)),
    ),
    Var,
  )
}
