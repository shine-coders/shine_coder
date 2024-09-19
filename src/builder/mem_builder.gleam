import gleam/bit_array
import gleam/int
import gleam/result
import gleamy/red_black_tree_map.{type Map}
import internal/structure/numbers.{
  type F32, type F64, type I32, type I64, type V128Value, decode_f32, decode_f64,
  i32, i64, v128,
}
import internal/structure/types.{type Limits}

pub opaque type MemBuilder {
  MemBuilder(
    page_count: Int,
    // just a constant value. page_size (64KiB) * page_count = byte count
    limits: Limits,
    // min pages and max pages
    // chunks of 64 bytes
    data: Map(Int, BitArray),
  )
}

pub fn write_bytes(
  mem_builder: MemBuilder,
  ptr: Int,
  bytes: BitArray,
) -> Result(MemBuilder, String) {
  let byte_size = bit_array.byte_size(bytes)
  case ptr + byte_size, mem_builder.page_count * 65_536 - 1 {
    ptr, max_address if ptr > max_address -> Error("Address out of bounds.")
    _, _ -> Ok(do_write_bytes(mem_builder, ptr, <<>>, byte_size))
  }
}

fn do_write_bytes(
  mem_builder: MemBuilder,
  ptr: Int,
  bytes: BitArray,
  rest_byte_count: Int,
) {
  let segment_index = ptr / 64
  let segment_offset = ptr |> int.bitwise_and(63)
  let next_segment_ptr = { segment_index + 1 } * 64
  case rest_byte_count {
    0 -> mem_builder
    // if overflow
    rest_byte_count -> {
      let to_write_byte_count =
        64
        |> int.subtract(segment_offset)
        |> int.min(rest_byte_count)
      let to_write_bit_count = to_write_byte_count * 8

      let assert <<to_write:bits-size(to_write_bit_count), rest:bits>> = bytes

      let assert <<
        start:bits-size(segment_offset),
        _:bits-size(to_write_bit_count),
        end:bits,
      >> = case red_black_tree_map.find(mem_builder.data, segment_index) {
        Ok(segment) -> segment
        _ -> <<0:512>>
      }

      case rest {
        <<>> -> mem_builder
        _ ->
          do_write_bytes(
            MemBuilder(
              ..mem_builder,
              data: red_black_tree_map.insert(mem_builder.data, segment_index, <<
                start:bits,
                to_write:bits,
                end:bits,
              >>),
            ),
            next_segment_ptr,
            rest,
            rest_byte_count - to_write_byte_count,
          )
      }
    }
  }
}

pub fn read_bytes(
  mem_builder: MemBuilder,
  ptr: Int,
  size: Int,
) -> Result(BitArray, String) {
  case ptr + size, mem_builder.page_count * 65_536 - 1 {
    ptr, max_address if ptr > max_address -> Error("Address out of bounds.")
    _, _ -> Ok(do_read_bytes(mem_builder, ptr, <<>>, size))
  }
}

fn do_read_bytes(
  mem_builder: MemBuilder,
  ptr: Int,
  acc: BitArray,
  rest_byte_count: Int,
) -> BitArray {
  let segment_index = ptr / 64
  let segment_offset = ptr |> int.bitwise_and(63)
  let segment_bits_offset = segment_offset * 8
  let next_segment_ptr = { segment_index + 1 } * 64
  let to_read_bytes = next_segment_ptr - ptr
  let to_read_bits = to_read_bytes * 8
  let assert <<
    _:bits-size(segment_bits_offset),
    data:bits-size(to_read_bits),
    _:bits,
  >> = case red_black_tree_map.find(mem_builder.data, segment_index) {
    Ok(segment) -> segment
    _ -> <<0:512>>
  }
  case rest_byte_count - to_read_bytes {
    0 -> <<acc:bits, data:bits>>
    rest_byte_count ->
      do_read_bytes(
        mem_builder,
        ptr + to_read_bytes,
        <<acc:bits, data:bits>>,
        rest_byte_count,
      )
  }
}

