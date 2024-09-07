import gleam/option.{type Option, None, Some}
import gleam/result.{map, try}
import internal/finger_tree.{type FingerTree}
import internal/structure/modules.{
  type BinaryModule, type CodeSection, type CustomSection, type DataCountSection,
  type DataSection, type ElementSection, type ExportSection,
  type FunctionSection, type GlobalSection, type ImportSection,
  type MemorySection, type StartSection, type TableSection, type TypeSection,
  BinaryModule, CodeSection, DataSection, ElementSection, ExportSection,
  FunctionSection, GlobalSection, ImportSection, MemorySection, StartSection,
  TableSection, TypeSection,
}
import internal/structure/types.{
  type ArrayType, type BlockType, type Code, type CompositeType, type Data,
  type DataIDX, type DefType, type Elem, type ElemIDX, type ElemMode,
  type Export, type Expr, type FieldIDX, type FieldType, type FuncIDX,
  type FuncType, type Global, type GlobalIDX, type GlobalType, type HeapType,
  type Import, type Instruction, type LabelIDX, type Limits, type LocalIDX,
  type Locals, type MemIDX, type MemType, type RecType, type RefType,
  type StorageType, type StructType, type SubType, type Table, type TableIDX,
  type TableType, type TypeIDX, type ValType, ActiveData, ActiveElemMode,
  AnyHeapType, AnyRefType, ArrayCompositeType, ArrayCopy, ArrayFill, ArrayGet,
  ArrayGetS, ArrayGetU, ArrayHeapType, ArrayInitData, ArrayInitElem, ArrayNew,
  ArrayNewData, ArrayNewDefault, ArrayNewElem, ArrayNewFixed, ArrayRefType,
  ArraySet, ArrayType, Block, Br, BrIf, BrOnCast, BrOnCastFail, BrOnNonNull,
  BrOnNull, BrTable, Call, CallIndirect, CallRef, Code, ConcreteHeapType,
  DataDrop, DeclarativeElemMode, DefType, DefTypeReference, ElemDrop,
  ElemExpressions, ElemFuncs, EqHeapType, EqRefType, Expr, ExternHeapType,
  ExternRefType, F32ValType, F64ValType, FieldType, FuncCompositeType,
  FuncExport, FuncHeapType, FuncImport, FuncRefType, FuncType, FuncTypeBlockType,
  Global, GlobalExport, GlobalGet, GlobalImport, GlobalSet, GlobalType,
  HeapTypeRefType, I16StorageType, I31HeapType, I31RefType, I32ValType,
  I64ValType, I8StorageType, If, LabelIDX, Limits, LocalGet, LocalSet, LocalTee,
  Locals, Loop, MemExport, MemIDX, MemImport, MemType, MemoryInit,
  NoExternHeapType, NoExternRefType, NoFuncHeapType, NoFuncRefType, NoneHeapType,
  NoneRefType, PassiveData, PassiveElemMode, RecType, RecTypeIDX, RefCast,
  RefCastNullable, RefFunc, RefNull, RefTest, RefTestNullable, RefTypeValType,
  ReturnCall, ReturnCallIndirect, ReturnCallRef, SelectT, StructCompositeType,
  StructGet, StructGetS, StructGetU, StructHeapType, StructRefType, StructSet,
  StructType, SubType, Table, TableCopy, TableExport, TableFill, TableGet,
  TableGrow, TableImport, TableInit, TableSet, TableSize, TableType, TypeIDX,
  V128ValType, ValTypeBlockType, ValTypeStorageType, VoidBlockType,
}
import pprint

