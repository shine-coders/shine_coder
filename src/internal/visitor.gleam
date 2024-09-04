import gleam/option.{type Option, None, Some}
import gleam/result.{map, try}
import internal/finger_tree.{type FingerTree}
import internal/structure/modules.{
  type BinaryModule, type CustomSection, type TypeSection, BinaryModule,
  TypeSection,
}
import internal/structure/types.{
  type ArrayType, type CompositeType, type DefType, type FuncType, type HeapType,
  type RecType, type RefType, type StructType, type SubType, type TypeIDX,
  type ValType, AnyRefType, ArrayCompositeType, ArrayRefType, DefType,
  DefTypeReference, EqRefType, ExternRefType, F32ValType, F64ValType,
  FuncCompositeType, FuncRefType, FuncType, HeapTypeRefType, I31RefType,
  I32ValType, I64ValType, NoExternRefType, NoFuncRefType, NoneRefType, RecType,
  RecTypeIDX, RefTypeValType, StructCompositeType, StructRefType, SubType,
  TypeIDX, V128ValType,
}

pub type VisitorCallback(ctx, element) =
  fn(ctx, element) -> Result(#(ctx, element), String)

pub type BinaryModuleVisitor(ctx) {
  BinaryModuleVisitor(
    on_enter_module: Option(VisitorCallback(ctx, BinaryModule)),
    on_exit_module: Option(VisitorCallback(ctx, BinaryModule)),
    on_enter_type_section: Option(VisitorCallback(ctx, Option(TypeSection))),
    on_exit_type_section: Option(VisitorCallback(ctx, Option(TypeSection))),
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

pub fn do_visit_type_section(
  ctx: context,
  type_section: Option(TypeSection),
  visitor: BinaryModuleVisitor(context),
) {
  use #(ctx, type_section) <- try(do_visit(
    ctx,
    type_section,
    visitor.on_enter_type_section,
  ))

  use #(ctx, type_section) <- try(case type_section {
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
  })

  do_visit(ctx, type_section, visitor.on_exit_type_section)
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

pub fn do_visit_rec_type(
  ctx,
  rec_type: RecType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, RecType), String) {
  use #(ctx, rec_type) <- try(do_visit(ctx, rec_type, visitor.on_enter_rec_type))

  use #(ctx, sub_types) <- try(do_visit_element_list(
    ctx,
    rec_type.sub_types,
    visitor,
    do_visit_sub_type,
  ))

  let rec_type = RecType(sub_types)

  do_visit(ctx, rec_type, visitor.on_exit_rec_type)
}

pub fn do_visit_sub_type(
  ctx,
  sub_type,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, SubType), String) {
  use #(ctx, SubType(final, t, ct)) <- try(do_visit(
    ctx,
    sub_type,
    visitor.on_enter_sub_type,
  ))

  use #(ctx, t) <- try(do_visit_element_list(ctx, t, visitor, do_visit_type_idx))

  use #(ctx, ct) <- try(do_visit_composite_type(ctx, ct, visitor))

  let sub_type = SubType(final, t, ct)
  do_visit(ctx, sub_type, visitor.on_exit_sub_type)
}

pub fn do_visit_type_idx(
  ctx,
  type_idx: TypeIDX,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, TypeIDX), String) {
  use #(ctx, type_idx) <- try(do_visit(ctx, type_idx, visitor.on_enter_type_idx))

  use #(ctx, type_idx) <- try(case type_idx {
    TypeIDX(_) -> Ok(#(ctx, type_idx))
    RecTypeIDX(_) -> do_visit(ctx, type_idx, visitor.on_enter_rec_type_idx)
    DefTypeReference(_) ->
      do_visit(ctx, type_idx, visitor.on_enter_def_type_reference)
  })

  use #(ctx, type_idx) <- try(case type_idx {
    DefTypeReference(dt) -> {
      use #(ctx, dt) <- map(do_visit_def_type(ctx, dt, visitor))

      #(ctx, DefTypeReference(dt))
    }
    _ -> Ok(#(ctx, type_idx))
  })

  do_visit(ctx, type_idx, visitor.on_exit_type_idx)
}

