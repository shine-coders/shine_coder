import builder/expression
import builder/instructions/i32
import builder/instructions/ref
import gleam/bit_array
import gleam/bytes_builder
import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/pair
import gleeunit/should
import internal/binary/common
import internal/binary/modules
import internal/binary/types
import internal/binary/values
import internal/structure/modules as structure_modules
import internal/structure/numbers
import internal/structure/types.{
  type FuncIDX, Expr, FuncImport, GlobalImport, MemImport, RefFunc, TableImport,
} as structure_types
import shine_tree

pub fn func_idx_to_expr(expr: FuncIDX) {
  Expr([RefFunc(expr)] |> shine_tree.from_list)
}

fn should_equal_helper(val: Result(u, String), expected: u) {
  case val |> should.be_ok == expected {
    True -> Nil
    _ -> {
      io.debug(#("actual", val, "expected", expected))
      panic as "Values were not equal"
    }
  }
}

pub fn decode_string_test() {
  common.decode_string(<<11, 70, 111, 111, 32, 66, 97, 114, 32, 66, 97, 122>>)
  |> should_equal_helper(#("Foo Bar Baz", <<>>))
}

pub fn decode_val_type_test() {
  <<0x7F>>
  |> types.decode_val_type
  |> should_equal_helper(#(structure_types.I32ValType, <<>>))
  <<0x7E>>
  |> types.decode_val_type
  |> should_equal_helper(#(structure_types.I64ValType, <<>>))
  <<0x7D>>
  |> types.decode_val_type
  |> should_equal_helper(#(structure_types.F32ValType, <<>>))
  <<0x7C>>
  |> types.decode_val_type
  |> should_equal_helper(#(structure_types.F64ValType, <<>>))
  <<0x7B>>
  |> types.decode_val_type
  |> should_equal_helper(#(structure_types.V128ValType, <<>>))
}

pub fn decode_abstract_heap_type_test() {
  <<0x73>>
  |> types.decode_heap_type
  |> should_equal_helper(#(structure_types.NoFuncHeapType, <<>>))
  <<0x72>>
  |> types.decode_heap_type
  |> should_equal_helper(#(structure_types.NoExternHeapType, <<>>))
  <<0x71>>
  |> types.decode_heap_type
  |> should_equal_helper(#(structure_types.NoneHeapType, <<>>))
  <<0x70>>
  |> types.decode_heap_type
  |> should_equal_helper(#(structure_types.FuncHeapType, <<>>))
  <<0x6F>>
  |> types.decode_heap_type
  |> should_equal_helper(#(structure_types.ExternHeapType, <<>>))
  // any, eq, i31
  <<0x6E>>
  |> types.decode_heap_type
  |> should_equal_helper(#(structure_types.AnyHeapType, <<>>))
  <<0x6D>>
  |> types.decode_heap_type
  |> should_equal_helper(#(structure_types.EqHeapType, <<>>))
  <<0x6C>>
  |> types.decode_heap_type
  |> should_equal_helper(#(structure_types.I31HeapType, <<>>))
  // struct, array
  <<0x6B>>
  |> types.decode_heap_type
  |> should_equal_helper(#(structure_types.StructHeapType, <<>>))
  <<0x6A>>
  |> types.decode_heap_type
  |> should_equal_helper(#(structure_types.ArrayHeapType, <<>>))
}

pub fn decode_concrete_heap_type_test() {
  let assert Ok(u32_value) = numbers.u32(10)
  <<0x0A>>
  |> types.decode_heap_type
  |> should_equal_helper(
    #(
      structure_types.ConcreteHeapType(structure_types.TypeIDX(u32_value)),
      <<>>,
    ),
  )
}

pub fn decode_ref_type_test() {
  <<0x73>>
  |> types.decode_ref_type
  |> should_equal_helper(#(structure_types.NoFuncRefType, <<>>))
  <<0x72>>
  |> types.decode_ref_type
  |> should_equal_helper(#(structure_types.NoExternRefType, <<>>))
  <<0x71>>
  |> types.decode_ref_type
  |> should_equal_helper(#(structure_types.NoneRefType, <<>>))
  <<0x70>>
  |> types.decode_ref_type
  |> should_equal_helper(#(structure_types.FuncRefType, <<>>))
  <<0x6F>>
  |> types.decode_ref_type
  |> should_equal_helper(#(structure_types.ExternRefType, <<>>))
  // any, eq, i31
  <<0x6E>>
  |> types.decode_ref_type
  |> should_equal_helper(#(structure_types.AnyRefType, <<>>))
  <<0x6D>>
  |> types.decode_ref_type
  |> should_equal_helper(#(structure_types.EqRefType, <<>>))
  <<0x6C>>
  |> types.decode_ref_type
  |> should_equal_helper(#(structure_types.I31RefType, <<>>))
  // struct, array
  <<0x6B>>
  |> types.decode_ref_type
  |> should_equal_helper(#(structure_types.StructRefType, <<>>))
  <<0x6A>>
  |> types.decode_ref_type
  |> should_equal_helper(#(structure_types.ArrayRefType, <<>>))
}

pub fn decode_heap_type_ref_type_test() {
  let assert Ok(u32_value) = numbers.u32(10)

  <<0x6B>>
  |> types.decode_ref_type
  |> should_equal_helper(#(structure_types.StructRefType, <<>>))

  <<0x63, 0x6B>>
  |> types.decode_ref_type
  |> should_equal_helper(#(structure_types.StructRefType, <<>>))

  <<0x64, 10>>
  |> types.decode_ref_type
  |> should_equal_helper(
    #(
      structure_types.HeapTypeRefType(
        structure_types.ConcreteHeapType(structure_types.TypeIDX(u32_value)),
        False,
      ),
      <<>>,
    ),
  )
  <<0x63, 10>>
  |> types.decode_ref_type
  |> should_equal_helper(
    #(
      structure_types.HeapTypeRefType(
        structure_types.ConcreteHeapType(structure_types.TypeIDX(u32_value)),
        True,
      ),
      <<>>,
    ),
  )
}

pub fn decode_result_type_test() {
  <<0>>
  |> types.decode_result_type
  |> should.be_ok
  |> pair.map_first(shine_tree.to_list)
  |> should.equal(#([], <<>>))

  <<4, 0x7F, 0x7E, 0x7D, 0x7C>>
  |> types.decode_result_type
  |> should.be_ok
  |> pair.map_first(shine_tree.to_list)
  |> should.equal(
    #(
      [
        structure_types.I32ValType,
        structure_types.I64ValType,
        structure_types.F32ValType,
        structure_types.F64ValType,
      ],
      <<>>,
    ),
  )
}

pub fn decode_array_type_test() {
  <<0x7F, 0x00>>
  |> types.decode_array_type
  |> should_equal_helper(
    #(
      structure_types.ArrayType(structure_types.FieldType(
        structure_types.ValTypeStorageType(structure_types.I32ValType),
        structure_types.Const,
      )),
      <<>>,
    ),
  )
  <<0x78, 0x00>>
  |> types.decode_array_type
  |> should_equal_helper(
    #(
      structure_types.ArrayType(structure_types.FieldType(
        structure_types.I8StorageType,
        structure_types.Const,
      )),
      <<>>,
    ),
  )
  <<0x77, 0x00>>
  |> types.decode_array_type
  |> should_equal_helper(
    #(
      structure_types.ArrayType(structure_types.FieldType(
        structure_types.I16StorageType,
        structure_types.Const,
      )),
      <<>>,
    ),
  )
  <<0x7F, 0x01>>
  |> types.decode_array_type
  |> should_equal_helper(
    #(
      structure_types.ArrayType(structure_types.FieldType(
        structure_types.ValTypeStorageType(structure_types.I32ValType),
        structure_types.Var,
      )),
      <<>>,
    ),
  )
  <<0x78, 0x01>>
  |> types.decode_array_type
  |> should_equal_helper(
    #(
      structure_types.ArrayType(structure_types.FieldType(
        structure_types.I8StorageType,
        structure_types.Var,
      )),
      <<>>,
    ),
  )
  <<0x77, 0x01>>
  |> types.decode_array_type
  |> should_equal_helper(
    #(
      structure_types.ArrayType(structure_types.FieldType(
        structure_types.I16StorageType,
        structure_types.Var,
      )),
      <<>>,
    ),
  )
}

pub fn decode_struct_type_test() {
  <<0>>
  |> types.decode_struct_type
  |> should.be_ok
  |> should.equal(#(structure_types.StructType(shine_tree.empty), <<>>))

  <<6, 0x7F, 0x00, 0x78, 0x00, 0x77, 0x00, 0x7F, 0x01, 0x78, 0x01, 0x77, 0x01>>
  |> types.decode_struct_type
  |> should.be_ok
  |> pair.map_first(fn(e) { e.ft |> shine_tree.to_list })
  |> should.equal(
    #(
      [
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
      ],
      <<>>,
    ),
  )
}

fn func_type_equals(a: structure_types.FuncType, b: structure_types.FuncType) {
  a.parameters
  |> shine_tree.to_list
  |> should.equal(b.parameters |> shine_tree.to_list)
  a.results
  |> shine_tree.to_list
  |> should.equal(b.results |> shine_tree.to_list)
}

fn struct_type_equals(
  a: structure_types.StructType,
  b: structure_types.StructType,
) {
  a.ft
  |> shine_tree.to_list
  |> should.equal(b.ft |> shine_tree.to_list)
}

fn array_type_equals(a: structure_types.ArrayType, b: structure_types.ArrayType) {
  a.ft |> should.equal(b.ft)
}

fn composite_type_equals(
  a: structure_types.CompositeType,
  b: structure_types.CompositeType,
) {
  case a, b {
    a, b if a == b -> Nil
    structure_types.FuncCompositeType(a), structure_types.FuncCompositeType(b) ->
      func_type_equals(a, b)
    structure_types.StructCompositeType(a),
      structure_types.StructCompositeType(b)
    -> struct_type_equals(a, b)
    structure_types.ArrayCompositeType(a), structure_types.ArrayCompositeType(b)
    -> array_type_equals(a, b)
    _, _ -> panic as "Values were not equal"
  }
}

fn decode_type_equals_helper(
  bits: BitArray,
  expected: u,
  decode_fn: fn(BitArray) -> Result(#(u, BitArray), String),
  equals_fn: fn(u, u) -> Nil,
) {
  decode_fn(bits)
  |> should.be_ok
  |> pair.map_first(equals_fn(_, expected))
  |> pair.map_second(should.equal(_, <<>>))
}

pub fn decode_composite_type_test() {
  decode_type_equals_helper(
    <<0x60, 0x00, 0x00>>,
    structure_types.FuncCompositeType(structure_types.FuncType(
      shine_tree.empty,
      shine_tree.empty,
    )),
    types.decode_comp_type,
    composite_type_equals,
  )

  decode_type_equals_helper(
    <<
      0x5F, 0x06, 0x7F, 0x00, 0x78, 0x00, 0x77, 0x00, 0x7F, 0x01, 0x78, 0x01,
      0x77, 0x01,
    >>,
    structure_types.StructCompositeType(
      structure_types.StructType(
        shine_tree.from_list([
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
    types.decode_comp_type,
    composite_type_equals,
  )

  decode_type_equals_helper(
    <<0x5E, 0x7F, 0x00>>,
    structure_types.ArrayCompositeType(
      structure_types.ArrayType(structure_types.FieldType(
        structure_types.ValTypeStorageType(structure_types.I32ValType),
        structure_types.Const,
      )),
    ),
    types.decode_comp_type,
    composite_type_equals,
  )
  decode_type_equals_helper(
    <<0x5E, 0x77, 0x01>>,
    structure_types.ArrayCompositeType(
      structure_types.ArrayType(structure_types.FieldType(
        structure_types.I16StorageType,
        structure_types.Var,
      )),
    ),
    types.decode_comp_type,
    composite_type_equals,
  )
}

fn do_type_idxs_equal(
  a: shine_tree.ShineTree(structure_types.TypeIDX),
  b: shine_tree.ShineTree(structure_types.TypeIDX),
) {
  case shine_tree.shift(a), shine_tree.shift(b) {
    Ok(#(a, rest_a)), Ok(#(b, rest_b))
      if rest_a == shine_tree.empty && rest_b == shine_tree.empty
    -> {
      a |> should.equal(b)
      Nil
    }
    Ok(#(a, rest_a)), Ok(#(b, rest_b)) -> {
      a |> should.equal(b)
      do_type_idxs_equal(rest_a, rest_b)
    }
    Error(Nil), Error(Nil) -> Nil
    _, _ -> panic as "TypeIdxs were not equal"
  }
}

fn do_func_idxs_equal(
  a: shine_tree.ShineTree(structure_types.FuncIDX),
  b: shine_tree.ShineTree(structure_types.FuncIDX),
) {
  case shine_tree.shift(a), shine_tree.shift(b) {
    Ok(#(a, rest_a)), Ok(#(b, rest_b))
      if rest_a == shine_tree.empty && rest_b == shine_tree.empty
    -> {
      a |> should.equal(b)
      Nil
    }
    Ok(#(a, rest_a)), Ok(#(b, rest_b)) -> {
      a |> should.equal(b)
      do_func_idxs_equal(rest_a, rest_b)
    }
    Error(Nil), Error(Nil) -> Nil
    _, _ -> {
      io.debug(#("funcs are not equal: ", a, " != ", b))
      panic as "FuncIDXs were not equal"
    }
  }
}

fn sub_type_equals(a: structure_types.SubType, b: structure_types.SubType) {
  a.final |> should.equal(b.final)
  do_type_idxs_equal(a.t, b.t)
  composite_type_equals(a.ct, b.ct)
}

fn rec_type_equals(a: structure_types.RecType, b: structure_types.RecType) {
  do_sub_types_equal(a.sub_types, b.sub_types)
}

fn do_sub_types_equal(
  a: shine_tree.ShineTree(structure_types.SubType),
  b: shine_tree.ShineTree(structure_types.SubType),
) {
  case shine_tree.shift(a), shine_tree.shift(b) {
    Ok(#(a, rest_a)), Ok(#(b, rest_b))
      if rest_a == shine_tree.empty && rest_b == shine_tree.empty
    -> {
      sub_type_equals(a, b)
      Nil
    }
    Ok(#(a, rest_a)), Ok(#(b, rest_b)) -> {
      sub_type_equals(a, b)
      do_sub_types_equal(rest_a, rest_b)
    }
    Error(Nil), Error(Nil) -> Nil
    _, _ -> panic as "SubTypes were not equal"
  }
}

pub fn decode_rec_type_test() {
  let subtype_one =
    structure_types.SubType(
      True,
      shine_tree.empty,
      structure_types.ArrayCompositeType(
        structure_types.ArrayType(structure_types.FieldType(
          structure_types.ValTypeStorageType(structure_types.I32ValType),
          structure_types.Const,
        )),
      ),
    )
  let rec_type_one =
    structure_types.RecType(shine_tree.from_list([subtype_one]))

  <<0x5E, 0x7F, 0x00>>
  |> decode_type_equals_helper(
    rec_type_one,
    types.decode_rec_type,
    rec_type_equals,
  )

  let assert Ok(idx_one) = numbers.u32(1)
  let assert Ok(idx_two) = numbers.u32(2)
  let subtype_two =
    structure_types.SubType(
      False,
      shine_tree.from_list([
        structure_types.TypeIDX(idx_one),
        structure_types.TypeIDX(idx_two),
      ]),
      structure_types.StructCompositeType(
        structure_types.StructType(
          shine_tree.from_list([
            structure_types.FieldType(
              structure_types.ValTypeStorageType(structure_types.I32ValType),
              structure_types.Const,
            ),
          ]),
        ),
      ),
    )

  let rec_type_two =
    structure_types.RecType(shine_tree.from_list([subtype_two]))

  <<0x50, 0x02, 0x01, 0x02, 0x5F, 0x01, 0x7F, 0x00>>
  |> decode_type_equals_helper(
    rec_type_two,
    types.decode_rec_type,
    rec_type_equals,
  )

  <<
    0x4E, 0x02, 0x5E, 0x7F, 0x00, 0x50, 0x02, 0x01, 0x02, 0x5F, 0x01, 0x7F, 0x00,
  >>
  |> decode_type_equals_helper(
    structure_types.RecType(shine_tree.from_list([subtype_one, subtype_two])),
    types.decode_rec_type,
    rec_type_equals,
  )
}

fn custom_section_equals(
  a: Option(structure_modules.CustomSection),
  b: Option(structure_modules.CustomSection),
) {
  case a, b {
    None, None -> Nil
    Some(a), Some(b) -> {
      a.name |> should.equal(b.name)
      a.data |> should.equal(b.data)
    }
    _, _ -> panic as "CustomSections were not equal"
  }
}

pub fn decode_custom_section_test() {
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

  <<
    0x00,
    section_length,
    name_length,
    name_bits:bits,
    payload_length,
    payload:bits,
  >>
  |> decode_type_equals_helper(
    Some(custom_section),
    modules.decode_custom_section,
    custom_section_equals,
  )
}

fn type_section_equals(
  a: Option(structure_modules.TypeSection),
  b: Option(structure_modules.TypeSection),
) {
  case a, b {
    None, None -> Nil
    Some(a), Some(b) -> do_rec_types_equal(a.types, b.types)
    _, _ -> panic as "TypeSections were not equal"
  }
}

fn do_rec_types_equal(
  a: shine_tree.ShineTree(structure_types.RecType),
  b: shine_tree.ShineTree(structure_types.RecType),
) {
  case shine_tree.shift(a), shine_tree.shift(b) {
    Ok(#(a, rest_a)), Ok(#(b, rest_b))
      if rest_a == shine_tree.empty && rest_b == shine_tree.empty
    -> {
      rec_type_equals(a, b)
      Nil
    }
    Ok(#(a, rest_a)), Ok(#(b, rest_b)) -> {
      rec_type_equals(a, b)
      do_rec_types_equal(rest_a, rest_b)
    }
    Error(Nil), Error(Nil) -> Nil
    _, _ -> panic as "RecTypes were not equal"
  }
}

// 1 type section
pub fn decode_type_section_test() {
  let empty_type_section = structure_modules.TypeSection(shine_tree.empty)

  <<0x01, 0x01, 0x00>>
  |> decode_type_equals_helper(
    Some(empty_type_section),
    modules.decode_type_section,
    type_section_equals,
  )

  let array_type_example =
    structure_types.RecType(
      shine_tree.from_list([
        structure_types.SubType(
          True,
          shine_tree.empty,
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
    structure_modules.TypeSection(shine_tree.from_list([array_type_example]))

  <<
    0x01,
    example_type_section_length:bits,
    array_example_length:bits,
    array_example_type:bits,
  >>
  |> decode_type_equals_helper(
    Some(example_type_section),
    modules.decode_type_section,
    type_section_equals,
  )
}

fn import_section_equals(
  a: Option(structure_modules.ImportSection),
  b: Option(structure_modules.ImportSection),
) {
  case a, b {
    None, None -> Nil
    Some(a), Some(b) -> do_imports_equal(a.imports, b.imports)
    _, _ -> panic as "ImportSections were not equal"
  }
}

fn do_imports_equal(
  a: shine_tree.ShineTree(structure_types.Import),
  b: shine_tree.ShineTree(structure_types.Import),
) {
  case shine_tree.shift(a), shine_tree.shift(b) {
    Ok(#(a, rest_a)), Ok(#(b, rest_b))
      if rest_a == shine_tree.empty && rest_b == shine_tree.empty
    -> {
      import_equals(a, b)
      Nil
    }
    Ok(#(a, rest_a)), Ok(#(b, rest_b)) -> {
      import_equals(a, b)
      do_imports_equal(rest_a, rest_b)
    }
    Error(Nil), Error(Nil) -> Nil
    _, _ -> panic as "Imports were not equal"
  }
}

fn import_equals(a: structure_types.Import, b: structure_types.Import) {
  case a, b {
    FuncImport(mod_one, name_one, type_idx_one),
      FuncImport(mod_two, name_two, type_idx_two)
    -> {
      mod_one |> should.equal(mod_two)
      name_one |> should.equal(name_two)
      type_idx_one |> should.equal(type_idx_two)
    }
    TableImport(mod_one, name_one, table_type_one),
      TableImport(mod_two, name_two, table_type_two)
    -> {
      mod_one |> should.equal(mod_two)
      name_one |> should.equal(name_two)
      table_type_one |> should.equal(table_type_two)
    }
    MemImport(mod_one, name_one, mem_type_one),
      MemImport(mod_two, name_two, mem_type_two)
    -> {
      mod_one |> should.equal(mod_two)
      name_one |> should.equal(name_two)
      mem_type_one |> should.equal(mem_type_two)
    }
    GlobalImport(mod_one, name_one, global_type_one),
      GlobalImport(mod_two, name_two, global_type_two)
    -> {
      mod_one |> should.equal(mod_two)
      name_one |> should.equal(name_two)
      global_type_one |> should.equal(global_type_two)
    }
    _, _ -> panic as "Imports were not equal"
  }
}

// 2 import section
pub fn decode_import_section_test() {
  let empty_import_section = structure_modules.ImportSection(shine_tree.empty)

  <<0x02, 0x01, 0x00>>
  |> decode_type_equals_helper(
    Some(empty_import_section),
    modules.decode_import_section,
    import_section_equals,
  )

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
    structure_modules.ImportSection(shine_tree.from_list([func_import_example]))
  <<0x02, func_import_bytes_length, func_import_bytes:bits>>
  |> decode_type_equals_helper(
    Some(example_import_section),
    modules.decode_import_section,
    import_section_equals,
  )
}

fn function_section_equals(
  a: Option(structure_modules.FunctionSection),
  b: Option(structure_modules.FunctionSection),
) {
  case a, b {
    None, None -> Nil
    Some(a), Some(b) -> do_type_idxs_equal(a.funcs, b.funcs)
    _, _ -> panic as "FunctionSections were not equal"
  }
}

// 3 function section
pub fn decode_function_section_test() {
  let empty_function_section =
    structure_modules.FunctionSection(shine_tree.empty)

  <<0x03, 0x01, 0x00>>
  |> decode_type_equals_helper(
    Some(empty_function_section),
    modules.decode_function_section,
    function_section_equals,
  )

  let assert Ok(indexes) =
    [1, 2, 3, 4]
    |> shine_tree.from_list
    |> shine_tree.try_map(numbers.u32)

  let indexes = indexes |> shine_tree.map(structure_types.TypeIDX)

  let function_section = structure_modules.FunctionSection(indexes)

  <<0x03, 0x05, 0x04, 0x01, 0x02, 0x03, 0x04>>
  |> decode_type_equals_helper(
    Some(function_section),
    modules.decode_function_section,
    function_section_equals,
  )
}

fn table_section_equals(
  a: Option(structure_modules.TableSection),
  b: Option(structure_modules.TableSection),
) {
  case a, b {
    None, None -> Nil
    Some(a), Some(b) -> do_tables_equal(a.tables, b.tables)
    _, _ -> panic as "TableSections were not equal"
  }
}

fn do_tables_equal(
  a: shine_tree.ShineTree(structure_types.Table),
  b: shine_tree.ShineTree(structure_types.Table),
) {
  case shine_tree.shift(a), shine_tree.shift(b) {
    Ok(#(a, rest_a)), Ok(#(b, rest_b)) -> {
      a |> table_equals(b)
      do_tables_equal(rest_a, rest_b)
    }
    Error(Nil), Error(Nil) -> Nil
    _, _ -> panic as "Tables were not equal"
  }
}

fn heap_type_equals(a: structure_types.HeapType, b: structure_types.HeapType) {
  a |> should.equal(b)
}

fn ref_type_equals(a: structure_types.RefType, b: structure_types.RefType) {
  case a, b {
    a, b if a == b -> Nil
    structure_types.HeapTypeRefType(a, mut_a),
      structure_types.HeapTypeRefType(b, mut_b)
    -> {
      a |> heap_type_equals(b)
      mut_a |> should.equal(mut_b)
      Nil
    }
    _, _ -> {
      io.debug(#("reftypes were not equal: ", a, b))
      panic as "RefTypes were not equal"
    }
  }
}

fn table_type_equals(a: structure_types.TableType, b: structure_types.TableType) {
  a.t |> ref_type_equals(b.t)
  a.limits |> should.equal(b.limits)
}

fn option_equals(a: Option(u), b: Option(u), equals_fn: fn(u, u) -> Nil) {
  case a, b {
    None, None -> Nil
    Some(a), Some(b) -> equals_fn(a, b)
    _, _ -> panic as "Options were not equal"
  }
}

fn expr_equals(a: structure_types.Expr, b: structure_types.Expr) {
  a |> should.equal(b)
}

fn table_equals(a: structure_types.Table, b: structure_types.Table) {
  let structure_types.Table(a_type, a_init) = a
  let structure_types.Table(b_type, b_init) = b
  a_type |> table_type_equals(b_type)
  a_init |> option_equals(b_init, expr_equals)
}

// 4 table section
pub fn decode_table_section_test() {
  let empty_table_section = structure_modules.TableSection(shine_tree.empty)

  <<0x04, 0x01, 0x00>>
  |> decode_type_equals_helper(
    Some(empty_table_section),
    modules.decode_table_section,
    table_section_equals,
  )

  let assert Ok(zero) = numbers.u32(0)
  let second_table_limits = structure_types.Limits(zero, None)

  let second_table =
    structure_types.Table(
      structure_types.TableType(
        structure_types.ArrayRefType,
        second_table_limits,
      ),
      None,
    )

  let second_table_section_length = <<0x04>>
  let second_table_count = <<0x01>>
  let second_table_bits = <<0x6A, 0x00, 0x00>>

  let second_table_bits = <<
    0x04,
    second_table_section_length:bits,
    second_table_count:bits,
    second_table_bits:bits,
  >>

  second_table_bits
  |> decode_type_equals_helper(
    Some(structure_modules.TableSection(shine_tree.from_list([second_table]))),
    modules.decode_table_section,
    table_section_equals,
  )

  let expr_three =
    expression.new()
    |> ref.null(structure_types.ArrayHeapType)
    |> expression.end_unwrap()
  let table_limits_three = structure_types.Limits(zero, None)
  let table_init_three =
    structure_types.Table(
      structure_types.TableType(
        structure_types.ArrayRefType,
        table_limits_three,
      ),
      Some(expr_three),
    )

  let table_bytes_three = <<0x40, 0x00, 0x6A, 0x00, 0x00, 0xD0, 0x6A, 0x0B>>

  <<0x04, 0x09, 0x01, table_bytes_three:bits>>
  |> decode_type_equals_helper(
    Some(
      structure_modules.TableSection(shine_tree.from_list([table_init_three])),
    ),
    modules.decode_table_section,
    table_section_equals,
  )
}

fn mem_types_equals(a: structure_types.MemType, b: structure_types.MemType) {
  case a.limits == b.limits {
    True -> Nil
    False -> panic as "MemoryTypes were not equal"
  }
}

fn do_mem_types_equal(
  a: shine_tree.ShineTree(structure_types.MemType),
  b: shine_tree.ShineTree(structure_types.MemType),
) {
  case shine_tree.shift(a), shine_tree.shift(b) {
    Ok(#(a, rest_a)), Ok(#(b, rest_b)) -> {
      a |> mem_types_equals(b)
      do_mem_types_equal(rest_a, rest_b)
    }
    Error(Nil), Error(Nil) -> Nil
    _, _ -> panic as "MemoryTypes were not equal"
  }
}

fn do_memory_sections_equal(
  a: structure_modules.MemorySection,
  b: structure_modules.MemorySection,
) {
  do_mem_types_equal(a.mts, b.mts)
}

fn memory_section_equals(
  a: Option(structure_modules.MemorySection),
  b: Option(structure_modules.MemorySection),
) {
  case a, b {
    a, b if a == b -> Nil
    Some(a), Some(b) -> do_memory_sections_equal(a, b)
    None, None -> Nil
    _, _ -> panic as "MemorySections were not equal"
  }
}

// 5 memory section
pub fn decode_memory_section_test() {
  let empty_memory_section = structure_modules.MemorySection(shine_tree.empty)

  <<0x05, 0x01, 0x00>>
  |> decode_type_equals_helper(
    Some(empty_memory_section),
    modules.decode_memory_section,
    memory_section_equals,
  )

  let assert Ok(zero) = numbers.u32(0)
  let limits = structure_types.Limits(zero, None)

  let example_memory = structure_types.MemType(limits)

  let section_length = <<0x03>>
  let memory_count = <<0x01>>
  let memory_type = <<0x00, 0x00>>

  <<0x05, section_length:bits, memory_count:bits, memory_type:bits>>
  |> decode_type_equals_helper(
    Some(
      structure_modules.MemorySection(shine_tree.from_list([example_memory])),
    ),
    modules.decode_memory_section,
    memory_section_equals,
  )
}

fn global_types_equals(
  a: structure_types.GlobalType,
  b: structure_types.GlobalType,
) {
  a.vt |> should.equal(b.vt)
  a.mut |> should.equal(b.mut)
}

fn globals_equals(a: structure_types.Global, b: structure_types.Global) {
  a.type_ |> global_types_equals(b.type_)
  a.init |> expr_equals(b.init)
}

fn do_globals_equal(
  a: shine_tree.ShineTree(structure_types.Global),
  b: shine_tree.ShineTree(structure_types.Global),
) {
  case shine_tree.shift(a), shine_tree.shift(b) {
    Ok(#(a, rest_a)), Ok(#(b, rest_b)) -> {
      a |> globals_equals(b)
      do_globals_equal(rest_a, rest_b)
    }
    Error(Nil), Error(Nil) -> Nil
    _, _ -> panic as "Globals were not equal"
  }
}

fn global_section_equals(
  a: Option(structure_modules.GlobalSection),
  b: Option(structure_modules.GlobalSection),
) {
  case a, b {
    a, b if a == b -> Nil
    Some(a), Some(b) -> do_globals_equal(a.globals, b.globals)
    None, None -> Nil
    _, _ -> panic as "GlobalSections were not equal"
  }
}

// 6 global section
pub fn decode_global_section_test() {
  let empty_global_section = structure_modules.GlobalSection(shine_tree.empty)

  <<0x06, 0x01, 0x00>>
  |> decode_type_equals_helper(
    Some(empty_global_section),
    modules.decode_global_section,
    global_section_equals,
  )

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

  <<0x06, 0x07, 0x01, 0x7F, 0x01, 0x41, 0xC2, 0x00, 0x0B>>
  |> decode_type_equals_helper(
    Some(
      structure_modules.GlobalSection(shine_tree.from_list([example_global])),
    ),
    modules.decode_global_section,
    global_section_equals,
  )
}

fn exports_equals(a: structure_types.Export, b: structure_types.Export) {
  case a, b {
    structure_types.FuncExport(name1, func_idx1),
      structure_types.FuncExport(name2, func_idx2)
    -> {
      name1 |> should.equal(name2)
      func_idx1 |> should.equal(func_idx2)
    }
    structure_types.TableExport(name1, table_idx1),
      structure_types.TableExport(name2, table_idx2)
    -> {
      name1 |> should.equal(name2)
      table_idx1 |> should.equal(table_idx2)
    }
    structure_types.MemExport(name1, mem_idx1),
      structure_types.MemExport(name2, mem_idx2)
    -> {
      name1 |> should.equal(name2)
      mem_idx1 |> should.equal(mem_idx2)
    }
    structure_types.GlobalExport(name1, global_idx1),
      structure_types.GlobalExport(name2, global_idx2)
    -> {
      name1 |> should.equal(name2)
      global_idx1 |> should.equal(global_idx2)
    }
    _, _ -> panic as "Exports were not equal"
  }
}

fn do_exports_equal(
  a: shine_tree.ShineTree(structure_types.Export),
  b: shine_tree.ShineTree(structure_types.Export),
) {
  case shine_tree.shift(a), shine_tree.shift(b) {
    Ok(#(a, rest_a)), Ok(#(b, rest_b)) -> {
      a |> exports_equals(b)
      do_exports_equal(rest_a, rest_b)
    }
    Error(Nil), Error(Nil) -> Nil
    _, _ -> panic as "Exports were not equal"
  }
}

fn export_section_equals(
  a: Option(structure_modules.ExportSection),
  b: Option(structure_modules.ExportSection),
) {
  case a, b {
    a, b if a == b -> Nil
    Some(a), Some(b) -> do_exports_equal(a.exports, b.exports)
    None, None -> Nil
    _, _ -> panic as "ExportSections were not equal"
  }
}

pub fn decode_export_section_test() {
  let empty_export_section = structure_modules.ExportSection(shine_tree.empty)

  <<0x07, 0x01, 0x00>>
  |> decode_type_equals_helper(
    Some(empty_export_section),
    modules.decode_export_section,
    export_section_equals,
  )

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
      shine_tree.from_list([
        func_export,
        table_export,
        mem_export,
        global_export,
      ]),
    )
  <<
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
  |> decode_type_equals_helper(
    Some(export_section),
    modules.decode_export_section,
    export_section_equals,
  )
}

// 7 export section

fn start_section_equals(
  a: Option(structure_modules.StartSection),
  b: Option(structure_modules.StartSection),
) {
  case a, b {
    a, b if a == b -> Nil
    Some(a), Some(b) -> a.start |> should.equal(b.start)
    None, None -> Nil
    _, _ -> panic as "StartSections were not equal"
  }
}

pub fn decode_start_section_test() {
  let assert Ok(fourty_two) = numbers.u32(42)
  <<0x08, 1, 42>>
  |> decode_type_equals_helper(
    Some(structure_modules.StartSection(structure_types.FuncIDX(fourty_two))),
    modules.decode_start_section,
    start_section_equals,
  )
}

// 8 start section

// 9 element section
fn do_expressions_equals(
  a: shine_tree.ShineTree(structure_types.Expr),
  b: shine_tree.ShineTree(structure_types.Expr),
) {
  case shine_tree.shift(a), shine_tree.shift(b) {
    Ok(#(a, rest_a)), Ok(#(b, rest_b)) -> {
      a |> expr_equals(b)
      do_expressions_equals(rest_a, rest_b)
    }
    Error(Nil), Error(Nil) -> Nil
    _, _ -> panic as "Expressions were not equal"
  }
}

fn elements_equals(a: structure_types.Elem, b: structure_types.Elem) {
  case a, b {
    a, b if a == b -> Nil
    structure_types.ElemFuncs(type1, init1, mode1),
      structure_types.ElemFuncs(type2, init2, mode2)
    -> {
      type1 |> ref_type_equals(type2)
      do_func_idxs_equal(init1, init2)
      mode1 |> should.equal(mode2)
    }
    structure_types.ElemExpressions(type1, init1, mode1),
      structure_types.ElemExpressions(type2, init2, mode2)
    -> {
      type1 |> ref_type_equals(type2)
      do_expressions_equals(init1, init2)
      mode1 |> should.equal(mode2)
    }
    _, _ -> {
      io.debug(#("elements were\n", a, "\nand\n", b))
      panic as "Elements were not equal"
    }
  }
}

fn do_elements_equal(
  a: shine_tree.ShineTree(structure_types.Elem),
  b: shine_tree.ShineTree(structure_types.Elem),
) {
  case shine_tree.shift(a), shine_tree.shift(b) {
    Ok(#(a, rest_a)), Ok(#(b, rest_b)) -> {
      a |> elements_equals(b)
      do_elements_equal(rest_a, rest_b)
    }
    Error(Nil), Error(Nil) -> Nil
    _, _ -> panic as "Elements were not equal"
  }
}

fn element_section_equals(
  a: Option(structure_modules.ElementSection),
  b: Option(structure_modules.ElementSection),
) {
  case a, b {
    a, b if a == b -> Nil
    Some(a), Some(b) -> do_elements_equal(a.elems, b.elems)
    None, None -> Nil
    _, _ -> panic as "ElementSections were not equal"
  }
}

pub fn decode_element_section_test() {
  let empty_element_section = structure_modules.ElementSection(shine_tree.empty)

  <<0x09, 0x01, 0x00>>
  |> decode_type_equals_helper(
    Some(empty_element_section),
    modules.decode_element_section,
    element_section_equals,
  )

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
  // Elem(type_: RefType, init: ShineTree(Expr), mode: ElemMode)

  let ref_null_i31 = structure_types.I31RefType
  let null_i31 =
    expression.new()
    |> ref.null(structure_types.I31HeapType)
    |> expression.end_unwrap()

  let three_null_i31 = shine_tree.from_list([null_i31, null_i31, null_i31])

  let three_func_idx =
    shine_tree.from_list([
      structure_types.FuncIDX(zero),
      structure_types.FuncIDX(one),
      structure_types.FuncIDX(two),
    ])

  let three_func_idx_expression =
    three_func_idx |> shine_tree.map(func_idx_to_expr)

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

  element_zero_bytes
  |> decode_type_equals_helper(
    element_zero,
    modules.decode_elememt,
    elements_equals,
  )

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

  element_one_bytes
  |> decode_type_equals_helper(
    element_one,
    modules.decode_elememt,
    elements_equals,
  )

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

  element_two_bytes
  |> decode_type_equals_helper(
    element_two,
    modules.decode_elememt,
    elements_equals,
  )

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

  element_three_bytes
  |> decode_type_equals_helper(
    element_three,
    modules.decode_elememt,
    elements_equals,
  )

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
  element_four_bytes
  |> decode_type_equals_helper(
    element_four,
    modules.decode_elememt,
    elements_equals,
  )

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

  element_five_bytes
  |> decode_type_equals_helper(
    element_five,
    modules.decode_elememt,
    elements_equals,
  )

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

  element_six_bytes
  |> decode_type_equals_helper(
    element_six,
    modules.decode_elememt,
    elements_equals,
  )

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

  element_seven_bytes
  |> decode_type_equals_helper(
    element_seven,
    modules.decode_elememt,
    elements_equals,
  )

  let element_section =
    structure_modules.ElementSection(
      shine_tree.from_list([
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

  element_section_bytes
  |> decode_type_equals_helper(
    Some(element_section),
    modules.decode_element_section,
    element_section_equals,
  )
}

fn locals_equals(a: structure_types.Locals, b: structure_types.Locals) {
  a.count |> should.equal(b.count)
  a.type_ |> should.equal(b.type_)
}

fn do_locals_equals(
  a: shine_tree.ShineTree(structure_types.Locals),
  b: shine_tree.ShineTree(structure_types.Locals),
) {
  case shine_tree.shift(a), shine_tree.shift(b) {
    Ok(#(a, rest_a)), Ok(#(b, rest_b)) -> {
      locals_equals(a, b)
      do_locals_equals(rest_a, rest_b)
    }
    Error(Nil), Error(Nil) -> Nil
    _, _ -> panic as "Locals were not equal"
  }
}

fn codes_equals(a: structure_types.Code, b: structure_types.Code) {
  do_locals_equals(a.locals, b.locals)

  expr_equals(a.body, b.body)
}

fn do_codes_equals(
  a: shine_tree.ShineTree(structure_types.Code),
  b: shine_tree.ShineTree(structure_types.Code),
) {
  case shine_tree.shift(a), shine_tree.shift(b) {
    Ok(#(a, rest_a)), Ok(#(b, rest_b)) -> {
      codes_equals(a, b)
      do_codes_equals(rest_a, rest_b)
    }
    Error(Nil), Error(Nil) -> Nil
    _, _ -> panic as "Codes were not equal"
  }
}

fn code_section_equals(
  a: Option(structure_modules.CodeSection),
  b: Option(structure_modules.CodeSection),
) {
  case a, b {
    a, b if a == b -> Nil
    Some(a), Some(b) -> do_codes_equals(a.codes, b.codes)
    None, None -> Nil
    _, _ -> panic as "Code sections aren't equal"
  }
}

pub fn code_section_test() {
  let assert Ok(two) = numbers.u32(2)
  let add_locals =
    shine_tree.from_list([
      structure_types.Locals(two, structure_types.I32ValType),
    ])

  let assert Ok(one) = numbers.i32(1)
  let assert Ok(forty_one) = numbers.i32(41)

  let code_section =
    structure_modules.CodeSection(
      shine_tree.from_list([
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

  code_section_bytes
  |> decode_type_equals_helper(
    Some(code_section),
    modules.decode_code_section,
    code_section_equals,
  )
}

fn data_equals(a: structure_types.Data, b: structure_types.Data) {
  case a, b {
    structure_types.ActiveData(mem1, offset1, init1),
      structure_types.ActiveData(mem2, offset2, init2)
    -> {
      mem1 |> should.equal(mem2)
      offset1 |> expr_equals(offset2)
      init1 |> should.equal(init2)
    }
    structure_types.PassiveData(init1), structure_types.PassiveData(init2) ->
      init1 |> should.equal(init2)
    _, _ -> panic as "Data was not equal"
  }
}

fn do_data_equals(
  a: shine_tree.ShineTree(structure_types.Data),
  b: shine_tree.ShineTree(structure_types.Data),
) {
  case shine_tree.shift(a), shine_tree.shift(b) {
    Ok(#(a, rest_a)), Ok(#(b, rest_b)) -> {
      data_equals(a, b)
      do_data_equals(rest_a, rest_b)
    }
    Error(Nil), Error(Nil) -> Nil
    _, _ -> panic as "Data was not equal"
  }
}

fn data_section_equals(
  a: Option(structure_modules.DataSection),
  b: Option(structure_modules.DataSection),
) {
  case a, b {
    a, b if a == b -> Nil
    Some(a), Some(b) -> do_data_equals(a.data, b.data)
    None, None -> Nil
    _, _ -> panic as "Data sections aren't equal"
  }
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

  let empty_data_section = structure_modules.DataSection(shine_tree.empty)

  <<0x0B, 0x01, 0x00>>
  |> decode_type_equals_helper(
    Some(empty_data_section),
    modules.decode_data_section,
    data_section_equals,
  )

  let data_section =
    structure_modules.DataSection(
      shine_tree.from_list([active_data_zero_idx, passive_data, active_data]),
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

  data_section_bytes
  |> decode_type_equals_helper(
    Some(data_section),
    modules.decode_data_section,
    data_section_equals,
  )
}
