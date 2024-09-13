import gleam/bit_array
import gleam/bytes_builder
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import gleeunit/should
import ieee_float
import internal/binary/types
import internal/structure/numbers
import internal/structure/types as structure_types
import pprint
import shine_tree

fn round_trip(
  expected_inst: structure_types.Instruction,
  expected_bits: BitArray,
) {
  let actual_encoded =
    bytes_builder.new()
    |> types.encode_instruction(expected_inst)
    |> result.map(bytes_builder.to_bit_array)

  let actual_decoded =
    expected_bits
    |> types.decode_instruction

  case actual_encoded, actual_decoded {
    Ok(actual_bits), Ok(#(actual_inst, <<>>)) ->
      case actual_bits == expected_bits, actual_inst == expected_inst {
        False, _ -> {
          let actual_bits = actual_bits |> bit_array.inspect
          let expected_bits = expected_bits |> bit_array.inspect
          let fail_text =
            "Instruction "
            <> string.inspect(expected_inst)
            <> " did not match. Expected:\n"
            <> expected_bits
            <> "\nActual:\n"
            <> actual_bits

          panic as fail_text
        }
        _, False -> {
          let actual_inst = actual_inst |> pprint.format
          let expected_inst = expected_inst |> pprint.format
          let fail_text =
            "Instruction "
            <> string.inspect(expected_inst)
            <> " did not decode correctly. Expected:\n"
            <> expected_inst
            <> "\nActual:\n"
            <> actual_inst
          panic as fail_text
        }
        _, _ -> Nil
      }
    _, Ok(#(_, rest)) -> {
      let fail_text =
        "Instruction "
        <> string.inspect(expected_inst)
        <> " did not decode all the bytes. The following bytes were left over:\n"
        <> { rest |> bit_array.inspect }
      panic as fail_text
    }
    Error(err), _ -> {
      let fail_text =
        "Instruction "
        <> string.inspect(expected_inst)
        <> " failed to encode with error: "
        <> err

      panic as fail_text
    }
    _, Error(err) -> {
      let fail_text =
        "Instruction "
        <> string.inspect(expected_inst)
        <> " failed to decode with error: "
        <> err
      panic as fail_text
    }
  }
}

pub fn unreachable_test() {
  round_trip(structure_types.Unreachable, <<0x00>>)
}

pub fn nop_test() {
  round_trip(structure_types.Nop, <<0x01>>)
}

pub fn br_test() {
  let assert Ok(label_idx) = numbers.u32(42)
  let label_idx = structure_types.LabelIDX(label_idx)

  round_trip(structure_types.Br(label_idx), <<0x0C, 42>>)
}

pub fn br_if_test() {
  let assert Ok(label_idx) = numbers.u32(42)
  let label_idx = structure_types.LabelIDX(label_idx)

  round_trip(structure_types.BrIf(label_idx), <<0x0D, 42>>)
}

pub fn br_table_test() {
  let assert Ok(label_default) = numbers.u32(42)
  let assert Ok(label_a) = numbers.u32(1)
  let assert Ok(label_b) = numbers.u32(2)
  let assert Ok(label_c) = numbers.u32(3)

  let label_default = structure_types.LabelIDX(label_default)
  let label_a = structure_types.LabelIDX(label_a)
  let label_b = structure_types.LabelIDX(label_b)
  let label_c = structure_types.LabelIDX(label_c)

  let label_list = [label_a, label_b, label_c]
  let labels = shine_tree.from_list(label_list)

  let assert Ok(#(
    structure_types.BrTable(actual_labels, actual_label_default),
    <<>>,
  )) = types.decode_instruction(<<0x0E, 3, 1, 2, 3, 42>>)

  actual_labels
  |> shine_tree.to_list
  |> should.equal(label_list)

  actual_label_default
  |> should.equal(label_default)

  let assert Ok(builder) =
    types.encode_instruction(
      bytes_builder.new(),
      structure_types.BrTable(labels, label_default),
    )

  builder
  |> bytes_builder.to_bit_array
  |> should.equal(<<0x0E, 3, 1, 2, 3, 42>>)
}

pub fn return_test() {
  round_trip(structure_types.Return, <<0x0F>>)
}

pub fn call_test() {
  let assert Ok(function_idx) = numbers.u32(42)
  let function_idx = structure_types.FuncIDX(function_idx)

  round_trip(structure_types.Call(function_idx), <<0x10, 42>>)
}

pub fn call_indirect_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  let assert Ok(table_idx) = numbers.u32(1)
  let table_idx = structure_types.TableIDX(table_idx)

  round_trip(structure_types.CallIndirect(table_idx, type_idx), <<0x11, 42, 1>>)
}

pub fn return_call_test() {
  let assert Ok(func_idx) = numbers.u32(42)
  let func_idx = structure_types.FuncIDX(func_idx)

  round_trip(structure_types.ReturnCall(func_idx), <<0x12, 42>>)
}

pub fn return_call_indirect_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  let assert Ok(table_idx) = numbers.u32(1)
  let table_idx = structure_types.TableIDX(table_idx)

  round_trip(structure_types.ReturnCallIndirect(table_idx, type_idx), <<
    0x13, 42, 1,
  >>)
}

pub fn call_ref_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)

  round_trip(structure_types.CallRef(type_idx), <<0x14, 42>>)
}

pub fn return_call_ref_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)

  round_trip(structure_types.ReturnCallRef(type_idx), <<0x15, 42>>)
}

pub fn block_test() {
  let assert Ok(local_idx1) = numbers.u32(0)
  let local_idx1 = structure_types.LocalIDX(local_idx1)
  let assert Ok(local_idx2) = numbers.u32(1)
  let local_idx2 = structure_types.LocalIDX(local_idx2)
  let local_get1 = structure_types.LocalGet(local_idx1)
  let local_get2 = structure_types.LocalGet(local_idx2)
  let i32_add = structure_types.I32Add
  let drop = structure_types.Drop

  let instruction_list = [local_get1, local_get2, i32_add, drop]
  let block_body = structure_types.Expr(shine_tree.from_list(instruction_list))

  let assert Ok(#(
    structure_types.Block(
      actual_block_type,
      structure_types.Expr(actual_block_body),
    ),
    <<>>,
  )) =
    types.decode_instruction(<<0x02, 0x40, 0x20, 0, 0x20, 1, 0x6A, 0x1A, 0x0B>>)

  actual_block_type
  |> should.equal(structure_types.VoidBlockType)

  actual_block_body
  |> shine_tree.to_list
  |> should.equal(instruction_list)

  let assert Ok(builder) =
    types.encode_instruction(
      bytes_builder.new(),
      structure_types.Block(structure_types.VoidBlockType, block_body),
    )

  builder
  |> bytes_builder.to_bit_array
  |> should.equal(<<0x02, 0x40, 0x20, 0, 0x20, 1, 0x6A, 0x1A, 0x0B>>)
}

// https://webassembly.github.io/gc/core/binary/instructions.html#control-instructions
pub fn loop_test() {
  let assert Ok(local_idx1) = numbers.u32(0)
  let local_idx1 = structure_types.LocalIDX(local_idx1)
  let assert Ok(local_idx2) = numbers.u32(1)
  let local_idx2 = structure_types.LocalIDX(local_idx2)
  let local_get1 = structure_types.LocalGet(local_idx1)
  let local_get2 = structure_types.LocalGet(local_idx2)
  let i32_add = structure_types.I32Add
  let drop = structure_types.Drop

  let instruction_list = [local_get1, local_get2, i32_add, drop]

  let assert Ok(#(
    structure_types.Loop(
      structure_types.VoidBlockType,
      structure_types.Expr(block_body),
    ),
    <<>>,
  )) =
    types.decode_instruction(<<0x03, 0x40, 0x20, 0, 0x20, 1, 0x6A, 0x1A, 0x0B>>)

  block_body
  |> shine_tree.to_list
  |> should.equal(instruction_list)

  let assert Ok(builder) =
    types.encode_instruction(
      bytes_builder.new(),
      structure_types.Loop(
        structure_types.VoidBlockType,
        structure_types.Expr(instruction_list |> shine_tree.from_list),
      ),
    )

  builder
  |> bytes_builder.to_bit_array
  |> should.equal(<<0x03, 0x40, 0x20, 0, 0x20, 1, 0x6A, 0x1A, 0x0B>>)
}

pub fn if_test() {
  let assert Ok(local_idx1) = numbers.u32(0)
  let local_idx1 = structure_types.LocalIDX(local_idx1)
  let assert Ok(local_idx2) = numbers.u32(1)
  let local_idx2 = structure_types.LocalIDX(local_idx2)
  let local_get1 = structure_types.LocalGet(local_idx1)
  let local_get2 = structure_types.LocalGet(local_idx2)
  let i32_add = structure_types.I32Add
  let drop = structure_types.Drop

  let instruction_list = [local_get1, local_get2, i32_add, drop]
  let block_body = shine_tree.from_list(instruction_list)

  let assert Ok(#(
    structure_types.If(structure_types.VoidBlockType, result_body, None),
    <<>>,
  )) =
    types.decode_instruction(<<0x04, 0x40, 0x20, 0, 0x20, 1, 0x6A, 0x1A, 0x0B>>)

  result_body
  |> shine_tree.to_list
  |> should.equal(instruction_list)

  let assert Ok(builder) =
    types.encode_instruction(
      bytes_builder.new(),
      structure_types.If(structure_types.VoidBlockType, block_body, None),
    )

  builder
  |> bytes_builder.to_bit_array
  |> should.equal(<<0x04, 0x40, 0x20, 0, 0x20, 1, 0x6A, 0x1A, 0x0B>>)
}

pub fn if_else_test() {
  let assert Ok(local_idx1) = numbers.u32(0)
  let local_idx1 = structure_types.LocalIDX(local_idx1)
  let local_get1 = structure_types.LocalGet(local_idx1)
  let drop = structure_types.Drop

  let block_body = shine_tree.from_list([local_get1, drop])

  round_trip(
    structure_types.If(
      structure_types.VoidBlockType,
      block_body,
      Some(block_body),
    ),
    <<0x04, 0x40, 0x20, 0, 0x1A, 0x05, 0x20, 0, 0x1A, 0x0B>>,
  )
}

