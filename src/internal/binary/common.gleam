import gleam/bit_array
import gleam/bytes_builder.{type BytesBuilder}
import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import internal/binary/values.{decode_u32, encode_u32}
import internal/structure/numbers.{u32, unwrap_u32}
import shine_tree.{type ShineTree}

/// Encode a vector of items using the given encoding function
pub fn encode_vec(
  builder: BytesBuilder,
  items: ShineTree(u),
  encode_fn: fn(BytesBuilder, u) -> Result(BytesBuilder, String),
) {
  // Vectors are encoded as the number of items (in uleb128) and then each item
  use size <- result.try(shine_tree.size(items) |> u32)
  builder
  |> encode_u32(size)
  // this function is a loop over the items in the vector
  |> shine_tree.try_foldl(items, _, encode_fn)
}

/// Decode a vector of items using the given decoding function
pub fn decode_vec(
  bits: BitArray,
  decode_fn: fn(BitArray) -> Result(#(u, BitArray), String),
) {
  // Vectors are encoded as the number of items (in uleb128) and then n items
  use #(size, rest) <- result.try(decode_u32(bits))
  do_decode_vec(rest, size |> unwrap_u32, shine_tree.empty, decode_fn)
}

/// Loop over each item in a vector, and decode them using the given decoding function
fn do_decode_vec(
  bits: BitArray,
  size: Int,
  acc: ShineTree(u),
  decode_fn: fn(BitArray) -> Result(#(u, BitArray), String),
) {
  case size {
    0 -> Ok(#(acc, bits))
    _ -> {
      use #(val, rest) <- result.try(decode_fn(bits))
      do_decode_vec(rest, size - 1, acc |> shine_tree.push(val), decode_fn)
    }
  }
}

/// Encode something optional using the given encoding function. If the value is present,
/// encode it using the given encoding function, otherwise write no bytes.
pub fn encode_option(
  builder: BytesBuilder,
  val: Option(u),
  encode_fn: fn(BytesBuilder, u) -> Result(BytesBuilder, String),
) {
  case val {
    // if the value is present, encode it
    Some(u) -> encode_fn(builder, u)
    None -> Ok(builder)
  }
}

/// WebAssembly strings are encoded with a byte_length and a utf8 string in the following format:
/// [byte_length: u32] [contents: string(byte_length)]
pub fn encode_string(builder: BytesBuilder, string: String) {
  let size = string |> string.byte_size
  use size <- result.map(size |> u32)
  builder
  |> encode_u32(size)
  |> bytes_builder.append_string(string)
}

/// Decode a given number of bytes, returning the resulting BitArray, and the rest of the BitArray
pub fn decode_bytes(bits: BitArray, size: Int) {
  let size = size * 8
  case bits {
    <<bits:bits-size(size), rest:bits>> -> Ok(#(bits, rest))
    _ -> Error("Byte length mismatch")
  }
}

/// Decode a vector of bytes, whose byte length is obtained by reading a u32 at the
/// current bit position, and then decoding that many bytes.
pub fn decode_byte_vec(bits: BitArray) {
  use #(size, rest) <- result.try(decode_u32(bits))
  let size = size |> unwrap_u32
  decode_bytes(rest, size)
}

// [u32]:size [name]:size
/// WebAssembly strings are encoded with a byte_length and a utf8 string.
/// This function decodes a string and returns the rest of the BitArray
pub fn decode_string(val: BitArray) -> Result(#(String, BitArray), String) {
  use #(byte_length, rest) <- result.try(decode_u32(val))
  use #(bytes, rest) <- result.try(decode_bytes(rest, byte_length |> unwrap_u32))
  use str <- result.try(
    bit_array.to_string(bytes) |> result.replace_error("Invalid utf8 string"),
  )
  Ok(#(str, rest))
}

/// Decode a section with the given section ID and the given decoding function
pub fn decode_section(
  bits: BitArray,
  section_id: Int,
  decode_section_fn: fn(BitArray) -> Result(#(u, BitArray), String),
) {
  case bits {
    // If the BitArray starts with the section ID, decode it and return the rest of the BitArray
    <<id, rest:bits>> if id == section_id -> {
      // Because the section has a size, split the BitArray into the section_bytes and the rest
      // of the BitArray
      use #(section_bytes, rest) <- result.try(decode_byte_vec(rest))

      // Try to decode the section with the given decoding function
      use #(section, left) <- result.try(decode_section_fn(section_bytes))

      // If the whole section was decoded, the section is valid, otherwise return an error
      case left {
        <<>> -> Ok(#(Some(section), rest))
        _ -> Error("Invalid section")
      }
    }
    // If the section doesn't exist, it's not an error
    _ -> Ok(#(None, bits))
  }
}

/// This function asserts the first byte of the BitArray is a given byte, and returns
/// the rest of the BitArray
pub fn expect_decode_byte(bits: BitArray, val: Int) {
  case bits {
    <<first, rest:bits>> if first == val -> Ok(#(first, rest))
    <<first, _:bits>> ->
      Error(
        "Invalid byte: 0x"
        <> { int.to_base16(first) }
        <> ", expected 0x"
        <> { int.to_base16(val) },
      )
    _ -> Error("Empty buffer, expected 0x" <> { int.to_base16(val) })
  }
}

/// Encode a vector of bytes, writing the byte length as a u32, followed by the bytes
/// themselves.
pub fn encode_byte_vec(builder: BytesBuilder, bytes: BitArray) {
  use size <- result.map(bytes |> bit_array.byte_size |> u32)
  builder
  |> encode_u32(size)
  |> bytes_builder.append(bytes)
}

/// This utility function is the final step of encoding a module section. Each section
/// is generated by creating a new BytesBuilder, and then calculating the byte length
/// of that section. Each section has the following format, and is written to the final
/// BytesBuilder buffer with the following pattern:
/// 
/// [section_id: byte] [byte_length: u32] [section_bytes: bytes(byte_length)]
pub fn encode_section_from_builder(
  builder: BytesBuilder,
  section_id: Int,
  section_builder: BytesBuilder,
) {
  use size <- result.map(section_builder |> bytes_builder.byte_size |> u32)
  builder
  |> bytes_builder.append(<<section_id>>)
  |> encode_u32(size)
  |> bytes_builder.append_builder(section_builder)
}

/// This utility function asserts the given match bytes are at the start of the given BitArray.
pub fn expect_decode_bytes(bits: BitArray, match: BitArray) {
  let match_length = 8 * bit_array.byte_size(match)
  case bits {
    <<match:bits-size(match_length), rest:bits>> if match == match -> Ok(rest)
    _ -> Error("Invalid bytes")
  }
}
