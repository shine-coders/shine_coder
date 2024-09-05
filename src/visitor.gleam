import gleam/option.{type Option, Some}
import internal/finger_tree
import internal/structure/modules.{
  type BinaryModule, type CodeSection, type CustomSection, type DataCountSection,
  type DataSection, type ElementSection, type ExportSection,
  type FunctionSection, type GlobalSection, type ImportSection,
  type MemorySection, type StartSection, type TableSection, type TypeSection,
}
import internal/structure/types.{
  type ArrayType, type BlockType, type Code, type CompositeType, type Data,
  type DataIDX, type DefType, type Elem, type ElemIDX, type ElemMode,
  type Export, type Expr, type FieldIDX, type FieldType, type FuncIDX,
  type FuncType, type Global, type GlobalIDX, type GlobalType, type HeapType,
  type Import, type Instruction, type LabelIDX, type Limits, type LocalIDX,
  type Locals, type MemIDX, type MemType, type RecType, type RefType,
  type StorageType, type StructType, type SubType, type Table, type TableIDX,
  type TableType, type TypeIDX, type ValType,
}
import internal/visitor.{
  type BinaryModuleVisitor, type VisitorCallback, BinaryModuleVisitor,
  do_visit_array_type, do_visit_block_type, do_visit_code, do_visit_code_section,
  do_visit_composite_type, do_visit_custom_section, do_visit_custom_sections,
  do_visit_data, do_visit_data_count_section, do_visit_data_idx,
  do_visit_data_section, do_visit_def_type, do_visit_elem_idx,
  do_visit_element_mode, do_visit_element_section, do_visit_element_segment,
  do_visit_export, do_visit_export_section, do_visit_expr, do_visit_field_idx,
  do_visit_field_type, do_visit_func_idx, do_visit_func_type,
  do_visit_function_section, do_visit_global, do_visit_global_idx,
  do_visit_global_section, do_visit_global_type, do_visit_heap_type,
  do_visit_import, do_visit_import_section, do_visit_instruction,
  do_visit_label_idx, do_visit_limits, do_visit_local_idx, do_visit_locals,
  do_visit_mem_idx, do_visit_mem_type, do_visit_memory_section, do_visit_module,
  do_visit_rec_type, do_visit_ref_type, do_visit_start_section,
  do_visit_storage_type, do_visit_struct_type, do_visit_sub_type, do_visit_table,
  do_visit_table_idx, do_visit_table_section, do_visit_table_type,
  do_visit_type_idx, do_visit_type_section, do_visit_val_type,
}

pub fn on_enter_module(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_module: VisitorCallback(ctx, BinaryModule),
) {
  BinaryModuleVisitor(..visitor, on_enter_module: Some(on_enter_module))
}

pub fn on_exit_module(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_module: VisitorCallback(ctx, BinaryModule),
) {
  BinaryModuleVisitor(..visitor, on_exit_module: Some(on_exit_module))
}

pub fn on_enter_custom_section(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_custom_section: VisitorCallback(ctx, Option(CustomSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_custom_section: Some(on_enter_custom_section),
  )
}

pub fn on_exit_custom_section(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_custom_section: VisitorCallback(ctx, Option(CustomSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_custom_section: Some(on_exit_custom_section),
  )
}

pub fn on_enter_type_section(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_type_section: VisitorCallback(ctx, Option(TypeSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_type_section: Some(on_enter_type_section),
  )
}

pub fn on_exit_type_section(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_type_section: VisitorCallback(ctx, Option(TypeSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_type_section: Some(on_exit_type_section),
  )
}

pub fn on_enter_import_section(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_import_section: VisitorCallback(ctx, Option(ImportSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_import_section: Some(on_enter_import_section),
  )
}

pub fn on_exit_import_section(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_import_section: VisitorCallback(ctx, Option(ImportSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_import_section: Some(on_exit_import_section),
  )
}

pub fn on_enter_table_section(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_table_section: VisitorCallback(ctx, Option(TableSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_table_section: Some(on_enter_table_section),
  )
}

pub fn on_exit_table_section(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_table_section: VisitorCallback(ctx, Option(TableSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_table_section: Some(on_exit_table_section),
  )
}

pub fn on_enter_memory_section(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_memory_section: VisitorCallback(ctx, Option(MemorySection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_memory_section: Some(on_enter_memory_section),
  )
}

pub fn on_exit_memory_section(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_memory_section: VisitorCallback(ctx, Option(MemorySection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_memory_section: Some(on_exit_memory_section),
  )
}

pub fn on_enter_start_section(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_start_section: VisitorCallback(ctx, Option(StartSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_start_section: Some(on_enter_start_section),
  )
}

pub fn on_exit_start_section(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_start_section: VisitorCallback(ctx, Option(StartSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_start_section: Some(on_exit_start_section),
  )
}

pub fn on_enter_element_segment(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_element_segment: VisitorCallback(ctx, Elem),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_element_segment: Some(on_enter_element_segment),
  )
}

pub fn on_exit_element_segment(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_element_segment: VisitorCallback(ctx, Elem),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_element_segment: Some(on_exit_element_segment),
  )
}

pub fn on_enter_element_section(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_element_section: VisitorCallback(ctx, Option(ElementSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_element_section: Some(on_enter_element_section),
  )
}

pub fn on_exit_element_section(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_element_section: VisitorCallback(ctx, Option(ElementSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_element_section: Some(on_exit_element_section),
  )
}

pub fn on_enter_import(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_import: VisitorCallback(ctx, Import),
) {
  BinaryModuleVisitor(..visitor, on_enter_import: Some(on_enter_import))
}

pub fn on_exit_import(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_import: VisitorCallback(ctx, Import),
) {
  BinaryModuleVisitor(..visitor, on_exit_import: Some(on_exit_import))
}

pub fn on_enter_func_import(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_func_import: VisitorCallback(ctx, Import),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_func_import: Some(on_enter_func_import),
  )
}

pub fn on_exit_func_import(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_func_import: VisitorCallback(ctx, Import),
) {
  BinaryModuleVisitor(..visitor, on_exit_func_import: Some(on_exit_func_import))
}

pub fn on_enter_table_import(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_table_import: VisitorCallback(ctx, Import),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_table_import: Some(on_enter_table_import),
  )
}

pub fn on_exit_table_import(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_table_import: VisitorCallback(ctx, Import),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_table_import: Some(on_exit_table_import),
  )
}

pub fn on_enter_mem_import(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_mem_import: VisitorCallback(ctx, Import),
) {
  BinaryModuleVisitor(..visitor, on_enter_mem_import: Some(on_enter_mem_import))
}

pub fn on_exit_mem_import(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_mem_import: VisitorCallback(ctx, Import),
) {
  BinaryModuleVisitor(..visitor, on_exit_mem_import: Some(on_exit_mem_import))
}

pub fn on_enter_global_import(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_global_import: VisitorCallback(ctx, Import),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_global_import: Some(on_enter_global_import),
  )
}

pub fn on_exit_global_import(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_global_import: VisitorCallback(ctx, Import),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_global_import: Some(on_exit_global_import),
  )
}

pub fn on_enter_table_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_table_type: VisitorCallback(ctx, TableType),
) {
  BinaryModuleVisitor(..visitor, on_enter_table_type: Some(on_enter_table_type))
}

pub fn on_exit_table_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_table_type: VisitorCallback(ctx, TableType),
) {
  BinaryModuleVisitor(..visitor, on_exit_table_type: Some(on_exit_table_type))
}

pub fn on_enter_table(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_table: VisitorCallback(ctx, Table),
) {
  BinaryModuleVisitor(..visitor, on_enter_table: Some(on_enter_table))
}

pub fn on_exit_table(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_table: VisitorCallback(ctx, Table),
) {
  BinaryModuleVisitor(..visitor, on_exit_table: Some(on_exit_table))
}

pub fn on_enter_global(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_global: VisitorCallback(ctx, Global),
) {
  BinaryModuleVisitor(..visitor, on_enter_global: Some(on_enter_global))
}

pub fn on_exit_global(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_global: VisitorCallback(ctx, Global),
) {
  BinaryModuleVisitor(..visitor, on_exit_global: Some(on_exit_global))
}

pub fn on_enter_global_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_global_type: VisitorCallback(ctx, GlobalType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_global_type: Some(on_enter_global_type),
  )
}

pub fn on_exit_global_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_global_type: VisitorCallback(ctx, GlobalType),
) {
  BinaryModuleVisitor(..visitor, on_exit_global_type: Some(on_exit_global_type))
}

pub fn on_enter_mem_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_mem_type: VisitorCallback(ctx, MemType),
) {
  BinaryModuleVisitor(..visitor, on_enter_mem_type: Some(on_enter_mem_type))
}

pub fn on_exit_mem_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_mem_type: VisitorCallback(ctx, MemType),
) {
  BinaryModuleVisitor(..visitor, on_exit_mem_type: Some(on_exit_mem_type))
}

pub fn on_enter_def_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_def_type: VisitorCallback(ctx, DefType),
) {
  BinaryModuleVisitor(..visitor, on_enter_def_type: Some(on_enter_def_type))
}

