import gleam/bytes_builder.{type BytesBuilder}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import internal/binary/common.{encode_section_from_builder}
import internal/binary/types.{
  decode_expression, decode_func_idx, decode_global_idx, decode_global_type,
  decode_mem_idx, decode_mem_type, decode_rec_type, decode_ref_type,
  decode_table_idx, decode_table_type, decode_type_idx, decode_val_type,
  encode_expression, encode_func_idx, encode_global_idx, encode_global_type,
  encode_locals, encode_mem_idx, encode_mem_type, encode_rec_type,
  encode_ref_type, encode_table_idx, encode_table_type, encode_type_idx,
}
import internal/binary/values.{encode_u32}
import internal/structure/modules.{
  type BinaryModule, type CodeSection, type CustomSection, type DataCountSection,
  type DataSection, type ElementSection, type ExportSection,
  type FunctionSection, type GlobalSection, type ImportSection,
  type MemorySection, type StartSection, type TableSection, type TypeSection,
  BinaryModule, CodeSection, CustomSection, DataCountSection, DataSection,
  ElementSection, ExportSection, FunctionSection, GlobalSection, ImportSection,
  MemorySection, StartSection, TableSection, TypeSection,
}
import internal/structure/numbers
import internal/structure/types.{
  type Code, type Data, type Elem, type Export, type Global, type Import,
  type Table, ActiveData, ActiveElemMode, Code, DeclarativeElemMode,
  ElemExpressions, ElemFuncs, FuncExport, FuncHeapType, FuncImport, Global,
  GlobalExport, GlobalImport, HeapTypeRefType, Locals, MemExport, MemImport,
  PassiveData, PassiveElemMode, Table, TableExport, TableIDX, TableImport,
} as structure_types

/// The magic header bytes of every web assembly module
const wasm_magic = <<0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00>>

/// Encode a binary module, returning either a BitArray or an Error
pub fn encode_module(module: BinaryModule) {
  let builder =
    bytes_builder.new()
    |> bytes_builder.append(wasm_magic)

  // Between each section can be a set of optional custom sections throughout the encoding
  // process, interleaved between each section.
  use builder <- result.try(encode_custom_sections(builder, module.custom_0))
  // The type section has id 0x01, and is always first if it exists in the module.
  // The job of this section is to describe a set of types that are used in the
  // rest of the module.
  use builder <- result.try(
    builder |> common.encode_option(module.types, encode_type_section),
  )

  use builder <- result.try(encode_custom_sections(builder, module.custom_1))

  // The next section is always the import section if it exists with id 0x02. The
  // import section is used to import functions, tables, memories, and globals from
  // the web assembly host.
  use builder <- result.try(
    builder |> common.encode_option(module.imports, encode_import_section),
  )

  use builder <- result.try(encode_custom_sections(builder, module.custom_2))

  // The next section is always the function section if it exists with id 0x03.
  // Despite the name, this section is used to define the types of each function
  // in the code section which has the actual function bodies.
  use builder <- result.try(
    builder |> common.encode_option(module.functions, encode_function_section),
  )

  use builder <- result.try(encode_custom_sections(builder, module.custom_3))

  // The next section is always the table section if it exists with id 0x04. The
  // table section describes a vector of tables that can hold a given number of
  // refrences used by that module.
  use builder <- result.try(
    builder |> common.encode_option(module.tables, encode_table_section),
  )

  use builder <- result.try(encode_custom_sections(builder, module.custom_4))

  // The next section is always the memory section if it exists with id 0x05.
  // This section describes a vector of memory types that describe the shape
  // of each web assembly memory used by this module. This is only "one" memory
  // but it may be more in the future.
  use builder <- result.try(
    builder |> common.encode_option(module.memories, encode_memory_section),
  )

  use builder <- result.try(encode_custom_sections(builder, module.custom_5))

  // The next section is always the global section if it exists with id 0x06.
  // The global section describes a vector of global variables, that can be
  // used by each function in the code section.
  use builder <- result.try(
    builder |> common.encode_option(module.globals, encode_global_section),
  )

  use builder <- result.try(encode_custom_sections(builder, module.custom_6))

  // The next section is always the export section if it exists with id 0x07.
  // The export section describes a vector of exports, that can be used by
  // the web assembly host.
  use builder <- result.try(
    builder |> common.encode_option(module.exports, encode_export_section),
  )

  use builder <- result.try(encode_custom_sections(builder, module.custom_7))

  // The next section is always the start section if it exists with id 0x08.
  // The start section has the "main" function that will be called after the
  // module is instantiated.
  use builder <- result.try(
    builder |> common.encode_option(module.start, encode_start_section),
  )

  use builder <- result.try(encode_custom_sections(builder, module.custom_8))

  // The next section is always the element section if it exists with id 0x09.
  // The element section describes a vector of element segments that can either
  // be used to instantiate the defined Tables of this module (active element segments,) or used later
  // with instructions like table.init.
  use builder <- result.try(
    builder |> common.encode_option(module.elements, encode_element_section),
  )

  use builder <- result.try(encode_custom_sections(builder, module.custom_9))

  // The next section is the data count section. It contains a single u32 value
  // that describes the number of data segments in the data section.
  // here: https://webassembly.github.io/gc/core/binary/modules.html#binary-module
  use builder <- result.try(
    builder
    |> common.encode_option(module.data_count, encode_data_count_section),
  )

  use builder <- result.try(encode_custom_sections(builder, module.custom_10))

  // The next section is always the code section if it exists with id 0x0a.
  // The code section describes a vector of code blocks that define all the
  // function bodies of each function.
  use builder <- result.try(
    builder |> common.encode_option(module.code, encode_code_section),
  )

  use builder <- result.try(encode_custom_sections(builder, module.custom_11))

  // The next section is always the data section if it exists with id 0x0b.
  // Just like the element section, the data section describes a vector of data
  // segments that can either be used to describe values in the defined memories (active,) or
  // used later to be used with instructions like memory.init.
  use builder <- result.try(
    builder |> common.encode_option(module.data, encode_data_section),
  )

  // The last sections, according to the Wasm Spec, are always custom sections
  use builder <- result.map(encode_custom_sections(builder, module.custom_12))
  builder |> bytes_builder.to_bit_array
}