pub fn br_on_null_test() {
  let assert Ok(label_idx) = numbers.u32(42)
  let label_idx = structure_types.LabelIDX(label_idx)

  round_trip(structure_types.BrOnNull(label_idx), <<0xD5, 42>>)
}

pub fn br_on_non_null_test() {
  let assert Ok(label_idx) = numbers.u32(42)
  let label_idx = structure_types.LabelIDX(label_idx)

  round_trip(structure_types.BrOnNonNull(label_idx), <<0xD6, 42>>)
}

pub fn i32_eqz_test() {
  round_trip(structure_types.I32Eqz, <<0x45>>)
}

pub fn i32_eq_test() {
  round_trip(structure_types.I32Eq, <<0x46>>)
}

pub fn i32_ne_test() {
  round_trip(structure_types.I32Ne, <<0x47>>)
}

pub fn i32_lt_s_test() {
  round_trip(structure_types.I32LtS, <<0x48>>)
}

pub fn i32_lt_u_test() {
  round_trip(structure_types.I32LtU, <<0x49>>)
}

pub fn i32_gt_s_test() {
  round_trip(structure_types.I32GtS, <<0x4A>>)
}

pub fn i32_gt_u_test() {
  round_trip(structure_types.I32GtU, <<0x4B>>)
}

pub fn i32_le_s_test() {
  round_trip(structure_types.I32LeS, <<0x4C>>)
}

pub fn i32_le_u_test() {
  round_trip(structure_types.I32LeU, <<0x4D>>)
}

pub fn i32_ge_s_test() {
  round_trip(structure_types.I32GeS, <<0x4E>>)
}

pub fn i32_ge_u_test() {
  round_trip(structure_types.I32GeU, <<0x4F>>)
}

pub fn i64_eqz_test() {
  round_trip(structure_types.I64Eqz, <<0x50>>)
}

pub fn i64_eq_test() {
  round_trip(structure_types.I64Eq, <<0x51>>)
}

pub fn i64_ne_test() {
  round_trip(structure_types.I64Ne, <<0x52>>)
}

pub fn i64_lt_s_test() {
  round_trip(structure_types.I64LtS, <<0x53>>)
}

pub fn i64_lt_u_test() {
  round_trip(structure_types.I64LtU, <<0x54>>)
}

pub fn i64_gt_s_test() {
  round_trip(structure_types.I64GtS, <<0x55>>)
}

pub fn i64_gt_u_test() {
  round_trip(structure_types.I64GtU, <<0x56>>)
}

pub fn i64_le_s_test() {
  round_trip(structure_types.I64LeS, <<0x57>>)
}

pub fn i64_le_u_test() {
  round_trip(structure_types.I64LeU, <<0x58>>)
}

pub fn i64_ge_s_test() {
  round_trip(structure_types.I64GeS, <<0x59>>)
}

pub fn i64_ge_u_test() {
  round_trip(structure_types.I64GeU, <<0x5A>>)
}

pub fn f32_eq_test() {
  round_trip(structure_types.F32Eq, <<0x5B>>)
}

pub fn f32_ne_test() {
  round_trip(structure_types.F32Ne, <<0x5C>>)
}

pub fn f32_lt_test() {
  round_trip(structure_types.F32Lt, <<0x5D>>)
}

pub fn f32_gt_test() {
  round_trip(structure_types.F32Gt, <<0x5E>>)
}

pub fn f32_le_test() {
  round_trip(structure_types.F32Le, <<0x5F>>)
}

pub fn f32_ge_test() {
  round_trip(structure_types.F32Ge, <<0x60>>)
}

pub fn f64_eq_test() {
  round_trip(structure_types.F64Eq, <<0x61>>)
}

pub fn f64_ne_test() {
  round_trip(structure_types.F64Ne, <<0x62>>)
}

pub fn f64_lt_test() {
  round_trip(structure_types.F64Lt, <<0x63>>)
}

pub fn f64_gt_test() {
  round_trip(structure_types.F64Gt, <<0x64>>)
}

pub fn f64_le_test() {
  round_trip(structure_types.F64Le, <<0x65>>)
}

pub fn f64_ge_test() {
  round_trip(structure_types.F64Ge, <<0x66>>)
}

pub fn i32_clz_test() {
  round_trip(structure_types.I32Clz, <<0x67>>)
}

pub fn i32_ctz_test() {
  round_trip(structure_types.I32Ctz, <<0x68>>)
}

pub fn i32_popcnt_test() {
  round_trip(structure_types.I32Popcnt, <<0x69>>)
}

pub fn i32_add_test() {
  round_trip(structure_types.I32Add, <<0x6A>>)
}

pub fn i32_sub_test() {
  round_trip(structure_types.I32Sub, <<0x6B>>)
}

pub fn i32_mul_test() {
  round_trip(structure_types.I32Mul, <<0x6C>>)
}

pub fn i32_div_s_test() {
  round_trip(structure_types.I32DivS, <<0x6D>>)
}

pub fn i32_div_u_test() {
  round_trip(structure_types.I32DivU, <<0x6E>>)
}

pub fn i32_rem_s_test() {
  round_trip(structure_types.I32RemS, <<0x6F>>)
}

pub fn i32_rem_u_test() {
  round_trip(structure_types.I32RemU, <<0x70>>)
}

pub fn i32_and_test() {
  round_trip(structure_types.I32And, <<0x71>>)
}

pub fn i32_or_test() {
  round_trip(structure_types.I32Or, <<0x72>>)
}

pub fn i32_xor_test() {
  round_trip(structure_types.I32Xor, <<0x73>>)
}

pub fn i32_shl_test() {
  round_trip(structure_types.I32Shl, <<0x74>>)
}

pub fn i32_shr_s_test() {
  round_trip(structure_types.I32ShrS, <<0x75>>)
}

pub fn i32_shr_u_test() {
  round_trip(structure_types.I32ShrU, <<0x76>>)
}

pub fn i32_rotl_test() {
  round_trip(structure_types.I32Rotl, <<0x77>>)
}

pub fn i32_rotr_test() {
  round_trip(structure_types.I32Rotr, <<0x78>>)
}

pub fn i64_clz_test() {
  round_trip(structure_types.I64Clz, <<0x79>>)
}

pub fn i64_ctz_test() {
  round_trip(structure_types.I64Ctz, <<0x7A>>)
}

pub fn i64_popcnt_test() {
  round_trip(structure_types.I64Popcnt, <<0x7B>>)
}

pub fn i64_add_test() {
  round_trip(structure_types.I64Add, <<0x7C>>)
}

pub fn i64_sub_test() {
  round_trip(structure_types.I64Sub, <<0x7D>>)
}

pub fn i64_mul_test() {
  round_trip(structure_types.I64Mul, <<0x7E>>)
}

pub fn i64_div_s_test() {
  round_trip(structure_types.I64DivS, <<0x7F>>)
}

pub fn i64_div_u_test() {
  round_trip(structure_types.I64DivU, <<0x80>>)
}

pub fn i64_rem_s_test() {
  round_trip(structure_types.I64RemS, <<0x81>>)
}

pub fn i64_rem_u_test() {
  round_trip(structure_types.I64RemU, <<0x82>>)
}

pub fn i64_and_test() {
  round_trip(structure_types.I64And, <<0x83>>)
}

pub fn i64_or_test() {
  round_trip(structure_types.I64Or, <<0x84>>)
}

pub fn i64_xor_test() {
  round_trip(structure_types.I64Xor, <<0x85>>)
}

pub fn i64_shl_test() {
  round_trip(structure_types.I64Shl, <<0x86>>)
}

pub fn i64_shr_s_test() {
  round_trip(structure_types.I64ShrS, <<0x87>>)
}

pub fn i64_shr_u_test() {
  round_trip(structure_types.I64ShrU, <<0x88>>)
}

pub fn i64_rotl_test() {
  round_trip(structure_types.I64Rotl, <<0x89>>)
}

pub fn i64_rotr_test() {
  round_trip(structure_types.I64Rotr, <<0x8A>>)
}

pub fn f32_abs_test() {
  round_trip(structure_types.F32Abs, <<0x8B>>)
}

pub fn f32_neg_test() {
  round_trip(structure_types.F32Neg, <<0x8C>>)
}

pub fn f32_ceil_test() {
  round_trip(structure_types.F32Ceil, <<0x8D>>)
}

pub fn f32_floor_test() {
  round_trip(structure_types.F32Floor, <<0x8E>>)
}

pub fn f32_trunc_test() {
  round_trip(structure_types.F32Trunc, <<0x8F>>)
}

pub fn f32_nearest_test() {
  round_trip(structure_types.F32Nearest, <<0x90>>)
}

pub fn f32_sqrt_test() {
  round_trip(structure_types.F32Sqrt, <<0x91>>)
}

pub fn f32_add_test() {
  round_trip(structure_types.F32Add, <<0x92>>)
}

pub fn f32_sub_test() {
  round_trip(structure_types.F32Sub, <<0x93>>)
}

pub fn f32_mul_test() {
  round_trip(structure_types.F32Mul, <<0x94>>)
}

pub fn f32_div_test() {
  round_trip(structure_types.F32Div, <<0x95>>)
}

pub fn f32_min_test() {
  round_trip(structure_types.F32Min, <<0x96>>)
}

pub fn f32_max_test() {
  round_trip(structure_types.F32Max, <<0x97>>)
}

pub fn f32_copysign_test() {
  round_trip(structure_types.F32Copysign, <<0x98>>)
}

pub fn f64_abs_test() {
  round_trip(structure_types.F64Abs, <<0x99>>)
}

pub fn f64_neg_test() {
  round_trip(structure_types.F64Neg, <<0x9A>>)
}