pub fn do_visit_composite_type(
  ctx,
  composite_type: CompositeType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, CompositeType), String) {
  use #(ctx, composite_type) <- try(do_visit(
    ctx,
    composite_type,
    visitor.on_enter_composite_type,
  ))

  use #(ctx, composite_type) <- try(case composite_type {
    FuncCompositeType(_) ->
      do_visit(ctx, composite_type, visitor.on_enter_func_composite_type)
    StructCompositeType(_) ->
      do_visit(ctx, composite_type, visitor.on_enter_struct_composite_type)
    ArrayCompositeType(_) ->
      do_visit(ctx, composite_type, visitor.on_enter_array_composite_type)
  })

  use #(ctx, composite_type) <- try(case composite_type {
    FuncCompositeType(ty) -> {
      use #(ctx, ty) <- map(do_visit_func_type(ctx, ty, visitor))
      #(ctx, FuncCompositeType(ty))
    }
    StructCompositeType(ty) -> {
      use #(ctx, ty) <- map(do_visit_struct_type(ctx, ty, visitor))
      #(ctx, StructCompositeType(ty))
    }
    ArrayCompositeType(ty) -> {
      use #(ctx, ty) <- map(do_visit_array_type(ctx, ty, visitor))
      #(ctx, ArrayCompositeType(ty))
    }
  })

  use #(ctx, composite_type) <- try(case composite_type {
    FuncCompositeType(_) ->
      do_visit(ctx, composite_type, visitor.on_exit_func_composite_type)
    StructCompositeType(_) ->
      do_visit(ctx, composite_type, visitor.on_exit_struct_composite_type)
    ArrayCompositeType(_) ->
      do_visit(ctx, composite_type, visitor.on_exit_array_composite_type)
  })

  do_visit(ctx, composite_type, visitor.on_exit_composite_type)
}

pub fn do_visit_def_type(
  ctx,
  def_type: DefType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, DefType), String) {
  use #(ctx, DefType(rec_type, idx)) <- try(do_visit(
    ctx,
    def_type,
    visitor.on_enter_def_type,
  ))

  use #(ctx, rec_type) <- try(do_visit_rec_type(ctx, rec_type, visitor))

  let def_type = DefType(rec_type, idx)
  do_visit(ctx, def_type, visitor.on_exit_def_type)
}

pub fn do_visit_func_type(
  ctx,
  func_type: FuncType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, FuncType), String) {
  use #(ctx, FuncType(parameters, results)) <- try(do_visit(
    ctx,
    func_type,
    visitor.on_enter_func_type,
  ))

  use #(ctx, parameters) <- try(do_visit_element_list(
    ctx,
    parameters,
    visitor,
    do_visit_val_type,
  ))

  use #(ctx, results) <- try(do_visit_element_list(
    ctx,
    results,
    visitor,
    do_visit_val_type,
  ))

  let func_type = FuncType(parameters, results)
  do_visit(ctx, func_type, visitor.on_exit_func_type)
}

pub fn do_visit_val_type(
  ctx,
  val_type: ValType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, ValType), String) {
  use #(ctx, val_type) <- try(do_visit(ctx, val_type, visitor.on_enter_val_type))

  use #(ctx, val_type) <- try(case val_type {
    V128ValType -> do_visit(ctx, val_type, visitor.on_enter_v128_val_type)
    I32ValType -> do_visit(ctx, val_type, visitor.on_enter_i32_val_type)
    I64ValType -> do_visit(ctx, val_type, visitor.on_enter_i64_val_type)
    F32ValType -> do_visit(ctx, val_type, visitor.on_enter_f32_val_type)
    F64ValType -> do_visit(ctx, val_type, visitor.on_enter_f64_val_type)
    RefTypeValType(_) ->
      do_visit(ctx, val_type, visitor.on_enter_ref_type_val_type)
    _ -> Ok(#(ctx, val_type))
  })

  use #(ctx, val_type) <- try(case val_type {
    RefTypeValType(rt) -> {
      use #(ctx, rt) <- map(do_visit_ref_type(ctx, rt, visitor))

      #(ctx, RefTypeValType(rt))
    }
    _ -> Ok(#(ctx, val_type))
  })

  use #(ctx, val_type) <- try(case val_type {
    V128ValType -> do_visit(ctx, val_type, visitor.on_exit_v128_val_type)
    I32ValType -> do_visit(ctx, val_type, visitor.on_exit_i32_val_type)
    I64ValType -> do_visit(ctx, val_type, visitor.on_exit_i64_val_type)
    F32ValType -> do_visit(ctx, val_type, visitor.on_exit_f32_val_type)
    F64ValType -> do_visit(ctx, val_type, visitor.on_exit_f64_val_type)
    RefTypeValType(_) ->
      do_visit(ctx, val_type, visitor.on_exit_ref_type_val_type)
    _ -> Ok(#(ctx, val_type))
  })

  do_visit(ctx, val_type, visitor.on_exit_val_type)
}

