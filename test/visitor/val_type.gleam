import internal/structure/types.{
  F32ValType, F64ValType, I31RefType, I32ValType, I64ValType, RefTypeValType,
  V128ValType,
}
import gleam/option.{None}
import visitor
import visitor/visit_test_variant

pub fn visit_v128_val_type_test() {
  let value = V128ValType
  visit_test_variant.run(
    value,
    visitor.on_enter_val_type,
    visitor.on_exit_val_type,
    visitor.on_enter_v128_val_type,
    visitor.on_exit_v128_val_type,
    visitor.visit_val_type,
    None,
  )
}

pub fn visit_i32_val_type_test() {
  let value = I32ValType
  visit_test_variant.run(
    value,
    visitor.on_enter_val_type,
    visitor.on_exit_val_type,
    visitor.on_enter_i32_val_type,
    visitor.on_exit_i32_val_type,
    visitor.visit_val_type,
    None,
  )
}

pub fn visit_i64_val_type_test() {
  let value = I64ValType
  visit_test_variant.run(
    value,
    visitor.on_enter_val_type,
    visitor.on_exit_val_type,
    visitor.on_enter_i64_val_type,
    visitor.on_exit_i64_val_type,
    visitor.visit_val_type,
    None,
  )
}

pub fn visit_f32_val_type_test() {
  let value = F32ValType
  visit_test_variant.run(
    value,
    visitor.on_enter_val_type,
    visitor.on_exit_val_type,
    visitor.on_enter_f32_val_type,
    visitor.on_exit_f32_val_type,
    visitor.visit_val_type,
    None,
  )
}

pub fn visit_f64_val_type_test() {
  let value = F64ValType
  visit_test_variant.run(
    value,
    visitor.on_enter_val_type,
    visitor.on_exit_val_type,
    visitor.on_enter_f64_val_type,
    visitor.on_exit_f64_val_type,
    visitor.visit_val_type,
    None,
  )
}

pub fn visit_ref_type_val_type_test() {
  let value = RefTypeValType(I31RefType)
  visit_test_variant.run(
    value,
    visitor.on_enter_val_type,
    visitor.on_exit_val_type,
    visitor.on_enter_ref_type_val_type,
    visitor.on_exit_ref_type_val_type,
    visitor.visit_val_type,
    None,
  )
}
