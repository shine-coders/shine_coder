import gleam/bytes_builder.{type BytesBuilder}
import gleam/int
import gleam/option.{None, Some}
import gleam/result
import internal/binary/common
import internal/binary/values.{
  decode_i32, decode_i64, decode_s33, decode_u32, encode_i32, encode_i64,
  encode_s33, encode_u32,
}
import internal/finger_tree.{type FingerTree}
import internal/structure/numbers.{
  decode_f32, decode_f64, encode_f32, encode_f64, s33, u32, unwrap_s33,
  unwrap_u32,
}
import internal/structure/types.{
  type ArrayType, type BlockType, type CompositeType, type DataIDX, type ElemIDX,
  type Expr, type FieldIDX, type FieldType, type FuncIDX, type FuncType,
  type GlobalIDX, type GlobalType, type HeapType, type Instruction,
  type LabelIDX, type LaneIDX16, type LaneIDX2, type LaneIDX4, type LaneIDX8,
  type Limits, type LocalIDX, type Locals, type MemArg, type MemIDX,
  type MemType, type Mut, type RecType, type RefType, type StorageType,
  type StructType, type SubType, type TableIDX, type TableType, type TypeIDX,
  type ValType, AnyConvertExtern, AnyHeapType, AnyRefType, ArrayCompositeType,
  ArrayCopy, ArrayFill, ArrayGet, ArrayGetS, ArrayGetU, ArrayHeapType,
  ArrayInitData, ArrayInitElem, ArrayLen, ArrayNew, ArrayNewData,
  ArrayNewDefault, ArrayNewElem, ArrayNewFixed, ArrayRefType, ArraySet,
  ArrayType, Block, BotValType, Br, BrIf, BrOnCast, BrOnCastFail, BrOnNonNull,
  BrOnNull, BrTable, Call, CallIndirect, CallRef, ConcreteHeapType, Const,
  DataDrop, DataIDX, Drop, ElemDrop, ElemIDX, EqHeapType, EqRefType, Expr,
  ExternConvertAny, ExternHeapType, ExternRefType, F32Abs, F32Add, F32Ceil,
  F32Const, F32ConvertI32S, F32ConvertI32U, F32ConvertI64S, F32ConvertI64U,
  F32Copysign, F32DemoteF64, F32Div, F32Eq, F32Floor, F32Ge, F32Gt, F32Le,
  F32Load, F32Lt, F32Max, F32Min, F32Mul, F32Ne, F32Nearest, F32Neg,
  F32ReinterpretI32, F32Sqrt, F32Store, F32Sub, F32Trunc, F32ValType, F32x4Abs,
  F32x4Add, F32x4Ceil, F32x4ConvertI32x4S, F32x4ConvertI32x4U,
  F32x4DemoteF64x2Zero, F32x4Div, F32x4Eq, F32x4ExtractLane, F32x4Floor, F32x4Ge,
  F32x4Gt, F32x4Le, F32x4Lt, F32x4Max, F32x4Min, F32x4Mul, F32x4Ne, F32x4Nearest,
  F32x4Neg, F32x4Pmax, F32x4Pmin, F32x4ReplaceLane, F32x4Splat, F32x4Sqrt,
  F32x4Sub, F32x4Trunc, F64Abs, F64Add, F64Ceil, F64Const, F64ConvertI32S,
  F64ConvertI32U, F64ConvertI64S, F64ConvertI64U, F64Copysign, F64Div, F64Eq,
  F64Floor, F64Ge, F64Gt, F64Le, F64Load, F64Lt, F64Max, F64Min, F64Mul, F64Ne,
  F64Nearest, F64Neg, F64PromoteF32, F64ReinterpretI64, F64Sqrt, F64Store,
  F64Sub, F64Trunc, F64ValType, F64x2Abs, F64x2Add, F64x2Ceil,
  F64x2ConvertLowI32x4S, F64x2ConvertLowI32x4U, F64x2Div, F64x2Eq,
  F64x2ExtractLane, F64x2Floor, F64x2Ge, F64x2Gt, F64x2Le, F64x2Lt, F64x2Max,
  F64x2Min, F64x2Mul, F64x2Ne, F64x2Nearest, F64x2Neg, F64x2Pmax, F64x2Pmin,
  F64x2PromoteLowF32x4, F64x2ReplaceLane, F64x2Splat, F64x2Sqrt, F64x2Sub,
  F64x2Trunc, FieldIDX, FieldType, FuncCompositeType, FuncHeapType, FuncIDX,
  FuncRefType, FuncType, FuncTypeBlockType, GlobalGet, GlobalIDX, GlobalSet,
  GlobalType, HeapTypeRefType, I16StorageType, I16x8Abs, I16x8Add, I16x8AddSatS,
  I16x8AddSatU, I16x8AllTrue, I16x8AvgrU, I16x8Bitmask, I16x8Eq,
  I16x8ExtaddPairwiseI8x16S, I16x8ExtaddPairwiseI8x16U, I16x8ExtendHighI8x16S,
  I16x8ExtendHighI8x16U, I16x8ExtendLowI8x16S, I16x8ExtendLowI8x16U,
  I16x8ExtmulHighI8x16S, I16x8ExtmulHighI8x16U, I16x8ExtmulLowI8x16S,
  I16x8ExtmulLowI8x16U, I16x8ExtractLaneS, I16x8ExtractLaneU, I16x8GeS, I16x8GeU,
  I16x8GtS, I16x8GtU, I16x8LeS, I16x8LeU, I16x8LtS, I16x8LtU, I16x8MaxS,
  I16x8MaxU, I16x8MinS, I16x8MinU, I16x8Mul, I16x8NarrowI32x4S,
  I16x8NarrowI32x4U, I16x8Ne, I16x8Neg, I16x8Q15mulrSatS, I16x8ReplaceLane,
  I16x8Shl, I16x8ShrS, I16x8ShrU, I16x8Splat, I16x8Sub, I16x8SubSatS,
  I16x8SubSatU, I31GetS, I31GetU, I31HeapType, I31RefType, I32Add, I32And,
  I32Clz, I32Const, I32Ctz, I32DivS, I32DivU, I32Eq, I32Eqz, I32Extend16S,
  I32Extend8S, I32GeS, I32GeU, I32GtS, I32GtU, I32LeS, I32LeU, I32Load,
  I32Load16S, I32Load16U, I32Load8S, I32Load8U, I32LtS, I32LtU, I32Mul, I32Ne,
  I32Or, I32Popcnt, I32ReinterpretF32, I32RemS, I32RemU, I32Rotl, I32Rotr,
  I32Shl, I32ShrS, I32ShrU, I32Store, I32Store16, I32Store8, I32Sub,
  I32TruncF32S, I32TruncF32U, I32TruncF64S, I32TruncF64U, I32TruncSatF32S,
  I32TruncSatF32U, I32TruncSatF64S, I32TruncSatF64U, I32ValType, I32WrapI64,
  I32Xor, I32x4Abs, I32x4Add, I32x4AllTrue, I32x4Bitmask, I32x4DotI16x8S,
  I32x4Eq, I32x4ExtaddPairwiseI16x8S, I32x4ExtaddPairwiseI16x8U,
  I32x4ExtendHighI16x8S, I32x4ExtendHighI16x8U, I32x4ExtendLowI16x8S,
  I32x4ExtendLowI16x8U, I32x4ExtmulHighI16x8S, I32x4ExtmulHighI16x8U,
  I32x4ExtmulLowI16x8S, I32x4ExtmulLowI16x8U, I32x4ExtractLane, I32x4GeS,
  I32x4GeU, I32x4GtS, I32x4GtU, I32x4LeS, I32x4LeU, I32x4LtS, I32x4LtU,
  I32x4MaxS, I32x4MaxU, I32x4MinS, I32x4MinU, I32x4Mul, I32x4Ne, I32x4Neg,
  I32x4ReplaceLane, I32x4Shl, I32x4ShrS, I32x4ShrU, I32x4Splat, I32x4Sub,
  I32x4TruncSatF32x4S, I32x4TruncSatF32x4U, I32x4TruncSatF64x2SZero,
  I32x4TruncSatF64x2UZero, I64Add, I64And, I64Clz, I64Const, I64Ctz, I64DivS,
  I64DivU, I64Eq, I64Eqz, I64Extend16S, I64Extend32S, I64Extend8S, I64ExtendI32S,
  I64ExtendI32U, I64GeS, I64GeU, I64GtS, I64GtU, I64LeS, I64LeU, I64Load,
  I64Load16S, I64Load16U, I64Load32S, I64Load32U, I64Load8S, I64Load8U, I64LtS,
  I64LtU, I64Mul, I64Ne, I64Or, I64Popcnt, I64ReinterpretF64, I64RemS, I64RemU,
  I64Rotl, I64Rotr, I64Shl, I64ShrS, I64ShrU, I64Store, I64Store16, I64Store32,
  I64Store8, I64Sub, I64TruncF32S, I64TruncF32U, I64TruncF64S, I64TruncF64U,
  I64TruncSatF32S, I64TruncSatF32U, I64TruncSatF64S, I64TruncSatF64U, I64ValType,
  I64Xor, I64x2Abs, I64x2Add, I64x2AllTrue, I64x2Bitmask, I64x2Eq,
  I64x2ExtendHighI32x4S, I64x2ExtendHighI32x4U, I64x2ExtendLowI32x4S,
  I64x2ExtendLowI32x4U, I64x2ExtmulHighI32x4S, I64x2ExtmulHighI32x4U,
  I64x2ExtmulLowI32x4S, I64x2ExtmulLowI32x4U, I64x2ExtractLane, I64x2GeS,
  I64x2GtS, I64x2LeS, I64x2LtS, I64x2Mul, I64x2Ne, I64x2Neg, I64x2ReplaceLane,
  I64x2Shl, I64x2ShrS, I64x2ShrU, I64x2Splat, I64x2Sub, I8StorageType, I8x16Abs,
  I8x16Add, I8x16AddSatS, I8x16AddSatU, I8x16AllTrue, I8x16AvgrU, I8x16Bitmask,
  I8x16Eq, I8x16ExtractLaneS, I8x16ExtractLaneU, I8x16GeS, I8x16GeU, I8x16GtS,
  I8x16GtU, I8x16LeS, I8x16LeU, I8x16LtS, I8x16LtU, I8x16MaxS, I8x16MaxU,
  I8x16MinS, I8x16MinU, I8x16NarrowI16x8S, I8x16NarrowI16x8U, I8x16Ne, I8x16Neg,
  I8x16Popcnt, I8x16ReplaceLane, I8x16Shl, I8x16ShrS, I8x16ShrU, I8x16Shuffle,
  I8x16Splat, I8x16Sub, I8x16SubSatS, I8x16SubSatU, I8x16Swizzle, If, LabelIDX,
  Limits, LocalGet, LocalIDX, LocalSet, LocalTee, Locals, Loop, MemArg, MemIDX,
  MemType, MemoryCopy, MemoryFill, MemoryGrow, MemoryInit, MemorySize,
  NoExternHeapType, NoExternRefType, NoFuncHeapType, NoFuncRefType, NoneHeapType,
  NoneRefType, Nop, RecType, RefAsNonNull, RefCast, RefCastNullable, RefEq,
  RefFunc, RefI31, RefIsNull, RefNull, RefTest, RefTestNullable, RefTypeValType,
  Return, ReturnCall, ReturnCallIndirect, ReturnCallRef, Select, SelectT,
  StructCompositeType, StructGet, StructGetS, StructGetU, StructHeapType,
  StructNew, StructNewDefault, StructRefType, StructSet, StructType, SubType,
  TableCopy, TableFill, TableGet, TableGrow, TableIDX, TableInit, TableSet,
  TableSize, TableType, TypeIDX, Unreachable, V128And, V128AndNot, V128AnyTrue,
  V128Bitselect, V128Const, V128Load, V128Load16Lane, V128Load16Splat,
  V128Load16x4S, V128Load16x4U, V128Load32Lane, V128Load32Splat, V128Load32Zero,
  V128Load32x2S, V128Load32x2U, V128Load64Lane, V128Load64Splat, V128Load64Zero,
  V128Load8Lane, V128Load8Splat, V128Load8x8S, V128Load8x8U, V128Not, V128Or,
  V128Store, V128Store16Lane, V128Store32Lane, V128Store64Lane, V128Store8Lane,
  V128ValType, V128Xor, ValTypeBlockType, ValTypeStorageType, Var, VoidBlockType,
  lane_16, lane_2, lane_4, lane_8,
}
import pprint

/// Decode a lane index (u32) from the given bit array, and assert it's
/// less than 16.
pub fn decode_lane_16(bits: BitArray) {
  use #(val, rest) <- result.try(decode_u32(bits))
  use lane <- result.map(lane_16(val |> unwrap_u32))
  #(lane, rest)
}

/// Decode a lane index (u32) from the given bit array, and assert it's
/// less than 8.
pub fn decode_lane_8(bits: BitArray) {
  use #(val, rest) <- result.try(decode_u32(bits))
  use lane <- result.map(lane_8(val |> unwrap_u32))
  #(lane, rest)
}

/// Decode a lane index (u32) from the given bit array, and assert it's
/// less than 4.
pub fn decode_lane_4(bits: BitArray) {
  use #(val, rest) <- result.try(decode_u32(bits))
  use lane <- result.map(lane_4(val |> unwrap_u32))
  #(lane, rest)
}

/// Decode a lane index (u32) from the given bit array, and assert it's
/// less than 2.
pub fn decode_lane_2(bits: BitArray) {
  use #(val, rest) <- result.try(decode_u32(bits))
  use lane <- result.map(lane_2(val |> unwrap_u32))
  #(lane, rest)
}

/// Encode a LaneIDX16 (u32) into the given bytes builder.
pub fn encode_lane_16(builder: BytesBuilder, lane: LaneIDX16) {
  use lane <- result.map(lane |> types.unwrap_lane_16 |> u32)
  builder |> encode_u32(lane)
}

/// Encode a LaneIDX8 (u32) into the given bytes builder.
pub fn encode_lane_8(builder: BytesBuilder, lane: LaneIDX8) {
  use lane <- result.map(lane |> types.unwrap_lane_8 |> u32)
  builder |> encode_u32(lane)
}

/// Encode a LaneIDX4 (u32) into the given bytes builder.
pub fn encode_lane_4(builder: BytesBuilder, lane: LaneIDX4) {
  use lane <- result.map(lane |> types.unwrap_lane_4 |> u32)
  builder |> encode_u32(lane)
}

/// Encode a LaneIDX2 (u32) into the given bytes builder.
pub fn encode_lane_2(builder: BytesBuilder, lane: LaneIDX2) {
  use lane <- result.map(lane |> types.unwrap_lane_2 |> u32)
  builder |> encode_u32(lane)
}

/// Encode a single set of locals in a code section definition.
pub fn encode_locals(builder: BytesBuilder, locals: Locals) {
  let Locals(count, type_) = locals
  builder
  |> encode_u32(count)
  |> encode_val_type(type_)
}