/// Decode a module from the given bit array, if possible, and returns the rest
/// of the bytes that weren't decoded.
pub fn decode_module(bits: BitArray) {
  use rest <- result.try(common.expect_decode_bytes(bits, wasm_magic))
  use #(custom_0, rest) <- result.try(decode_custom_sections(rest))
  use #(types, rest) <- result.try(decode_type_section(rest))
  use #(custom_1, rest) <- result.try(decode_custom_sections(rest))
  use #(imports, rest) <- result.try(decode_import_section(rest))
  use #(custom_2, rest) <- result.try(decode_custom_sections(rest))
  use #(functions, rest) <- result.try(decode_function_section(rest))
  use #(custom_3, rest) <- result.try(decode_custom_sections(rest))
  use #(tables, rest) <- result.try(decode_table_section(rest))
  use #(custom_4, rest) <- result.try(decode_custom_sections(rest))
  use #(memories, rest) <- result.try(decode_memory_section(rest))
  use #(custom_5, rest) <- result.try(decode_custom_sections(rest))
  use #(globals, rest) <- result.try(decode_global_section(rest))
  use #(custom_6, rest) <- result.try(decode_custom_sections(rest))
  use #(exports, rest) <- result.try(decode_export_section(rest))
  use #(custom_7, rest) <- result.try(decode_custom_sections(rest))
  use #(start, rest) <- result.try(decode_start_section(rest))
  use #(custom_8, rest) <- result.try(decode_custom_sections(rest))
  use #(elements, rest) <- result.try(decode_element_section(rest))
  use #(custom_9, rest) <- result.try(decode_custom_sections(rest))
  use #(data_count, rest) <- result.try(decode_data_count_section(rest))
  use #(custom_10, rest) <- result.try(decode_custom_sections(rest))
  use #(code, rest) <- result.try(decode_code_section(rest))
  use #(custom_11, rest) <- result.try(decode_custom_sections(rest))
  use #(data, rest) <- result.try(decode_data_section(rest))
  use #(custom_12, rest) <- result.map(decode_custom_sections(rest))
  #(
    BinaryModule(
      custom_0,
      types,
      custom_1,
      imports,
      custom_2,
      functions,
      custom_3,
      tables,
      custom_4,
      memories,
      custom_5,
      globals,
      custom_6,
      exports,
      custom_7,
      start,
      custom_8,
      elements,
      custom_9,
      code,
      custom_10,
      data,
      custom_11,
      data_count,
      custom_12,
    ),
    rest,
  )
}

fn do_decode_data_count_section(bits: BitArray) {
  use #(count, rest) <- result.map(values.decode_u32(bits))
  #(DataCountSection(count), rest)
}

/// Decode a data count section from the given bit array. The section should have
/// a single u32 value, which is the number of data segments in the data section.
pub fn decode_data_count_section(bits: BitArray) {
  common.decode_section(bits, 0x0C, do_decode_data_count_section)
}

/// Decode a single data segment from the given bit array.
pub fn decode_data(bits: BitArray) {
  // Each data segment type is denoted by a single byte.
  use #(data_type, rest) <- result.try(values.decode_u32(bits))

  case data_type |> numbers.unwrap_u32 {
    // Type 0 indicates that the data segment is an active data segment, that
    // fills the first memory at memory index 0 when the module is instantiated.
    0 -> {
      use #(offset, rest) <- result.try(decode_expression(rest))
      use #(data, rest) <- result.map(common.decode_byte_vec(rest))

      // The memory index is always 0 for normal active segments
      let assert Ok(mem_idx) = numbers.u32(0)
      let mem_idx = structure_types.MemIDX(mem_idx)

      #(ActiveData(mem_idx, offset, data), rest)
    }

    // Type 1 indicates a static memory segment that can be used later.
    1 -> {
      use #(data, rest) <- result.map(common.decode_byte_vec(rest))
      #(PassiveData(data), rest)
    }

    // Type 2 indicates an active memory segment, just like type 0, except
    // the target memory index must be decoded from the bit array.
    2 -> {
      use #(mem_idx, rest) <- result.try(decode_mem_idx(rest))
      use #(offset, rest) <- result.try(decode_expression(rest))
      use #(data, rest) <- result.map(common.decode_byte_vec(rest))
      #(ActiveData(mem_idx, offset, data), rest)
    }
    _ -> Error("Invalid data type")
  }
}

fn do_decode_data_section(bits: BitArray) {
  use #(data, rest) <- result.map(common.decode_vec(bits, decode_data))
  #(DataSection(data), rest)
}

/// Decode a data section from the given bit array. The section contains
/// a vector of data segments.
pub fn decode_data_section(bits: BitArray) {
  common.decode_section(bits, 0x0B, do_decode_data_section)
}

