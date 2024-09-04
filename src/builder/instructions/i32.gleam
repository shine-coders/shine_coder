import builder/expression.{type ExpressionBuilder}
import internal/structure/numbers.{type I32}
import internal/structure/types.{
  type MemArg, I32Add, I32And, I32Clz, I32Const, I32Ctz, I32DivS, I32DivU, I32Eq,
  I32Eqz, I32Extend16S, I32Extend8S, I32GeS, I32GeU, I32GtS, I32GtU, I32LeS,
  I32LeU, I32Load, I32Load16S, I32Load16U, I32Load8S, I32Load8U, I32LtS, I32LtU,
  I32Mul, I32Ne, I32Or, I32Popcnt, I32ReinterpretF32, I32RemS, I32RemU, I32Rotl,
  I32Rotr, I32Shl, I32ShrS, I32ShrU, I32Store, I32Store16, I32Store8, I32Sub,
  I32TruncF32S, I32TruncF32U, I32TruncF64S, I32TruncF64U, I32TruncSatF32S,
  I32TruncSatF32U, I32TruncSatF64S, I32TruncSatF64U, I32WrapI64,
}

pub fn const_(builder: ExpressionBuilder, value: I32) {
  builder
  |> expression.push(I32Const(value))
}

pub fn popcnt(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32Popcnt)
}

pub fn ctz(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32Ctz)
}

pub fn clz(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32Clz)
}

pub fn rotr(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32Rotr)
}

pub fn rotl(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32Rotl)
}

pub fn shr_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32ShrS)
}

pub fn shr_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32ShrU)
}

pub fn shl(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32Shl)
}

pub fn or(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32Or)
}

pub fn and(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32And)
}

pub fn rem_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32RemS)
}

pub fn rem_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32RemU)
}

pub fn div_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32DivS)
}

pub fn div_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32DivU)
}

pub fn mul(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32Mul)
}

pub fn sub(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32Sub)
}

pub fn add(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32Add)
}

pub fn eqz(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32Eqz)
}

pub fn ge_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32GeS)
}

pub fn ge_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32GeU)
}

pub fn le_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32LeS)
}

pub fn le_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32LeU)
}

pub fn gt_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32GtS)
}

pub fn gt_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32GtU)
}

pub fn lt_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32LtS)
}

pub fn lt_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32LtU)
}

pub fn ne(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32Ne)
}

pub fn eq(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32Eq)
}

pub fn extend16s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32Extend16S)
}

pub fn extend8s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32Extend8S)
}

pub fn wrap_i64(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32WrapI64)
}

pub fn trunc_f64s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32TruncF64S)
}

pub fn trunc_f64u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32TruncF64U)
}

pub fn trunc_f32s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32TruncF32S)
}

pub fn trunc_f32u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32TruncF32U)
}

pub fn trunc_sat_f64s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32TruncSatF64S)
}

pub fn trunc_sat_f64u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32TruncSatF64U)
}

pub fn trunc_sat_f32s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32TruncSatF32S)
}

pub fn trunc_sat_f32u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32TruncSatF32U)
}

pub fn reinterpret_f32(builder: ExpressionBuilder) {
  builder
  |> expression.push(I32ReinterpretF32)
}

pub fn load(builder: ExpressionBuilder, arg: MemArg) {
  builder
  |> expression.push(I32Load(arg))
}

pub fn store(builder: ExpressionBuilder, arg: MemArg) {
  builder
  |> expression.push(I32Store(arg))
}

pub fn store8(builder: ExpressionBuilder, arg: MemArg) {
  builder
  |> expression.push(I32Store8(arg))
}

pub fn store16(builder: ExpressionBuilder, arg: MemArg) {
  builder
  |> expression.push(I32Store16(arg))
}

pub fn load16s(builder: ExpressionBuilder, arg: MemArg) {
  builder
  |> expression.push(I32Load16S(arg))
}

pub fn load16u(builder: ExpressionBuilder, arg: MemArg) {
  builder
  |> expression.push(I32Load16U(arg))
}

pub fn load8s(builder: ExpressionBuilder, arg: MemArg) {
  builder
  |> expression.push(I32Load8S(arg))
}

pub fn load8u(builder: ExpressionBuilder, arg: MemArg) {
  builder
  |> expression.push(I32Load8U(arg))
}