pub fn write_int(
  mem_builder: MemBuilder,
  ptr: Int,
  num: Int,
  size: Int,
) -> Result(MemBuilder, String) {
  let bit_count = size * 8
  write_bytes(mem_builder, ptr, <<num:size(bit_count)>>)
}

pub fn read_uint(
  mem_builder: MemBuilder,
  ptr: Int,
  size: Int,
) -> Result(Int, String) {
  let bit_size = size * 8
  case read_bytes(mem_builder, ptr, size) {
    Ok(<<value:size(bit_size)>>) -> Ok(value)
    Error(e) -> Error(e)
    _ -> panic as "Invalid BitArray size"
  }
}

pub fn read_int(
  mem_builder: MemBuilder,
  ptr: Int,
  size: Int,
) -> Result(Int, String) {
  let bit_size = size * 8
  case read_bytes(mem_builder, ptr, size) {
    Ok(<<value:signed-size(bit_size)>>) -> Ok(value)
    Error(e) -> Error(e)
    _ -> panic as "Invalid BitArray size"
  }
}

pub fn i64_load(mem_builder: MemBuilder, ptr: Int) -> Result(I64, String) {
  result.try(read_int(mem_builder, ptr, 8), i64)
}

pub fn i32_load(mem_builder: MemBuilder, ptr: Int) -> Result(I32, String) {
  result.try(read_int(mem_builder, ptr, 4), i32)
}

// F32Load
pub fn f32_load(mem_builder: MemBuilder, ptr: Int) -> Result(F32, String) {
  use bytes <- result.try(read_bytes(mem_builder, ptr, 4))
  case decode_f32(bytes) {
    Ok(#(value, <<>>)) -> Ok(value)
    _ -> Error("Invalid byte sequence.")
  }
}

pub fn f64_load(mem_builder: MemBuilder, ptr: Int) -> Result(F64, String) {
  use bytes <- result.try(read_bytes(mem_builder, ptr, 8))
  case decode_f64(bytes) {
    Ok(#(value, <<>>)) -> Ok(value)
    _ -> Error("Invalid byte sequence.")
  }
}

pub fn v128_load(mem_builder: MemBuilder, ptr: Int) -> Result(V128Value, String) {
  result.try(read_bytes(mem_builder, ptr, 16), v128)
}

// The following instructions will need to be supported for memory reading and writing ops
//
// I64Load16S
// I64Load16U
// I64Load8S
// I64Load8U
// I32Load16S
// I32Load16U
// I32Load8S
// I32Load8U
// I64Load32S
// I64Load32U
// V128Load8x8S
// V128Load8x8U
// V128Load16x4S
// V128Load16x4U
// V128Load32x2S
// V128Load32x2U
// V128Load32Zero
// V128Load64Zero
// V128Load64Splat
// V128Load32Splat
// V128Load16Splat
// V128Load8Splat
// V128Load8Lane
// V128Load16Lane
// V128Load32Lane
// V128Load64Lane
// I32Load
// I32Load16S
// I32Load16U
// I32Load8S
// I32Load8U
// I64Load
// I64Load16S
// I64Load16U
// I64Load8S
// I64Load8U
// I64Load32S
// I64Load32U
// F64Load
// F32Load
// V128Load
// V128Load8x8S
// V128Load8x8U
// V128Load16x4S
// V128Load16x4U
// V128Load32x2S
// V128Load32x2U
// V128Load32Zero
// V128Load64Zero
// V128Load64Splat
// V128Load32Splat
// V128Load16Splat
// V128Load8Splat
// V128Load8Lane
// V128Load16Lane
// V128Load32Lane
// V128Load64Lane
// I64Store
// I64Store8
// I64Store16
// I64Store32
// I32Store
// I32Store8
// I32Store16
// F64Store
// F32Store
// V128Store
// V128Store8Lane
// V128Store16Lane
// V128Store32Lane
// V128Store64Lane
// I64Store
// I64Store16
// I64Store8
// I64Store32
// I32Store
// I32Store16
// I32Store8
// F64Store
// F32Store
// V128Store
// V128Store8Lane
// V128Store16Lane
// V128Store32Lane
// V128Store64Lane
// V128Store64Lane