pub fn on_exit_def_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_def_type: VisitorCallback(ctx, DefType),
) {
  BinaryModuleVisitor(..visitor, on_exit_def_type: Some(on_exit_def_type))
}

pub fn on_enter_rec_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_rec_type: VisitorCallback(ctx, RecType),
) {
  BinaryModuleVisitor(..visitor, on_enter_rec_type: Some(on_enter_rec_type))
}

pub fn on_exit_rec_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_rec_type: VisitorCallback(ctx, RecType),
) {
  BinaryModuleVisitor(..visitor, on_exit_rec_type: Some(on_exit_rec_type))
}

pub fn on_enter_sub_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_sub_type: VisitorCallback(ctx, SubType),
) {
  BinaryModuleVisitor(..visitor, on_enter_sub_type: Some(on_enter_sub_type))
}

pub fn on_exit_sub_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_sub_type: VisitorCallback(ctx, SubType),
) {
  BinaryModuleVisitor(..visitor, on_exit_sub_type: Some(on_exit_sub_type))
}

pub fn on_enter_type_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_type_idx: VisitorCallback(ctx, TypeIDX),
) {
  BinaryModuleVisitor(..visitor, on_enter_type_idx: Some(on_enter_type_idx))
}

pub fn on_exit_type_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_type_idx: VisitorCallback(ctx, TypeIDX),
) {
  BinaryModuleVisitor(..visitor, on_exit_type_idx: Some(on_exit_type_idx))
}

pub fn on_enter_rec_type_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_rec_type_idx: VisitorCallback(ctx, TypeIDX),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_rec_type_idx: Some(on_enter_rec_type_idx),
  )
}

pub fn on_exit_rec_type_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_rec_type_idx: VisitorCallback(ctx, TypeIDX),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_rec_type_idx: Some(on_exit_rec_type_idx),
  )
}

pub fn on_enter_def_type_reference(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_def_type_reference: VisitorCallback(ctx, TypeIDX),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_def_type_reference: Some(on_enter_def_type_reference),
  )
}

pub fn on_exit_def_type_reference(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_def_type_reference: VisitorCallback(ctx, TypeIDX),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_def_type_reference: Some(on_exit_def_type_reference),
  )
}

pub fn on_enter_comp_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_comp_type: VisitorCallback(ctx, CompositeType),
) {
  BinaryModuleVisitor(..visitor, on_enter_comp_type: Some(on_enter_comp_type))
}

pub fn on_exit_comp_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_comp_type: VisitorCallback(ctx, CompositeType),
) {
  BinaryModuleVisitor(..visitor, on_exit_comp_type: Some(on_exit_comp_type))
}

pub fn on_enter_composite_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_composite_type: VisitorCallback(ctx, CompositeType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_composite_type: Some(on_enter_composite_type),
  )
}

pub fn on_exit_composite_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_composite_type: VisitorCallback(ctx, CompositeType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_composite_type: Some(on_exit_composite_type),
  )
}

pub fn on_enter_func_composite_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_func_composite_type: VisitorCallback(ctx, CompositeType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_func_composite_type: Some(on_enter_func_composite_type),
  )
}

pub fn on_exit_func_composite_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_func_composite_type: VisitorCallback(ctx, CompositeType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_func_composite_type: Some(on_exit_func_composite_type),
  )
}

pub fn on_enter_struct_composite_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_struct_composite_type: VisitorCallback(ctx, CompositeType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_struct_composite_type: Some(on_enter_struct_composite_type),
  )
}

pub fn on_exit_struct_composite_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_struct_composite_type: VisitorCallback(ctx, CompositeType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_struct_composite_type: Some(on_exit_struct_composite_type),
  )
}

pub fn on_enter_array_composite_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_composite_type: VisitorCallback(ctx, CompositeType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_array_composite_type: Some(on_enter_array_composite_type),
  )
}

pub fn on_exit_array_composite_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_composite_type: VisitorCallback(ctx, CompositeType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_array_composite_type: Some(on_exit_array_composite_type),
  )
}

pub fn on_enter_func_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_func_type: VisitorCallback(ctx, FuncType),
) {
  BinaryModuleVisitor(..visitor, on_enter_func_type: Some(on_enter_func_type))
}

pub fn on_enter_val_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_val_type: VisitorCallback(ctx, ValType),
) {
  BinaryModuleVisitor(..visitor, on_enter_val_type: Some(on_enter_val_type))
}

pub fn on_exit_val_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_val_type: VisitorCallback(ctx, ValType),
) {
  BinaryModuleVisitor(..visitor, on_exit_val_type: Some(on_exit_val_type))
}

pub fn on_exit_func_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_func_type: VisitorCallback(ctx, FuncType),
) {
  BinaryModuleVisitor(..visitor, on_exit_func_type: Some(on_exit_func_type))
}

pub fn on_enter_v128_val_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_v128_val_type: VisitorCallback(ctx, ValType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_v128_val_type: Some(on_enter_v128_val_type),
  )
}

pub fn on_exit_v128_val_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_v128_val_type: VisitorCallback(ctx, ValType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_v128_val_type: Some(on_exit_v128_val_type),
  )
}

pub fn on_enter_i32_val_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_i32_val_type: VisitorCallback(ctx, ValType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_i32_val_type: Some(on_enter_i32_val_type),
  )
}

pub fn on_exit_i32_val_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_i32_val_type: VisitorCallback(ctx, ValType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_i32_val_type: Some(on_exit_i32_val_type),
  )
}

pub fn on_enter_i64_val_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_i64_val_type: VisitorCallback(ctx, ValType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_i64_val_type: Some(on_enter_i64_val_type),
  )
}

pub fn on_exit_i64_val_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_i64_val_type: VisitorCallback(ctx, ValType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_i64_val_type: Some(on_exit_i64_val_type),
  )
}

pub fn on_enter_f32_val_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_f32_val_type: VisitorCallback(ctx, ValType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_f32_val_type: Some(on_enter_f32_val_type),
  )
}

