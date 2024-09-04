import builder/expression
import builder/instructions/i32
import builder/instructions/ref
import gleam/bit_array
import gleam/bytes_builder.{type BytesBuilder}
import gleam/io
import gleam/option.{None, Some}
import gleeunit/should
import internal/binary/common
import internal/binary/modules
import internal/binary/types
import internal/binary/values
import internal/finger_tree
import internal/structure/modules as structure_modules
import internal/structure/numbers
import internal/structure/types.{type FuncIDX, Expr, RefFunc} as structure_types

pub fn func_idx_to_expr(expr: FuncIDX) {
  Expr([RefFunc(expr)] |> finger_tree.from_list)
}

fn should_equal_helper(val: Result(BytesBuilder, String), expected: BitArray) {
  let val =
    val
    |> should.be_ok
    |> bytes_builder.to_bit_array

  case val == expected {
    True -> Nil
    _ -> {
      io.debug(#(
        "actual",
        val |> bit_array.inspect,
        "expected",
        expected |> bit_array.inspect,
      ))
      panic as "Values were not equal"
    }
  }
}

pub fn encode_string_test() {
  bytes_builder.new()
  |> common.encode_string("Foo Bar Baz")
  |> should_equal_helper(<<11, 70, 111, 111, 32, 66, 97, 114, 32, 66, 97, 122>>)
}

pub fn encode_val_type_test() {
  bytes_builder.new()
  |> types.encode_val_type(structure_types.I32ValType)
  |> should_equal_helper(<<0x7F>>)
  bytes_builder.new()
  |> types.encode_val_type(structure_types.I64ValType)
  |> should_equal_helper(<<0x7E>>)
  bytes_builder.new()
  |> types.encode_val_type(structure_types.F32ValType)
  |> should_equal_helper(<<0x7D>>)
  bytes_builder.new()
  |> types.encode_val_type(structure_types.F64ValType)
  |> should_equal_helper(<<0x7C>>)
  bytes_builder.new()
  |> types.encode_val_type(structure_types.V128ValType)
  |> should_equal_helper(<<0x7B>>)
}

pub fn encode_abstract_heap_type_test() {
  bytes_builder.new()
  |> types.encode_heap_type(structure_types.NoFuncHeapType)
  |> should_equal_helper(<<0x73>>)
  bytes_builder.new()
  |> types.encode_heap_type(structure_types.NoExternHeapType)
  |> should_equal_helper(<<0x72>>)
  bytes_builder.new()
  |> types.encode_heap_type(structure_types.NoneHeapType)
  |> should_equal_helper(<<0x71>>)
  bytes_builder.new()
  |> types.encode_heap_type(structure_types.FuncHeapType)
  |> should_equal_helper(<<0x70>>)
  bytes_builder.new()
  |> types.encode_heap_type(structure_types.ExternHeapType)
  |> should_equal_helper(<<0x6F>>)
  // any, eq, i31
  bytes_builder.new()
  |> types.encode_heap_type(structure_types.AnyHeapType)
  |> should_equal_helper(<<0x6E>>)
  bytes_builder.new()
  |> types.encode_heap_type(structure_types.EqHeapType)
  |> should_equal_helper(<<0x6D>>)
  bytes_builder.new()
  |> types.encode_heap_type(structure_types.I31HeapType)
  |> should_equal_helper(<<0x6C>>)
  // struct, array
  bytes_builder.new()
  |> types.encode_heap_type(structure_types.StructHeapType)
  |> should_equal_helper(<<0x6B>>)
  bytes_builder.new()
  |> types.encode_heap_type(structure_types.ArrayHeapType)
  |> should_equal_helper(<<0x6A>>)
}

pub fn encode_concrete_heap_type_test() {
  let assert Ok(u32_value) = numbers.u32(10)
  bytes_builder.new()
  |> types.encode_heap_type(
    structure_types.ConcreteHeapType(structure_types.TypeIDX(u32_value)),
  )
  |> should_equal_helper(<<0x0A>>)
}

