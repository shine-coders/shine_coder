import gleam/dict
import gleam/option.{type Option, None, Some}
import gleam/set.{type Set}
import internal/finger_tree.{type FingerTree}
import internal/structure/modules.{
  type BinaryModule, type CustomSection, type ExportSection,
  type FunctionSection, type GlobalSection, type MemorySection,
  type TableSection, type TypeSection, BinaryModule, CustomSection,
  ExportSection, FunctionSection, GlobalSection, ImportSection, MemorySection,
  TableSection, TypeSection,
}
import internal/structure/types.{
  type Export, type FuncIDX, type Global, type GlobalIDX, type Import,
  type MemIDX, type MemType, type RecType, type Table, type TableIDX,
  type TypeIDX, FuncExport, FuncIDX, GlobalExport, MemExport, TableExport,
  TypeIDX,
}

pub const new = modules.binary_module_new

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

pub fn add_import(module: BinaryModule, import_: Import) {
  let BinaryModule(imports: imports, ..) = module
  case imports {
    None ->
      BinaryModule(
        ..module,
        imports: Some(ImportSection(finger_tree.single(import_))),
      )
    Some(ImportSection(imports)) ->
      BinaryModule(
        ..module,
        imports: Some(ImportSection(finger_tree.push(imports, import_))),
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
