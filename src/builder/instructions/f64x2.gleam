import builder/expression.{type ExpressionBuilder}
import internal/structure/types.{
  type LaneIDX2, F64x2Abs, F64x2Add, F64x2Ceil, F64x2ConvertLowI32x4S,
  F64x2ConvertLowI32x4U, F64x2Div, F64x2Eq, F64x2ExtractLane, F64x2Floor,
  F64x2Ge, F64x2Gt, F64x2Le, F64x2Lt, F64x2Max, F64x2Min, F64x2Mul, F64x2Ne,
  F64x2Nearest, F64x2Neg, F64x2Pmax, F64x2Pmin, F64x2PromoteLowF32x4,
  F64x2ReplaceLane, F64x2Splat, F64x2Sqrt, F64x2Sub, F64x2Trunc,
}

pub fn splat(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Splat)
}

pub fn extract_lane(builder: ExpressionBuilder, lane_idx: LaneIDX2) {
  builder
  |> expression.push(F64x2ExtractLane(lane_idx))
}

pub fn replace_lane(builder: ExpressionBuilder, lane_idx: LaneIDX2) {
  builder
  |> expression.push(F64x2ReplaceLane(lane_idx))
}

pub fn ge(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Ge)
}

pub fn le(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Le)
}

pub fn gt(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Gt)
}

pub fn lt(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Lt)
}

pub fn ne(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Ne)
}

pub fn eq(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Eq)
}

pub fn nearest(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Nearest)
}

pub fn trunc(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Trunc)
}

pub fn floor(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Floor)
}

pub fn ceil(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Ceil)
}

pub fn sqrt(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Sqrt)
}

pub fn neg(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Neg)
}

pub fn abs(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Abs)
}

pub fn pmax(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Pmax)
}

pub fn pmin(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Pmin)
}

pub fn max(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Max)
}

pub fn min(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Min)
}

pub fn div(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Div)
}

pub fn mul(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Mul)
}

pub fn sub(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Sub)
}

pub fn add(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2Add)
}

pub fn convert_low_i32x4s(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2ConvertLowI32x4S)
}

pub fn convert_low_i32x4u(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2ConvertLowI32x4U)
}

pub fn promote_low_f32x4(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64x2PromoteLowF32x4)
}