pub fn on_exit_f32_val_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_f32_val_type: VisitorCallback(ctx, ValType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_f32_val_type: Some(on_exit_f32_val_type),
  )
}

pub fn on_enter_f64_val_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_f64_val_type: VisitorCallback(ctx, ValType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_f64_val_type: Some(on_enter_f64_val_type),
  )
}

pub fn on_exit_f64_val_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_f64_val_type: VisitorCallback(ctx, ValType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_f64_val_type: Some(on_exit_f64_val_type),
  )
}

pub fn on_enter_ref_type_val_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_ref_type_val_type: VisitorCallback(ctx, ValType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_ref_type_val_type: Some(on_enter_ref_type_val_type),
  )
}

pub fn on_exit_ref_type_val_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_ref_type_val_type: VisitorCallback(ctx, ValType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_ref_type_val_type: Some(on_exit_ref_type_val_type),
  )
}

pub fn on_enter_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(..visitor, on_enter_ref_type: Some(on_enter_ref_type))
}

pub fn on_exit_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(..visitor, on_exit_ref_type: Some(on_exit_ref_type))
}

pub fn on_enter_heap_type_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_heap_type_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_heap_type_ref_type: Some(on_enter_heap_type_ref_type),
  )
}

pub fn on_exit_heap_type_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_heap_type_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_heap_type_ref_type: Some(on_exit_heap_type_ref_type),
  )
}

pub fn on_enter_any_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_any_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_any_ref_type: Some(on_enter_any_ref_type),
  )
}

pub fn on_exit_any_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_any_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_any_ref_type: Some(on_exit_any_ref_type),
  )
}

pub fn on_enter_eq_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_eq_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_eq_ref_type: Some(on_enter_eq_ref_type),
  )
}

pub fn on_exit_eq_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_eq_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(..visitor, on_exit_eq_ref_type: Some(on_exit_eq_ref_type))
}

pub fn on_enter_i31_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_i31_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_i31_ref_type: Some(on_enter_i31_ref_type),
  )
}

pub fn on_exit_i31_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_i31_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_i31_ref_type: Some(on_exit_i31_ref_type),
  )
}

pub fn on_enter_struct_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_struct_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_struct_ref_type: Some(on_enter_struct_ref_type),
  )
}

pub fn on_exit_struct_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_struct_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_struct_ref_type: Some(on_exit_struct_ref_type),
  )
}

pub fn on_enter_array_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_array_ref_type: Some(on_enter_array_ref_type),
  )
}

pub fn on_exit_array_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_array_ref_type: Some(on_exit_array_ref_type),
  )
}

pub fn on_enter_func_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_func_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_func_ref_type: Some(on_enter_func_ref_type),
  )
}

pub fn on_exit_func_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_func_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_func_ref_type: Some(on_exit_func_ref_type),
  )
}

pub fn on_enter_extern_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_extern_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_extern_ref_type: Some(on_enter_extern_ref_type),
  )
}

pub fn on_exit_extern_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_extern_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_extern_ref_type: Some(on_exit_extern_ref_type),
  )
}

pub fn on_enter_none_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_none_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_none_ref_type: Some(on_enter_none_ref_type),
  )
}

pub fn on_exit_none_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_none_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_none_ref_type: Some(on_exit_none_ref_type),
  )
}

pub fn on_enter_no_func_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_no_func_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_no_func_ref_type: Some(on_enter_no_func_ref_type),
  )
}

pub fn on_exit_no_func_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_no_func_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_no_func_ref_type: Some(on_exit_no_func_ref_type),
  )
}

pub fn on_enter_no_extern_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_no_extern_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_no_extern_ref_type: Some(on_enter_no_extern_ref_type),
  )
}

pub fn on_exit_no_extern_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_no_extern_ref_type: VisitorCallback(ctx, RefType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_no_extern_ref_type: Some(on_exit_no_extern_ref_type),
  )
}

pub fn on_enter_struct_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_struct_type: VisitorCallback(ctx, StructType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_struct_type: Some(on_enter_struct_type),
  )
}

pub fn on_exit_struct_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_struct_type: VisitorCallback(ctx, StructType),
) {
  BinaryModuleVisitor(..visitor, on_exit_struct_type: Some(on_exit_struct_type))
}

pub fn on_enter_field_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_field_type: VisitorCallback(ctx, FieldType),
) {
  BinaryModuleVisitor(..visitor, on_enter_field_type: Some(on_enter_field_type))
}

pub fn on_exit_field_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_field_type: VisitorCallback(ctx, FieldType),
) {
  BinaryModuleVisitor(..visitor, on_exit_field_type: Some(on_exit_field_type))
}

pub fn on_enter_storage_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_storage_type: VisitorCallback(ctx, StorageType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_storage_type: Some(on_enter_storage_type),
  )
}

pub fn on_enter_i8_storage_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_i8_storage_type: VisitorCallback(ctx, StorageType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_i8_storage_type: Some(on_enter_i8_storage_type),
  )
}

pub fn on_enter_i16_storage_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_i16_storage_type: VisitorCallback(ctx, StorageType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_i16_storage_type: Some(on_enter_i16_storage_type),
  )
}

pub fn on_enter_val_type_storage_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_val_type_storage_type: VisitorCallback(ctx, StorageType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_val_type_storage_type: Some(on_enter_val_type_storage_type),
  )
}

pub fn on_exit_i8_storage_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_i8_storage_type: VisitorCallback(ctx, StorageType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_i8_storage_type: Some(on_exit_i8_storage_type),
  )
}

pub fn on_exit_i16_storage_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_i16_storage_type: VisitorCallback(ctx, StorageType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_i16_storage_type: Some(on_exit_i16_storage_type),
  )
}

pub fn on_exit_val_type_storage_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_val_type_storage_type: VisitorCallback(ctx, StorageType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_val_type_storage_type: Some(on_exit_val_type_storage_type),
  )
}

pub fn on_exit_storage_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_storage_type: VisitorCallback(ctx, StorageType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_storage_type: Some(on_exit_storage_type),
  )
}

pub fn on_enter_array_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_type: VisitorCallback(ctx, ArrayType),
) {
  BinaryModuleVisitor(..visitor, on_enter_array_type: Some(on_enter_array_type))
}

pub fn on_exit_array_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_type: VisitorCallback(ctx, ArrayType),
) {
  BinaryModuleVisitor(..visitor, on_exit_array_type: Some(on_exit_array_type))
}

pub fn on_enter_function_section(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_function_section: VisitorCallback(ctx, Option(FunctionSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_function_section: Some(on_enter_function_section),
  )
}

pub fn on_exit_function_section(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_function_section: VisitorCallback(ctx, Option(FunctionSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_function_section: Some(on_exit_function_section),
  )
}

pub fn on_enter_code_section(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_code_section: VisitorCallback(ctx, Option(CodeSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_code_section: Some(on_enter_code_section),
  )
}

pub fn on_exit_code_section(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_code_section: VisitorCallback(ctx, Option(CodeSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_code_section: Some(on_exit_code_section),
  )
}

pub fn on_enter_func_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_func_idx: VisitorCallback(ctx, FuncIDX),
) {
  BinaryModuleVisitor(..visitor, on_enter_func_idx: Some(on_enter_func_idx))
}

pub fn on_exit_func_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_func_idx: VisitorCallback(ctx, FuncIDX),
) {
  BinaryModuleVisitor(..visitor, on_exit_func_idx: Some(on_exit_func_idx))
}

pub fn on_enter_table_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_table_idx: VisitorCallback(ctx, TableIDX),
) {
  BinaryModuleVisitor(..visitor, on_enter_table_idx: Some(on_enter_table_idx))
}

pub fn on_exit_table_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_table_idx: VisitorCallback(ctx, TableIDX),
) {
  BinaryModuleVisitor(..visitor, on_exit_table_idx: Some(on_exit_table_idx))
}

