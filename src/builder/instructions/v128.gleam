import builder/expression.{type ExpressionBuilder}
import internal/structure/numbers.{type V128Value}
import internal/structure/types.{
  type LaneIDX16, type LaneIDX2, type LaneIDX4, type LaneIDX8, type MemArg,
  V128And, V128AndNot, V128AnyTrue, V128Bitselect, V128Const, V128Load,
  V128Load16Lane, V128Load16Splat, V128Load16x4S, V128Load16x4U, V128Load32Lane,
  V128Load32Splat, V128Load32Zero, V128Load32x2S, V128Load32x2U, V128Load64Lane,
  V128Load64Splat, V128Load64Zero, V128Load8Lane, V128Load8Splat, V128Load8x8S,
  V128Load8x8U, V128Not, V128Or, V128Store, V128Store16Lane, V128Store32Lane,
  V128Store64Lane, V128Store8Lane, V128Xor,
}

pub fn and_not(builder: ExpressionBuilder) {
  builder
  |> expression.push(V128AndNot)
}

pub fn const_(builder: ExpressionBuilder, value: V128Value) {
  builder
  |> expression.push(V128Const(value))
}

pub fn not(builder: ExpressionBuilder) {
  builder
  |> expression.push(V128Not)
}

pub fn xor(builder: ExpressionBuilder) {
  builder
  |> expression.push(V128Xor)
}

pub fn or(builder: ExpressionBuilder) {
  builder
  |> expression.push(V128Or)
}

pub fn and(builder: ExpressionBuilder) {
  builder
  |> expression.push(V128And)
}

pub fn bitselect(builder: ExpressionBuilder) {
  builder
  |> expression.push(V128Bitselect)
}

pub fn any_true(builder: ExpressionBuilder) {
  builder
  |> expression.push(V128AnyTrue)
}

pub fn load(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(V128Load(mem_arg))
}

pub fn store(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(V128Store(mem_arg))
}

pub fn load8x8s(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(V128Load8x8S(mem_arg))
}

pub fn load8x8u(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(V128Load8x8U(mem_arg))
}

pub fn load16x4s(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(V128Load16x4S(mem_arg))
}

pub fn load16x4u(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(V128Load16x4U(mem_arg))
}

pub fn load32x2s(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(V128Load32x2S(mem_arg))
}

pub fn load32x2u(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(V128Load32x2U(mem_arg))
}

pub fn load32_zero(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(V128Load32Zero(mem_arg))
}

pub fn load64_zero(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(V128Load64Zero(mem_arg))
}

pub fn load64_splat(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(V128Load64Splat(mem_arg))
}

pub fn load32_splat(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(V128Load32Splat(mem_arg))
}

pub fn load16_splat(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(V128Load16Splat(mem_arg))
}

pub fn load8_splat(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(V128Load8Splat(mem_arg))
}

pub fn load8_lane(
  builder: ExpressionBuilder,
  mem_arg: MemArg,
  lane_idx: LaneIDX16,
) {
  builder
  |> expression.push(V128Load8Lane(mem_arg, lane_idx))
}

pub fn load16_lane(
  builder: ExpressionBuilder,
  mem_arg: MemArg,
  lane_idx: LaneIDX8,
) {
  builder
  |> expression.push(V128Load16Lane(mem_arg, lane_idx))
}

pub fn load32_lane(
  builder: ExpressionBuilder,
  mem_arg: MemArg,
  lane_idx: LaneIDX4,
) {
  builder
  |> expression.push(V128Load32Lane(mem_arg, lane_idx))
}

pub fn load64_lane(
  builder: ExpressionBuilder,
  mem_arg: MemArg,
  lane_idx: LaneIDX2,
) {
  builder
  |> expression.push(V128Load64Lane(mem_arg, lane_idx))
}

pub fn store8_lane(
  builder: ExpressionBuilder,
  mem_arg: MemArg,
  lane_idx: LaneIDX16,
) {
  builder
  |> expression.push(V128Store8Lane(mem_arg, lane_idx))
}

pub fn store16_lane(
  builder: ExpressionBuilder,
  mem_arg: MemArg,
  lane_idx: LaneIDX8,
) {
  builder
  |> expression.push(V128Store16Lane(mem_arg, lane_idx))
}

pub fn store32_lane(
  builder: ExpressionBuilder,
  mem_arg: MemArg,
  lane_idx: LaneIDX4,
) {
  builder
  |> expression.push(V128Store32Lane(mem_arg, lane_idx))
}

pub fn store64_lane(
  builder: ExpressionBuilder,
  mem_arg: MemArg,
  lane_idx: LaneIDX2,
) {
  builder
  |> expression.push(V128Store64Lane(mem_arg, lane_idx))
}
