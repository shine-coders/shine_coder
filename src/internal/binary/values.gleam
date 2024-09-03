import gleam/bytes_builder.{type BytesBuilder}
import gleam/int
import gleam/result
import internal/structure/numbers.{
  type I16, type I32, type I64, type I8, type S33, type U16, type U32, type U64,
  type U8, type V128Value, i16, i32, i64, i8, s33, u16, u32, u64, u8, unwrap_i16,
  unwrap_i32, unwrap_i64, unwrap_i8, unwrap_s33, unwrap_u16, unwrap_u32,
  unwrap_u64, unwrap_u8, unwrap_v128, v128,
}

/// Decode a single i8 from the given BitArray, and return the rest
/// of the bits.
pub fn decode_i8(bits: BitArray) {
  do_decode_signed(bits, i8, 8)
}

/// Decode a single u8 from the given BitArray, and return the rest
/// of the bits.
pub fn decode_u8(bits: BitArray) {
  do_decode_unsigned(bits, u8, 8)
}

/// Decode a single i16 from the given BitArray, and return the rest
/// of the bits.
pub fn decode_i16(bits: BitArray) {
  do_decode_signed(bits, i16, 16)
}

/// Decode a single u16 from the given BitArray, and return the rest
/// of the bits.
pub fn decode_u16(bits: BitArray) {
  do_decode_unsigned(bits, u16, 16)
}

/// Decode a single i32 from the given BitArray, and return the rest
/// of the bits.
pub fn decode_i32(bits: BitArray) {
  do_decode_signed(bits, i32, 32)
}

/// Decode a single u32 from the given BitArray, and return the rest
/// of the bits.
pub fn decode_u32(bits: BitArray) {
  do_decode_unsigned(bits, u32, 32)
}

/// Decode a single i64 from the given BitArray, and return the rest
/// of the bits.
pub fn decode_i64(bits: BitArray) {
  do_decode_signed(bits, i64, 64)
}

/// Decode a single u64 from the given BitArray, and return the rest
/// of the bits.
pub fn decode_u64(bits: BitArray) {
  do_decode_unsigned(bits, u64, 64)
}

/// Decode a single s33 from the given BitArray, and return the rest
/// of the bits.
pub fn decode_s33(bits: BitArray) {
  do_decode_signed(bits, s33, 33)
}

/// Decode a single v128 from the given BitArray, and return the rest
/// of the bits.
pub fn decode_v128(bits: BitArray) {
  case bits {
    <<v128_val:bits-128, rest:bits>> -> {
      use v128_val <- result.map(v128(v128_val))
      #(v128_val, rest)
    }
    _ -> Error("Could not decode V128")
  }
}