/// Decode a heap type from the given bit array. Please note that the
/// abstract heap types are hoisted from the "AbstractHeapType" definition
/// here for convenience.
pub fn decode_heap_type(bits: BitArray) {
  case bits {
    <<0x73, rest:bits>> -> Ok(#(NoFuncHeapType, rest))
    <<0x72, rest:bits>> -> Ok(#(NoExternHeapType, rest))
    <<0x71, rest:bits>> -> Ok(#(NoneHeapType, rest))
    <<0x70, rest:bits>> -> Ok(#(FuncHeapType, rest))
    <<0x6F, rest:bits>> -> Ok(#(ExternHeapType, rest))
    <<0x6E, rest:bits>> -> Ok(#(AnyHeapType, rest))
    <<0x6D, rest:bits>> -> Ok(#(EqHeapType, rest))
    <<0x6C, rest:bits>> -> Ok(#(I31HeapType, rest))
    <<0x6B, rest:bits>> -> Ok(#(StructHeapType, rest))
    <<0x6A, rest:bits>> -> Ok(#(ArrayHeapType, rest))
    // Heap type indexes are encoded as 33-bit signed integers,
    // but are always positive. This is to prevent number collisions
    // with the different heap types. The last byte of the integer
    // encoding can never be greater than 0x3F, which garuntees
    // encoding safety.
    _ -> {
      use #(val, rest) <- result.try(decode_s33(bits))
      let val = val |> unwrap_s33
      use val <- result.map(u32(val))
      #(ConcreteHeapType(TypeIDX(val)), rest)
    }
  }
}

/// Encode a heap type into the given bytes builder.
pub fn encode_heap_type(builder: BytesBuilder, heap_type: HeapType) {
  case heap_type {
    NoFuncHeapType -> Ok(builder |> bytes_builder.append(<<0x73>>))
    NoExternHeapType -> Ok(builder |> bytes_builder.append(<<0x72>>))
    NoneHeapType -> Ok(builder |> bytes_builder.append(<<0x71>>))
    FuncHeapType -> Ok(builder |> bytes_builder.append(<<0x70>>))
    ExternHeapType -> Ok(builder |> bytes_builder.append(<<0x6F>>))
    AnyHeapType -> Ok(builder |> bytes_builder.append(<<0x6E>>))
    EqHeapType -> Ok(builder |> bytes_builder.append(<<0x6D>>))
    I31HeapType -> Ok(builder |> bytes_builder.append(<<0x6C>>))
    StructHeapType -> Ok(builder |> bytes_builder.append(<<0x6B>>))
    ArrayHeapType -> Ok(builder |> bytes_builder.append(<<0x6A>>))
    // Heap type indexes are encoded as 33-bit signed integers,
    // but are always positive. This is to prevent number collisions
    // with the different heap types. The last byte of the integer
    // encoding can never be greater than 0x3F, which garuntees
    // encoding safety.
    ConcreteHeapType(TypeIDX(val)) -> {
      let val = val |> unwrap_u32
      use val <- result.map(s33(val))
      builder |> encode_s33(val)
    }
    _ -> Error("Invalid heap type")
  }
}

/// Decode a reference type from the given bit array. Please note that the
/// abstract reference types are hoisted from the "HeapType" definitions.
pub fn decode_ref_type(bits: BitArray) {
  case bits {
    // The first byte can simply be an AbstractHeapType (and is always nullable)
    <<0x73, rest:bits>> -> Ok(#(NoFuncRefType, rest))
    <<0x72, rest:bits>> -> Ok(#(NoExternRefType, rest))
    <<0x71, rest:bits>> -> Ok(#(NoneRefType, rest))
    <<0x70, rest:bits>> -> Ok(#(FuncRefType, rest))
    <<0x6F, rest:bits>> -> Ok(#(ExternRefType, rest))
    <<0x6E, rest:bits>> -> Ok(#(AnyRefType, rest))
    <<0x6D, rest:bits>> -> Ok(#(EqRefType, rest))
    <<0x6C, rest:bits>> -> Ok(#(I31RefType, rest))
    <<0x6B, rest:bits>> -> Ok(#(StructRefType, rest))
    <<0x6A, rest:bits>> -> Ok(#(ArrayRefType, rest))
    // The first byte can be [0x63] which represents a nullable abstract reference type.
    // Abstract heap type ref types are always nullable, and return the same result as
    // if the nullable byte did not exist in the encoding.
    <<0x63, 0x73, rest:bits>> -> Ok(#(NoFuncRefType, rest))
    <<0x63, 0x72, rest:bits>> -> Ok(#(NoExternRefType, rest))
    <<0x63, 0x71, rest:bits>> -> Ok(#(NoneRefType, rest))
    <<0x63, 0x70, rest:bits>> -> Ok(#(FuncRefType, rest))
    <<0x63, 0x6F, rest:bits>> -> Ok(#(ExternRefType, rest))
    <<0x63, 0x6E, rest:bits>> -> Ok(#(AnyRefType, rest))
    <<0x63, 0x6D, rest:bits>> -> Ok(#(EqRefType, rest))
    <<0x63, 0x6C, rest:bits>> -> Ok(#(I31RefType, rest))
    <<0x63, 0x6B, rest:bits>> -> Ok(#(StructRefType, rest))
    <<0x63, 0x6A, rest:bits>> -> Ok(#(ArrayRefType, rest))
    // This is the general case of a nullable refrence type. If decoding the
    // heap type results in something that can be hoisted, then the equivalent
    // ref type is returned.
    <<0x63, rest:bits>> -> {
      use #(heap_type, rest) <- result.map(decode_heap_type(rest))
      case heap_type {
        NoFuncHeapType -> #(NoFuncRefType, rest)
        NoExternHeapType -> #(NoExternRefType, rest)
        NoneHeapType -> #(NoneRefType, rest)
        FuncHeapType -> #(FuncRefType, rest)
        ExternHeapType -> #(ExternRefType, rest)
        AnyHeapType -> #(AnyRefType, rest)
        EqHeapType -> #(EqRefType, rest)
        I31HeapType -> #(I31RefType, rest)
        StructHeapType -> #(StructRefType, rest)
        ArrayHeapType -> #(ArrayRefType, rest)
        _ -> #(HeapTypeRefType(heap_type, True), rest)
      }
    }
    // This is the general case of a non-nullable refrence type. There are no
    // equivalent representations for heap types that aren't nullable, so the
    // general case is always returned.
    <<0x64, rest:bits>> -> {
      use #(heap_type, rest) <- result.map(decode_heap_type(rest))
      #(HeapTypeRefType(heap_type, False), rest)
    }
    _ -> Error("Invalid reference type")
  }
}

pub fn encode_ref_type(builder: BytesBuilder, ref_type: RefType) {
  case ref_type {
    // These RefTypes are always nullable, so it is safe to just append the
    // abstract heap type representation.
    NoFuncRefType -> Ok(builder |> bytes_builder.append(<<0x73>>))
    NoExternRefType -> Ok(builder |> bytes_builder.append(<<0x72>>))
    NoneRefType -> Ok(builder |> bytes_builder.append(<<0x71>>))
    FuncRefType -> Ok(builder |> bytes_builder.append(<<0x70>>))
    ExternRefType -> Ok(builder |> bytes_builder.append(<<0x6F>>))
    AnyRefType -> Ok(builder |> bytes_builder.append(<<0x6E>>))
    EqRefType -> Ok(builder |> bytes_builder.append(<<0x6D>>))
    I31RefType -> Ok(builder |> bytes_builder.append(<<0x6C>>))
    StructRefType -> Ok(builder |> bytes_builder.append(<<0x6B>>))
    ArrayRefType -> Ok(builder |> bytes_builder.append(<<0x6A>>))
    // When a HeapTypeRefType is an abstract heap type, and the RefType is
    // nullable, it suffices to encode the abstract heap type.
    HeapTypeRefType(NoFuncHeapType, True) ->
      Ok(builder |> bytes_builder.append(<<0x73>>))
    HeapTypeRefType(NoExternHeapType, True) ->
      Ok(builder |> bytes_builder.append(<<0x72>>))
    HeapTypeRefType(NoneHeapType, True) ->
      Ok(builder |> bytes_builder.append(<<0x71>>))
    HeapTypeRefType(FuncHeapType, True) ->
      Ok(builder |> bytes_builder.append(<<0x70>>))
    HeapTypeRefType(ExternHeapType, True) ->
      Ok(builder |> bytes_builder.append(<<0x6F>>))
    HeapTypeRefType(AnyHeapType, True) ->
      Ok(builder |> bytes_builder.append(<<0x6E>>))
    HeapTypeRefType(EqHeapType, True) ->
      Ok(builder |> bytes_builder.append(<<0x6D>>))
    HeapTypeRefType(I31HeapType, True) ->
      Ok(builder |> bytes_builder.append(<<0x6C>>))
    HeapTypeRefType(StructHeapType, True) ->
      Ok(builder |> bytes_builder.append(<<0x6B>>))
    HeapTypeRefType(ArrayHeapType, True) ->
      Ok(builder |> bytes_builder.append(<<0x6A>>))
    // All other heap type RefTypes should be encoded properly.
    HeapTypeRefType(ht, True) ->
      builder
      |> bytes_builder.append(<<0x63>>)
      |> encode_heap_type(ht)
    HeapTypeRefType(ht, False) ->
      builder
      |> bytes_builder.append(<<0x64>>)
      |> encode_heap_type(ht)
  }
}

/// Decodes a ValType from the given bits.
/// 
/// A valtype may be:
/// 1. an I32
/// 2. an I64
/// 3. an F32
/// 4. an F64
/// 5. a V128
/// 6. a reference type
pub fn decode_val_type(bits: BitArray) {
  case bits {
    <<0x7F, rest:bits>> -> Ok(#(I32ValType, rest))
    <<0x7E, rest:bits>> -> Ok(#(I64ValType, rest))
    <<0x7D, rest:bits>> -> Ok(#(F32ValType, rest))
    <<0x7C, rest:bits>> -> Ok(#(F64ValType, rest))
    <<0x7B, rest:bits>> -> Ok(#(V128ValType, rest))
    _ -> {
      use #(rt, rest) <- result.map(decode_ref_type(bits))
      #(RefTypeValType(rt), rest)
    }
  }
}

/// Encodes a ValType into the given builder.
pub fn encode_val_type(builder: BytesBuilder, val_type: ValType) {
  case val_type {
    I32ValType -> Ok(builder |> bytes_builder.append(<<0x7F>>))
    I64ValType -> Ok(builder |> bytes_builder.append(<<0x7E>>))
    F32ValType -> Ok(builder |> bytes_builder.append(<<0x7D>>))
    F64ValType -> Ok(builder |> bytes_builder.append(<<0x7C>>))
    V128ValType -> Ok(builder |> bytes_builder.append(<<0x7B>>))
    RefTypeValType(rt) -> encode_ref_type(builder, rt)
    BotValType -> Error("Cannot encode BotValType")
  }
}

/// Encoding a result type is the same as encoding a vector of ValTypes
pub fn encode_result_type(
  builder: BytesBuilder,
  result_type: FingerTree(ValType),
) {
  builder |> common.encode_vec(result_type, encode_val_type)
}

/// Decoding a result type is the same as decoding a vector of ValTypes
pub fn decode_result_type(bits: BitArray) {
  common.decode_vec(bits, decode_val_type)
}

/// Encoding a function type is the same as encoding two result types,
/// where the first result type is a vector of parameter ValTypes, and
/// the second result type is a vector of result ValTypes.
pub fn encode_func_type(builder: BytesBuilder, func_type: FuncType) {
  use builder <- result.try(
    builder |> common.encode_vec(func_type.parameters, encode_val_type),
  )
  builder |> common.encode_vec(func_type.results, encode_val_type)
}

/// Decoding a function type is the same as decoding two result types,
/// where the first result type is a vector of parameter ValTypes, and
/// the second result type is a vector of result ValTypes.
pub fn decode_func_type(bits: BitArray) {
  use #(parameters, rest) <- result.try(common.decode_vec(bits, decode_val_type))
  use #(results, rest) <- result.map(common.decode_vec(rest, decode_val_type))
  #(FuncType(parameters, results), rest)
}

/// Encoding an array type is the same as encoding a field type.
pub fn decode_array_type(bits: BitArray) {
  use #(ft, rest) <- result.map(decode_field_type(bits))
  #(ArrayType(ft), rest)
}

/// Decoding an array type is the same as decoding a field type.
pub fn encode_array_type(builder: BytesBuilder, array_type: ArrayType) {
  builder |> encode_field_type(array_type.ft)
}

/// Decoding a field type follows the following byte pattern:
/// 
/// 1. Decode a storage type
/// 2. Decode a mutability flag
pub fn decode_field_type(bits: BitArray) {
  use #(st, rest) <- result.try(decode_storage_type(bits))
  use #(mut, rest) <- result.map(decode_mut(rest))
  #(FieldType(st, mut), rest)
}

/// Encoding a field type follows the following byte pattern:
///
/// 1. Encode a storage type
/// 2. Encode a mutability flag
pub fn encode_field_type(builder: BytesBuilder, field_type: FieldType) {
  use builder <- result.try(builder |> encode_storage_type(field_type.st))
  builder |> encode_mut(field_type.mut)
}

/// Decoding a storage type follows the one of following byte pattern:
/// 
/// 1. [0x78] - This represents a packed type I8
/// 2. [0x77] - This represents a packed type I16
/// 3. Any other value - This represents a ValType
pub fn decode_storage_type(bits: BitArray) {
  case bits {
    <<0x78, rest:bits>> -> Ok(#(I8StorageType, rest))
    <<0x77, rest:bits>> -> Ok(#(I16StorageType, rest))
    _ -> {
      use #(vt, rest) <- result.map(decode_val_type(bits))
      #(ValTypeStorageType(vt), rest)
    }
  }
}

/// Encoding a storage type follows the one of following byte pattern:
/// 
/// 1. [0x78] - This represents a packed type I8
/// 2. [0x77] - This represents a packed type I16
/// 3. Any other value - This represents a ValType
pub fn encode_storage_type(builder: BytesBuilder, storage_type: StorageType) {
  case storage_type {
    ValTypeStorageType(vt) -> encode_val_type(builder, vt)
    I8StorageType -> Ok(builder |> bytes_builder.append(<<0x78>>))
    I16StorageType -> Ok(builder |> bytes_builder.append(<<0x77>>))
  }
}

/// Decoding a mutability flag follows the following byte pattern:
/// 
/// 1. [0x00] - This represents a const
/// 2. [0x01] - This represents a var
pub fn decode_mut(bits: BitArray) {
  case bits {
    <<0x00, rest:bits>> -> Ok(#(Const, rest))
    <<0x01, rest:bits>> -> Ok(#(Var, rest))
    _ -> Error("Invalid mutability")
  }
}

/// Encoding a mutability flag follows the following byte pattern:
/// 
/// 1. [0x00] - This represents a const
/// 2. [0x01] - This represents a var
pub fn encode_mut(builder: BytesBuilder, mut: Mut) {
  case mut {
    Const -> Ok(builder |> bytes_builder.append(<<0x00>>))
    Var -> Ok(builder |> bytes_builder.append(<<0x01>>))
  }
}

/// Decoding a struct type is the same as decoding a vector of field types.
/// These field types describe the shape of the struct, and are 0-based indexed.
pub fn decode_struct_type(bits: BitArray) {
  use #(fields, rest) <- result.map(common.decode_vec(bits, decode_field_type))
  #(StructType(fields), rest)
}

/// Encoding a struct type is the same as encoding a vector of field types.
///  These field types describe the shape of the struct, and are 0-based indexed.
pub fn encode_struct_type(builder: BytesBuilder, struct_type: StructType) {
  builder |> common.encode_vec(struct_type.ft, encode_field_type)
}

/// Decoding a composite type uses one of the following byte patterns:
/// 
/// 1. [0x5E]  - This represents an array type followed by a single field type
/// 2. [0x5F]  - This represents a struct type followed by a vector of field types
/// 3. [0x60]  - This represents a function type followed by a function type
pub fn decode_comp_type(bits: BitArray) {
  case bits {
    <<0x5E, rest:bits>> -> {
      use #(at, rest) <- result.map(decode_array_type(rest))
      #(ArrayCompositeType(at), rest)
    }
    <<0x5F, rest:bits>> -> {
      use #(st, rest) <- result.map(decode_struct_type(rest))
      #(StructCompositeType(st), rest)
    }
    <<0x60, rest:bits>> -> {
      use #(ft, rest) <- result.map(decode_func_type(rest))
      #(FuncCompositeType(ft), rest)
    }
    _ -> Error("Invalid composite type")
  }
}

/// Encoding a composite type uses one of the following byte patterns:
/// 
/// 1. [0x5E]  - This represents an array type followed by a single field type
/// 2. [0x5F]  - This represents a struct type followed by a vector of field types
/// 3. [0x60]  - This represents a function type followed by a function type
pub fn encode_composite_type(builder: BytesBuilder, comp_type: CompositeType) {
  case comp_type {
    FuncCompositeType(ft) ->
      builder
      |> bytes_builder.append(<<0x60>>)
      |> encode_func_type(ft)
    StructCompositeType(st) ->
      builder
      |> bytes_builder.append(<<0x5F>>)
      |> encode_struct_type(st)
    ArrayCompositeType(at) ->
      builder
      |> bytes_builder.append(<<0x5E>>)
      |> encode_array_type(at)
  }
}

/// Decoding a recursive type uses one of the following byte patterns:
/// 
/// 1. [0x4E]  - This represents a vector of sub types that are iso-recursive
/// 2. A single subtype wrapped inside of a rectype group
pub fn decode_rec_type(bits: BitArray) {
  case bits {
    <<0x4E, rest:bits>> -> {
      use #(st, rest) <- result.map(common.decode_vec(rest, decode_sub_type))
      #(RecType(st), rest)
    }
    _ -> {
      use #(st, rest) <- result.map(decode_sub_type(bits))
      #(RecType(finger_tree.from_list([st])), rest)
    }
  }
}

/// Encoding a recursive type uses one of the following byte patterns:
/// 
/// 1. [0x4E]  - This represents a vector of sub types that are iso-recursive
/// 2. A single subtype wrapped inside of a rectype group
pub fn encode_rec_type(builder: BytesBuilder, rec_type: RecType) {
  case rec_type.sub_types |> finger_tree.size {
    1 ->
      case rec_type.sub_types |> finger_tree.shift {
        Ok(#(sub_type, _)) -> encode_sub_type(builder, sub_type)
        Error(_) -> Error("Invalid recursive type")
      }
    t if t > 1 ->
      builder
      |> bytes_builder.append(<<0x4E>>)
      |> common.encode_vec(rec_type.sub_types, encode_sub_type)
    _ -> Error("Invalid recursive type")
  }
}

/// Decoding a subtype uses one of the following byte patterns:
/// 
/// 1. [0x50]  - This represents a subtype, followed by a vector of type indexes,
///    and a single composite type.
/// 2. [0x4F]  - This represents a *FINAL* subtype, followed by a vector of type indexes,
///    and a single composite type.
/// 3. A single composite type that is *FINAL*
pub fn decode_sub_type(bits: BitArray) {
  case bits {
    <<0x50, rest:bits>> -> {
      use #(ty, rest) <- result.try(common.decode_vec(rest, decode_type_idx))
      use #(ct, rest) <- result.map(decode_comp_type(rest))
      #(SubType(False, ty, ct), rest)
    }
    <<0x4F, rest:bits>> -> {
      use #(ty, rest) <- result.try(common.decode_vec(rest, decode_type_idx))
      use #(ct, rest) <- result.map(decode_comp_type(rest))
      #(SubType(True, ty, ct), rest)
    }
    _ -> {
      use #(ct, rest) <- result.map(decode_comp_type(bits))
      #(SubType(True, finger_tree.new(), ct), rest)
    }
  }
}

/// Encoding a subtype uses one of the following byte patterns:
/// 
/// 1. [0x50]  - This represents a subtype, followed by a vector of type indexes,
///    and a single composite type.
/// 2. [0x4F]  - This represents a *FINAL* subtype, followed by a vector of type indexes,
///    and a single composite type.
/// 3. A single composite type that is *FINAL*
pub fn encode_sub_type(builder: BytesBuilder, sub_type: SubType) {
  case sub_type.final, sub_type.t |> finger_tree.size {
    True, 0 -> builder |> encode_composite_type(sub_type.ct)
    True, _ -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x4F>>)
        |> common.encode_vec(sub_type.t, encode_type_idx),
      )
      builder |> encode_composite_type(sub_type.ct)
    }
    False, _ -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x50>>)
        |> common.encode_vec(sub_type.t, encode_type_idx),
      )
      builder |> encode_composite_type(sub_type.ct)
    }
  }
}

/// Decoding a FuncIDX is the same as decoding a u32
pub fn decode_func_idx(bits: BitArray) {
  use #(idx, rest) <- result.map(decode_u32(bits))
  #(FuncIDX(idx), rest)
}

/// Encoding a FuncIDX is the same as encoding a u32
pub fn encode_func_idx(builder: BytesBuilder, func_idx: FuncIDX) {
  Ok(builder |> encode_u32(func_idx.id))
}

/// Decoding a TableIDX is the same as decoding a u32
pub fn decode_table_idx(bits: BitArray) {
  use #(idx, rest) <- result.map(decode_u32(bits))
  #(TableIDX(idx), rest)
}

/// Encoding a TableIDX is the same as encoding a u32
pub fn encode_table_idx(builder: BytesBuilder, func_idx: TableIDX) {
  Ok(builder |> encode_u32(func_idx.id))
}

/// Decoding a FieldIDX is the same as decoding a u32
pub fn decode_field_idx(bits: BitArray) {
  use #(idx, rest) <- result.map(decode_u32(bits))
  #(FieldIDX(idx), rest)
}

/// Encoding a FieldIDX is the same as encoding a u32
pub fn encode_field_idx(builder: BytesBuilder, field_idx: FieldIDX) {
  Ok(builder |> encode_u32(field_idx.id))
}

/// Decoding a TypeIDX is the same as decoding a u32.
/// 
/// Note: Despite the fact that type indices are replacable by RecTypeIDXs and DefTypes,
/// these forms are impossible when used in a binary format.
pub fn decode_type_idx(bits: BitArray) {
  use #(idx, rest) <- result.map(decode_u32(bits))
  #(TypeIDX(idx), rest)
}

/// Encoding a TypeIDX is the same as encoding a u32.
/// 
/// Note: Despite the fact that type indices are replacable by RecTypeIDXs and DefTypes,
/// these forms are impossible when used in a binary format.
pub fn encode_type_idx(builder: BytesBuilder, type_idx: TypeIDX) {
  case type_idx {
    TypeIDX(id) -> Ok(builder |> encode_u32(id))
    _ -> Error("Invalid type index, found concrete index instead of numeric.")
  }
}

/// Decoding a MemIDX is the same as decoding a u32
pub fn encode_mem_idx(builder: BytesBuilder, mem_idx: MemIDX) {
  Ok(builder |> encode_u32(mem_idx.id))
}

/// Decoding a MemIDX is the same as decoding a u32
pub fn decode_mem_idx(bits: BitArray) {
  use #(idx, rest) <- result.map(decode_u32(bits))
  #(MemIDX(idx), rest)
}

/// Decoding a LocalIDX is the same as decoding a u32
pub fn decode_local_idx(bits: BitArray) {
  use #(idx, rest) <- result.map(decode_u32(bits))
  #(LocalIDX(idx), rest)
}

/// Encoding a LocalIDX is the same as encoding a u32
pub fn encode_local_idx(builder: BytesBuilder, local_idx: LocalIDX) {
  Ok(builder |> encode_u32(local_idx.id))
}

/// Decoding a GlobalIDX is the same as decoding a u32
pub fn decode_global_idx(bits: BitArray) {
  use #(idx, rest) <- result.map(decode_u32(bits))
  #(GlobalIDX(idx), rest)
}

/// Encoding a GlobalIDX is the same as encoding a u32
pub fn encode_global_idx(builder: BytesBuilder, global_idx: GlobalIDX) {
  Ok(builder |> encode_u32(global_idx.id))
}

/// Decoding a DataIDX is the same as decoding a u32
pub fn decode_data_idx(bits: BitArray) {
  use #(idx, rest) <- result.map(decode_u32(bits))
  #(DataIDX(idx), rest)
}

/// Encoding a DataIDX is the same as encoding a u32
pub fn encode_data_idx(builder: BytesBuilder, data_idx: DataIDX) {
  Ok(builder |> encode_u32(data_idx.id))
}

/// Decoding a ElemIDX is the same as decoding a u32
pub fn decode_elem_idx(bits: BitArray) {
  use #(idx, rest) <- result.map(decode_u32(bits))
  #(ElemIDX(idx), rest)
}

/// Encoding a ElemIDX is the same as encoding a u32
pub fn encode_elem_idx(builder: BytesBuilder, elem_idx: ElemIDX) {
  Ok(builder |> encode_u32(elem_idx.id))
}

/// Decoding a LabelIDX is the same as decoding a u32
pub fn decode_label_idx(bits: BitArray) {
  use #(idx, rest) <- result.map(decode_u32(bits))
  #(LabelIDX(idx), rest)
}

/// Encoding a LabelIDX is the same as encoding a u32
pub fn encode_label_idx(builder: BytesBuilder, type_idx: LabelIDX) {
  Ok(builder |> encode_u32(type_idx.id))
}

/// Decoding a limits definition follows two possible formats:
/// 
/// 1. [0x00] [min: u32] - This represents a memory without a maximum size
/// 2. [0x01] [min: u32] [max: u32] - This represents a memory with a maximum size
pub fn decode_limits(bits: BitArray) {
  case bits {
    <<0x00, rest:bits>> -> {
      use #(min, rest) <- result.map(decode_u32(rest))
      #(Limits(min, None), rest)
    }
    <<0x01, rest:bits>> -> {
      use #(min, rest) <- result.try(decode_u32(rest))
      use #(max, rest) <- result.map(decode_u32(rest))
      #(Limits(min, Some(max)), rest)
    }
    _ -> Error("Invalid limits")
  }
}

/// Encoding a limits definition follows two possible formats:
/// 
/// 1. [0x00] [min: u32] - This represents a memory without a maximum size
/// 2. [0x01] [min: u32] [max: u32] - This represents a memory with a maximum size
pub fn encode_limits(builder: BytesBuilder, limits: Limits) {
  case limits.max {
    Some(max) ->
      Ok(
        builder
        |> bytes_builder.append(<<0x01>>)
        |> encode_u32(limits.min)
        |> encode_u32(max),
      )
    None ->
      Ok(
        builder
        |> bytes_builder.append(<<0x00>>)
        |> encode_u32(limits.min),
      )
  }
}

/// Decoding a MemType is the same as decoding a Limits definition
pub fn decode_mem_type(bits: BitArray) {
  use #(limits, rest) <- result.map(decode_limits(bits))
  #(MemType(limits), rest)
}

/// Encoding a MemType is the same as encoding a Limits definition
pub fn encode_mem_type(builder: BytesBuilder, mem_type: MemType) {
  builder |> encode_limits(mem_type.limits)
}

/// Table types are encoded using the following format:
/// 
/// TableType -> [ref_type: RefType] [limits: Limits]
pub fn decode_table_type(rest: BitArray) {
  use #(rt, rest) <- result.try(decode_ref_type(rest))
  use #(limits, rest) <- result.map(decode_limits(rest))
  #(TableType(rt, limits), rest)
}

/// Table types are encoded using the following format:
/// 
/// TableType -> [ref_type: RefType] [limits: Limits]
pub fn encode_table_type(builder: BytesBuilder, table_type: TableType) {
  use builder <- result.try(builder |> encode_ref_type(table_type.t))
  builder |> encode_limits(table_type.limits)
}

/// Global types are encoded using the following format:
/// 
/// GlobalType -> [val_type: ValType] [mutability: Mutability]
pub fn decode_global_type(rest: BitArray) {
  use #(vt, rest) <- result.try(decode_val_type(rest))
  use #(mutability, rest) <- result.map(decode_mut(rest))
  #(GlobalType(vt, mutability), rest)
}

/// Global types are encoded using the following format:
/// 
/// GlobalType -> [val_type: ValType] [mutability: Mutability]
pub fn encode_global_type(builder: BytesBuilder, global_type: GlobalType) {
  use builder <- result.try(builder |> encode_val_type(global_type.vt))
  builder |> encode_mut(global_type.mut)
}

/// Block types are encoded into three possible formats:
/// 
/// 1. [0x40] - This represents a void block without any operands or results
/// 2. A single ValType - This represents a block type that consumes a single ValType
///    operand.
/// 3. A single TypeIDX - This represents a block type that has the same definition
///    as a function type in the type section.
pub fn decode_block_type(bits: BitArray) {
  case bits {
    <<0x40, rest:bits>> -> Ok(#(VoidBlockType, rest))
    _ -> {
      case bits |> decode_val_type {
        Ok(#(vt, rest)) -> Ok(#(ValTypeBlockType(vt), rest))
        _ -> {
          use #(s33_value, rest) <- result.try(values.decode_s33(bits))
          use u32_value <- result.map(
            s33_value |> numbers.unwrap_s33 |> numbers.u32,
          )
          #(FuncTypeBlockType(TypeIDX(u32_value)), rest)
        }
      }
    }
  }
}

/// Block types are encoded into three possible formats:
/// 
/// 1. [0x40] - This represents a void block without any operands or results
/// 2. A single ValType - This represents a block type that consumes a single ValType
///    operand.
/// 3. A single TypeIDX - This represents a block type that has the same definition
///    as a function type in the type section.
pub fn encode_block_type(builder: BytesBuilder, block_type: BlockType) {
  case block_type {
    VoidBlockType -> Ok(builder |> bytes_builder.append(<<0x40>>))
    ValTypeBlockType(vt) -> builder |> encode_val_type(vt)
    FuncTypeBlockType(TypeIDX(type_idx)) -> {
      use s33_value <- result.map(type_idx |> unwrap_u32 |> s33)
      builder |> encode_s33(s33_value)
    }
    _ ->
      panic as "Concrete block types cannot be encoded. Something went wrong."
  }
}

/// Cast flags define the behavior of the `cast` instruction, defining which
/// heap type operands are nullable.
/// 
/// Please see the control instructions for more information:
/// https://webassembly.github.io/gc/core/binary/instructions.html#control-instructions
pub fn decode_cast_flags(bits: BitArray) {
  case bits {
    <<0x00, rest:bits>> -> Ok(#(#(False, False), rest))
    <<0x01, rest:bits>> -> Ok(#(#(True, False), rest))
    <<0x02, rest:bits>> -> Ok(#(#(False, True), rest))
    <<0x03, rest:bits>> -> Ok(#(#(True, True), rest))
    _ -> Error("Invalid cast flags")
  }
}

/// Cast flags define the behavior of the `cast` instruction, defining which
/// heap type operands are nullable.
/// 
/// Please see the control instructions for more information:
/// https://webassembly.github.io/gc/core/binary/instructions.html#control-instructions
pub fn encode_cast_flags(builder: BytesBuilder, cast_flags: #(Bool, Bool)) {
  case cast_flags {
    #(False, False) -> Ok(builder |> bytes_builder.append(<<0x00>>))
    #(True, False) -> Ok(builder |> bytes_builder.append(<<0x01>>))
    #(False, True) -> Ok(builder |> bytes_builder.append(<<0x02>>))
    #(True, True) -> Ok(builder |> bytes_builder.append(<<0x03>>))
  }
}

/// MemArgs define the way load and store operations work in linear memory. They use the
/// following format:
/// 
/// MemArg -> [offset: u32] [align: u32]
pub fn decode_mem_arg(bits: BitArray) {
  use #(offset, rest) <- result.try(decode_u32(bits))
  use #(align, rest) <- result.map(decode_u32(rest))
  #(MemArg(offset, align), rest)
}

/// MemArgs define the way load and store operations work in linear memory. They use the
/// following format:
/// 
/// MemArg -> [offset: u32] [align: u32]
pub fn encode_mem_arg(builder: BytesBuilder, mem_arg: MemArg) {
  Ok(
    builder
    |> encode_u32(mem_arg.offset)
    |> encode_u32(mem_arg.align),
  )
}

/// An expression is simply a list of instructions that are executed in order, followed
/// by an "end" instruction [0x0B]
pub fn encode_expression(
  builder: BytesBuilder,
  expression: Expr,
) -> Result(BytesBuilder, String) {
  let insts = expression.insts

  use builder <- result.map(
    builder
    |> do_encode_instructions(insts),
  )
  builder
  |> bytes_builder.append(<<0x0B>>)
}

/// This function takes a list of instructions and encodes them into a given BytesBuilder
/// until the list is empty.
pub fn do_encode_instructions(
  builder: BytesBuilder,
  insts: FingerTree(Instruction),
) -> Result(BytesBuilder, String) {
  insts
  |> finger_tree.try_reducel(builder, encode_instruction)
}

/// This function decodes an expression from a given BitArray, stopping when it
/// encounters an "end" instruction.
pub fn decode_expression(bits: BitArray) -> Result(#(Expr, BitArray), String) {
  do_decode_expression(bits, finger_tree.empty)
}

fn do_decode_expression(
  bits: BitArray,
  acc: FingerTree(Instruction),
) -> Result(#(Expr, BitArray), String) {
  case bits {
    <<0x0B, rest:bits>> -> Ok(#(Expr(acc), rest))
    _ -> {
      use #(inst, rest) <- result.try(decode_instruction(bits))
      do_decode_expression(rest, acc |> finger_tree.push(inst))
    }
  }
}

/// This function decodes an if instruction, which is a special type of block
/// that can contain an "else" instruction that denotes an alternative case
/// if the condition is false.
/// 
/// If an "end" is encountered before an "else" is encountered, the "else" branch
/// is set to None, and the "If" instruction is returned.
fn do_decode_if_instruction(
  bits: BitArray,
  bt: BlockType,
  acc: FingerTree(Instruction),
) -> Result(#(Instruction, BitArray), String) {
  case bits {
    <<0x0B, rest:bits>> -> Ok(#(If(bt, acc, None), rest))
    <<0x05, rest:bits>> -> {
      do_decode_else_instruction(rest, bt, acc, finger_tree.empty)
    }
    _ -> {
      use #(inst, rest) <- result.try(decode_instruction(bits))
      do_decode_if_instruction(rest, bt, acc |> finger_tree.push(inst))
    }
  }
}

/// This function decodes the "else" half of an if instruction. When it encounters
/// an "end" instruction, it returns the "If" instruction with the accumulated instructions
/// in both blocks.
fn do_decode_else_instruction(
  bits: BitArray,
  bt: BlockType,
  if_acc: FingerTree(Instruction),
  else_acc: FingerTree(Instruction),
) -> Result(#(Instruction, BitArray), String) {
  case bits {
    <<0x0B, rest:bits>> -> Ok(#(If(bt, if_acc, Some(else_acc)), rest))
    _ -> {
      use #(inst, rest) <- result.try(decode_instruction(bits))
      do_decode_else_instruction(
        rest,
        bt,
        if_acc,
        else_acc |> finger_tree.push(inst),
      )
    }
  }
}

/// For information on how each instruction is encoded, please see the specification:
/// 
/// https://webassembly.github.io/gc/core/binary/instructions.html#instructions
pub fn encode_instruction(
  builder: BytesBuilder,
  instruction: Instruction,
) -> Result(BytesBuilder, String) {
  case instruction {
    Unreachable -> Ok(builder |> bytes_builder.append(<<0x00>>))
    Nop -> Ok(builder |> bytes_builder.append(<<0x01>>))
    Block(block_type, expression) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x02>>)
        |> encode_block_type(block_type),
      )
      builder |> encode_expression(expression)
    }
    Loop(block_type, expression) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x03>>)
        |> encode_block_type(block_type),
      )
      builder |> encode_expression(expression)
    }
    If(block_type, then_expression, else_expression) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x04>>)
        |> encode_block_type(block_type),
      )
      use builder <- result.try(
        builder
        |> do_encode_instructions(then_expression),
      )
      case else_expression {
        Some(else_expression) -> {
          use builder <- result.map(
            builder
            |> bytes_builder.append(<<0x05>>)
            |> do_encode_instructions(else_expression),
          )
          builder |> bytes_builder.append(<<0x0B>>)
        }
        None ->
          Ok(
            builder
            |> bytes_builder.append(<<0x0B>>),
          )
      }
    }
    Br(LabelIDX(label_idx)) -> {
      builder
      |> bytes_builder.append(<<0x0C>>)
      |> encode_u32(label_idx)
      |> Ok
    }
    BrIf(LabelIDX(label_idx)) -> {
      builder
      |> bytes_builder.append(<<0x0D>>)
      |> encode_u32(label_idx)
      |> Ok
    }
    BrTable(labels, label_default) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x0E>>)
        |> common.encode_vec(labels, encode_label_idx),
      )
      builder |> encode_label_idx(label_default)
    }
    Return -> Ok(builder |> bytes_builder.append(<<0x0F>>))
    Call(FuncIDX(function_idx)) -> {
      builder
      |> bytes_builder.append(<<0x10>>)
      |> encode_u32(function_idx)
      |> Ok
    }
    CallIndirect(table_idx, type_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x11>>)
        |> encode_type_idx(type_idx),
      )
      builder |> encode_table_idx(table_idx)
    }
    ReturnCall(func_idx) -> {
      builder
      |> bytes_builder.append(<<0x12>>)
      |> encode_func_idx(func_idx)
    }
    ReturnCallIndirect(table_idx, type_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0x13>>)
        |> encode_type_idx(type_idx),
      )
      builder |> encode_table_idx(table_idx)
    }
    CallRef(type_idx) ->
      builder
      |> bytes_builder.append(<<0x14>>)
      |> encode_type_idx(type_idx)
    ReturnCallRef(type_idx) ->
      builder
      |> bytes_builder.append(<<0x15>>)
      |> encode_type_idx(type_idx)
    BrOnNull(label_idx) -> {
      builder
      |> bytes_builder.append(<<0xD5>>)
      |> encode_label_idx(label_idx)
    }
    BrOnNonNull(label_idx) -> {
      builder
      |> bytes_builder.append(<<0xD6>>)
      |> encode_label_idx(label_idx)
    }
    LocalGet(local_idx) -> {
      builder
      |> bytes_builder.append(<<0x20>>)
      |> encode_local_idx(local_idx)
    }
    LocalSet(local_idx) -> {
      builder
      |> bytes_builder.append(<<0x21>>)
      |> encode_local_idx(local_idx)
    }
    LocalTee(local_idx) -> {
      builder
      |> bytes_builder.append(<<0x22>>)
      |> encode_local_idx(local_idx)
    }
    GlobalGet(global_idx) -> {
      builder
      |> bytes_builder.append(<<0x23>>)
      |> encode_global_idx(global_idx)
    }
    GlobalSet(global_idx) -> {
      builder
      |> bytes_builder.append(<<0x24>>)
      |> encode_global_idx(global_idx)
    }
    TableGet(table_idx) -> {
      builder
      |> bytes_builder.append(<<0x25>>)
      |> encode_table_idx(table_idx)
    }
    TableSet(table_idx) -> {
      builder
      |> bytes_builder.append(<<0x26>>)
      |> encode_table_idx(table_idx)
    }

    I32Load(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x28>>)
      |> encode_mem_arg(mem_arg)
    I64Load(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x29>>)
      |> encode_mem_arg(mem_arg)
    F32Load(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x2A>>)
      |> encode_mem_arg(mem_arg)
    F64Load(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x2B>>)
      |> encode_mem_arg(mem_arg)
    I32Load8S(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x2C>>)
      |> encode_mem_arg(mem_arg)
    I32Load8U(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x2D>>)
      |> encode_mem_arg(mem_arg)
    I32Load16S(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x2E>>)
      |> encode_mem_arg(mem_arg)
    I32Load16U(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x2F>>)
      |> encode_mem_arg(mem_arg)
    I64Load8S(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x30>>)
      |> encode_mem_arg(mem_arg)
    I64Load8U(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x31>>)
      |> encode_mem_arg(mem_arg)
    I64Load16S(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x32>>)
      |> encode_mem_arg(mem_arg)
    I64Load16U(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x33>>)
      |> encode_mem_arg(mem_arg)
    I64Load32S(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x34>>)
      |> encode_mem_arg(mem_arg)
    I64Load32U(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x35>>)
      |> encode_mem_arg(mem_arg)
    I32Store(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x36>>)
      |> encode_mem_arg(mem_arg)
    I64Store(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x37>>)
      |> encode_mem_arg(mem_arg)
    F32Store(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x38>>)
      |> encode_mem_arg(mem_arg)
    F64Store(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x39>>)
      |> encode_mem_arg(mem_arg)
    I32Store8(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x3A>>)
      |> encode_mem_arg(mem_arg)
    I32Store16(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x3B>>)
      |> encode_mem_arg(mem_arg)
    I64Store8(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x3C>>)
      |> encode_mem_arg(mem_arg)
    I64Store16(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x3D>>)
      |> encode_mem_arg(mem_arg)
    I64Store32(mem_arg) ->
      builder
      |> bytes_builder.append(<<0x3E>>)
      |> encode_mem_arg(mem_arg)
    MemorySize -> Ok(builder |> bytes_builder.append(<<0x3F, 0x00>>))
    MemoryGrow -> Ok(builder |> bytes_builder.append(<<0x40, 0x00>>))
    I32Const(i32_val) ->
      builder
      |> bytes_builder.append(<<0x41>>)
      |> encode_i32(i32_val)
      |> Ok
    I64Const(i64_val) ->
      builder
      |> bytes_builder.append(<<0x42>>)
      |> encode_i64(i64_val)
      |> Ok
    F32Const(f32_val) ->
      builder
      |> bytes_builder.append(<<0x43>>)
      |> encode_f32(f32_val)
      |> Ok
    F64Const(f64_val) ->
      builder
      |> bytes_builder.append(<<0x44>>)
      |> encode_f64(f64_val)
      |> Ok
    I32Eqz -> Ok(builder |> bytes_builder.append(<<0x45>>))
    I32Eq -> Ok(builder |> bytes_builder.append(<<0x46>>))
    I32Ne -> Ok(builder |> bytes_builder.append(<<0x47>>))
    I32LtS -> Ok(builder |> bytes_builder.append(<<0x48>>))
    I32LtU -> Ok(builder |> bytes_builder.append(<<0x49>>))
    I32GtS -> Ok(builder |> bytes_builder.append(<<0x4A>>))
    I32GtU -> Ok(builder |> bytes_builder.append(<<0x4B>>))
    I32LeS -> Ok(builder |> bytes_builder.append(<<0x4C>>))
    I32LeU -> Ok(builder |> bytes_builder.append(<<0x4D>>))
    I32GeS -> Ok(builder |> bytes_builder.append(<<0x4E>>))
    I32GeU -> Ok(builder |> bytes_builder.append(<<0x4F>>))
    I64Eqz -> Ok(builder |> bytes_builder.append(<<0x50>>))
    I64Eq -> Ok(builder |> bytes_builder.append(<<0x51>>))
    I64Ne -> Ok(builder |> bytes_builder.append(<<0x52>>))
    I64LtS -> Ok(builder |> bytes_builder.append(<<0x53>>))
    I64LtU -> Ok(builder |> bytes_builder.append(<<0x54>>))
    I64GtS -> Ok(builder |> bytes_builder.append(<<0x55>>))
    I64GtU -> Ok(builder |> bytes_builder.append(<<0x56>>))
    I64LeS -> Ok(builder |> bytes_builder.append(<<0x57>>))
    I64LeU -> Ok(builder |> bytes_builder.append(<<0x58>>))
    I64GeS -> Ok(builder |> bytes_builder.append(<<0x59>>))
    I64GeU -> Ok(builder |> bytes_builder.append(<<0x5A>>))
    F32Eq -> Ok(builder |> bytes_builder.append(<<0x5B>>))
    F32Ne -> Ok(builder |> bytes_builder.append(<<0x5C>>))
    F32Lt -> Ok(builder |> bytes_builder.append(<<0x5D>>))
    F32Gt -> Ok(builder |> bytes_builder.append(<<0x5E>>))
    F32Le -> Ok(builder |> bytes_builder.append(<<0x5F>>))
    F32Ge -> Ok(builder |> bytes_builder.append(<<0x60>>))
    F64Eq -> Ok(builder |> bytes_builder.append(<<0x61>>))
    F64Ne -> Ok(builder |> bytes_builder.append(<<0x62>>))
    F64Lt -> Ok(builder |> bytes_builder.append(<<0x63>>))
    F64Gt -> Ok(builder |> bytes_builder.append(<<0x64>>))
    F64Le -> Ok(builder |> bytes_builder.append(<<0x65>>))
    F64Ge -> Ok(builder |> bytes_builder.append(<<0x66>>))
    I32Clz -> Ok(builder |> bytes_builder.append(<<0x67>>))
    I32Ctz -> Ok(builder |> bytes_builder.append(<<0x68>>))
    I32Popcnt -> Ok(builder |> bytes_builder.append(<<0x69>>))
    I32Add -> Ok(builder |> bytes_builder.append(<<0x6A>>))
    I32Sub -> Ok(builder |> bytes_builder.append(<<0x6B>>))
    I32Mul -> Ok(builder |> bytes_builder.append(<<0x6C>>))
    I32DivS -> Ok(builder |> bytes_builder.append(<<0x6D>>))
    I32DivU -> Ok(builder |> bytes_builder.append(<<0x6E>>))
    I32RemS -> Ok(builder |> bytes_builder.append(<<0x6F>>))
    I32RemU -> Ok(builder |> bytes_builder.append(<<0x70>>))
    I32And -> Ok(builder |> bytes_builder.append(<<0x71>>))
    I32Or -> Ok(builder |> bytes_builder.append(<<0x72>>))
    I32Xor -> Ok(builder |> bytes_builder.append(<<0x73>>))
    I32Shl -> Ok(builder |> bytes_builder.append(<<0x74>>))
    I32ShrS -> Ok(builder |> bytes_builder.append(<<0x75>>))
    I32ShrU -> Ok(builder |> bytes_builder.append(<<0x76>>))
    I32Rotl -> Ok(builder |> bytes_builder.append(<<0x77>>))
    I32Rotr -> Ok(builder |> bytes_builder.append(<<0x78>>))
    I64Clz -> Ok(builder |> bytes_builder.append(<<0x79>>))
    I64Ctz -> Ok(builder |> bytes_builder.append(<<0x7A>>))
    I64Popcnt -> Ok(builder |> bytes_builder.append(<<0x7B>>))
    I64Add -> Ok(builder |> bytes_builder.append(<<0x7C>>))
    I64Sub -> Ok(builder |> bytes_builder.append(<<0x7D>>))
    I64Mul -> Ok(builder |> bytes_builder.append(<<0x7E>>))
    I64DivS -> Ok(builder |> bytes_builder.append(<<0x7F>>))
    I64DivU -> Ok(builder |> bytes_builder.append(<<0x80>>))
    I64RemS -> Ok(builder |> bytes_builder.append(<<0x81>>))
    I64RemU -> Ok(builder |> bytes_builder.append(<<0x82>>))
    I64And -> Ok(builder |> bytes_builder.append(<<0x83>>))
    I64Or -> Ok(builder |> bytes_builder.append(<<0x84>>))
    I64Xor -> Ok(builder |> bytes_builder.append(<<0x85>>))
    I64Shl -> Ok(builder |> bytes_builder.append(<<0x86>>))
    I64ShrS -> Ok(builder |> bytes_builder.append(<<0x87>>))
    I64ShrU -> Ok(builder |> bytes_builder.append(<<0x88>>))
    I64Rotl -> Ok(builder |> bytes_builder.append(<<0x89>>))
    I64Rotr -> Ok(builder |> bytes_builder.append(<<0x8A>>))
    F32Abs -> Ok(builder |> bytes_builder.append(<<0x8B>>))
    F32Neg -> Ok(builder |> bytes_builder.append(<<0x8C>>))
    F32Ceil -> Ok(builder |> bytes_builder.append(<<0x8D>>))
    F32Floor -> Ok(builder |> bytes_builder.append(<<0x8E>>))
    F32Trunc -> Ok(builder |> bytes_builder.append(<<0x8F>>))
    F32Nearest -> Ok(builder |> bytes_builder.append(<<0x90>>))
    F32Sqrt -> Ok(builder |> bytes_builder.append(<<0x91>>))
    F32Add -> Ok(builder |> bytes_builder.append(<<0x92>>))
    F32Sub -> Ok(builder |> bytes_builder.append(<<0x93>>))
    F32Mul -> Ok(builder |> bytes_builder.append(<<0x94>>))
    F32Div -> Ok(builder |> bytes_builder.append(<<0x95>>))
    F32Min -> Ok(builder |> bytes_builder.append(<<0x96>>))
    F32Max -> Ok(builder |> bytes_builder.append(<<0x97>>))
    F32Copysign -> Ok(builder |> bytes_builder.append(<<0x98>>))
    F64Abs -> Ok(builder |> bytes_builder.append(<<0x99>>))
    F64Neg -> Ok(builder |> bytes_builder.append(<<0x9A>>))
    F64Ceil -> Ok(builder |> bytes_builder.append(<<0x9B>>))
    F64Floor -> Ok(builder |> bytes_builder.append(<<0x9C>>))
    F64Trunc -> Ok(builder |> bytes_builder.append(<<0x9D>>))
    F64Nearest -> Ok(builder |> bytes_builder.append(<<0x9E>>))
    F64Sqrt -> Ok(builder |> bytes_builder.append(<<0x9F>>))
    F64Add -> Ok(builder |> bytes_builder.append(<<0xA0>>))
    F64Sub -> Ok(builder |> bytes_builder.append(<<0xA1>>))
    F64Mul -> Ok(builder |> bytes_builder.append(<<0xA2>>))
    F64Div -> Ok(builder |> bytes_builder.append(<<0xA3>>))
    F64Min -> Ok(builder |> bytes_builder.append(<<0xA4>>))
    F64Max -> Ok(builder |> bytes_builder.append(<<0xA5>>))
    F64Copysign -> Ok(builder |> bytes_builder.append(<<0xA6>>))
    I32WrapI64 -> Ok(builder |> bytes_builder.append(<<0xA7>>))
    I32TruncF32S -> Ok(builder |> bytes_builder.append(<<0xA8>>))
    I32TruncF32U -> Ok(builder |> bytes_builder.append(<<0xA9>>))
    I32TruncF64S -> Ok(builder |> bytes_builder.append(<<0xAA>>))
    I32TruncF64U -> Ok(builder |> bytes_builder.append(<<0xAB>>))
    I64ExtendI32S -> Ok(builder |> bytes_builder.append(<<0xAC>>))
    I64ExtendI32U -> Ok(builder |> bytes_builder.append(<<0xAD>>))
    I64TruncF32S -> Ok(builder |> bytes_builder.append(<<0xAE>>))
    I64TruncF32U -> Ok(builder |> bytes_builder.append(<<0xAF>>))
    I64TruncF64S -> Ok(builder |> bytes_builder.append(<<0xB0>>))
    I64TruncF64U -> Ok(builder |> bytes_builder.append(<<0xB1>>))
    F32ConvertI32S -> Ok(builder |> bytes_builder.append(<<0xB2>>))
    F32ConvertI32U -> Ok(builder |> bytes_builder.append(<<0xB3>>))
    F32ConvertI64S -> Ok(builder |> bytes_builder.append(<<0xB4>>))
    F32ConvertI64U -> Ok(builder |> bytes_builder.append(<<0xB5>>))
    F32DemoteF64 -> Ok(builder |> bytes_builder.append(<<0xB6>>))
    F64ConvertI32S -> Ok(builder |> bytes_builder.append(<<0xB7>>))
    F64ConvertI32U -> Ok(builder |> bytes_builder.append(<<0xB8>>))
    F64ConvertI64S -> Ok(builder |> bytes_builder.append(<<0xB9>>))
    F64ConvertI64U -> Ok(builder |> bytes_builder.append(<<0xBA>>))
    F64PromoteF32 -> Ok(builder |> bytes_builder.append(<<0xBB>>))
    I32ReinterpretF32 -> Ok(builder |> bytes_builder.append(<<0xBC>>))
    I64ReinterpretF64 -> Ok(builder |> bytes_builder.append(<<0xBD>>))
    F32ReinterpretI32 -> Ok(builder |> bytes_builder.append(<<0xBE>>))
    F64ReinterpretI64 -> Ok(builder |> bytes_builder.append(<<0xBF>>))
    I32Extend8S -> Ok(builder |> bytes_builder.append(<<0xC0>>))
    I32Extend16S -> Ok(builder |> bytes_builder.append(<<0xC1>>))
    I64Extend8S -> Ok(builder |> bytes_builder.append(<<0xC2>>))
    I64Extend16S -> Ok(builder |> bytes_builder.append(<<0xC3>>))
    I64Extend32S -> Ok(builder |> bytes_builder.append(<<0xC4>>))
    I32TruncSatF32S -> Ok(builder |> bytes_builder.append(<<0xFC, 0>>))
    I32TruncSatF32U -> Ok(builder |> bytes_builder.append(<<0xFC, 1>>))
    I32TruncSatF64S -> Ok(builder |> bytes_builder.append(<<0xFC, 2>>))
    I32TruncSatF64U -> Ok(builder |> bytes_builder.append(<<0xFC, 3>>))
    I64TruncSatF32S -> Ok(builder |> bytes_builder.append(<<0xFC, 4>>))
    I64TruncSatF32U -> Ok(builder |> bytes_builder.append(<<0xFC, 5>>))
    I64TruncSatF64S -> Ok(builder |> bytes_builder.append(<<0xFC, 6>>))
    I64TruncSatF64U -> Ok(builder |> bytes_builder.append(<<0xFC, 7>>))
    TableInit(elem_idx, table_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFC, 12>>)
        |> encode_elem_idx(elem_idx),
      )
      builder |> encode_table_idx(table_idx)
    }
    ElemDrop(elem_idx) ->
      builder
      |> bytes_builder.append(<<0xFC, 13>>)
      |> encode_elem_idx(elem_idx)

    MemoryInit(data_idx) -> {
      use builder <- result.map(
        builder
        |> bytes_builder.append(<<0xFC, 8>>)
        |> encode_data_idx(data_idx),
      )
      builder |> bytes_builder.append(<<0x00>>)
    }
    DataDrop(data_idx) ->
      builder
      |> bytes_builder.append(<<0xFC, 9>>)
      |> encode_data_idx(data_idx)
    TableCopy(table_idx1, table_idx2) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFC, 14>>)
        |> encode_table_idx(table_idx1),
      )
      builder |> encode_table_idx(table_idx2)
    }
    TableGrow(table_idx) ->
      builder
      |> bytes_builder.append(<<0xFC, 15>>)
      |> encode_table_idx(table_idx)
    TableSize(table_idx) ->
      builder
      |> bytes_builder.append(<<0xFC, 16>>)
      |> encode_table_idx(table_idx)
    TableFill(table_idx) ->
      builder
      |> bytes_builder.append(<<0xFC, 17>>)
      |> encode_table_idx(table_idx)
    MemoryCopy -> Ok(builder |> bytes_builder.append(<<0xFC, 10, 0x00, 0x00>>))
    MemoryFill -> Ok(builder |> bytes_builder.append(<<0xFC, 11, 0x00>>))
    I32x4ExtaddPairwiseI16x8S ->
      Ok(builder |> bytes_builder.append(<<0xFD, 126>>))
    I32x4ExtaddPairwiseI16x8U ->
      Ok(builder |> bytes_builder.append(<<0xFD, 127>>))
    I32x4Abs -> Ok(builder |> bytes_builder.append(<<0xFD, 160, 1>>))
    I32x4Neg -> Ok(builder |> bytes_builder.append(<<0xFD, 161, 1>>))
    I32x4AllTrue -> Ok(builder |> bytes_builder.append(<<0xFD, 163, 1>>))
    I32x4Bitmask -> Ok(builder |> bytes_builder.append(<<0xFD, 164, 1>>))
    I32x4ExtendLowI16x8S ->
      Ok(builder |> bytes_builder.append(<<0xFD, 167, 1>>))
    I32x4ExtendHighI16x8S ->
      Ok(builder |> bytes_builder.append(<<0xFD, 168, 1>>))
    I32x4ExtendLowI16x8U ->
      Ok(builder |> bytes_builder.append(<<0xFD, 169, 1>>))
    I32x4ExtendHighI16x8U ->
      Ok(builder |> bytes_builder.append(<<0xFD, 170, 1>>))
    I32x4Shl -> Ok(builder |> bytes_builder.append(<<0xFD, 171, 1>>))
    I32x4ShrS -> Ok(builder |> bytes_builder.append(<<0xFD, 172, 1>>))
    I32x4ShrU -> Ok(builder |> bytes_builder.append(<<0xFD, 173, 1>>))
    I32x4Add -> Ok(builder |> bytes_builder.append(<<0xFD, 174, 1>>))
    I32x4Sub -> Ok(builder |> bytes_builder.append(<<0xFD, 177, 1>>))
    I32x4Mul -> Ok(builder |> bytes_builder.append(<<0xFD, 181, 1>>))
    I32x4MinS -> Ok(builder |> bytes_builder.append(<<0xFD, 182, 1>>))
    I32x4MinU -> Ok(builder |> bytes_builder.append(<<0xFD, 183, 1>>))
    I32x4MaxS -> Ok(builder |> bytes_builder.append(<<0xFD, 184, 1>>))
    I32x4MaxU -> Ok(builder |> bytes_builder.append(<<0xFD, 185, 1>>))
    I32x4DotI16x8S -> Ok(builder |> bytes_builder.append(<<0xFD, 186, 1>>))
    I32x4ExtmulLowI16x8S ->
      Ok(builder |> bytes_builder.append(<<0xFD, 188, 1>>))
    I32x4ExtmulHighI16x8S ->
      Ok(builder |> bytes_builder.append(<<0xFD, 189, 1>>))
    I32x4ExtmulLowI16x8U ->
      Ok(builder |> bytes_builder.append(<<0xFD, 190, 1>>))
    I32x4ExtmulHighI16x8U ->
      Ok(builder |> bytes_builder.append(<<0xFD, 191, 1>>))
    I64x2Abs -> Ok(builder |> bytes_builder.append(<<0xFD, 192, 1>>))
    I64x2Neg -> Ok(builder |> bytes_builder.append(<<0xFD, 193, 1>>))
    I64x2AllTrue -> Ok(builder |> bytes_builder.append(<<0xFD, 195, 1>>))
    I64x2Bitmask -> Ok(builder |> bytes_builder.append(<<0xFD, 196, 1>>))
    I64x2ExtendLowI32x4S ->
      Ok(builder |> bytes_builder.append(<<0xFD, 199, 1>>))
    I64x2ExtendHighI32x4S ->
      Ok(builder |> bytes_builder.append(<<0xFD, 200, 1>>))
    I64x2ExtendLowI32x4U ->
      Ok(builder |> bytes_builder.append(<<0xFD, 201, 1>>))
    I64x2ExtendHighI32x4U ->
      Ok(builder |> bytes_builder.append(<<0xFD, 202, 1>>))
    I64x2Shl -> Ok(builder |> bytes_builder.append(<<0xFD, 203, 1>>))
    I64x2ShrS -> Ok(builder |> bytes_builder.append(<<0xFD, 204, 1>>))
    I64x2ShrU -> Ok(builder |> bytes_builder.append(<<0xFD, 205, 1>>))
    I64x2Add -> Ok(builder |> bytes_builder.append(<<0xFD, 206, 1>>))
    I64x2Sub -> Ok(builder |> bytes_builder.append(<<0xFD, 209, 1>>))
    I64x2Mul -> Ok(builder |> bytes_builder.append(<<0xFD, 213, 1>>))
    I64x2ExtmulLowI32x4S ->
      Ok(builder |> bytes_builder.append(<<0xFD, 220, 1>>))
    I64x2ExtmulHighI32x4S ->
      Ok(builder |> bytes_builder.append(<<0xFD, 221, 1>>))
    I64x2ExtmulLowI32x4U ->
      Ok(builder |> bytes_builder.append(<<0xFD, 222, 1>>))
    I64x2ExtmulHighI32x4U ->
      Ok(builder |> bytes_builder.append(<<0xFD, 223, 1>>))
    F32x4Abs -> Ok(builder |> bytes_builder.append(<<0xFD, 224, 1>>))
    F32x4Neg -> Ok(builder |> bytes_builder.append(<<0xFD, 225, 1>>))
    F32x4Sqrt -> Ok(builder |> bytes_builder.append(<<0xFD, 227, 1>>))
    F32x4Add -> Ok(builder |> bytes_builder.append(<<0xFD, 228, 1>>))
    F32x4Sub -> Ok(builder |> bytes_builder.append(<<0xFD, 229, 1>>))
    F32x4Mul -> Ok(builder |> bytes_builder.append(<<0xFD, 230, 1>>))
    F32x4Div -> Ok(builder |> bytes_builder.append(<<0xFD, 231, 1>>))
    F32x4Min -> Ok(builder |> bytes_builder.append(<<0xFD, 232, 1>>))
    F32x4Max -> Ok(builder |> bytes_builder.append(<<0xFD, 233, 1>>))
    F32x4Pmin -> Ok(builder |> bytes_builder.append(<<0xFD, 234, 1>>))
    F32x4Pmax -> Ok(builder |> bytes_builder.append(<<0xFD, 235, 1>>))
    F64x2Abs -> Ok(builder |> bytes_builder.append(<<0xFD, 236, 1>>))
    F64x2Neg -> Ok(builder |> bytes_builder.append(<<0xFD, 237, 1>>))
    F64x2Sqrt -> Ok(builder |> bytes_builder.append(<<0xFD, 239, 1>>))
    F64x2Add -> Ok(builder |> bytes_builder.append(<<0xFD, 240, 1>>))
    F64x2Sub -> Ok(builder |> bytes_builder.append(<<0xFD, 241, 1>>))
    F64x2Mul -> Ok(builder |> bytes_builder.append(<<0xFD, 242, 1>>))
    F64x2Div -> Ok(builder |> bytes_builder.append(<<0xFD, 243, 1>>))
    F64x2Min -> Ok(builder |> bytes_builder.append(<<0xFD, 244, 1>>))
    F64x2Max -> Ok(builder |> bytes_builder.append(<<0xFD, 245, 1>>))
    F64x2Pmin -> Ok(builder |> bytes_builder.append(<<0xFD, 246, 1>>))
    F64x2Pmax -> Ok(builder |> bytes_builder.append(<<0xFD, 247, 1>>))
    I32x4TruncSatF32x4S -> Ok(builder |> bytes_builder.append(<<0xFD, 248, 1>>))
    I32x4TruncSatF32x4U -> Ok(builder |> bytes_builder.append(<<0xFD, 249, 1>>))
    F32x4ConvertI32x4S -> Ok(builder |> bytes_builder.append(<<0xFD, 250, 1>>))
    F32x4ConvertI32x4U -> Ok(builder |> bytes_builder.append(<<0xFD, 251, 1>>))
    I32x4TruncSatF64x2SZero ->
      Ok(builder |> bytes_builder.append(<<0xFD, 252, 1>>))
    I32x4TruncSatF64x2UZero ->
      Ok(builder |> bytes_builder.append(<<0xFD, 253, 1>>))
    F64x2ConvertLowI32x4S ->
      Ok(builder |> bytes_builder.append(<<0xFD, 254, 1>>))
    F64x2ConvertLowI32x4U ->
      Ok(builder |> bytes_builder.append(<<0xFD, 255, 1>>))
    Drop ->
      builder
      |> bytes_builder.append(<<0x1A>>)
      |> Ok
    // 0xFB 0 𝑥:typeidx -> struct.new 𝑥
    StructNew(type_idx) ->
      builder
      |> bytes_builder.append(<<0xFB, 0>>)
      |> encode_type_idx(type_idx)
    // 0xFB 1 𝑥:typeidx -> struct.new_default 𝑥
    StructNewDefault(type_idx) ->
      builder
      |> bytes_builder.append(<<0xFB, 1>>)
      |> encode_type_idx(type_idx)
    // 0xFB 2 𝑥:typeidx 𝑦:fieldidx -> struct.get 𝑥 𝑦
    StructGet(type_idx, field_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFB, 2>>)
        |> encode_type_idx(type_idx),
      )
      builder
      |> encode_field_idx(field_idx)
    }
    // 0xFB 3 𝑥:typeidx 𝑦:fieldidx -> struct.get_s 𝑥 𝑦
    StructGetS(type_idx, field_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFB, 3>>)
        |> encode_type_idx(type_idx),
      )
      builder
      |> encode_field_idx(field_idx)
    }
    // 0xFB 4 𝑥:typeidx 𝑦:fieldidx -> struct.get_u 𝑥 𝑦
    StructGetU(type_idx, field_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFB, 4>>)
        |> encode_type_idx(type_idx),
      )
      builder
      |> encode_field_idx(field_idx)
    }
    // 0xFB 5 𝑥:typeidx 𝑦:fieldidx -> struct.set 𝑥 𝑦
    StructSet(type_idx, field_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFB, 5>>)
        |> encode_type_idx(type_idx),
      )
      builder
      |> encode_field_idx(field_idx)
    }
    // 0xFB 6 𝑥:typeidx -> array.new 𝑥
    ArrayNew(type_idx) ->
      builder
      |> bytes_builder.append(<<0xFB, 6>>)
      |> encode_type_idx(type_idx)
    // 0xFB 7 𝑥:typeidx -> array.new_default 𝑥
    ArrayNewDefault(type_idx) ->
      builder
      |> bytes_builder.append(<<0xFB, 7>>)
      |> encode_type_idx(type_idx)
    // 0xFB 8 𝑥:typeidx 𝑛:u32 -> array.new_fixed 𝑥 𝑛
    ArrayNewFixed(type_idx, size) -> {
      use builder <- result.map(
        builder
        |> bytes_builder.append(<<0xFB, 8>>)
        |> encode_type_idx(type_idx),
      )
      builder
      |> encode_u32(size)
    }
    // 0xFB 9 𝑥:typeidx 𝑦:dataidx -> array.new_data 𝑥 𝑦
    ArrayNewData(type_idx, data_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFB, 9>>)
        |> encode_type_idx(type_idx),
      )
      builder
      |> encode_data_idx(data_idx)
    }
    // 0xFB 10 𝑥:typeidx 𝑦:elemidx -> array.new_elem 𝑥 𝑦
    ArrayNewElem(type_idx, elem_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFB, 10>>)
        |> encode_type_idx(type_idx),
      )
      builder
      |> encode_elem_idx(elem_idx)
    }
    // 0xFB 11 𝑥:typeidx -> array.get 𝑥
    ArrayGet(type_idx) ->
      builder
      |> bytes_builder.append(<<0xFB, 11>>)
      |> encode_type_idx(type_idx)
    // 0xFB 12 𝑥:typeidx -> array.get_s 𝑥
    ArrayGetS(type_idx) ->
      builder
      |> bytes_builder.append(<<0xFB, 12>>)
      |> encode_type_idx(type_idx)
    // 0xFB 13 𝑥:typeidx -> array.get_u 𝑥
    ArrayGetU(type_idx) ->
      builder
      |> bytes_builder.append(<<0xFB, 13>>)
      |> encode_type_idx(type_idx)
    // 0xFB 14 𝑥:typeidx -> array.set 𝑥
    ArraySet(type_idx) ->
      builder
      |> bytes_builder.append(<<0xFB, 14>>)
      |> encode_type_idx(type_idx)
    // 0xFB 15 -> array_len
    ArrayLen -> Ok(builder |> bytes_builder.append(<<0xFB, 15>>))
    // 0xFB 16 𝑥:typeidx -> array.fill 𝑥
    ArrayFill(type_idx) ->
      builder
      |> bytes_builder.append(<<0xFB, 16>>)
      |> encode_type_idx(type_idx)
    // 0xFB 17 𝑥:typeidx 𝑦:typeidx -> array.copy 𝑥 𝑦
    ArrayCopy(type_idx1, type_idx2) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFB, 17>>)
        |> encode_type_idx(type_idx1),
      )
      builder
      |> encode_type_idx(type_idx2)
    }
    // 0xFB 18 𝑥:typeidx 𝑦:dataidx -> array.init_data 𝑥 𝑦
    ArrayInitData(type_idx, data_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFB, 18>>)
        |> encode_type_idx(type_idx),
      )
      builder
      |> encode_data_idx(data_idx)
    }
    // 0xFB 19 𝑥:typeidx 𝑦:elemidx -> array.init_elem 𝑥 𝑦
    ArrayInitElem(type_idx, elem_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFB, 19>>)
        |> encode_type_idx(type_idx),
      )
      builder
      |> encode_elem_idx(elem_idx)
    }
    // 0xFB 20 ht:heaptype -> ref.test (ref ht)
    RefTest(ht) ->
      builder
      |> bytes_builder.append(<<0xFB, 20>>)
      |> encode_heap_type(ht)
    // 0xFB 21 ht:heaptype -> ref.test (ref null ht)
    RefTestNullable(ht) ->
      builder
      |> bytes_builder.append(<<0xFB, 21>>)
      |> encode_heap_type(ht)
    // 0xFB 22 ht:heaptype -> ref.cast (ref ht)
    RefCast(ht) ->
      builder
      |> bytes_builder.append(<<0xFB, 22>>)
      |> encode_heap_type(ht)
    // 0xFB 23 ht:heaptype -> ref.cast (ref null ht)
    RefCastNullable(ht) ->
      builder
      |> bytes_builder.append(<<0xFB, 23>>)
      |> encode_heap_type(ht)
    // 0xFB 26 -> any_convert_extern
    AnyConvertExtern -> Ok(builder |> bytes_builder.append(<<0xFB, 26>>))
    // 0xFB 27 -> extern_convert_any
    ExternConvertAny -> Ok(builder |> bytes_builder.append(<<0xFB, 27>>))
    // 0xFB 28 -> ref_i31
    RefI31 -> Ok(builder |> bytes_builder.append(<<0xFB, 28>>))
    // 0xFB 29 -> i31_get_s
    I31GetS -> Ok(builder |> bytes_builder.append(<<0xFB, 29>>))
    // 0xFB 30 -> i31_get_u
    I31GetU -> Ok(builder |> bytes_builder.append(<<0xFB, 30>>))
    BrOnCast(label_idx, rt1, rt2) -> {
      let ht1_nullable = types.ref_type_is_nullable(rt1)
      let ht2_nullable = types.ref_type_is_nullable(rt2)
      let ht1 = types.ref_type_unwrap_heap_type(rt1)
      let ht2 = types.ref_type_unwrap_heap_type(rt2)
      let assert Ok(op_code) = u32(24)
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFB>>)
        |> encode_u32(op_code)
        |> encode_cast_flags(#(ht1_nullable, ht2_nullable)),
      )
      use builder <- result.try(builder |> encode_label_idx(label_idx))
      use builder <- result.try(builder |> encode_heap_type(ht1))
      encode_heap_type(builder, ht2)
    }
    BrOnCastFail(label_idx, rt1, rt2) -> {
      let ht1_nullable = types.ref_type_is_nullable(rt1)
      let ht2_nullable = types.ref_type_is_nullable(rt2)
      let ht1 = types.ref_type_unwrap_heap_type(rt1)
      let ht2 = types.ref_type_unwrap_heap_type(rt2)
      let assert Ok(op_code) = u32(25)
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFB>>)
        |> encode_u32(op_code)
        |> encode_cast_flags(#(ht1_nullable, ht2_nullable)),
      )
      use builder <- result.try(builder |> encode_label_idx(label_idx))
      use builder <- result.try(builder |> encode_heap_type(ht1))
      encode_heap_type(builder, ht2)
    }
    Select -> Ok(builder |> bytes_builder.append(<<0x1B>>))
    SelectT(vt) ->
      builder
      |> bytes_builder.append(<<0x1C>>)
      |> common.encode_vec(vt, encode_val_type)
    RefNull(ht) ->
      builder
      |> bytes_builder.append(<<0xD0>>)
      |> encode_heap_type(ht)
    RefIsNull -> Ok(builder |> bytes_builder.append(<<0xD1>>))
    RefFunc(func_idx) ->
      builder
      |> bytes_builder.append(<<0xD2>>)
      |> encode_func_idx(func_idx)
    RefEq -> Ok(builder |> bytes_builder.append(<<0xD3>>))
    RefAsNonNull -> Ok(builder |> bytes_builder.append(<<0xD4>>))
    V128Load(mem_arg) ->
      builder
      |> bytes_builder.append(<<0xFD, 0>>)
      |> encode_mem_arg(mem_arg)
    V128Load8x8S(mem_arg) ->
      builder
      |> bytes_builder.append(<<0xFD, 1>>)
      |> encode_mem_arg(mem_arg)
    V128Load8x8U(mem_arg) ->
      builder
      |> bytes_builder.append(<<0xFD, 2>>)
      |> encode_mem_arg(mem_arg)
    V128Load16x4S(mem_arg) ->
      builder
      |> bytes_builder.append(<<0xFD, 3>>)
      |> encode_mem_arg(mem_arg)
    V128Load16x4U(mem_arg) ->
      builder
      |> bytes_builder.append(<<0xFD, 4>>)
      |> encode_mem_arg(mem_arg)
    V128Load32x2S(mem_arg) ->
      builder
      |> bytes_builder.append(<<0xFD, 5>>)
      |> encode_mem_arg(mem_arg)
    V128Load32x2U(mem_arg) ->
      builder
      |> bytes_builder.append(<<0xFD, 6>>)
      |> encode_mem_arg(mem_arg)
    V128Load8Splat(mem_arg) ->
      builder
      |> bytes_builder.append(<<0xFD, 7>>)
      |> encode_mem_arg(mem_arg)
    V128Load16Splat(mem_arg) ->
      builder
      |> bytes_builder.append(<<0xFD, 8>>)
      |> encode_mem_arg(mem_arg)
    V128Load32Splat(mem_arg) ->
      builder
      |> bytes_builder.append(<<0xFD, 9>>)
      |> encode_mem_arg(mem_arg)
    V128Load64Splat(mem_arg) ->
      builder
      |> bytes_builder.append(<<0xFD, 10>>)
      |> encode_mem_arg(mem_arg)
    V128Store(mem_arg) ->
      builder
      |> bytes_builder.append(<<0xFD, 11>>)
      |> encode_mem_arg(mem_arg)
    V128Const(v128_val) ->
      Ok(
        builder
        |> bytes_builder.append(<<
          0xFD,
          12,
          { v128_val |> numbers.unwrap_v128 }:bits,
        >>),
      )
    I8x16Shuffle(
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
      lane_10,
      lane_11,
      lane_12,
      lane_13,
      lane_14,
      lane_15,
    ) -> {
      use builder <- result.try(
        builder |> bytes_builder.append(<<0xFD, 13>>) |> encode_lane_16(lane_0),
      )
      use builder <- result.try(builder |> encode_lane_16(lane_1))
      use builder <- result.try(builder |> encode_lane_16(lane_2))
      use builder <- result.try(builder |> encode_lane_16(lane_3))
      use builder <- result.try(builder |> encode_lane_16(lane_4))
      use builder <- result.try(builder |> encode_lane_16(lane_5))
      use builder <- result.try(builder |> encode_lane_16(lane_6))
      use builder <- result.try(builder |> encode_lane_16(lane_7))
      use builder <- result.try(builder |> encode_lane_16(lane_8))
      use builder <- result.try(builder |> encode_lane_16(lane_9))
      use builder <- result.try(builder |> encode_lane_16(lane_10))
      use builder <- result.try(builder |> encode_lane_16(lane_11))
      use builder <- result.try(builder |> encode_lane_16(lane_12))
      use builder <- result.try(builder |> encode_lane_16(lane_13))
      use builder <- result.try(builder |> encode_lane_16(lane_14))
      builder |> encode_lane_16(lane_15)
    }
    I8x16Swizzle -> Ok(builder |> bytes_builder.append(<<0xFD, 14>>))
    I8x16Splat -> Ok(builder |> bytes_builder.append(<<0xFD, 15>>))
    I16x8Splat -> Ok(builder |> bytes_builder.append(<<0xFD, 16>>))
    I32x4Splat -> Ok(builder |> bytes_builder.append(<<0xFD, 17>>))
    I64x2Splat -> Ok(builder |> bytes_builder.append(<<0xFD, 18>>))
    F32x4Splat -> Ok(builder |> bytes_builder.append(<<0xFD, 19>>))
    F64x2Splat -> Ok(builder |> bytes_builder.append(<<0xFD, 20>>))
    I8x16ExtractLaneS(lane_idx) ->
      builder
      |> bytes_builder.append(<<0xFD, 21>>)
      |> encode_lane_16(lane_idx)
    I8x16ExtractLaneU(lane_idx) ->
      builder
      |> bytes_builder.append(<<0xFD, 22>>)
      |> encode_lane_16(lane_idx)
    I8x16ReplaceLane(lane_idx) ->
      builder
      |> bytes_builder.append(<<0xFD, 23>>)
      |> encode_lane_16(lane_idx)
    I16x8ExtractLaneS(lane_idx) ->
      builder
      |> bytes_builder.append(<<0xFD, 24>>)
      |> encode_lane_8(lane_idx)
    I16x8ExtractLaneU(lane_idx) ->
      builder
      |> bytes_builder.append(<<0xFD, 25>>)
      |> encode_lane_8(lane_idx)
    I16x8ReplaceLane(lane_idx) ->
      builder
      |> bytes_builder.append(<<0xFD, 26>>)
      |> encode_lane_8(lane_idx)
    I32x4ExtractLane(lane_idx) ->
      builder
      |> bytes_builder.append(<<0xFD, 27>>)
      |> encode_lane_4(lane_idx)
    I32x4ReplaceLane(lane_idx) ->
      builder
      |> bytes_builder.append(<<0xFD, 28>>)
      |> encode_lane_4(lane_idx)
    I64x2ExtractLane(lane_idx) ->
      builder
      |> bytes_builder.append(<<0xFD, 29>>)
      |> encode_lane_2(lane_idx)
    I64x2ReplaceLane(lane_idx) ->
      builder
      |> bytes_builder.append(<<0xFD, 30>>)
      |> encode_lane_2(lane_idx)
    F32x4ExtractLane(lane_idx) ->
      builder
      |> bytes_builder.append(<<0xFD, 31>>)
      |> encode_lane_4(lane_idx)
    F32x4ReplaceLane(lane_idx) ->
      builder
      |> bytes_builder.append(<<0xFD, 32>>)
      |> encode_lane_4(lane_idx)
    F64x2ExtractLane(lane_idx) ->
      builder
      |> bytes_builder.append(<<0xFD, 33>>)
      |> encode_lane_2(lane_idx)
    F64x2ReplaceLane(lane_idx) ->
      builder
      |> bytes_builder.append(<<0xFD, 34>>)
      |> encode_lane_2(lane_idx)
    I8x16Eq -> Ok(builder |> bytes_builder.append(<<0xFD, 35>>))
    I8x16Ne -> Ok(builder |> bytes_builder.append(<<0xFD, 36>>))
    I8x16LtS -> Ok(builder |> bytes_builder.append(<<0xFD, 37>>))
    I8x16LtU -> Ok(builder |> bytes_builder.append(<<0xFD, 38>>))
    I8x16GtS -> Ok(builder |> bytes_builder.append(<<0xFD, 39>>))
    I8x16GtU -> Ok(builder |> bytes_builder.append(<<0xFD, 40>>))
    I8x16LeS -> Ok(builder |> bytes_builder.append(<<0xFD, 41>>))
    I8x16LeU -> Ok(builder |> bytes_builder.append(<<0xFD, 42>>))
    I8x16GeS -> Ok(builder |> bytes_builder.append(<<0xFD, 43>>))
    I8x16GeU -> Ok(builder |> bytes_builder.append(<<0xFD, 44>>))
    I16x8Eq -> Ok(builder |> bytes_builder.append(<<0xFD, 45>>))
    I16x8Ne -> Ok(builder |> bytes_builder.append(<<0xFD, 46>>))
    I16x8LtS -> Ok(builder |> bytes_builder.append(<<0xFD, 47>>))
    I16x8LtU -> Ok(builder |> bytes_builder.append(<<0xFD, 48>>))
    I16x8GtS -> Ok(builder |> bytes_builder.append(<<0xFD, 49>>))
    I16x8GtU -> Ok(builder |> bytes_builder.append(<<0xFD, 50>>))
    I16x8LeS -> Ok(builder |> bytes_builder.append(<<0xFD, 51>>))
    I16x8LeU -> Ok(builder |> bytes_builder.append(<<0xFD, 52>>))
    I16x8GeS -> Ok(builder |> bytes_builder.append(<<0xFD, 53>>))
    I16x8GeU -> Ok(builder |> bytes_builder.append(<<0xFD, 54>>))
    I32x4Eq -> Ok(builder |> bytes_builder.append(<<0xFD, 55>>))
    I32x4Ne -> Ok(builder |> bytes_builder.append(<<0xFD, 56>>))
    I32x4LtS -> Ok(builder |> bytes_builder.append(<<0xFD, 57>>))
    I32x4LtU -> Ok(builder |> bytes_builder.append(<<0xFD, 58>>))
    I32x4GtS -> Ok(builder |> bytes_builder.append(<<0xFD, 59>>))
    I32x4GtU -> Ok(builder |> bytes_builder.append(<<0xFD, 60>>))
    I32x4LeS -> Ok(builder |> bytes_builder.append(<<0xFD, 61>>))
    I32x4LeU -> Ok(builder |> bytes_builder.append(<<0xFD, 62>>))
    I32x4GeS -> Ok(builder |> bytes_builder.append(<<0xFD, 63>>))
    I32x4GeU -> Ok(builder |> bytes_builder.append(<<0xFD, 64>>))
    I64x2Eq -> Ok(builder |> bytes_builder.append(<<0xFD, 214, 1>>))
    I64x2Ne -> Ok(builder |> bytes_builder.append(<<0xFD, 215, 1>>))
    I64x2LtS -> Ok(builder |> bytes_builder.append(<<0xFD, 216, 1>>))
    I64x2GtS -> Ok(builder |> bytes_builder.append(<<0xFD, 217, 1>>))
    I64x2LeS -> Ok(builder |> bytes_builder.append(<<0xFD, 218, 1>>))
    I64x2GeS -> Ok(builder |> bytes_builder.append(<<0xFD, 219, 1>>))
    F32x4Eq -> Ok(builder |> bytes_builder.append(<<0xFD, 65>>))
    F32x4Ne -> Ok(builder |> bytes_builder.append(<<0xFD, 66>>))
    F32x4Lt -> Ok(builder |> bytes_builder.append(<<0xFD, 67>>))
    F32x4Gt -> Ok(builder |> bytes_builder.append(<<0xFD, 68>>))
    F32x4Le -> Ok(builder |> bytes_builder.append(<<0xFD, 69>>))
    F32x4Ge -> Ok(builder |> bytes_builder.append(<<0xFD, 70>>))
    F64x2Eq -> Ok(builder |> bytes_builder.append(<<0xFD, 71>>))
    F64x2Ne -> Ok(builder |> bytes_builder.append(<<0xFD, 72>>))
    F64x2Lt -> Ok(builder |> bytes_builder.append(<<0xFD, 73>>))
    F64x2Gt -> Ok(builder |> bytes_builder.append(<<0xFD, 74>>))
    F64x2Le -> Ok(builder |> bytes_builder.append(<<0xFD, 75>>))
    F64x2Ge -> Ok(builder |> bytes_builder.append(<<0xFD, 76>>))
    V128Not -> Ok(builder |> bytes_builder.append(<<0xFD, 77>>))
    V128And -> Ok(builder |> bytes_builder.append(<<0xFD, 78>>))
    V128AndNot -> Ok(builder |> bytes_builder.append(<<0xFD, 79>>))
    V128Or -> Ok(builder |> bytes_builder.append(<<0xFD, 80>>))
    V128Xor -> Ok(builder |> bytes_builder.append(<<0xFD, 81>>))
    V128Bitselect -> Ok(builder |> bytes_builder.append(<<0xFD, 82>>))
    V128AnyTrue -> Ok(builder |> bytes_builder.append(<<0xFD, 83>>))
    V128Load8Lane(mem_arg, lane_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFD, 84>>)
        |> encode_mem_arg(mem_arg),
      )
      builder
      |> encode_lane_16(lane_idx)
    }

    V128Load16Lane(mem_arg, lane_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFD, 85>>)
        |> encode_mem_arg(mem_arg),
      )
      builder
      |> encode_lane_8(lane_idx)
    }
    V128Load32Lane(mem_arg, lane_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFD, 86>>)
        |> encode_mem_arg(mem_arg),
      )
      builder
      |> encode_lane_4(lane_idx)
    }
    V128Load64Lane(mem_arg, lane_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFD, 87>>)
        |> encode_mem_arg(mem_arg),
      )
      builder
      |> encode_lane_2(lane_idx)
    }
    V128Store8Lane(mem_arg, lane_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFD, 88>>)
        |> encode_mem_arg(mem_arg),
      )
      builder
      |> encode_lane_16(lane_idx)
    }
    V128Store16Lane(mem_arg, lane_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFD, 89>>)
        |> encode_mem_arg(mem_arg),
      )
      builder
      |> encode_lane_8(lane_idx)
    }
    V128Store32Lane(mem_arg, lane_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFD, 90>>)
        |> encode_mem_arg(mem_arg),
      )
      builder
      |> encode_lane_4(lane_idx)
    }
    V128Store64Lane(mem_arg, lane_idx) -> {
      use builder <- result.try(
        builder
        |> bytes_builder.append(<<0xFD, 91>>)
        |> encode_mem_arg(mem_arg),
      )
      builder
      |> encode_lane_2(lane_idx)
    }
    V128Load32Zero(mem_arg) ->
      builder
      |> bytes_builder.append(<<0xFD, 92>>)
      |> encode_mem_arg(mem_arg)
    V128Load64Zero(mem_arg) ->
      builder
      |> bytes_builder.append(<<0xFD, 93>>)
      |> encode_mem_arg(mem_arg)
    F32x4DemoteF64x2Zero -> Ok(builder |> bytes_builder.append(<<0xFD, 94>>))
    F64x2PromoteLowF32x4 -> Ok(builder |> bytes_builder.append(<<0xFD, 95>>))

    I16x8ExtmulLowI8x16S ->
      builder
      |> bytes_builder.append(<<0xFD, 0x9C, 0x01>>)
      |> Ok
    I16x8ExtmulHighI8x16S ->
      builder
      |> bytes_builder.append(<<0xFD, 0x9D, 0x01>>)
      |> Ok
    I16x8ExtmulLowI8x16U ->
      builder
      |> bytes_builder.append(<<0xFD, 0x9E, 0x01>>)
      |> Ok
    I16x8ExtmulHighI8x16U ->
      builder
      |> bytes_builder.append(<<0xFD, 0x9F, 0x01>>)
      |> Ok
    I8x16Abs ->
      builder
      |> bytes_builder.append(<<0xFD, 96>>)
      |> Ok
    I8x16Neg ->
      builder
      |> bytes_builder.append(<<0xFD, 97>>)
      |> Ok
    I8x16Popcnt ->
      builder
      |> bytes_builder.append(<<0xFD, 98>>)
      |> Ok
    I8x16AllTrue ->
      builder
      |> bytes_builder.append(<<0xFD, 99>>)
      |> Ok
    I8x16Bitmask ->
      builder
      |> bytes_builder.append(<<0xFD, 100>>)
      |> Ok
    I8x16NarrowI16x8S ->
      builder
      |> bytes_builder.append(<<0xFD, 101>>)
      |> Ok
    I8x16NarrowI16x8U ->
      builder
      |> bytes_builder.append(<<0xFD, 102>>)
      |> Ok
    I8x16Shl ->
      builder
      |> bytes_builder.append(<<0xFD, 107>>)
      |> Ok
    I8x16ShrS ->
      builder
      |> bytes_builder.append(<<0xFD, 108>>)
      |> Ok
    I8x16ShrU ->
      builder
      |> bytes_builder.append(<<0xFD, 109>>)
      |> Ok
    I8x16Add ->
      builder
      |> bytes_builder.append(<<0xFD, 110>>)
      |> Ok
    I8x16AddSatS ->
      builder
      |> bytes_builder.append(<<0xFD, 111>>)
      |> Ok
    I8x16AddSatU ->
      builder
      |> bytes_builder.append(<<0xFD, 112>>)
      |> Ok
    I8x16Sub ->
      builder
      |> bytes_builder.append(<<0xFD, 113>>)
      |> Ok
    I8x16SubSatS ->
      builder
      |> bytes_builder.append(<<0xFD, 114>>)
      |> Ok
    I8x16SubSatU ->
      builder
      |> bytes_builder.append(<<0xFD, 115>>)
      |> Ok
    I8x16MinS ->
      builder
      |> bytes_builder.append(<<0xFD, 118>>)
      |> Ok
    I8x16MinU ->
      builder
      |> bytes_builder.append(<<0xFD, 119>>)
      |> Ok
    I8x16MaxS ->
      builder
      |> bytes_builder.append(<<0xFD, 120>>)
      |> Ok
    I8x16MaxU ->
      builder
      |> bytes_builder.append(<<0xFD, 121>>)
      |> Ok
    I8x16AvgrU ->
      builder
      |> bytes_builder.append(<<0xFD, 123>>)
      |> Ok
    I16x8AvgrU ->
      builder
      |> bytes_builder.append(<<0xFD, 0x9B, 0x01>>)
      |> Ok
    I16x8MaxU ->
      builder
      |> bytes_builder.append(<<0xFD, 0x99, 0x01>>)
      |> Ok
    I16x8MaxS ->
      builder
      |> bytes_builder.append(<<0xFD, 0x98, 0x01>>)
      |> Ok
    I16x8ExtaddPairwiseI8x16S ->
      builder
      |> bytes_builder.append(<<0xFD, 124>>)
      |> Ok
    I16x8ExtaddPairwiseI8x16U ->
      builder
      |> bytes_builder.append(<<0xFD, 125>>)
      |> Ok
    I16x8Abs ->
      builder
      |> bytes_builder.append(<<0xFD, 128, 0x01>>)
      |> Ok
    I16x8Neg ->
      builder
      |> bytes_builder.append(<<0xFD, 0x81, 0x01>>)
      |> Ok
    I16x8Q15mulrSatS -> Ok(builder |> bytes_builder.append(<<0xFD, 130, 1>>))
    I16x8AllTrue -> Ok(builder |> bytes_builder.append(<<0xFD, 131, 1>>))
    I16x8Bitmask -> Ok(builder |> bytes_builder.append(<<0xFD, 132, 1>>))
    I16x8NarrowI32x4S -> Ok(builder |> bytes_builder.append(<<0xFD, 133, 1>>))
    I16x8NarrowI32x4U -> Ok(builder |> bytes_builder.append(<<0xFD, 134, 1>>))
    I16x8ExtendLowI8x16S ->
      Ok(builder |> bytes_builder.append(<<0xFD, 135, 1>>))
    I16x8ExtendHighI8x16S ->
      Ok(builder |> bytes_builder.append(<<0xFD, 136, 1>>))
    I16x8ExtendLowI8x16U ->
      Ok(builder |> bytes_builder.append(<<0xFD, 137, 1>>))
    I16x8ExtendHighI8x16U ->
      Ok(builder |> bytes_builder.append(<<0xFD, 138, 1>>))
    I16x8Shl -> Ok(builder |> bytes_builder.append(<<0xFD, 139, 1>>))
    I16x8ShrS -> Ok(builder |> bytes_builder.append(<<0xFD, 140, 1>>))
    I16x8ShrU -> Ok(builder |> bytes_builder.append(<<0xFD, 141, 1>>))
    I16x8Add -> Ok(builder |> bytes_builder.append(<<0xFD, 142, 1>>))
    I16x8AddSatS -> Ok(builder |> bytes_builder.append(<<0xFD, 143, 1>>))
    I16x8AddSatU -> Ok(builder |> bytes_builder.append(<<0xFD, 144, 1>>))
    I16x8Sub -> Ok(builder |> bytes_builder.append(<<0xFD, 145, 1>>))
    I16x8SubSatS -> Ok(builder |> bytes_builder.append(<<0xFD, 146, 1>>))
    I16x8SubSatU -> Ok(builder |> bytes_builder.append(<<0xFD, 147, 1>>))
    I16x8Mul -> Ok(builder |> bytes_builder.append(<<0xFD, 149, 1>>))
    I16x8MinS -> Ok(builder |> bytes_builder.append(<<0xFD, 150, 1>>))
    I16x8MinU -> Ok(builder |> bytes_builder.append(<<0xFD, 151, 1>>))
    F32x4Ceil -> Ok(builder |> bytes_builder.append(<<0xFD, 103>>))
    F32x4Floor -> Ok(builder |> bytes_builder.append(<<0xFD, 104>>))
    F32x4Trunc -> Ok(builder |> bytes_builder.append(<<0xFD, 105>>))
    F32x4Nearest -> Ok(builder |> bytes_builder.append(<<0xFD, 106>>))
    F64x2Ceil -> Ok(builder |> bytes_builder.append(<<0xFD, 116>>))
    F64x2Floor -> Ok(builder |> bytes_builder.append(<<0xFD, 117>>))
    F64x2Trunc -> Ok(builder |> bytes_builder.append(<<0xFD, 122>>))
    F64x2Nearest -> Ok(builder |> bytes_builder.append(<<0xFD, 148, 1>>))
    inst -> {
      let name = pprint.format(inst)
      Error("Instruction not implemented: " <> name)
    }
  }
}