pub type VisitorCallback(ctx, element) =
  fn(ctx, element) -> Result(#(ctx, element), String)

pub const empty_visitor = BinaryModuleVisitor(
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
  None,
)

pub type BinaryModuleVisitor(ctx) {
  BinaryModuleVisitor(
    on_enter_module: Option(VisitorCallback(ctx, BinaryModule)),
    on_exit_module: Option(VisitorCallback(ctx, BinaryModule)),
    on_enter_custom_section: Option(VisitorCallback(ctx, Option(CustomSection))),
    on_exit_custom_section: Option(VisitorCallback(ctx, Option(CustomSection))),
    on_enter_type_section: Option(VisitorCallback(ctx, Option(TypeSection))),
    on_exit_type_section: Option(VisitorCallback(ctx, Option(TypeSection))),
    on_enter_import_section: Option(VisitorCallback(ctx, Option(ImportSection))),
    on_exit_import_section: Option(VisitorCallback(ctx, Option(ImportSection))),
    on_enter_table_section: Option(VisitorCallback(ctx, Option(TableSection))),
    on_exit_table_section: Option(VisitorCallback(ctx, Option(TableSection))),
    on_enter_memory_section: Option(VisitorCallback(ctx, Option(MemorySection))),
    on_exit_memory_section: Option(VisitorCallback(ctx, Option(MemorySection))),
    on_enter_start_section: Option(VisitorCallback(ctx, Option(StartSection))),
    on_exit_start_section: Option(VisitorCallback(ctx, Option(StartSection))),
    on_enter_element_segment: Option(VisitorCallback(ctx, Elem)),
    on_exit_element_segment: Option(VisitorCallback(ctx, Elem)),
    on_enter_element_section: Option(
      VisitorCallback(ctx, Option(ElementSection)),
    ),
    on_exit_element_section: Option(
      VisitorCallback(ctx, Option(ElementSection)),
    ),
    on_enter_import: Option(VisitorCallback(ctx, Import)),
    on_exit_import: Option(VisitorCallback(ctx, Import)),
    on_enter_func_import: Option(VisitorCallback(ctx, Import)),
    on_exit_func_import: Option(VisitorCallback(ctx, Import)),
    on_enter_table_import: Option(VisitorCallback(ctx, Import)),
    on_exit_table_import: Option(VisitorCallback(ctx, Import)),
    on_enter_mem_import: Option(VisitorCallback(ctx, Import)),
    on_exit_mem_import: Option(VisitorCallback(ctx, Import)),
    on_enter_global_import: Option(VisitorCallback(ctx, Import)),
    on_exit_global_import: Option(VisitorCallback(ctx, Import)),
    on_enter_table_type: Option(VisitorCallback(ctx, TableType)),
    on_exit_table_type: Option(VisitorCallback(ctx, TableType)),
    on_enter_table: Option(VisitorCallback(ctx, Table)),
    on_exit_table: Option(VisitorCallback(ctx, Table)),
    on_enter_global: Option(VisitorCallback(ctx, Global)),
    on_exit_global: Option(VisitorCallback(ctx, Global)),
    on_enter_global_type: Option(VisitorCallback(ctx, GlobalType)),
    on_exit_global_type: Option(VisitorCallback(ctx, GlobalType)),
    on_enter_mem_type: Option(VisitorCallback(ctx, MemType)),
    on_exit_mem_type: Option(VisitorCallback(ctx, MemType)),
    on_enter_def_type: Option(VisitorCallback(ctx, DefType)),
    on_exit_def_type: Option(VisitorCallback(ctx, DefType)),
    on_enter_rec_type: Option(VisitorCallback(ctx, RecType)),
    on_exit_rec_type: Option(VisitorCallback(ctx, RecType)),
    on_enter_sub_type: Option(VisitorCallback(ctx, SubType)),
    on_exit_sub_type: Option(VisitorCallback(ctx, SubType)),
    on_enter_type_idx: Option(VisitorCallback(ctx, TypeIDX)),
    on_exit_type_idx: Option(VisitorCallback(ctx, TypeIDX)),
    on_enter_rec_type_idx: Option(VisitorCallback(ctx, TypeIDX)),
    on_exit_rec_type_idx: Option(VisitorCallback(ctx, TypeIDX)),
    on_enter_def_type_reference: Option(VisitorCallback(ctx, TypeIDX)),
    on_exit_def_type_reference: Option(VisitorCallback(ctx, TypeIDX)),
    on_enter_comp_type: Option(VisitorCallback(ctx, CompositeType)),
    on_exit_comp_type: Option(VisitorCallback(ctx, CompositeType)),
    on_enter_composite_type: Option(VisitorCallback(ctx, CompositeType)),
    on_exit_composite_type: Option(VisitorCallback(ctx, CompositeType)),
    on_enter_func_composite_type: Option(VisitorCallback(ctx, CompositeType)),
    on_exit_func_composite_type: Option(VisitorCallback(ctx, CompositeType)),
    on_enter_struct_composite_type: Option(VisitorCallback(ctx, CompositeType)),
    on_exit_struct_composite_type: Option(VisitorCallback(ctx, CompositeType)),
    on_enter_array_composite_type: Option(VisitorCallback(ctx, CompositeType)),
    on_exit_array_composite_type: Option(VisitorCallback(ctx, CompositeType)),
    on_enter_func_type: Option(VisitorCallback(ctx, FuncType)),
    on_enter_val_type: Option(VisitorCallback(ctx, ValType)),
    on_exit_val_type: Option(VisitorCallback(ctx, ValType)),
    on_exit_func_type: Option(VisitorCallback(ctx, FuncType)),
    on_enter_v128_val_type: Option(VisitorCallback(ctx, ValType)),
    on_exit_v128_val_type: Option(VisitorCallback(ctx, ValType)),
    on_enter_i32_val_type: Option(VisitorCallback(ctx, ValType)),
    on_exit_i32_val_type: Option(VisitorCallback(ctx, ValType)),
    on_enter_i64_val_type: Option(VisitorCallback(ctx, ValType)),
    on_exit_i64_val_type: Option(VisitorCallback(ctx, ValType)),
    on_enter_f32_val_type: Option(VisitorCallback(ctx, ValType)),
    on_exit_f32_val_type: Option(VisitorCallback(ctx, ValType)),
    on_enter_f64_val_type: Option(VisitorCallback(ctx, ValType)),
    on_exit_f64_val_type: Option(VisitorCallback(ctx, ValType)),
    on_enter_ref_type_val_type: Option(VisitorCallback(ctx, ValType)),
    on_exit_ref_type_val_type: Option(VisitorCallback(ctx, ValType)),
    on_enter_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_exit_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_enter_heap_type_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_exit_heap_type_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_enter_any_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_exit_any_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_enter_eq_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_exit_eq_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_enter_i31_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_exit_i31_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_enter_struct_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_exit_struct_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_enter_array_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_exit_array_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_enter_func_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_exit_func_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_enter_extern_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_exit_extern_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_enter_none_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_exit_none_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_enter_no_func_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_exit_no_func_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_enter_no_extern_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_exit_no_extern_ref_type: Option(VisitorCallback(ctx, RefType)),
    on_enter_struct_type: Option(VisitorCallback(ctx, StructType)),
    on_exit_struct_type: Option(VisitorCallback(ctx, StructType)),
    on_enter_field_type: Option(VisitorCallback(ctx, FieldType)),
    on_exit_field_type: Option(VisitorCallback(ctx, FieldType)),
    on_enter_storage_type: Option(VisitorCallback(ctx, StorageType)),
    on_enter_i8_storage_type: Option(VisitorCallback(ctx, StorageType)),
    on_enter_i16_storage_type: Option(VisitorCallback(ctx, StorageType)),
    on_enter_val_type_storage_type: Option(VisitorCallback(ctx, StorageType)),
    on_exit_i8_storage_type: Option(VisitorCallback(ctx, StorageType)),
    on_exit_i16_storage_type: Option(VisitorCallback(ctx, StorageType)),
    on_exit_val_type_storage_type: Option(VisitorCallback(ctx, StorageType)),
    on_exit_storage_type: Option(VisitorCallback(ctx, StorageType)),
    on_enter_array_type: Option(VisitorCallback(ctx, ArrayType)),
    on_exit_array_type: Option(VisitorCallback(ctx, ArrayType)),
    on_enter_function_section: Option(
      VisitorCallback(ctx, Option(FunctionSection)),
    ),
    on_exit_function_section: Option(
      VisitorCallback(ctx, Option(FunctionSection)),
    ),
    on_enter_code_section: Option(VisitorCallback(ctx, Option(CodeSection))),
    on_exit_code_section: Option(VisitorCallback(ctx, Option(CodeSection))),
    on_enter_func_idx: Option(VisitorCallback(ctx, FuncIDX)),
    on_exit_func_idx: Option(VisitorCallback(ctx, FuncIDX)),
    on_enter_table_idx: Option(VisitorCallback(ctx, TableIDX)),
    on_exit_table_idx: Option(VisitorCallback(ctx, TableIDX)),
    on_enter_mem_idx: Option(VisitorCallback(ctx, MemIDX)),
    on_exit_mem_idx: Option(VisitorCallback(ctx, MemIDX)),
    on_enter_global_idx: Option(VisitorCallback(ctx, GlobalIDX)),
    on_exit_global_idx: Option(VisitorCallback(ctx, GlobalIDX)),
    on_enter_elem_expressions: Option(VisitorCallback(ctx, Elem)),
    on_exit_elem_expressions: Option(VisitorCallback(ctx, Elem)),
    on_enter_elem_funcs: Option(VisitorCallback(ctx, Elem)),
    on_exit_elem_funcs: Option(VisitorCallback(ctx, Elem)),
    on_enter_global_section: Option(VisitorCallback(ctx, Option(GlobalSection))),
    on_exit_global_section: Option(VisitorCallback(ctx, Option(GlobalSection))),
    on_enter_export_section: Option(VisitorCallback(ctx, Option(ExportSection))),
    on_exit_export_section: Option(VisitorCallback(ctx, Option(ExportSection))),
    on_enter_export: Option(VisitorCallback(ctx, Export)),
    on_exit_export: Option(VisitorCallback(ctx, Export)),
    on_enter_func_export: Option(VisitorCallback(ctx, Export)),
    on_exit_func_export: Option(VisitorCallback(ctx, Export)),
    on_enter_table_export: Option(VisitorCallback(ctx, Export)),
    on_exit_table_export: Option(VisitorCallback(ctx, Export)),
    on_enter_mem_export: Option(VisitorCallback(ctx, Export)),
    on_exit_mem_export: Option(VisitorCallback(ctx, Export)),
    on_enter_global_export: Option(VisitorCallback(ctx, Export)),
    on_exit_global_export: Option(VisitorCallback(ctx, Export)),
    on_enter_limits: Option(VisitorCallback(ctx, Limits)),
    on_exit_limits: Option(VisitorCallback(ctx, Limits)),
    on_enter_expr: Option(VisitorCallback(ctx, Expr)),
    on_exit_expr: Option(VisitorCallback(ctx, Expr)),
    on_enter_instruction: Option(VisitorCallback(ctx, Instruction)),
    on_exit_instruction: Option(VisitorCallback(ctx, Instruction)),
    on_enter_element_mode: Option(VisitorCallback(ctx, ElemMode)),
    on_exit_element_mode: Option(VisitorCallback(ctx, ElemMode)),
    on_enter_declarative_elem_mode: Option(VisitorCallback(ctx, ElemMode)),
    on_exit_declarative_elem_mode: Option(VisitorCallback(ctx, ElemMode)),
    on_enter_passive_elem_mode: Option(VisitorCallback(ctx, ElemMode)),
    on_exit_passive_elem_mode: Option(VisitorCallback(ctx, ElemMode)),
    on_enter_active_elem_mode: Option(VisitorCallback(ctx, ElemMode)),
    on_exit_active_elem_mode: Option(VisitorCallback(ctx, ElemMode)),
    on_enter_code: Option(VisitorCallback(ctx, Code)),
    on_exit_code: Option(VisitorCallback(ctx, Code)),
    on_enter_locals: Option(VisitorCallback(ctx, Locals)),
    on_exit_locals: Option(VisitorCallback(ctx, Locals)),
    on_enter_data_section: Option(VisitorCallback(ctx, Option(DataSection))),
    on_exit_data_section: Option(VisitorCallback(ctx, Option(DataSection))),
    on_enter_active_data: Option(VisitorCallback(ctx, Data)),
    on_exit_active_data: Option(VisitorCallback(ctx, Data)),
    on_enter_passive_data: Option(VisitorCallback(ctx, Data)),
    on_exit_passive_data: Option(VisitorCallback(ctx, Data)),
    on_enter_data: Option(VisitorCallback(ctx, Data)),
    on_exit_data: Option(VisitorCallback(ctx, Data)),
    on_enter_data_count_section: Option(
      VisitorCallback(ctx, Option(DataCountSection)),
    ),
    on_exit_data_count_section: Option(
      VisitorCallback(ctx, Option(DataCountSection)),
    ),
    on_enter_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_exit_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_enter_func_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_exit_func_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_enter_no_func_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_exit_no_func_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_enter_extern_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_exit_extern_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_enter_no_extern_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_exit_no_extern_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_enter_any_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_exit_any_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_enter_eq_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_exit_eq_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_enter_i31_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_exit_i31_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_enter_struct_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_exit_struct_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_enter_array_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_exit_array_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_enter_none_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_exit_none_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_enter_concrete_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_exit_concrete_heap_type: Option(VisitorCallback(ctx, HeapType)),
    on_enter_ref_null: Option(VisitorCallback(ctx, Instruction)),
    on_exit_ref_null: Option(VisitorCallback(ctx, Instruction)),
    on_enter_ref_func: Option(VisitorCallback(ctx, Instruction)),
    on_exit_ref_func: Option(VisitorCallback(ctx, Instruction)),
    on_enter_ref_test: Option(VisitorCallback(ctx, Instruction)),
    on_exit_ref_test: Option(VisitorCallback(ctx, Instruction)),
    on_enter_ref_test_nullable: Option(VisitorCallback(ctx, Instruction)),
    on_exit_ref_test_nullable: Option(VisitorCallback(ctx, Instruction)),
    on_enter_ref_cast: Option(VisitorCallback(ctx, Instruction)),
    on_exit_ref_cast: Option(VisitorCallback(ctx, Instruction)),
    on_enter_ref_cast_nullable: Option(VisitorCallback(ctx, Instruction)),
    on_exit_ref_cast_nullable: Option(VisitorCallback(ctx, Instruction)),
    on_enter_struct_get: Option(VisitorCallback(ctx, Instruction)),
    on_exit_struct_get: Option(VisitorCallback(ctx, Instruction)),
    on_enter_struct_get_s: Option(VisitorCallback(ctx, Instruction)),
    on_exit_struct_get_s: Option(VisitorCallback(ctx, Instruction)),
    on_enter_struct_get_u: Option(VisitorCallback(ctx, Instruction)),
    on_exit_struct_get_u: Option(VisitorCallback(ctx, Instruction)),
    on_enter_struct_set: Option(VisitorCallback(ctx, Instruction)),
    on_exit_struct_set: Option(VisitorCallback(ctx, Instruction)),
    on_enter_array_new: Option(VisitorCallback(ctx, Instruction)),
    on_exit_array_new: Option(VisitorCallback(ctx, Instruction)),
    on_enter_array_new_default: Option(VisitorCallback(ctx, Instruction)),
    on_exit_array_new_default: Option(VisitorCallback(ctx, Instruction)),
    on_enter_array_new_data: Option(VisitorCallback(ctx, Instruction)),
    on_exit_array_new_data: Option(VisitorCallback(ctx, Instruction)),
    on_enter_array_new_elem: Option(VisitorCallback(ctx, Instruction)),
    on_exit_array_new_elem: Option(VisitorCallback(ctx, Instruction)),
    on_enter_array_new_fixed: Option(VisitorCallback(ctx, Instruction)),
    on_exit_array_new_fixed: Option(VisitorCallback(ctx, Instruction)),
    on_enter_array_get: Option(VisitorCallback(ctx, Instruction)),
    on_exit_array_get: Option(VisitorCallback(ctx, Instruction)),
    on_enter_array_get_s: Option(VisitorCallback(ctx, Instruction)),
    on_exit_array_get_s: Option(VisitorCallback(ctx, Instruction)),
    on_enter_array_get_u: Option(VisitorCallback(ctx, Instruction)),
    on_exit_array_get_u: Option(VisitorCallback(ctx, Instruction)),
    on_enter_array_set: Option(VisitorCallback(ctx, Instruction)),
    on_exit_array_set: Option(VisitorCallback(ctx, Instruction)),
    on_enter_array_fill: Option(VisitorCallback(ctx, Instruction)),
    on_exit_array_fill: Option(VisitorCallback(ctx, Instruction)),
    on_enter_array_copy: Option(VisitorCallback(ctx, Instruction)),
    on_exit_array_copy: Option(VisitorCallback(ctx, Instruction)),
    on_enter_array_init_data: Option(VisitorCallback(ctx, Instruction)),
    on_exit_array_init_data: Option(VisitorCallback(ctx, Instruction)),
    on_enter_array_init_elem: Option(VisitorCallback(ctx, Instruction)),
    on_exit_array_init_elem: Option(VisitorCallback(ctx, Instruction)),
    on_enter_select_t: Option(VisitorCallback(ctx, Instruction)),
    on_exit_select_t: Option(VisitorCallback(ctx, Instruction)),
    on_enter_local_get: Option(VisitorCallback(ctx, Instruction)),
    on_exit_local_get: Option(VisitorCallback(ctx, Instruction)),
    on_enter_local_set: Option(VisitorCallback(ctx, Instruction)),
    on_exit_local_set: Option(VisitorCallback(ctx, Instruction)),
    on_enter_local_tee: Option(VisitorCallback(ctx, Instruction)),
    on_exit_local_tee: Option(VisitorCallback(ctx, Instruction)),
    on_enter_global_get: Option(VisitorCallback(ctx, Instruction)),
    on_exit_global_get: Option(VisitorCallback(ctx, Instruction)),
    on_enter_global_set: Option(VisitorCallback(ctx, Instruction)),
    on_exit_global_set: Option(VisitorCallback(ctx, Instruction)),
    on_enter_table_get: Option(VisitorCallback(ctx, Instruction)),
    on_exit_table_get: Option(VisitorCallback(ctx, Instruction)),
    on_enter_table_set: Option(VisitorCallback(ctx, Instruction)),
    on_exit_table_set: Option(VisitorCallback(ctx, Instruction)),
    on_enter_table_size: Option(VisitorCallback(ctx, Instruction)),
    on_exit_table_size: Option(VisitorCallback(ctx, Instruction)),
    on_enter_table_grow: Option(VisitorCallback(ctx, Instruction)),
    on_exit_table_grow: Option(VisitorCallback(ctx, Instruction)),
    on_enter_table_fill: Option(VisitorCallback(ctx, Instruction)),
    on_exit_table_fill: Option(VisitorCallback(ctx, Instruction)),
    on_enter_table_copy: Option(VisitorCallback(ctx, Instruction)),
    on_exit_table_copy: Option(VisitorCallback(ctx, Instruction)),
    on_enter_table_init: Option(VisitorCallback(ctx, Instruction)),
    on_exit_table_init: Option(VisitorCallback(ctx, Instruction)),
    on_enter_elem_drop: Option(VisitorCallback(ctx, Instruction)),
    on_exit_elem_drop: Option(VisitorCallback(ctx, Instruction)),
    on_enter_memory_init: Option(VisitorCallback(ctx, Instruction)),
    on_exit_memory_init: Option(VisitorCallback(ctx, Instruction)),
    on_enter_data_drop: Option(VisitorCallback(ctx, Instruction)),
    on_exit_data_drop: Option(VisitorCallback(ctx, Instruction)),
    on_enter_block: Option(VisitorCallback(ctx, Instruction)),
    on_exit_block: Option(VisitorCallback(ctx, Instruction)),
    on_enter_loop: Option(VisitorCallback(ctx, Instruction)),
    on_exit_loop: Option(VisitorCallback(ctx, Instruction)),
    on_enter_if: Option(VisitorCallback(ctx, Instruction)),
    on_exit_if: Option(VisitorCallback(ctx, Instruction)),
    on_enter_br: Option(VisitorCallback(ctx, Instruction)),
    on_exit_br: Option(VisitorCallback(ctx, Instruction)),
    on_enter_br_if: Option(VisitorCallback(ctx, Instruction)),
    on_exit_br_if: Option(VisitorCallback(ctx, Instruction)),
    on_enter_br_table: Option(VisitorCallback(ctx, Instruction)),
    on_exit_br_table: Option(VisitorCallback(ctx, Instruction)),
    on_enter_br_on_null: Option(VisitorCallback(ctx, Instruction)),
    on_exit_br_on_null: Option(VisitorCallback(ctx, Instruction)),
    on_enter_br_on_non_null: Option(VisitorCallback(ctx, Instruction)),
    on_exit_br_on_non_null: Option(VisitorCallback(ctx, Instruction)),
    on_enter_br_on_cast: Option(VisitorCallback(ctx, Instruction)),
    on_exit_br_on_cast: Option(VisitorCallback(ctx, Instruction)),
    on_enter_br_on_cast_fail: Option(VisitorCallback(ctx, Instruction)),
    on_exit_br_on_cast_fail: Option(VisitorCallback(ctx, Instruction)),
    on_enter_call: Option(VisitorCallback(ctx, Instruction)),
    on_exit_call: Option(VisitorCallback(ctx, Instruction)),
    on_enter_call_ref: Option(VisitorCallback(ctx, Instruction)),
    on_exit_call_ref: Option(VisitorCallback(ctx, Instruction)),
    on_enter_call_indirect: Option(VisitorCallback(ctx, Instruction)),
    on_exit_call_indirect: Option(VisitorCallback(ctx, Instruction)),
    on_enter_return_call: Option(VisitorCallback(ctx, Instruction)),
    on_exit_return_call: Option(VisitorCallback(ctx, Instruction)),
    on_enter_return_call_ref: Option(VisitorCallback(ctx, Instruction)),
    on_exit_return_call_ref: Option(VisitorCallback(ctx, Instruction)),
    on_enter_return_call_indirect: Option(VisitorCallback(ctx, Instruction)),
    on_exit_return_call_indirect: Option(VisitorCallback(ctx, Instruction)),
    on_enter_label_idx: Option(VisitorCallback(ctx, LabelIDX)),
    on_exit_label_idx: Option(VisitorCallback(ctx, LabelIDX)),
    on_enter_block_type: Option(VisitorCallback(ctx, BlockType)),
    on_exit_block_type: Option(VisitorCallback(ctx, BlockType)),
    on_enter_void_block_type: Option(VisitorCallback(ctx, BlockType)),
    on_exit_void_block_type: Option(VisitorCallback(ctx, BlockType)),
    on_enter_val_type_block_type: Option(VisitorCallback(ctx, BlockType)),
    on_exit_val_type_block_type: Option(VisitorCallback(ctx, BlockType)),
    on_enter_func_type_block_type: Option(VisitorCallback(ctx, BlockType)),
    on_exit_func_type_block_type: Option(VisitorCallback(ctx, BlockType)),
    on_enter_field_idx: Option(VisitorCallback(ctx, FieldIDX)),
    on_exit_field_idx: Option(VisitorCallback(ctx, FieldIDX)),
    on_enter_data_idx: Option(VisitorCallback(ctx, DataIDX)),
    on_exit_data_idx: Option(VisitorCallback(ctx, DataIDX)),
    on_enter_elem_idx: Option(VisitorCallback(ctx, ElemIDX)),
    on_exit_elem_idx: Option(VisitorCallback(ctx, ElemIDX)),
    on_enter_local_idx: Option(VisitorCallback(ctx, LocalIDX)),
    on_exit_local_idx: Option(VisitorCallback(ctx, LocalIDX)),
  )
}

pub fn do_visit_module(
  ctx: context,
  module: BinaryModule,
  visitor: BinaryModuleVisitor(context),
) {
  let BinaryModuleVisitor(
    on_enter_module: on_enter,
    on_exit_module: on_exit,
    ..,
  ) = visitor

  use #(ctx, module) <- try(case on_enter {
    Some(f) -> f(ctx, module)
    None -> Ok(#(ctx, module))
  })

  use #(ctx, custom_0) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_0,
    visitor,
  ))
  use #(ctx, types) <- result.try(do_visit_type_section(
    ctx,
    module.types,
    visitor,
  ))
  use #(ctx, custom_1) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_1,
    visitor,
  ))
  use #(ctx, imports) <- result.try(do_visit_import_section(
    ctx,
    module.imports,
    visitor,
  ))
  use #(ctx, custom_2) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_2,
    visitor,
  ))
  use #(ctx, functions) <- result.try(do_visit_function_section(
    ctx,
    module.functions,
    visitor,
  ))
  use #(ctx, custom_3) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_3,
    visitor,
  ))
  use #(ctx, tables) <- result.try(do_visit_table_section(
    ctx,
    module.tables,
    visitor,
  ))
  use #(ctx, custom_4) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_4,
    visitor,
  ))
  use #(ctx, memories) <- result.try(do_visit_memory_section(
    ctx,
    module.memories,
    visitor,
  ))
  use #(ctx, custom_5) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_5,
    visitor,
  ))
  use #(ctx, globals) <- result.try(do_visit_global_section(
    ctx,
    module.globals,
    visitor,
  ))
  use #(ctx, custom_6) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_6,
    visitor,
  ))
  use #(ctx, exports) <- result.try(do_visit_export_section(
    ctx,
    module.exports,
    visitor,
  ))
  use #(ctx, custom_7) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_7,
    visitor,
  ))
  use #(ctx, start) <- result.try(do_visit_start_section(
    ctx,
    module.start,
    visitor,
  ))
  use #(ctx, custom_8) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_8,
    visitor,
  ))
  use #(ctx, elements) <- result.try(do_visit_element_section(
    ctx,
    module.elements,
    visitor,
  ))
  use #(ctx, custom_9) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_9,
    visitor,
  ))
  use #(ctx, code) <- result.try(do_visit_code_section(
    ctx,
    module.code,
    visitor,
  ))
  use #(ctx, custom_10) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_10,
    visitor,
  ))
  use #(ctx, data) <- result.try(do_visit_data_section(
    ctx,
    module.data,
    visitor,
  ))
  use #(ctx, custom_11) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_11,
    visitor,
  ))
  use #(ctx, data_count) <- result.try(do_visit_data_count_section(
    ctx,
    module.data_count,
    visitor,
  ))
  use #(ctx, custom_12) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_12,
    visitor,
  ))

  let module =
    BinaryModule(
      custom_0: custom_0,
      types: types,
      custom_1: custom_1,
      imports: imports,
      custom_2: custom_2,
      functions: functions,
      custom_3: custom_3,
      tables: tables,
      custom_4: custom_4,
      memories: memories,
      custom_5: custom_5,
      globals: globals,
      custom_6: custom_6,
      exports: exports,
      custom_7: custom_7,
      start: start,
      custom_8: custom_8,
      elements: elements,
      custom_9: custom_9,
      code: code,
      custom_10: custom_10,
      data: data,
      custom_11: custom_11,
      data_count: data_count,
      custom_12: custom_12,
    )
  case on_exit {
    Some(f) -> f(ctx, module)
    None -> Ok(#(ctx, module))
  }
}

