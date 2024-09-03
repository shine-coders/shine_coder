import gleam/bit_array
import gleam/bytes_builder.{type BytesBuilder}
import ieee_float.{type IEEEFloat}
import internal/structure/common.{between}

/// An opaque 8-bit signed integer value which can be unwrapped to obtain it's value
pub opaque type I8 {
  I8(val: Int)
}

/// An opaque 8-bit unsigned integer value which can be unwrapped to obtain it's value
pub opaque type U8 {
  U8(val: Int)
}

/// An opaque 16-bit signed integer value which can be unwrapped to obtain it's value
pub opaque type I16 {
  I16(val: Int)
}

/// An opaque 16-bit unsigned integer value which can be unwrapped to obtain it's value
pub opaque type U16 {
  U16(val: Int)
}

/// An opaque 32-bit signed integer value which can be unwrapped to obtain it's value
pub opaque type I32 {
  I32(val: Int)
}

/// An opaque 32-bit unsigned integer value which can be unwrapped to obtain it's value
pub opaque type U32 {
  U32(val: Int)
}

/// An opaque 64-bit signed integer value which can be unwrapped to obtain it's value
pub opaque type I64 {
  I64(val: Int)
}

/// An opaque 64-bit unsigned integer value which can be unwrapped to obtain it's value
pub opaque type U64 {
  U64(val: Int)
}

/// An opaque 32-bit floating point value which can be unwrapped to obtain it's value as a IEEEFloat
pub opaque type F32 {
  F32(val: IEEEFloat)
}

/// An opaque 64-bit floating point value which can be unwrapped to obtain it's value as a IEEEFloat
pub opaque type F64 {
  F64(val: IEEEFloat)
}

/// An opaque 33-bit signed integer value which can be unwrapped to obtain it's value. Note that
/// an S33 is a signed 33-bit integer, but in the WebAssembly specification, it will always be a
/// positive integer
pub opaque type S33 {
  S33(val: Int)
}

/// i8_range = #(-128, 127)
const i8_range = #(-128, 127)

/// u8_range = #(0, 255)
const u8_range = #(0, 255)

/// i16_range = #(-32_768, 32_767)
const i16_range = #(-32_768, 32_767)

/// u16_range = #(0, 65_535)
const u16_range = #(0, 65_535)

/// i32_range = #(-2_147_483_648, 2_147_483_647)
const i32_range = #(-2_147_483_648, 2_147_483_647)

/// u32_range = #(0, 4_294_967_295)
const u32_range = #(0, 4_294_967_295)

/// i64_range = #(-9_223_372_036_854_775_808, 9_223_372_036_854_775_807)
const i64_range = #(-9_223_372_036_854_775_808, 9_223_372_036_854_775_807)

/// u64_range = #(0, 18_446_744_073_709_551_615)
const u64_range = #(0, 18_446_744_073_709_551_615)

/// Note that an S33 is a signed 33-bit integer, but in WASM it will always be positive
const s33_range = #(0, 8_589_934_591)

/// Try to create an I8 from an Int, validating it's range, and returning an "out of range"
/// error the the integer is not the correct size.
pub fn i8(val: Int) -> Result(I8, String) {
  case val |> between(i8_range) {
    True -> Ok(I8(val))
    False -> Error("Integer out of range for I8")
  }
}

/// Try to create an U8 from an Int, validating it's range, and returning an "out of range"
/// error the the integer is not the correct size.
pub fn u8(val: Int) -> Result(U8, String) {
  case val |> between(u8_range) {
    True -> Ok(U8(val))
    False -> Error("Integer out of range for U8")
  }
}

/// Try to create an I16 from an Int, validating it's range, and returning an "out of range"
/// error the the integer is not the correct size.
pub fn i16(val: Int) -> Result(I16, String) {
  case val |> between(i16_range) {
    True -> Ok(I16(val))
    False -> Error("Integer out of range for I16")
  }
}

/// Try to create an U16 from an Int, validating it's range, and returning an "out of range"
/// error the the integer is not the correct size.
pub fn u16(val: Int) -> Result(U16, String) {
  case val |> between(u16_range) {
    True -> Ok(U16(val))
    False -> Error("Integer out of range for U16")
  }
}

