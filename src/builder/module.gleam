import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/set.{type Set}
import internal/binary/modules
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
  type Export, type Expr, type FieldType, type FuncIDX, type Global,
  type GlobalIDX, type Limits, type Locals, type MemIDX, type MemType,
  type RecType, type RefType, type Table, type TableIDX, type TableType,
  type TypeIDX, type ValType, ActiveData, ActiveElemMode, ArrayCompositeType,
  ArrayType, Code, Const, DataIDX, DeclarativeElemMode, ElemExpressions,
<<<<<<< HEAD
  ElemFuncs, ElemIDX, FieldIDX, FieldType, FuncCompositeType, FuncExport,
  FuncHeapType, FuncIDX, FuncImport, FuncType, Global, GlobalExport, GlobalIDX,
  GlobalImport, GlobalType, HeapTypeRefType, LabelIDX, Limits, LocalIDX, Locals,
  MemExport, MemIDX, MemImport, MemType, PassiveData, PassiveElemMode, RecType,
=======
  ElemFuncs, ElemIDX, FieldType, FuncCompositeType, FuncExport, FuncHeapType,
  FuncIDX, FuncImport, FuncType, Global, GlobalExport, GlobalIDX, GlobalImport,
  GlobalType, HeapTypeRefType, LabelIDX, Limits, LocalIDX, Locals, MemExport,
  MemIDX, MemImport, MemType, PassiveData, PassiveElemMode, RecType,