fn do_visit(ctx, element, visitor: Option(VisitorCallback(ctx, element))) {
  case visitor {
    Some(f) -> f(ctx, element)
    None -> Ok(#(ctx, element))
  }
}

fn do_visit_element_list(
  ctx,
  elements: FingerTree(element),
  visitor: BinaryModuleVisitor(ctx),
  do_visit_callback: fn(ctx, element, BinaryModuleVisitor(ctx)) ->
    Result(#(ctx, element), String),
) {
  use #(ctx, elements, _) <- map(
    finger_tree.try_reducel(
      elements,
      #(ctx, finger_tree.empty, visitor),
      fn(acc, element) {
        let #(ctx, acc, visitor) = acc
        use #(ctx, element) <- map(do_visit_callback(ctx, element, visitor))
        #(ctx, acc |> finger_tree.push(element), visitor)
      },
    ),
  )
  #(ctx, elements)
}

pub fn do_visit_type_section(
  ctx,
  type_section: Option(TypeSection),
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Option(TypeSection)), String) {
  use #(ctx, type_section) <- enter(
    ctx,
    type_section,
    visitor.on_enter_type_section,
    visitor.on_exit_type_section,
  )

  case type_section {
    Some(TypeSection(types)) -> {
      use #(ctx, types) <- map(do_visit_element_list(
        ctx,
        types,
        visitor,
        do_visit_rec_type,
      ))
      #(ctx, Some(TypeSection(types)))
    }
    None -> Ok(#(ctx, None))
  }
}

pub fn do_visit_rec_type(
  ctx,
  rec_type: RecType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, RecType), String) {
  use #(ctx, rec_type) <- enter(
    ctx,
    rec_type,
    visitor.on_enter_rec_type,
    visitor.on_exit_rec_type,
  )
  use #(ctx, sub_types) <- map(do_visit_element_list(
    ctx,
    rec_type.sub_types,
    visitor,
    do_visit_sub_type,
  ))
  #(ctx, RecType(sub_types))
}

pub fn do_visit_sub_type(
  ctx,
  sub_type,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, SubType), String) {
  use #(ctx, SubType(final, t, ct)) <- enter(
    ctx,
    sub_type,
    visitor.on_enter_sub_type,
    visitor.on_exit_sub_type,
  )
  use #(ctx, t) <- try(do_visit_element_list(ctx, t, visitor, do_visit_type_idx))
  use #(ctx, ct) <- map(do_visit_composite_type(ctx, ct, visitor))
  #(ctx, SubType(final, t, ct))
}

