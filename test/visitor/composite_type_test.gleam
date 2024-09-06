import builder/types/composite_type
import builder/types/field_type

import visitor
import visitor/visit_test_variant

pub fn visit_func_composite_type() {
  let func_type = composite_type.func_type([], [])
  visit_test_variant.run(
    func_type,
    visitor.on_enter_composite_type,
    visitor.on_exit_composite_type,
    visitor.on_enter_func_composite_type,
    visitor.on_exit_func_composite_type,
    visitor.visit_composite_type,
  )
}

pub fn visit_struct_composite_type() {
  let struct_type = composite_type.struct_type([])
  visit_test_variant.run(
    struct_type,
    visitor.on_enter_composite_type,
    visitor.on_exit_composite_type,
    visitor.on_enter_struct_composite_type,
    visitor.on_exit_struct_composite_type,
    visitor.visit_composite_type,
  )
}

pub fn visit_array_composite_type() {
  // I cleaned up the imports :)
  // I can take any random type I want, right?
  // Well... for now I'll take i16
  let array_type = composite_type.array_type(field_type.i16)
  visit_test_variant.run(
    array_type,
    visitor.on_enter_composite_type,
    visitor.on_exit_composite_type,
    visitor.on_enter_array_composite_type,
    visitor.on_exit_array_composite_type,
    visitor.visit_composite_type,
  )
}