/// Locals are encoded with a count and a val_type, describing a vector
/// of local variables. For example:
///
/// With three "locals" definitions:
/// [(1 i32) (4 i64) (2 f32)]
///
/// This results in the following local variables defined in a given function body:
/// [(i32) (i64) (i64) (i64) (i64) (f32) (f32)]
///
/// This function decodes a single set of "locals" definitions.
fn decode_locals(bits: BitArray) {
  use #(count, rest) <- result.try(values.decode_u32(bits))
  use #(vt, rest) <- result.map(decode_val_type(rest))
  #(Locals(count, vt), rest)
}

/// Decode a single code segment from the given bit array.
///
/// A code segment is defined by a single u32 value, which denotes the
/// byte size of the locals and function body combined, followed by the
/// locals definitions, and the function body itself.
pub fn decode_code_segment(bits: BitArray) {
  use #(size, rest) <- result.try(values.decode_u32(bits))
  let size = size |> numbers.unwrap_u32
  use #(code_bytes, rest) <- result.try(common.decode_bytes(rest, size))
  use #(locals, code_bytes) <- result.try(common.decode_vec(
    code_bytes,
    decode_locals,
  ))
  use #(body, code_bytes) <- result.try(decode_expression(code_bytes))

  case code_bytes {
    <<>> -> Ok(#(Code(locals, body), rest))
    _ -> Error("Invalid code segment")
  }
}

fn do_decode_code_section(bits: BitArray) {
  use #(codes, rest) <- result.map(common.decode_vec(bits, decode_code_segment))
  #(CodeSection(codes), rest)
}

/// The code section contains a vector of code segments.
pub fn decode_code_section(bits: BitArray) {
  common.decode_section(bits, 0x0A, do_decode_code_section)
}

/// Decode a single element segment from the given bit array.
pub fn decode_elememt(bits: BitArray) {
  // Element segments are denoted by a single byte which represents the type
  // of a given segment.
  use #(elem_type, rest) <- result.try(values.decode_u32(bits))
  let elem_type = elem_type |> numbers.unwrap_u32
  case elem_type {
    // Type 0 indicates and active segment that fills the first table in the table
    // section with the given function indexes when the module is instantiated.
    0 -> {
      use #(expr, rest) <- result.try(decode_expression(rest))
      use #(idx, rest) <- result.map(common.decode_vec(rest, decode_func_idx))
      let assert Ok(zero) = numbers.u32(0x00)
      let table_idx_zero = TableIDX(zero)

      #(
        ElemFuncs(
          HeapTypeRefType(FuncHeapType, False),
          idx,
          ActiveElemMode(table_idx_zero, expr),
        ),
        rest,
      )
    }

    // Type 1 indicates a passive segment of function indexes that can be used
    // later using instructions like table.init.
    1 -> {
      use #(_, rest) <- result.try(common.expect_decode_byte(rest, 0x00))
      use #(idx, rest) <- result.map(common.decode_vec(rest, decode_func_idx))
      #(
        ElemFuncs(HeapTypeRefType(FuncHeapType, False), idx, PassiveElemMode),
        rest,
      )
    }

    // Type 2 indicates an active segment that fills the given table index with
    // the given function indexes when the module is instantiated.
    2 -> {
      use #(table_idx, rest) <- result.try(decode_table_idx(rest))
      use #(expr, rest) <- result.try(decode_expression(rest))
      use #(_, rest) <- result.try(common.expect_decode_byte(rest, 0x00))
      use #(idx, rest) <- result.map(common.decode_vec(rest, decode_func_idx))

      #(
        ElemFuncs(
          HeapTypeRefType(FuncHeapType, False),
          idx,
          ActiveElemMode(table_idx, expr),
        ),
        rest,
      )
    }

    // Type 3 indicates a declarative segment of function indexes that can be used
    // as a hint to the runtime for later reference.
    3 -> {
      use #(_, rest) <- result.try(common.expect_decode_byte(rest, 0x00))
      use #(idx, rest) <- result.map(common.decode_vec(rest, decode_func_idx))

      #(
        ElemFuncs(
          HeapTypeRefType(FuncHeapType, False),
          idx,
          DeclarativeElemMode,
        ),
        rest,
      )
    }

    // Type 4 indicates an active segment that fills the first table in the table
    // section with the given vector of expressions. Each of these expressions must
    // match a function reference value type.
    4 -> {
      use #(offset, rest) <- result.try(decode_expression(rest))
      use #(init, rest) <- result.map(common.decode_vec(rest, decode_expression))
      let assert Ok(zero) = numbers.u32(0x00)
      let table_idx_zero = TableIDX(zero)
      #(
        ElemExpressions(
          HeapTypeRefType(FuncHeapType, False),
          init,
          ActiveElemMode(table_idx_zero, offset),
        ),
        rest,
      )
    }

    // Type 5 indicates a passive vector of expressions that can be used by the
    // module at runtime using instructions like table.init. Each of these expressions
    // must match the given refrence type provided by the definition.
    5 -> {
      use #(rt, rest) <- result.try(decode_ref_type(rest))
      use #(init, rest) <- result.map(common.decode_vec(rest, decode_expression))
      #(ElemExpressions(rt, init, PassiveElemMode), rest)
    }

    // Type 6 indicates an active segment that fills the given table index with
    // the given vector of expressions. Each of these expressions must match the given
    // refrence type provided by the definition.
    6 -> {
      use #(table_idx, rest) <- result.try(decode_table_idx(rest))
      use #(offset, rest) <- result.try(decode_expression(rest))
      use #(rt, rest) <- result.try(decode_ref_type(rest))
      use #(init, rest) <- result.map(common.decode_vec(rest, decode_expression))
      #(ElemExpressions(rt, init, ActiveElemMode(table_idx, offset)), rest)
    }

    // Type 7 indicates a declarative segment of expressions that can be used
    // as a hint to the runtime for later reference. Each of these expressions
    // must match the given refrence type provided by the definition.
    7 -> {
      use #(rt, rest) <- result.try(decode_ref_type(rest))
      use #(init, rest) <- result.map(common.decode_vec(rest, decode_expression))
      #(ElemExpressions(rt, init, DeclarativeElemMode), rest)
    }
    _ -> Error("Invalid element segment type")
  }
}

