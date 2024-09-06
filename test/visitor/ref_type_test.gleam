import internal/structure/types.{
  AnyRefType, ArrayRefType, EqRefType, ExternRefType, FuncRefType,
  HeapTypeRefType, I31HeapType, I31RefType, NoExternRefType, NoFuncRefType,
  NoneRefType, StructRefType,
}

import visitor
import visitor/visit_test_variant

pub fn visit_any_ref_type_test() {
  visit_test_variant.run(
    AnyRefType,
    visitor.on_enter_ref_type,
    visitor.on_exit_ref_type,
    visitor.on_enter_any_ref_type,
    visitor.on_exit_any_ref_type,
    visitor.visit_ref_type,
  )
}

pub fn visit_eq_ref_type_test() {
  visit_test_variant.run(
    EqRefType,
    visitor.on_enter_ref_type,
    visitor.on_exit_ref_type,
    visitor.on_enter_eq_ref_type,
    visitor.on_exit_eq_ref_type,
    visitor.visit_ref_type,
  )
}

pub fn visit_i31_ref_type_test() {
  visit_test_variant.run(
    I31RefType,
    visitor.on_enter_ref_type,
    visitor.on_exit_ref_type,
    visitor.on_enter_i31_ref_type,
    visitor.on_exit_i31_ref_type,
    visitor.visit_ref_type,
  )
}

pub fn visit_struct_ref_type_test() {
  visit_test_variant.run(
    StructRefType,
    visitor.on_enter_ref_type,
    visitor.on_exit_ref_type,
    visitor.on_enter_struct_ref_type,
    visitor.on_exit_struct_ref_type,
    visitor.visit_ref_type,
  )
}

pub fn visit_array_ref_type_test() {
  visit_test_variant.run(
    ArrayRefType,
    visitor.on_enter_ref_type,
    visitor.on_exit_ref_type,
    visitor.on_enter_array_ref_type,
    visitor.on_exit_array_ref_type,
    visitor.visit_ref_type,
  )
}

pub fn visit_func_ref_type_test() {
  visit_test_variant.run(
    FuncRefType,
    visitor.on_enter_ref_type,
    visitor.on_exit_ref_type,
    visitor.on_enter_func_ref_type,
    visitor.on_exit_func_ref_type,
    visitor.visit_ref_type,
  )
}

pub fn visit_extern_ref_type_test() {
  visit_test_variant.run(
    ExternRefType,
    visitor.on_enter_ref_type,
    visitor.on_exit_ref_type,
    visitor.on_enter_extern_ref_type,
    visitor.on_exit_extern_ref_type,
    visitor.visit_ref_type,
  )
}

pub fn visit_none_ref_type_test() {
  visit_test_variant.run(
    NoneRefType,
    visitor.on_enter_ref_type,
    visitor.on_exit_ref_type,
    visitor.on_enter_none_ref_type,
    visitor.on_exit_none_ref_type,
    visitor.visit_ref_type,
  )
}

pub fn visit_no_func_ref_type_test() {
  visit_test_variant.run(
    NoFuncRefType,
    visitor.on_enter_ref_type,
    visitor.on_exit_ref_type,
    visitor.on_enter_no_func_ref_type,
    visitor.on_exit_no_func_ref_type,
    visitor.visit_ref_type,
  )
}

pub fn visit_no_extern_ref_type_test() {
  visit_test_variant.run(
    NoExternRefType,
    visitor.on_enter_ref_type,
    visitor.on_exit_ref_type,
    visitor.on_enter_no_extern_ref_type,
    visitor.on_exit_no_extern_ref_type,
    visitor.visit_ref_type,
  )
}

pub fn visit_heap_type_ref_type_test() {
  let value = HeapTypeRefType(I31HeapType, False)
  visit_test_variant.run(
    value,
    visitor.on_enter_ref_type,
    visitor.on_exit_ref_type,
    visitor.on_enter_heap_type_ref_type,
    visitor.on_exit_heap_type_ref_type,
    visitor.visit_ref_type,
  )
}