pub fn f64_ceil_test() {
  round_trip(structure_types.F64Ceil, <<0x9B>>)
}

pub fn f64_floor_test() {
  round_trip(structure_types.F64Floor, <<0x9C>>)
}

pub fn f64_trunc_test() {
  round_trip(structure_types.F64Trunc, <<0x9D>>)
}

pub fn f64_nearest_test() {
  round_trip(structure_types.F64Nearest, <<0x9E>>)
}

pub fn f64_sqrt_test() {
  round_trip(structure_types.F64Sqrt, <<0x9F>>)
}

pub fn f64_add_test() {
  round_trip(structure_types.F64Add, <<0xA0>>)
}

pub fn f64_sub_test() {
  round_trip(structure_types.F64Sub, <<0xA1>>)
}

pub fn f64_mul_test() {
  round_trip(structure_types.F64Mul, <<0xA2>>)
}

pub fn f64_div_test() {
  round_trip(structure_types.F64Div, <<0xA3>>)
}

pub fn f64_min_test() {
  round_trip(structure_types.F64Min, <<0xA4>>)
}

pub fn f64_max_test() {
  round_trip(structure_types.F64Max, <<0xA5>>)
}

pub fn f64_copysign_test() {
  round_trip(structure_types.F64Copysign, <<0xA6>>)
}

pub fn i32_wrap_i64_test() {
  round_trip(structure_types.I32WrapI64, <<0xA7>>)
}

pub fn i32_trunc_f32s_test() {
  round_trip(structure_types.I32TruncF32S, <<0xA8>>)
}

pub fn i32_trunc_f32u_test() {
  round_trip(structure_types.I32TruncF32U, <<0xA9>>)
}

pub fn i32_trunc_f64s_test() {
  round_trip(structure_types.I32TruncF64S, <<0xAA>>)
}

pub fn i32_trunc_f64u_test() {
  round_trip(structure_types.I32TruncF64U, <<0xAB>>)
}

pub fn i64_extend_i32s_test() {
  round_trip(structure_types.I64ExtendI32S, <<0xAC>>)
}

pub fn i64_extend_i32u_test() {
  round_trip(structure_types.I64ExtendI32U, <<0xAD>>)
}

pub fn i64_trunc_f32s_test() {
  round_trip(structure_types.I64TruncF32S, <<0xAE>>)
}

pub fn i64_trunc_f32u_test() {
  round_trip(structure_types.I64TruncF32U, <<0xAF>>)
}

pub fn i64_trunc_f64s_test() {
  round_trip(structure_types.I64TruncF64S, <<0xB0>>)
}

pub fn i64_trunc_f64u_test() {
  round_trip(structure_types.I64TruncF64U, <<0xB1>>)
}

pub fn f32_convert_i32s_test() {
  round_trip(structure_types.F32ConvertI32S, <<0xB2>>)
}

pub fn f32_convert_i32u_test() {
  round_trip(structure_types.F32ConvertI32U, <<0xB3>>)
}

pub fn f32_convert_i64s_test() {
  round_trip(structure_types.F32ConvertI64S, <<0xB4>>)
}

pub fn f32_convert_i64u_test() {
  round_trip(structure_types.F32ConvertI64U, <<0xB5>>)
}

pub fn f32_demote_f64_test() {
  round_trip(structure_types.F32DemoteF64, <<0xB6>>)
}

pub fn f64_convert_i32s_test() {
  round_trip(structure_types.F64ConvertI32S, <<0xB7>>)
}

pub fn f64_convert_i32u_test() {
  round_trip(structure_types.F64ConvertI32U, <<0xB8>>)
}

pub fn f64_convert_i64s_test() {
  round_trip(structure_types.F64ConvertI64S, <<0xB9>>)
}

pub fn f64_convert_i64u_test() {
  round_trip(structure_types.F64ConvertI64U, <<0xBA>>)
}

pub fn f64_promote_f32_test() {
  round_trip(structure_types.F64PromoteF32, <<0xBB>>)
}

pub fn i32_reinterpret_f32_test() {
  round_trip(structure_types.I32ReinterpretF32, <<0xBC>>)
}

pub fn i64_reinterpret_f64_test() {
  round_trip(structure_types.I64ReinterpretF64, <<0xBD>>)
}

pub fn f32_reinterpret_i32_test() {
  round_trip(structure_types.F32ReinterpretI32, <<0xBE>>)
}

pub fn f64_reinterpret_i64_test() {
  round_trip(structure_types.F64ReinterpretI64, <<0xBF>>)
}

pub fn i32_extend8s_test() {
  round_trip(structure_types.I32Extend8S, <<0xC0>>)
}

pub fn i32_extend16s_test() {
  round_trip(structure_types.I32Extend16S, <<0xC1>>)
}

pub fn i64_extend8s_test() {
  round_trip(structure_types.I64Extend8S, <<0xC2>>)
}

pub fn i64_extend16s_test() {
  round_trip(structure_types.I64Extend16S, <<0xC3>>)
}

pub fn i64_extend32s_test() {
  round_trip(structure_types.I64Extend32S, <<0xC4>>)
}

pub fn br_on_cast_test() {
  let assert Ok(label_idx) = numbers.u32(42)
  let label_idx = structure_types.LabelIDX(label_idx)
  let ht1 = structure_types.HeapTypeRefType(structure_types.I31HeapType, False)
  let ht2 = structure_types.HeapTypeRefType(structure_types.FuncHeapType, True)

  round_trip(structure_types.BrOnCast(label_idx, ht1, ht2), <<
    0xFB, 24, 0x02, 42, 0x6C, 0x70,
  >>)
}

pub fn br_on_cast_fail_test() {
  let assert Ok(label_idx) = numbers.u32(42)
  let label_idx = structure_types.LabelIDX(label_idx)
  let ht1 = structure_types.HeapTypeRefType(structure_types.I31HeapType, False)
  let ht2 = structure_types.HeapTypeRefType(structure_types.FuncHeapType, True)

  round_trip(structure_types.BrOnCastFail(label_idx, ht1, ht2), <<
    0xFB, 25, 0x02, 42, 0x6C, 0x70,
  >>)
}

pub fn select_test() {
  round_trip(structure_types.Select, <<0x1B>>)
}

pub fn select_t_test() {
  let val_types_list = [
    structure_types.I32ValType,
    structure_types.I64ValType,
    structure_types.F32ValType,
    structure_types.F64ValType,
  ]
  let val_types = shine_tree.from_list(val_types_list)

  let assert Ok(#(structure_types.SelectT(actual_val_types), <<>>)) =
    types.decode_instruction(<<0x1C, 0x04, 0x7F, 0x7E, 0x7D, 0x7C>>)

  actual_val_types
  |> shine_tree.to_list
  |> should.equal(val_types_list)

  let assert Ok(builder) =
    types.encode_instruction(
      bytes_builder.new(),
      structure_types.SelectT(val_types),
    )
  builder
  |> bytes_builder.to_bit_array
  |> should.equal(<<0x1C, 0x04, 0x7F, 0x7E, 0x7D, 0x7C>>)
}

pub fn local_get_test() {
  let assert Ok(local_idx) = numbers.u32(42)
  let local_idx = structure_types.LocalIDX(local_idx)
  round_trip(structure_types.LocalGet(local_idx), <<0x20, 42>>)
}

pub fn local_set_test() {
  let assert Ok(local_idx) = numbers.u32(42)
  let local_idx = structure_types.LocalIDX(local_idx)
  round_trip(structure_types.LocalSet(local_idx), <<0x21, 42>>)
}

pub fn local_tee_test() {
  let assert Ok(local_idx) = numbers.u32(42)
  let local_idx = structure_types.LocalIDX(local_idx)
  round_trip(structure_types.LocalTee(local_idx), <<0x22, 42>>)
}

pub fn global_get_test() {
  let assert Ok(global_idx) = numbers.u32(42)
  let global_idx = structure_types.GlobalIDX(global_idx)
  round_trip(structure_types.GlobalGet(global_idx), <<0x23, 42>>)
}

pub fn global_set_test() {
  let assert Ok(global_idx) = numbers.u32(42)
  let global_idx = structure_types.GlobalIDX(global_idx)
  round_trip(structure_types.GlobalSet(global_idx), <<0x24, 42>>)
}

pub fn table_get_test() {
  let assert Ok(table_idx) = numbers.u32(42)
  let table_idx = structure_types.TableIDX(table_idx)

  round_trip(structure_types.TableGet(table_idx), <<0x25, 42>>)
}

pub fn table_set_test() {
  let assert Ok(table_idx) = numbers.u32(42)
  let table_idx = structure_types.TableIDX(table_idx)

  round_trip(structure_types.TableSet(table_idx), <<0x26, 42>>)
}

pub fn i32_load_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I32Load(mem_arg), <<0x28, 10, 20>>)
}

pub fn i64_load_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I64Load(mem_arg), <<0x29, 10, 20>>)
}

pub fn f32_load_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.F32Load(mem_arg), <<0x2A, 10, 20>>)
}

pub fn f64_load_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.F64Load(mem_arg), <<0x2B, 10, 20>>)
}

pub fn i32_load8s_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I32Load8S(mem_arg), <<0x2C, 10, 20>>)
}

pub fn i32_load8u_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I32Load8U(mem_arg), <<0x2D, 10, 20>>)
}

pub fn i32_load16s_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I32Load16S(mem_arg), <<0x2E, 10, 20>>)
}

pub fn i32_load16u_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I32Load16U(mem_arg), <<0x2F, 10, 20>>)
}

pub fn i64_load8s_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I64Load8S(mem_arg), <<0x30, 10, 20>>)
}

pub fn i64_load8u_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I64Load8U(mem_arg), <<0x31, 10, 20>>)
}

pub fn i64_load16s_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I64Load16S(mem_arg), <<0x32, 10, 20>>)
}

pub fn i64_load16u_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I64Load16U(mem_arg), <<0x33, 10, 20>>)
}

