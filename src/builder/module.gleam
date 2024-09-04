import gleam/option.{type Option, None, Some}
import gleam/set.{type Set}
import internal/binary/modules
import internal/finger_tree.{type FingerTree}
import internal/structure/modules.{
  type BinaryModule, type CustomSection, type ExportSection,
  type FunctionSection, type GlobalSection, type MemorySection,
  type TableSection, type TypeSection, BinaryModule, CodeSection, CustomSection,
  DataCountSection, DataSection, ElementSection, ExportSection, FunctionSection,
  GlobalSection, ImportSection, MemorySection, StartSection, TableSection,
  TypeSection,
} as structure_modules
import internal/structure/numbers.{type U32, u32}
import internal/structure/types.{
  type Export, type Expr, type FuncIDX, type Global, type GlobalIDX, type Limits,
  type Locals, type MemIDX, type MemType, type RecType, type RefType, type Table,
  type TableIDX, type TableType, type TypeIDX, type ValType, ActiveData,
  ActiveElemMode, Code, Const, DataIDX, DeclarativeElemMode, ElemExpressions,
  ElemFuncs, ElemIDX, FuncExport, FuncHeapType, FuncIDX, FuncImport,
  GlobalExport, GlobalIDX, GlobalImport, GlobalType, HeapTypeRefType, LabelIDX,
  Limits, LocalIDX, Locals, MemExport, MemIDX, MemImport, MemType, PassiveData,
  PassiveElemMode, TableExport, TableIDX, TableImport, TableType, TypeIDX, Var,
}

pub const new = structure_modules.binary_module_new

pub fn custom_section(module: BinaryModule, name: String, data: BitArray) {
  case module {
    BinaryModule(
      a,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
    ) ->
      BinaryModule(
        ..module,
        custom_0: add_to_optional_list(a, CustomSection(name, data)),
      )

    BinaryModule(
      _,
      _,
      a,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
    ) ->
      BinaryModule(
        ..module,
        custom_1: add_to_optional_list(a, CustomSection(name, data)),
      )

    BinaryModule(
      _,
      _,
      _,
      _,
      a,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
    ) ->
      BinaryModule(
        ..module,
        custom_2: add_to_optional_list(a, CustomSection(name, data)),
      )

    BinaryModule(
      _,
      _,
      _,
      _,
      _,
      _,
      a,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
    ) ->
      BinaryModule(
        ..module,
        custom_3: add_to_optional_list(a, CustomSection(name, data)),
      )

    BinaryModule(
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      a,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
    ) ->
      BinaryModule(
        ..module,
        custom_4: add_to_optional_list(a, CustomSection(name, data)),
      )

    BinaryModule(
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      a,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
    ) ->
      BinaryModule(
        ..module,
        custom_5: add_to_optional_list(a, CustomSection(name, data)),
      )

    BinaryModule(
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      a,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
    ) ->
      BinaryModule(
        ..module,
        custom_6: add_to_optional_list(a, CustomSection(name, data)),
      )

    BinaryModule(
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      a,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
    ) ->
      BinaryModule(
        ..module,
        custom_7: add_to_optional_list(a, CustomSection(name, data)),
      )

    BinaryModule(
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      a,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
      None,
    ) ->
      BinaryModule(
        ..module,
        custom_8: add_to_optional_list(a, CustomSection(name, data)),
      )

    BinaryModule(
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      a,
      None,
      None,
      None,
      None,
      None,
      None,
    ) ->
      BinaryModule(
        ..module,
        custom_9: add_to_optional_list(a, CustomSection(name, data)),
      )

    BinaryModule(
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      a,
      None,
      None,
      None,
      None,
    ) ->
      BinaryModule(
        ..module,
        custom_10: add_to_optional_list(a, CustomSection(name, data)),
      )

    BinaryModule(
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      a,
      None,
      None,
    ) ->
      BinaryModule(
        ..module,
        custom_11: add_to_optional_list(a, CustomSection(name, data)),
      )

    BinaryModule(
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      _,
      a,
    ) ->
      BinaryModule(
        ..module,
        custom_12: add_to_optional_list(a, CustomSection(name, data)),
      )
  }
}