pub fn on_enter_mem_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_mem_idx: VisitorCallback(ctx, MemIDX),
) {
  BinaryModuleVisitor(..visitor, on_enter_mem_idx: Some(on_enter_mem_idx))
}

pub fn on_exit_mem_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_mem_idx: VisitorCallback(ctx, MemIDX),
) {
  BinaryModuleVisitor(..visitor, on_exit_mem_idx: Some(on_exit_mem_idx))
}

pub fn on_enter_global_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_global_idx: VisitorCallback(ctx, GlobalIDX),
) {
  BinaryModuleVisitor(..visitor, on_enter_global_idx: Some(on_enter_global_idx))
}

pub fn on_exit_global_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_global_idx: VisitorCallback(ctx, GlobalIDX),
) {
  BinaryModuleVisitor(..visitor, on_exit_global_idx: Some(on_exit_global_idx))
}

pub fn on_enter_elem_expressions(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_elem_expressions: VisitorCallback(ctx, Elem),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_elem_expressions: Some(on_enter_elem_expressions),
  )
}

pub fn on_exit_elem_expressions(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_elem_expressions: VisitorCallback(ctx, Elem),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_elem_expressions: Some(on_exit_elem_expressions),
  )
}

pub fn on_enter_elem_funcs(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_elem_funcs: VisitorCallback(ctx, Elem),
) {
  BinaryModuleVisitor(..visitor, on_enter_elem_funcs: Some(on_enter_elem_funcs))
}

pub fn on_exit_elem_funcs(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_elem_funcs: VisitorCallback(ctx, Elem),
) {
  BinaryModuleVisitor(..visitor, on_exit_elem_funcs: Some(on_exit_elem_funcs))
}

pub fn on_enter_global_section(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_global_section: VisitorCallback(ctx, Option(GlobalSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_global_section: Some(on_enter_global_section),
  )
}

pub fn on_exit_global_section(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_global_section: VisitorCallback(ctx, Option(GlobalSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_global_section: Some(on_exit_global_section),
  )
}

pub fn on_enter_export_section(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_export_section: VisitorCallback(ctx, Option(ExportSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_export_section: Some(on_enter_export_section),
  )
}

pub fn on_exit_export_section(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_export_section: VisitorCallback(ctx, Option(ExportSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_export_section: Some(on_exit_export_section),
  )
}

pub fn on_enter_export(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_export: VisitorCallback(ctx, Export),
) {
  BinaryModuleVisitor(..visitor, on_enter_export: Some(on_enter_export))
}

pub fn on_exit_export(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_export: VisitorCallback(ctx, Export),
) {
  BinaryModuleVisitor(..visitor, on_exit_export: Some(on_exit_export))
}

pub fn on_enter_func_export(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_func_export: VisitorCallback(ctx, Export),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_func_export: Some(on_enter_func_export),
  )
}

pub fn on_exit_func_export(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_func_export: VisitorCallback(ctx, Export),
) {
  BinaryModuleVisitor(..visitor, on_exit_func_export: Some(on_exit_func_export))
}

pub fn on_enter_table_export(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_table_export: VisitorCallback(ctx, Export),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_table_export: Some(on_enter_table_export),
  )
}

pub fn on_exit_table_export(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_table_export: VisitorCallback(ctx, Export),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_table_export: Some(on_exit_table_export),
  )
}

pub fn on_enter_mem_export(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_mem_export: VisitorCallback(ctx, Export),
) {
  BinaryModuleVisitor(..visitor, on_enter_mem_export: Some(on_enter_mem_export))
}

pub fn on_exit_mem_export(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_mem_export: VisitorCallback(ctx, Export),
) {
  BinaryModuleVisitor(..visitor, on_exit_mem_export: Some(on_exit_mem_export))
}

pub fn on_enter_global_export(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_global_export: VisitorCallback(ctx, Export),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_global_export: Some(on_enter_global_export),
  )
}

pub fn on_exit_global_export(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_global_export: VisitorCallback(ctx, Export),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_global_export: Some(on_exit_global_export),
  )
}

pub fn on_enter_limits(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_limits: VisitorCallback(ctx, Limits),
) {
  BinaryModuleVisitor(..visitor, on_enter_limits: Some(on_enter_limits))
}

pub fn on_exit_limits(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_limits: VisitorCallback(ctx, Limits),
) {
  BinaryModuleVisitor(..visitor, on_exit_limits: Some(on_exit_limits))
}

pub fn on_enter_expr(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_expr: VisitorCallback(ctx, Expr),
) {
  BinaryModuleVisitor(..visitor, on_enter_expr: Some(on_enter_expr))
}

pub fn on_exit_expr(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_expr: VisitorCallback(ctx, Expr),
) {
  BinaryModuleVisitor(..visitor, on_exit_expr: Some(on_exit_expr))
}

pub fn on_enter_instruction(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_instruction: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_instruction: Some(on_enter_instruction),
  )
}

pub fn on_exit_instruction(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_instruction: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_instruction: Some(on_exit_instruction))
}

pub fn on_enter_element_mode(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_element_mode: VisitorCallback(ctx, ElemMode),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_element_mode: Some(on_enter_element_mode),
  )
}

pub fn on_exit_element_mode(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_element_mode: VisitorCallback(ctx, ElemMode),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_element_mode: Some(on_exit_element_mode),
  )
}

pub fn on_enter_declarative_elem_mode(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_declarative_elem_mode: VisitorCallback(ctx, ElemMode),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_declarative_elem_mode: Some(on_enter_declarative_elem_mode),
  )
}

pub fn on_exit_declarative_elem_mode(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_declarative_elem_mode: VisitorCallback(ctx, ElemMode),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_declarative_elem_mode: Some(on_exit_declarative_elem_mode),
  )
}

pub fn on_enter_passive_elem_mode(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_passive_elem_mode: VisitorCallback(ctx, ElemMode),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_passive_elem_mode: Some(on_enter_passive_elem_mode),
  )
}

pub fn on_exit_passive_elem_mode(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_passive_elem_mode: VisitorCallback(ctx, ElemMode),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_passive_elem_mode: Some(on_exit_passive_elem_mode),
  )
}

pub fn on_enter_active_elem_mode(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_active_elem_mode: VisitorCallback(ctx, ElemMode),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_active_elem_mode: Some(on_enter_active_elem_mode),
  )
}

pub fn on_exit_active_elem_mode(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_active_elem_mode: VisitorCallback(ctx, ElemMode),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_active_elem_mode: Some(on_exit_active_elem_mode),
  )
}

pub fn on_enter_code(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_code: VisitorCallback(ctx, Code),
) {
  BinaryModuleVisitor(..visitor, on_enter_code: Some(on_enter_code))
}

pub fn on_exit_code(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_code: VisitorCallback(ctx, Code),
) {
  BinaryModuleVisitor(..visitor, on_exit_code: Some(on_exit_code))
}

pub fn on_enter_locals(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_locals: VisitorCallback(ctx, Locals),
) {
  BinaryModuleVisitor(..visitor, on_enter_locals: Some(on_enter_locals))
}

pub fn on_exit_locals(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_locals: VisitorCallback(ctx, Locals),
) {
  BinaryModuleVisitor(..visitor, on_exit_locals: Some(on_exit_locals))
}

