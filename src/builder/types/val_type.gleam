import internal/structure/types.{
  type RefType, BotValType, F32ValType, F64ValType, I32ValType, I64ValType,
  RefTypeValType, V128ValType,
}

/// A ValType of type `v128`
pub const v128 = V128ValType

/// A ValType of type `i32`
pub const i32 = I32ValType

/// A ValType of type `i64`
pub const i64 = I64ValType

/// A ValType of type `f32`
pub const f32 = F32ValType

/// A ValType of type `f64`
pub const f64 = F64ValType

/// A ValType of type `bot`
pub const bot = BotValType

/// Create a ValType from the given `RefType` classifier
pub fn from_ref_type(ref_type: RefType) {
  RefTypeValType(ref_type)
}
