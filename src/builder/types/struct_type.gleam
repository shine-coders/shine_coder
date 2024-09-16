import gleam/list
import internal/structure/types.{
  type RefType, type StructType, type TypeIDX, ConcreteHeapType, Const,
  F32ValType, F64ValType, FieldType, HeapTypeRefType, I16StorageType, I32ValType,
  I64ValType, I8StorageType, RefTypeValType, StructType, TypeIDX, V128ValType,
  ValTypeStorageType, Var,
}

/// Create an empty Struct type
/// https://webassembly.github.io/gc/core/syntax/types.html#aggregate-types
pub fn new() {
  StructType([])
}

/// Add an immutable `i8` field to the struct
pub fn i8_field(struct_type: StructType) {
  StructType(list.append(struct_type.ft, [FieldType(I8StorageType, Const)]))
}

/// Add a mutable `i8` field to the struct
pub fn i8_mut_field(struct_type: StructType) {
  StructType(
    struct_type.ft
    |> list.append([FieldType(I8StorageType, Var)]),
  )
}

/// Add an immutable `i16` field to the struct
pub fn i16_field(struct_type: StructType) {
  StructType(
    struct_type.ft
    |> list.append([FieldType(I16StorageType, Const)]),
  )
}

/// Add a mutable `i16` field to the struct
pub fn i16_mut_field(struct_type: StructType) {
  StructType(
    struct_type.ft
    |> list.append([FieldType(I16StorageType, Var)]),
  )
}

/// Add an immutable `i32` field to the struct
pub fn i32_field(struct_type: StructType) {
  StructType(
    struct_type.ft
    |> list.append([FieldType(ValTypeStorageType(I32ValType), Const)]),
  )
}

/// Add a mutable `i32` field to the struct
pub fn i32_mut_field(struct_type: StructType) {
  StructType(
    struct_type.ft
    |> list.append([FieldType(ValTypeStorageType(I32ValType), Var)]),
  )
}

/// Add an immutable `i64` field to the struct
pub fn i64_field(struct_type: StructType) {
  StructType(
    struct_type.ft
    |> list.append([FieldType(ValTypeStorageType(I64ValType), Const)]),
  )
}

/// Add a mutable `i64` field to the struct
pub fn i64_mut_field(struct_type: StructType) {
  StructType(
    struct_type.ft
    |> list.append([FieldType(ValTypeStorageType(I64ValType), Var)]),
  )
}

/// Add an immutable `f32` field to the struct
pub fn f32_field(struct_type: StructType) {
  StructType(
    struct_type.ft
    |> list.append([FieldType(ValTypeStorageType(F32ValType), Const)]),
  )
}

/// Add a mutable `f32` field to the struct
pub fn f32_mut_field(struct_type: StructType) {
  StructType(
    struct_type.ft
    |> list.append([FieldType(ValTypeStorageType(F32ValType), Var)]),
  )
}

/// Add an immutable `f64` field to the struct
pub fn f64_field(struct_type: StructType) {
  StructType(
    struct_type.ft
    |> list.append([FieldType(ValTypeStorageType(F64ValType), Const)]),
  )
}

/// Add a mutable `f64` field to the struct
pub fn f64_mut_field(struct_type: StructType) {
  StructType(
    struct_type.ft
    |> list.append([FieldType(ValTypeStorageType(F64ValType), Var)]),
  )
}

/// Add an immutable `v128` field to the struct
pub fn v128_field(struct_type: StructType) {
  StructType(
    struct_type.ft
    |> list.append([FieldType(ValTypeStorageType(V128ValType), Const)]),
  )
}

/// Add a mutable `v128` field to the struct
pub fn v128_mut_field(struct_type: StructType) {
  StructType(
    struct_type.ft
    |> list.append([FieldType(ValTypeStorageType(V128ValType), Var)]),
  )
}

/// Add an immutable `RefType` field to the struct
pub fn from_ref_type_field(struct_type: StructType, ref_type: RefType) {
  StructType(
    struct_type.ft
    |> list.append([
      FieldType(ValTypeStorageType(RefTypeValType(ref_type)), Const),
    ]),
  )
}

/// Add a mutable `RefType` field to the struct
pub fn from_ref_type_mut_field(struct_type: StructType, ref_type: RefType) {
  StructType(
    struct_type.ft
    |> list.append([
      FieldType(ValTypeStorageType(RefTypeValType(ref_type)), Var),
    ]),
  )
}

/// Add an immutable non-nullable field of type indexed by type_idx to the struct
///
/// Note: The `TypeIDX` cannot be a `RecTypeIDX` or `DefTypeReference`
pub fn from_type_index_field(struct_type: StructType, type_idx: TypeIDX) {
  StructType(
    struct_type.ft
    |> list.append([
      FieldType(
        ValTypeStorageType(
          RefTypeValType(HeapTypeRefType(ConcreteHeapType(type_idx), False)),
        ),
        Const,
      ),
    ]),
  )
}

/// Add a mutable non-nullable field of type indexed by type_idx to the struct
///
/// Note: The `TypeIDX` cannot be a `RecTypeIDX` or `DefTypeReference`
pub fn from_type_index_mut_field(struct_type: StructType, type_idx: TypeIDX) {
  StructType(
    struct_type.ft
    |> list.append([
      FieldType(
        ValTypeStorageType(
          RefTypeValType(HeapTypeRefType(ConcreteHeapType(type_idx), False)),
        ),
        Var,
      ),
    ]),
  )
}

/// Add an immutable nullable field of type indexed by type_idx to the struct
///
/// Note: The `TypeIDX` cannot be a `RecTypeIDX` or `DefTypeReference`
pub fn from_type_index_nullable_field(
  struct_type: StructType,
  type_idx: TypeIDX,
) {
  StructType(
    struct_type.ft
    |> list.append([
      FieldType(
        ValTypeStorageType(
          RefTypeValType(HeapTypeRefType(ConcreteHeapType(type_idx), True)),
        ),
        Const,
      ),
    ]),
  )
}

/// Add a mutable nullable field of type indexed by type_idx to the struct
///
/// Note: The `TypeIDX` cannot be a `RecTypeIDX` or `DefTypeReference`
pub fn from_type_index_nullable_mut_field(
  struct_type: StructType,
  type_idx: TypeIDX,
) {
  StructType(
    struct_type.ft
    |> list.append([
      FieldType(
        ValTypeStorageType(
          RefTypeValType(HeapTypeRefType(ConcreteHeapType(type_idx), True)),
        ),
        Var,
      ),
    ]),
  )
}