pub fn on_enter_data_section(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_data_section: VisitorCallback(ctx, Option(DataSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_data_section: Some(on_enter_data_section),
  )
}

pub fn on_exit_data_section(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_data_section: VisitorCallback(ctx, Option(DataSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_data_section: Some(on_exit_data_section),
  )
}

pub fn on_enter_active_data(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_active_data: VisitorCallback(ctx, Data),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_active_data: Some(on_enter_active_data),
  )
}

pub fn on_exit_active_data(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_active_data: VisitorCallback(ctx, Data),
) {
  BinaryModuleVisitor(..visitor, on_exit_active_data: Some(on_exit_active_data))
}

pub fn on_enter_passive_data(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_passive_data: VisitorCallback(ctx, Data),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_passive_data: Some(on_enter_passive_data),
  )
}

pub fn on_exit_passive_data(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_passive_data: VisitorCallback(ctx, Data),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_passive_data: Some(on_exit_passive_data),
  )
}

pub fn on_enter_data(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_data: VisitorCallback(ctx, Data),
) {
  BinaryModuleVisitor(..visitor, on_enter_data: Some(on_enter_data))
}

pub fn on_exit_data(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_data: VisitorCallback(ctx, Data),
) {
  BinaryModuleVisitor(..visitor, on_exit_data: Some(on_exit_data))
}

pub fn on_enter_data_count_section(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_data_count_section: VisitorCallback(ctx, Option(DataCountSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_data_count_section: Some(on_enter_data_count_section),
  )
}

pub fn on_exit_data_count_section(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_data_count_section: VisitorCallback(ctx, Option(DataCountSection)),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_data_count_section: Some(on_exit_data_count_section),
  )
}

pub fn on_enter_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(..visitor, on_enter_heap_type: Some(on_enter_heap_type))
}

pub fn on_exit_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(..visitor, on_exit_heap_type: Some(on_exit_heap_type))
}

pub fn on_enter_func_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_func_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_func_heap_type: Some(on_enter_func_heap_type),
  )
}

pub fn on_exit_func_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_func_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_func_heap_type: Some(on_exit_func_heap_type),
  )
}

pub fn on_enter_no_func_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_no_func_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_no_func_heap_type: Some(on_enter_no_func_heap_type),
  )
}

pub fn on_exit_no_func_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_no_func_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_no_func_heap_type: Some(on_exit_no_func_heap_type),
  )
}

pub fn on_enter_extern_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_extern_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_extern_heap_type: Some(on_enter_extern_heap_type),
  )
}

pub fn on_exit_extern_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_extern_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_extern_heap_type: Some(on_exit_extern_heap_type),
  )
}

pub fn on_enter_no_extern_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_no_extern_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_no_extern_heap_type: Some(on_enter_no_extern_heap_type),
  )
}

pub fn on_exit_no_extern_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_no_extern_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_no_extern_heap_type: Some(on_exit_no_extern_heap_type),
  )
}

pub fn on_enter_any_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_any_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_any_heap_type: Some(on_enter_any_heap_type),
  )
}

pub fn on_exit_any_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_any_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_any_heap_type: Some(on_exit_any_heap_type),
  )
}

pub fn on_enter_eq_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_eq_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_eq_heap_type: Some(on_enter_eq_heap_type),
  )
}

pub fn on_exit_eq_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_eq_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_eq_heap_type: Some(on_exit_eq_heap_type),
  )
}

pub fn on_enter_i31_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_i31_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_i31_heap_type: Some(on_enter_i31_heap_type),
  )
}

pub fn on_exit_i31_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_i31_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_i31_heap_type: Some(on_exit_i31_heap_type),
  )
}

pub fn on_enter_struct_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_struct_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_struct_heap_type: Some(on_enter_struct_heap_type),
  )
}

pub fn on_exit_struct_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_struct_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_struct_heap_type: Some(on_exit_struct_heap_type),
  )
}

pub fn on_enter_array_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_array_heap_type: Some(on_enter_array_heap_type),
  )
}

pub fn on_exit_array_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_array_heap_type: Some(on_exit_array_heap_type),
  )
}

pub fn on_enter_none_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_none_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_none_heap_type: Some(on_enter_none_heap_type),
  )
}

pub fn on_exit_none_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_none_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_none_heap_type: Some(on_exit_none_heap_type),
  )
}

pub fn on_enter_concrete_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_concrete_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_concrete_heap_type: Some(on_enter_concrete_heap_type),
  )
}

pub fn on_exit_concrete_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_concrete_heap_type: VisitorCallback(ctx, HeapType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_concrete_heap_type: Some(on_exit_concrete_heap_type),
  )
}

pub fn on_enter_ref_null(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_ref_null: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_ref_null: Some(on_enter_ref_null))
}

pub fn on_exit_ref_null(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_ref_null: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_ref_null: Some(on_exit_ref_null))
}

pub fn on_enter_ref_func(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_ref_func: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_ref_func: Some(on_enter_ref_func))
}

pub fn on_exit_ref_func(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_ref_func: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_ref_func: Some(on_exit_ref_func))
}

pub fn on_enter_ref_test(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_ref_test: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_ref_test: Some(on_enter_ref_test))
}

pub fn on_exit_ref_test(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_ref_test: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_ref_test: Some(on_exit_ref_test))
}

pub fn on_enter_ref_test_nullable(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_ref_test_nullable: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_ref_test_nullable: Some(on_enter_ref_test_nullable),
  )
}

pub fn on_exit_ref_test_nullable(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_ref_test_nullable: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_ref_test_nullable: Some(on_exit_ref_test_nullable),
  )
}

pub fn on_enter_ref_cast(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_ref_cast: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_ref_cast: Some(on_enter_ref_cast))
}

pub fn on_exit_ref_cast(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_ref_cast: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_ref_cast: Some(on_exit_ref_cast))
}

pub fn on_enter_ref_cast_nullable(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_ref_cast_nullable: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_ref_cast_nullable: Some(on_enter_ref_cast_nullable),
  )
}

pub fn on_exit_ref_cast_nullable(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_ref_cast_nullable: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_ref_cast_nullable: Some(on_exit_ref_cast_nullable),
  )
}

pub fn on_enter_struct_get(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_struct_get: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_struct_get: Some(on_enter_struct_get))
}

pub fn on_exit_struct_get(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_struct_get: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_struct_get: Some(on_exit_struct_get))
}

pub fn on_enter_struct_get_s(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_struct_get_s: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_struct_get_s: Some(on_enter_struct_get_s),
  )
}

pub fn on_exit_struct_get_s(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_struct_get_s: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_struct_get_s: Some(on_exit_struct_get_s),
  )
}

pub fn on_enter_struct_get_u(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_struct_get_u: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_struct_get_u: Some(on_enter_struct_get_u),
  )
}

pub fn on_exit_struct_get_u(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_struct_get_u: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_struct_get_u: Some(on_exit_struct_get_u),
  )
}

pub fn on_enter_struct_set(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_struct_set: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_struct_set: Some(on_enter_struct_set))
}

pub fn on_exit_struct_set(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_struct_set: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_struct_set: Some(on_exit_struct_set))
}

pub fn on_enter_array_new(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_new: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_array_new: Some(on_enter_array_new))
}

pub fn on_exit_array_new(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_new: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_array_new: Some(on_exit_array_new))
}

pub fn on_enter_array_new_default(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_new_default: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_array_new_default: Some(on_enter_array_new_default),
  )
}

pub fn on_exit_array_new_default(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_new_default: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_array_new_default: Some(on_exit_array_new_default),
  )
}