/// For information on how each instruction is decoded, please see the specification:
/// 
/// https://webassembly.github.io/gc/core/binary/instructions.html#instructions
pub fn decode_instruction(
  bits: BitArray,
) -> Result(#(Instruction, BitArray), String) {
  case bits {
    <<0x0B, _:bits>> -> Error("Invalid end instruction")
    <<0x05, _:bits>> -> Error("Invalid else instruction")
    <<0x00, rest:bits>> -> Ok(#(Unreachable, rest))
    <<0x01, rest:bits>> -> Ok(#(Nop, rest))
    <<0x02, rest:bits>> -> {
      use #(bt, rest) <- result.try(decode_block_type(rest))
      use #(expr, rest) <- result.map(decode_expression(rest))
      #(Block(bt, expr), rest)
    }
    <<0x03, rest:bits>> -> {
      use #(bt, rest) <- result.try(decode_block_type(rest))
      use #(expr, rest) <- result.map(decode_expression(rest))
      #(Loop(bt, expr), rest)
    }
    <<0x04, rest:bits>> -> {
      use #(bt, rest) <- result.try(decode_block_type(rest))
      do_decode_if_instruction(rest, bt, finger_tree.empty)
    }
    <<0x0C, rest:bits>> -> {
      use #(label_idx, rest) <- result.map(decode_u32(rest))
      #(Br(LabelIDX(label_idx)), rest)
    }
    <<0x0D, rest:bits>> -> {
      use #(label_idx, rest) <- result.map(decode_u32(rest))
      #(BrIf(LabelIDX(label_idx)), rest)
    }
    <<0x0E, rest:bits>> -> {
      use #(labels, rest) <- result.try(
        rest |> common.decode_vec(decode_label_idx),
      )
      use #(label_default, rest) <- result.map(decode_label_idx(rest))
      #(BrTable(labels, label_default), rest)
    }
    <<0x0F, rest:bits>> -> Ok(#(Return, rest))
    <<0x10, rest:bits>> -> {
      use #(idx, rest) <- result.map(decode_func_idx(rest))
      #(Call(idx), rest)
    }
    <<0x11, rest:bits>> -> {
      use #(type_idx, rest) <- result.try(decode_type_idx(rest))
      use #(table_idx, rest) <- result.map(decode_table_idx(rest))
      #(CallIndirect(table_idx, type_idx), rest)
    }
    <<0x12, rest:bits>> -> {
      use #(func_idx, rest) <- result.map(decode_func_idx(rest))
      #(ReturnCall(func_idx), rest)
    }
    <<0x13, rest:bits>> -> {
      use #(type_idx, rest) <- result.try(decode_type_idx(rest))
      use #(table_idx, rest) <- result.map(decode_table_idx(rest))
      #(ReturnCallIndirect(table_idx, type_idx), rest)
    }
    <<0x14, rest:bits>> -> {
      use #(type_idx, rest) <- result.map(decode_type_idx(rest))
      #(CallRef(type_idx), rest)
    }
    <<0x15, rest:bits>> -> {
      use #(type_idx, rest) <- result.map(decode_type_idx(rest))
      #(ReturnCallRef(type_idx), rest)
    }
    <<0x1A, rest:bits>> -> Ok(#(Drop, rest))
    <<0x1B, rest:bits>> -> Ok(#(Select, rest))
    <<0x1C, rest:bits>> -> {
      use #(vt, rest) <- result.map(common.decode_vec(rest, decode_val_type))
      #(SelectT(vt), rest)
    }
    <<0x20, rest:bits>> -> {
      use #(local_idx, rest) <- result.map(decode_local_idx(rest))
      #(LocalGet(local_idx), rest)
    }
    <<0x21, rest:bits>> -> {
      use #(local_idx, rest) <- result.map(decode_local_idx(rest))
      #(LocalSet(local_idx), rest)
    }
    <<0x22, rest:bits>> -> {
      use #(local_idx, rest) <- result.map(decode_local_idx(rest))
      #(LocalTee(local_idx), rest)
    }
    <<0x23, rest:bits>> -> {
      use #(global_idx, rest) <- result.map(decode_global_idx(rest))
      #(GlobalGet(global_idx), rest)
    }
    <<0x24, rest:bits>> -> {
      use #(global_idx, rest) <- result.map(decode_global_idx(rest))
      #(GlobalSet(global_idx), rest)
    }
    <<0x25, rest:bits>> -> {
      use #(table_idx, rest) <- result.map(decode_table_idx(rest))
      #(TableGet(table_idx), rest)
    }
    <<0x26, rest:bits>> -> {
      use #(table_idx, rest) <- result.map(decode_table_idx(rest))
      #(TableSet(table_idx), rest)
    }
    <<0x28, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I32Load(mem_arg), rest)
    }
    <<0x29, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I64Load(mem_arg), rest)
    }
    <<0x2A, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(F32Load(mem_arg), rest)
    }
    <<0x2B, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(F64Load(mem_arg), rest)
    }
    <<0x2C, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I32Load8S(mem_arg), rest)
    }
    <<0x2D, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I32Load8U(mem_arg), rest)
    }
    <<0x2E, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I32Load16S(mem_arg), rest)
    }
    <<0x2F, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I32Load16U(mem_arg), rest)
    }
    <<0x30, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I64Load8S(mem_arg), rest)
    }
    <<0x31, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I64Load8U(mem_arg), rest)
    }
    <<0x32, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I64Load16S(mem_arg), rest)
    }
    <<0x33, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I64Load16U(mem_arg), rest)
    }
    <<0x34, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I64Load32S(mem_arg), rest)
    }
    <<0x35, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I64Load32U(mem_arg), rest)
    }
    <<0x36, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I32Store(mem_arg), rest)
    }
    <<0x37, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I64Store(mem_arg), rest)
    }
    <<0x38, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(F32Store(mem_arg), rest)
    }
    <<0x39, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(F64Store(mem_arg), rest)
    }
    <<0x3A, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I32Store8(mem_arg), rest)
    }
    <<0x3B, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I32Store16(mem_arg), rest)
    }
    <<0x3C, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I64Store8(mem_arg), rest)
    }
    <<0x3D, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I64Store16(mem_arg), rest)
    }
    <<0x3E, rest:bits>> -> {
      use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
      #(I64Store32(mem_arg), rest)
    }
    <<0x3F, 0x00, rest:bits>> -> Ok(#(MemorySize, rest))
    <<0x40, 0x00, rest:bits>> -> Ok(#(MemoryGrow, rest))
    <<0x41, rest:bits>> -> {
      use #(i32_val, rest) <- result.map(decode_i32(rest))
      #(I32Const(i32_val), rest)
    }
    <<0x42, rest:bits>> -> {
      use #(i64_val, rest) <- result.map(decode_i64(rest))
      #(I64Const(i64_val), rest)
    }
    <<0x43, rest:bits>> -> {
      use #(f32_val, rest) <- result.map(decode_f32(rest))
      #(F32Const(f32_val), rest)
    }
    <<0x44, rest:bits>> -> {
      use #(f64_val, rest) <- result.map(decode_f64(rest))
      #(F64Const(f64_val), rest)
    }
    <<0x45, rest:bits>> -> Ok(#(I32Eqz, rest))
    <<0x46, rest:bits>> -> Ok(#(I32Eq, rest))
    <<0x47, rest:bits>> -> Ok(#(I32Ne, rest))
    <<0x48, rest:bits>> -> Ok(#(I32LtS, rest))
    <<0x49, rest:bits>> -> Ok(#(I32LtU, rest))
    <<0x4A, rest:bits>> -> Ok(#(I32GtS, rest))
    <<0x4B, rest:bits>> -> Ok(#(I32GtU, rest))
    <<0x4C, rest:bits>> -> Ok(#(I32LeS, rest))
    <<0x4D, rest:bits>> -> Ok(#(I32LeU, rest))
    <<0x4E, rest:bits>> -> Ok(#(I32GeS, rest))
    <<0x4F, rest:bits>> -> Ok(#(I32GeU, rest))
    <<0x50, rest:bits>> -> Ok(#(I64Eqz, rest))
    <<0x51, rest:bits>> -> Ok(#(I64Eq, rest))
    <<0x52, rest:bits>> -> Ok(#(I64Ne, rest))
    <<0x53, rest:bits>> -> Ok(#(I64LtS, rest))
    <<0x54, rest:bits>> -> Ok(#(I64LtU, rest))
    <<0x55, rest:bits>> -> Ok(#(I64GtS, rest))
    <<0x56, rest:bits>> -> Ok(#(I64GtU, rest))
    <<0x57, rest:bits>> -> Ok(#(I64LeS, rest))
    <<0x58, rest:bits>> -> Ok(#(I64LeU, rest))
    <<0x59, rest:bits>> -> Ok(#(I64GeS, rest))
    <<0x5A, rest:bits>> -> Ok(#(I64GeU, rest))
    <<0x5B, rest:bits>> -> Ok(#(F32Eq, rest))
    <<0x5C, rest:bits>> -> Ok(#(F32Ne, rest))
    <<0x5D, rest:bits>> -> Ok(#(F32Lt, rest))
    <<0x5E, rest:bits>> -> Ok(#(F32Gt, rest))
    <<0x5F, rest:bits>> -> Ok(#(F32Le, rest))
    <<0x60, rest:bits>> -> Ok(#(F32Ge, rest))
    <<0x61, rest:bits>> -> Ok(#(F64Eq, rest))
    <<0x62, rest:bits>> -> Ok(#(F64Ne, rest))
    <<0x63, rest:bits>> -> Ok(#(F64Lt, rest))
    <<0x64, rest:bits>> -> Ok(#(F64Gt, rest))
    <<0x65, rest:bits>> -> Ok(#(F64Le, rest))
    <<0x66, rest:bits>> -> Ok(#(F64Ge, rest))
    <<0x67, rest:bits>> -> Ok(#(I32Clz, rest))
    <<0x68, rest:bits>> -> Ok(#(I32Ctz, rest))
    <<0x69, rest:bits>> -> Ok(#(I32Popcnt, rest))
    <<0x6A, rest:bits>> -> Ok(#(I32Add, rest))
    <<0x6B, rest:bits>> -> Ok(#(I32Sub, rest))
    <<0x6C, rest:bits>> -> Ok(#(I32Mul, rest))
    <<0x6D, rest:bits>> -> Ok(#(I32DivS, rest))
    <<0x6E, rest:bits>> -> Ok(#(I32DivU, rest))
    <<0x6F, rest:bits>> -> Ok(#(I32RemS, rest))
    <<0x70, rest:bits>> -> Ok(#(I32RemU, rest))
    <<0x71, rest:bits>> -> Ok(#(I32And, rest))
    <<0x72, rest:bits>> -> Ok(#(I32Or, rest))
    <<0x73, rest:bits>> -> Ok(#(I32Xor, rest))
    <<0x74, rest:bits>> -> Ok(#(I32Shl, rest))
    <<0x75, rest:bits>> -> Ok(#(I32ShrS, rest))
    <<0x76, rest:bits>> -> Ok(#(I32ShrU, rest))
    <<0x77, rest:bits>> -> Ok(#(I32Rotl, rest))
    <<0x78, rest:bits>> -> Ok(#(I32Rotr, rest))
    <<0x79, rest:bits>> -> Ok(#(I64Clz, rest))
    <<0x7A, rest:bits>> -> Ok(#(I64Ctz, rest))
    <<0x7B, rest:bits>> -> Ok(#(I64Popcnt, rest))
    <<0x7C, rest:bits>> -> Ok(#(I64Add, rest))
    <<0x7D, rest:bits>> -> Ok(#(I64Sub, rest))
    <<0x7E, rest:bits>> -> Ok(#(I64Mul, rest))
    <<0x7F, rest:bits>> -> Ok(#(I64DivS, rest))
    <<0x80, rest:bits>> -> Ok(#(I64DivU, rest))
    <<0x81, rest:bits>> -> Ok(#(I64RemS, rest))
    <<0x82, rest:bits>> -> Ok(#(I64RemU, rest))
    <<0x83, rest:bits>> -> Ok(#(I64And, rest))
    <<0x84, rest:bits>> -> Ok(#(I64Or, rest))
    <<0x85, rest:bits>> -> Ok(#(I64Xor, rest))
    <<0x86, rest:bits>> -> Ok(#(I64Shl, rest))
    <<0x87, rest:bits>> -> Ok(#(I64ShrS, rest))
    <<0x88, rest:bits>> -> Ok(#(I64ShrU, rest))
    <<0x89, rest:bits>> -> Ok(#(I64Rotl, rest))
    <<0x8A, rest:bits>> -> Ok(#(I64Rotr, rest))
    <<0x8B, rest:bits>> -> Ok(#(F32Abs, rest))
    <<0x8C, rest:bits>> -> Ok(#(F32Neg, rest))
    <<0x8D, rest:bits>> -> Ok(#(F32Ceil, rest))
    <<0x8E, rest:bits>> -> Ok(#(F32Floor, rest))
    <<0x8F, rest:bits>> -> Ok(#(F32Trunc, rest))
    <<0x90, rest:bits>> -> Ok(#(F32Nearest, rest))
    <<0x91, rest:bits>> -> Ok(#(F32Sqrt, rest))
    <<0x92, rest:bits>> -> Ok(#(F32Add, rest))
    <<0x93, rest:bits>> -> Ok(#(F32Sub, rest))
    <<0x94, rest:bits>> -> Ok(#(F32Mul, rest))
    <<0x95, rest:bits>> -> Ok(#(F32Div, rest))
    <<0x96, rest:bits>> -> Ok(#(F32Min, rest))
    <<0x97, rest:bits>> -> Ok(#(F32Max, rest))
    <<0x98, rest:bits>> -> Ok(#(F32Copysign, rest))
    <<0x99, rest:bits>> -> Ok(#(F64Abs, rest))
    <<0x9A, rest:bits>> -> Ok(#(F64Neg, rest))
    <<0x9B, rest:bits>> -> Ok(#(F64Ceil, rest))
    <<0x9C, rest:bits>> -> Ok(#(F64Floor, rest))
    <<0x9D, rest:bits>> -> Ok(#(F64Trunc, rest))
    <<0x9E, rest:bits>> -> Ok(#(F64Nearest, rest))
    <<0x9F, rest:bits>> -> Ok(#(F64Sqrt, rest))
    <<0xA0, rest:bits>> -> Ok(#(F64Add, rest))
    <<0xA1, rest:bits>> -> Ok(#(F64Sub, rest))
    <<0xA2, rest:bits>> -> Ok(#(F64Mul, rest))
    <<0xA3, rest:bits>> -> Ok(#(F64Div, rest))
    <<0xA4, rest:bits>> -> Ok(#(F64Min, rest))
    <<0xA5, rest:bits>> -> Ok(#(F64Max, rest))
    <<0xA6, rest:bits>> -> Ok(#(F64Copysign, rest))
    <<0xA7, rest:bits>> -> Ok(#(I32WrapI64, rest))
    <<0xA8, rest:bits>> -> Ok(#(I32TruncF32S, rest))
    <<0xA9, rest:bits>> -> Ok(#(I32TruncF32U, rest))
    <<0xAA, rest:bits>> -> Ok(#(I32TruncF64S, rest))
    <<0xAB, rest:bits>> -> Ok(#(I32TruncF64U, rest))
    <<0xAC, rest:bits>> -> Ok(#(I64ExtendI32S, rest))
    <<0xAD, rest:bits>> -> Ok(#(I64ExtendI32U, rest))
    <<0xAE, rest:bits>> -> Ok(#(I64TruncF32S, rest))
    <<0xAF, rest:bits>> -> Ok(#(I64TruncF32U, rest))
    <<0xB0, rest:bits>> -> Ok(#(I64TruncF64S, rest))
    <<0xB1, rest:bits>> -> Ok(#(I64TruncF64U, rest))
    <<0xB2, rest:bits>> -> Ok(#(F32ConvertI32S, rest))
    <<0xB3, rest:bits>> -> Ok(#(F32ConvertI32U, rest))
    <<0xB4, rest:bits>> -> Ok(#(F32ConvertI64S, rest))
    <<0xB5, rest:bits>> -> Ok(#(F32ConvertI64U, rest))
    <<0xB6, rest:bits>> -> Ok(#(F32DemoteF64, rest))
    <<0xB7, rest:bits>> -> Ok(#(F64ConvertI32S, rest))
    <<0xB8, rest:bits>> -> Ok(#(F64ConvertI32U, rest))
    <<0xB9, rest:bits>> -> Ok(#(F64ConvertI64S, rest))
    <<0xBA, rest:bits>> -> Ok(#(F64ConvertI64U, rest))
    <<0xBB, rest:bits>> -> Ok(#(F64PromoteF32, rest))
    <<0xBC, rest:bits>> -> Ok(#(I32ReinterpretF32, rest))
    <<0xBD, rest:bits>> -> Ok(#(I64ReinterpretF64, rest))
    <<0xBE, rest:bits>> -> Ok(#(F32ReinterpretI32, rest))
    <<0xBF, rest:bits>> -> Ok(#(F64ReinterpretI64, rest))
    <<0xC0, rest:bits>> -> Ok(#(I32Extend8S, rest))
    <<0xC1, rest:bits>> -> Ok(#(I32Extend16S, rest))
    <<0xC2, rest:bits>> -> Ok(#(I64Extend8S, rest))
    <<0xC3, rest:bits>> -> Ok(#(I64Extend16S, rest))
    <<0xC4, rest:bits>> -> Ok(#(I64Extend32S, rest))
    <<0xD0, rest:bits>> -> {
      use #(heap_type, rest) <- result.map(decode_heap_type(rest))
      #(RefNull(heap_type), rest)
    }
    <<0xD1, rest:bits>> -> Ok(#(RefIsNull, rest))
    <<0xD2, rest:bits>> -> {
      use #(func_idx, rest) <- result.map(decode_func_idx(rest))
      #(RefFunc(func_idx), rest)
    }
    <<0xD3, rest:bits>> -> Ok(#(RefEq, rest))
    <<0xD4, rest:bits>> -> Ok(#(RefAsNonNull, rest))
    <<0xD5, rest:bits>> -> {
      use #(label_idx, rest) <- result.map(decode_label_idx(rest))
      #(BrOnNull(label_idx), rest)
    }
    <<0xD6, rest:bits>> -> {
      use #(label_idx, rest) <- result.map(decode_label_idx(rest))
      #(BrOnNonNull(label_idx), rest)
    }
    <<0xFB, rest:bits>> -> {
      use #(inst_id, rest) <- result.try(decode_u32(rest))
      let inst_id = inst_id |> unwrap_u32
      case inst_id {
        0 -> {
          // 𝑥:typeidx -> struct.new 𝑥
          use #(type_idx, rest) <- result.map(decode_type_idx(rest))
          #(StructNew(type_idx), rest)
        }
        1 -> {
          // 𝑥:typeidx -> struct.new_default 𝑥
          use #(type_idx, rest) <- result.map(decode_type_idx(rest))
          #(StructNewDefault(type_idx), rest)
        }
        2 -> {
          // 𝑥:typeidx 𝑦:fieldidx -> struct.get 𝑥 𝑦
          use #(type_idx, rest) <- result.try(decode_type_idx(rest))
          use #(field_idx, rest) <- result.map(decode_field_idx(rest))
          #(StructGet(type_idx, field_idx), rest)
        }
        3 -> {
          // 𝑥:typeidx 𝑦:fieldidx -> struct.get_s 𝑥 𝑦
          use #(type_idx, rest) <- result.try(decode_type_idx(rest))
          use #(field_idx, rest) <- result.map(decode_field_idx(rest))
          #(StructGetS(type_idx, field_idx), rest)
        }
        4 -> {
          // 𝑥:typeidx 𝑦:fieldidx -> struct.get_u 𝑥 𝑦
          use #(type_idx, rest) <- result.try(decode_type_idx(rest))
          use #(field_idx, rest) <- result.map(decode_field_idx(rest))
          #(StructGetU(type_idx, field_idx), rest)
        }
        5 -> {
          // 𝑥:typeidx 𝑦:fieldidx -> struct.set 𝑥 𝑦
          use #(type_idx, rest) <- result.try(decode_type_idx(rest))
          use #(field_idx, rest) <- result.map(decode_field_idx(rest))
          #(StructSet(type_idx, field_idx), rest)
        }
        6 -> {
          // 𝑥:typeidx -> array.new 𝑥
          use #(type_idx, rest) <- result.map(decode_type_idx(rest))
          #(ArrayNew(type_idx), rest)
        }
        7 -> {
          // 𝑥:typeidx -> array.new_default 𝑥
          use #(type_idx, rest) <- result.map(decode_type_idx(rest))
          #(ArrayNewDefault(type_idx), rest)
        }
        8 -> {
          // 𝑥:typeidx 𝑛:u32 -> array.new_fixed 𝑥 𝑛
          use #(type_idx, rest) <- result.try(decode_type_idx(rest))
          use #(len, rest) <- result.map(decode_u32(rest))
          #(ArrayNewFixed(type_idx, len), rest)
        }
        9 -> {
          // 𝑥:typeidx 𝑦:dataidx -> array.new_data 𝑥 𝑦
          use #(type_idx, rest) <- result.try(decode_type_idx(rest))
          use #(data_idx, rest) <- result.map(decode_data_idx(rest))
          #(ArrayNewData(type_idx, data_idx), rest)
        }
        10 -> {
          // 𝑥:typeidx 𝑦:elemidx -> array.new_elem 𝑥 𝑦
          use #(type_idx, rest) <- result.try(decode_type_idx(rest))
          use #(elem_idx, rest) <- result.map(decode_elem_idx(rest))
          #(ArrayNewElem(type_idx, elem_idx), rest)
        }
        11 -> {
          // 𝑥:typeidx -> array.get 𝑥
          use #(type_idx, rest) <- result.map(decode_type_idx(rest))
          #(ArrayGet(type_idx), rest)
        }
        12 -> {
          // 𝑥:typeidx -> array.get_s 𝑥
          use #(type_idx, rest) <- result.map(decode_type_idx(rest))
          #(ArrayGetS(type_idx), rest)
        }
        13 -> {
          // 𝑥:typeidx -> array.get_u 𝑥
          use #(type_idx, rest) <- result.map(decode_type_idx(rest))
          #(ArrayGetU(type_idx), rest)
        }
        14 -> {
          // 𝑥:typeidx -> array.set 𝑥
          use #(type_idx, rest) <- result.map(decode_type_idx(rest))
          #(ArraySet(type_idx), rest)
        }
        15 -> Ok(#(ArrayLen, rest))
        16 -> {
          // 𝑥:typeidx -> array.fill 𝑥
          use #(type_idx, rest) <- result.map(decode_type_idx(rest))
          #(ArrayFill(type_idx), rest)
        }
        17 -> {
          // 𝑥:typeidx 𝑦:typeidx -> array.copy 𝑥 𝑦
          use #(type_idx1, rest) <- result.try(decode_type_idx(rest))
          use #(type_idx2, rest) <- result.map(decode_type_idx(rest))
          #(ArrayCopy(type_idx1, type_idx2), rest)
        }
        18 -> {
          // 𝑥:typeidx 𝑦:dataidx -> array.init_data 𝑥 𝑦
          use #(type_idx, rest) <- result.try(decode_type_idx(rest))
          use #(data_idx, rest) <- result.map(decode_data_idx(rest))
          #(ArrayInitData(type_idx, data_idx), rest)
        }
        19 -> {
          // 𝑥:typeidx 𝑦:elemidx -> array.init_elem 𝑥 𝑦
          use #(type_idx, rest) <- result.try(decode_type_idx(rest))
          use #(elem_idx, rest) <- result.map(decode_elem_idx(rest))
          #(ArrayInitElem(type_idx, elem_idx), rest)
        }
        20 -> {
          // ht:heaptype -> ref.test (ref ht)
          use #(ht, rest) <- result.map(decode_heap_type(rest))
          #(RefTest(ht), rest)
        }
        21 -> {
          // ht:heaptype -> ref.test (ref null ht)
          use #(ht, rest) <- result.map(decode_heap_type(rest))
          #(RefTestNullable(ht), rest)
        }
        22 -> {
          // ht:heaptype -> ref.cast (ref ht)
          use #(ht, rest) <- result.map(decode_heap_type(rest))
          #(RefCast(ht), rest)
        }
        23 -> {
          // ht:heaptype -> ref.cast (ref null ht)
          use #(ht, rest) <- result.map(decode_heap_type(rest))
          #(RefCastNullable(ht), rest)
        }
        26 -> Ok(#(AnyConvertExtern, rest))
        27 -> Ok(#(ExternConvertAny, rest))
        28 -> Ok(#(RefI31, rest))
        29 -> Ok(#(I31GetS, rest))
        30 -> Ok(#(I31GetU, rest))
        24 -> {
          // br_on_cast [cast_flags] [label_idx] [heap_type] [heap_type]
          use #(cast_flags, rest) <- result.try(decode_cast_flags(rest))
          use #(label_idx, rest) <- result.try(decode_label_idx(rest))
          use #(ht1, rest) <- result.try(decode_heap_type(rest))
          use #(ht2, rest) <- result.map(decode_heap_type(rest))
          #(
            BrOnCast(
              label_idx,
              HeapTypeRefType(ht1, cast_flags.0),
              HeapTypeRefType(ht2, cast_flags.1),
            ),
            rest,
          )
        }
        25 -> {
          // br_on_cast_fail [cast_flags] [label_idx] [heap_type] [heap_type]
          use #(cast_flags, rest) <- result.try(decode_cast_flags(rest))
          use #(label_idx, rest) <- result.try(decode_label_idx(rest))
          use #(ht1, rest) <- result.try(decode_heap_type(rest))
          use #(ht2, rest) <- result.map(decode_heap_type(rest))
          #(
            BrOnCastFail(
              label_idx,
              HeapTypeRefType(ht1, cast_flags.0),
              HeapTypeRefType(ht2, cast_flags.1),
            ),
            rest,
          )
        }
        _ ->
          Error(
            "Invalid ref instruction: 0xFB 0x" <> { inst_id |> int.to_base16 },
          )
      }
    }
    <<0xFC, rest:bits>> -> {
      use #(inst_id, rest) <- result.try(decode_u32(rest))
      let inst_id = inst_id |> unwrap_u32
      case inst_id {
        0 -> Ok(#(I32TruncSatF32S, rest))
        1 -> Ok(#(I32TruncSatF32U, rest))
        2 -> Ok(#(I32TruncSatF64S, rest))
        3 -> Ok(#(I32TruncSatF64U, rest))
        4 -> Ok(#(I64TruncSatF32S, rest))
        5 -> Ok(#(I64TruncSatF32U, rest))
        6 -> Ok(#(I64TruncSatF64S, rest))
        7 -> Ok(#(I64TruncSatF64U, rest))
        8 -> {
          use #(data_idx, rest) <- result.try(decode_data_idx(rest))
          use #(_, rest) <- result.map(rest |> common.expect_decode_byte(0x00))
          #(MemoryInit(data_idx), rest)
        }
        9 -> {
          use #(data_idx, rest) <- result.map(decode_data_idx(rest))
          #(DataDrop(data_idx), rest)
        }
        10 -> {
          use rest <- result.map(
            rest |> common.expect_decode_bytes(<<0x00, 0x00>>),
          )
          #(MemoryCopy, rest)
        }
        11 -> {
          use #(_, rest) <- result.map(rest |> common.expect_decode_byte(0x00))
          #(MemoryFill, rest)
        }
        // 12 elemidx 𝑥:tableidx ⇒ table.init 𝑥 𝑦
        12 -> {
          use #(elem_idx, rest) <- result.try(decode_elem_idx(rest))
          use #(table_idx, rest) <- result.map(rest |> decode_table_idx)
          #(TableInit(elem_idx, table_idx), rest)
        }
        // 13 elemidx ⇒ elem.drop 𝑥
        13 -> {
          use #(elem_idx, rest) <- result.map(decode_elem_idx(rest))
          #(ElemDrop(elem_idx), rest)
        }
        // 14 tableidx 𝑦:tableidx ⇒ table.copy 𝑥 𝑦
        14 -> {
          use #(table_idx, rest) <- result.try(decode_table_idx(rest))
          use #(table_idx2, rest) <- result.map(rest |> decode_table_idx)
          #(TableCopy(table_idx, table_idx2), rest)
        }
        // 15 tableidx ⇒ table.grow 𝑥
        15 -> {
          use #(table_idx, rest) <- result.map(rest |> decode_table_idx)
          #(TableGrow(table_idx), rest)
        }
        // 16 tableidx ⇒ table.size 𝑥
        16 -> {
          use #(table_idx, rest) <- result.map(rest |> decode_table_idx)
          #(TableSize(table_idx), rest)
        }
        // 17 tableidx ⇒ table.fill 𝑥
        17 -> {
          use #(table_idx, rest) <- result.map(rest |> decode_table_idx)
          #(TableFill(table_idx), rest)
        }
        _ ->
          Error(
            "Invalid saturation truncation instruction 0xFC 0x"
            <> { inst_id |> int.to_base16 },
          )
      }
    }
    <<0xFD, rest:bits>> -> {
      use #(inst_id, rest) <- result.try(decode_u32(rest))
      let inst_id = inst_id |> unwrap_u32
      case inst_id {
        0 -> {
          use #(mem_arg, rest) <- result.map(rest |> decode_mem_arg)
          #(V128Load(mem_arg), rest)
        }
        1 -> {
          use #(mem_arg, rest) <- result.map(rest |> decode_mem_arg)
          #(V128Load8x8S(mem_arg), rest)
        }
        2 -> {
          use #(mem_arg, rest) <- result.map(rest |> decode_mem_arg)
          #(V128Load8x8U(mem_arg), rest)
        }
        3 -> {
          use #(mem_arg, rest) <- result.map(rest |> decode_mem_arg)
          #(V128Load16x4S(mem_arg), rest)
        }
        4 -> {
          use #(mem_arg, rest) <- result.map(rest |> decode_mem_arg)
          #(V128Load16x4U(mem_arg), rest)
        }
        5 -> {
          use #(mem_arg, rest) <- result.map(rest |> decode_mem_arg)
          #(V128Load32x2S(mem_arg), rest)
        }
        6 -> {
          use #(mem_arg, rest) <- result.map(rest |> decode_mem_arg)
          #(V128Load32x2U(mem_arg), rest)
        }
        7 -> {
          use #(mem_arg, rest) <- result.map(rest |> decode_mem_arg)
          #(V128Load8Splat(mem_arg), rest)
        }
        8 -> {
          use #(mem_arg, rest) <- result.map(rest |> decode_mem_arg)
          #(V128Load16Splat(mem_arg), rest)
        }
        9 -> {
          use #(mem_arg, rest) <- result.map(rest |> decode_mem_arg)
          #(V128Load32Splat(mem_arg), rest)
        }
        10 -> {
          use #(mem_arg, rest) <- result.map(rest |> decode_mem_arg)
          #(V128Load64Splat(mem_arg), rest)
        }
        11 -> {
          use #(mem_arg, rest) <- result.map(rest |> decode_mem_arg)
          #(V128Store(mem_arg), rest)
        }
        12 -> {
          use #(v128_val, rest) <- result.map(rest |> values.decode_v128)
          #(V128Const(v128_val), rest)
        }
        13 -> {
          use #(lane_0, rest) <- result.try(rest |> decode_lane_16)
          use #(lane_1, rest) <- result.try(rest |> decode_lane_16)
          use #(lane_2, rest) <- result.try(rest |> decode_lane_16)
          use #(lane_3, rest) <- result.try(rest |> decode_lane_16)
          use #(lane_4, rest) <- result.try(rest |> decode_lane_16)
          use #(lane_5, rest) <- result.try(rest |> decode_lane_16)
          use #(lane_6, rest) <- result.try(rest |> decode_lane_16)
          use #(lane_7, rest) <- result.try(rest |> decode_lane_16)
          use #(lane_8, rest) <- result.try(rest |> decode_lane_16)
          use #(lane_9, rest) <- result.try(rest |> decode_lane_16)
          use #(lane_10, rest) <- result.try(rest |> decode_lane_16)
          use #(lane_11, rest) <- result.try(rest |> decode_lane_16)
          use #(lane_12, rest) <- result.try(rest |> decode_lane_16)
          use #(lane_13, rest) <- result.try(rest |> decode_lane_16)
          use #(lane_14, rest) <- result.try(rest |> decode_lane_16)
          use #(lane_15, rest) <- result.map(rest |> decode_lane_16)
          #(
            I8x16Shuffle(
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
              lane_10,
              lane_11,
              lane_12,
              lane_13,
              lane_14,
              lane_15,
            ),
            rest,
          )
        }
        14 -> Ok(#(I8x16Swizzle, rest))
        15 -> Ok(#(I8x16Splat, rest))
        16 -> Ok(#(I16x8Splat, rest))
        17 -> Ok(#(I32x4Splat, rest))
        18 -> Ok(#(I64x2Splat, rest))
        19 -> Ok(#(F32x4Splat, rest))
        20 -> Ok(#(F64x2Splat, rest))
        21 -> {
          use #(lane_idx, rest) <- result.map(decode_lane_16(rest))
          #(I8x16ExtractLaneS(lane_idx), rest)
        }
        22 -> {
          use #(lane_idx, rest) <- result.map(decode_lane_16(rest))
          #(I8x16ExtractLaneU(lane_idx), rest)
        }
        23 -> {
          use #(lane_idx, rest) <- result.map(decode_lane_16(rest))
          #(I8x16ReplaceLane(lane_idx), rest)
        }
        24 -> {
          use #(lane_idx, rest) <- result.map(decode_lane_8(rest))
          #(I16x8ExtractLaneS(lane_idx), rest)
        }
        25 -> {
          use #(lane_idx, rest) <- result.map(decode_lane_8(rest))
          #(I16x8ExtractLaneU(lane_idx), rest)
        }
        26 -> {
          use #(lane_idx, rest) <- result.map(decode_lane_8(rest))
          #(I16x8ReplaceLane(lane_idx), rest)
        }
        27 -> {
          use #(lane_idx, rest) <- result.map(decode_lane_4(rest))
          #(I32x4ExtractLane(lane_idx), rest)
        }
        28 -> {
          use #(lane_idx, rest) <- result.map(decode_lane_4(rest))
          #(I32x4ReplaceLane(lane_idx), rest)
        }
        29 -> {
          use #(lane_idx, rest) <- result.map(decode_lane_2(rest))
          #(I64x2ExtractLane(lane_idx), rest)
        }
        30 -> {
          use #(lane_idx, rest) <- result.map(decode_lane_2(rest))
          #(I64x2ReplaceLane(lane_idx), rest)
        }
        31 -> {
          use #(lane_idx, rest) <- result.map(decode_lane_4(rest))
          #(F32x4ExtractLane(lane_idx), rest)
        }
        32 -> {
          use #(lane_idx, rest) <- result.map(decode_lane_4(rest))
          #(F32x4ReplaceLane(lane_idx), rest)
        }
        33 -> {
          use #(lane_idx, rest) <- result.map(decode_lane_2(rest))
          #(F64x2ExtractLane(lane_idx), rest)
        }
        34 -> {
          use #(lane_idx, rest) <- result.map(decode_lane_2(rest))
          #(F64x2ReplaceLane(lane_idx), rest)
        }
        35 -> Ok(#(I8x16Eq, rest))
        36 -> Ok(#(I8x16Ne, rest))
        37 -> Ok(#(I8x16LtS, rest))
        38 -> Ok(#(I8x16LtU, rest))
        39 -> Ok(#(I8x16GtS, rest))
        40 -> Ok(#(I8x16GtU, rest))
        41 -> Ok(#(I8x16LeS, rest))
        42 -> Ok(#(I8x16LeU, rest))
        43 -> Ok(#(I8x16GeS, rest))
        44 -> Ok(#(I8x16GeU, rest))
        45 -> Ok(#(I16x8Eq, rest))
        46 -> Ok(#(I16x8Ne, rest))
        47 -> Ok(#(I16x8LtS, rest))
        48 -> Ok(#(I16x8LtU, rest))
        49 -> Ok(#(I16x8GtS, rest))
        50 -> Ok(#(I16x8GtU, rest))
        51 -> Ok(#(I16x8LeS, rest))
        52 -> Ok(#(I16x8LeU, rest))
        53 -> Ok(#(I16x8GeS, rest))
        54 -> Ok(#(I16x8GeU, rest))
        55 -> Ok(#(I32x4Eq, rest))
        56 -> Ok(#(I32x4Ne, rest))
        57 -> Ok(#(I32x4LtS, rest))
        58 -> Ok(#(I32x4LtU, rest))
        59 -> Ok(#(I32x4GtS, rest))
        60 -> Ok(#(I32x4GtU, rest))
        61 -> Ok(#(I32x4LeS, rest))
        62 -> Ok(#(I32x4LeU, rest))
        63 -> Ok(#(I32x4GeS, rest))
        64 -> Ok(#(I32x4GeU, rest))
        214 -> Ok(#(I64x2Eq, rest))
        215 -> Ok(#(I64x2Ne, rest))
        216 -> Ok(#(I64x2LtS, rest))
        217 -> Ok(#(I64x2GtS, rest))
        218 -> Ok(#(I64x2LeS, rest))
        219 -> Ok(#(I64x2GeS, rest))
        65 -> Ok(#(F32x4Eq, rest))
        66 -> Ok(#(F32x4Ne, rest))
        67 -> Ok(#(F32x4Lt, rest))
        68 -> Ok(#(F32x4Gt, rest))
        69 -> Ok(#(F32x4Le, rest))
        70 -> Ok(#(F32x4Ge, rest))
        71 -> Ok(#(F64x2Eq, rest))
        72 -> Ok(#(F64x2Ne, rest))
        73 -> Ok(#(F64x2Lt, rest))
        74 -> Ok(#(F64x2Gt, rest))
        75 -> Ok(#(F64x2Le, rest))
        76 -> Ok(#(F64x2Ge, rest))
        77 -> Ok(#(V128Not, rest))
        78 -> Ok(#(V128And, rest))
        79 -> Ok(#(V128AndNot, rest))
        80 -> Ok(#(V128Or, rest))
        81 -> Ok(#(V128Xor, rest))
        82 -> Ok(#(V128Bitselect, rest))
        83 -> Ok(#(V128AnyTrue, rest))
        84 -> {
          use #(mem_arg, rest) <- result.try(decode_mem_arg(rest))
          use #(lane_idx, rest) <- result.map(decode_lane_16(rest))
          #(V128Load8Lane(mem_arg, lane_idx), rest)
        }
        85 -> {
          use #(mem_arg, rest) <- result.try(decode_mem_arg(rest))
          use #(lane_idx, rest) <- result.map(decode_lane_8(rest))
          #(V128Load16Lane(mem_arg, lane_idx), rest)
        }
        86 -> {
          use #(mem_arg, rest) <- result.try(decode_mem_arg(rest))
          use #(lane_idx, rest) <- result.map(decode_lane_4(rest))
          #(V128Load32Lane(mem_arg, lane_idx), rest)
        }
        87 -> {
          use #(mem_arg, rest) <- result.try(decode_mem_arg(rest))
          use #(lane_idx, rest) <- result.map(decode_lane_2(rest))
          #(V128Load64Lane(mem_arg, lane_idx), rest)
        }
        88 -> {
          use #(mem_arg, rest) <- result.try(decode_mem_arg(rest))
          use #(lane_idx, rest) <- result.map(decode_lane_16(rest))
          #(V128Store8Lane(mem_arg, lane_idx), rest)
        }
        89 -> {
          use #(mem_arg, rest) <- result.try(decode_mem_arg(rest))
          use #(lane_idx, rest) <- result.map(decode_lane_8(rest))
          #(V128Store16Lane(mem_arg, lane_idx), rest)
        }
        90 -> {
          use #(mem_arg, rest) <- result.try(decode_mem_arg(rest))
          use #(lane_idx, rest) <- result.map(decode_lane_4(rest))
          #(V128Store32Lane(mem_arg, lane_idx), rest)
        }
        91 -> {
          use #(mem_arg, rest) <- result.try(decode_mem_arg(rest))
          use #(lane_idx, rest) <- result.map(decode_lane_2(rest))
          #(V128Store64Lane(mem_arg, lane_idx), rest)
        }
        92 -> {
          use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
          #(V128Load32Zero(mem_arg), rest)
        }
        93 -> {
          use #(mem_arg, rest) <- result.map(decode_mem_arg(rest))
          #(V128Load64Zero(mem_arg), rest)
        }
        94 -> Ok(#(F32x4DemoteF64x2Zero, rest))
        95 -> Ok(#(F64x2PromoteLowF32x4, rest))
        96 -> Ok(#(I8x16Abs, rest))
        97 -> Ok(#(I8x16Neg, rest))
        98 -> Ok(#(I8x16Popcnt, rest))
        99 -> Ok(#(I8x16AllTrue, rest))
        100 -> Ok(#(I8x16Bitmask, rest))
        101 -> Ok(#(I8x16NarrowI16x8S, rest))
        102 -> Ok(#(I8x16NarrowI16x8U, rest))
        103 -> Ok(#(F32x4Ceil, rest))
        104 -> Ok(#(F32x4Floor, rest))
        105 -> Ok(#(F32x4Trunc, rest))
        106 -> Ok(#(F32x4Nearest, rest))
        116 -> Ok(#(F64x2Ceil, rest))
        117 -> Ok(#(F64x2Floor, rest))
        122 -> Ok(#(F64x2Trunc, rest))
        148 -> Ok(#(F64x2Nearest, rest))
        107 -> Ok(#(I8x16Shl, rest))
        108 -> Ok(#(I8x16ShrS, rest))
        109 -> Ok(#(I8x16ShrU, rest))
        110 -> Ok(#(I8x16Add, rest))
        111 -> Ok(#(I8x16AddSatS, rest))
        112 -> Ok(#(I8x16AddSatU, rest))
        113 -> Ok(#(I8x16Sub, rest))
        114 -> Ok(#(I8x16SubSatS, rest))
        115 -> Ok(#(I8x16SubSatU, rest))
        118 -> Ok(#(I8x16MinS, rest))
        119 -> Ok(#(I8x16MinU, rest))
        120 -> Ok(#(I8x16MaxS, rest))
        121 -> Ok(#(I8x16MaxU, rest))
        123 -> Ok(#(I8x16AvgrU, rest))
        124 -> Ok(#(I16x8ExtaddPairwiseI8x16S, rest))
        125 -> Ok(#(I16x8ExtaddPairwiseI8x16U, rest))
        128 -> Ok(#(I16x8Abs, rest))
        129 -> Ok(#(I16x8Neg, rest))
        130 -> Ok(#(I16x8Q15mulrSatS, rest))
        131 -> Ok(#(I16x8AllTrue, rest))
        132 -> Ok(#(I16x8Bitmask, rest))
        133 -> Ok(#(I16x8NarrowI32x4S, rest))
        134 -> Ok(#(I16x8NarrowI32x4U, rest))
        135 -> Ok(#(I16x8ExtendLowI8x16S, rest))
        136 -> Ok(#(I16x8ExtendHighI8x16S, rest))
        137 -> Ok(#(I16x8ExtendLowI8x16U, rest))
        138 -> Ok(#(I16x8ExtendHighI8x16U, rest))
        139 -> Ok(#(I16x8Shl, rest))
        140 -> Ok(#(I16x8ShrS, rest))
        141 -> Ok(#(I16x8ShrU, rest))
        142 -> Ok(#(I16x8Add, rest))
        143 -> Ok(#(I16x8AddSatS, rest))
        144 -> Ok(#(I16x8AddSatU, rest))
        145 -> Ok(#(I16x8Sub, rest))
        146 -> Ok(#(I16x8SubSatS, rest))
        147 -> Ok(#(I16x8SubSatU, rest))
        149 -> Ok(#(I16x8Mul, rest))
        150 -> Ok(#(I16x8MinS, rest))
        151 -> Ok(#(I16x8MinU, rest))
        126 -> Ok(#(I32x4ExtaddPairwiseI16x8S, rest))
        127 -> Ok(#(I32x4ExtaddPairwiseI16x8U, rest))
        152 -> Ok(#(I16x8MaxS, rest))
        153 -> Ok(#(I16x8MaxU, rest))
        155 -> Ok(#(I16x8AvgrU, rest))
        156 -> Ok(#(I16x8ExtmulLowI8x16S, rest))
        157 -> Ok(#(I16x8ExtmulHighI8x16S, rest))
        158 -> Ok(#(I16x8ExtmulLowI8x16U, rest))
        159 -> Ok(#(I16x8ExtmulHighI8x16U, rest))
        160 -> Ok(#(I32x4Abs, rest))
        161 -> Ok(#(I32x4Neg, rest))
        163 -> Ok(#(I32x4AllTrue, rest))
        164 -> Ok(#(I32x4Bitmask, rest))
        167 -> Ok(#(I32x4ExtendLowI16x8S, rest))
        168 -> Ok(#(I32x4ExtendHighI16x8S, rest))
        169 -> Ok(#(I32x4ExtendLowI16x8U, rest))
        170 -> Ok(#(I32x4ExtendHighI16x8U, rest))
        171 -> Ok(#(I32x4Shl, rest))
        172 -> Ok(#(I32x4ShrS, rest))
        173 -> Ok(#(I32x4ShrU, rest))
        174 -> Ok(#(I32x4Add, rest))
        177 -> Ok(#(I32x4Sub, rest))
        181 -> Ok(#(I32x4Mul, rest))
        182 -> Ok(#(I32x4MinS, rest))
        183 -> Ok(#(I32x4MinU, rest))
        184 -> Ok(#(I32x4MaxS, rest))
        185 -> Ok(#(I32x4MaxU, rest))
        186 -> Ok(#(I32x4DotI16x8S, rest))
        188 -> Ok(#(I32x4ExtmulLowI16x8S, rest))
        189 -> Ok(#(I32x4ExtmulHighI16x8S, rest))
        190 -> Ok(#(I32x4ExtmulLowI16x8U, rest))
        191 -> Ok(#(I32x4ExtmulHighI16x8U, rest))
        192 -> Ok(#(I64x2Abs, rest))
        193 -> Ok(#(I64x2Neg, rest))
        195 -> Ok(#(I64x2AllTrue, rest))
        196 -> Ok(#(I64x2Bitmask, rest))
        199 -> Ok(#(I64x2ExtendLowI32x4S, rest))
        200 -> Ok(#(I64x2ExtendHighI32x4S, rest))
        201 -> Ok(#(I64x2ExtendLowI32x4U, rest))
        202 -> Ok(#(I64x2ExtendHighI32x4U, rest))
        203 -> Ok(#(I64x2Shl, rest))
        204 -> Ok(#(I64x2ShrS, rest))
        205 -> Ok(#(I64x2ShrU, rest))
        206 -> Ok(#(I64x2Add, rest))
        209 -> Ok(#(I64x2Sub, rest))
        213 -> Ok(#(I64x2Mul, rest))
        220 -> Ok(#(I64x2ExtmulLowI32x4S, rest))
        221 -> Ok(#(I64x2ExtmulHighI32x4S, rest))
        222 -> Ok(#(I64x2ExtmulLowI32x4U, rest))
        223 -> Ok(#(I64x2ExtmulHighI32x4U, rest))
        224 -> Ok(#(F32x4Abs, rest))
        225 -> Ok(#(F32x4Neg, rest))
        227 -> Ok(#(F32x4Sqrt, rest))
        228 -> Ok(#(F32x4Add, rest))
        229 -> Ok(#(F32x4Sub, rest))
        230 -> Ok(#(F32x4Mul, rest))
        231 -> Ok(#(F32x4Div, rest))
        232 -> Ok(#(F32x4Min, rest))
        233 -> Ok(#(F32x4Max, rest))
        234 -> Ok(#(F32x4Pmin, rest))
        235 -> Ok(#(F32x4Pmax, rest))
        236 -> Ok(#(F64x2Abs, rest))
        237 -> Ok(#(F64x2Neg, rest))
        239 -> Ok(#(F64x2Sqrt, rest))
        240 -> Ok(#(F64x2Add, rest))
        241 -> Ok(#(F64x2Sub, rest))
        242 -> Ok(#(F64x2Mul, rest))
        243 -> Ok(#(F64x2Div, rest))
        244 -> Ok(#(F64x2Min, rest))
        245 -> Ok(#(F64x2Max, rest))
        246 -> Ok(#(F64x2Pmin, rest))
        247 -> Ok(#(F64x2Pmax, rest))
        248 -> Ok(#(I32x4TruncSatF32x4S, rest))
        249 -> Ok(#(I32x4TruncSatF32x4U, rest))
        250 -> Ok(#(F32x4ConvertI32x4S, rest))
        251 -> Ok(#(F32x4ConvertI32x4U, rest))
        252 -> Ok(#(I32x4TruncSatF64x2SZero, rest))
        253 -> Ok(#(I32x4TruncSatF64x2UZero, rest))
        254 -> Ok(#(F64x2ConvertLowI32x4S, rest))
        255 -> Ok(#(F64x2ConvertLowI32x4U, rest))
        _ ->
          Error(
            "Invalid SIMD instruction: 0xFD 0x" <> { inst_id |> int.to_base16 },
          )
      }
    }
    <<a, _:bits>> -> Error("Invalid Instruction: 0x" <> { a |> int.to_base16 })
    _ -> panic as "Instruction buffer empty"
  }
}