fn do_decode_element_segment(bits: BitArray) {
  use #(elems, rest) <- result.map(common.decode_vec(bits, decode_elememt))
  #(ElementSection(elems), rest)
}

/// Decode an element section which is defined by a vector of element segments.
pub fn decode_element_section(bits: BitArray) {
  common.decode_section(bits, 0x09, do_decode_element_segment)
}

fn do_decode_start_section(bits: BitArray) {
  use #(start_idx, rest) <- result.map(decode_func_idx(bits))
  #(StartSection(start_idx), rest)
}

/// decode a start section which is defined by a single function index.
pub fn decode_start_section(bits: BitArray) {
  common.decode_section(bits, 0x08, do_decode_start_section)
}

/// Decode an export in the export section. Each export is defined by a name,
/// a type, and then an index of the given type.
fn decode_export(bits: BitArray) {
  use #(name, rest) <- result.try(common.decode_string(bits))
  case rest {
    // type 0 is a function export
    <<0, rest:bits>> -> {
      use #(func_idx, rest) <- result.map(decode_func_idx(rest))
      #(FuncExport(name, func_idx), rest)
    }
    // type 1 is a table export
    <<1, rest:bits>> -> {
      use #(table_idx, rest) <- result.map(decode_table_idx(rest))
      #(TableExport(name, table_idx), rest)
    }
    // type 2 is a memory export
    <<2, rest:bits>> -> {
      use #(mem_idx, rest) <- result.map(decode_mem_idx(rest))
      #(MemExport(name, mem_idx), rest)
    }
    // type 3 is a global export
    <<3, rest:bits>> -> {
      use #(global_idx, rest) <- result.map(decode_global_idx(rest))
      #(GlobalExport(name, global_idx), rest)
    }
    _ -> Error("expected export")
  }
}

fn do_decode_export_section(bits: BitArray) {
  use #(exports, rest) <- result.map(common.decode_vec(bits, decode_export))
  #(ExportSection(exports), rest)
}

/// Decode an export section which is defined by a vector of exports.
pub fn decode_export_section(bits: BitArray) {
  common.decode_section(bits, 7, do_decode_export_section)
}

/// Decode a single global in the global section. Each global is defined by
/// a global type and an initializer expression.
fn decode_global(bits: BitArray) {
  use #(gt, rest) <- result.try(decode_global_type(bits))
  use #(expr, rest) <- result.map(decode_expression(rest))
  #(Global(gt, expr), rest)
}

fn do_decode_global_section(bits: BitArray) {
  use #(globals, rest) <- result.map(common.decode_vec(bits, decode_global))
  #(GlobalSection(globals), rest)
}

/// Decode a global section which is defined by a vector of globals.
pub fn decode_global_section(bits: BitArray) {
  common.decode_section(bits, 6, do_decode_global_section)
}

fn do_decode_memory_section(bits: BitArray) {
  use #(mems, rest) <- result.map(common.decode_vec(bits, decode_mem_type))
  #(MemorySection(mems), rest)
}

/// Decode a memory section which is defined by a vector of memory types. Typically,
/// a module has at most one memory type in this list.
pub fn decode_memory_section(bits: BitArray) {
  common.decode_section(bits, 5, do_decode_memory_section)
}

/// Decode a single table in the table section. Each table is defined by
/// table type, and an optional initializer expression.
fn decode_table(bits: BitArray) {
  case bits {
    // This sequence of bytes denotes the table type will be followed by an expression.
    <<0x40, 0x00, rest:bits>> -> {
      use #(tt, rest) <- result.try(decode_table_type(rest))
      use #(expr, rest) <- result.map(decode_expression(rest))
      #(Table(tt, Some(expr)), rest)
    }
    _ -> {
      use #(tt, rest) <- result.map(decode_table_type(bits))
      #(Table(tt, None), rest)
    }
  }
}

fn do_decode_table_section(bits: BitArray) {
  use #(types, rest) <- result.map(common.decode_vec(bits, decode_table))
  #(TableSection(types), rest)
}

/// Decode a table section which is defined by a vector of tables.
pub fn decode_table_section(bits: BitArray) {
  common.decode_section(bits, 4, do_decode_table_section)
}

/// The function section is defined by a vector of type indexes which should
/// point to a function composite type in the module's type section.
fn do_decode_function_section(bits: BitArray) {
  use #(indices, rest) <- result.map(common.decode_vec(bits, decode_type_idx))
  #(FunctionSection(indices), rest)
}

pub fn decode_function_section(bits: BitArray) {
  common.decode_section(bits, 3, do_decode_function_section)
}