>>>>>>> 5b7120c (Final push 0.0.1 (#3))
  StructCompositeType, StructType, SubType, Table, TableExport, TableIDX,
  TableImport, TableType, TypeIDX, Var,
}

pub const new = structure_modules.binary_module_new

/// Add a custom section to the module after the last modified section.
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

fn add_to_optional_list(items: Option(List(u)), item: u) {
  case items {
    Some(items) -> Some(items |> list.append([item]))
    None -> Some([item])
  }
}

/// Add a new concrete Recursive Type to the TypeSection.
pub fn add_type(module: BinaryModule, type_: RecType) {
  let BinaryModule(types: types, ..) = module
  case types {
    None -> BinaryModule(..module, types: Some(TypeSection([type_])))
    Some(TypeSection(types)) ->
      BinaryModule(
        ..module,
        types: Some(TypeSection(list.append(types, [type_]))),
      )
  }
}

/// Add a new concrete FuncType to the TypeSection.
pub fn add_func_type(
  module: BinaryModule,
  parameters: List(ValType),
  results: List(ValType),
) {
  let func_type =
<<<<<<< HEAD
    SubType(False, [], FuncCompositeType(FuncType(parameters, results)))

  add_type(module, RecType([func_type]))
=======
    SubType(
      False,
      finger_tree.empty,
      FuncCompositeType(FuncType(
        finger_tree.from_list(parameters),
        finger_tree.from_list(results),
      )),
    )

  add_type(module, RecType(finger_tree.single(func_type)))
>>>>>>> 5b7120c (Final push 0.0.1 (#3))
}

/// Add a new concrete ArrayType to the TypeSection
pub fn add_array_type(module: BinaryModule, element_type: FieldType) {
  let array_type =
<<<<<<< HEAD
    SubType(False, [], ArrayCompositeType(ArrayType(element_type)))
  add_type(module, RecType([array_type]))
=======
    SubType(
      False,
      finger_tree.empty,
      ArrayCompositeType(ArrayType(element_type)),
    )
  add_type(module, RecType(finger_tree.single(array_type)))
>>>>>>> 5b7120c (Final push 0.0.1 (#3))
}

// Add a new StructType to the TypeSection
pub fn add_struct_type(module: BinaryModule, fields: List(FieldType)) {
<<<<<<< HEAD
  let struct_type = SubType(False, [], StructCompositeType(StructType(fields)))

  add_type(module, RecType([struct_type]))
=======
  let struct_type =
    SubType(
      False,
      finger_tree.empty,
      StructCompositeType(StructType(finger_tree.from_list(fields))),
    )

  add_type(module, RecType(finger_tree.single(struct_type)))
>>>>>>> 5b7120c (Final push 0.0.1 (#3))
}

// Add a new StructType to the TypeSection that is marked as "final"
pub fn add_final_struct_type(module: BinaryModule, fields: List(FieldType)) {
<<<<<<< HEAD
  let struct_type = SubType(True, [], StructCompositeType(StructType(fields)))

  add_type(module, RecType([struct_type]))
=======
  let struct_type =
    SubType(
      True,
      finger_tree.empty,
      StructCompositeType(StructType(finger_tree.from_list(fields))),
    )

  add_type(module, RecType(finger_tree.single(struct_type)))
>>>>>>> 5b7120c (Final push 0.0.1 (#3))
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
        imports: Some(ImportSection([FuncImport(module_name, name, type_)])),
      )

    Some(ImportSection(imports)), TypeIDX(_) ->
      BinaryModule(
        ..module,
        imports: Some(
          ImportSection(
            list.append(imports, [FuncImport(module_name, name, type_)]),
          ),
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
          ImportSection([GlobalImport(module_name, name, GlobalType(vt, mut))]),
        ),
      )
    Some(ImportSection(imports)) ->
      BinaryModule(
        ..module,
        imports: Some(ImportSection(
          imports
          |> list.append([GlobalImport(module_name, name, GlobalType(vt, mut))]),
        )),
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
          ImportSection([
            TableImport(module_name, name, TableType(ref_type, limits)),
          ]),
        ),
      )
    Some(ImportSection(imports)) ->
      BinaryModule(
        ..module,
        imports: Some(
          ImportSection(
            list.append(imports, [
              TableImport(module_name, name, TableType(ref_type, limits)),
            ]),
          ),
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
          ImportSection([
            MemImport(module_name, name, MemType(Limits(min, max))),
          ]),
        ),
      )
    Some(ImportSection(imports)) ->
      BinaryModule(
        ..module,
        imports: Some(
          ImportSection(
            list.append(imports, [
              MemImport(module_name, name, MemType(Limits(min, max))),
            ]),
          ),
        ),
      )
  }
}

/// Appends a function type, defined by it's index, into the function signature
/// section. This is not the same as adding a concrete function type to the module's type section.
/// It merely describes the signature of a given function in the import and code section.
///
/// Note: The function type index must be absolute, and the function type must already be defined
/// in the type section in order for the module to be valid.
///
/// Every function signature must be defined in the function section.
///
/// Panics if the index is a RecTypeIDX or a DefType
pub fn append_function_type_index(module: BinaryModule, type_: TypeIDX) {
  case module, type_ {
    BinaryModule(functions: None, ..), TypeIDX(_) ->
      BinaryModule(..module, functions: Some(FunctionSection([type_])))

    BinaryModule(functions: Some(FunctionSection(functions)), ..), TypeIDX(_) ->
      BinaryModule(
        ..module,
        functions: Some(FunctionSection(list.append(functions, [type_]))),
      )

    _, _ -> panic as "Invalid type index"
  }
}

/// Add a WebAssembly table to the module defined by it's reference type, it's minimum and optional
/// maximum size, and an optional constant initializer expression.
pub fn add_table(
  module: BinaryModule,
  ref_type: RefType,
  min: U32,
  max: Option(U32),
  init: Option(Expr),
) {
  let BinaryModule(tables: tables, ..) = module
  let table = Table(TableType(ref_type, Limits(min, max)), init)
  case tables {
    None -> BinaryModule(..module, tables: Some(TableSection([table])))
    Some(TableSection(tables)) ->
      BinaryModule(
        ..module,
        tables: Some(TableSection(list.append(tables, [table]))),
      )
  }
}

/// Add a WebAssembly memory to the module defined by it's memory type.
///
/// Note: Currently, only one memory is allowed per module, as described in the WebAssembly spec.
pub fn add_memory(module: BinaryModule, memory: MemType) {
  let BinaryModule(memories: memories, ..) = module
  case memories {
    None -> BinaryModule(..module, memories: Some(MemorySection([memory])))
    _ -> panic as "Only one memory is allowed per module."
  }
}

/// Add a WebAssembly global to the module defined by it's global type, mutability option
/// and initializer expression.
pub fn add_global(module: BinaryModule, vt: ValType, mut: Bool, init: Expr) {
  let BinaryModule(globals: globals, ..) = module
  let global =
    Global(
      GlobalType(vt, case mut {
        True -> Var
        False -> Const
      }),
      init,
    )
  case globals {
    None -> BinaryModule(..module, globals: Some(GlobalSection([global])))
    Some(GlobalSection(globals)) ->
      BinaryModule(
        ..module,
        globals: Some(GlobalSection(list.append(globals, [global]))),
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

/// Export a function to the module. The function is given by it's index into the function section,
/// and it's name.
pub fn export_func(module: BinaryModule, name: String, func: FuncIDX) {
  let BinaryModule(exports: exports, ..) = module
  case exports {
    None ->
      BinaryModule(
        ..module,
        exports: Some(ExportSection([FuncExport(name, func)])),
      )
    Some(ExportSection(exports)) -> {
      let assert Ok(_) =
        exports
        |> list.try_fold(set.new() |> set.insert(name), unique_export_name)
      BinaryModule(
        ..module,
        exports: Some(
          ExportSection(list.append(exports, [FuncExport(name, func)])),
        ),
      )
    }
  }
}

/// Export a table to the module. The table is given by it's index into the table section,
/// and it's name.
pub fn export_table(module: BinaryModule, name: String, table: TableIDX) {
  let BinaryModule(exports: exports, ..) = module
  case exports {
    None ->
      BinaryModule(
        ..module,
        exports: Some(ExportSection([TableExport(name, table)])),
      )
    Some(ExportSection(exports)) -> {
      let assert Ok(_) =
        exports
        |> list.try_fold(set.new() |> set.insert(name), unique_export_name)
      BinaryModule(
        ..module,
        exports: Some(
          ExportSection(list.append(exports, [TableExport(name, table)])),
        ),
      )
    }
  }
}

/// Export a memory to the module. The memory is given by it's index into the memory section,
/// and it's name.
<<<<<<< HEAD
///
=======
/// 
>>>>>>> 5b7120c (Final push 0.0.1 (#3))
/// Note: Currently, only one memory is allowed per module, as described in the WebAssembly spec.
/// https://webassembly.github.io/gc/core/syntax/modules.html#memories
pub fn export_memory(module: BinaryModule, name: String, memory: MemIDX) {
  let BinaryModule(exports: exports, ..) = module
  case exports {
    None ->
      BinaryModule(
        ..module,
        exports: Some(ExportSection([MemExport(name, memory)])),
      )
    Some(ExportSection(exports)) -> {
      let assert Ok(_) =
        exports
        |> list.try_fold(set.new() |> set.insert(name), unique_export_name)
      BinaryModule(
        ..module,
        exports: Some(
          ExportSection(list.append(exports, [MemExport(name, memory)])),
        ),
      )
    }
  }
}

/// Export a global to the module. The global is given by it's index into the global section,
/// and it's name.
pub fn export_global(module: BinaryModule, name: String, global: GlobalIDX) {
  let BinaryModule(exports: exports, ..) = module
  case exports {
    None ->
      BinaryModule(
        ..module,
        exports: Some(ExportSection([GlobalExport(name, global)])),
      )
    Some(ExportSection(exports)) -> {
      let assert Ok(_) =
        exports
        |> list.try_fold(set.new() |> set.insert(name), unique_export_name)
      BinaryModule(
        ..module,
        exports: Some(
          ExportSection(list.append(exports, [GlobalExport(name, global)])),
        ),
      )
    }
  }
}

/// Set the start function for the module.
pub fn set_start(module: BinaryModule, func: FuncIDX) {
  BinaryModule(..module, start: Some(StartSection(func)))
}

/// Add an active element segment with the given list of function indexes to the module.
/// It will initialize the given table at the given offset when the module is instantiated.
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
          ElementSection([
            ElemFuncs(
              HeapTypeRefType(FuncHeapType, False),
              funcs,
              ActiveElemMode(table_index, offset),
            ),
          ]),
        ),
      )
    Some(ElementSection(elements)) ->
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(
            list.append(elements, [
              ElemFuncs(
                HeapTypeRefType(FuncHeapType, False),
                funcs,
                ActiveElemMode(table_index, offset),
              ),
            ]),
          ),
        ),
      )
  }
}

/// Add a passive element segment with the given list of function indexes to the module.
pub fn passive_funcs_element_segment(module: BinaryModule, funcs: List(FuncIDX)) {
  let BinaryModule(elements: elements, ..) = module
  case elements {
    None ->
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection([
            ElemFuncs(
              HeapTypeRefType(FuncHeapType, False),
              funcs,
              PassiveElemMode,
            ),
          ]),
        ),
      )
    Some(ElementSection(elements)) ->
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(
            list.append(elements, [
              ElemFuncs(
                HeapTypeRefType(FuncHeapType, False),
                funcs,
                PassiveElemMode,
              ),
            ]),
          ),
        ),
      )
  }
}

/// Add a declarative element segment with the given list of function indexes to the module.
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
          ElementSection([
            ElemFuncs(
              HeapTypeRefType(FuncHeapType, False),
              funcs,
              DeclarativeElemMode,
            ),
          ]),
        ),
      )
    Some(ElementSection(elements)) ->
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(
            list.append(elements, [
              ElemFuncs(
                HeapTypeRefType(FuncHeapType, False),
                funcs,
                DeclarativeElemMode,
              ),
            ]),
          ),
        ),
      )
  }
}