fn add_to_optional_list(items: Option(FingerTree(u)), item: u) {
  case items {
    Some(items) -> Some(finger_tree.push(items, item))
    None -> Some(finger_tree.single(item))
  }
}

pub fn add_type(module: BinaryModule, type_: RecType) {
  let BinaryModule(types: types, ..) = module
  case types {
    None ->
      BinaryModule(
        ..module,
        types: Some(TypeSection(finger_tree.single(type_))),
      )
    Some(TypeSection(types)) ->
      BinaryModule(
        ..module,
        types: Some(TypeSection(finger_tree.push(types, type_))),
      )
  }
}

/// Import a function from the host. The module_name and name are used to identify the
/// import as the host specifies it. The type of the function is defined by a TypeIDX that
/// points into the TypeSection. Type indexes at this point *must* be absolute, or this
/// method panics.
pub fn import_func(
  module: BinaryModule,
  module_name: String,
  name: String,
  type_: TypeIDX,
) {
  let BinaryModule(imports: imports, ..) = module
  case imports, type_ {
    None, TypeIDX(_) ->
      BinaryModule(
        ..module,
        imports: Some(
          ImportSection(
            finger_tree.single(FuncImport(module_name, name, type_)),
          ),
        ),
      )

    Some(ImportSection(imports)), TypeIDX(_) ->
      BinaryModule(
        ..module,
        imports: Some(
          ImportSection(finger_tree.push(
            imports,
            FuncImport(module_name, name, type_),
          )),
        ),
      )

    _, _ -> panic as "Invalid type index. Type Index must be absolute."
  }
}

/// Import a global from the host. The module_name and name are used to identify the
/// import as the host specifies it. The type of the global is defined by a ValType and
/// whether it is mutable or not.
pub fn import_global(
  module: BinaryModule,
  module_name: String,
  name: String,
  vt: ValType,
  mut: Bool,
) {
  let BinaryModule(imports: imports, ..) = module
  let mut = case mut {
    True -> Var
    False -> Const
  }
  case imports {
    None ->
      BinaryModule(
        ..module,
        imports: Some(
          ImportSection(
            finger_tree.single(GlobalImport(
              module_name,
              name,
              GlobalType(vt, mut),
            )),
          ),
        ),
      )
    Some(ImportSection(imports)) ->
      BinaryModule(
        ..module,
        imports: Some(
          ImportSection(finger_tree.push(
            imports,
            GlobalImport(module_name, name, GlobalType(vt, mut)),
          )),
        ),
      )
  }
}

/// Import a table from the host. The module_name and name are used to identify the
/// import as the host specifies it. The type of the table is defined by a TableType
/// which specifies a refrence type and the size limits of the table.
pub fn import_table(
  module: BinaryModule,
  module_name: String,
  name: String,
  ref_type: RefType,
  limits: Limits,
) {
  let BinaryModule(imports: imports, ..) = module
  case imports {
    None ->
      BinaryModule(
        ..module,
        imports: Some(
          ImportSection(
            finger_tree.single(TableImport(
              module_name,
              name,
              TableType(ref_type, limits),
            )),
          ),
        ),
      )
    Some(ImportSection(imports)) ->
      BinaryModule(
        ..module,
        imports: Some(
          ImportSection(finger_tree.push(
            imports,
            TableImport(module_name, name, TableType(ref_type, limits)),
          )),
        ),
      )
  }
}

/// Import a memory from the host. The module_name and name are used to identify the
/// import as the host specifies it. The type of the memory is defined by a MemType.
/// 
/// Note: There can only be one memory per module.
pub fn import_memory(
  module: BinaryModule,
  module_name: String,
  name: String,
  min: U32,
  max: Option(U32),
) {
  let BinaryModule(imports: imports, ..) = module
  case imports {
    None ->
      BinaryModule(
        ..module,
        imports: Some(
          ImportSection(
            finger_tree.single(MemImport(
              module_name,
              name,
              MemType(Limits(min, max)),
            )),
          ),
        ),
      )
    Some(ImportSection(imports)) ->
      BinaryModule(
        ..module,
        imports: Some(
          ImportSection(finger_tree.push(
            imports,
            MemImport(module_name, name, MemType(Limits(min, max))),
          )),
        ),
      )
  }
}