fn finish_decode(
  val: Result(u, String),
  rest: BitArray,
) -> Result(#(u, BitArray), String) {
  case val {
    Ok(val) -> Ok(#(val, rest))
    Error(err) -> Error(err)
  }
}

/// Decode a single signed integer from the given BitArray. The function body
/// is comprised of multiple cases, one for each integer byte representation.
/// All the loops are unrolled.
fn do_decode_signed(
  val: BitArray,
  make: fn(Int) -> Result(i, String),
  bit_count: Int,
) -> Result(#(i, BitArray), String) {
  case val {
    <<
      0b1:1,
      val9:7,
      0b1:1,
      val8:7,
      0b1:1,
      val7:7,
      0b1:1,
      val6:7,
      0b1:1,
      val5:7,
      0b1:1,
      val4:7,
      0b1:1,
      val3:7,
      0b1:1,
      val2:7,
      0b1:1,
      val1:7,
      0b0:1,
      val0:7-signed,
      rest:bits,
    >>
      if bit_count > 63
    ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val2)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val3)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val4)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val5)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val6)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val7)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val8)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val9),
      )
      |> finish_decode(rest)
    <<
      0b1:1,
      val8:7,
      0b1:1,
      val7:7,
      0b1:1,
      val6:7,
      0b1:1,
      val5:7,
      0b1:1,
      val4:7,
      0b1:1,
      val3:7,
      0b1:1,
      val2:7,
      0b1:1,
      val1:7,
      0b0:1,
      val0:7-signed,
      rest:bits,
    >>
      if bit_count > 56
    ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val2)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val3)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val4)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val5)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val6)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val7)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val8),
      )
      |> finish_decode(rest)
    <<
      0b1:1,
      val7:7,
      0b1:1,
      val6:7,
      0b1:1,
      val5:7,
      0b1:1,
      val4:7,
      0b1:1,
      val3:7,
      0b1:1,
      val2:7,
      0b1:1,
      val1:7,
      0b0:1,
      val0:7-signed,
      rest:bits,
    >>
      if bit_count > 49
    ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val2)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val3)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val4)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val5)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val6)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val7),
      )
      |> finish_decode(rest)
    <<
      0b1:1,
      val6:7,
      0b1:1,
      val5:7,
      0b1:1,
      val4:7,
      0b1:1,
      val3:7,
      0b1:1,
      val2:7,
      0b1:1,
      val1:7,
      0b0:1,
      val0:7-signed,
      rest:bits,
    >>
      if bit_count > 42
    ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val2)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val3)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val4)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val5)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val6),
      )
      |> finish_decode(rest)
    <<
      0b1:1,
      val5:7,
      0b1:1,
      val4:7,
      0b1:1,
      val3:7,
      0b1:1,
      val2:7,
      0b1:1,
      val1:7,
      0b0:1,
      val0:7-signed,
      rest:bits,
    >>
      if bit_count > 35
    ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val2)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val3)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val4)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val5),
      )
      |> finish_decode(rest)
    <<
      0b1:1,
      val4:7,
      0b1:1,
      val3:7,
      0b1:1,
      val2:7,
      0b1:1,
      val1:7,
      0b0:1,
      val0:7-signed,
      rest:bits,
    >>
      if bit_count > 28
    ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val2)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val3)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val4),
      )
      |> finish_decode(rest)
    <<
      0b1:1,
      val3:7,
      0b1:1,
      val2:7,
      0b1:1,
      val1:7,
      0b0:1,
      val0:7-signed,
      rest:bits,
    >>
      if bit_count > 21
    ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val2)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val3),
      )
      |> finish_decode(rest)
    <<0b1:1, val2:7, 0b1:1, val1:7, 0b0:1, val0:7-signed, rest:bits>>
      if bit_count > 14
    ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val2),
      )
      |> finish_decode(rest)
    <<0b1:1, val1:7, 0b0:1, val0:7-signed, rest:bits>> if bit_count > 7 ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1),
      )
      |> finish_decode(rest)
    <<0b0:1, val0:7-signed, rest:bits>> if bit_count > 0 ->
      make(val0) |> finish_decode(rest)
    _ -> Error("Invalid number format")
  }
}

/// Decode a single unsigned integer from the given BitArray. The function body
/// is comprised of multiple cases, one for each integer byte representation.
/// All the loops are unrolled.
fn do_decode_unsigned(
  val: BitArray,
  make: fn(Int) -> Result(u, String),
  bit_count: Int,
) -> Result(#(u, BitArray), String) {
  case val {
    <<
      0b1:1,
      val9:7,
      0b1:1,
      val8:7,
      0b1:1,
      val7:7,
      0b1:1,
      val6:7,
      0b1:1,
      val5:7,
      0b1:1,
      val4:7,
      0b1:1,
      val3:7,
      0b1:1,
      val2:7,
      0b1:1,
      val1:7,
      0b0:1,
      val0:7,
      rest:bits,
    >>
      if bit_count > 63
    ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val2)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val3)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val4)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val5)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val6)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val7)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val8)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val9),
      )
      |> finish_decode(rest)
    <<
      0b1:1,
      val8:7,
      0b1:1,
      val7:7,
      0b1:1,
      val6:7,
      0b1:1,
      val5:7,
      0b1:1,
      val4:7,
      0b1:1,
      val3:7,
      0b1:1,
      val2:7,
      0b1:1,
      val1:7,
      0b0:1,
      val0:7,
      rest:bits,
    >>
      if bit_count > 56
    ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val2)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val3)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val4)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val5)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val6)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val7)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val8),
      )
      |> finish_decode(rest)
    <<
      0b1:1,
      val7:7,
      0b1:1,
      val6:7,
      0b1:1,
      val5:7,
      0b1:1,
      val4:7,
      0b1:1,
      val3:7,
      0b1:1,
      val2:7,
      0b1:1,
      val1:7,
      0b0:1,
      val0:7,
      rest:bits,
    >>
      if bit_count > 49
    ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val2)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val3)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val4)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val5)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val6)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val7),
      )
      |> finish_decode(rest)
    <<
      0b1:1,
      val6:7,
      0b1:1,
      val5:7,
      0b1:1,
      val4:7,
      0b1:1,
      val3:7,
      0b1:1,
      val2:7,
      0b1:1,
      val1:7,
      0b0:1,
      val0:7,
      rest:bits,
    >>
      if bit_count > 42
    ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val2)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val3)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val4)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val5)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val6),
      )
      |> finish_decode(rest)
    <<
      0b1:1,
      val5:7,
      0b1:1,
      val4:7,
      0b1:1,
      val3:7,
      0b1:1,
      val2:7,
      0b1:1,
      val1:7,
      0b0:1,
      val0:7,
      rest:bits,
    >>
      if bit_count > 35
    ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val2)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val3)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val4)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val5),
      )
      |> finish_decode(rest)
    <<
      0b1:1,
      val4:7,
      0b1:1,
      val3:7,
      0b1:1,
      val2:7,
      0b1:1,
      val1:7,
      0b0:1,
      val0:7,
      rest:bits,
    >>
      if bit_count > 28
    ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val2)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val3)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val4),
      )
      |> finish_decode(rest)
    <<0b1:1, val3:7, 0b1:1, val2:7, 0b1:1, val1:7, 0b0:1, val0:7, rest:bits>>
      if bit_count > 21
    ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val2)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val3),
      )
      |> finish_decode(rest)
    <<0b1:1, val2:7, 0b1:1, val1:7, 0b0:1, val0:7, rest:bits>>
      if bit_count > 14
    ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1)
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val2),
      )
      |> finish_decode(rest)
    <<0b1:1, val1:7, 0b0:1, val0:7, rest:bits>> if bit_count > 7 ->
      make(
        val0
        |> int.bitwise_shift_left(7)
        |> int.bitwise_or(val1),
      )
      |> finish_decode(rest)
    <<0b0:1, val0:7, rest:bits>> if bit_count > 0 ->
      make(val0) |> finish_decode(rest)
    _ -> Error("Invalid number format")
  }
}

