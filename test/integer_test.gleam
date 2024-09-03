import gleam/bit_array
import gleam/bytes_builder.{type BytesBuilder}
import gleam/io
import gleam/pair
import gleeunit/should
import internal/binary/values.{
  decode_i16, decode_i32, decode_i64, decode_i8, decode_s33, decode_u16,
  decode_u32, decode_u64, decode_u8, encode_i16, encode_i32, encode_i64,
  encode_i8, encode_s33, encode_u16, encode_u32, encode_u64, encode_u8,
}
import internal/structure/numbers.{
  i16, i32, i64, i8, s33, u16, u32, u64, u8, unwrap_i16, unwrap_i32, unwrap_i64,
  unwrap_i8, unwrap_s33, unwrap_u16, unwrap_u32, unwrap_u64, unwrap_u8,
}

pub fn to_i16(val: Int) {
  i16(val) |> should.be_ok
}

pub fn to_i32(val: Int) {
  i32(val) |> should.be_ok
}

pub fn to_i64(val: Int) {
  i64(val) |> should.be_ok
}

pub fn to_i8(val: Int) {
  i8(val) |> should.be_ok
}

pub fn to_s33(val: Int) {
  s33(val) |> should.be_ok
}

pub fn to_u16(val: Int) {
  u16(val) |> should.be_ok
}

pub fn to_u32(val: Int) {
  u32(val) |> should.be_ok
}

pub fn to_u64(val: Int) {
  u64(val) |> should.be_ok
}

pub fn to_u8(val: Int) {
  u8(val) |> should.be_ok
}

