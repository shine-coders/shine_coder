import builder/expression_builder.{type ExpressionBuilder}
import internal/structure/types.{
  type LaneIDX16, I8x16Abs, I8x16Add, I8x16AddSatS, I8x16AddSatU, I8x16AllTrue,
  I8x16AvgrU, I8x16Bitmask, I8x16Eq, I8x16ExtractLaneS, I8x16ExtractLaneU,
  I8x16GeS, I8x16GeU, I8x16GtS, I8x16GtU, I8x16LeS, I8x16LeU, I8x16LtS, I8x16LtU,
  I8x16MaxS, I8x16MaxU, I8x16MinS, I8x16MinU, I8x16NarrowI16x8S,
  I8x16NarrowI16x8U, I8x16Ne, I8x16Neg, I8x16Popcnt, I8x16ReplaceLane, I8x16Shl,
  I8x16ShrS, I8x16ShrU, I8x16Shuffle, I8x16Splat, I8x16Sub, I8x16SubSatS,
  I8x16SubSatU, I8x16Swizzle,
}

pub fn abs(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16Abs)
}

pub fn add(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16Add)
}

pub fn add_sat_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16AddSatS)
}

pub fn add_sat_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16AddSatU)
}

pub fn all_true(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16AllTrue)
}

pub fn avgr_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16AvgrU)
}

pub fn bitmask(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16Bitmask)
}

pub fn eq(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16Eq)
}

pub fn extract_lane_u(builder: ExpressionBuilder, lane_idx: LaneIDX16) {
  builder
  |> expression_builder.push(I8x16ExtractLaneU(lane_idx))
}

pub fn extract_lane_s(builder: ExpressionBuilder, lane_idx: LaneIDX16) {
  builder
  |> expression_builder.push(I8x16ExtractLaneS(lane_idx))
}

pub fn ge_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16GeS)
}

pub fn ge_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16GeU)
}

pub fn gt_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16GtS)
}

pub fn gt_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16GtU)
}

pub fn le_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16LeS)
}

pub fn le_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16LeU)
}

pub fn lt_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16LtS)
}

pub fn lt_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16LtU)
}

pub fn max_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16MaxS)
}

pub fn max_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16MaxU)
}

pub fn min_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16MinS)
}

pub fn min_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16MinU)
}

pub fn narrow_i16x8_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16NarrowI16x8S)
}

pub fn narrow_i16x8_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16NarrowI16x8U)
}

pub fn ne(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16Ne)
}

pub fn neg(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16Neg)
}

pub fn popcnt(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16Popcnt)
}

pub fn replace_lane(builder: ExpressionBuilder, lane_idx: LaneIDX16) {
  builder
  |> expression_builder.push(I8x16ReplaceLane(lane_idx))
}

pub fn shl(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16Shl)
}

pub fn shr_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16ShrS)
}

pub fn shr_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16ShrU)
}

pub fn shuffle(
  builder: ExpressionBuilder,
  l0: LaneIDX16,
  l1: LaneIDX16,
  l2: LaneIDX16,
  l3: LaneIDX16,
  l4: LaneIDX16,
  l5: LaneIDX16,
  l6: LaneIDX16,
  l7: LaneIDX16,
  l8: LaneIDX16,
  l9: LaneIDX16,
  l10: LaneIDX16,
  l11: LaneIDX16,
  l12: LaneIDX16,
  l13: LaneIDX16,
  l14: LaneIDX16,
  l15: LaneIDX16,
) {
  builder
  |> expression_builder.push(I8x16Shuffle(
    l0,
    l1,
    l2,
    l3,
    l4,
    l5,
    l6,
    l7,
    l8,
    l9,
    l10,
    l11,
    l12,
    l13,
    l14,
    l15,
  ))
}

pub fn splat(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16Splat)
}

pub fn sub(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16Sub)
}

pub fn sub_sat_s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16SubSatS)
}

pub fn sub_sat_u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16SubSatU)
}

pub fn swizzle(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(I8x16Swizzle)
}