pub fn encode_ref_type_test() {
  bytes_builder.new()
  |> types.encode_ref_type(structure_types.NoFuncRefType)
  |> should_equal_helper(<<0x73>>)

  bytes_builder.new()
  |> types.encode_ref_type(structure_types.NoExternRefType)
  |> should_equal_helper(<<0x72>>)

  bytes_builder.new()
  |> types.encode_ref_type(structure_types.NoneRefType)
  |> should_equal_helper(<<0x71>>)

  bytes_builder.new()
  |> types.encode_ref_type(structure_types.FuncRefType)
  |> should_equal_helper(<<0x70>>)

  bytes_builder.new()
  |> types.encode_ref_type(structure_types.ExternRefType)
  |> should_equal_helper(<<0x6F>>)

  bytes_builder.new()
  |> types.encode_ref_type(structure_types.AnyRefType)
  |> should_equal_helper(<<0x6E>>)

  bytes_builder.new()
  |> types.encode_ref_type(structure_types.EqRefType)
  |> should_equal_helper(<<0x6D>>)

  bytes_builder.new()
  |> types.encode_ref_type(structure_types.I31RefType)
  |> should_equal_helper(<<0x6C>>)

  bytes_builder.new()
  |> types.encode_ref_type(structure_types.StructRefType)
  |> should_equal_helper(<<0x6B>>)

  bytes_builder.new()
  |> types.encode_ref_type(structure_types.ArrayRefType)
  |> should_equal_helper(<<0x6A>>)
}

pub fn encode_heap_type_ref_type_test() {
  let assert Ok(u32_value) = numbers.u32(10)

  bytes_builder.new()
  |> types.encode_ref_type(structure_types.HeapTypeRefType(
    structure_types.StructHeapType,
    True,
  ))
  |> should_equal_helper(<<0x6B>>)

  bytes_builder.new()
  |> types.encode_ref_type(structure_types.HeapTypeRefType(
    structure_types.ConcreteHeapType(structure_types.TypeIDX(u32_value)),
    False,
  ))
  |> should_equal_helper(<<0x64, 10>>)
  bytes_builder.new()
  |> types.encode_ref_type(structure_types.HeapTypeRefType(
    structure_types.ConcreteHeapType(structure_types.TypeIDX(u32_value)),
    True,
  ))
  |> should_equal_helper(<<0x63, 10>>)
}

pub fn encode_result_type_test() {
  let empty = finger_tree.new()
  let four =
    finger_tree.from_list([
      structure_types.I32ValType,
      structure_types.I64ValType,
      structure_types.F32ValType,
      structure_types.F64ValType,
    ])

  bytes_builder.new()
  |> types.encode_result_type(empty)
  |> should_equal_helper(<<0>>)

  bytes_builder.new()
  |> types.encode_result_type(four)
  |> should_equal_helper(<<4, 0x7F, 0x7E, 0x7D, 0x7C>>)
}

pub fn encode_array_type_test() {
  bytes_builder.new()
  |> types.encode_array_type(
    structure_types.ArrayType(structure_types.FieldType(
      structure_types.ValTypeStorageType(structure_types.I32ValType),
      structure_types.Const,
    )),
  )
  |> should_equal_helper(<<0x7F, 0x00>>)
  bytes_builder.new()
  |> types.encode_array_type(
    structure_types.ArrayType(structure_types.FieldType(
      structure_types.I8StorageType,
      structure_types.Const,
    )),
  )
  |> should_equal_helper(<<0x78, 0x00>>)
  bytes_builder.new()
  |> types.encode_array_type(
    structure_types.ArrayType(structure_types.FieldType(
      structure_types.I16StorageType,
      structure_types.Const,
    )),
  )
  |> should_equal_helper(<<0x77, 0x00>>)
  bytes_builder.new()
  |> types.encode_array_type(
    structure_types.ArrayType(structure_types.FieldType(
      structure_types.ValTypeStorageType(structure_types.I32ValType),
      structure_types.Var,
    )),
  )
  |> should_equal_helper(<<0x7F, 0x01>>)
  bytes_builder.new()
  |> types.encode_array_type(
    structure_types.ArrayType(structure_types.FieldType(
      structure_types.I8StorageType,
      structure_types.Var,
    )),
  )
  |> should_equal_helper(<<0x78, 0x01>>)
  bytes_builder.new()
  |> types.encode_array_type(
    structure_types.ArrayType(structure_types.FieldType(
      structure_types.I16StorageType,
      structure_types.Var,
    )),
  )
  |> should_equal_helper(<<0x77, 0x01>>)
}