/// Decode a single import in the import section. Each import is defined by
/// a module name, an import identifier, and an import type.
fn decode_import(bits: BitArray) {
  use #(mod, rest) <- result.try(common.decode_string(bits))
  use #(name, rest) <- result.try(common.decode_string(rest))
  case rest {
    // type 0 is a function import
    <<0x00, rest:bits>> -> {
      use #(type_idx, rest) <- result.map(decode_type_idx(rest))
      #(FuncImport(mod, name, type_idx), rest)
    }
    // type 1 is a table import
    <<0x01, rest:bits>> -> {
      use #(tt, rest) <- result.map(decode_table_type(rest))
      #(TableImport(mod, name, tt), rest)
    }
    // type 2 is a memory import
    <<0x02, rest:bits>> -> {
      use #(mt, rest) <- result.map(decode_mem_type(rest))
      #(MemImport(mod, name, mt), rest)
    }
    // type 3 is a global import
    <<0x03, rest:bits>> -> {
      use #(gt, rest) <- result.map(decode_global_type(rest))
      #(GlobalImport(mod, name, gt), rest)
    }
    _ -> Error("Invalid import")
  }
}

fn do_decode_import_section(bits: BitArray) {
  use #(imports, rest) <- result.map(common.decode_vec(bits, decode_import))
  #(ImportSection(imports), rest)
}

/// The import section is defined by a vector of module imports.
pub fn decode_import_section(bits: BitArray) {
  common.decode_section(bits, 2, do_decode_import_section)
}

/// The type section is defined by a vector of type definitions. Each of these types
/// are encoded as (iso-)recursive type groups, or single composite types that can be
/// refrenced from anywhere else in the module.
fn do_decode_type_section(bits: BitArray) {
  use #(types, left) <- result.map(common.decode_vec(bits, decode_rec_type))
  #(TypeSection(types), left)
}

/// Decode a type section which is defined by a vector of (iso-)recursive type definitions.
pub fn decode_type_section(bits: BitArray) {
  common.decode_section(bits, 1, do_decode_type_section)
}

/// Decode a set of consecutive custom sections.
pub fn decode_custom_sections(bits: BitArray) {
  do_decode_custom_sections(bits, [])
}

fn do_decode_custom_section(rest: BitArray) {
  use #(name, rest) <- result.try(common.decode_string(rest))
  use #(data, rest) <- result.map(common.decode_byte_vec(rest))
  #(CustomSection(name, data), rest)
}

/// Decode a single custom section. Each custom section is defined by a
/// name and a byte vector of data.
pub fn decode_custom_section(bits: BitArray) {
  common.decode_section(bits, 0x00, do_decode_custom_section)
}

/// This method is a helper function for emulating a while loop that continues
/// until the next wasm binary section isn't a custom one
fn do_decode_custom_sections(bits: BitArray, acc: List(CustomSection)) {
  case decode_custom_section(bits) {
    Ok(#(Some(section), rest)) ->
      do_decode_custom_sections(rest, [section, ..acc])
    _ -> Ok(#(Some(acc |> list.reverse), bits))
  }
}

/// Binary sections can exist anywhere in a module, and there is always an arbitrary
/// amount of them. This function simply encodes an array of sections until they are
/// exhausted.
pub fn encode_custom_sections(
  builder: BytesBuilder,
  sections: Option(List(CustomSection)),
) {
  case sections {
    Some(sections) -> list.try_fold(sections, builder, encode_custom_section)
    None -> Ok(builder)
  }
}

/// Encode a single custom section. This method writes the following byte patterns
/// to the builder:
///
/// 1. A single 0x00 byte denoting a custom section
/// 2. The byte length of the entire section: [byte_length: u32]
/// 3. The name of the custom section: [byte_length: u32] [string_bytes: utf8]
/// 4. The byte vector of the custom section: [byte_length: u32] [bytes: byte*]
pub fn encode_custom_section(builder: BytesBuilder, section: CustomSection) {
  use section_builder <- result.try(
    bytes_builder.new()
    |> common.encode_string(section.name),
  )
  use section_builder <- result.try(
    section_builder |> common.encode_byte_vec(section.data),
  )
  builder
  // This method calculates the byte length of the entire section, and writes
  // that byte length to the builder before appending the section payload.
  |> encode_section_from_builder(0, section_builder)
}

/// Encode a type section. This method writes the following byte patterns:
///
/// 1. A single 0x01 byte denoting a type section
/// 2. A vector of RecTypes which can be either a single type, or a group of
///    mutually recursive subtypes.
pub fn encode_type_section(builder: BytesBuilder, section: TypeSection) {
  use section_builder <- result.try(
    bytes_builder.new() |> common.encode_vec(section.types, encode_rec_type),
  )
  builder
  // This method calculates the byte length of the entire section, and writes
  // that byte length to the builder before appending the section payload.
  |> encode_section_from_builder(1, section_builder)
}

/// Encode a single import. This method writes the following byte patterns:
///
/// 1. A single 0x00 byte followed by a function import or
/// 2. A single 0x01 byte followed by a table import or
/// 3. A single 0x02 byte followed by a memory import or
/// 4. A single 0x03 byte followed by a global import
pub fn encode_import(builder: BytesBuilder, import_: Import) {
  case import_ {
    // [0x00] [module_name_length: u32] [module_name: string] ..
    // [func_name_length: u32] [func_name: string] [type_idx: TypeIDX]
    FuncImport(mod, name, type_idx) -> {
      use builder <- result.try(builder |> common.encode_string(mod))
      use builder <- result.try(builder |> common.encode_string(name))
      builder
      |> bytes_builder.append(<<0x00>>)
      |> encode_type_idx(type_idx)
    }
    TableImport(mod, name, table_type) -> {
      use builder <- result.try(builder |> common.encode_string(mod))
      use builder <- result.try(builder |> common.encode_string(name))
      builder
      |> bytes_builder.append(<<0x01>>)
      // This table type must match the type of the table imnported
      |> encode_table_type(table_type)
    }
    MemImport(mod, name, mem_type) -> {
      use builder <- result.try(builder |> common.encode_string(mod))
      use builder <- result.try(builder |> common.encode_string(name))
      builder
      |> bytes_builder.append(<<0x02>>)
      // This memory type must match the type of the memory imnported
      |> encode_mem_type(mem_type)
    }
    GlobalImport(mod, name, global_type) -> {
      use builder <- result.try(builder |> common.encode_string(mod))
      use builder <- result.try(builder |> common.encode_string(name))
      builder
      |> bytes_builder.append(<<0x03>>)
      // This global type must match the type of the global imnported
      |> encode_global_type(global_type)
    }
  }
}

/// This type index points to the n-th type in the module's type section
/// [0x01] [module_name_length: u32] [module_name: string] ..
/// [table_name_length: u32] [table_name: string] [table_type: TableType]
/// [0x02] [module_name_length: u32] [module_name: string] ..
/// [mem_name_length: u32] [mem_name: string] [mem_type: MemType]
/// [0x03] [module_name_length: u32] [module_name: string] ..
/// [global_name_length: u32] [global_name: string] [global_type: GlobalType]
/// Encode an import section. This method writes the following byte patterns:
///
/// 1. A single 0x02 byte denoting an import section
/// 2. The byte length of the following section payload
/// 3. A vector of imports: [import_length: u32] [imports: Import*]
pub fn encode_import_section(builder: BytesBuilder, section: ImportSection) {
  use section_builder <- result.try(
    bytes_builder.new() |> common.encode_vec(section.imports, encode_import),
  )
  builder
  |> encode_section_from_builder(2, section_builder)
}

/// Encode a function section. This method writes the following byte patterns:
///
/// 1. A single 0x03 byte denoting a function section
/// 2. The byte length of the following section payload
/// 3. A vector of type indices: [function_length: u32] [type_indices: TypeIDX*]
pub fn encode_function_section(
  builder: BytesBuilder,
  function_section: FunctionSection,
) {
  use section_builder <- result.try(
    bytes_builder.new()
    // Each type index points to the n-th type in the module's type section
    |> common.encode_vec(function_section.funcs, encode_type_idx),
  )

  builder
  |> encode_section_from_builder(3, section_builder)
}

/// Encode a single table. This method writes the following byte patterns:
///
/// 1. A single table type: [table_type: TableType] or...
/// 2. Two bytes denoting a table with an initializer expression: [0x40, 0x00] [expr: Expression]
pub fn encode_table(builder: BytesBuilder, table: Table) {
  case table {
    Table(type_, None) -> builder |> encode_table_type(type_)
    Table(type_, Some(expr)) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x40, 0x00>>)
        |> encode_table_type(type_),
      )
      builder |> encode_expression(expr)
    }
  }
}