pub fn add_function_type(module: BinaryModule, type_: TypeIDX) {
  case module, type_ {
    BinaryModule(functions: None, ..), TypeIDX(_) ->
      BinaryModule(
        ..module,
        functions: Some(FunctionSection(finger_tree.single(type_))),
      )

    BinaryModule(functions: Some(FunctionSection(functions)), ..), TypeIDX(_) ->
      BinaryModule(
        ..module,
        functions: Some(FunctionSection(finger_tree.push(functions, type_))),
      )

    _, _ -> panic as "Invalid type index"
  }
}

pub fn add_table(module: BinaryModule, table: Table) {
  let BinaryModule(tables: tables, ..) = module
  case tables {
    None ->
      BinaryModule(
        ..module,
        tables: Some(TableSection(finger_tree.single(table))),
      )
    Some(TableSection(tables)) ->
      BinaryModule(
        ..module,
        tables: Some(TableSection(finger_tree.push(tables, table))),
      )
  }
}

pub fn add_memory(module: BinaryModule, memory: MemType) {
  let BinaryModule(memories: memories, ..) = module
  case memories {
    None ->
      BinaryModule(
        ..module,
        memories: Some(MemorySection(finger_tree.single(memory))),
      )
    _ -> panic as "Only one memory is allowed per module."
  }
}

pub fn add_global(module: BinaryModule, global: Global) {
  let BinaryModule(globals: globals, ..) = module
  case globals {
    None ->
      BinaryModule(
        ..module,
        globals: Some(GlobalSection(finger_tree.single(global))),
      )
    Some(GlobalSection(globals)) ->
      BinaryModule(
        ..module,
        globals: Some(GlobalSection(finger_tree.push(globals, global))),
      )
  }
}

fn unique_export_name(acc: Set(String), export: Export) {
  let name = export.name
  case acc |> set.contains(name) {
    True -> Error("Duplicate export name")
    False -> Ok(acc |> set.insert(name))
  }
}

pub fn export_func(module: BinaryModule, name: String, func: FuncIDX) {
  let BinaryModule(exports: exports, ..) = module
  case exports {
    None ->
      BinaryModule(
        ..module,
        exports: Some(ExportSection(finger_tree.single(FuncExport(name, func)))),
      )
    Some(ExportSection(exports)) -> {
      let assert Ok(_) =
        exports
        |> finger_tree.try_reducel(
          set.new() |> set.insert(name),
          unique_export_name,
        )
      BinaryModule(
        ..module,
        exports: Some(
          ExportSection(finger_tree.push(exports, FuncExport(name, func))),
        ),
      )
    }
  }
}

pub fn export_table(module: BinaryModule, name: String, table: TableIDX) {
  let BinaryModule(exports: exports, ..) = module
  case exports {
    None ->
      BinaryModule(
        ..module,
        exports: Some(
          ExportSection(finger_tree.single(TableExport(name, table))),
        ),
      )
    Some(ExportSection(exports)) -> {
      let assert Ok(_) =
        exports
        |> finger_tree.try_reducel(
          set.new() |> set.insert(name),
          unique_export_name,
        )
      BinaryModule(
        ..module,
        exports: Some(
          ExportSection(finger_tree.push(exports, TableExport(name, table))),
        ),
      )
    }
  }
}

pub fn export_memory(module: BinaryModule, name: String, memory: MemIDX) {
  let BinaryModule(exports: exports, ..) = module
  case exports {
    None ->
      BinaryModule(
        ..module,
        exports: Some(
          ExportSection(finger_tree.single(MemExport(name, memory))),
        ),
      )
    Some(ExportSection(exports)) -> {
      let assert Ok(_) =
        exports
        |> finger_tree.try_reducel(
          set.new() |> set.insert(name),
          unique_export_name,
        )
      BinaryModule(
        ..module,
        exports: Some(
          ExportSection(finger_tree.push(exports, MemExport(name, memory))),
        ),
      )
    }
  }
}

