import internal/structure/types.{
  F32ValType, F64ValType, I16StorageType, I32ValType, I64ValType, I8StorageType,
  RefTypeValType, V128ValType, ValTypeStorageType,
  type RefType,
}

pub const i8 = I8StorageType

pub const i16 = I16StorageType

pub const i32 = ValTypeStorageType(I32ValType)

pub const i64 = ValTypeStorageType(I64ValType)

pub const f32 = ValTypeStorageType(F32ValType)

pub const f64 = ValTypeStorageType(F64ValType)

pub const v128 = ValTypeStorageType(V128ValType)

pub fn ref_type(ref_type: RefType) {
  ValTypeStorageType(RefTypeValType(ref_type))
}