/// Encode a table section. This method writes the following byte patterns:
///
/// 1. A single 0x04 byte denoting a table section
/// 2. The byte length of the following section payload
/// 3. A vector of tables: [table_length: u32] [tables: Table*]
pub fn encode_table_section(builder: BytesBuilder, table_section: TableSection) {
  use section_builder <- result.try(
    bytes_builder.new()
    |> common.encode_vec(table_section.tables, encode_table),
  )
  builder
  |> encode_section_from_builder(4, section_builder)
}

/// Encode a memory section. This is usually a vector of memory types with
/// a single element. It encodes the following byte patterns:
///
/// 1. A single 0x05 byte denoting a memory section
/// 2. The byte length of the following section payload
/// 3. A vector of memory types: [memory_length: u32] [memory_types: MemType*]
pub fn encode_memory_section(
  builder: BytesBuilder,
  memory_section: MemorySection,
) {
  use section_builder <- result.try(
    bytes_builder.new()
    |> common.encode_vec(memory_section.mts, encode_mem_type),
  )

  builder
  |> encode_section_from_builder(5, section_builder)
}

/// Encode a single global. This method writes the following byte patterns:
///
/// [global_type: GlobalType] [init: Expression]
///
/// Note: The expression result type must match the global type specified.
pub fn encode_global(builder: BytesBuilder, global: Global) {
  use builder <- result.try(builder |> encode_global_type(global.type_))
  builder |> encode_expression(global.init)
}

/// Encode a global section. This method writes the following byte patterns:
///
/// 1. A single 0x06 byte denoting a global section
/// 2. The byte length of the following section payload
/// 3. A vector of globals: [global_length: u32] [globals: Global*]
pub fn encode_global_section(
  builder: BytesBuilder,
  global_section: GlobalSection,
) {
  use section_builder <- result.try(
    bytes_builder.new()
    |> common.encode_vec(global_section.globals, encode_global),
  )
  builder
  |> encode_section_from_builder(6, section_builder)
}