pub fn i64_load32s_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I64Load32S(mem_arg), <<0x34, 10, 20>>)
}

pub fn i64_load32u_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I64Load32U(mem_arg), <<0x35, 10, 20>>)
}

pub fn i32_store_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I32Store(mem_arg), <<0x36, 10, 20>>)
}

pub fn i64_store_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I64Store(mem_arg), <<0x37, 10, 20>>)
}

pub fn f32_store_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.F32Store(mem_arg), <<0x38, 10, 20>>)
}

pub fn f64_store_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.F64Store(mem_arg), <<0x39, 10, 20>>)
}

pub fn i32_store8_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I32Store8(mem_arg), <<0x3A, 10, 20>>)
}

pub fn i32_store16_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I32Store16(mem_arg), <<0x3B, 10, 20>>)
}

pub fn i64_store8_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I64Store8(mem_arg), <<0x3C, 10, 20>>)
}

pub fn i64_store16_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I64Store16(mem_arg), <<0x3D, 10, 20>>)
}

pub fn i64_store32_test() {
  let assert Ok(align) = numbers.u32(10)
  let assert Ok(offset) = numbers.u32(20)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.I64Store32(mem_arg), <<0x3E, 10, 20>>)
}

pub fn memory_size_test() {
  round_trip(structure_types.MemorySize, <<0x3F, 0x00>>)
}

pub fn memory_grow_test() {
  round_trip(structure_types.MemoryGrow, <<0x40, 0x00>>)
}

pub fn i32_const_test() {
  let assert Ok(val) = numbers.i32(42)

  round_trip(structure_types.I32Const(val), <<0x41, 42>>)
}

pub fn i64_const_test() {
  let assert Ok(val) = numbers.i64(42)

  round_trip(structure_types.I64Const(val), <<0x42, 42>>)
}

pub fn f32_const_test() {
  let val = numbers.f32(42.0)
  round_trip(structure_types.F32Const(val), <<
    0x43,
    { ieee_float.to_bytes_32_le(42.0 |> ieee_float.finite) }:bits,
  >>)
}

pub fn f64_const_test() {
  let val = numbers.f64(42.0)
  round_trip(structure_types.F64Const(val), <<
    0x44,
    { ieee_float.to_bytes_64_le(42.0 |> ieee_float.finite) }:bits,
  >>)
}

pub fn ref_null_test() {
  let ht = structure_types.I31HeapType

  round_trip(structure_types.RefNull(ht), <<0xD0, 0x6C>>)
}

pub fn ref_is_null_test() {
  round_trip(structure_types.RefIsNull, <<0xD1>>)
}

pub fn ref_func_test() {
  let assert Ok(func_idx) = numbers.u32(42)
  let func_idx = structure_types.FuncIDX(func_idx)
  round_trip(structure_types.RefFunc(func_idx), <<0xD2, 42>>)
}

pub fn ref_eq_test() {
  round_trip(structure_types.RefEq, <<0xD3>>)
}

pub fn ref_as_non_null_test() {
  round_trip(structure_types.RefAsNonNull, <<0xD4>>)
}

pub fn struct_new_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  round_trip(structure_types.StructNew(type_idx), <<0xFB, 0, 42>>)
}

pub fn struct_new_default_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  round_trip(structure_types.StructNewDefault(type_idx), <<0xFB, 1, 42>>)
}

pub fn struct_get_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  let assert Ok(field_idx) = numbers.u32(4)
  let field_idx = structure_types.FieldIDX(field_idx)
  round_trip(structure_types.StructGet(type_idx, field_idx), <<0xFB, 2, 42, 4>>)
}

pub fn struct_get_s_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  let assert Ok(field_idx) = numbers.u32(4)
  let field_idx = structure_types.FieldIDX(field_idx)
  round_trip(structure_types.StructGetS(type_idx, field_idx), <<0xFB, 3, 42, 4>>)
}

pub fn struct_get_u_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  let assert Ok(field_idx) = numbers.u32(4)
  let field_idx = structure_types.FieldIDX(field_idx)
  round_trip(structure_types.StructGetU(type_idx, field_idx), <<0xFB, 4, 42, 4>>)
}

pub fn struct_set_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  let assert Ok(field_idx) = numbers.u32(4)
  let field_idx = structure_types.FieldIDX(field_idx)
  round_trip(structure_types.StructSet(type_idx, field_idx), <<0xFB, 5, 42, 4>>)
}

pub fn array_new_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)

  round_trip(structure_types.ArrayNew(type_idx), <<0xFB, 6, 42>>)
}

pub fn array_new_default_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)

  round_trip(structure_types.ArrayNewDefault(type_idx), <<0xFB, 7, 42>>)
}

pub fn array_new_fixed_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  let assert Ok(size) = numbers.u32(4)

  round_trip(structure_types.ArrayNewFixed(type_idx, size), <<0xFB, 8, 42, 4>>)
}

pub fn array_new_data_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  let assert Ok(data_idx) = numbers.u32(4)
  let data_idx = structure_types.DataIDX(data_idx)
  round_trip(structure_types.ArrayNewData(type_idx, data_idx), <<
    0xFB, 9, 42, 4,
  >>)
}

pub fn array_new_elem_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  let assert Ok(elem_idx) = numbers.u32(4)
  let elem_idx = structure_types.ElemIDX(elem_idx)
  round_trip(structure_types.ArrayNewElem(type_idx, elem_idx), <<
    0xFB, 10, 42, 4,
  >>)
}

pub fn array_get_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  round_trip(structure_types.ArrayGet(type_idx), <<0xFB, 11, 42>>)
}

pub fn array_get_s_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  round_trip(structure_types.ArrayGetS(type_idx), <<0xFB, 12, 42>>)
}

pub fn array_get_u_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  round_trip(structure_types.ArrayGetU(type_idx), <<0xFB, 13, 42>>)
}

pub fn array_set_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  round_trip(structure_types.ArraySet(type_idx), <<0xFB, 14, 42>>)
}

pub fn array_len_test() {
  round_trip(structure_types.ArrayLen, <<0xFB, 15>>)
}

pub fn array_fill_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  round_trip(structure_types.ArrayFill(type_idx), <<0xFB, 16, 42>>)
}

pub fn array_copy_test() {
  let assert Ok(type_idx1) = numbers.u32(42)
  let type_idx1 = structure_types.TypeIDX(type_idx1)
  let assert Ok(type_idx2) = numbers.u32(20)
  let type_idx2 = structure_types.TypeIDX(type_idx2)

  round_trip(structure_types.ArrayCopy(type_idx1, type_idx2), <<
    0xFB, 17, 42, 20,
  >>)
}

pub fn array_init_data_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  let assert Ok(data_idx) = numbers.u32(4)
  let data_idx = structure_types.DataIDX(data_idx)
  round_trip(structure_types.ArrayInitData(type_idx, data_idx), <<
    0xFB, 18, 42, 4,
  >>)
}

pub fn array_init_elem_test() {
  let assert Ok(type_idx) = numbers.u32(42)
  let type_idx = structure_types.TypeIDX(type_idx)
  let assert Ok(elem_idx) = numbers.u32(4)
  let elem_idx = structure_types.ElemIDX(elem_idx)
  round_trip(structure_types.ArrayInitElem(type_idx, elem_idx), <<
    0xFB, 19, 42, 4,
  >>)
}

pub fn ref_test_test() {
  round_trip(structure_types.RefTest(structure_types.ArrayHeapType), <<
    0xFB, 20, 0x6A,
  >>)
}

pub fn ref_test_nullable_test() {
  round_trip(structure_types.RefTestNullable(structure_types.ArrayHeapType), <<
    0xFB, 21, 0x6A,
  >>)
}

pub fn ref_cast_test() {
  round_trip(structure_types.RefCast(structure_types.ArrayHeapType), <<
    0xFB, 22, 0x6A,
  >>)
}

pub fn ref_cast_nullable_test() {
  round_trip(structure_types.RefCastNullable(structure_types.ArrayHeapType), <<
    0xFB, 23, 0x6A,
  >>)
}

pub fn any_convert_extern_test() {
  round_trip(structure_types.AnyConvertExtern, <<0xFB, 26>>)
}

pub fn extern_convert_any_test() {
  round_trip(structure_types.ExternConvertAny, <<0xFB, 27>>)
}

pub fn ref_i31_test() {
  round_trip(structure_types.RefI31, <<0xFB, 28>>)
}

pub fn i31_get_s_test() {
  round_trip(structure_types.I31GetS, <<0xFB, 29>>)
}

pub fn i31_get_u_test() {
  round_trip(structure_types.I31GetU, <<0xFB, 30>>)
}

pub fn i32_trunc_sat_f32s_test() {
  round_trip(structure_types.I32TruncSatF32S, <<0xFC, 0>>)
}

pub fn i32_trunc_sat_f32u_test() {
  round_trip(structure_types.I32TruncSatF32U, <<0xFC, 1>>)
}

pub fn i32_trunc_sat_f64s_test() {
  round_trip(structure_types.I32TruncSatF64S, <<0xFC, 2>>)
}

pub fn i32_trunc_sat_f64u_test() {
  round_trip(structure_types.I32TruncSatF64U, <<0xFC, 3>>)
}

pub fn i64_trunc_sat_f32s_test() {
  round_trip(structure_types.I64TruncSatF32S, <<0xFC, 4>>)
}

pub fn i64_trunc_sat_f32u_test() {
  round_trip(structure_types.I64TruncSatF32U, <<0xFC, 5>>)
}

pub fn i64_trunc_sat_f64s_test() {
  round_trip(structure_types.I64TruncSatF64S, <<0xFC, 6>>)
}

pub fn i64_trunc_sat_f64u_test() {
  round_trip(structure_types.I64TruncSatF64U, <<0xFC, 7>>)
}

pub fn memory_init_test() {
  let assert Ok(data_idx) = numbers.u32(42)
  let data_idx = structure_types.DataIDX(data_idx)

  round_trip(structure_types.MemoryInit(data_idx), <<0xFC, 8, 42, 0x00>>)
}