/// Add an active element segment with the given list of expressions to the module.
/// It will initialize the given table at the given offset when the module is instantiated.
/// The expressions must all match the given reference type.
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
          ElementSection([
            ElemExpressions(
              ref_type,
              exprs,
              ActiveElemMode(table_index, offset),
            ),
          ]),
        ),
      )
    }
    Some(ElementSection(elements)) ->
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(
            list.append(elements, [
              ElemExpressions(
                ref_type,
                exprs,
                ActiveElemMode(table_index, offset),
              ),
            ]),
          ),
        ),
      )
  }
}

/// Add a passive element segment with the given list of expressions to the module.
/// The expressions must all match the given reference type.
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
          ElementSection([ElemExpressions(ref_type, exprs, PassiveElemMode)]),
        ),
      )
    }
    Some(ElementSection(elements)) ->
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(
            list.append(elements, [
              ElemExpressions(ref_type, exprs, PassiveElemMode),
            ]),
          ),
        ),
      )
  }
}

/// Add a declarative element segment with the given list of expressions to the module.
/// The expressions must all match the given reference type.
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
          ElementSection([ElemExpressions(ref_type, exprs, DeclarativeElemMode)]),
        ),
      )
    }
    Some(ElementSection(elements)) ->
      BinaryModule(
        ..module,
        elements: Some(
          ElementSection(
            list.append(elements, [
              ElemExpressions(ref_type, exprs, DeclarativeElemMode),
            ]),
          ),
        ),
      )
  }
}

