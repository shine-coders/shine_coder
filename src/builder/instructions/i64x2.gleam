import builder/expression_builder.{type ExpressionBuilder}
import internal/structure/types.{
  type LaneIDX2, I64x2Abs, I64x2Add, I64x2AllTrue, I64x2Bitmask, I64x2Eq,
  I64x2ExtendHighI32x4S, I64x2ExtendHighI32x4U, I64x2ExtendLowI32x4S,
  I64x2ExtendLowI32x4U, I64x2ExtmulHighI32x4S, I64x2ExtmulHighI32x4U,
  I64x2ExtmulLowI32x4S, I64x2ExtmulLowI32x4U, I64x2ExtractLane, I64x2GeS,
  I64x2GtS, I64x2LeS, I64x2LtS, I64x2Mul, I64x2Ne, I64x2Neg, I64x2ReplaceLane,
  I64x2Shl, I64x2ShrS, I64x2ShrU, I64x2Splat, I64x2Sub,
}

pub fn splat(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2Splat)
}

pub fn extract_lane(builder: ExpressionBuilder, lane_idx: LaneIDX2) {
  builder
  |> expression_builder.push(I64x2ExtractLane(lane_idx))
}

pub fn replace_lane(builder: ExpressionBuilder, lane_idx: LaneIDX2) {
  builder
  |> expression_builder.push(I64x2ReplaceLane(lane_idx))
}

pub fn ge_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2GeS)
}

pub fn le_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2LeS)
}

pub fn gt_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2GtS)
}

pub fn lt_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2LtS)
}

pub fn ne(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2Ne)
}

pub fn eq(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2Eq)
}

pub fn neg(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2Neg)
}

pub fn abs(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2Abs)
}

pub fn all_true(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2AllTrue)
}

pub fn bitmask(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2Bitmask)
}

pub fn extend_high_i32x4s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2ExtendHighI32x4S)
}

pub fn extend_high_i32x4u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2ExtendHighI32x4U)
}

pub fn extend_low_i32x4s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2ExtendLowI32x4S)
}

pub fn extend_low_i32x4u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2ExtendLowI32x4U)
}

pub fn shr_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2ShrS)
}

pub fn shr_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2ShrU)
}

pub fn shl(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2Shl)
}

pub fn sub(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2Sub)
}

pub fn add(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2Add)
}

pub fn mul(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2Mul)
}

pub fn extmul_high_i32x4s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2ExtmulHighI32x4S)
}

pub fn extmul_high_i32x4u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2ExtmulHighI32x4U)
}

pub fn extmul_low_i32x4s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2ExtmulLowI32x4S)
}

pub fn extmul_low_i32x4u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I64x2ExtmulLowI32x4U)
}