pub fn data_drop_test() {
  let assert Ok(data_idx) = numbers.u32(42)
  let data_idx = structure_types.DataIDX(data_idx)

  round_trip(structure_types.DataDrop(data_idx), <<0xFC, 9, 42>>)
}

pub fn memory_copy_test() {
  round_trip(structure_types.MemoryCopy, <<0xFC, 10, 0x00, 0x00>>)
}

pub fn memory_fill_test() {
  round_trip(structure_types.MemoryFill, <<0xFC, 11, 0x00>>)
}

pub fn table_init_test() {
  let assert Ok(elem_idx) = numbers.u32(42)
  let elem_idx = structure_types.ElemIDX(elem_idx)
  let assert Ok(table_idx) = numbers.u32(4)
  let table_idx = structure_types.TableIDX(table_idx)
  round_trip(structure_types.TableInit(elem_idx, table_idx), <<0xFC, 12, 42, 4>>)
}

pub fn elem_drop_test() {
  let assert Ok(elem_idx) = numbers.u32(42)
  let elem_idx = structure_types.ElemIDX(elem_idx)
  round_trip(structure_types.ElemDrop(elem_idx), <<0xFC, 13, 42>>)
}

pub fn table_copy_test() {
  let assert Ok(dst_table_idx) = numbers.u32(42)
  let dst_table_idx = structure_types.TableIDX(dst_table_idx)
  let assert Ok(src_table_idx) = numbers.u32(4)
  let src_table_idx = structure_types.TableIDX(src_table_idx)
  round_trip(structure_types.TableCopy(dst_table_idx, src_table_idx), <<
    0xFC, 14, 42, 4,
  >>)
}

pub fn table_grow_test() {
  let assert Ok(table_idx) = numbers.u32(42)
  let table_idx = structure_types.TableIDX(table_idx)
  round_trip(structure_types.TableGrow(table_idx), <<0xFC, 15, 42>>)
}

pub fn table_size_test() {
  let assert Ok(table_idx) = numbers.u32(42)
  let table_idx = structure_types.TableIDX(table_idx)
  round_trip(structure_types.TableSize(table_idx), <<0xFC, 16, 42>>)
}

pub fn table_fill_test() {
  let assert Ok(table_idx) = numbers.u32(42)
  let table_idx = structure_types.TableIDX(table_idx)
  round_trip(structure_types.TableFill(table_idx), <<0xFC, 17, 42>>)
}

pub fn v128_load_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(30)

  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.V128Load(mem_arg), <<0xFD, 0x00, 42, 30>>)
}

pub fn v128_load8x8s_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(30)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.V128Load8x8S(mem_arg), <<0xFD, 1, 42, 30>>)
}

pub fn v128_load8x8u_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(30)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.V128Load8x8U(mem_arg), <<0xFD, 2, 42, 30>>)
}

pub fn v128_load16x4s_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(30)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.V128Load16x4S(mem_arg), <<0xFD, 3, 42, 30>>)
}

pub fn v128_load16x4u_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(30)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.V128Load16x4U(mem_arg), <<0xFD, 4, 42, 30>>)
}

pub fn v128_load32x2s_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(30)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.V128Load32x2S(mem_arg), <<0xFD, 5, 42, 30>>)
}

pub fn v128_load32x2u_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(30)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.V128Load32x2U(mem_arg), <<0xFD, 6, 42, 30>>)
}

pub fn v128_load8_splat_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(30)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.V128Load8Splat(mem_arg), <<0xFD, 7, 42, 30>>)
}

pub fn v128_load16_splat_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(30)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.V128Load16Splat(mem_arg), <<0xFD, 8, 42, 30>>)
}

pub fn v128_load32_splat_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(30)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.V128Load32Splat(mem_arg), <<0xFD, 9, 42, 30>>)
}

pub fn v128_load64_splat_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(30)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.V128Load64Splat(mem_arg), <<0xFD, 10, 42, 30>>)
}

pub fn v128_store_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(30)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.V128Store(mem_arg), <<0xFD, 11, 42, 30>>)
}

pub fn v128_const_test() {
  let assert Ok(v128_val) =
    numbers.v128(<<
      0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B,
      0x0C, 0x0D, 0x0E, 0x0F,
    >>)
  round_trip(structure_types.V128Const(v128_val), <<
    0xFD, 12, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A,
    0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
  >>)
}

pub fn i8x16_shuffle_test() {
  let assert Ok(lane_0) = structure_types.lane_16(0x00)
  let assert Ok(lane_1) = structure_types.lane_16(0x01)
  let assert Ok(lane_2) = structure_types.lane_16(0x02)
  let assert Ok(lane_3) = structure_types.lane_16(0x03)
  let assert Ok(lane_4) = structure_types.lane_16(0x04)
  let assert Ok(lane_5) = structure_types.lane_16(0x05)
  let assert Ok(lane_6) = structure_types.lane_16(0x06)
  let assert Ok(lane_7) = structure_types.lane_16(0x07)
  let assert Ok(lane_8) = structure_types.lane_16(0x08)
  let assert Ok(lane_9) = structure_types.lane_16(0x09)
  let assert Ok(lane_a) = structure_types.lane_16(0x0a)
  let assert Ok(lane_b) = structure_types.lane_16(0x0b)
  let assert Ok(lane_c) = structure_types.lane_16(0x0c)
  let assert Ok(lane_d) = structure_types.lane_16(0x0d)
  let assert Ok(lane_e) = structure_types.lane_16(0x0e)
  let assert Ok(lane_f) = structure_types.lane_16(0x0f)

  round_trip(
    structure_types.I8x16Shuffle(
      lane_0,
      lane_1,
      lane_2,
      lane_3,
      lane_4,
      lane_5,
      lane_6,
      lane_7,
      lane_8,
      lane_9,
      lane_a,
      lane_b,
      lane_c,
      lane_d,
      lane_e,
      lane_f,
    ),
    <<
      0xFD, 13, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A,
      0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
    >>,
  )
}

pub fn i8x16_swizzle_test() {
  round_trip(structure_types.I8x16Swizzle, <<0xFD, 14>>)
}

pub fn i8x16_splat_test() {
  round_trip(structure_types.I8x16Splat, <<0xFD, 15>>)
}

pub fn i16x8_splat_test() {
  round_trip(structure_types.I16x8Splat, <<0xFD, 16>>)
}

pub fn i32x4_splat_test() {
  round_trip(structure_types.I32x4Splat, <<0xFD, 17>>)
}

pub fn i64x2_splat_test() {
  round_trip(structure_types.I64x2Splat, <<0xFD, 18>>)
}

pub fn f32x4_splat_test() {
  round_trip(structure_types.F32x4Splat, <<0xFD, 19>>)
}

pub fn f64x2_splat_test() {
  round_trip(structure_types.F64x2Splat, <<0xFD, 20>>)
}

// lane_idx
pub fn i8x16_extract_lane_s_test() {
  let assert Ok(lane_idx) = structure_types.lane_16(2)
  round_trip(structure_types.I8x16ExtractLaneS(lane_idx), <<0xFD, 21, 2>>)
}

pub fn i8x16_extract_lane_u_test() {
  let assert Ok(lane_idx) = structure_types.lane_16(2)
  round_trip(structure_types.I8x16ExtractLaneU(lane_idx), <<0xFD, 22, 2>>)
}

pub fn i8x16_replace_lane_test() {
  let assert Ok(lane_idx) = structure_types.lane_16(2)
  round_trip(structure_types.I8x16ReplaceLane(lane_idx), <<0xFD, 23, 2>>)
}

pub fn i16x8_extract_lane_s_test() {
  let assert Ok(lane_idx) = structure_types.lane_8(2)
  round_trip(structure_types.I16x8ExtractLaneS(lane_idx), <<0xFD, 24, 2>>)
}

pub fn i16x8_extract_lane_u_test() {
  let assert Ok(lane_idx) = structure_types.lane_8(2)
  round_trip(structure_types.I16x8ExtractLaneU(lane_idx), <<0xFD, 25, 2>>)
}

pub fn i16x8_replace_lane_test() {
  let assert Ok(lane_idx) = structure_types.lane_8(2)
  round_trip(structure_types.I16x8ReplaceLane(lane_idx), <<0xFD, 26, 2>>)
}

pub fn i32x4_extract_lane_test() {
  let assert Ok(lane_idx) = structure_types.lane_4(2)
  round_trip(structure_types.I32x4ExtractLane(lane_idx), <<0xFD, 27, 2>>)
}

pub fn i32x4_replace_lane_test() {
  let assert Ok(lane_idx) = structure_types.lane_4(2)
  round_trip(structure_types.I32x4ReplaceLane(lane_idx), <<0xFD, 28, 2>>)
}

pub fn i64x2_extract_lane_test() {
  let assert Ok(lane_idx) = structure_types.lane_2(1)
  round_trip(structure_types.I64x2ExtractLane(lane_idx), <<0xFD, 29, 1>>)
}

pub fn i64x2_replace_lane_test() {
  let assert Ok(lane_idx) = structure_types.lane_2(1)
  round_trip(structure_types.I64x2ReplaceLane(lane_idx), <<0xFD, 30, 1>>)
}

pub fn f32x4_extract_lane_test() {
  let assert Ok(lane_idx) = structure_types.lane_4(2)
  round_trip(structure_types.F32x4ExtractLane(lane_idx), <<0xFD, 31, 2>>)
}

pub fn f32x4_replace_lane_test() {
  let assert Ok(lane_idx) = structure_types.lane_4(2)
  round_trip(structure_types.F32x4ReplaceLane(lane_idx), <<0xFD, 32, 2>>)
}

pub fn f64x2_extract_lane_test() {
  let assert Ok(lane_idx) = structure_types.lane_2(1)
  round_trip(structure_types.F64x2ExtractLane(lane_idx), <<0xFD, 33, 1>>)
}

