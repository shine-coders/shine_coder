import builder/expression.{type ExpressionBuilder}
import internal/structure/types.{
  type LaneIDX8, I16x8Abs, I16x8Add, I16x8AddSatS, I16x8AddSatU, I16x8AllTrue,
  I16x8AvgrU, I16x8Bitmask, I16x8Eq, I16x8ExtaddPairwiseI8x16S,
  I16x8ExtaddPairwiseI8x16U, I16x8ExtendHighI8x16S, I16x8ExtendHighI8x16U,
  I16x8ExtendLowI8x16S, I16x8ExtendLowI8x16U, I16x8ExtmulHighI8x16S,
  I16x8ExtmulHighI8x16U, I16x8ExtmulLowI8x16S, I16x8ExtmulLowI8x16U,
  I16x8ExtractLaneS, I16x8ExtractLaneU, I16x8GeS, I16x8GeU, I16x8GtS, I16x8GtU,
  I16x8LeS, I16x8LeU, I16x8LtS, I16x8LtU, I16x8MaxS, I16x8MaxU, I16x8MinS,
  I16x8MinU, I16x8Mul, I16x8NarrowI32x4S, I16x8NarrowI32x4U, I16x8Ne, I16x8Neg,
  I16x8Q15mulrSatS, I16x8ReplaceLane, I16x8Shl, I16x8ShrS, I16x8ShrU, I16x8Splat,
  I16x8Sub, I16x8SubSatS, I16x8SubSatU,
}

pub fn splat(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8Splat)
}

pub fn extract_lane_s(builder: ExpressionBuilder, lane_idx: LaneIDX8) {
  builder
  |> expression.push(I16x8ExtractLaneS(lane_idx))
}

pub fn extract_lane_u(builder: ExpressionBuilder, lane_idx: LaneIDX8) {
  builder
  |> expression.push(I16x8ExtractLaneU(lane_idx))
}

pub fn replace_lane(builder: ExpressionBuilder, lane_idx: LaneIDX8) {
  builder
  |> expression.push(I16x8ReplaceLane(lane_idx))
}

pub fn ge_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8GeS)
}

pub fn ge_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8GeU)
}

pub fn le_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8LeS)
}

pub fn le_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8LeU)
}

pub fn gt_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8GtS)
}

pub fn gt_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8GtU)
}

pub fn lt_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8LtS)
}

pub fn lt_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8LtU)
}

pub fn ne(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8Ne)
}

pub fn eq(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8Eq)
}

pub fn neg(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8Neg)
}

pub fn abs(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8Abs)
}

pub fn i16x8q15mulr_sat_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8Q15mulrSatS)
}

pub fn all_true(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8AllTrue)
}

pub fn bitmask(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8Bitmask)
}

pub fn narrow_i32x4s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8NarrowI32x4S)
}

pub fn narrow_i32x4u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8NarrowI32x4U)
}

pub fn extend_high_i8x16s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8ExtendHighI8x16S)
}

pub fn extend_high_i8x16u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8ExtendHighI8x16U)
}

pub fn extend_low_i8x16s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8ExtendLowI8x16S)
}

pub fn extend_low_i8x16u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8ExtendLowI8x16U)
}

pub fn shr_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8ShrS)
}

pub fn shr_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8ShrU)
}

pub fn shl(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8Shl)
}

pub fn sub(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8Sub)
}

pub fn add(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8Add)
}

pub fn max_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8MaxS)
}

pub fn max_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8MaxU)
}

pub fn min_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8MinS)
}

pub fn min_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8MinU)
}

pub fn sub_sat_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8SubSatS)
}

pub fn sub_sat_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8SubSatU)
}

pub fn add_sat_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8AddSatS)
}

pub fn add_sat_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8AddSatU)
}

pub fn mul(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8Mul)
}

pub fn avgr_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8AvgrU)
}

pub fn extmul_high_i8x16s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8ExtmulHighI8x16S)
}

pub fn extmul_high_i8x16u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8ExtmulHighI8x16U)
}

pub fn extmul_low_i8x16s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8ExtmulLowI8x16S)
}

pub fn extmul_low_i8x16u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8ExtmulLowI8x16U)
}

pub fn extadd_pairwise_i8x16s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8ExtaddPairwiseI8x16S)
}

pub fn extadd_pairwise_i8x16u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I16x8ExtaddPairwiseI8x16U)
}