/// Try to create an I32 from an Int, validating it's range, and returning an "out of range"
/// error the the integer is not the correct size.
pub fn i32(val: Int) -> Result(I32, String) {
  case val |> between(i32_range) {
    True -> Ok(I32(val))
    False -> Error("Integer out of range for I32")
  }
}

/// Try to create an U32 from an Int, validating it's range, and returning an "out of range"
/// error the the integer is not the correct size.
pub fn u32(val: Int) -> Result(U32, String) {
  case val |> between(u32_range) {
    True -> Ok(U32(val))
    False -> Error("Integer out of range for U32")
  }
}

/// Try to create an I64 from an Int, validating it's range, and returning an "out of range"
/// error the the integer is not the correct size.
pub fn i64(val: Int) -> Result(I64, String) {
  case val |> between(i64_range) {
    True -> Ok(I64(val))
    False -> Error("Integer out of range for I64")
  }
}

/// Try to create an U64 from an Int, validating it's range, and returning an "out of range"
/// error the the integer is not the correct size.
pub fn u64(val: Int) -> Result(U64, String) {
  case val |> between(u64_range) {
    True -> Ok(U64(val))
    False -> Error("Integer out of range for U64")
  }
}

/// Try to create an S33 from an Int, validating it's range, and returning an "out of range"
/// error the the integer is not the correct size.
pub fn s33(val: Int) -> Result(S33, String) {
  case val |> between(s33_range) {
    True -> Ok(S33(val))
    False -> Error("Integer out of range for S33")
  }
}

/// Unwrap a I16 into its integer value
pub fn unwrap_i16(val: I16) {
  val.val
}

/// Unwrap a I32 into its integer value
pub fn unwrap_i32(val: I32) {
  val.val
}

/// Unwrap a I64 into its integer value
pub fn unwrap_i64(val: I64) {
  val.val
}

/// Unwrap a I8 into its integer value
pub fn unwrap_i8(val: I8) {
  val.val
}

/// Unwrap a S33 into its integer value. This number will never be negative, despite being
/// represented as a signed 33-bit integer.
pub fn unwrap_s33(val: S33) {
  val.val
}

/// Unwrap a U16 into its integer value
pub fn unwrap_u16(val: U16) {
  val.val
}

/// Unwrap a U32 into its integer value
pub fn unwrap_u32(val: U32) {
  val.val
}

/// Unwrap a U64 into its integer value
pub fn unwrap_u64(val: U64) {
  val.val
}

/// Unwrap a U8 into its integer value
pub fn unwrap_u8(val: U8) {
  val.val
}

/// An opaque value representing a 128-bit byte vector
pub opaque type V128Value {
  V128Value(val: BitArray)
}

/// unwrap a V128Value into its BitArray
pub fn unwrap_v128(val: V128Value) {
  val.val
}

/// Create a V128Value from a BitArray, validating the size is 16 bytes,
/// and returning an error if it isn't.
pub fn v128(val: BitArray) -> Result(V128Value, String) {
  case val |> bit_array.byte_size {
    16 -> Ok(V128Value(val))
    _ -> Error("V128 value must be 16 bytes long")
  }
}

/// Create an F32 from a Float
pub fn f32(val: Float) {
  F32(ieee_float.finite(val))
}

/// Create a cannonical NaN f32 value
pub fn f32_nan() {
  F32(ieee_float.nan())
}

/// Create a negative infinity f32 value
pub fn f32_neg_inf() {
  F32(ieee_float.negative_infinity())
}

/// Create a positive infinity f32 value
pub fn f32_pos_inf() {
  F32(ieee_float.positive_infinity())
}

/// Create an F64 from a Float
pub fn f64(val: Float) {
  F64(ieee_float.finite(val))
}

/// Create a cannonical NaN f64 value
pub fn f64_nan() {
  F64(ieee_float.nan())
}

/// Create a negative infinity f64 value
pub fn f64_neg_inf() {
  F64(ieee_float.negative_infinity())
}