pub fn do_visit_ref_type(
  ctx,
  ref_type: RefType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, RefType), String) {
  use #(ctx, rt) <- try(do_visit(ctx, ref_type, visitor.on_enter_ref_type))

  use #(ctx, rt) <- try(case rt {
    HeapTypeRefType(_, _) ->
      do_visit(ctx, rt, visitor.on_enter_heap_type_ref_type)
    AnyRefType -> do_visit(ctx, rt, visitor.on_enter_any_ref_type)
    EqRefType -> do_visit(ctx, rt, visitor.on_enter_eq_ref_type)
    I31RefType -> do_visit(ctx, rt, visitor.on_enter_i31_ref_type)
    StructRefType -> do_visit(ctx, rt, visitor.on_enter_struct_ref_type)
    ArrayRefType -> do_visit(ctx, rt, visitor.on_enter_array_ref_type)
    FuncRefType -> do_visit(ctx, rt, visitor.on_enter_func_ref_type)
    ExternRefType -> do_visit(ctx, rt, visitor.on_enter_extern_ref_type)
    NoneRefType -> do_visit(ctx, rt, visitor.on_enter_none_ref_type)
    NoFuncRefType -> do_visit(ctx, rt, visitor.on_enter_no_func_ref_type)
    NoExternRefType -> do_visit(ctx, rt, visitor.on_enter_no_extern_ref_type)
  })

  use #(ctx, rt) <- try(case rt {
    HeapTypeRefType(ht, mut) -> {
      use #(ctx, ht) <- map(do_visit_heap_type(ctx, ht, visitor))
      #(ctx, HeapTypeRefType(ht, mut))
    }
    _ -> Ok(#(ctx, rt))
  })

  use #(ctx, rt) <- try(case rt {
    HeapTypeRefType(_, _) ->
      do_visit(ctx, rt, visitor.on_exit_heap_type_ref_type)
    AnyRefType -> do_visit(ctx, rt, visitor.on_exit_any_ref_type)
    EqRefType -> do_visit(ctx, rt, visitor.on_exit_eq_ref_type)
    I31RefType -> do_visit(ctx, rt, visitor.on_exit_i31_ref_type)
    StructRefType -> do_visit(ctx, rt, visitor.on_exit_struct_ref_type)
    ArrayRefType -> do_visit(ctx, rt, visitor.on_exit_array_ref_type)
    FuncRefType -> do_visit(ctx, rt, visitor.on_exit_func_ref_type)
    ExternRefType -> do_visit(ctx, rt, visitor.on_exit_extern_ref_type)
    NoneRefType -> do_visit(ctx, rt, visitor.on_exit_none_ref_type)
    NoFuncRefType -> do_visit(ctx, rt, visitor.on_exit_no_func_ref_type)
    NoExternRefType -> do_visit(ctx, rt, visitor.on_exit_no_extern_ref_type)
  })

  do_visit(ctx, rt, visitor.on_exit_ref_type)
}

pub fn do_visit_struct_type(
  ctx,
  struct_type: StructType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, StructType), String) {
  todo
}

pub fn do_visit_array_type(
  ctx,
  array_type: ArrayType,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, ArrayType), String) {
  todo
}

pub fn do_visit_custom_sections(
  ctx,
  custom_sections: Option(FingerTree(CustomSection)),
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, Option(FingerTree(CustomSection))), String) {
  todo
}

pub fn do_visit_imports(
  ctx,
  imports: section,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, section), String) {
  todo
}

pub fn do_visit_functions(
  ctx,
  functions: section,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, section), String) {
  todo
}

pub fn do_visit_tables(
  ctx,
  tables: section,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, section), String) {
  todo
}

pub fn do_visit_memories(
  ctx,
  memories: section,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, section), String) {
  todo
}

pub fn do_visit_globals(
  ctx,
  globals: section,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, section), String) {
  todo
}

pub fn do_visit_exports(
  ctx,
  exports: section,
  visitor: BinaryModuleVisitor(ctx),
) -> Result(#(ctx, section), String) {
  todo
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