pub fn on_enter_array_new_data(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_new_data: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_array_new_data: Some(on_enter_array_new_data),
  )
}

pub fn on_exit_array_new_data(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_new_data: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_array_new_data: Some(on_exit_array_new_data),
  )
}

pub fn on_enter_array_new_elem(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_new_elem: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_array_new_elem: Some(on_enter_array_new_elem),
  )
}

pub fn on_exit_array_new_elem(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_new_elem: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_array_new_elem: Some(on_exit_array_new_elem),
  )
}

pub fn on_enter_array_new_fixed(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_new_fixed: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_array_new_fixed: Some(on_enter_array_new_fixed),
  )
}

pub fn on_exit_array_new_fixed(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_new_fixed: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_array_new_fixed: Some(on_exit_array_new_fixed),
  )
}

pub fn on_enter_array_get(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_get: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_array_get: Some(on_enter_array_get))
}

pub fn on_exit_array_get(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_get: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_array_get: Some(on_exit_array_get))
}

pub fn on_enter_array_get_s(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_get_s: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_array_get_s: Some(on_enter_array_get_s),
  )
}

pub fn on_exit_array_get_s(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_get_s: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_array_get_s: Some(on_exit_array_get_s))
}

pub fn on_enter_array_get_u(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_get_u: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_array_get_u: Some(on_enter_array_get_u),
  )
}

pub fn on_exit_array_get_u(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_get_u: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_array_get_u: Some(on_exit_array_get_u))
}

pub fn on_enter_array_set(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_set: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_array_set: Some(on_enter_array_set))
}

pub fn on_exit_array_set(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_set: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_array_set: Some(on_exit_array_set))
}

pub fn on_enter_array_fill(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_fill: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_array_fill: Some(on_enter_array_fill))
}

pub fn on_exit_array_fill(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_fill: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_array_fill: Some(on_exit_array_fill))
}

pub fn on_enter_array_copy(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_copy: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_array_copy: Some(on_enter_array_copy))
}

pub fn on_exit_array_copy(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_copy: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_array_copy: Some(on_exit_array_copy))
}

pub fn on_enter_array_init_data(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_init_data: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_array_init_data: Some(on_enter_array_init_data),
  )
}

pub fn on_exit_array_init_data(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_init_data: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_array_init_data: Some(on_exit_array_init_data),
  )
}

pub fn on_enter_array_init_elem(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_array_init_elem: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_array_init_elem: Some(on_enter_array_init_elem),
  )
}

pub fn on_exit_array_init_elem(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_array_init_elem: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_array_init_elem: Some(on_exit_array_init_elem),
  )
}

pub fn on_enter_select_t(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_select_t: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_select_t: Some(on_enter_select_t))
}

pub fn on_exit_select_t(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_select_t: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_select_t: Some(on_exit_select_t))
}

pub fn on_enter_local_get(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_local_get: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_local_get: Some(on_enter_local_get))
}

pub fn on_exit_local_get(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_local_get: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_local_get: Some(on_exit_local_get))
}

pub fn on_enter_local_set(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_local_set: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_local_set: Some(on_enter_local_set))
}

pub fn on_exit_local_set(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_local_set: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_local_set: Some(on_exit_local_set))
}

pub fn on_enter_local_tee(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_local_tee: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_local_tee: Some(on_enter_local_tee))
}

pub fn on_exit_local_tee(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_local_tee: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_local_tee: Some(on_exit_local_tee))
}

pub fn on_enter_global_get(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_global_get: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_global_get: Some(on_enter_global_get))
}

pub fn on_exit_global_get(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_global_get: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_global_get: Some(on_exit_global_get))
}

pub fn on_enter_global_set(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_global_set: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_global_set: Some(on_enter_global_set))
}

pub fn on_exit_global_set(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_global_set: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_global_set: Some(on_exit_global_set))
}

pub fn on_enter_table_get(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_table_get: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_table_get: Some(on_enter_table_get))
}

pub fn on_exit_table_get(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_table_get: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_table_get: Some(on_exit_table_get))
}

pub fn on_enter_table_set(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_table_set: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_table_set: Some(on_enter_table_set))
}

pub fn on_exit_table_set(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_table_set: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_table_set: Some(on_exit_table_set))
}

pub fn on_enter_table_size(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_table_size: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_table_size: Some(on_enter_table_size))
}

pub fn on_exit_table_size(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_table_size: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_table_size: Some(on_exit_table_size))
}

pub fn on_enter_table_grow(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_table_grow: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_table_grow: Some(on_enter_table_grow))
}

pub fn on_exit_table_grow(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_table_grow: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_table_grow: Some(on_exit_table_grow))
}

pub fn on_enter_table_fill(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_table_fill: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_table_fill: Some(on_enter_table_fill))
}

pub fn on_exit_table_fill(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_table_fill: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_table_fill: Some(on_exit_table_fill))
}

pub fn on_enter_table_copy(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_table_copy: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_table_copy: Some(on_enter_table_copy))
}

pub fn on_exit_table_copy(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_table_copy: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_table_copy: Some(on_exit_table_copy))
}

pub fn on_enter_table_init(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_table_init: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_table_init: Some(on_enter_table_init))
}

pub fn on_exit_table_init(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_table_init: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_table_init: Some(on_exit_table_init))
}

pub fn on_enter_elem_drop(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_elem_drop: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_elem_drop: Some(on_enter_elem_drop))
}

pub fn on_exit_elem_drop(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_elem_drop: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_elem_drop: Some(on_exit_elem_drop))
}

pub fn on_enter_memory_init(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_memory_init: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_memory_init: Some(on_enter_memory_init),
  )
}

pub fn on_exit_memory_init(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_memory_init: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_memory_init: Some(on_exit_memory_init))
}

pub fn on_enter_data_drop(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_data_drop: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_data_drop: Some(on_enter_data_drop))
}

pub fn on_exit_data_drop(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_data_drop: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_data_drop: Some(on_exit_data_drop))
}

pub fn on_enter_block(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_block: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_block: Some(on_enter_block))
}

pub fn on_exit_block(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_block: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_block: Some(on_exit_block))
}

pub fn on_enter_loop(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_loop: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_loop: Some(on_enter_loop))
}

pub fn on_exit_loop(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_loop: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_loop: Some(on_exit_loop))
}

pub fn on_enter_if(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_if: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_if: Some(on_enter_if))
}

pub fn on_exit_if(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_if: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_if: Some(on_exit_if))
}

pub fn on_enter_br(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_br: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_br: Some(on_enter_br))
}

pub fn on_exit_br(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_br: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_br: Some(on_exit_br))
}

pub fn on_enter_br_if(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_br_if: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_br_if: Some(on_enter_br_if))
}

pub fn on_exit_br_if(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_br_if: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_br_if: Some(on_exit_br_if))
}

pub fn on_enter_br_table(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_br_table: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_br_table: Some(on_enter_br_table))
}

pub fn on_exit_br_table(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_br_table: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_br_table: Some(on_exit_br_table))
}

pub fn on_enter_br_on_null(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_br_on_null: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_br_on_null: Some(on_enter_br_on_null))
}

pub fn on_exit_br_on_null(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_br_on_null: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_br_on_null: Some(on_exit_br_on_null))
}

pub fn on_enter_br_on_non_null(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_br_on_non_null: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_br_on_non_null: Some(on_enter_br_on_non_null),
  )
}

pub fn on_exit_br_on_non_null(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_br_on_non_null: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_br_on_non_null: Some(on_exit_br_on_non_null),
  )
}