pub fn encode_struct_type_test() {
  bytes_builder.new()
  |> types.encode_struct_type(structure_types.StructType(finger_tree.new()))
  |> should_equal_helper(<<0>>)

  bytes_builder.new()
  |> types.encode_struct_type(
    structure_types.StructType(
      finger_tree.from_list([
        structure_types.FieldType(
          structure_types.ValTypeStorageType(structure_types.I32ValType),
          structure_types.Const,
        ),
        structure_types.FieldType(
          structure_types.I8StorageType,
          structure_types.Const,
        ),
        structure_types.FieldType(
          structure_types.I16StorageType,
          structure_types.Const,
        ),
        structure_types.FieldType(
          structure_types.ValTypeStorageType(structure_types.I32ValType),
          structure_types.Var,
        ),
        structure_types.FieldType(
          structure_types.I8StorageType,
          structure_types.Var,
        ),
        structure_types.FieldType(
          structure_types.I16StorageType,
          structure_types.Var,
        ),
      ]),
    ),
  )
  |> should_equal_helper(<<
    6, 0x7F, 0x00, 0x78, 0x00, 0x77, 0x00, 0x7F, 0x01, 0x78, 0x01, 0x77, 0x01,
  >>)
}

pub fn encode_composite_type_test() {
  bytes_builder.new()
  |> types.encode_composite_type(
    structure_types.FuncCompositeType(structure_types.FuncType(
      finger_tree.new(),
      finger_tree.new(),
    )),
  )
  |> should_equal_helper(<<0x60, 0x00, 0x00>>)

  bytes_builder.new()
  |> types.encode_composite_type(
    structure_types.StructCompositeType(
      structure_types.StructType(
        finger_tree.from_list([
          structure_types.FieldType(
            structure_types.ValTypeStorageType(structure_types.I32ValType),
            structure_types.Const,
          ),
          structure_types.FieldType(
            structure_types.I8StorageType,
            structure_types.Const,
          ),
          structure_types.FieldType(
            structure_types.I16StorageType,
            structure_types.Const,
          ),
          structure_types.FieldType(
            structure_types.ValTypeStorageType(structure_types.I32ValType),
            structure_types.Var,
          ),
          structure_types.FieldType(
            structure_types.I8StorageType,
            structure_types.Var,
          ),
          structure_types.FieldType(
            structure_types.I16StorageType,
            structure_types.Var,
          ),
        ]),
      ),
    ),
  )
  |> should_equal_helper(<<
    0x5F, 0x06, 0x7F, 0x00, 0x78, 0x00, 0x77, 0x00, 0x7F, 0x01, 0x78, 0x01, 0x77,
    0x01,
  >>)

  bytes_builder.new()
  |> types.encode_composite_type(
    structure_types.ArrayCompositeType(
      structure_types.ArrayType(structure_types.FieldType(
        structure_types.ValTypeStorageType(structure_types.I32ValType),
        structure_types.Const,
      )),
    ),
  )
  |> should_equal_helper(<<0x5E, 0x7F, 0x00>>)

  bytes_builder.new()
  |> types.encode_composite_type(
    structure_types.ArrayCompositeType(
      structure_types.ArrayType(structure_types.FieldType(
        structure_types.I16StorageType,
        structure_types.Var,
      )),
    ),
  )
  |> should_equal_helper(<<0x5E, 0x77, 0x01>>)
}

pub fn encode_rec_type_test() {
  let subtype_one =
    structure_types.SubType(
      True,
      finger_tree.new(),
      structure_types.ArrayCompositeType(
        structure_types.ArrayType(structure_types.FieldType(
          structure_types.ValTypeStorageType(structure_types.I32ValType),
          structure_types.Const,
        )),
      ),
    )

  bytes_builder.new()
  |> types.encode_rec_type(
    structure_types.RecType(finger_tree.from_list([subtype_one])),
  )
  |> should_equal_helper(<<0x5E, 0x7F, 0x00>>)

  let assert Ok(idx_one) = numbers.u32(1)
  let assert Ok(idx_two) = numbers.u32(2)
  let subtype_two =
    structure_types.SubType(
      False,
      finger_tree.from_list([
        structure_types.TypeIDX(idx_one),
        structure_types.TypeIDX(idx_two),
      ]),
      structure_types.StructCompositeType(
        structure_types.StructType(
          finger_tree.from_list([
            structure_types.FieldType(
              structure_types.ValTypeStorageType(structure_types.I32ValType),
              structure_types.Const,
            ),
          ]),
        ),
      ),
    )

  bytes_builder.new()
  |> types.encode_rec_type(
    structure_types.RecType(finger_tree.from_list([subtype_two])),
  )
  |> should_equal_helper(<<0x50, 0x02, 0x01, 0x02, 0x5F, 0x01, 0x7F, 0x00>>)

  bytes_builder.new()
  |> types.encode_rec_type(
    structure_types.RecType(finger_tree.from_list([subtype_one, subtype_two])),
  )
  |> should_equal_helper(<<
    0x4E, 0x02, 0x5E, 0x7F, 0x00, 0x50, 0x02, 0x01, 0x02, 0x5F, 0x01, 0x7F, 0x00,
  >>)
}