pub fn do_visit_type_idx(
  ctx,
  type_idx: TypeIDX,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, TypeIDX), String) {
  use #(ctx, type_idx) <- enter(
    ctx,
    type_idx,
    visitor.on_enter_type_idx,
    visitor.on_exit_type_idx,
  )

  case type_idx {
    TypeIDX(_) -> Ok(#(ctx, type_idx))
    RecTypeIDX(_) ->
      enter(
        ctx,
        type_idx,
        visitor.on_enter_rec_type_idx,
        visitor.on_exit_rec_type_idx,
        Ok,
      )
    DefTypeReference(_) ->
      enter(
        ctx,
        type_idx,
        visitor.on_enter_def_type_reference,
        visitor.on_exit_def_type_reference,
        Ok,
      )
  }
}

pub fn do_visit_composite_type(
  ctx,
  composite_type: CompositeType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, CompositeType), String) {
  use #(ctx, composite_type) <- enter(
    ctx,
    composite_type,
    visitor.on_enter_composite_type,
    visitor.on_exit_composite_type,
  )

  use #(ctx, composite_type) <-
    case composite_type {
      FuncCompositeType(_) -> enter(
        ctx,
        composite_type,
        visitor.on_enter_func_composite_type,
        visitor.on_exit_func_composite_type,
        _,
      )
      StructCompositeType(_) -> enter(
        ctx,
        composite_type,
        visitor.on_enter_struct_composite_type,
        visitor.on_exit_struct_composite_type,
        _,
      )
      ArrayCompositeType(_) -> enter(
        ctx,
        composite_type,
        visitor.on_enter_array_composite_type,
        visitor.on_exit_array_composite_type,
        _,
      )
    }

  case composite_type {
    FuncCompositeType(func_type) -> {
      use #(ctx, func_type) <- map(do_visit_func_type(ctx, func_type, visitor))
      #(ctx, FuncCompositeType(func_type))
    }
    StructCompositeType(struct_type) -> {
      use #(ctx, struct_type) <- map(do_visit_struct_type(
        ctx,
        struct_type,
        visitor,
      ))
      #(ctx, StructCompositeType(struct_type))
    }
    ArrayCompositeType(array_type) -> {
      use #(ctx, array_type) <- map(do_visit_array_type(
        ctx,
        array_type,
        visitor,
      ))
      #(ctx, ArrayCompositeType(array_type))
    }
  }
}

pub fn do_visit_def_type(
  ctx,
  def_type: DefType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, DefType), String) {
  use #(ctx, DefType(rec_type, idx)) <- enter(
    ctx,
    def_type,
    visitor.on_enter_def_type,
    visitor.on_exit_def_type,
  )

  use #(ctx, rec_type) <- map(do_visit_rec_type(ctx, rec_type, visitor))

  #(ctx, DefType(rec_type, idx))
}

pub fn do_visit_func_type(
  ctx,
  func_type: FuncType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, FuncType), String) {
  use #(ctx, FuncType(parameters, results)) <- enter(
    ctx,
    func_type,
    visitor.on_enter_func_type,
    visitor.on_exit_func_type,
  )

  use #(ctx, parameters) <- try(do_visit_element_list(
    ctx,
    parameters,
    visitor,
    do_visit_val_type,
  ))

  use #(ctx, results) <- map(do_visit_element_list(
    ctx,
    results,
    visitor,
    do_visit_val_type,
  ))

  #(ctx, FuncType(parameters, results))
}

pub fn do_visit_val_type(
  ctx,
  val_type: ValType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, ValType), String) {
  use #(ctx, val_type) <- enter(
    ctx,
    val_type,
    visitor.on_enter_val_type,
    visitor.on_exit_val_type,
  )

  use #(ctx, val_type) <-
    case val_type {
      V128ValType -> enter(
        ctx,
        val_type,
        visitor.on_enter_v128_val_type,
        visitor.on_exit_v128_val_type,
        _,
      )
      I32ValType -> enter(
        ctx,
        val_type,
        visitor.on_enter_i32_val_type,
        visitor.on_exit_i32_val_type,
        _,
      )
      I64ValType -> enter(
        ctx,
        val_type,
        visitor.on_enter_i64_val_type,
        visitor.on_exit_i64_val_type,
        _,
      )
      F32ValType -> enter(
        ctx,
        val_type,
        visitor.on_enter_f32_val_type,
        visitor.on_exit_f32_val_type,
        _,
      )
      F64ValType -> enter(
        ctx,
        val_type,
        visitor.on_enter_f64_val_type,
        visitor.on_exit_f64_val_type,
        _,
      )
      RefTypeValType(_) -> enter(
        ctx,
        val_type,
        visitor.on_enter_ref_type_val_type,
        visitor.on_exit_ref_type_val_type,
        _,
      )
      _ -> try(Ok(#(ctx, val_type)), _)
    }

  case val_type {
    RefTypeValType(rt) -> {
      use #(ctx, rt) <- map(do_visit_ref_type(ctx, rt, visitor))

      #(ctx, RefTypeValType(rt))
    }
    _ -> Ok(#(ctx, val_type))
  }
}

pub fn do_visit_ref_type(
  ctx,
  ref_type: RefType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, RefType), String) {
  use #(ctx, ref_type) <- enter(
    ctx,
    ref_type,
    visitor.on_enter_ref_type,
    visitor.on_exit_ref_type,
  )

  use #(ctx, ref_type) <-
    case ref_type {
      HeapTypeRefType(_, _) -> enter(
        ctx,
        ref_type,
        visitor.on_enter_heap_type_ref_type,
        visitor.on_exit_heap_type_ref_type,
        _,
      )
      AnyRefType -> enter(
        ctx,
        ref_type,
        visitor.on_enter_any_ref_type,
        visitor.on_exit_any_ref_type,
        _,
      )
      EqRefType -> enter(
        ctx,
        ref_type,
        visitor.on_enter_eq_ref_type,
        visitor.on_exit_eq_ref_type,
        _,
      )
      I31RefType -> enter(
        ctx,
        ref_type,
        visitor.on_enter_i31_ref_type,
        visitor.on_exit_i31_ref_type,
        _,
      )
      StructRefType -> enter(
        ctx,
        ref_type,
        visitor.on_enter_struct_ref_type,
        visitor.on_exit_struct_ref_type,
        _,
      )
      ArrayRefType -> enter(
        ctx,
        ref_type,
        visitor.on_enter_array_ref_type,
        visitor.on_exit_array_ref_type,
        _,
      )
      FuncRefType -> enter(
        ctx,
        ref_type,
        visitor.on_enter_func_ref_type,
        visitor.on_exit_func_ref_type,
        _,
      )
      ExternRefType -> enter(
        ctx,
        ref_type,
        visitor.on_enter_extern_ref_type,
        visitor.on_exit_extern_ref_type,
        _,
      )
      NoneRefType -> enter(
        ctx,
        ref_type,
        visitor.on_enter_none_ref_type,
        visitor.on_exit_none_ref_type,
        _,
      )
      NoFuncRefType -> enter(
        ctx,
        ref_type,
        visitor.on_enter_no_func_ref_type,
        visitor.on_exit_no_func_ref_type,
        _,
      )
      NoExternRefType -> enter(
        ctx,
        ref_type,
        visitor.on_enter_no_extern_ref_type,
        visitor.on_exit_no_extern_ref_type,
        _,
      )
    }
  case ref_type {
    HeapTypeRefType(ht, mut) -> {
      use #(ctx, ht) <- map(do_visit_heap_type(ctx, ht, visitor))
      #(ctx, HeapTypeRefType(ht, mut))
    }
    _ -> Ok(#(ctx, ref_type))
  }
}

pub fn do_visit_struct_type(
  ctx,
  struct_type: StructType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, StructType), String) {
  use #(ctx, StructType(fields)) <- enter(
    ctx,
    struct_type,
    visitor.on_enter_struct_type,
    visitor.on_exit_struct_type,
  )

  use #(ctx, fields) <- map(do_visit_element_list(
    ctx,
    fields,
    visitor,
    do_visit_field_type,
  ))
  #(ctx, StructType(fields))
}

pub fn do_visit_array_type(
  ctx,
  array_type: ArrayType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, ArrayType), String) {
  use #(ctx, ArrayType(field_type)) <- enter(
    ctx,
    array_type,
    visitor.on_enter_array_type,
    visitor.on_exit_array_type,
  )

  use #(ctx, field_type) <- map(do_visit_field_type(ctx, field_type, visitor))
  #(ctx, ArrayType(field_type))
}

pub fn do_visit_custom_sections(
  ctx,
  custom_sections: Option(FingerTree(CustomSection)),
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Option(FingerTree(CustomSection))), String) {
  case custom_sections {
    Some(custom_sections) ->
      do_visit_custom_sections_filter(
        ctx,
        custom_sections,
        finger_tree.empty,
        visitor,
      )
    _ -> Ok(#(ctx, custom_sections))
  }
}

fn do_visit_custom_sections_filter(
  ctx,
  custom_sections: FingerTree(CustomSection),
  acc: FingerTree(CustomSection),
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Option(FingerTree(CustomSection))), String) {
  case finger_tree.shift(custom_sections) {
    Ok(#(custom_section, custom_sections)) -> {
      use #(ctx, custom_section) <- try(do_visit_custom_section(
        ctx,
        custom_section,
        visitor,
      ))
      case custom_section {
        Some(custom_section) ->
          do_visit_custom_sections_filter(
            ctx,
            custom_sections,
            finger_tree.push(acc, custom_section),
            visitor,
          )
        None ->
          do_visit_custom_sections_filter(ctx, custom_sections, acc, visitor)
      }
    }
    _ -> Ok(#(ctx, Some(acc)))
  }
}

pub fn do_visit_custom_section(
  ctx,
  custom_section: CustomSection,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Option(CustomSection)), String) {
  enter(
    ctx,
    Some(custom_section),
    visitor.on_enter_custom_section,
    visitor.on_exit_custom_section,
    Ok,
  )
}

pub fn do_visit_import_section(
  ctx,
  import_section: Option(ImportSection),
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Option(ImportSection)), String) {
  use #(ctx, import_section) <- enter(
    ctx,
    import_section,
    visitor.on_enter_import_section,
    visitor.on_exit_import_section,
  )

  case import_section {
    Some(ImportSection(imports)) -> {
      use #(ctx, imports) <- map(do_visit_element_list(
        ctx,
        imports,
        visitor,
        do_visit_import,
      ))
      #(ctx, Some(ImportSection(imports)))
    }
    _ -> Ok(#(ctx, import_section))
  }
}

