import builder/expression.{type ExpressionBuilder}
import internal/structure/numbers.{type F64}
import internal/structure/types.{
  type MemArg, F64Abs, F64Add, F64Ceil, F64Const, F64ConvertI32S, F64ConvertI32U,
  F64ConvertI64S, F64ConvertI64U, F64Copysign, F64Div, F64Eq, F64Floor, F64Ge,
  F64Gt, F64Le, F64Load, F64Lt, F64Max, F64Min, F64Mul, F64Ne, F64Nearest,
  F64Neg, F64PromoteF32, F64ReinterpretI64, F64Sqrt, F64Store, F64Sub, F64Trunc,
}

pub fn const_(builder: ExpressionBuilder, val: F64) {
  builder
  |> expression.push(F64Const(val))
}

pub fn nearest(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Nearest)
}

pub fn trunc(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Trunc)
}

pub fn floor(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Floor)
}

pub fn ceil(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Ceil)
}

pub fn sqrt(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Sqrt)
}

pub fn neg(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Neg)
}

pub fn abs(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Abs)
}

pub fn copysign(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Copysign)
}

pub fn max(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Max)
}

pub fn min(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Min)
}

pub fn div(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Div)
}

pub fn mul(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Mul)
}

pub fn sub(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Sub)
}

pub fn add(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Add)
}

pub fn ge(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Ge)
}

pub fn le(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Le)
}

pub fn gt(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Gt)
}

pub fn lt(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Lt)
}

pub fn ne(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Ne)
}

pub fn eq(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64Eq)
}

pub fn promote_f32(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64PromoteF32)
}

pub fn convert_i64s(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64ConvertI64S)
}

pub fn convert_i64u(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64ConvertI64U)
}

pub fn convert_i32s(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64ConvertI32S)
}

pub fn convert_i32u(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64ConvertI32U)
}

pub fn reinterpret_i64(builder: ExpressionBuilder) {
  builder
  |> expression.push(F64ReinterpretI64)
}

pub fn load(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(F64Load(mem_arg))
}

pub fn store(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(F64Store(mem_arg))
}
