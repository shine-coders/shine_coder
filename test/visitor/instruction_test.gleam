import builder/expression
import builder/instructions/control
import builder/instructions/i32
import builder/module
import builder/types/block_type
import gleam/option.{None}
import internal/structure/types.{
  ArrayCopy, ArrayFill, ArrayGet, ArrayGetS, ArrayGetU, ArrayInitData,
  ArrayInitElem, ArrayNew, ArrayNewData, ArrayNewDefault, ArrayNewElem,
  ArrayNewFixed, ArraySet, Block, Br, BrIf, BrOnCast, BrOnCastFail, BrOnNonNull,
  BrOnNull, BrTable, Call, CallIndirect, CallRef, DataDrop, ElemDrop, F32ValType,
  F64ValType, GlobalGet, GlobalSet, I31HeapType, I31RefType, I32ValType,
  I64ValType, If, LocalGet, LocalSet, LocalTee, Loop, MemoryInit, Nop, RefCast,
  RefCastNullable, RefFunc, RefNull, RefTest, RefTestNullable, ReturnCall,
  ReturnCallIndirect, ReturnCallRef, SelectT, StructGet, StructGetS, StructGetU,
  StructSet, TableCopy, TableFill, TableGet, TableGrow, TableInit, TableSet,
  TableSize,
}
import values
import visitor
import visitor/visit_test_variant