pub fn do_visit_import(ctx, import_: Import, visitor: BinaryModuleVisitor(ctx)) {
  use #(ctx, import_) <- enter(
    ctx,
    import_,
    visitor.on_enter_import,
    visitor.on_exit_import,
  )

  use #(ctx, import_) <-
    case import_ {
      FuncImport(_, _, _) -> enter(
        ctx,
        import_,
        visitor.on_enter_func_import,
        visitor.on_exit_func_import,
        _,
      )
      TableImport(_, _, _) -> enter(
        ctx,
        import_,
        visitor.on_enter_table_import,
        visitor.on_exit_table_import,
        _,
      )
      MemImport(_, _, _) -> enter(
        ctx,
        import_,
        visitor.on_enter_mem_import,
        visitor.on_exit_mem_import,
        _,
      )
      GlobalImport(_, _, _) -> enter(
        ctx,
        import_,
        visitor.on_enter_global_import,
        visitor.on_exit_global_import,
        _,
      )
    }
  case import_ {
    FuncImport(mod, name, type_idx) -> {
      use #(ctx, type_idx) <- map(do_visit_type_idx(ctx, type_idx, visitor))
      #(ctx, FuncImport(mod, name, type_idx))
    }
    TableImport(mod, name, table_type) -> {
      use #(ctx, table_type) <- map(do_visit_table_type(
        ctx,
        table_type,
        visitor,
      ))
      #(ctx, TableImport(mod, name, table_type))
    }
    MemImport(mod, name, mem_type) -> {
      use #(ctx, mem_type) <- map(do_visit_mem_type(ctx, mem_type, visitor))
      #(ctx, MemImport(mod, name, mem_type))
    }
    GlobalImport(mod, name, global_type) -> {
      use #(ctx, global_type) <- map(do_visit_global_type(
        ctx,
        global_type,
        visitor,
      ))
      #(ctx, GlobalImport(mod, name, global_type))
    }
  }
}

pub fn do_visit_function_section(
  ctx,
  section: Option(FunctionSection),
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Option(FunctionSection)), String) {
  use #(ctx, section) <- enter(
    ctx,
    section,
    visitor.on_enter_function_section,
    visitor.on_exit_function_section,
  )
  case section {
    Some(FunctionSection(indexes)) -> {
      use #(ctx, indices) <- map(do_visit_element_list(
        ctx,
        indexes,
        visitor,
        do_visit_type_idx,
      ))
      #(ctx, Some(FunctionSection(indices)))
    }
    _ -> Ok(#(ctx, section))
  }
}

pub fn do_visit_table_section(
  ctx,
  table_section: Option(TableSection),
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Option(TableSection)), String) {
  use #(ctx, table_section) <- enter(
    ctx,
    table_section,
    visitor.on_enter_table_section,
    visitor.on_exit_table_section,
  )

  case table_section {
    Some(TableSection(tables)) -> {
      use #(ctx, tables) <- map(do_visit_element_list(
        ctx,
        tables,
        visitor,
        do_visit_table,
      ))
      #(ctx, Some(TableSection(tables)))
    }
    _ -> Ok(#(ctx, table_section))
  }
}

pub fn do_visit_memory_section(
  ctx,
  memories: Option(MemorySection),
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Option(MemorySection)), String) {
  use #(ctx, memories) <- enter(
    ctx,
    memories,
    visitor.on_enter_memory_section,
    visitor.on_exit_memory_section,
  )
  case memories {
    Some(MemorySection(memories)) -> {
      use #(ctx, memories) <- map(do_visit_element_list(
        ctx,
        memories,
        visitor,
        do_visit_mem_type,
      ))
      #(ctx, Some(MemorySection(memories)))
    }
    _ -> Ok(#(ctx, memories))
  }
}

pub fn do_visit_global_section(
  ctx,
  globals: Option(GlobalSection),
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Option(GlobalSection)), String) {
  use #(ctx, globals) <- enter(
    ctx,
    globals,
    visitor.on_enter_global_section,
    visitor.on_exit_global_section,
  )
  case globals {
    Some(GlobalSection(globals)) -> {
      use #(ctx, globals) <- map(do_visit_element_list(
        ctx,
        globals,
        visitor,
        do_visit_global,
      ))
      #(ctx, Some(GlobalSection(globals)))
    }
    _ -> Ok(#(ctx, globals))
  }
}

pub fn do_visit_global(ctx, global: Global, visitor: BinaryModuleVisitor(ctx)) {
  use #(ctx, Global(global_type, init)) <- enter(
    ctx,
    global,
    visitor.on_enter_global,
    visitor.on_exit_global,
  )

  use #(ctx, global_type) <- try(do_visit_global_type(ctx, global_type, visitor))
  use #(ctx, init) <- map(do_visit_expr(ctx, init, visitor))

  #(ctx, Global(global_type, init))
}

pub fn do_visit_export_section(
  ctx,
  exports: Option(ExportSection),
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Option(ExportSection)), String) {
  use #(ctx, exports) <- enter(
    ctx,
    exports,
    visitor.on_enter_export_section,
    visitor.on_exit_export_section,
  )

  case exports {
    Some(ExportSection(exports)) -> {
      use #(ctx, exports) <- map(do_visit_element_list(
        ctx,
        exports,
        visitor,
        do_visit_export,
      ))
      #(ctx, Some(ExportSection(exports)))
    }
    _ -> Ok(#(ctx, exports))
  }
}

pub fn do_visit_export(ctx, export: Export, visitor: BinaryModuleVisitor(ctx)) {
  use #(ctx, export) <- enter(
    ctx,
    export,
    visitor.on_enter_export,
    visitor.on_exit_export,
  )

  use #(ctx, export) <-
    case export {
      FuncExport(_, _) -> enter(
        ctx,
        export,
        visitor.on_enter_func_export,
        visitor.on_exit_func_export,
        _,
      )
      TableExport(_, _) -> enter(
        ctx,
        export,
        visitor.on_enter_table_export,
        visitor.on_exit_table_export,
        _,
      )
      MemExport(_, _) -> enter(
        ctx,
        export,
        visitor.on_enter_mem_export,
        visitor.on_exit_mem_export,
        _,
      )
      GlobalExport(_, _) -> enter(
        ctx,
        export,
        visitor.on_enter_global_export,
        visitor.on_exit_global_export,
        _,
      )
    }

  case export {
    FuncExport(name, func_idx) -> {
      use #(ctx, func_idx) <- map(do_visit_func_idx(ctx, func_idx, visitor))
      #(ctx, FuncExport(name, func_idx))
    }
    TableExport(name, table_idx) -> {
      use #(ctx, table_idx) <- map(do_visit_table_idx(ctx, table_idx, visitor))
      #(ctx, TableExport(name, table_idx))
    }
    MemExport(name, mem_idx) -> {
      use #(ctx, mem_idx) <- map(do_visit_mem_idx(ctx, mem_idx, visitor))
      #(ctx, MemExport(name, mem_idx))
    }
    GlobalExport(name, global_idx) -> {
      use #(ctx, global_idx) <- map(do_visit_global_idx(
        ctx,
        global_idx,
        visitor,
      ))
      #(ctx, GlobalExport(name, global_idx))
    }
  }
}

pub fn do_visit_start_section(
  ctx,
  start_section: Option(StartSection),
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Option(StartSection)), String) {
  use #(ctx, start_section) <- enter(
    ctx,
    start_section,
    visitor.on_enter_start_section,
    visitor.on_exit_start_section,
  )

  case start_section {
    Some(StartSection(func_idx)) -> {
      use #(ctx, func_idx) <- map(do_visit_func_idx(ctx, func_idx, visitor))
      #(ctx, Some(StartSection(func_idx)))
    }
    _ -> Ok(#(ctx, start_section))
  }
}

pub fn do_visit_element_section(
  ctx,
  elements: Option(ElementSection),
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Option(ElementSection)), String) {
  use #(ctx, elements) <- enter(
    ctx,
    elements,
    visitor.on_enter_element_section,
    visitor.on_exit_element_section,
  )

  case elements {
    Some(ElementSection(elements)) -> {
      use #(ctx, elements) <- map(do_visit_element_list(
        ctx,
        elements,
        visitor,
        do_visit_element_segment,
      ))
      #(ctx, Some(ElementSection(elements)))
    }
    _ -> Ok(#(ctx, elements))
  }
}

pub fn do_visit_element_segment(
  ctx,
  element_segment: Elem,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Elem), String) {
  use #(ctx, element_segment) <- enter(
    ctx,
    element_segment,
    visitor.on_enter_element_segment,
    visitor.on_exit_element_segment,
  )

  use #(ctx, element_segment) <-
    case element_segment {
      ElemFuncs(_, _, _) -> enter(
        ctx,
        element_segment,
        visitor.on_enter_elem_funcs,
        visitor.on_exit_elem_funcs,
        _,
      )
      ElemExpressions(_, _, _) -> enter(
        ctx,
        element_segment,
        visitor.on_enter_elem_expressions,
        visitor.on_exit_elem_expressions,
        _,
      )
    }

  case element_segment {
    ElemExpressions(ref_type, exprs, mode) -> {
      use #(ctx, ref_type) <- try(do_visit_ref_type(ctx, ref_type, visitor))
      use #(ctx, exprs) <- try(do_visit_element_list(
        ctx,
        exprs,
        visitor,
        do_visit_expr,
      ))
      use #(ctx, mode) <- map(do_visit_element_mode(ctx, mode, visitor))

      #(ctx, ElemExpressions(ref_type, exprs, mode))
    }
    ElemFuncs(ref_type, func_idxs, mode) -> {
      use #(ctx, ref_type) <- try(do_visit_ref_type(ctx, ref_type, visitor))
      use #(ctx, func_idxs) <- try(do_visit_element_list(
        ctx,
        func_idxs,
        visitor,
        do_visit_func_idx,
      ))
      use #(ctx, mode) <- map(do_visit_element_mode(ctx, mode, visitor))

      #(ctx, ElemFuncs(ref_type, func_idxs, mode))
    }
  }
}

pub fn do_visit_element_mode(
  ctx,
  mode: ElemMode,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, ElemMode), String) {
  use #(ctx, mode) <- enter(
    ctx,
    mode,
    visitor.on_enter_element_mode,
    visitor.on_exit_element_mode,
  )

  case mode {
    DeclarativeElemMode -> enter(
      ctx,
      mode,
      visitor.on_enter_declarative_elem_mode,
      visitor.on_exit_declarative_elem_mode,
      _,
    )
    PassiveElemMode -> enter(
      ctx,
      mode,
      visitor.on_enter_passive_elem_mode,
      visitor.on_exit_passive_elem_mode,
      _,
    )
    ActiveElemMode(_, _) -> enter(
      ctx,
      mode,
      visitor.on_enter_active_elem_mode,
      visitor.on_exit_active_elem_mode,
      _,
    )
  }

  case mode {
    ActiveElemMode(table_idx, offset) -> {
      use #(ctx, table_idx) <- try(do_visit_table_idx(ctx, table_idx, visitor))
      use #(ctx, offset) <- map(do_visit_expr(ctx, offset, visitor))
      #(ctx, ActiveElemMode(table_idx, offset))
    }
    _ -> Ok(#(ctx, mode))
  }
}

pub fn do_visit_code_section(
  ctx,
  code: Option(CodeSection),
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Option(CodeSection)), String) {
  use #(ctx, code) <- enter(
    ctx,
    code,
    visitor.on_enter_code_section,
    visitor.on_exit_code_section,
  )

  case code {
    Some(CodeSection(code)) -> {
      use #(ctx, codes) <- map(do_visit_element_list(
        ctx,
        code,
        visitor,
        do_visit_code,
      ))
      #(ctx, Some(CodeSection(codes)))
    }
    _ -> Ok(#(ctx, code))
  }
}

pub fn do_visit_code(
  ctx,
  code: Code,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Code), String) {
  use #(ctx, Code(locals, body)) <- enter(
    ctx,
    code,
    visitor.on_enter_code,
    visitor.on_exit_code,
  )

  use #(ctx, locals) <- try(do_visit_element_list(
    ctx,
    locals,
    visitor,
    do_visit_locals,
  ))

  use #(ctx, body) <- map(do_visit_expr(ctx, body, visitor))

  #(ctx, Code(locals, body))
}