pub fn custom_section_test() {
  let custom_section =
    structure_modules.CustomSection("Custom Section!", <<0x01, 0x02, 0x03>>)

  // "Custom Section!" -> length 15
  let name_length = 15
  let name_bits = <<
    0x43, 0x75, 0x73, 0x74, 0x6f, 0x6d, 0x20, 0x53, 0x65, 0x63, 0x74, 0x69, 0x6f,
    0x6e, 0x21,
  >>

  let payload_length = 3
  let payload = <<0x01, 0x02, 0x03>>

  let section_length = 1 + name_length + 1 + payload_length

  bytes_builder.new()
  |> modules.encode_custom_section(custom_section)
  |> should_equal_helper(<<
    0x00,
    section_length,
    name_length,
    name_bits:bits,
    payload_length,
    payload:bits,
  >>)
}

pub fn type_section_test() {
  let empty_type_section = structure_modules.TypeSection(finger_tree.new())

  bytes_builder.new()
  |> modules.encode_type_section(empty_type_section)
  |> should_equal_helper(<<0x01, 0x01, 0x00>>)

  let array_type_example =
    structure_types.RecType(
      finger_tree.from_list([
        structure_types.SubType(
          True,
          finger_tree.new(),
          structure_types.ArrayCompositeType(
            structure_types.ArrayType(structure_types.FieldType(
              structure_types.ValTypeStorageType(structure_types.I32ValType),
              structure_types.Const,
            )),
          ),
        ),
      ]),
    )
  let array_example_type = <<0x5E, 0x7F, 0x00>>
  let array_example_length = <<0x01>>

  let example_type_section_length = <<0x04>>
  let example_type_section =
    structure_modules.TypeSection(finger_tree.from_list([array_type_example]))

  bytes_builder.new()
  |> modules.encode_type_section(example_type_section)
  |> should_equal_helper(<<
    0x01,
    example_type_section_length:bits,
    array_example_length:bits,
    array_example_type:bits,
  >>)
}

pub fn import_section_test() {
  let empty_import_section = structure_modules.ImportSection(finger_tree.new())

  bytes_builder.new()
  |> modules.encode_import_section(empty_import_section)
  |> should_equal_helper(<<0x02, 0x01, 0x00>>)

  let assert Ok(type_idx_zero) = numbers.u32(0)
  let type_idx_zero = structure_types.TypeIDX(type_idx_zero)

  let func_import_example =
    structure_types.FuncImport("module", "name", type_idx_zero)

  let module_name = bit_array.from_string("module")
  let module_byte_length = <<0x06>>
  let func_name = bit_array.from_string("name")
  let func_name_byte_length = <<0x04>>

  let func_import_idx = <<0x00>>
  let func_import_desc = <<0x00, func_import_idx:bits>>

  let func_import_bytes = <<
    0x01,
    // one func
    module_byte_length:bits,
    module_name:bits,
    func_name_byte_length:bits,
    func_name:bits,
    func_import_desc:bits,
  >>

  let func_import_bytes_length = bit_array.byte_size(func_import_bytes)

  let example_import_section =
    structure_modules.ImportSection(
      finger_tree.from_list([func_import_example]),
    )

  bytes_builder.new()
  |> modules.encode_import_section(example_import_section)
  |> should_equal_helper(<<
    0x02,
    func_import_bytes_length,
    func_import_bytes:bits,
  >>)
}

pub fn function_section_test() {
  let empty_function_section =
    structure_modules.FunctionSection(finger_tree.new())

  bytes_builder.new()
  |> modules.encode_function_section(empty_function_section)
  |> should_equal_helper(<<0x03, 0x01, 0x00>>)

  let assert Ok(indexes) =
    [1, 2, 3, 4]
    |> finger_tree.from_list
    |> finger_tree.try_map(numbers.u32)

  let indexes = indexes |> finger_tree.map(structure_types.TypeIDX)

  let function_section = structure_modules.FunctionSection(indexes)

  bytes_builder.new()
  |> modules.encode_function_section(function_section)
  |> should_equal_helper(<<0x03, 0x05, 0x04, 0x01, 0x02, 0x03, 0x04>>)
}

