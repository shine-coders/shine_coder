import internal/structure/types.{
  type RefType, BotValType, F32ValType, F64ValType, I32ValType, I64ValType,
  RefTypeValType, V128ValType,
}

pub const v128 = V128ValType

pub const i32 = I32ValType

pub const i64 = I64ValType

pub const f32 = F32ValType

pub const f64 = F64ValType

pub const bot = BotValType

pub fn from_ref_type(ref_type: RefType) {
  RefTypeValType(ref_type)
}