pub fn round_trip(
  val: Int,
  bits: BitArray,
  unwrapper: fn(u) -> Int,
  wrapper: fn(Int) -> Result(u, String),
  encoder: fn(BytesBuilder, u) -> BytesBuilder,
  decoder: fn(BitArray) -> Result(#(u, BitArray), String),
) {
  let encoded_bits =
    val
    |> wrapper
    |> should.be_ok
    |> encoder(bytes_builder.new(), _)
    |> bytes_builder.to_bit_array

  case encoded_bits == bits {
    True -> Nil
    _ -> {
      io.debug(#(
        "expected:",
        bits |> bit_array.inspect,
        "got:",
        encoded_bits |> bit_array.inspect,
        "val:",
        val,
      ))
      Nil
    }
  }

  encoded_bits |> should.equal(bits)

  bits
  |> decoder
  |> should.be_ok
  |> pair.map_first(unwrapper)
  |> should.equal(#(val, <<>>))
}

pub fn unsigned_encode_integer_test() {
  round_trip(0, <<0>>, unwrap_u8, u8, encode_u8, decode_u8)
  round_trip(42, <<42>>, unwrap_u8, u8, encode_u8, decode_u8)
  round_trip(127, <<127>>, unwrap_u8, u8, encode_u8, decode_u8)
  round_trip(128, <<128, 1>>, unwrap_u8, u8, encode_u8, decode_u8)
  round_trip(255, <<255, 1>>, unwrap_u8, u8, encode_u8, decode_u8)
  round_trip(0, <<0>>, unwrap_u16, u16, encode_u16, decode_u16)
  round_trip(42, <<42>>, unwrap_u16, u16, encode_u16, decode_u16)
  round_trip(127, <<127>>, unwrap_u16, u16, encode_u16, decode_u16)
  round_trip(128, <<128, 1>>, unwrap_u16, u16, encode_u16, decode_u16)
  round_trip(
    0xffff,
    <<255, 255, 0b11>>,
    unwrap_u16,
    u16,
    encode_u16,
    decode_u16,
  )
  round_trip(0, <<0>>, unwrap_u32, u32, encode_u32, decode_u32)
  round_trip(42, <<42>>, unwrap_u32, u32, encode_u32, decode_u32)
  round_trip(127, <<127>>, unwrap_u32, u32, encode_u32, decode_u32)
  round_trip(128, <<128, 1>>, unwrap_u32, u32, encode_u32, decode_u32)
  round_trip(
    624_485,
    <<0xE5, 0x8E, 0x26>>,
    unwrap_u32,
    u32,
    encode_u32,
    decode_u32,
  )
  round_trip(0, <<0>>, unwrap_u64, u64, encode_u64, decode_u64)
  round_trip(42, <<42>>, unwrap_u64, u64, encode_u64, decode_u64)
  round_trip(127, <<127>>, unwrap_u64, u64, encode_u64, decode_u64)
  round_trip(128, <<128, 1>>, unwrap_u64, u64, encode_u64, decode_u64)
  round_trip(
    624_485,
    <<0xE5, 0x8E, 0x26>>,
    unwrap_u64,
    u64,
    encode_u64,
    decode_u64,
  )
}

pub fn signed_encode_integer_test() {
  round_trip(0, <<0>>, unwrap_i8, i8, encode_i8, decode_i8)
  round_trip(2, <<2>>, unwrap_i8, i8, encode_i8, decode_i8)
  round_trip(-2, <<0x7e>>, unwrap_i8, i8, encode_i8, decode_i8)
  round_trip(127, <<0xff, 0>>, unwrap_i8, i8, encode_i8, decode_i8)
  round_trip(-127, <<0x81, 0x7f>>, unwrap_i8, i8, encode_i8, decode_i8)
  round_trip(-128, <<0x80, 0x7f>>, unwrap_i8, i8, encode_i8, decode_i8)
  round_trip(0, <<0>>, unwrap_i16, i16, encode_i16, decode_i16)
  round_trip(2, <<2>>, unwrap_i16, i16, encode_i16, decode_i16)
  round_trip(-2, <<0x7e>>, unwrap_i16, i16, encode_i16, decode_i16)
  round_trip(127, <<0xff, 0>>, unwrap_i16, i16, encode_i16, decode_i16)
  round_trip(-127, <<0x81, 0x7f>>, unwrap_i16, i16, encode_i16, decode_i16)
  round_trip(128, <<0x80, 1>>, unwrap_i16, i16, encode_i16, decode_i16)
  round_trip(-128, <<0x80, 0x7f>>, unwrap_i16, i16, encode_i16, decode_i16)
  round_trip(129, <<0x81, 1>>, unwrap_i16, i16, encode_i16, decode_i16)
  round_trip(-129, <<0xff, 0x7e>>, unwrap_i16, i16, encode_i16, decode_i16)
  round_trip(0, <<0>>, unwrap_i32, i32, encode_i32, decode_i32)
  round_trip(2, <<2>>, unwrap_i32, i32, encode_i32, decode_i32)
  round_trip(-2, <<0x7e>>, unwrap_i32, i32, encode_i32, decode_i32)
  round_trip(127, <<0xff, 0>>, unwrap_i32, i32, encode_i32, decode_i32)
  round_trip(-127, <<0x81, 0x7f>>, unwrap_i32, i32, encode_i32, decode_i32)
  round_trip(128, <<0x80, 1>>, unwrap_i32, i32, encode_i32, decode_i32)
  round_trip(-128, <<0x80, 0x7f>>, unwrap_i32, i32, encode_i32, decode_i32)
  round_trip(129, <<0x81, 1>>, unwrap_i32, i32, encode_i32, decode_i32)
  round_trip(-129, <<0xff, 0x7e>>, unwrap_i32, i32, encode_i32, decode_i32)
  round_trip(0, <<0>>, unwrap_i64, i64, encode_i64, decode_i64)
  round_trip(2, <<2>>, unwrap_i64, i64, encode_i64, decode_i64)
  round_trip(-2, <<0x7e>>, unwrap_i64, i64, encode_i64, decode_i64)
  round_trip(127, <<0xff, 0>>, unwrap_i64, i64, encode_i64, decode_i64)
  round_trip(-127, <<0x81, 0x7f>>, unwrap_i64, i64, encode_i64, decode_i64)
  round_trip(128, <<0x80, 1>>, unwrap_i64, i64, encode_i64, decode_i64)
  round_trip(-128, <<0x80, 0x7f>>, unwrap_i64, i64, encode_i64, decode_i64)
  round_trip(129, <<0x81, 1>>, unwrap_i64, i64, encode_i64, decode_i64)
  round_trip(-129, <<0xff, 0x7e>>, unwrap_i64, i64, encode_i64, decode_i64)
  round_trip(0, <<0>>, unwrap_s33, s33, encode_s33, decode_s33)
  round_trip(2, <<2>>, unwrap_s33, s33, encode_s33, decode_s33)
  // round_trip(-2, <<0x7e>>, unwrap_s33, s33, encode_s33, decode_s33)
  round_trip(127, <<0xff, 0>>, unwrap_s33, s33, encode_s33, decode_s33)
  // round_trip(-127, <<0x81, 0x7f>>, unwrap_s33, s33, encode_s33, decode_s33)
  round_trip(128, <<0x80, 1>>, unwrap_s33, s33, encode_s33, decode_s33)
  // round_trip(-128, <<0x80, 0x7f>>, unwrap_s33, s33, encode_s33, decode_s33)
  round_trip(129, <<0x81, 1>>, unwrap_s33, s33, encode_s33, decode_s33)
  // round_trip(-129, <<0xff, 0x7e>>, unwrap_s33, s33, encode_s33, decode_s33)
}

pub fn decode_u8_test() {
  <<0>>
  |> decode_u8
  |> should.be_ok
  |> pair.first
  |> unwrap_u8
  |> should.equal(0)
  <<42>>
  |> decode_u8
  |> should.be_ok
  |> pair.first
  |> unwrap_u8
  |> should.equal(42)
  <<127>>
  |> decode_u8
  |> should.be_ok
  |> pair.first
  |> unwrap_u8
  |> should.equal(127)
  <<128, 1>>
  |> decode_u8
  |> should.be_ok
  |> pair.first
  |> unwrap_u8
  |> should.equal(128)
  <<255, 1>>
  |> decode_u8
  |> should.be_ok
  |> pair.first
  |> unwrap_u8
  |> should.equal(255)
}

pub fn decode_u16_test() {
  <<0>>
  |> decode_u16
  |> should.be_ok
  |> pair.first
  |> unwrap_u16
  |> should.equal(0)
  <<42>>
  |> decode_u16
  |> should.be_ok
  |> pair.first
  |> unwrap_u16
  |> should.equal(42)
  <<127>>
  |> decode_u16
  |> should.be_ok
  |> pair.first
  |> unwrap_u16
  |> should.equal(127)
  <<128, 1>>
  |> decode_u16
  |> should.be_ok
  |> pair.first
  |> unwrap_u16
  |> should.equal(128)
  <<255, 255, 3>>
  |> decode_u16
  |> should.be_ok
  |> pair.first
  |> unwrap_u16
  |> should.equal(0xffff)
}

pub fn decode_u32_test() {
  <<0>>
  |> decode_u32
  |> should.be_ok
  |> pair.first
  |> unwrap_u32
  |> should.equal(0)
  <<42>>
  |> decode_u32
  |> should.be_ok
  |> pair.first
  |> unwrap_u32
  |> should.equal(42)
  <<127>>
  |> decode_u32
  |> should.be_ok
  |> pair.first
  |> unwrap_u32
  |> should.equal(127)
  <<128, 1>>
  |> decode_u32
  |> should.be_ok
  |> pair.first
  |> unwrap_u32
  |> should.equal(128)
  <<0xE5, 0x8E, 0x26>>
  |> decode_u32
  |> should.be_ok
  |> pair.first
  |> unwrap_u32
  |> should.equal(624_485)
  <<255, 255, 255, 255, 0b1111>>
  |> decode_u32
  |> should.be_ok
  |> pair.first
  |> unwrap_u32
  |> should.equal(0xffff_ffff)
}

pub fn decode_u64_test() {
  <<0>>
  |> decode_u64
  |> should.be_ok
  |> pair.first
  |> unwrap_u64
  |> should.equal(0)
  <<42>>
  |> decode_u64
  |> should.be_ok
  |> pair.first
  |> unwrap_u64
  |> should.equal(42)
  <<127>>
  |> decode_u64
  |> should.be_ok
  |> pair.first
  |> unwrap_u64
  |> should.equal(127)
  <<128, 1>>
  |> decode_u64
  |> should.be_ok
  |> pair.first
  |> unwrap_u64
  |> should.equal(128)
  <<0xE5, 0x8E, 0x26>>
  |> decode_u64
  |> should.be_ok
  |> pair.first
  |> unwrap_u64
  |> should.equal(624_485)
  <<255, 255, 255, 255, 255, 255, 255, 255, 255, 1>>
  |> decode_u64
  |> should.be_ok
  |> pair.first
  |> unwrap_u64
  |> should.equal(0xffff_ffff_ffff_ffff)
  // extra tests are for usize
  // <<0>> |> decode_unsigned |> should.be_ok |> pair.first |> unwrap |> should.equal(0)
  // <<42>> |> decode_unsigned |> should.be_ok |> pair.first |> unwrap |> should.equal(42)
  // <<127>> |> decode_unsigned |> should.be_ok |> pair.first |> unwrap |> should.equal(127)
  // <<128, 1>> |> decode_unsigned |> should.be_ok |> pair.first |> unwrap |> should.equal(128)
  // <<0xE5, 0x8E, 0x26>>
  // |> decode_unsigned
  // |> should.be_ok
  // |> unwrap |> should.equal(624_485)
  // <<255, 255, 255, 255, 0b1111>>
  // |> decode_unsigned
  // |> should.be_ok
  // |> unwrap |> should.equal(0xffff_ffff)
}

pub fn decode_i8_test() {
  <<0>>
  |> decode_i8
  |> should.be_ok
  |> pair.first
  |> unwrap_i8
  |> should.equal(0)
  <<2>>
  |> decode_i8
  |> should.be_ok
  |> pair.first
  |> unwrap_i8
  |> should.equal(2)
  <<0x7e>>
  |> decode_i8
  |> should.be_ok
  |> pair.first
  |> unwrap_i8
  |> should.equal(-2)
  <<0xff, 0>>
  |> decode_i8
  |> should.be_ok
  |> pair.first
  |> unwrap_i8
  |> should.equal(127)
  <<0x81, 0x7f>>
  |> decode_i8
  |> should.be_ok
  |> pair.first
  |> unwrap_i8
  |> should.equal(-127)
  <<0x80, 0x7f>>
  |> decode_i8
  |> should.be_ok
  |> pair.first
  |> unwrap_i8
  |> should.equal(-128)
}

pub fn decode_i16_test() {
  <<0>>
  |> decode_i16
  |> should.be_ok
  |> pair.first
  |> unwrap_i16
  |> should.equal(0)
  <<2>>
  |> decode_i16
  |> should.be_ok
  |> pair.first
  |> unwrap_i16
  |> should.equal(2)
  <<0x7e>>
  |> decode_i16
  |> should.be_ok
  |> pair.first
  |> unwrap_i16
  |> should.equal(-2)
  <<0xff, 0>>
  |> decode_i16
  |> should.be_ok
  |> pair.first
  |> unwrap_i16
  |> should.equal(127)
  <<0x81, 0x7f>>
  |> decode_i16
  |> should.be_ok
  |> pair.first
  |> unwrap_i16
  |> should.equal(-127)
  <<0x80, 1>>
  |> decode_i16
  |> should.be_ok
  |> pair.first
  |> unwrap_i16
  |> should.equal(128)
  <<0x80, 0x7f>>
  |> decode_i16
  |> should.be_ok
  |> pair.first
  |> unwrap_i16
  |> should.equal(-128)
  <<0x81, 1>>
  |> decode_i16
  |> should.be_ok
  |> pair.first
  |> unwrap_i16
  |> should.equal(129)
  <<0xff, 0x7e>>
  |> decode_i16
  |> should.be_ok
  |> pair.first
  |> unwrap_i16
  |> should.equal(-129)
}

pub fn decode_i32_test() {
  <<0>>
  |> decode_i32
  |> should.be_ok
  |> pair.first
  |> unwrap_i32
  |> should.equal(0)
  <<2>>
  |> decode_i32
  |> should.be_ok
  |> pair.first
  |> unwrap_i32
  |> should.equal(2)
  <<0x7e>>
  |> decode_i32
  |> should.be_ok
  |> pair.first
  |> unwrap_i32
  |> should.equal(-2)
  <<0xff, 0>>
  |> decode_i32
  |> should.be_ok
  |> pair.first
  |> unwrap_i32
  |> should.equal(127)
  <<0x81, 0x7f>>
  |> decode_i32
  |> should.be_ok
  |> pair.first
  |> unwrap_i32
  |> should.equal(-127)
  <<0x80, 1>>
  |> decode_i32
  |> should.be_ok
  |> pair.first
  |> unwrap_i32
  |> should.equal(128)
  <<0x80, 0x7f>>
  |> decode_i32
  |> should.be_ok
  |> pair.first
  |> unwrap_i32
  |> should.equal(-128)
  <<0x81, 1>>
  |> decode_i32
  |> should.be_ok
  |> pair.first
  |> unwrap_i32
  |> should.equal(129)
  <<0xff, 0x7e>>
  |> decode_i32
  |> should.be_ok
  |> pair.first
  |> unwrap_i32
  |> should.equal(-129)
}

pub fn decode_i64_test() {
  <<0>>
  |> decode_i64
  |> should.be_ok
  |> pair.first
  |> unwrap_i64
  |> should.equal(0)
  <<0>>
  |> decode_i64
  |> should.be_ok
  |> pair.first
  |> unwrap_i64
  |> should.equal(0)
  <<2>>
  |> decode_i64
  |> should.be_ok
  |> pair.first
  |> unwrap_i64
  |> should.equal(2)
  <<0x7e>>
  |> decode_i64
  |> should.be_ok
  |> pair.first
  |> unwrap_i64
  |> should.equal(-2)
  <<0xff, 0>>
  |> decode_i64
  |> should.be_ok
  |> pair.first
  |> unwrap_i64
  |> should.equal(127)
  <<0x81, 0x7f>>
  |> decode_i64
  |> should.be_ok
  |> pair.first
  |> unwrap_i64
  |> should.equal(-127)
  <<0x80, 1>>
  |> decode_i64
  |> should.be_ok
  |> pair.first
  |> unwrap_i64
  |> should.equal(128)
  <<0x80, 0x7f>>
  |> decode_i64
  |> should.be_ok
  |> pair.first
  |> unwrap_i64
  |> should.equal(-128)
  <<0x81, 1>>
  |> decode_i64
  |> should.be_ok
  |> pair.first
  |> unwrap_i64
  |> should.equal(129)
  <<0xff, 0x7e>>
  |> decode_i64
  |> should.be_ok
  |> pair.first
  |> unwrap_i64
  |> should.equal(-129)
  // <<0>> |> decode_signed |> should.be_ok |> pair.first |> unwrap |> should.equal(0)
  // <<0>> |> decode_signed |> should.be_ok |> pair.first |> unwrap |> should.equal(0)
  // <<2>> |> decode_signed |> should.be_ok |> pair.first |> unwrap |> should.equal(2)
  // <<0x7e>> |> decode_signed |> should.be_ok |> pair.first |> unwrap |> should.equal(-2)
  // <<0xff, 0>> |> decode_signed |> should.be_ok |> pair.first |> unwrap |> should.equal(127)
  // <<0x81, 0x7f>> |> decode_signed |> should.be_ok |> pair.first |> unwrap |> should.equal(-127)
  // <<0x80, 1>> |> decode_signed |> should.be_ok |> pair.first |> unwrap |> should.equal(128)
  // <<0x80, 0x7f>> |> decode_signed |> should.be_ok |> pair.first |> unwrap |> should.equal(-128)
  // <<0x81, 1>> |> decode_signed |> should.be_ok |> pair.first |> unwrap |> should.equal(129)
  // <<0xff, 0x7e>> |> decode_signed |> should.be_ok |> pair.first |> unwrap |> should.equal(-129)
}

pub fn unsigned_decode_overflow_test() {
  <<128, 2>>
  |> decode_u8
  |> should.be_error
  <<128, 128, 4>>
  |> decode_u16
  |> should.be_error
  <<128, 128, 128, 128, 16>>
  |> decode_u32
  |> should.be_error
  <<128, 128, 128, 128, 128, 128, 128, 128, 128, 2>>
  |> decode_u64
  |> should.be_error
}

pub fn signed_decode_overflow_test() {
  <<128, 2>>
  |> decode_i8
  |> should.be_error
  <<128, 128, 4>>
  |> decode_i16
  |> should.be_error
  <<128, 128, 128, 128, 16>>
  |> decode_i32
  |> should.be_error
  <<128, 128, 128, 128, 128, 128, 128, 128, 128, 2>>
  |> decode_i64
  |> should.be_error
}
// pub fn byte_count_test() {
//   <<2>>
//   |> decode_i64
//   |> should.be_ok
//   |> pair.first
//   |> unwrap
//   |> i64
//   |> should.be_ok
//   |> byte_count
//   |> should.equal(1)
//   <<128, 128, 128, 2>>
//   |> decode_i64
//   |> should.be_ok
//   |> pair.first
//   |> unwrap
//   |> i64
//   |> should.be_ok
//   |> byte_count
//   |> should.equal(4)
//   <<128, 128, 128, 128, 128, 128, 128, 128, 2>>
//   |> decode_i64
//   |> should.be_ok
//   |> pair.first
//   |> unwrap
//   |> i64
//   |> should.be_ok
//   |> byte_count
//   |> should.equal(9)
//   <<2>>
//   |> decode_u64
//   |> should.be_ok
//   |> pair.first
//   |> unwrap
//   |> u64
//   |> should.be_ok
//   |> byte_count
//   |> should.equal(1)
//   <<128, 128, 128, 2>>
//   |> decode_u64
//   |> should.be_ok
//   |> pair.first
//   |> unwrap
//   |> u64
//   |> should.be_ok
//   |> byte_count
//   |> should.equal(4)
//   <<128, 128, 128, 128, 128, 128, 128, 128, 2>>
//   |> decode_u64
//   |> should.be_ok
//   |> pair.first
//   |> unwrap
//   |> u64
//   |> should.be_ok
//   |> byte_count
//   |> should.equal(9)
// }
