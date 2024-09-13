import builder/module
import internal/structure/types.{
  AnyHeapType, ArrayHeapType, ConcreteHeapType, EqHeapType, ExternHeapType,
  FuncHeapType, I31HeapType, NoExternHeapType, NoFuncHeapType, NoneHeapType,
  StructHeapType,
}
import visitor
import visitor/visit_test_variant
import gleam/option.{None}

pub fn visit_func_heap_type_test() {
  visit_test_variant.run(
    FuncHeapType,
    visitor.on_enter_heap_type,
    visitor.on_exit_heap_type,
    visitor.on_enter_func_heap_type,
    visitor.on_exit_func_heap_type,
    visitor.visit_heap_type,
    None,
  )
}

pub fn visit_no_func_heap_type_test() {
  visit_test_variant.run(
    NoFuncHeapType,
    visitor.on_enter_heap_type,
    visitor.on_exit_heap_type,
    visitor.on_enter_no_func_heap_type,
    visitor.on_exit_no_func_heap_type,
    visitor.visit_heap_type,
    None,
  )
}

pub fn visit_extern_heap_type_test() {
  visit_test_variant.run(
    ExternHeapType,
    visitor.on_enter_heap_type,
    visitor.on_exit_heap_type,
    visitor.on_enter_extern_heap_type,
    visitor.on_exit_extern_heap_type,
    visitor.visit_heap_type,
    None,
  )
}

pub fn visit_no_extern_heap_type_test() {
  visit_test_variant.run(
    NoExternHeapType,
    visitor.on_enter_heap_type,
    visitor.on_exit_heap_type,
    visitor.on_enter_no_extern_heap_type,
    visitor.on_exit_no_extern_heap_type,
    visitor.visit_heap_type,
    None,
  )
}

pub fn visit_any_heap_type_test() {
  visit_test_variant.run(
    AnyHeapType,
    visitor.on_enter_heap_type,
    visitor.on_exit_heap_type,
    visitor.on_enter_any_heap_type,
    visitor.on_exit_any_heap_type,
    visitor.visit_heap_type,
    None,
  )
}

pub fn visit_eq_heap_type_test() {
  visit_test_variant.run(
    EqHeapType,
    visitor.on_enter_heap_type,
    visitor.on_exit_heap_type,
    visitor.on_enter_eq_heap_type,
    visitor.on_exit_eq_heap_type,
    visitor.visit_heap_type,
    None,
  )
}

pub fn visit_i31_heap_type_test() {
  visit_test_variant.run(
    I31HeapType,
    visitor.on_enter_heap_type,
    visitor.on_exit_heap_type,
    visitor.on_enter_i31_heap_type,
    visitor.on_exit_i31_heap_type,
    visitor.visit_heap_type,
    None,
  )
}

pub fn visit_struct_heap_type_test() {
  visit_test_variant.run(
    StructHeapType,
    visitor.on_enter_heap_type,
    visitor.on_exit_heap_type,
    visitor.on_enter_struct_heap_type,
    visitor.on_exit_struct_heap_type,
    visitor.visit_heap_type,
    None,
  )
}

pub fn visit_array_heap_type_test() {
  visit_test_variant.run(
    ArrayHeapType,
    visitor.on_enter_heap_type,
    visitor.on_exit_heap_type,
    visitor.on_enter_array_heap_type,
    visitor.on_exit_array_heap_type,
    visitor.visit_heap_type,
    None,
  )
}

pub fn visit_none_heap_type_test() {
  visit_test_variant.run(
    NoneHeapType,
    visitor.on_enter_heap_type,
    visitor.on_exit_heap_type,
    visitor.on_enter_none_heap_type,
    visitor.on_exit_none_heap_type,
    visitor.visit_heap_type,
    None,
  )
}

pub fn visit_concrete_heap_type_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  visit_test_variant.run(
    ConcreteHeapType(type_idx),
    visitor.on_enter_heap_type,
    visitor.on_exit_heap_type,
    visitor.on_enter_concrete_heap_type,
    visitor.on_exit_concrete_heap_type,
    visitor.visit_heap_type,
    None,
  )
}