pub fn do_visit_locals(
  ctx,
  locals: Locals,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Locals), String) {
  use #(ctx, Locals(count, val_type)) <- enter(
    ctx,
    locals,
    visitor.on_enter_locals,
    visitor.on_exit_locals,
  )

  use #(ctx, val_type) <- map(do_visit_val_type(ctx, val_type, visitor))

  #(ctx, Locals(count, val_type))
}

pub fn do_visit_data_section(
  ctx,
  data_section: Option(DataSection),
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Option(DataSection)), String) {
  use #(ctx, data_section) <- enter(
    ctx,
    data_section,
    visitor.on_enter_data_section,
    visitor.on_exit_data_section,
  )

  case data_section {
    Some(DataSection(data_segments)) -> {
      use #(ctx, data_segments) <- map(do_visit_element_list(
        ctx,
        data_segments,
        visitor,
        do_visit_data,
      ))
      #(ctx, Some(DataSection(data_segments)))
    }
    _ -> Ok(#(ctx, data_section))
  }
}

pub fn do_visit_data(
  ctx,
  data: Data,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Data), String) {
  use #(ctx, data) <- enter(
    ctx,
    data,
    visitor.on_enter_data,
    visitor.on_exit_data,
  )

  use #(ctx, data) <-
    case data {
      ActiveData(_, _, _) -> enter(
        ctx,
        data,
        visitor.on_enter_active_data,
        visitor.on_exit_active_data,
        _,
      )
      PassiveData(_) -> enter(
        ctx,
        data,
        visitor.on_enter_passive_data,
        visitor.on_exit_passive_data,
        _,
      )
    }

  case data {
    ActiveData(mem_idx, offset, init) -> {
      use #(ctx, mem_idx) <- try(do_visit_mem_idx(ctx, mem_idx, visitor))
      use #(ctx, offset) <- map(do_visit_expr(ctx, offset, visitor))
      #(ctx, ActiveData(mem_idx, offset, init))
    }
    PassiveData(_) -> Ok(#(ctx, data))
  }
}

pub fn do_visit_data_count_section(
  ctx,
  data_count_section: Option(DataCountSection),
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Option(DataCountSection)), String) {
  enter(
    ctx,
    data_count_section,
    visitor.on_enter_data_count_section,
    visitor.on_exit_data_count_section,
    Ok,
  )
}

pub fn do_visit_heap_type(
  ctx,
  heap_type: HeapType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, HeapType), String) {
  use #(ctx, heap_type) <- enter(
    ctx,
    heap_type,
    visitor.on_enter_heap_type,
    visitor.on_exit_heap_type,
  )

  use #(ctx, heap_type) <-
    case heap_type {
      FuncHeapType -> enter(
        ctx,
        heap_type,
        visitor.on_enter_func_heap_type,
        visitor.on_exit_func_heap_type,
        _,
      )
      NoFuncHeapType -> enter(
        ctx,
        heap_type,
        visitor.on_enter_no_func_heap_type,
        visitor.on_exit_no_func_heap_type,
        _,
      )
      ExternHeapType -> enter(
        ctx,
        heap_type,
        visitor.on_enter_extern_heap_type,
        visitor.on_exit_extern_heap_type,
        _,
      )
      NoExternHeapType -> enter(
        ctx,
        heap_type,
        visitor.on_enter_no_extern_heap_type,
        visitor.on_exit_no_extern_heap_type,
        _,
      )
      AnyHeapType -> enter(
        ctx,
        heap_type,
        visitor.on_enter_any_heap_type,
        visitor.on_exit_any_heap_type,
        _,
      )
      EqHeapType -> enter(
        ctx,
        heap_type,
        visitor.on_enter_eq_heap_type,
        visitor.on_exit_eq_heap_type,
        _,
      )
      I31HeapType -> enter(
        ctx,
        heap_type,
        visitor.on_enter_i31_heap_type,
        visitor.on_exit_i31_heap_type,
        _,
      )
      StructHeapType -> enter(
        ctx,
        heap_type,
        visitor.on_enter_struct_heap_type,
        visitor.on_exit_struct_heap_type,
        _,
      )
      ArrayHeapType -> enter(
        ctx,
        heap_type,
        visitor.on_enter_array_heap_type,
        visitor.on_exit_array_heap_type,
        _,
      )
      NoneHeapType -> enter(
        ctx,
        heap_type,
        visitor.on_enter_none_heap_type,
        visitor.on_exit_none_heap_type,
        _,
      )
      ConcreteHeapType(_) -> enter(
        ctx,
        heap_type,
        visitor.on_enter_concrete_heap_type,
        visitor.on_exit_concrete_heap_type,
        _,
      )
      _ -> fn(_) { Ok(#(ctx, heap_type)) }
    }

  case heap_type {
    ConcreteHeapType(idx) -> {
      use #(ctx, idx) <- map(do_visit_type_idx(ctx, idx, visitor))
      #(ctx, ConcreteHeapType(idx))
    }
    _ -> Ok(#(ctx, heap_type))
  }
}

pub fn do_visit_field_type(
  ctx,
  field_type: FieldType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, FieldType), String) {
  use #(ctx, FieldType(storage_type, mut)) <- enter(
    ctx,
    field_type,
    visitor.on_enter_field_type,
    visitor.on_exit_field_type,
  )
  use #(ctx, st) <- map(do_visit_storage_type(ctx, storage_type, visitor))
  #(ctx, FieldType(st, mut))
}

pub fn do_visit_storage_type(
  ctx,
  storage_type: StorageType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, StorageType), String) {
  use #(ctx, storage_type) <- enter(
    ctx,
    storage_type,
    visitor.on_enter_storage_type,
    visitor.on_exit_storage_type,
  )

  use #(ctx, storage_type) <-
    case storage_type {
      I8StorageType -> enter(
        ctx,
        storage_type,
        visitor.on_enter_i8_storage_type,
        visitor.on_exit_i8_storage_type,
        _,
      )
      I16StorageType -> enter(
        ctx,
        storage_type,
        visitor.on_enter_i16_storage_type,
        visitor.on_exit_i16_storage_type,
        _,
      )
      ValTypeStorageType(_) -> enter(
        ctx,
        storage_type,
        visitor.on_enter_val_type_storage_type,
        visitor.on_exit_val_type_storage_type,
        _,
      )
    }

  case storage_type {
    ValTypeStorageType(vt) -> {
      use #(ctx, vt) <- map(do_visit_val_type(ctx, vt, visitor))
      #(ctx, ValTypeStorageType(vt))
    }
    a -> Ok(#(ctx, a))
  }
}

pub fn do_visit_table_type(
  ctx,
  table_type: TableType,
  visitor: BinaryModuleVisitor(ctx),
) {
  use #(ctx, TableType(rt, limits)) <- enter(
    ctx,
    table_type,
    visitor.on_enter_table_type,
    visitor.on_exit_table_type,
  )

  use #(ctx, rt) <- try(do_visit_ref_type(ctx, rt, visitor))
  use #(ctx, limits) <- map(do_visit_limits(ctx, limits, visitor))

  let table_type = TableType(rt, limits)
  #(ctx, table_type)
}

pub fn do_visit_limits(
  ctx,
  limits: Limits,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Limits), String) {
  enter(ctx, limits, visitor.on_enter_limits, visitor.on_exit_limits, Ok)
}

pub fn do_visit_mem_type(
  ctx,
  mem_type: MemType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, MemType), String) {
  use #(ctx, MemType(limits)) <- enter(
    ctx,
    mem_type,
    visitor.on_enter_mem_type,
    visitor.on_exit_mem_type,
  )
  use #(ctx, limits) <- map(do_visit_limits(ctx, limits, visitor))

  #(ctx, MemType(limits))
}

pub fn do_visit_global_type(
  ctx,
  global_type: GlobalType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, GlobalType), String) {
  use #(ctx, GlobalType(vt, mut)) <- enter(
    ctx,
    global_type,
    visitor.on_enter_global_type,
    visitor.on_exit_global_type,
  )

  use #(ctx, vt) <- map(do_visit_val_type(ctx, vt, visitor))
  #(ctx, GlobalType(vt, mut))
}

pub fn do_visit_table(
  ctx,
  table: Table,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Table), String) {
  use #(ctx, Table(table_type, init_expr)) <- enter(
    ctx,
    table,
    visitor.on_enter_table,
    visitor.on_exit_table,
  )

  use #(ctx, table_type) <- try(do_visit_table_type(ctx, table_type, visitor))

  use #(ctx, init_expr) <- map(case init_expr {
    Some(init_expr) -> {
      use #(ctx, init_expr) <- map(do_visit_expr(ctx, init_expr, visitor))
      #(ctx, Some(init_expr))
    }
    None -> Ok(#(ctx, None))
  })

  let table = Table(table_type, init_expr)
  #(ctx, table)
}

pub fn do_visit_expr(
  ctx,
  expr: Expr,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Expr), String) {
  use #(ctx, Expr(body)) <- enter(
    ctx,
    expr,
    visitor.on_enter_expr,
    visitor.on_exit_expr,
  )

  use #(ctx, body) <- map(do_visit_element_list(
    ctx,
    body,
    visitor,
    do_visit_instruction,
  ))

  #(ctx, Expr(body))
}