pub fn table_section_test() {
  let empty_table_section = structure_modules.TableSection(finger_tree.new())

  bytes_builder.new()
  |> modules.encode_table_section(empty_table_section)
  |> should_equal_helper(<<0x04, 0x01, 0x00>>)

  let assert Ok(zero) = numbers.u32(0)
  let limits = structure_types.Limits(zero, None)

  let example_table =
    structure_types.Table(
      structure_types.TableType(structure_types.ArrayRefType, limits),
      None,
    )

  let section_length = <<0x04>>
  let table_count = <<0x01>>
  let table = <<0x6A, 0x00, 0x00>>

  bytes_builder.new()
  |> modules.encode_table_section(
    structure_modules.TableSection(finger_tree.from_list([example_table])),
  )
  |> should_equal_helper(<<
    0x04,
    section_length:bits,
    table_count:bits,
    table:bits,
  >>)

  let expr =
    expression.new()
    |> ref.null(structure_types.ArrayHeapType)
    // 
    |> expression.end_unwrap()

  let example_table_init =
    structure_types.Table(
      structure_types.TableType(structure_types.ArrayRefType, limits),
      Some(expr),
    )

  let example_table_init_bytes = <<
    0x40, 0x00, 0x6A, 0x00, 0x00, 0xD0, 0x6A, 0x0B,
  >>

  bytes_builder.new()
  |> modules.encode_table_section(
    structure_modules.TableSection(finger_tree.from_list([example_table_init])),
  )
  |> should_equal_helper(<<0x04, 0x09, 0x01, example_table_init_bytes:bits>>)
}

pub fn memory_section_test() {
  let empty_memory_section = structure_modules.MemorySection(finger_tree.new())

  bytes_builder.new()
  |> modules.encode_memory_section(empty_memory_section)
  |> should_equal_helper(<<0x05, 0x01, 0x00>>)

  let assert Ok(zero) = numbers.u32(0)
  let limits = structure_types.Limits(zero, None)

  let example_memory = structure_types.MemType(limits)

  let section_length = <<0x03>>
  let memory_count = <<0x01>>
  let memory_type = <<0x00, 0x00>>

  bytes_builder.new()
  |> modules.encode_memory_section(
    structure_modules.MemorySection(finger_tree.from_list([example_memory])),
  )
  |> should_equal_helper(<<
    0x05,
    section_length:bits,
    memory_count:bits,
    memory_type:bits,
  >>)
}

pub fn global_section_test() {
  let empty_global_section = structure_modules.GlobalSection(finger_tree.new())

  bytes_builder.new()
  |> modules.encode_global_section(empty_global_section)
  |> should_equal_helper(<<0x06, 0x01, 0x00>>)

  let assert Ok(fourty_two) = numbers.i32(0x42)

  let gt =
    structure_types.GlobalType(structure_types.I32ValType, structure_types.Var)

  let example_global =
    structure_types.Global(
      gt,
      expression.new()
        |> i32.const_(fourty_two)
        |> expression.end_unwrap(),
    )

  let global_section =
    structure_modules.GlobalSection(finger_tree.from_list([example_global]))
  let global_section_bytes = <<
    0x06, 0x07, 0x01, 0x7F, 0x01, 0x41, 0xC2, 0x00, 0x0B,
  >>
  bytes_builder.new()
  |> modules.encode_global_section(global_section)
  |> should_equal_helper(global_section_bytes)
}

pub fn export_section_test() {
  let empty_export_section = structure_modules.ExportSection(finger_tree.new())

  bytes_builder.new()
  |> modules.encode_export_section(empty_export_section)
  |> should_equal_helper(<<0x07, 0x01, 0x00>>)

  let assert Ok(one) = numbers.u32(1)
  let assert Ok(two) = numbers.u32(2)
  let assert Ok(three) = numbers.u32(3)
  let assert Ok(four) = numbers.u32(4)

  let func_export =
    structure_types.FuncExport("func", structure_types.FuncIDX(one))
  let table_export =
    structure_types.TableExport("table", structure_types.TableIDX(two))
  let mem_export =
    structure_types.MemExport("mem", structure_types.MemIDX(three))
  let global_export =
    structure_types.GlobalExport("global", structure_types.GlobalIDX(four))

  let export_section =
    structure_modules.ExportSection(
      finger_tree.from_list([
        func_export,
        table_export,
        mem_export,
        global_export,
      ]),
    )
  let export_section_bytes = <<
    0x07, 31,
    // placeholder
    0x04,
    // 1
    0x04, "func":utf8,
    // 5
    0x00, 0x01,
    // 2

    0x05, "table":utf8,
    // 6
    0x01, 0x02,
    // 2

    0x03, "mem":utf8,
    // 4
    0x02, 0x03,
    // 2

    0x06, "global":utf8,
    // 7
    0x03, 0x04,
    // 2
  >>

  bytes_builder.new()
  |> modules.encode_export_section(export_section)
  |> should_equal_helper(export_section_bytes)
}