fn concatenate_locals(locals: List(ValType)) {
  case locals {
    [] -> []
    [a, ..rest] -> do_concatenate_locals(rest, [], #(1, a))
  }
}

/// fn i32 i32 i32 f32 -> void
/// "Locals"
/// fn (3 i32) (1 f32)
fn do_concatenate_locals(
  locals: List(ValType),
  acc: List(Locals),
  current: #(Int, ValType),
) {
  case locals, current {
    [val_type, ..rest], #(count, current_type) if val_type == current_type ->
      do_concatenate_locals(rest, acc, #(count + 1, val_type))
    [val_type, ..rest], #(count, current_type) -> {
      let assert Ok(count) = u32(count)

      let locals = Locals(count, current_type)
      do_concatenate_locals(rest, [locals, ..acc], #(1, val_type))
    }
    [], #(count, current_type) -> {
      let assert Ok(count) = u32(count)

      let locals = Locals(count, current_type)
      [locals, ..acc] |> list.reverse
    }
  }
}

/// Add the function's definition to the code section. The given locals must be in order
/// and match the function section's parameters, followed by any local variables needed
/// by the function.
pub fn add_code(module: BinaryModule, locals: List(ValType), body: Expr) {
  let BinaryModule(code: code, ..) = module

  let locals = concatenate_locals(locals)

  case code {
    None ->
      BinaryModule(..module, code: Some(CodeSection([Code(locals, body)])))
    Some(CodeSection(code)) ->
      BinaryModule(
        ..module,
        code: Some(CodeSection(list.append(code, [Code(locals, body)]))),
      )
  }
}

/// Add an active data segment to the module. The data will initialize the given
/// memory index at the given offset when the module is instantiated.
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
        data: Some(DataSection([ActiveData(mem_idx, offset, data)])),
      )
    Some(DataSection(data_section)) ->
      BinaryModule(
        ..module,
        data: Some(
          DataSection(
            list.append(data_section, [ActiveData(mem_idx, offset, data)]),
          ),
        ),
      )
  }
}

