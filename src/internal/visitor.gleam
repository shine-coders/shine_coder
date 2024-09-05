import gleam/option.{type Option, None, Some}
import gleam/result.{map, try}
import internal/finger_tree.{type FingerTree}
import internal/structure/modules.{
  type BinaryModule, type CustomSection, type ExportSection,
  type FunctionSection, type GlobalSection, type ImportSection,
  type MemorySection, type TableSection, type TypeSection, BinaryModule,
  ExportSection, FunctionSection, GlobalSection, ImportSection, MemorySection,
  TableSection, TypeSection,
}
import internal/structure/types.{
  type ArrayType, type CompositeType, type DefType, type Export, type Expr,
  type FieldType, type FuncType, type Global, type GlobalType, type HeapType,
  type Import, type Instruction, type Limits, type MemType, type RecType,
  type RefType, type StorageType, type StructType, type SubType, type Table,
  type TableType, type TypeIDX, type ValType, AnyRefType, ArrayCompositeType,
  ArrayRefType, ArrayType, DefType, DefTypeReference, EqRefType, Expr,
  ExternRefType, F32ValType, F64ValType, FieldType, FuncCompositeType,
  FuncExport, FuncImport, FuncRefType, FuncType, Global, GlobalExport,
  GlobalImport, GlobalType, HeapTypeRefType, I16StorageType, I31RefType,
  I32ValType, I64ValType, I8StorageType, Limits, MemExport, MemImport, MemType,
  NoExternRefType, NoFuncRefType, NoneRefType, RecType, RecTypeIDX,
  RefTypeValType, StructCompositeType, StructRefType, StructType, SubType, Table,
  TableExport, TableImport, TableType, TypeIDX, V128ValType, ValTypeStorageType,
}

pub type VisitorCallback(ctx, element) =
  fn(ctx, element) -> Result(#(ctx, element), String)

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
  use #(ctx, imports) <- result.try(do_visit_imports(
    ctx,
    module.imports,
    visitor,
  ))
  use #(ctx, custom_2) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_2,
    visitor,
  ))
  use #(ctx, functions) <- result.try(do_visit_functions(
    ctx,
    module.functions,
    visitor,
  ))
  use #(ctx, custom_3) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_3,
    visitor,
  ))
  use #(ctx, tables) <- result.try(do_visit_tables(ctx, module.tables, visitor))
  use #(ctx, custom_4) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_4,
    visitor,
  ))
  use #(ctx, memories) <- result.try(do_visit_memories(
    ctx,
    module.memories,
    visitor,
  ))
  use #(ctx, custom_5) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_5,
    visitor,
  ))
  use #(ctx, globals) <- result.try(do_visit_globals(
    ctx,
    module.globals,
    visitor,
  ))
  use #(ctx, custom_6) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_6,
    visitor,
  ))
  use #(ctx, exports) <- result.try(do_visit_exports(
    ctx,
    module.exports,
    visitor,
  ))
  use #(ctx, custom_7) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_7,
    visitor,
  ))
  use #(ctx, start) <- result.try(do_visit_start(ctx, module.start, visitor))
  use #(ctx, custom_8) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_8,
    visitor,
  ))
  use #(ctx, elements) <- result.try(do_visit_elements(
    ctx,
    module.elements,
    visitor,
  ))
  use #(ctx, custom_9) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_9,
    visitor,
  ))
  use #(ctx, code) <- result.try(do_visit_code(ctx, module.code, visitor))
  use #(ctx, custom_10) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_10,
    visitor,
  ))
  use #(ctx, data) <- result.try(do_visit_data(ctx, module.data, visitor))
  use #(ctx, custom_11) <- result.try(do_visit_custom_sections(
    ctx,
    module.custom_11,
    visitor,
  ))
  use #(ctx, data_count) <- result.try(do_visit_data_count(
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

pub fn do_visit_imports(
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

pub fn do_visit_functions(
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

pub fn do_visit_tables(
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

pub fn do_visit_memories(
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

pub fn do_visit_globals(
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
  use #(ctx, Global(global_type, init)) <-
    enter(ctx, global, visitor.on_enter_global, visitor.on_exit_global, _)

  use #(ctx, global_type) <- try(do_visit_global_type(ctx, global_type, visitor))
  use #(ctx, init) <- map(do_visit_expr(ctx, init, visitor))

  #(ctx, Global(global_type, init))
}

pub fn do_visit_exports(
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

pub fn do_visit_start(
  ctx,
  start: section,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, section), String) {
  todo
}

pub fn do_visit_elements(
  ctx,
  elements: section,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, section), String) {
  todo
}

pub fn do_visit_code(
  ctx,
  code: section,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, section), String) {
  todo
}

pub fn do_visit_data(
  ctx,
  data: section,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, section), String) {
  todo
}

pub fn do_visit_data_count(
  ctx,
  data_count: section,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, section), String) {
  todo
}

