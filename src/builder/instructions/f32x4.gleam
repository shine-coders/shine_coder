import builder/expression.{type ExpressionBuilder}
import internal/structure/types.{
  type LaneIDX4, F32x4Abs, F32x4Add, F32x4Ceil, F32x4ConvertI32x4S,
  F32x4ConvertI32x4U, F32x4DemoteF64x2Zero, F32x4Div, F32x4Eq, F32x4ExtractLane,
  F32x4Floor, F32x4Ge, F32x4Gt, F32x4Le, F32x4Lt, F32x4Max, F32x4Min, F32x4Mul,
  F32x4Ne, F32x4Nearest, F32x4Neg, F32x4Pmax, F32x4Pmin, F32x4ReplaceLane,
  F32x4Splat, F32x4Sqrt, F32x4Sub, F32x4Trunc,
}

pub fn splat(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Splat)
}

pub fn extract_lane(builder: ExpressionBuilder, lane_idx: LaneIDX4) {
  builder
  |> expression.push(F32x4ExtractLane(lane_idx))
}

pub fn replace_lane(builder: ExpressionBuilder, lane_idx: LaneIDX4) {
  builder
  |> expression.push(F32x4ReplaceLane(lane_idx))
}

pub fn ge(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Ge)
}

pub fn le(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Le)
}

pub fn gt(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Gt)
}

pub fn lt(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Lt)
}

pub fn ne(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Ne)
}

pub fn eq(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Eq)
}

pub fn nearest(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Nearest)
}

pub fn trunc(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Trunc)
}

pub fn floor(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Floor)
}

pub fn ceil(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Ceil)
}

pub fn sqrt(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Sqrt)
}

pub fn neg(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Neg)
}

pub fn abs(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Abs)
}

pub fn pmax(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Pmax)
}

pub fn pmin(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Pmin)
}

pub fn max(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Max)
}

pub fn min(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Min)
}

pub fn div(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Div)
}

pub fn mul(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Mul)
}

pub fn sub(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Sub)
}

pub fn add(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4Add)
}

pub fn convert_i32x4s(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4ConvertI32x4S)
}

pub fn convert_i32x4u(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4ConvertI32x4U)
}

pub fn demote_f64x2_zero(builder: ExpressionBuilder) {
  builder
  |> expression.push(F32x4DemoteF64x2Zero)
}
