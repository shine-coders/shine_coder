import builder/module
import builder/types/block_type
import builder/types/val_type
import visitor
import visitor/visit_test_variant

pub fn visit_val_type_storage_type_test() {
  visit_test_variant.run(
    block_type.val_type(val_type.i32),
    visitor.on_enter_block_type,
    visitor.on_exit_block_type,
    visitor.on_enter_val_type_block_type,
    visitor.on_exit_val_type_block_type,
    visitor.visit_block_type,
  )
}

pub fn visit_void_block_type_test() {
  visit_test_variant.run(
    block_type.void,
    visitor.on_enter_block_type,
    visitor.on_exit_block_type,
    visitor.on_enter_void_block_type,
    visitor.on_exit_void_block_type,
    visitor.visit_block_type,
  )
}

pub fn visit_func_type_block_type_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  visit_test_variant.run(
    block_type.func_type(type_idx),
    visitor.on_enter_block_type,
    visitor.on_exit_block_type,
    visitor.on_enter_func_type_block_type,
    visitor.on_exit_func_type_block_type,
    visitor.visit_block_type,
  )
}
