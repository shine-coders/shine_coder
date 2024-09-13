import builder/types/storage_type
import gleam/option.{None}
import visitor
import visitor/visit_test_variant

pub fn visit_i8_storage_type_test() {
  visit_test_variant.run(
    storage_type.i8,
    visitor.on_enter_storage_type,
    visitor.on_exit_storage_type,
    visitor.on_enter_i8_storage_type,
    visitor.on_exit_i8_storage_type,
    visitor.visit_storage_type,
    None,
  )
}

pub fn visit_i16_storage_type_test() {
  visit_test_variant.run(
    storage_type.i16,
    visitor.on_enter_storage_type,
    visitor.on_exit_storage_type,
    visitor.on_enter_i16_storage_type,
    visitor.on_exit_i16_storage_type,
    visitor.visit_storage_type,
    None,
  )
}

pub fn visit_val_type_storage_type_test() {
  visit_test_variant.run(
    storage_type.i32,
    visitor.on_enter_storage_type,
    visitor.on_exit_storage_type,
    visitor.on_enter_val_type_storage_type,
    visitor.on_exit_val_type_storage_type,
    visitor.visit_storage_type,
    None,
  )
}