pub fn on_enter_br_on_cast(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_br_on_cast: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_br_on_cast: Some(on_enter_br_on_cast))
}

pub fn on_exit_br_on_cast(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_br_on_cast: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_br_on_cast: Some(on_exit_br_on_cast))
}

pub fn on_enter_br_on_cast_fail(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_br_on_cast_fail: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_br_on_cast_fail: Some(on_enter_br_on_cast_fail),
  )
}

pub fn on_exit_br_on_cast_fail(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_br_on_cast_fail: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_br_on_cast_fail: Some(on_exit_br_on_cast_fail),
  )
}

pub fn on_enter_call(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_call: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_call: Some(on_enter_call))
}

pub fn on_exit_call(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_call: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_call: Some(on_exit_call))
}

pub fn on_enter_call_ref(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_call_ref: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_enter_call_ref: Some(on_enter_call_ref))
}

pub fn on_exit_call_ref(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_call_ref: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_call_ref: Some(on_exit_call_ref))
}

pub fn on_enter_call_indirect(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_call_indirect: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_call_indirect: Some(on_enter_call_indirect),
  )
}

pub fn on_exit_call_indirect(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_call_indirect: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_call_indirect: Some(on_exit_call_indirect),
  )
}

pub fn on_enter_return_call(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_return_call: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_return_call: Some(on_enter_return_call),
  )
}

pub fn on_exit_return_call(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_return_call: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(..visitor, on_exit_return_call: Some(on_exit_return_call))
}

pub fn on_enter_return_call_ref(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_return_call_ref: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_return_call_ref: Some(on_enter_return_call_ref),
  )
}

pub fn on_exit_return_call_ref(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_return_call_ref: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_return_call_ref: Some(on_exit_return_call_ref),
  )
}

pub fn on_enter_return_call_indirect(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_return_call_indirect: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_return_call_indirect: Some(on_enter_return_call_indirect),
  )
}

pub fn on_exit_return_call_indirect(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_return_call_indirect: VisitorCallback(ctx, Instruction),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_return_call_indirect: Some(on_exit_return_call_indirect),
  )
}

pub fn on_enter_label_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_label_idx: VisitorCallback(ctx, LabelIDX),
) {
  BinaryModuleVisitor(..visitor, on_enter_label_idx: Some(on_enter_label_idx))
}

pub fn on_exit_label_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_label_idx: VisitorCallback(ctx, LabelIDX),
) {
  BinaryModuleVisitor(..visitor, on_exit_label_idx: Some(on_exit_label_idx))
}

pub fn on_enter_block_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_block_type: VisitorCallback(ctx, BlockType),
) {
  BinaryModuleVisitor(..visitor, on_enter_block_type: Some(on_enter_block_type))
}

pub fn on_exit_block_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_block_type: VisitorCallback(ctx, BlockType),
) {
  BinaryModuleVisitor(..visitor, on_exit_block_type: Some(on_exit_block_type))
}

pub fn on_enter_void_block_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_void_block_type: VisitorCallback(ctx, BlockType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_void_block_type: Some(on_enter_void_block_type),
  )
}

pub fn on_exit_void_block_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_void_block_type: VisitorCallback(ctx, BlockType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_void_block_type: Some(on_exit_void_block_type),
  )
}

pub fn on_enter_val_type_block_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_val_type_block_type: VisitorCallback(ctx, BlockType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_val_type_block_type: Some(on_enter_val_type_block_type),
  )
}

pub fn on_exit_val_type_block_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_val_type_block_type: VisitorCallback(ctx, BlockType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_val_type_block_type: Some(on_exit_val_type_block_type),
  )
}

pub fn on_enter_func_type_block_type(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_func_type_block_type: VisitorCallback(ctx, BlockType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_enter_func_type_block_type: Some(on_enter_func_type_block_type),
  )
}

pub fn on_exit_func_type_block_type(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_func_type_block_type: VisitorCallback(ctx, BlockType),
) {
  BinaryModuleVisitor(
    ..visitor,
    on_exit_func_type_block_type: Some(on_exit_func_type_block_type),
  )
}

pub fn on_enter_field_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_field_idx: VisitorCallback(ctx, FieldIDX),
) {
  BinaryModuleVisitor(..visitor, on_enter_field_idx: Some(on_enter_field_idx))
}

pub fn on_exit_field_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_field_idx: VisitorCallback(ctx, FieldIDX),
) {
  BinaryModuleVisitor(..visitor, on_exit_field_idx: Some(on_exit_field_idx))
}

pub fn on_enter_data_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_data_idx: VisitorCallback(ctx, DataIDX),
) {
  BinaryModuleVisitor(..visitor, on_enter_data_idx: Some(on_enter_data_idx))
}

pub fn on_exit_data_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_data_idx: VisitorCallback(ctx, DataIDX),
) {
  BinaryModuleVisitor(..visitor, on_exit_data_idx: Some(on_exit_data_idx))
}

pub fn on_enter_elem_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_elem_idx: VisitorCallback(ctx, ElemIDX),
) {
  BinaryModuleVisitor(..visitor, on_enter_elem_idx: Some(on_enter_elem_idx))
}

pub fn on_exit_elem_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_elem_idx: VisitorCallback(ctx, ElemIDX),
) {
  BinaryModuleVisitor(..visitor, on_exit_elem_idx: Some(on_exit_elem_idx))
}

pub fn on_enter_local_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_enter_local_idx: VisitorCallback(ctx, LocalIDX),
) {
  BinaryModuleVisitor(..visitor, on_enter_local_idx: Some(on_enter_local_idx))
}

pub fn on_exit_local_idx(
  visitor: BinaryModuleVisitor(ctx),
  on_exit_local_idx: VisitorCallback(ctx, LocalIDX),
) {
  BinaryModuleVisitor(..visitor, on_exit_local_idx: Some(on_exit_local_idx))
}

pub fn visit_module(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  module: BinaryModule,
) -> Result(#(ctx, BinaryModule), String) {
  do_visit_module(ctx, module, visitor)
}

pub fn visit_type_section(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  type_section: TypeSection,
) -> Result(#(ctx, Option(TypeSection)), String) {
  do_visit_type_section(ctx, Some(type_section), visitor)
}

pub fn visit_rec_type(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  rec_type: RecType,
) -> Result(#(ctx, RecType), String) {
  do_visit_rec_type(ctx, rec_type, visitor)
}

pub fn visit_sub_type(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  sub_type: SubType,
) -> Result(#(ctx, SubType), String) {
  do_visit_sub_type(ctx, sub_type, visitor)
}

pub fn visit_type_idx(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  type_idx: TypeIDX,
) -> Result(#(ctx, TypeIDX), String) {
  do_visit_type_idx(ctx, type_idx, visitor)
}

pub fn visit_composite_type(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  composite_type: CompositeType,
) -> Result(#(ctx, CompositeType), String) {
  do_visit_composite_type(ctx, composite_type, visitor)
}

pub fn visit_def_type(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  def_type: DefType,
) -> Result(#(ctx, DefType), String) {
  do_visit_def_type(ctx, def_type, visitor)
}

pub fn visit_func_type(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  func_type: FuncType,
) -> Result(#(ctx, FuncType), String) {
  do_visit_func_type(ctx, func_type, visitor)
}

pub fn visit_val_type(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  val_type: ValType,
) -> Result(#(ctx, ValType), String) {
  do_visit_val_type(ctx, val_type, visitor)
}

pub fn visit_ref_type(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  ref_type: RefType,
) -> Result(#(ctx, RefType), String) {
  do_visit_ref_type(ctx, ref_type, visitor)
}

