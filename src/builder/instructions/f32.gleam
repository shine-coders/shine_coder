import builder/expression_builder.{type ExpressionBuilder}
import internal/structure/numbers.{type F32}
import internal/structure/types.{
  type MemArg, F32Abs, F32Add, F32Ceil, F32Const, F32ConvertI32S, F32ConvertI32U,
  F32ConvertI64S, F32ConvertI64U, F32Copysign, F32DemoteF64, F32Div, F32Eq,
  F32Floor, F32Ge, F32Gt, F32Le, F32Load, F32Lt, F32Max, F32Min, F32Mul, F32Ne,
  F32Nearest, F32Neg, F32ReinterpretI32, F32Sqrt, F32Store, F32Sub, F32Trunc,
}

pub fn const_(builder: ExpressionBuilder, val: F32) {
  builder
  |> expression_builder.push(F32Const(val))
}

pub fn nearest(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Nearest)
}

pub fn trunc(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Trunc)
}

pub fn floor(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Floor)
}

pub fn ceil(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Ceil)
}

pub fn sqrt(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Sqrt)
}

pub fn neg(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Neg)
}

pub fn abs(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Abs)
}

pub fn copysign(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Copysign)
}

pub fn max(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Max)
}

pub fn min(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Min)
}

pub fn div(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Div)
}

pub fn mul(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Mul)
}

pub fn sub(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Sub)
}

pub fn add(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Add)
}

pub fn ge(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Ge)
}

pub fn le(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Le)
}

pub fn gt(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Gt)
}

pub fn lt(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Lt)
}

pub fn ne(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Ne)
}

pub fn eq(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32Eq)
}

pub fn demote_f64(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32DemoteF64)
}

pub fn convert_i64s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32ConvertI64S)
}

pub fn convert_i64u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32ConvertI64U)
}

pub fn convert_i32s(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32ConvertI32S)
}

pub fn convert_i32u(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32ConvertI32U)
}

pub fn reinterpret_i32(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(F32ReinterpretI32)
}

pub fn load(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression_builder.push(F32Load(mem_arg))
}

pub fn store(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression_builder.push(F32Store(mem_arg))
}