pub fn f64x2_replace_lane_test() {
  let assert Ok(lane_idx) = structure_types.lane_2(1)
  round_trip(structure_types.F64x2ReplaceLane(lane_idx), <<0xFD, 34, 1>>)
}

pub fn i8x16_eq_test() {
  round_trip(structure_types.I8x16Eq, <<0xFD, 35>>)
}

pub fn i8x16_ne_test() {
  round_trip(structure_types.I8x16Ne, <<0xFD, 36>>)
}

pub fn i8x16_lt_s_test() {
  round_trip(structure_types.I8x16LtS, <<0xFD, 37>>)
}

pub fn i8x16_lt_u_test() {
  round_trip(structure_types.I8x16LtU, <<0xFD, 38>>)
}

pub fn i8x16_gt_s_test() {
  round_trip(structure_types.I8x16GtS, <<0xFD, 39>>)
}

pub fn i8x16_gt_u_test() {
  round_trip(structure_types.I8x16GtU, <<0xFD, 40>>)
}

pub fn i8x16_le_s_test() {
  round_trip(structure_types.I8x16LeS, <<0xFD, 41>>)
}

pub fn i8x16_le_u_test() {
  round_trip(structure_types.I8x16LeU, <<0xFD, 42>>)
}

pub fn i8x16_ge_s_test() {
  round_trip(structure_types.I8x16GeS, <<0xFD, 43>>)
}

pub fn i8x16_ge_u_test() {
  round_trip(structure_types.I8x16GeU, <<0xFD, 44>>)
}

pub fn i16x8_eq_test() {
  round_trip(structure_types.I16x8Eq, <<0xFD, 45>>)
}

pub fn i16x8_ne_test() {
  round_trip(structure_types.I16x8Ne, <<0xFD, 46>>)
}

pub fn i16x8_lt_s_test() {
  round_trip(structure_types.I16x8LtS, <<0xFD, 47>>)
}

pub fn i16x8_lt_u_test() {
  round_trip(structure_types.I16x8LtU, <<0xFD, 48>>)
}

pub fn i16x8_gt_s_test() {
  round_trip(structure_types.I16x8GtS, <<0xFD, 49>>)
}

pub fn i16x8_gt_u_test() {
  round_trip(structure_types.I16x8GtU, <<0xFD, 50>>)
}

pub fn i16x8_le_s_test() {
  round_trip(structure_types.I16x8LeS, <<0xFD, 51>>)
}

pub fn i16x8_le_u_test() {
  round_trip(structure_types.I16x8LeU, <<0xFD, 52>>)
}

pub fn i16x8_ge_s_test() {
  round_trip(structure_types.I16x8GeS, <<0xFD, 53>>)
}

pub fn i16x8_ge_u_test() {
  round_trip(structure_types.I16x8GeU, <<0xFD, 54>>)
}

pub fn i32x4_eq_test() {
  round_trip(structure_types.I32x4Eq, <<0xFD, 55>>)
}

pub fn i32x4_ne_test() {
  round_trip(structure_types.I32x4Ne, <<0xFD, 56>>)
}

pub fn i32x4_lt_s_test() {
  round_trip(structure_types.I32x4LtS, <<0xFD, 57>>)
}

pub fn i32x4_lt_u_test() {
  round_trip(structure_types.I32x4LtU, <<0xFD, 58>>)
}

pub fn i32x4_gt_s_test() {
  round_trip(structure_types.I32x4GtS, <<0xFD, 59>>)
}

pub fn i32x4_gt_u_test() {
  round_trip(structure_types.I32x4GtU, <<0xFD, 60>>)
}

pub fn i32x4_le_s_test() {
  round_trip(structure_types.I32x4LeS, <<0xFD, 61>>)
}

pub fn i32x4_le_u_test() {
  round_trip(structure_types.I32x4LeU, <<0xFD, 62>>)
}

pub fn i32x4_ge_s_test() {
  round_trip(structure_types.I32x4GeS, <<0xFD, 63>>)
}

pub fn i32x4_ge_u_test() {
  round_trip(structure_types.I32x4GeU, <<0xFD, 64>>)
}

pub fn f32x4_eq_test() {
  round_trip(structure_types.F32x4Eq, <<0xFD, 65>>)
}

pub fn i64x2_eq_test() {
  round_trip(structure_types.I64x2Eq, <<0xFD, 214, 1>>)
}

pub fn i64x2_ne_test() {
  round_trip(structure_types.I64x2Ne, <<0xFD, 215, 1>>)
}

pub fn i64x2_lt_s_test() {
  round_trip(structure_types.I64x2LtS, <<0xFD, 216, 1>>)
}

pub fn i64x2_gt_s_test() {
  round_trip(structure_types.I64x2GtS, <<0xFD, 217, 1>>)
}

pub fn i64x2_le_s_test() {
  round_trip(structure_types.I64x2LeS, <<0xFD, 218, 1>>)
}

pub fn i64x2_ge_s_test() {
  round_trip(structure_types.I64x2GeS, <<0xFD, 219, 1>>)
}

pub fn f32x4_ne_test() {
  round_trip(structure_types.F32x4Ne, <<0xFD, 66>>)
}

pub fn f32x4_lt_test() {
  round_trip(structure_types.F32x4Lt, <<0xFD, 67>>)
}

pub fn f32x4_gt_test() {
  round_trip(structure_types.F32x4Gt, <<0xFD, 68>>)
}

pub fn f32x4_le_test() {
  round_trip(structure_types.F32x4Le, <<0xFD, 69>>)
}

pub fn f32x4_ge_test() {
  round_trip(structure_types.F32x4Ge, <<0xFD, 70>>)
}

pub fn f64x2_eq_test() {
  round_trip(structure_types.F64x2Eq, <<0xFD, 71>>)
}

pub fn f64x2_ne_test() {
  round_trip(structure_types.F64x2Ne, <<0xFD, 72>>)
}

pub fn f64x2_lt_test() {
  round_trip(structure_types.F64x2Lt, <<0xFD, 73>>)
}

pub fn f64x2_gt_test() {
  round_trip(structure_types.F64x2Gt, <<0xFD, 74>>)
}

pub fn f64x2_le_test() {
  round_trip(structure_types.F64x2Le, <<0xFD, 75>>)
}

pub fn f64x2_ge_test() {
  round_trip(structure_types.F64x2Ge, <<0xFD, 76>>)
}

pub fn v128_not_test() {
  round_trip(structure_types.V128Not, <<0xFD, 77>>)
}

pub fn v128_and_test() {
  round_trip(structure_types.V128And, <<0xFD, 78>>)
}

pub fn v128_and_not_test() {
  round_trip(structure_types.V128AndNot, <<0xFD, 79>>)
}

pub fn v128_or_test() {
  round_trip(structure_types.V128Or, <<0xFD, 80>>)
}

pub fn v128_xor_test() {
  round_trip(structure_types.V128Xor, <<0xFD, 81>>)
}

pub fn v128_bitselect_test() {
  round_trip(structure_types.V128Bitselect, <<0xFD, 82>>)
}

pub fn v128_any_true_test() {
  round_trip(structure_types.V128AnyTrue, <<0xFD, 83>>)
}

pub fn v128_load8_lane_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(4)
  let mem_arg = structure_types.MemArg(align, offset)
  let assert Ok(lane_idx) = structure_types.lane_16(2)
  round_trip(structure_types.V128Load8Lane(mem_arg, lane_idx), <<
    0xFD, 84, 42, 4, 2,
  >>)
}

pub fn v128_load16_lane_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(4)
  let mem_arg = structure_types.MemArg(align, offset)
  let assert Ok(lane_idx) = structure_types.lane_8(2)
  round_trip(structure_types.V128Load16Lane(mem_arg, lane_idx), <<
    0xFD, 85, 42, 4, 2,
  >>)
}

pub fn v128_load32_lane_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(4)
  let mem_arg = structure_types.MemArg(align, offset)
  let assert Ok(lane_idx) = structure_types.lane_4(2)
  round_trip(structure_types.V128Load32Lane(mem_arg, lane_idx), <<
    0xFD, 86, 42, 4, 2,
  >>)
}

pub fn v128_load64_lane_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(4)
  let mem_arg = structure_types.MemArg(align, offset)
  let assert Ok(lane_idx) = structure_types.lane_2(1)
  round_trip(structure_types.V128Load64Lane(mem_arg, lane_idx), <<
    0xFD, 87, 42, 4, 1,
  >>)
}

pub fn v128_store8_lane_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(4)
  let mem_arg = structure_types.MemArg(align, offset)
  let assert Ok(lane_idx) = structure_types.lane_16(2)
  round_trip(structure_types.V128Store8Lane(mem_arg, lane_idx), <<
    0xFD, 88, 42, 4, 2,
  >>)
}

pub fn v128_store16_lane_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(4)
  let mem_arg = structure_types.MemArg(align, offset)
  let assert Ok(lane_idx) = structure_types.lane_8(2)
  round_trip(structure_types.V128Store16Lane(mem_arg, lane_idx), <<
    0xFD, 89, 42, 4, 2,
  >>)
}

pub fn v128_store32_lane_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(4)
  let mem_arg = structure_types.MemArg(align, offset)
  let assert Ok(lane_idx) = structure_types.lane_4(2)
  round_trip(structure_types.V128Store32Lane(mem_arg, lane_idx), <<
    0xFD, 90, 42, 4, 2,
  >>)
}

pub fn v128_store64_lane_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(4)
  let mem_arg = structure_types.MemArg(align, offset)
  let assert Ok(lane_idx) = structure_types.lane_2(1)
  round_trip(structure_types.V128Store64Lane(mem_arg, lane_idx), <<
    0xFD, 91, 42, 4, 1,
  >>)
}

pub fn v128_load32_zero_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(4)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.V128Load32Zero(mem_arg), <<0xFD, 92, 42, 4>>)
}

pub fn v128_load64_zero_test() {
  let assert Ok(align) = numbers.u32(42)
  let assert Ok(offset) = numbers.u32(4)
  let mem_arg = structure_types.MemArg(align, offset)
  round_trip(structure_types.V128Load64Zero(mem_arg), <<0xFD, 93, 42, 4>>)
}