pub fn start_section_test() {
  let assert Ok(fourty_two) = numbers.u32(42)
  let start_section =
    structure_modules.StartSection(structure_types.FuncIDX(fourty_two))

  bytes_builder.new()
  |> modules.encode_start_section(start_section)
  |> should_equal_helper(<<0x08, 1, 42>>)
}

pub fn element_section_test() {
  let empty_element_section =
    structure_modules.ElementSection(finger_tree.new())

  bytes_builder.new()
  |> modules.encode_element_section(empty_element_section)
  |> should_equal_helper(<<0x09, 0x01, 0x00>>)

  let assert Ok(zero) = numbers.u32(0)
  let assert Ok(one) = numbers.u32(1)
  let assert Ok(two) = numbers.u32(2)
  let assert Ok(fourty_two) = numbers.i32(42)
  let assert Ok(fourty_two_unsigned) = numbers.u32(42)
  let offset_fourty_two =
    expression.new()
    |> i32.const_(fourty_two)
    |> expression.end_unwrap()

  let table_idx_zero = structure_types.TableIDX(zero)
  let table_idx_fourty_two = structure_types.TableIDX(fourty_two_unsigned)

  let ref_func =
    structure_types.HeapTypeRefType(structure_types.FuncHeapType, False)
  // Elem(type_: RefType, init: FingerTree(Expr), mode: ElemMode)

  let ref_null_i31 =
    structure_types.HeapTypeRefType(structure_types.I31HeapType, True)
  let null_i31 =
    expression.new()
    |> ref.null(structure_types.I31HeapType)
    |> expression.end_unwrap()

  let three_null_i31 = finger_tree.from_list([null_i31, null_i31, null_i31])

  let three_func_idx =
    finger_tree.from_list([
      structure_types.FuncIDX(zero),
      structure_types.FuncIDX(one),
      structure_types.FuncIDX(two),
    ])

  let three_func_idx_expression =
    three_func_idx |> finger_tree.map(func_idx_to_expr)

  // type 0 -> (ref func) (init: FuncIDX*) Active(TableIDX(0), Offset(offset_fourty_two))
  let element_zero =
    structure_types.ElemFuncs(
      ref_func,
      three_func_idx,
      structure_types.ActiveElemMode(table_idx_zero, offset_fourty_two),
    )
  let element_zero_bytes = <<
    // segment type 0
    0x00,
    // offset 42
    0x41, 42, 0x0B,
    // 3 indexes [0, 1, 2]
    0x03, 0x00, 0x01, 0x02,
  >>
  bytes_builder.new()
  |> modules.encode_element_segment(element_zero)
  |> should_equal_helper(element_zero_bytes)

  // 1 -> (ref func) (init: FuncIDX*) (passive)
  let element_one =
    structure_types.ElemFuncs(
      ref_func,
      three_func_idx,
      structure_types.PassiveElemMode,
    )
  let element_one_bytes = <<
    // segment type 1
    0x01,
    // elem kind 0
    0x00,
    // 3 indexes [0, 1, 2]
    0x03, 0x00, 0x01, 0x02,
  >>
  bytes_builder.new()
  |> modules.encode_element_segment(element_one)
  |> should_equal_helper(element_one_bytes)

  // 2 -> (ref func) (init: FuncIDX*) (Active (TableIDX(42), Offset(offset_fourty_two)))
  let element_two =
    structure_types.ElemFuncs(
      ref_func,
      three_func_idx,
      structure_types.ActiveElemMode(table_idx_fourty_two, offset_fourty_two),
    )
  let element_two_bytes = <<
    // segment type 2
    0x02,
    // table index 42
    42,
    // offset 42
    0x41, 42, 0x0B,
    // elem kind 0
    0x00,
    // 3 indexes [0, 1, 2]
    0x03, 0x00, 0x01, 0x02,
  >>
  bytes_builder.new()
  |> modules.encode_element_segment(element_two)
  |> should_equal_helper(element_two_bytes)

  // 3 -> (ref func) init: FuncIDX* (declarative)
  let element_three =
    structure_types.ElemFuncs(
      ref_func,
      three_func_idx,
      structure_types.DeclarativeElemMode,
    )
  let element_three_bytes = <<
    // segment type 3
    0x03,
    // elem kind 0
    0x00,
    // 3 indexes [0, 1, 2]
    0x03, 0x00, 0x01, 0x02,
  >>
  bytes_builder.new()
  |> modules.encode_element_segment(element_three)
  |> should_equal_helper(element_three_bytes)

  let element_four =
    structure_types.ElemExpressions(
      ref_func,
      three_func_idx_expression,
      structure_types.ActiveElemMode(table_idx_zero, offset_fourty_two),
    )
  let element_four_bytes = <<
    // segment type 4
    0x04,
    // offset 42
    0x41, 42, 0x0B,
    // 3 index expressions [0, 1, 2]
    0x03,
    // ref.func 0 end
    0xd2, 0x00, 0x0B,
    // ref.func 1 end
    0xd2, 0x01, 0x0B,
    // ref.func 2 end
    0xd2, 0x02, 0x0B,
  >>
  bytes_builder.new()
  |> modules.encode_element_segment(element_four)
  |> should_equal_helper(element_four_bytes)

  let element_five =
    structure_types.ElemExpressions(
      ref_null_i31,
      three_null_i31,
      structure_types.PassiveElemMode,
    )
  let element_five_bytes = <<
    // segment type 5
    0x05,
    // elem ref type (ref i31 null)
    0x6C,
    // 3 (ref.null i3i)
    0x03,
    // ref.null i31 x 3
    0xD0, 0x6C, 0x0B, 0xD0, 0x6C, 0x0B, 0xD0, 0x6C, 0x0B,
  >>
  // <<5, 108, 3, 208, 108, 11, 208, 108, 11, 208, 108, 11>>
  // <<5, 108, 3, 208, 108, 208, 108, 208, 108>>
  bytes_builder.new()
  |> modules.encode_element_segment(element_five)
  |> should_equal_helper(element_five_bytes)

  let element_six =
    structure_types.ElemExpressions(
      ref_null_i31,
      three_null_i31,
      structure_types.ActiveElemMode(table_idx_fourty_two, offset_fourty_two),
    )
  let element_six_bytes = <<
    // segment type 6
    0x06,
    // table index 42
    42,
    // offset 42
    0x41, 42, 0x0B,
    // elem ref type (ref i31 null)
    0x6C,
    // 3 (ref.null i3i)
    0x03,
    // ref.null i31 x 3
    0xD0, 0x6C, 0x0B, 0xD0, 0x6C, 0x0B, 0xD0, 0x6C, 0x0B,
  >>
  bytes_builder.new()
  |> modules.encode_element_segment(element_six)
  |> should_equal_helper(element_six_bytes)

  let element_seven =
    structure_types.ElemExpressions(
      ref_null_i31,
      three_null_i31,
      structure_types.DeclarativeElemMode,
    )
  let element_seven_bytes = <<
    // segment type 7
    0x07,
    // elem ref type (ref i31 null)
    0x6C,
    // 3 (ref.null i3i)
    0x03,
    // ref.null i31 x 3
    0xD0, 0x6C, 0x0B, 0xD0, 0x6C, 0x0B, 0xD0, 0x6C, 0x0B,
  >>
  bytes_builder.new()
  |> modules.encode_element_segment(element_seven)
  |> should_equal_helper(element_seven_bytes)

  let element_section =
    structure_modules.ElementSection(
      finger_tree.from_list([
        element_zero,
        element_one,
        element_two,
        element_three,
        element_four,
        element_five,
        element_six,
        element_seven,
      ]),
    )

  let element_section_byte_length =
    1
    // for vector size (0x08)
    + bit_array.byte_size(element_zero_bytes)
    + bit_array.byte_size(element_one_bytes)
    + bit_array.byte_size(element_two_bytes)
    + bit_array.byte_size(element_three_bytes)
    + bit_array.byte_size(element_four_bytes)
    + bit_array.byte_size(element_five_bytes)
    + bit_array.byte_size(element_six_bytes)
    + bit_array.byte_size(element_seven_bytes)

  let assert Ok(element_section_length) =
    numbers.u32(element_section_byte_length)
  let element_section_length =
    values.encode_u32(bytes_builder.new(), element_section_length)
    |> bytes_builder.to_bit_array

  let element_section_bytes = <<
    // section type 9
    0x09,
    // byte size
    element_section_length:bits,
    // 8 elements
    0x08,
    // segment type 0 through 7
    element_zero_bytes:bits,
    element_one_bytes:bits,
    element_two_bytes:bits,
    element_three_bytes:bits,
    element_four_bytes:bits,
    element_five_bytes:bits,
    element_six_bytes:bits,
    element_seven_bytes:bits,
  >>

  bytes_builder.new()
  |> modules.encode_element_section(element_section)
  |> should_equal_helper(element_section_bytes)
}