pub fn do_visit_instruction(
  ctx,
  instruction: Instruction,
  visitor: BinaryModuleVisitor(ctx),
) {
  use #(ctx, instruction) <- enter(
    ctx,
    instruction,
    visitor.on_enter_instruction,
    visitor.on_exit_instruction,
  )

  use #(ctx, instruction) <-
    case instruction {
      RefNull(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_ref_null,
        visitor.on_exit_ref_null,
        _,
      )
      RefFunc(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_ref_func,
        visitor.on_exit_ref_func,
        _,
      )
      RefTest(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_ref_test,
        visitor.on_exit_ref_test,
        _,
      )
      RefTestNullable(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_ref_test_nullable,
        visitor.on_exit_ref_test_nullable,
        _,
      )
      RefCast(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_ref_cast,
        visitor.on_exit_ref_cast,
        _,
      )
      RefCastNullable(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_ref_cast_nullable,
        visitor.on_exit_ref_cast_nullable,
        _,
      )
      StructGet(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_struct_get,
        visitor.on_exit_struct_get,
        _,
      )
      StructGetS(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_struct_get_s,
        visitor.on_exit_struct_get_s,
        _,
      )
      StructGetU(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_struct_get_u,
        visitor.on_exit_struct_get_u,
        _,
      )
      StructSet(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_struct_set,
        visitor.on_exit_struct_set,
        _,
      )
      ArrayNew(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_array_new,
        visitor.on_exit_array_new,
        _,
      )
      ArrayNewDefault(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_array_new_default,
        visitor.on_exit_array_new_default,
        _,
      )
      ArrayNewData(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_array_new_data,
        visitor.on_exit_array_new_data,
        _,
      )
      ArrayNewElem(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_array_new_elem,
        visitor.on_exit_array_new_elem,
        _,
      )
      ArrayNewFixed(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_array_new_fixed,
        visitor.on_exit_array_new_fixed,
        _,
      )
      ArrayGet(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_array_get,
        visitor.on_exit_array_get,
        _,
      )
      ArrayGetS(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_array_get_s,
        visitor.on_exit_array_get_s,
        _,
      )
      ArrayGetU(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_array_get_u,
        visitor.on_exit_array_get_u,
        _,
      )
      ArraySet(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_array_set,
        visitor.on_exit_array_set,
        _,
      )
      ArrayFill(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_array_fill,
        visitor.on_exit_array_fill,
        _,
      )
      ArrayCopy(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_array_copy,
        visitor.on_exit_array_copy,
        _,
      )
      ArrayInitData(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_array_init_data,
        visitor.on_exit_array_init_data,
        _,
      )
      ArrayInitElem(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_array_init_elem,
        visitor.on_exit_array_init_elem,
        _,
      )
      SelectT(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_select_t,
        visitor.on_exit_select_t,
        _,
      )
      LocalGet(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_local_get,
        visitor.on_exit_local_get,
        _,
      )
      LocalSet(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_local_set,
        visitor.on_exit_local_set,
        _,
      )
      LocalTee(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_local_tee,
        visitor.on_exit_local_tee,
        _,
      )
      GlobalGet(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_global_get,
        visitor.on_exit_global_get,
        _,
      )
      GlobalSet(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_global_set,
        visitor.on_exit_global_set,
        _,
      )
      TableGet(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_table_get,
        visitor.on_exit_table_get,
        _,
      )
      TableSet(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_table_set,
        visitor.on_exit_table_set,
        _,
      )
      TableSize(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_table_size,
        visitor.on_exit_table_size,
        _,
      )
      TableGrow(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_table_grow,
        visitor.on_exit_table_grow,
        _,
      )
      TableFill(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_table_fill,
        visitor.on_exit_table_fill,
        _,
      )
      TableCopy(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_table_copy,
        visitor.on_exit_table_copy,
        _,
      )
      TableInit(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_table_init,
        visitor.on_exit_table_init,
        _,
      )
      ElemDrop(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_elem_drop,
        visitor.on_exit_elem_drop,
        _,
      )
      MemoryInit(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_memory_init,
        visitor.on_exit_memory_init,
        _,
      )
      DataDrop(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_data_drop,
        visitor.on_exit_data_drop,
        _,
      )
      Block(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_block,
        visitor.on_exit_block,
        _,
      )
      Loop(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_loop,
        visitor.on_exit_loop,
        _,
      )
      If(_, _, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_if,
        visitor.on_exit_if,
        _,
      )
      Br(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_br,
        visitor.on_exit_br,
        _,
      )
      BrIf(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_br_if,
        visitor.on_exit_br_if,
        _,
      )
      BrTable(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_br_table,
        visitor.on_exit_br_table,
        _,
      )
      BrOnNull(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_br_on_null,
        visitor.on_exit_br_on_null,
        _,
      )
      BrOnNonNull(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_br_on_non_null,
        visitor.on_exit_br_on_non_null,
        _,
      )
      BrOnCast(_, _, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_br_on_cast,
        visitor.on_exit_br_on_cast,
        _,
      )
      BrOnCastFail(_, _, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_br_on_cast_fail,
        visitor.on_exit_br_on_cast_fail,
        _,
      )
      Call(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_call,
        visitor.on_exit_call,
        _,
      )
      CallRef(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_call_ref,
        visitor.on_exit_call_ref,
        _,
      )
      CallIndirect(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_call_indirect,
        visitor.on_exit_call_indirect,
        _,
      )
      ReturnCall(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_return_call,
        visitor.on_exit_return_call,
        _,
      )
      ReturnCallRef(_) -> enter(
        ctx,
        instruction,
        visitor.on_enter_return_call_ref,
        visitor.on_exit_return_call_ref,
        _,
      )
      ReturnCallIndirect(_, _) -> enter(
        ctx,
        instruction,
        visitor.on_enter_return_call_indirect,
        visitor.on_exit_return_call_indirect,
        _,
      )
      _ -> fn(_) { Ok(#(ctx, instruction)) }
    }

  case instruction {
    RefNull(heap_type) -> {
      use #(ctx, heap_type) <- map(do_visit_heap_type(ctx, heap_type, visitor))
      #(ctx, RefNull(heap_type))
    }
    RefFunc(func_idx) -> {
      use #(ctx, func_idx) <- map(do_visit_func_idx(ctx, func_idx, visitor))
      #(ctx, RefFunc(func_idx))
    }
    RefTest(heap_type) -> {
      use #(ctx, heap_type) <- map(do_visit_heap_type(ctx, heap_type, visitor))
      #(ctx, RefTest(heap_type))
    }
    RefTestNullable(heap_type) -> {
      use #(ctx, heap_type) <- map(do_visit_heap_type(ctx, heap_type, visitor))
      #(ctx, RefTestNullable(heap_type))
    }
    RefCast(heap_type) -> {
      use #(ctx, heap_type) <- map(do_visit_heap_type(ctx, heap_type, visitor))
      #(ctx, RefCast(heap_type))
    }
    RefCastNullable(heap_type) -> {
      use #(ctx, heap_type) <- map(do_visit_heap_type(ctx, heap_type, visitor))
      #(ctx, RefCastNullable(heap_type))
    }
    StructGet(type_idx, field_idx) -> {
      use #(ctx, type_idx) <- try(do_visit_type_idx(ctx, type_idx, visitor))
      use #(ctx, field_idx) <- map(do_visit_field_idx(ctx, field_idx, visitor))
      #(ctx, StructGet(type_idx, field_idx))
    }
    StructGetS(type_idx, field_idx) -> {
      use #(ctx, type_idx) <- try(do_visit_type_idx(ctx, type_idx, visitor))
      use #(ctx, field_idx) <- map(do_visit_field_idx(ctx, field_idx, visitor))
      #(ctx, StructGetS(type_idx, field_idx))
    }
    StructGetU(type_idx, field_idx) -> {
      use #(ctx, type_idx) <- try(do_visit_type_idx(ctx, type_idx, visitor))
      use #(ctx, field_idx) <- map(do_visit_field_idx(ctx, field_idx, visitor))
      #(ctx, StructGetU(type_idx, field_idx))
    }
    StructSet(type_idx, field_idx) -> {
      use #(ctx, type_idx) <- try(do_visit_type_idx(ctx, type_idx, visitor))
      use #(ctx, field_idx) <- map(do_visit_field_idx(ctx, field_idx, visitor))
      #(ctx, StructSet(type_idx, field_idx))
    }
    ArrayNew(type_idx) -> {
      use #(ctx, type_idx) <- map(do_visit_type_idx(ctx, type_idx, visitor))
      #(ctx, ArrayNew(type_idx))
    }
    ArrayNewDefault(type_idx) -> {
      use #(ctx, type_idx) <- map(do_visit_type_idx(ctx, type_idx, visitor))
      #(ctx, ArrayNewDefault(type_idx))
    }
    ArrayNewData(type_idx, data_idx) -> {
      use #(ctx, type_idx) <- try(do_visit_type_idx(ctx, type_idx, visitor))
      use #(ctx, data_idx) <- map(do_visit_data_idx(ctx, data_idx, visitor))
      #(ctx, ArrayNewData(type_idx, data_idx))
    }
    ArrayNewElem(type_idx, elem_idx) -> {
      use #(ctx, type_idx) <- try(do_visit_type_idx(ctx, type_idx, visitor))
      use #(ctx, elem_idx) <- map(do_visit_elem_idx(ctx, elem_idx, visitor))
      #(ctx, ArrayNewElem(type_idx, elem_idx))
    }
    ArrayNewFixed(type_idx, size) -> {
      use #(ctx, type_idx) <- map(do_visit_type_idx(ctx, type_idx, visitor))
      #(ctx, ArrayNewFixed(type_idx, size))
    }
    ArrayGet(type_idx) -> {
      use #(ctx, type_idx) <- map(do_visit_type_idx(ctx, type_idx, visitor))
      #(ctx, ArrayGet(type_idx))
    }
    ArrayGetS(type_idx) -> {
      use #(ctx, type_idx) <- map(do_visit_type_idx(ctx, type_idx, visitor))
      #(ctx, ArrayGetS(type_idx))
    }
    ArrayGetU(type_idx) -> {
      use #(ctx, type_idx) <- map(do_visit_type_idx(ctx, type_idx, visitor))
      #(ctx, ArrayGetU(type_idx))
    }
    ArraySet(type_idx) -> {
      use #(ctx, type_idx) <- map(do_visit_type_idx(ctx, type_idx, visitor))
      #(ctx, ArraySet(type_idx))
    }
    ArrayFill(type_idx) -> {
      use #(ctx, type_idx) <- map(do_visit_type_idx(ctx, type_idx, visitor))
      #(ctx, ArrayFill(type_idx))
    }
    ArrayCopy(type_idx1, type_idx2) -> {
      use #(ctx, type_idx1) <- try(do_visit_type_idx(ctx, type_idx1, visitor))
      use #(ctx, type_idx2) <- map(do_visit_type_idx(ctx, type_idx2, visitor))
      #(ctx, ArrayCopy(type_idx1, type_idx2))
    }
    ArrayInitData(type_idx, data_idx) -> {
      use #(ctx, type_idx) <- try(do_visit_type_idx(ctx, type_idx, visitor))
      use #(ctx, data_idx) <- map(do_visit_data_idx(ctx, data_idx, visitor))
      #(ctx, ArrayInitData(type_idx, data_idx))
    }
    ArrayInitElem(type_idx, elem_idx) -> {
      use #(ctx, type_idx) <- try(do_visit_type_idx(ctx, type_idx, visitor))
      use #(ctx, elem_idx) <- map(do_visit_elem_idx(ctx, elem_idx, visitor))
      #(ctx, ArrayInitElem(type_idx, elem_idx))
    }
    SelectT(val_types) -> {
      use #(ctx, val_types) <- map(do_visit_element_list(
        ctx,
        val_types,
        visitor,
        do_visit_val_type,
      ))
      #(ctx, SelectT(val_types))
    }
    LocalGet(local_idx) -> {
      use #(ctx, local_idx) <- map(do_visit_local_idx(ctx, local_idx, visitor))
      #(ctx, LocalGet(local_idx))
    }
    LocalSet(local_idx) -> {
      use #(ctx, local_idx) <- map(do_visit_local_idx(ctx, local_idx, visitor))
      #(ctx, LocalSet(local_idx))
    }
    LocalTee(local_idx) -> {
      use #(ctx, local_idx) <- map(do_visit_local_idx(ctx, local_idx, visitor))
      #(ctx, LocalTee(local_idx))
    }
    GlobalGet(global_idx) -> {
      use #(ctx, global_idx) <- map(do_visit_global_idx(
        ctx,
        global_idx,
        visitor,
      ))
      #(ctx, GlobalGet(global_idx))
    }
    GlobalSet(global_idx) -> {
      use #(ctx, global_idx) <- map(do_visit_global_idx(
        ctx,
        global_idx,
        visitor,
      ))
      #(ctx, GlobalSet(global_idx))
    }
    TableGet(table_idx) -> {
      use #(ctx, table_idx) <- map(do_visit_table_idx(ctx, table_idx, visitor))
      #(ctx, TableGet(table_idx))
    }
    TableSet(table_idx) -> {
      use #(ctx, table_idx) <- map(do_visit_table_idx(ctx, table_idx, visitor))
      #(ctx, TableSet(table_idx))
    }
    TableSize(table_idx) -> {
      use #(ctx, table_idx) <- map(do_visit_table_idx(ctx, table_idx, visitor))
      #(ctx, TableSize(table_idx))
    }
    TableGrow(table_idx) -> {
      use #(ctx, table_idx) <- map(do_visit_table_idx(ctx, table_idx, visitor))
      #(ctx, TableGrow(table_idx))
    }
    TableFill(table_idx) -> {
      use #(ctx, table_idx) <- map(do_visit_table_idx(ctx, table_idx, visitor))
      #(ctx, TableFill(table_idx))
    }
    TableCopy(dest_idx, src_idx) -> {
      use #(ctx, dest_idx) <- try(do_visit_table_idx(ctx, dest_idx, visitor))
      use #(ctx, src_idx) <- map(do_visit_table_idx(ctx, src_idx, visitor))
      #(ctx, TableCopy(dest_idx, src_idx))
    }
    TableInit(elem_idx, table_idx) -> {
      use #(ctx, elem_idx) <- try(do_visit_elem_idx(ctx, elem_idx, visitor))
      use #(ctx, table_idx) <- map(do_visit_table_idx(ctx, table_idx, visitor))
      #(ctx, TableInit(elem_idx, table_idx))
    }
    ElemDrop(elem_idx) -> {
      use #(ctx, elem_idx) <- map(do_visit_elem_idx(ctx, elem_idx, visitor))
      #(ctx, ElemDrop(elem_idx))
    }
    MemoryInit(data_idx) -> {
      use #(ctx, data_idx) <- map(do_visit_data_idx(ctx, data_idx, visitor))
      #(ctx, MemoryInit(data_idx))
    }
    DataDrop(data_idx) -> {
      use #(ctx, data_idx) <- map(do_visit_data_idx(ctx, data_idx, visitor))
      #(ctx, DataDrop(data_idx))
    }
    Block(block_type, body) -> {
      use #(ctx, block_type) <- try(do_visit_block_type(
        ctx,
        block_type,
        visitor,
      ))
      use #(ctx, body) <- map(do_visit_expr(ctx, body, visitor))
      #(ctx, Block(block_type, body))
    }
    Loop(block_type, body) -> {
      use #(ctx, block_type) <- try(do_visit_block_type(
        ctx,
        block_type,
        visitor,
      ))
      use #(ctx, body) <- map(do_visit_expr(ctx, body, visitor))
      #(ctx, Loop(block_type, body))
    }
    If(block_type, if_instructions, else_instructions) -> {
      use #(ctx, block_type) <- try(do_visit_block_type(
        ctx,
        block_type,
        visitor,
      ))
      use #(ctx, if_instructions) <- try(do_visit_element_list(
        ctx,
        if_instructions,
        visitor,
        do_visit_instruction,
      ))
      use #(ctx, else_instructions) <- map(case else_instructions {
        Some(else_instructions) -> {
          use #(ctx, else_instructions) <- map(do_visit_element_list(
            ctx,
            else_instructions,
            visitor,
            do_visit_instruction,
          ))
          #(ctx, Some(else_instructions))
        }
        None -> Ok(#(ctx, None))
      })
      #(ctx, If(block_type, if_instructions, else_instructions))
    }
    Br(label_idx) -> {
      use #(ctx, label_idx) <- map(do_visit_label_idx(ctx, label_idx, visitor))
      #(ctx, Br(label_idx))
    }
    BrIf(label_idx) -> {
      use #(ctx, label_idx) <- map(do_visit_label_idx(ctx, label_idx, visitor))
      #(ctx, BrIf(label_idx))
    }
    BrTable(label_idxs, default_label_idx) -> {
      use #(ctx, label_idxs) <- try(do_visit_element_list(
        ctx,
        label_idxs,
        visitor,
        do_visit_label_idx,
      ))
      use #(ctx, default_label_idx) <- map(do_visit_label_idx(
        ctx,
        default_label_idx,
        visitor,
      ))
      #(ctx, BrTable(label_idxs, default_label_idx))
    }
    BrOnNull(label_idx) -> {
      use #(ctx, label_idx) <- map(do_visit_label_idx(ctx, label_idx, visitor))
      #(ctx, BrOnNull(label_idx))
    }
    BrOnNonNull(label_idx) -> {
      use #(ctx, label_idx) <- map(do_visit_label_idx(ctx, label_idx, visitor))
      #(ctx, BrOnNonNull(label_idx))
    }
    BrOnCast(label_idx, ref_type1, ref_type2) -> {
      use #(ctx, label_idx) <- try(do_visit_label_idx(ctx, label_idx, visitor))
      use #(ctx, ref_type1) <- try(do_visit_ref_type(ctx, ref_type1, visitor))
      use #(ctx, ref_type2) <- map(do_visit_ref_type(ctx, ref_type2, visitor))
      #(ctx, BrOnCast(label_idx, ref_type1, ref_type2))
    }
    BrOnCastFail(label_idx, ref_type1, ref_type2) -> {
      use #(ctx, label_idx) <- try(do_visit_label_idx(ctx, label_idx, visitor))
      use #(ctx, ref_type1) <- try(do_visit_ref_type(ctx, ref_type1, visitor))
      use #(ctx, ref_type2) <- map(do_visit_ref_type(ctx, ref_type2, visitor))
      #(ctx, BrOnCastFail(label_idx, ref_type1, ref_type2))
    }
    Call(func_idx) -> {
      use #(ctx, func_idx) <- map(do_visit_func_idx(ctx, func_idx, visitor))
      #(ctx, Call(func_idx))
    }
    CallRef(type_idx) -> {
      use #(ctx, type_idx) <- map(do_visit_type_idx(ctx, type_idx, visitor))
      #(ctx, CallRef(type_idx))
    }
    CallIndirect(table_idx, type_idx) -> {
      use #(ctx, table_idx) <- try(do_visit_table_idx(ctx, table_idx, visitor))
      use #(ctx, type_idx) <- map(do_visit_type_idx(ctx, type_idx, visitor))
      #(ctx, CallIndirect(table_idx, type_idx))
    }
    ReturnCall(func_idx) -> {
      use #(ctx, func_idx) <- map(do_visit_func_idx(ctx, func_idx, visitor))
      #(ctx, ReturnCall(func_idx))
    }
    ReturnCallRef(type_idx) -> {
      use #(ctx, type_idx) <- map(do_visit_type_idx(ctx, type_idx, visitor))
      #(ctx, ReturnCallRef(type_idx))
    }
    ReturnCallIndirect(table_idx, type_idx) -> {
      use #(ctx, table_idx) <- try(do_visit_table_idx(ctx, table_idx, visitor))
      use #(ctx, type_idx) <- map(do_visit_type_idx(ctx, type_idx, visitor))
      #(ctx, ReturnCallIndirect(table_idx, type_idx))
    }
    _ -> Ok(#(ctx, instruction))
  }
}