pub fn f32x4_demote_f64x2_zero_test() {
  round_trip(structure_types.F32x4DemoteF64x2Zero, <<0xFD, 94>>)
}

pub fn f64x2_promote_low_f32x4_test() {
  round_trip(structure_types.F64x2PromoteLowF32x4, <<0xFD, 95>>)
}

pub fn i8x16_abs_test() {
  round_trip(structure_types.I8x16Abs, <<0xFD, 96>>)
}

pub fn i8x16_neg_test() {
  round_trip(structure_types.I8x16Neg, <<0xFD, 97>>)
}

pub fn i8x16_popcnt_test() {
  round_trip(structure_types.I8x16Popcnt, <<0xFD, 98>>)
}

pub fn i8x16_all_true_test() {
  round_trip(structure_types.I8x16AllTrue, <<0xFD, 99>>)
}

pub fn i8x16_bitmask_test() {
  round_trip(structure_types.I8x16Bitmask, <<0xFD, 100>>)
}

pub fn i8x16_narrow_i16x8s_test() {
  round_trip(structure_types.I8x16NarrowI16x8S, <<0xFD, 101>>)
}

pub fn i8x16_narrow_i16x8u_test() {
  // 0xFD, 102
  round_trip(structure_types.I8x16NarrowI16x8U, <<0xFD, 102>>)
}

pub fn f32x4_ceil_test() {
  round_trip(structure_types.F32x4Ceil, <<0xFD, 103>>)
}

pub fn f32x4_floor_test() {
  round_trip(structure_types.F32x4Floor, <<0xFD, 104>>)
}

pub fn f32x4_trunc_test() {
  round_trip(structure_types.F32x4Trunc, <<0xFD, 105>>)
}

pub fn f32x4_nearest_test() {
  round_trip(structure_types.F32x4Nearest, <<0xFD, 106>>)
}

pub fn i8x16_shl_test() {
  round_trip(structure_types.I8x16Shl, <<0xFD, 107>>)
}

pub fn i8x16_shr_s_test() {
  round_trip(structure_types.I8x16ShrS, <<0xFD, 108>>)
}

pub fn i8x16_shr_u_test() {
  round_trip(structure_types.I8x16ShrU, <<0xFD, 109>>)
}

pub fn i8x16_add_test() {
  round_trip(structure_types.I8x16Add, <<0xFD, 110>>)
}

pub fn i8x16_add_sat_s_test() {
  round_trip(structure_types.I8x16AddSatS, <<0xFD, 111>>)
}

pub fn i8x16_add_sat_u_test() {
  round_trip(structure_types.I8x16AddSatU, <<0xFD, 112>>)
}

pub fn i8x16_sub_test() {
  round_trip(structure_types.I8x16Sub, <<0xFD, 113>>)
}

pub fn i8x16_sub_sat_s_test() {
  round_trip(structure_types.I8x16SubSatS, <<0xFD, 114>>)
}

pub fn i8x16_sub_sat_u_test() {
  round_trip(structure_types.I8x16SubSatU, <<0xFD, 115>>)
}

pub fn f64x2_ceil_test() {
  round_trip(structure_types.F64x2Ceil, <<0xFD, 116>>)
}

pub fn f64x2_floor_test() {
  round_trip(structure_types.F64x2Floor, <<0xFD, 117>>)
}

pub fn i8x16_min_s_test() {
  round_trip(structure_types.I8x16MinS, <<0xFD, 118>>)
}

pub fn i8x16_min_u_test() {
  round_trip(structure_types.I8x16MinU, <<0xFD, 119>>)
}

pub fn i8x16_max_s_test() {
  round_trip(structure_types.I8x16MaxS, <<0xFD, 120>>)
}

pub fn i8x16_max_u_test() {
  round_trip(structure_types.I8x16MaxU, <<0xFD, 121>>)
}

pub fn f64x2_trunc_test() {
  round_trip(structure_types.F64x2Trunc, <<0xFD, 122>>)
}

pub fn i8x16_avgr_u_test() {
  round_trip(structure_types.I8x16AvgrU, <<0xFD, 123>>)
}

pub fn i16x8_extadd_pairwise_i8x16s_test() {
  round_trip(structure_types.I16x8ExtaddPairwiseI8x16S, <<0xFD, 124>>)
}

pub fn i16x8_extadd_pairwise_i8x16u_test() {
  round_trip(structure_types.I16x8ExtaddPairwiseI8x16U, <<0xFD, 125>>)
}

pub fn i32x4_extadd_pairwise_i16x8s_test() {
  round_trip(structure_types.I32x4ExtaddPairwiseI16x8S, <<0xFD, 126>>)
}

pub fn i32x4_extadd_pairwise_i16x8u_test() {
  round_trip(structure_types.I32x4ExtaddPairwiseI16x8U, <<0xFD, 127>>)
}

pub fn i16x8_abs_test() {
  round_trip(structure_types.I16x8Abs, <<0xFD, 128, 1>>)
}

pub fn i16x8_neg_test() {
  round_trip(structure_types.I16x8Neg, <<0xFD, 129, 1>>)
}

pub fn i16x8q15mulr_sat_s_test() {
  round_trip(structure_types.I16x8Q15mulrSatS, <<0xFD, 130, 1>>)
}

pub fn i16x8_all_true_test() {
  round_trip(structure_types.I16x8AllTrue, <<0xFD, 131, 1>>)
}

pub fn i16x8_bitmask_test() {
  round_trip(structure_types.I16x8Bitmask, <<0xFD, 132, 1>>)
}

pub fn i16x8_narrow_i32x4s_test() {
  round_trip(structure_types.I16x8NarrowI32x4S, <<0xFD, 133, 1>>)
}

pub fn i16x8_narrow_i32x4u_test() {
  round_trip(structure_types.I16x8NarrowI32x4U, <<0xFD, 134, 1>>)
}

pub fn i16x8_extend_low_i8x16s_test() {
  round_trip(structure_types.I16x8ExtendLowI8x16S, <<0xFD, 135, 1>>)
}

pub fn i16x8_extend_high_i8x16s_test() {
  round_trip(structure_types.I16x8ExtendHighI8x16S, <<0xFD, 136, 1>>)
}

pub fn i16x8_extend_low_i8x16u_test() {
  round_trip(structure_types.I16x8ExtendLowI8x16U, <<0xFD, 137, 1>>)
}

pub fn i16x8_extend_high_i8x16u_test() {
  round_trip(structure_types.I16x8ExtendHighI8x16U, <<0xFD, 138, 1>>)
}

pub fn i16x8_shl_test() {
  round_trip(structure_types.I16x8Shl, <<0xFD, 139, 1>>)
}

pub fn i16x8_shr_s_test() {
  round_trip(structure_types.I16x8ShrS, <<0xFD, 140, 1>>)
}

pub fn i16x8_shr_u_test() {
  round_trip(structure_types.I16x8ShrU, <<0xFD, 141, 1>>)
}

pub fn i16x8_add_test() {
  round_trip(structure_types.I16x8Add, <<0xFD, 142, 1>>)
}

pub fn i16x8_add_sat_s_test() {
  round_trip(structure_types.I16x8AddSatS, <<0xFD, 143, 1>>)
}

pub fn i16x8_add_sat_u_test() {
  round_trip(structure_types.I16x8AddSatU, <<0xFD, 144, 1>>)
}

pub fn i16x8_sub_test() {
  round_trip(structure_types.I16x8Sub, <<0xFD, 145, 1>>)
}

pub fn i16x8_sub_sat_s_test() {
  round_trip(structure_types.I16x8SubSatS, <<0xFD, 146, 1>>)
}

pub fn i16x8_sub_sat_u_test() {
  round_trip(structure_types.I16x8SubSatU, <<0xFD, 147, 1>>)
}

pub fn f64x2_nearest_test() {
  round_trip(structure_types.F64x2Nearest, <<0xFD, 148, 1>>)
}

pub fn i16x8_mul_test() {
  round_trip(structure_types.I16x8Mul, <<0xFD, 149, 1>>)
}

pub fn i16x8_min_s_test() {
  round_trip(structure_types.I16x8MinS, <<0xFD, 150, 1>>)
}

pub fn i16x8_min_u_test() {
  round_trip(structure_types.I16x8MinU, <<0xFD, 151, 1>>)
}

pub fn i16x8_max_s_test() {
  round_trip(structure_types.I16x8MaxS, <<0xFD, 152, 1>>)
}

pub fn i16x8_max_u_test() {
  round_trip(structure_types.I16x8MaxU, <<0xFD, 153, 1>>)
}

pub fn i16x8_avgr_u_test() {
  round_trip(structure_types.I16x8AvgrU, <<0xFD, 155, 1>>)
}

pub fn i16x8_extmul_low_i8x16s_test() {
  round_trip(structure_types.I16x8ExtmulLowI8x16S, <<0xFD, 156, 1>>)
}

pub fn i16x8_extmul_high_i8x16s_test() {
  round_trip(structure_types.I16x8ExtmulHighI8x16S, <<0xFD, 157, 1>>)
}

pub fn i16x8_extmul_low_i8x16u_test() {
  round_trip(structure_types.I16x8ExtmulLowI8x16U, <<0xFD, 158, 1>>)
}

pub fn i16x8_extmul_high_i8x16u_test() {
  round_trip(structure_types.I16x8ExtmulHighI8x16U, <<0xFD, 159, 1>>)
}

pub fn i32x4_abs_test() {
  round_trip(structure_types.I32x4Abs, <<0xFD, 160, 1>>)
}

pub fn i32x4_neg_test() {
  round_trip(structure_types.I32x4Neg, <<0xFD, 161, 1>>)
}

pub fn i32x4_all_true_test() {
  round_trip(structure_types.I32x4AllTrue, <<0xFD, 163, 1>>)
}

