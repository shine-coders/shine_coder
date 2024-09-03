import builder/expression_builder.{type ExpressionBuilder}
import internal/structure/types.{
  type LaneIDX4, I32x4Abs, I32x4Add, I32x4AllTrue, I32x4Bitmask, I32x4DotI16x8S,
  I32x4Eq, I32x4ExtaddPairwiseI16x8S, I32x4ExtaddPairwiseI16x8U,
  I32x4ExtendHighI16x8S, I32x4ExtendHighI16x8U, I32x4ExtendLowI16x8S,
  I32x4ExtendLowI16x8U, I32x4ExtmulHighI16x8S, I32x4ExtmulHighI16x8U,
  I32x4ExtmulLowI16x8S, I32x4ExtmulLowI16x8U, I32x4ExtractLane, I32x4GeS,
  I32x4GeU, I32x4GtS, I32x4GtU, I32x4LeS, I32x4LeU, I32x4LtS, I32x4LtU,
  I32x4MaxS, I32x4MaxU, I32x4MinS, I32x4MinU, I32x4Mul, I32x4Ne, I32x4Neg,
  I32x4ReplaceLane, I32x4Shl, I32x4ShrS, I32x4ShrU, I32x4Splat, I32x4Sub,
  I32x4TruncSatF32x4S, I32x4TruncSatF32x4U, I32x4TruncSatF64x2SZero,
  I32x4TruncSatF64x2UZero,
}

pub fn splat(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4Splat)
}

pub fn extract_lane(builder: ExpressionBuilder, lane_idx: LaneIDX4) {
  builder
  |> expression_builder.push(I32x4ExtractLane(lane_idx))
}

pub fn replace_lane(builder: ExpressionBuilder, lane_idx: LaneIDX4) {
  builder
  |> expression_builder.push(I32x4ReplaceLane(lane_idx))
}

pub fn ge_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4GeS)
}

pub fn ge_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4GeU)
}

pub fn le_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4LeS)
}

pub fn le_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4LeU)
}

pub fn gt_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4GtS)
}

pub fn gt_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4GtU)
}

pub fn lt_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4LtS)
}

pub fn lt_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4LtU)
}

pub fn ne(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4Ne)
}

pub fn eq(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4Eq)
}

pub fn neg(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4Neg)
}

pub fn abs(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4Abs)
}

pub fn dot_i16x8s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4DotI16x8S)
}

pub fn all_true(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4AllTrue)
}

pub fn bitmask(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4Bitmask)
}

pub fn extend_high_i16x8s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4ExtendHighI16x8S)
}

pub fn extend_high_i16x8u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4ExtendHighI16x8U)
}

pub fn extend_low_i16x8s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4ExtendLowI16x8S)
}

pub fn extend_low_i16x8u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4ExtendLowI16x8U)
}

pub fn shr_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4ShrS)
}

pub fn shr_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4ShrU)
}

pub fn shl(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4Shl)
}

pub fn sub(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4Sub)
}

pub fn add(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4Add)
}

pub fn max_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4MaxS)
}

pub fn max_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4MaxU)
}

pub fn min_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4MinS)
}

pub fn min_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4MinU)
}

pub fn mul(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4Mul)
}

pub fn extmul_high_i16x8s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4ExtmulHighI16x8S)
}

pub fn extmul_high_i16x8u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4ExtmulHighI16x8U)
}

pub fn extmul_low_i16x8s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4ExtmulLowI16x8S)
}

pub fn extmul_low_i16x8u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4ExtmulLowI16x8U)
}

pub fn extadd_pairwise_i16x8s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4ExtaddPairwiseI16x8S)
}

pub fn extadd_pairwise_i16x8u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4ExtaddPairwiseI16x8U)
}

pub fn trunc_sat_f32x4s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4TruncSatF32x4S)
}

pub fn trunc_sat_f32x4u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4TruncSatF32x4U)
}

pub fn trunc_sat_f64x2s_zero(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4TruncSatF64x2SZero)
}

pub fn trunc_sat_f64x2u_zero(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I32x4TruncSatF64x2UZero)
}