/// Add a passive data segment to the module. A passive element segment's elements
/// can be copied to a table using the WebAssembly `table.init` instruction.
pub fn add_passive_data(module: BinaryModule, data: BitArray) {
  let BinaryModule(data: data_section, ..) = module
  case data_section {
    None -> BinaryModule(..module, data: Some(DataSection([PassiveData(data)])))
    Some(DataSection(data_section)) ->
      BinaryModule(
        ..module,
        data: Some(DataSection(list.append(data_section, [PassiveData(data)]))),
      )
  }
}

/// Set the number of data segments in the module. This section is not necessary, but is
/// useful for validation.
pub fn set_data_count(module: BinaryModule, count: U32) {
  BinaryModule(..module, data_count: Some(DataCountSection(count)))
}

/// Create a type index, as long as the index is a valid U32 value.
pub fn type_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(TypeIDX(idx))
    Error(msg) -> Error(msg)
  }
}

/// Create a function index, as long as the index is a valid U32 value.
pub fn local_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(LocalIDX(idx))
    Error(msg) -> Error(msg)
  }
}

/// Create a global index, as long as the index is a valid U32 value.
pub fn global_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(GlobalIDX(idx))
    Error(msg) -> Error(msg)
  }
}

/// Create a table index, as long as the index is a valid U32 value.
pub fn table_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(TableIDX(idx))
    Error(msg) -> Error(msg)
  }
}

/// Create a memory index, as long as the index is a valid U32 value.
pub fn mem_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(MemIDX(idx))
    Error(msg) -> Error(msg)
  }
}

/// Create an element index, as long as the index is a valid U32 value.
pub fn elem_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(ElemIDX(idx))
    Error(msg) -> Error(msg)
  }
}

/// Create a data index, as long as the index is a valid U32 value.
pub fn data_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(DataIDX(idx))
    Error(msg) -> Error(msg)
  }
}

/// Create a label index, as long as the index is a valid U32 value.
pub fn label_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(LabelIDX(idx))
    Error(msg) -> Error(msg)
  }
}

/// Create a function index, as long as the index is a valid U32 value.
pub fn func_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(FuncIDX(idx))
    Error(msg) -> Error(msg)
  }
}

<<<<<<< HEAD
/// Create a field index, as long as the index is a valid U32 value. The index must
/// must be less than the number of fields in the struct.
pub fn field_idx(idx: Int) {
  case u32(idx) {
    Ok(idx) -> Ok(FieldIDX(idx))
    Error(msg) -> Error(msg)
  }
}

=======
>>>>>>> 5b7120c (Final push 0.0.1 (#3))
/// Encode the module into a BitArray, as long as the module is syntatically correctly.
/// Modules encoded with this function will not be validated. Please use the `validate`
/// function to validate the module before encoding to ensure that the module is usable.
///
/// Note: The validate function has not been implemented yet, and is not provided as part
/// of the MVP of shine_coder
pub fn encode(module: BinaryModule) {
  modules.encode_module(module)
}

/// Decode the module from a BitArray.
///
/// This method will fail if the module is invalid.
///
/// It returns:
///
/// - Ok(#(the_module, unparsed_bits))
/// - Error(message)
pub fn decode(module: BitArray) {
  modules.decode_module(module)
}