pub fn do_visit_heap_type(
  ctx,
  heap_type: HeapType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, HeapType), String) {
  todo
}

pub fn do_visit_field_type(
  ctx,
  field_type: FieldType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, FieldType), String) {
  use #(ctx, FieldType(st, mut)) <- try(do_visit(
    ctx,
    field_type,
    visitor.on_enter_field_type,
  ))

  use #(ctx, st) <- try(do_visit_storage_type(ctx, st, visitor))

  let field_type = FieldType(st, mut)
  do_visit(ctx, field_type, visitor.on_exit_field_type)
}

pub fn do_visit_storage_type(
  ctx,
  storage_type: StorageType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, StorageType), String) {
  use #(ctx, storage_type) <- try(do_visit(
    ctx,
    storage_type,
    visitor.on_enter_storage_type,
  ))

  use #(ctx, storage_type) <- try(case storage_type {
    I8StorageType ->
      do_visit(ctx, storage_type, visitor.on_enter_i8_storage_type)
    I16StorageType ->
      do_visit(ctx, storage_type, visitor.on_enter_i16_storage_type)
    ValTypeStorageType(_) ->
      do_visit(ctx, storage_type, visitor.on_enter_val_type_storage_type)
  })

  use #(ctx, storage_type) <- try(case storage_type {
    ValTypeStorageType(vt) -> {
      use #(ctx, vt) <- map(do_visit_val_type(ctx, vt, visitor))
      #(ctx, ValTypeStorageType(vt))
    }
    a -> Ok(#(ctx, a))
  })

  use #(ctx, storage_type) <- try(case storage_type {
    I8StorageType ->
      do_visit(ctx, storage_type, visitor.on_exit_i8_storage_type)
    I16StorageType ->
      do_visit(ctx, storage_type, visitor.on_exit_i16_storage_type)
    ValTypeStorageType(_) ->
      do_visit(ctx, storage_type, visitor.on_exit_val_type_storage_type)
  })

  do_visit(ctx, storage_type, visitor.on_exit_storage_type)
}

pub fn do_visit_table_type(
  ctx,
  table_type: TableType,
  visitor: BinaryModuleVisitor(ctx),
) {
  use #(ctx, TableType(rt, limits)) <- try(do_visit(
    ctx,
    table_type,
    visitor.on_enter_table_type,
  ))

  use #(ctx, rt) <- try(do_visit_ref_type(ctx, rt, visitor))
  use #(ctx, limits) <- try(do_visit_limits(ctx, limits, visitor))

  let table_type = TableType(rt, limits)
  do_visit(ctx, table_type, visitor.on_exit_table_type)
}

pub fn do_visit_limits(
  ctx,
  limits: Limits,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Limits), String) {
  use #(ctx, limits) <- try(do_visit(ctx, limits, visitor.on_enter_limits))
  do_visit(ctx, limits, visitor.on_exit_limits)
}

pub fn do_visit_mem_type(
  ctx,
  mem_type: MemType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, MemType), String) {
  use #(ctx, MemType(limits)) <- try(do_visit(
    ctx,
    mem_type,
    visitor.on_enter_mem_type,
  ))
  use #(ctx, limits) <- try(do_visit_limits(ctx, limits, visitor))
  let mem_type = MemType(limits)
  do_visit(ctx, mem_type, visitor.on_exit_mem_type)
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
  use #(ctx, Table(table_type, init_expr)) <- try(do_visit(
    ctx,
    table,
    visitor.on_enter_table,
  ))

  use #(ctx, table_type) <- try(do_visit_table_type(ctx, table_type, visitor))

  use #(ctx, init_expr) <- try(case init_expr {
    Some(init_expr) -> {
      use #(ctx, init_expr) <- map(do_visit_expr(ctx, init_expr, visitor))
      #(ctx, Some(init_expr))
    }
    None -> Ok(#(ctx, None))
  })

  let table = Table(table_type, init_expr)
  do_visit(ctx, table, visitor.on_exit_table)
}

pub fn do_visit_expr(ctx, expr: Expr, visitor: BinaryModuleVisitor(ctx)) {
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

  todo
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