pub fn do_visit_func_idx(
  ctx,
  func_idx: FuncIDX,
  visitor: BinaryModuleVisitor(ctx),
) {
  enter(ctx, func_idx, visitor.on_enter_func_idx, visitor.on_exit_func_idx, Ok)
}

pub fn do_visit_table_idx(
  ctx,
  table_idx: TableIDX,
  visitor: BinaryModuleVisitor(ctx),
) {
  enter(
    ctx,
    table_idx,
    visitor.on_enter_table_idx,
    visitor.on_exit_table_idx,
    Ok,
  )
}

pub fn do_visit_mem_idx(ctx, mem_idx: MemIDX, visitor: BinaryModuleVisitor(ctx)) {
  enter(ctx, mem_idx, visitor.on_enter_mem_idx, visitor.on_exit_mem_idx, Ok)
}

pub fn do_visit_global_idx(
  ctx,
  global_idx: GlobalIDX,
  visitor: BinaryModuleVisitor(ctx),
) {
  enter(
    ctx,
    global_idx,
    visitor.on_enter_global_idx,
    visitor.on_exit_global_idx,
    Ok,
  )
}

fn enter(
  ctx,
  element,
  on_enter: Option(VisitorCallback(ctx, element)),
  on_exit: Option(VisitorCallback(ctx, element)),
  body: fn(#(ctx, element)) -> Result(#(ctx, element), String),
) {
  use #(ctx, element) <- try(do_visit(ctx, element, on_enter))
  use #(ctx, element) <- try(body(#(ctx, element)))
  do_visit(ctx, element, on_exit)
}

pub fn do_visit_label_idx(
  ctx,
  label_idx: LabelIDX,
  visitor: BinaryModuleVisitor(ctx),
) {
  enter(
    ctx,
    label_idx,
    visitor.on_enter_label_idx,
    visitor.on_exit_label_idx,
    Ok,
  )
}

pub fn do_visit_field_idx(
  ctx,
  field_idx: FieldIDX,
  visitor: BinaryModuleVisitor(ctx),
) {
  enter(
    ctx,
    field_idx,
    visitor.on_enter_field_idx,
    visitor.on_exit_field_idx,
    Ok,
  )
}

pub fn do_visit_data_idx(
  ctx,
  data_idx: DataIDX,
  visitor: BinaryModuleVisitor(ctx),
) {
  enter(ctx, data_idx, visitor.on_enter_data_idx, visitor.on_exit_data_idx, Ok)
}

pub fn do_visit_elem_idx(
  ctx,
  elem_idx: ElemIDX,
  visitor: BinaryModuleVisitor(ctx),
) {
  enter(ctx, elem_idx, visitor.on_enter_elem_idx, visitor.on_exit_elem_idx, Ok)
}

pub fn do_visit_local_idx(
  ctx,
  local_idx: LocalIDX,
  visitor: BinaryModuleVisitor(ctx),
) {
  enter(
    ctx,
    local_idx,
    visitor.on_enter_local_idx,
    visitor.on_exit_local_idx,
    Ok,
  )
}

pub fn do_visit_block_type(
  ctx,
  block_type: BlockType,
  visitor: BinaryModuleVisitor(ctx),
) {
  use #(ctx, block_type) <- enter(
    ctx,
    block_type,
    visitor.on_enter_block_type,
    visitor.on_exit_block_type,
  )

  use #(ctx, block_type) <-
    case block_type {
      VoidBlockType -> enter(
        ctx,
        block_type,
        visitor.on_enter_void_block_type,
        visitor.on_exit_void_block_type,
        _,
      )
      ValTypeBlockType(_) -> enter(
        ctx,
        block_type,
        visitor.on_enter_val_type_block_type,
        visitor.on_exit_val_type_block_type,
        _,
      )
      FuncTypeBlockType(_) -> enter(
        ctx,
        block_type,
        visitor.on_enter_func_type_block_type,
        visitor.on_exit_func_type_block_type,
        _,
      )
    }

  case block_type {
    ValTypeBlockType(val_type) -> {
      use #(ctx, val_type) <- map(do_visit_val_type(ctx, val_type, visitor))
      #(ctx, ValTypeBlockType(val_type))
    }
    FuncTypeBlockType(type_idx) -> {
      use #(ctx, type_idx) <- map(do_visit_type_idx(ctx, type_idx, visitor))
      #(ctx, FuncTypeBlockType(type_idx))
    }
    _ -> Ok(#(ctx, block_type))
  }
}