pub fn visit_ref_null_test() {
  let heap_type = I31HeapType
  visit_test_variant.run(
    RefNull(heap_type),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_ref_null,
    visitor.on_exit_ref_null,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_ref_func_test() {
  let assert Ok(func_idx) = module.func_idx(42)
  visit_test_variant.run(
    RefFunc(func_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_ref_func,
    visitor.on_exit_ref_func,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_ref_test_test() {
  let heap_type = I31HeapType
  visit_test_variant.run(
    RefTest(heap_type),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_ref_test,
    visitor.on_exit_ref_test,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_ref_test_nullable_test() {
  let heap_type = I31HeapType
  visit_test_variant.run(
    RefTestNullable(heap_type),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_ref_test_nullable,
    visitor.on_exit_ref_test_nullable,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_ref_cast_test() {
  let heap_type = I31HeapType
  visit_test_variant.run(
    RefCast(heap_type),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_ref_cast,
    visitor.on_exit_ref_cast,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_ref_cast_nullable_test() {
  let heap_type = I31HeapType
  visit_test_variant.run(
    RefCastNullable(heap_type),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_ref_cast_nullable,
    visitor.on_exit_ref_cast_nullable,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_struct_get_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  let assert Ok(field_idx) = module.field_idx(12)
  visit_test_variant.run(
    StructGet(type_idx, field_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_struct_get,
    visitor.on_exit_struct_get,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_struct_get_s_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  let assert Ok(field_idx) = module.field_idx(12)
  visit_test_variant.run(
    StructGetS(type_idx, field_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_struct_get_s,
    visitor.on_exit_struct_get_s,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_struct_get_u_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  let assert Ok(field_idx) = module.field_idx(12)
  visit_test_variant.run(
    StructGetU(type_idx, field_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_struct_get_u,
    visitor.on_exit_struct_get_u,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_struct_set_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  let assert Ok(field_idx) = module.field_idx(12)
  visit_test_variant.run(
    StructSet(type_idx, field_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_struct_set,
    visitor.on_exit_struct_set,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_array_new_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  visit_test_variant.run(
    ArrayNew(type_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_array_new,
    visitor.on_exit_array_new,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_array_new_default_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  visit_test_variant.run(
    ArrayNewDefault(type_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_array_new_default,
    visitor.on_exit_array_new_default,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_array_new_data_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  let assert Ok(data_idx) = module.data_idx(12)
  visit_test_variant.run(
    ArrayNewData(type_idx, data_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_array_new_data,
    visitor.on_exit_array_new_data,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_array_new_elem_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  let assert Ok(elem_idx) = module.elem_idx(12)
  visit_test_variant.run(
    ArrayNewElem(type_idx, elem_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_array_new_elem,
    visitor.on_exit_array_new_elem,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_array_new_fixed_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  let assert Ok(size) = values.u32(12)
  visit_test_variant.run(
    ArrayNewFixed(type_idx, size),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_array_new_fixed,
    visitor.on_exit_array_new_fixed,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_array_get_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  visit_test_variant.run(
    ArrayGet(type_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_array_get,
    visitor.on_exit_array_get,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_array_get_s_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  visit_test_variant.run(
    ArrayGetS(type_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_array_get_s,
    visitor.on_exit_array_get_s,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_array_get_u_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  visit_test_variant.run(
    ArrayGetU(type_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_array_get_u,
    visitor.on_exit_array_get_u,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_array_set_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  visit_test_variant.run(
    ArraySet(type_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_array_set,
    visitor.on_exit_array_set,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_array_fill_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  visit_test_variant.run(
    ArrayFill(type_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_array_fill,
    visitor.on_exit_array_fill,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_array_copy_test() {
  let assert Ok(type_idx1) = module.type_idx(42)
  let assert Ok(type_idx2) = module.type_idx(43)
  visit_test_variant.run(
    ArrayCopy(type_idx1, type_idx2),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_array_copy,
    visitor.on_exit_array_copy,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_array_init_data_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  let assert Ok(data_idx) = module.data_idx(12)
  visit_test_variant.run(
    ArrayInitData(type_idx, data_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_array_init_data,
    visitor.on_exit_array_init_data,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_array_init_elem_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  let assert Ok(elem_idx) = module.elem_idx(12)
  visit_test_variant.run(
    ArrayInitElem(type_idx, elem_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_array_init_elem,
    visitor.on_exit_array_init_elem,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_select_t_test() {
  let val_types = [I32ValType, I64ValType, F32ValType, F64ValType]

  visit_test_variant.run(
    SelectT(val_types),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_select_t,
    visitor.on_exit_select_t,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_local_get_test() {
  let assert Ok(local_idx) = module.local_idx(42)
  visit_test_variant.run(
    LocalGet(local_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_local_get,
    visitor.on_exit_local_get,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_local_set_test() {
  let assert Ok(local_idx) = module.local_idx(42)
  visit_test_variant.run(
    LocalSet(local_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_local_set,
    visitor.on_exit_local_set,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_local_tee_test() {
  let assert Ok(local_idx) = module.local_idx(42)
  visit_test_variant.run(
    LocalTee(local_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_local_tee,
    visitor.on_exit_local_tee,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_global_get_test() {
  let assert Ok(global_idx) = module.global_idx(42)
  visit_test_variant.run(
    GlobalGet(global_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_global_get,
    visitor.on_exit_global_get,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_global_set_test() {
  let assert Ok(global_idx) = module.global_idx(42)
  visit_test_variant.run(
    GlobalSet(global_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_global_set,
    visitor.on_exit_global_set,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_table_get_test() {
  let assert Ok(table_idx) = module.table_idx(42)
  visit_test_variant.run(
    TableGet(table_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_table_get,
    visitor.on_exit_table_get,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_table_set_test() {
  let assert Ok(table_idx) = module.table_idx(42)
  visit_test_variant.run(
    TableSet(table_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_table_set,
    visitor.on_exit_table_set,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_table_size_test() {
  let assert Ok(table_idx) = module.table_idx(42)
  visit_test_variant.run(
    TableSize(table_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_table_size,
    visitor.on_exit_table_size,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_table_grow_test() {
  let assert Ok(table_idx) = module.table_idx(42)
  visit_test_variant.run(
    TableGrow(table_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_table_grow,
    visitor.on_exit_table_grow,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_table_fill_test() {
  let assert Ok(table_idx) = module.table_idx(42)
  visit_test_variant.run(
    TableFill(table_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_table_fill,
    visitor.on_exit_table_fill,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_table_copy_test() {
  let assert Ok(table_idx) = module.table_idx(42)
  let assert Ok(src_idx) = module.table_idx(43)
  visit_test_variant.run(
    TableCopy(table_idx, src_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_table_copy,
    visitor.on_exit_table_copy,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_table_init_test() {
  //   TableInit(elem: ElemIDX, idx: TableIDX)
  let assert Ok(elem_idx) = module.elem_idx(42)
  let assert Ok(table_idx) = module.table_idx(43)
  visit_test_variant.run(
    TableInit(elem_idx, table_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_table_init,
    visitor.on_exit_table_init,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_elem_drop_test() {
  let assert Ok(elem_idx) = module.elem_idx(42)
  visit_test_variant.run(
    ElemDrop(elem_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_elem_drop,
    visitor.on_exit_elem_drop,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_memory_init_test() {
  let assert Ok(data_idx) = module.data_idx(42)
  visit_test_variant.run(
    MemoryInit(data_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_memory_init,
    visitor.on_exit_memory_init,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_data_drop_test() {
  let assert Ok(data_idx) = module.data_idx(42)
  visit_test_variant.run(
    DataDrop(data_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_data_drop,
    visitor.on_exit_data_drop,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_block_test() {
  let assert Ok(fourty_one) = values.i32(41)
  let assert Ok(one) = values.i32(1)
  let body =
    expression.new()
    |> i32.const_(fourty_one)
    |> i32.const_(one)
    |> i32.add
    |> control.drop
    |> expression.end_unwrap

  visit_test_variant.run(
    Block(block_type.void, body),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_block,
    visitor.on_exit_block,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_loop_test() {
  let body =
    expression.new()
    |> control.nop
    |> expression.end_unwrap

  visit_test_variant.run(
    Loop(block_type.void, body),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_loop,
    visitor.on_exit_loop,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_if_test() {
  visit_test_variant.run(
    If(block_type.void, [Nop], None),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_if,
    visitor.on_exit_if,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_br_test() {
  let assert Ok(label_idx) = module.label_idx(42)
  visit_test_variant.run(
    Br(label_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_br,
    visitor.on_exit_br,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_br_if_test() {
  let assert Ok(label_idx) = module.label_idx(42)
  visit_test_variant.run(
    BrIf(label_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_br_if,
    visitor.on_exit_br_if,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_br_table_test() {
  let assert Ok(label_idx1) = module.label_idx(42)
  let assert Ok(label_idx2) = module.label_idx(43)
  let assert Ok(label_idx3) = module.label_idx(44)
  let assert Ok(label_idx4) = module.label_idx(45)
  let assert Ok(label_idx5) = module.label_idx(46)
  let assert Ok(default_label) = module.label_idx(47)
  let labels = [label_idx1, label_idx2, label_idx3, label_idx4, label_idx5]
  visit_test_variant.run(
    BrTable(labels, default_label),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_br_table,
    visitor.on_exit_br_table,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_br_on_null_test() {
  let assert Ok(label_idx) = module.label_idx(42)
  visit_test_variant.run(
    BrOnNull(label_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_br_on_null,
    visitor.on_exit_br_on_null,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_br_on_non_null_test() {
  let assert Ok(label_idx) = module.label_idx(42)
  visit_test_variant.run(
    BrOnNonNull(label_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_br_on_non_null,
    visitor.on_exit_br_on_non_null,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_br_on_cast_test() {
  let assert Ok(label_idx) = module.label_idx(42)
  let ref_type1 = I31RefType
  let ref_type2 = I31RefType
  visit_test_variant.run(
    BrOnCast(label_idx, ref_type1, ref_type2),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_br_on_cast,
    visitor.on_exit_br_on_cast,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_br_on_cast_fail_test() {
  let assert Ok(label_idx) = module.label_idx(42)
  let ref_type1 = I31RefType
  let ref_type2 = I31RefType
  visit_test_variant.run(
    BrOnCastFail(label_idx, ref_type1, ref_type2),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_br_on_cast_fail,
    visitor.on_exit_br_on_cast_fail,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_call_test() {
  let assert Ok(func_idx) = module.func_idx(42)
  visit_test_variant.run(
    Call(func_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_call,
    visitor.on_exit_call,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_call_ref_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  visit_test_variant.run(
    CallRef(type_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_call_ref,
    visitor.on_exit_call_ref,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_call_indirect_test() {
  let assert Ok(table_idx) = module.table_idx(42)
  let assert Ok(type_idx) = module.type_idx(12)
  visit_test_variant.run(
    CallIndirect(table_idx, type_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_call_indirect,
    visitor.on_exit_call_indirect,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_return_call_test() {
  let assert Ok(func_idx) = module.func_idx(42)
  visit_test_variant.run(
    ReturnCall(func_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_return_call,
    visitor.on_exit_return_call,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_return_call_ref_test() {
  let assert Ok(type_idx) = module.type_idx(42)
  visit_test_variant.run(
    ReturnCallRef(type_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_return_call_ref,
    visitor.on_exit_return_call_ref,
    visitor.visit_instruction,
    None,
  )
}

pub fn visit_return_call_indirect_test() {
  let assert Ok(table_idx) = module.table_idx(42)
  let assert Ok(type_idx) = module.type_idx(12)
  visit_test_variant.run(
    ReturnCallIndirect(table_idx, type_idx),
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
    visitor.on_enter_return_call_indirect,
    visitor.on_exit_return_call_indirect,
    visitor.visit_instruction,
    None,
  )
}