pub fn visit_struct_type(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  struct_type: StructType,
) -> Result(#(ctx, StructType), String) {
  do_visit_struct_type(ctx, struct_type, visitor)
}

pub fn visit_array_type(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  array_type: ArrayType,
) -> Result(#(ctx, ArrayType), String) {
  do_visit_array_type(ctx, array_type, visitor)
}

pub fn visit_custom_section(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  custom_section: CustomSection,
) -> Result(#(ctx, Option(CustomSection)), String) {
  do_visit_custom_section(ctx, custom_section, visitor)
}

pub fn visit_import_section(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  imports: ImportSection,
) -> Result(#(ctx, Option(ImportSection)), String) {
  do_visit_import_section(ctx, Some(imports), visitor)
}

pub fn visit_import(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  import_: Import,
) -> Result(#(ctx, Import), String) {
  do_visit_import(ctx, import_, visitor)
}

pub fn visit_function_section(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  functions: FunctionSection,
) -> Result(#(ctx, Option(FunctionSection)), String) {
  do_visit_function_section(ctx, Some(functions), visitor)
}

pub fn visit_table_section(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  tables: TableSection,
) -> Result(#(ctx, Option(TableSection)), String) {
  do_visit_table_section(ctx, Some(tables), visitor)
}

pub fn visit_memory_section(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  memories: MemorySection,
) -> Result(#(ctx, Option(MemorySection)), String) {
  do_visit_memory_section(ctx, Some(memories), visitor)
}

pub fn visit_global_section(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  globals: GlobalSection,
) -> Result(#(ctx, Option(GlobalSection)), String) {
  do_visit_global_section(ctx, Some(globals), visitor)
}

pub fn visit_global(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  global: Global,
) -> Result(#(ctx, Global), String) {
  do_visit_global(ctx, global, visitor)
}

pub fn visit_export_section(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  exports: ExportSection,
) -> Result(#(ctx, Option(ExportSection)), String) {
  do_visit_export_section(ctx, Some(exports), visitor)
}

pub fn visit_export(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  export: Export,
) -> Result(#(ctx, Export), String) {
  do_visit_export(ctx, export, visitor)
}

pub fn visit_start_section(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  start: StartSection,
) -> Result(#(ctx, Option(StartSection)), String) {
  do_visit_start_section(ctx, Some(start), visitor)
}

pub fn visit_element_section(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  element_section: ElementSection,
) -> Result(#(ctx, Option(ElementSection)), String) {
  do_visit_element_section(ctx, Some(element_section), visitor)
}

pub fn visit_element_segment(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  element_segment: Elem,
) -> Result(#(ctx, Elem), String) {
  do_visit_element_segment(ctx, element_segment, visitor)
}

pub fn visit_element_mode(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  element_mode: ElemMode,
) -> Result(#(ctx, ElemMode), String) {
  do_visit_element_mode(ctx, element_mode, visitor)
}

pub fn visit_code_section(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  code_section: CodeSection,
) -> Result(#(ctx, Option(CodeSection)), String) {
  do_visit_code_section(ctx, Some(code_section), visitor)
}

pub fn visit_code(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  code: Code,
) -> Result(#(ctx, Code), String) {
  do_visit_code(ctx, code, visitor)
}

pub fn visit_locals(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  locals: Locals,
) -> Result(#(ctx, Locals), String) {
  do_visit_locals(ctx, locals, visitor)
}

pub fn visit_data_section(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  data_section: DataSection,
) -> Result(#(ctx, Option(DataSection)), String) {
  do_visit_data_section(ctx, Some(data_section), visitor)
}

pub fn visit_data(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  data: Data,
) -> Result(#(ctx, Data), String) {
  do_visit_data(ctx, data, visitor)
}

pub fn visit_data_count_section(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  data_count: DataCountSection,
) -> Result(#(ctx, Option(DataCountSection)), String) {
  do_visit_data_count_section(ctx, Some(data_count), visitor)
}

pub fn visit_heap_type(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  heap_type: HeapType,
) -> Result(#(ctx, HeapType), String) {
  do_visit_heap_type(ctx, heap_type, visitor)
}

pub fn visit_field_type(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  field_type: FieldType,
) -> Result(#(ctx, FieldType), String) {
  do_visit_field_type(ctx, field_type, visitor)
}

pub fn visit_storage_type(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  storage_type: StorageType,
) -> Result(#(ctx, StorageType), String) {
  do_visit_storage_type(ctx, storage_type, visitor)
}

pub fn visit_table_type(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  table_type: TableType,
) -> Result(#(ctx, TableType), String) {
  do_visit_table_type(ctx, table_type, visitor)
}

pub fn visit_limits(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  limits: Limits,
) -> Result(#(ctx, Limits), String) {
  do_visit_limits(ctx, limits, visitor)
}

pub fn visit_mem_type(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  mem_type: MemType,
) -> Result(#(ctx, MemType), String) {
  do_visit_mem_type(ctx, mem_type, visitor)
}

pub fn visit_global_type(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  global_type: GlobalType,
) -> Result(#(ctx, GlobalType), String) {
  do_visit_global_type(ctx, global_type, visitor)
}

pub fn visit_table(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  table: Table,
) -> Result(#(ctx, Table), String) {
  do_visit_table(ctx, table, visitor)
}

pub fn visit_expr(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  expr: Expr,
) -> Result(#(ctx, Expr), String) {
  do_visit_expr(ctx, expr, visitor)
}

pub fn visit_instruction(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  instruction: Instruction,
) -> Result(#(ctx, Instruction), String) {
  do_visit_instruction(ctx, instruction, visitor)
}

pub fn visit_func_idx(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  func_idx: FuncIDX,
) -> Result(#(ctx, FuncIDX), String) {
  do_visit_func_idx(ctx, func_idx, visitor)
}

pub fn visit_table_idx(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  table_idx: TableIDX,
) -> Result(#(ctx, TableIDX), String) {
  do_visit_table_idx(ctx, table_idx, visitor)
}

pub fn visit_mem_idx(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  mem_idx: MemIDX,
) -> Result(#(ctx, MemIDX), String) {
  do_visit_mem_idx(ctx, mem_idx, visitor)
}

pub fn visit_global_idx(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  global_idx: GlobalIDX,
) -> Result(#(ctx, GlobalIDX), String) {
  do_visit_global_idx(ctx, global_idx, visitor)
}

pub fn visit_label_idx(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  label_idx: LabelIDX,
) -> Result(#(ctx, LabelIDX), String) {
  do_visit_label_idx(ctx, label_idx, visitor)
}

pub fn visit_field_idx(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  field_idx: FieldIDX,
) -> Result(#(ctx, FieldIDX), String) {
  do_visit_field_idx(ctx, field_idx, visitor)
}

pub fn visit_data_idx(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  data_idx: DataIDX,
) -> Result(#(ctx, DataIDX), String) {
  do_visit_data_idx(ctx, data_idx, visitor)
}

pub fn visit_elem_idx(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  elem_idx: ElemIDX,
) -> Result(#(ctx, ElemIDX), String) {
  do_visit_elem_idx(ctx, elem_idx, visitor)
}

pub fn visit_local_idx(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  local_idx: LocalIDX,
) -> Result(#(ctx, LocalIDX), String) {
  do_visit_local_idx(ctx, local_idx, visitor)
}

pub fn visit_block_type(
  visitor: BinaryModuleVisitor(ctx),
  ctx,
  block_type: BlockType,
) -> Result(#(ctx, BlockType), String) {
  do_visit_block_type(ctx, block_type, visitor)
}