/// Encode a single export. Exports define the module contents that can be used externally
/// by the web assembly host.
///
/// Exports can be encoded in the following ways:
///
/// 1. [name_length: u32] [name: utf8] [0x00] [func_idx: FuncIDX] indicating a function export
/// 2. [name_length: u32] [name: utf8] [0x01] [table_idx: TableIDX] indicating a table export.
/// 3. [name_length: u32] [name: utf8] [0x02] [mem_idx: MemIDX] indicating a memory export.
/// 4. [name_length: u32] [name: utf8] [0x03] [global_idx: GlobalIDX] indicating a global export.
pub fn encode_export(builder: BytesBuilder, export_: Export) {
  use builder <- result.try(builder |> common.encode_string(export_.name))
  case export_ {
    //
    FuncExport(_, func_idx) ->
      builder
      |> bytes_builder.append(<<0x00>>)
      |> encode_func_idx(func_idx)
    TableExport(_, table_idx) ->
      builder
      |> bytes_builder.append(<<0x01>>)
      |> encode_table_idx(table_idx)
    MemExport(_, mem_idx) ->
      builder
      |> bytes_builder.append(<<0x02>>)
      |> encode_mem_idx(mem_idx)
    GlobalExport(_, global_idx) ->
      builder
      |> bytes_builder.append(<<0x03>>)
      |> encode_global_idx(global_idx)
  }
}

/// Encode an export section. This method writes the following byte patterns:
///
/// 1. A single 0x07 byte denoting an export section
/// 2. The byte length of the following section payload
/// 3. A vector of exports: [exports_length: u32] [exports: Export*]
pub fn encode_export_section(
  builder: BytesBuilder,
  export_section: ExportSection,
) {
  use section_builder <- result.try(
    bytes_builder.new()
    |> common.encode_vec(export_section.exports, encode_export),
  )
  builder
  |> encode_section_from_builder(7, section_builder)
}

/// Encode a start section. This method writes the following byte patterns:
///
/// 1. A single 0x08 byte denoting a start section
/// 2. The byte length of the following section payload which is a single u32
/// 3. The start function index as a u32
pub fn encode_start_section(builder: BytesBuilder, start_section: StartSection) {
  use section_builder <- result.try(
    bytes_builder.new() |> encode_func_idx(start_section.start),
  )
  builder
  |> encode_section_from_builder(8, section_builder)
}

/// Encode a single element segment. This method writes a byte pattern based
/// on the type of elements and how they are treated to the web assembly module.
///
/// For more information on how they are encoded, see the specification here:
/// https://webassembly.github.io/gc/core/binary/modules.html#element-section
pub fn encode_element_segment(builder: BytesBuilder, element: Elem) {
  let assert Ok(zero) = numbers.u32(0x00)
  let table_idx_zero = TableIDX(zero)

  case element {
    // Type: 0
    // this segment initializes the first table with the given function indexes at offset [Expr]
    // [Active with func idx] 0x00 Offset Expr, init:FuncIDX*
    ElemFuncs(
      HeapTypeRefType(FuncHeapType, False),
      init,
      ActiveElemMode(table_idx, offset),
    )
      if table_idx == table_idx_zero
    -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x00>>)
        |> encode_expression(offset),
      )
      builder |> common.encode_vec(init, encode_func_idx)
    }

    // Type: 1
    // this segment can only be used with a `table.init` instruction with an array of function indexes
    // [Passive with func idx] 0x01 0x00 init:FuncIDX*
    ElemFuncs(HeapTypeRefType(FuncHeapType, False), init, PassiveElemMode) ->
      builder
      |> bytes_builder.append(<<0x01, 0x00>>)
      |> common.encode_vec(init, encode_func_idx)

    // Note: because it's implied table index is 0, variant 4 must be tried as a special case first
    // Type: 4
    // this segment initializes the first table with the given expressions at offset [Expr]
    // [Active with function expressions] 0x04 Offset Expr, init:Expr*
    ElemExpressions(
      HeapTypeRefType(FuncHeapType, False),
      init,
      ActiveElemMode(table_idx, offset),
    )
      if table_idx == table_idx_zero
    -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x04>>)
        |> encode_expression(offset),
      )
      builder |> common.encode_vec(init, encode_expression)
    }

    // Type: 2
    // this segment initializes the table at index [x] with the given function indexes at offset [Expr]
    // [Active with func idx] 0x02 x:TableIDX offset:Expr 0x00 init:FuncIDX*
    ElemFuncs(
      HeapTypeRefType(FuncHeapType, False),
      init,
      ActiveElemMode(table_idx, offset),
    ) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x02>>)
        |> encode_table_idx(table_idx),
      )
      use builder <- result.try(builder |> encode_expression(offset))
      builder
      |> bytes_builder.append(<<0x00>>)
      |> common.encode_vec(init, encode_func_idx)
    }

    // Type: 3
    // this segment pre-initializes an array of function indexes for future use
    // [Declarative with func idx] 0x03 0x00 init:FuncIDX*
    ElemFuncs(HeapTypeRefType(FuncHeapType, False), init, DeclarativeElemMode) ->
      builder
      |> bytes_builder.append(<<0x03, 0x00>>)
      |> common.encode_vec(init, encode_func_idx)

    // Type: 5
    // this segment can only be used with a `table.init` instruction with an array of expressions of
    // the given reftype
    // [Passive with reftype expressions] 0x05 rt:Reftype init:Expr*
    ElemExpressions(type_, init, PassiveElemMode) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x05>>)
        |> encode_ref_type(type_),
      )
      builder |> common.encode_vec(init, encode_expression)
    }

    // Type: 6
    // this segment initializes the given table with the given expressions of the given reftype at
    // the provided offset
    // [Active with reftype expressions] 0x06 x:TableIDX offset:Expr rt:Reftype init:Expr*
    ElemExpressions(type_, init, ActiveElemMode(table_idx, offset)) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x06>>)
        |> encode_table_idx(table_idx),
      )
      use builder <- result.try(builder |> encode_expression(offset))
      use builder <- result.try(builder |> encode_ref_type(type_))
      builder |> common.encode_vec(init, encode_expression)
    }

    // Type: 7
    // this segment pre-initializes an array of expressions of the given reftype for future use
    // [Declarative with reftype expressions] 0x07 rt:Reftype init:Expr*
    ElemExpressions(type_, init, DeclarativeElemMode) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x07>>)
        |> encode_ref_type(type_),
      )
      builder |> common.encode_vec(init, encode_expression)
    }

    _ -> Error("invalid element segment type")
  }
}