pub fn export_global(module: BinaryModule, name: String, global: GlobalIDX) {
  let BinaryModule(exports: exports, ..) = module
  case exports {
    None ->
      BinaryModule(
        ..module,
        exports: Some(
          ExportSection(finger_tree.single(GlobalExport(name, global))),
        ),
      )
    Some(ExportSection(exports)) -> {
      let assert Ok(_) =
        exports
        |> finger_tree.try_reducel(
          set.new() |> set.insert(name),
          unique_export_name,
        )
      BinaryModule(
        ..module,
        exports: Some(
          ExportSection(finger_tree.push(exports, GlobalExport(name, global))),
        ),
      )
    }
  }
}

pub fn set_start(module: BinaryModule, func: FuncIDX) {
  BinaryModule(..module, start: Some(StartSection(func)))
}

pub fn active_funcs_element_segment(
  module: BinaryModule,
  offset: Expr,
  table_index: TableIDX,
  funcs: List(FuncIDX),
) {
  let BinaryModule(elements: elements, ..) = module
  case elements {
    None ->
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(
            finger_tree.single(ElemFuncs(
              HeapTypeRefType(FuncHeapType, False),
              finger_tree.from_list(funcs),
              ActiveElemMode(table_index, offset),
            )),
          ),
        ),
      )
    Some(ElementSection(elements)) ->
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(finger_tree.push(
            elements,
            ElemFuncs(
              HeapTypeRefType(FuncHeapType, False),
              finger_tree.from_list(funcs),
              ActiveElemMode(table_index, offset),
            ),
          )),
        ),
      )
  }
}

pub fn passive_funcs_element_segment(module: BinaryModule, funcs: List(FuncIDX)) {
  let BinaryModule(elements: elements, ..) = module
  case elements {
    None ->
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(
            finger_tree.single(ElemFuncs(
              HeapTypeRefType(FuncHeapType, False),
              finger_tree.from_list(funcs),
              PassiveElemMode,
            )),
          ),
        ),
      )
    Some(ElementSection(elements)) ->
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(finger_tree.push(
            elements,
            ElemFuncs(
              HeapTypeRefType(FuncHeapType, False),
              finger_tree.from_list(funcs),
              PassiveElemMode,
            ),
          )),
        ),
      )
  }
}

pub fn declarative_funcs_element_segment(
  module: BinaryModule,
  funcs: List(FuncIDX),
) {
  let BinaryModule(elements: elements, ..) = module
  case elements {
    None ->
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(
            finger_tree.single(ElemFuncs(
              HeapTypeRefType(FuncHeapType, False),
              finger_tree.from_list(funcs),
              DeclarativeElemMode,
            )),
          ),
        ),
      )
    Some(ElementSection(elements)) ->
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(finger_tree.push(
            elements,
            ElemFuncs(
              HeapTypeRefType(FuncHeapType, False),
              finger_tree.from_list(funcs),
              DeclarativeElemMode,
            ),
          )),
        ),
      )
  }
}

pub fn active_element_segment(
  module: BinaryModule,
  ref_type: RefType,
  offset: Expr,
  table_index: TableIDX,
  exprs: List(Expr),
) {
  let BinaryModule(elements: elements, ..) = module
  case elements {
    None -> {
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(
            finger_tree.single(ElemExpressions(
              ref_type,
              finger_tree.from_list(exprs),
              ActiveElemMode(table_index, offset),
            )),
          ),
        ),
      )
    }
    Some(ElementSection(elements)) ->
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(finger_tree.push(
            elements,
            ElemExpressions(
              ref_type,
              finger_tree.from_list(exprs),
              ActiveElemMode(table_index, offset),
            ),
          )),
        ),
      )
  }
}

pub fn passive_element_segment(
  module: BinaryModule,
  ref_type: RefType,
  exprs: List(Expr),
) {
  let BinaryModule(elements: elements, ..) = module
  case elements {
    None -> {
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(
            finger_tree.single(ElemExpressions(
              ref_type,
              finger_tree.from_list(exprs),
              PassiveElemMode,
            )),
          ),
        ),
      )
    }
    Some(ElementSection(elements)) ->
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(finger_tree.push(
            elements,
            ElemExpressions(
              ref_type,
              finger_tree.from_list(exprs),
              PassiveElemMode,
            ),
          )),
        ),
      )
  }
}