pub fn i32x4_bitmask_test() {
  round_trip(structure_types.I32x4Bitmask, <<0xFD, 164, 1>>)
}

pub fn i32x4_extend_low_i16x8s_test() {
  round_trip(structure_types.I32x4ExtendLowI16x8S, <<0xFD, 167, 1>>)
}

pub fn i32x4_extend_high_i16x8s_test() {
  round_trip(structure_types.I32x4ExtendHighI16x8S, <<0xFD, 168, 1>>)
}

pub fn i32x4_extend_low_i16x8u_test() {
  round_trip(structure_types.I32x4ExtendLowI16x8U, <<0xFD, 169, 1>>)
}

pub fn i32x4_extend_high_i16x8u_test() {
  round_trip(structure_types.I32x4ExtendHighI16x8U, <<0xFD, 170, 1>>)
}

pub fn i32x4_shl_test() {
  round_trip(structure_types.I32x4Shl, <<0xFD, 171, 1>>)
}

pub fn i32x4_shr_s_test() {
  round_trip(structure_types.I32x4ShrS, <<0xFD, 172, 1>>)
}

pub fn i32x4_shr_u_test() {
  round_trip(structure_types.I32x4ShrU, <<0xFD, 173, 1>>)
}

pub fn i32x4_add_test() {
  round_trip(structure_types.I32x4Add, <<0xFD, 174, 1>>)
}

pub fn i32x4_sub_test() {
  round_trip(structure_types.I32x4Sub, <<0xFD, 177, 1>>)
}

pub fn i32x4_mul_test() {
  round_trip(structure_types.I32x4Mul, <<0xFD, 181, 1>>)
}

pub fn i32x4_min_s_test() {
  round_trip(structure_types.I32x4MinS, <<0xFD, 182, 1>>)
}

pub fn i32x4_min_u_test() {
  round_trip(structure_types.I32x4MinU, <<0xFD, 183, 1>>)
}

pub fn i32x4_max_s_test() {
  round_trip(structure_types.I32x4MaxS, <<0xFD, 184, 1>>)
}

pub fn i32x4_max_u_test() {
  round_trip(structure_types.I32x4MaxU, <<0xFD, 185, 1>>)
}

pub fn i32x4_dot_i16x8s_test() {
  round_trip(structure_types.I32x4DotI16x8S, <<0xFD, 186, 1>>)
}

pub fn i32x4_extmul_low_i16x8s_test() {
  round_trip(structure_types.I32x4ExtmulLowI16x8S, <<0xFD, 188, 1>>)
}

pub fn i32x4_extmul_high_i16x8s_test() {
  round_trip(structure_types.I32x4ExtmulHighI16x8S, <<0xFD, 189, 1>>)
}

pub fn i32x4_extmul_low_i16x8u_test() {
  round_trip(structure_types.I32x4ExtmulLowI16x8U, <<0xFD, 190, 1>>)
}

pub fn i32x4_extmul_high_i16x8u_test() {
  round_trip(structure_types.I32x4ExtmulHighI16x8U, <<0xFD, 191, 1>>)
}

pub fn i64x2_abs_test() {
  round_trip(structure_types.I64x2Abs, <<0xFD, 192, 1>>)
}

pub fn i64x2_neg_test() {
  round_trip(structure_types.I64x2Neg, <<0xFD, 193, 1>>)
}

pub fn i64x2_all_true_test() {
  round_trip(structure_types.I64x2AllTrue, <<0xFD, 195, 1>>)
}

pub fn i64x2_bitmask_test() {
  round_trip(structure_types.I64x2Bitmask, <<0xFD, 196, 1>>)
}

pub fn i64x2_extend_low_i32x4s_test() {
  round_trip(structure_types.I64x2ExtendLowI32x4S, <<0xFD, 199, 1>>)
}

pub fn i64x2_extend_high_i32x4s_test() {
  round_trip(structure_types.I64x2ExtendHighI32x4S, <<0xFD, 200, 1>>)
}

pub fn i64x2_extend_low_i32x4u_test() {
  round_trip(structure_types.I64x2ExtendLowI32x4U, <<0xFD, 201, 1>>)
}

pub fn i64x2_extend_high_i32x4u_test() {
  round_trip(structure_types.I64x2ExtendHighI32x4U, <<0xFD, 202, 1>>)
}

pub fn i64x2_shl_test() {
  round_trip(structure_types.I64x2Shl, <<0xFD, 203, 1>>)
}

pub fn i64x2_shr_s_test() {
  round_trip(structure_types.I64x2ShrS, <<0xFD, 204, 1>>)
}

pub fn i64x2_shr_u_test() {
  round_trip(structure_types.I64x2ShrU, <<0xFD, 205, 1>>)
}

pub fn i64x2_add_test() {
  round_trip(structure_types.I64x2Add, <<0xFD, 206, 1>>)
}

pub fn i64x2_sub_test() {
  round_trip(structure_types.I64x2Sub, <<0xFD, 209, 1>>)
}

pub fn i64x2_mul_test() {
  round_trip(structure_types.I64x2Mul, <<0xFD, 213, 1>>)
}

pub fn i64x2_extmul_low_i32x4s_test() {
  round_trip(structure_types.I64x2ExtmulLowI32x4S, <<0xFD, 220, 1>>)
}

pub fn i64x2_extmul_high_i32x4s_test() {
  round_trip(structure_types.I64x2ExtmulHighI32x4S, <<0xFD, 221, 1>>)
}

pub fn i64x2_extmul_low_i32x4u_test() {
  round_trip(structure_types.I64x2ExtmulLowI32x4U, <<0xFD, 222, 1>>)
}

pub fn i64x2_extmul_high_i32x4u_test() {
  round_trip(structure_types.I64x2ExtmulHighI32x4U, <<0xFD, 223, 1>>)
}

pub fn f32x4_abs_test() {
  round_trip(structure_types.F32x4Abs, <<0xFD, 224, 1>>)
}

pub fn f32x4_neg_test() {
  round_trip(structure_types.F32x4Neg, <<0xFD, 225, 1>>)
}

pub fn f32x4_sqrt_test() {
  round_trip(structure_types.F32x4Sqrt, <<0xFD, 227, 1>>)
}

pub fn f32x4_add_test() {
  round_trip(structure_types.F32x4Add, <<0xFD, 228, 1>>)
}

pub fn f32x4_sub_test() {
  round_trip(structure_types.F32x4Sub, <<0xFD, 229, 1>>)
}

pub fn f32x4_mul_test() {
  round_trip(structure_types.F32x4Mul, <<0xFD, 230, 1>>)
}

pub fn f32x4_div_test() {
  round_trip(structure_types.F32x4Div, <<0xFD, 231, 1>>)
}

pub fn f32x4_min_test() {
  round_trip(structure_types.F32x4Min, <<0xFD, 232, 1>>)
}

pub fn f32x4_max_test() {
  round_trip(structure_types.F32x4Max, <<0xFD, 233, 1>>)
}

pub fn f32x4_pmin_test() {
  round_trip(structure_types.F32x4Pmin, <<0xFD, 234, 1>>)
}

pub fn f32x4_pmax_test() {
  round_trip(structure_types.F32x4Pmax, <<0xFD, 235, 1>>)
}

pub fn f64x2_abs_test() {
  round_trip(structure_types.F64x2Abs, <<0xFD, 236, 1>>)
}

pub fn f64x2_neg_test() {
  round_trip(structure_types.F64x2Neg, <<0xFD, 237, 1>>)
}

pub fn f64x2_sqrt_test() {
  round_trip(structure_types.F64x2Sqrt, <<0xFD, 239, 1>>)
}

pub fn f64x2_add_test() {
  round_trip(structure_types.F64x2Add, <<0xFD, 240, 1>>)
}

pub fn f64x2_sub_test() {
  round_trip(structure_types.F64x2Sub, <<0xFD, 241, 1>>)
}

pub fn f64x2_mul_test() {
  round_trip(structure_types.F64x2Mul, <<0xFD, 242, 1>>)
}

pub fn f64x2_div_test() {
  round_trip(structure_types.F64x2Div, <<0xFD, 243, 1>>)
}

pub fn f64x2_min_test() {
  round_trip(structure_types.F64x2Min, <<0xFD, 244, 1>>)
}

pub fn f64x2_max_test() {
  round_trip(structure_types.F64x2Max, <<0xFD, 245, 1>>)
}

pub fn f64x2_pmin_test() {
  round_trip(structure_types.F64x2Pmin, <<0xFD, 246, 1>>)
}

pub fn f64x2_pmax_test() {
  round_trip(structure_types.F64x2Pmax, <<0xFD, 247, 1>>)
}

pub fn i32x4_trunc_sat_f32x4s_test() {
  round_trip(structure_types.I32x4TruncSatF32x4S, <<0xFD, 248, 1>>)
}

pub fn i32x4_trunc_sat_f32x4u_test() {
  round_trip(structure_types.I32x4TruncSatF32x4U, <<0xFD, 249, 1>>)
}

pub fn f32x4_convert_i32x4s_test() {
  round_trip(structure_types.F32x4ConvertI32x4S, <<0xFD, 250, 1>>)
}

pub fn f32x4_convert_i32x4u_test() {
  round_trip(structure_types.F32x4ConvertI32x4U, <<0xFD, 251, 1>>)
}

pub fn i32x4_trunc_sat_f64x2s_zero_test() {
  round_trip(structure_types.I32x4TruncSatF64x2SZero, <<0xFD, 252, 1>>)
}

pub fn i32x4_trunc_sat_f64x2u_zero_test() {
  round_trip(structure_types.I32x4TruncSatF64x2UZero, <<0xFD, 253, 1>>)
}

pub fn f64x2_convert_low_i32x4s_test() {
  round_trip(structure_types.F64x2ConvertLowI32x4S, <<0xFD, 254, 1>>)
}

pub fn f64x2_convert_low_i32x4u_test() {
  round_trip(structure_types.F64x2ConvertLowI32x4U, <<0xFD, 255, 1>>)
}