/// Encodes an element section. This method writes the following byte patterns:
///
/// 1. A 0x09 byte, indicating the start of an element section
/// 2. The byte length of the section as a u32
/// 3. A vector of encoded element segments
///
/// For more information, please see:
/// https://webassembly.github.io/gc/core/binary/modules.html#element-section
pub fn encode_element_section(
  builder: BytesBuilder,
  element_section: ElementSection,
) {
  use section_builder <- result.try(
    bytes_builder.new()
    |> common.encode_vec(element_section.elems, encode_element_segment),
  )
  builder
  |> encode_section_from_builder(9, section_builder)
}

/// Encode a code segment, also known as a function body. This method writes the following
/// byte patterns:
///
/// 1. The byte length of the segment as a u32
/// 2. A vector of encoded locals
/// 3. An expression containing the function body, terminated by a single 0x0B (end) byte.
pub fn encode_code_segment(builder: BytesBuilder, code: Code) {
  use code_builder <- result.try(
    bytes_builder.new()
    |> common.encode_vec(code.locals, encode_locals),
  )
  use code_builder <- result.try(code_builder |> encode_expression(code.body))
  use size <- result.map(code_builder |> bytes_builder.byte_size |> numbers.u32)
  builder
  |> encode_u32(size)
  |> bytes_builder.append_builder(code_builder)
}

/// Encodes a code section. This method writes the following byte patterns:
///
/// 1. A 0x0A (10) byte, indicating the start of a code section
/// 2. The byte length of the section as a u32
/// 3. A vector of encoded code segments
pub fn encode_code_section(builder: BytesBuilder, code_section: CodeSection) {
  use section_builder <- result.try(
    bytes_builder.new()
    |> common.encode_vec(code_section.codes, encode_code_segment),
  )
  builder
  |> encode_section_from_builder(10, section_builder)
}

/// Encodes a single data segment. There are three types of memory segments, and
/// each of them is encoded in a different way. For more information, please see:
/// https://webassembly.github.io/gc/core/binary/modules.html#data-section
fn encode_data_segment(builder: BytesBuilder, data: Data) {
  let assert Ok(index_zero) = numbers.u32(0)
  let index_zero = structure_types.MemIDX(index_zero)

  case data {
    // Type 0:is an active data segment that populates the first memory in the module
    // when the module is instantiated. It is encoded with the following pattern:
    //
    // 1. A 0x00 byte, indicating the start of an active data segment
    // 2. A constant expression that defines the offset of the written data
    // 3. The byte length of the data segment as a u32
    // 4. The data itself
    ActiveData(mem, offset, init) if mem == index_zero -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x00>>)
        |> encode_expression(offset),
      )
      builder |> common.encode_byte_vec(init)
    }

    // Type 1: a passive data segment that can be used later with instructions like
    // table.init. It is encoded with the following pattern:
    //
    // 1. A 0x01 byte, indicating the start of a passive data segment
    // 2. The byte length of the data segment as a u32
    // 3. The data itself
    PassiveData(init) -> {
      builder
      |> bytes_builder.append(<<0x01>>)
      |> common.encode_byte_vec(init)
    }

    // Type 2: an active data segment that populates the given memory when the module
    // is instantiated. It is encoded with the following pattern:
    //
    // 1. A 0x02 byte, indicating the start of an active data segment with a memory index
    // 2. A memory index that defines the memory to write to
    // 3. A constant expression that defines the offset of the written data
    // 4. The byte length of the data segment as a u32
    // 5. The data itself
    ActiveData(mem, offset, init) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x02>>)
        |> encode_mem_idx(mem),
      )
      use builder <- result.try(builder |> encode_expression(offset))
      builder |> common.encode_byte_vec(init)
    }
  }
}

/// Encode a data section. This method writes the following byte patterns:
///
/// 1. A 0x0B (11) byte, indicating the start of a data section
/// 2. The byte length of the section as a u32
/// 3. A vector of encoded data segments: [data_section_count: u32] [data_segments: Data*]
///
pub fn encode_data_section(builder: BytesBuilder, data_section: DataSection) {
  use section_builder <- result.try(
    bytes_builder.new()
    |> common.encode_vec(data_section.data, encode_data_segment),
  )

  builder
  |> encode_section_from_builder(11, section_builder)
}

/// Encodes a data count section. This method writes the following byte patterns:
///
/// 1. A 0x0C (12) byte, indicating the start of a data count section
/// 2. The byte length of the section as a u32
/// 3. The number of data segments in the module as a u32
pub fn encode_data_count_section(
  builder: BytesBuilder,
  data_count_section: DataCountSection,
) {
  let data_count =
    bytes_builder.new()
    |> encode_u32(data_count_section.count)
  let size = bytes_builder.byte_size(data_count)

  use size <- result.map(numbers.u32(size))

  builder
  |> bytes_builder.append(<<0x0C>>)
  |> encode_u32(size)
  |> bytes_builder.append_builder(data_count)
}