pub fn declarative_element_segment(
  module: BinaryModule,
  ref_type: RefType,
  exprs: List(Expr),
) {
  let BinaryModule(elements: elements, ..) = module
  case elements {
    None -> {
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(
            finger_tree.single(ElemExpressions(
              ref_type,
              finger_tree.from_list(exprs),
              DeclarativeElemMode,
            )),
          ),
        ),
      )
    }
    Some(ElementSection(elements)) ->
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(finger_tree.push(
            elements,
            ElemExpressions(
              ref_type,
              finger_tree.from_list(exprs),
              DeclarativeElemMode,
            ),
          )),
        ),
      )
  }
}

fn concatenate_locals(locals: List(ValType)) {
  case locals {
    [] -> finger_tree.new()
    [a, ..rest] -> do_concatenate_locals(rest, finger_tree.new(), #(1, a))
  }
}

fn do_concatenate_locals(
  locals: List(ValType),
  acc: FingerTree(Locals),
  current: #(Int, ValType),
) {
  case locals, current {
    [val_type, ..rest], #(count, current_type) if val_type == current_type ->
      do_concatenate_locals(rest, acc, #(count + 1, val_type))
    [val_type, ..rest], #(count, current_type) -> {
      let assert Ok(count) = u32(count)

      let locals = Locals(count, current_type)
      do_concatenate_locals(rest, finger_tree.push(acc, locals), #(1, val_type))
    }
    [], #(count, current_type) -> {
      let assert Ok(count) = u32(count)

      let locals = Locals(count, current_type)
      finger_tree.push(acc, locals)
    }
  }
}

/// Add a code function to the code section.
pub fn add_code(module: BinaryModule, locals: List(ValType), body: Expr) {
  let BinaryModule(code: code, ..) = module

  let locals = concatenate_locals(locals)

  case code {
    None ->
      BinaryModule(
        ..module,
        code: Some(CodeSection(finger_tree.single(Code(locals, body)))),
      )
    Some(CodeSection(code)) ->
      BinaryModule(
        ..module,
        code: Some(CodeSection(finger_tree.push(code, Code(locals, body)))),
      )
  }
}

pub fn add_active_data(
  module: BinaryModule,
  mem_idx: MemIDX,
  offset: Expr,
  data: BitArray,
) {
  let BinaryModule(data: data_section, ..) = module
  case data_section {
    None ->
      BinaryModule(
        ..module,
        data: Some(
          DataSection(finger_tree.single(ActiveData(mem_idx, offset, data))),
        ),
      )
    Some(DataSection(data_section)) ->
      BinaryModule(
        ..module,
        data: Some(
          DataSection(finger_tree.push(
            data_section,
            ActiveData(mem_idx, offset, data),
          )),
        ),
      )
  }
}

pub fn add_passive_data(module: BinaryModule, data: BitArray) {
  let BinaryModule(data: data_section, ..) = module
  case data_section {
    None ->
      BinaryModule(
        ..module,
        data: Some(DataSection(finger_tree.single(PassiveData(data)))),
      )
    Some(DataSection(data_section)) ->
      BinaryModule(
        ..module,
        data: Some(
          DataSection(finger_tree.push(data_section, PassiveData(data))),
        ),
      )
  }
}

pub fn set_data_count(module: BinaryModule, count: U32) {
  BinaryModule(..module, data_count: Some(DataCountSection(count)))
}

pub fn type_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(TypeIDX(idx))
    Error(msg) -> Error(msg)
  }
}

pub fn local_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(LocalIDX(idx))
    Error(msg) -> Error(msg)
  }
}

pub fn global_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(GlobalIDX(idx))
    Error(msg) -> Error(msg)
  }
}

pub fn table_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(TableIDX(idx))
    Error(msg) -> Error(msg)
  }
}

pub fn mem_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(MemIDX(idx))
    Error(msg) -> Error(msg)
  }
}

pub fn elem_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(ElemIDX(idx))
    Error(msg) -> Error(msg)
  }
}

pub fn data_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(DataIDX(idx))
    Error(msg) -> Error(msg)
  }
}

pub fn label_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(LabelIDX(idx))
    Error(msg) -> Error(msg)
  }
}

pub fn func_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(FuncIDX(idx))
    Error(msg) -> Error(msg)
  }
}

pub fn encode(module: BinaryModule) {
  modules.encode_module(module)
}