/// Create a positive infinity f64 value
pub fn f64_pos_inf() {
  F64(ieee_float.positive_infinity())
}

/// Unwrap a F32 into its IEEEFloat value
pub fn unwrap_f32(val: F32) {
  val.val
}

/// Unwrap a F64 into its IEEEFloat value
pub fn unwrap_f64(val: F64) {
  val.val
}

/// Create an I8x16 from 16 I8 values
pub fn i8x16(
  v0: I8,
  v1: I8,
  v2: I8,
  v3: I8,
  v4: I8,
  v5: I8,
  v6: I8,
  v7: I8,
  v8: I8,
  v9: I8,
  v10: I8,
  v11: I8,
  v12: I8,
  v13: I8,
  v14: I8,
  v15: I8,
) {
  V128Value(<<
    v0.val,
    v1.val,
    v2.val,
    v3.val,
    v4.val,
    v5.val,
    v6.val,
    v7.val,
    v8.val,
    v9.val,
    v10.val,
    v11.val,
    v12.val,
    v13.val,
    v14.val,
    v15.val,
  >>)
}

/// Create an I16x8 from 8 I16 values
pub fn i16x8(
  v0: I16,
  v1: I16,
  v2: I16,
  v3: I16,
  v4: I16,
  v5: I16,
  v6: I16,
  v7: I16,
) {
  V128Value(<<
    v0.val:16,
    v1.val:16,
    v2.val:16,
    v3.val:16,
    v4.val:16,
    v5.val:16,
    v6.val:16,
    v7.val:16,
  >>)
}

/// Create an I32x4 from 4 I32 values
pub fn i32x4(v0: I32, v1: I32, v2: I32, v3: I32) {
  V128Value(<<v0.val:32, v1.val:32, v2.val:32, v3.val:32>>)
}

/// Create an I64x2 from 2 I64 values
pub fn i64x2(v0: I64, v1: I64) {
  V128Value(<<v0.val:64, v1.val:64>>)
}

/// Create an F32x4 from 4 F32 values
pub fn f32x4(v0: F32, v1: F32, v2: F32, v3: F32) {
  let v0 = v0.val |> ieee_float.to_bytes_32_le
  let v1 = v1.val |> ieee_float.to_bytes_32_le
  let v2 = v2.val |> ieee_float.to_bytes_32_le
  let v3 = v3.val |> ieee_float.to_bytes_32_le
  V128Value(<<v0:bits, v1:bits, v2:bits, v3:bits>>)
}

/// Create an F64x2 from 2 F64 values
pub fn f64x2(v0: F64, v1: F64) {
  let v0 = v0.val |> ieee_float.to_bytes_64_le
  let v1 = v1.val |> ieee_float.to_bytes_64_le
  V128Value(<<v0:bits, v1:bits>>)
}

/// Decode a 32-bit float from a BitArray, returning the result and the rest of the BitArray
pub fn decode_f32(val: BitArray) -> Result(#(F32, BitArray), String) {
  case val {
    <<val:bits-32, rest:bits>> -> {
      Ok(#(F32(ieee_float.from_bytes_32_le(val)), rest))
    }
    _ -> Error("Expected 32-bit float")
  }
}

/// Encode a 32-bit float into a BytesBuilder
pub fn encode_f32(builder: BytesBuilder, val: F32) {
  builder
  |> bytes_builder.append(val.val |> ieee_float.to_bytes_32_le)
}

/// Decode a 64-bit float from a BitArray, returning the result and the rest of the BitArray
pub fn decode_f64(val: BitArray) -> Result(#(F64, BitArray), String) {
  case val {
    <<val:bits-64, rest:bits>> -> {
      Ok(#(F64(ieee_float.from_bytes_64_le(val)), rest))
    }
    _ -> Error("Expected 32-bit float")
  }
}

/// Encode a 64-bit float into a BytesBuilder
pub fn encode_f64(builder: BytesBuilder, val: F64) {
  builder
  |> bytes_builder.append(val.val |> ieee_float.to_bytes_64_le)
}