pub fn code_section_test() {
  let assert Ok(two) = numbers.u32(2)
  let add_locals =
    finger_tree.from_list([
      structure_types.Locals(two, structure_types.I32ValType),
    ])

  let assert Ok(one) = numbers.i32(1)
  let assert Ok(forty_one) = numbers.i32(41)

  let code_section =
    structure_modules.CodeSection(
      finger_tree.from_list([
        structure_types.Code(
          add_locals,
          expression.new()
            |> i32.const_(forty_one)
            |> i32.const_(one)
            |> i32.add()
            |> expression.end_unwrap(),
        ),
      ]),
    )

  let code_section_bytes = <<
    0x0A, 0x0B,
    // section size
    0x01,
    // 1 Code

    0x09,
    // size of code
    0x01,
    // 1 Locals
    0x02, 0x7F,
    // 2 i32s
    // body
    0x41, 41,
    // i32.const 41 
    0x41, 1,
    // i32.const 1 
    0x6A,
    // i32.add
    0x0B,
    // end
  >>

  bytes_builder.new()
  |> modules.encode_code_section(code_section)
  |> should_equal_helper(code_section_bytes)
}

pub fn data_section_test() {
  let assert Ok(mem_idx_zero) = numbers.u32(0)
  let assert Ok(mem_idx_one) = numbers.u32(1)
  let assert Ok(offset_zero) = numbers.i32(0)
  let assert Ok(offset_ten) = numbers.i32(10)
  let mem_idx_zero = structure_types.MemIDX(mem_idx_zero)
  let mem_idx_one = structure_types.MemIDX(mem_idx_one)
  let offset_zero_expr =
    expression.new()
    |> i32.const_(offset_zero)
    |> expression.end_unwrap()

  let offset_ten_expr =
    expression.new()
    |> i32.const_(offset_ten)
    |> expression.end_unwrap()

  let active_data_zero_idx =
    structure_types.ActiveData(mem_idx_zero, offset_zero_expr, <<
      0x01, 0x02, 0x03,
    >>)

  let passive_data = structure_types.PassiveData(<<0x04, 0x05, 0x06>>)

  let active_data =
    structure_types.ActiveData(mem_idx_one, offset_ten_expr, <<
      0x07, 0x08, 0x09,
    >>)

  let empty_data_section = structure_modules.DataSection(finger_tree.new())

  bytes_builder.new()
  |> modules.encode_data_section(empty_data_section)
  |> should_equal_helper(<<0x0B, 0x01, 0x00>>)

  let data_section =
    structure_modules.DataSection(
      finger_tree.from_list([active_data_zero_idx, passive_data, active_data]),
    )

  let data_section_bytes = <<
    0x0B, 23,
    // data section: 23 bytes

    0x03,
    // three data segments

    0x00, 0x41, 0x00, 0x0B,
    // active data segment: mem_idx = 0, offset = i32.const(0)
    0x03, 0x01, 0x02, 0x03,
    // 3 bytes, [1, 2, 3]

    0x01,
    // passive data segment
    0x03, 0x04, 0x05, 0x06,
    // 3 bytes, [4, 5, 6]

    0x02, 0x01, 0x41, 0x0A, 0x0B,
    // active data segment: mem_idx = 1, offset = i32.const(10)

    0x03, 0x07, 0x08, 0x09,
    // 3 bytes, [7, 8, 9]
  >>

  bytes_builder.new()
  |> modules.encode_data_section(data_section)
  |> should_equal_helper(data_section_bytes)
}