/// Encode a single unsigned integer recursively.
fn do_encode_unsigned(builder: BytesBuilder, val: Int) {
  case val {
    val if val > 127 ->
      builder
      |> bytes_builder.append(<<0b1:1, val:7>>)
      |> do_encode_unsigned(val |> int.bitwise_shift_right(7))
    val ->
      builder
      |> bytes_builder.append(<<0b0:1, val:7>>)
  }
}

/// Encode a single signed integer recursively.
fn do_encode_signed(builder: BytesBuilder, val: Int) {
  case val {
    val if val > 63 || val < -64 ->
      builder
      |> bytes_builder.append(<<0b1:1, val:7>>)
      |> do_encode_signed(val |> int.bitwise_shift_right(7))
    val ->
      builder
      |> bytes_builder.append(<<0b0:1, val:7>>)
  }
}

/// Encode a single u16 value into the given BytesBuilder.
pub fn encode_u16(builder: BytesBuilder, val: U16) {
  do_encode_unsigned(builder, val |> unwrap_u16)
}

/// Encode a single u32 value into the given BytesBuilder.
pub fn encode_u32(builder: BytesBuilder, val: U32) {
  do_encode_unsigned(builder, val |> unwrap_u32)
}

/// Encode a single u64 value into the given BytesBuilder.
pub fn encode_u64(builder: BytesBuilder, val: U64) {
  do_encode_unsigned(builder, val |> unwrap_u64)
}

/// Encode a single u8 value into the given BytesBuilder.
pub fn encode_u8(builder: BytesBuilder, val: U8) {
  do_encode_unsigned(builder, val |> unwrap_u8)
}

/// Encode a single i16 value into the given BytesBuilder.
pub fn encode_i16(builder: BytesBuilder, val: I16) {
  do_encode_signed(builder, val |> unwrap_i16)
}

/// Encode a single i32 value into the given BytesBuilder.
pub fn encode_i32(builder: BytesBuilder, val: I32) {
  do_encode_signed(builder, val |> unwrap_i32)
}

/// Encode a single i64 value into the given BytesBuilder.
pub fn encode_i64(builder: BytesBuilder, val: I64) {
  do_encode_signed(builder, val |> unwrap_i64)
}

/// Encode a single i8 value into the given BytesBuilder.
pub fn encode_i8(builder: BytesBuilder, val: I8) {
  do_encode_signed(builder, val |> unwrap_i8)
}

/// Encode a single s33 value into the given BytesBuilder.
pub fn encode_s33(builder: BytesBuilder, val: S33) {
  do_encode_signed(builder, val |> unwrap_s33)
}

/// Encode a single v128 value into the given BytesBuilder.
pub fn encode_v128(builder: BytesBuilder, val: V128Value) {
  builder
  |> bytes_builder.append(val |> unwrap_v128)
}
