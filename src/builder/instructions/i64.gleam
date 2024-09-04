import builder/expression.{type ExpressionBuilder}
import internal/structure/numbers.{type I64}
import internal/structure/types.{
  type MemArg, I64Add, I64And, I64Clz, I64Const, I64Ctz, I64DivS, I64DivU, I64Eq,
  I64Eqz, I64Extend16S, I64Extend32S, I64Extend8S, I64ExtendI32S, I64ExtendI32U,
  I64GeS, I64GeU, I64GtS, I64GtU, I64LeS, I64LeU, I64Load, I64Load16S,
  I64Load16U, I64Load32S, I64Load32U, I64Load8S, I64Load8U, I64LtS, I64LtU,
  I64Mul, I64Ne, I64Or, I64Popcnt, I64ReinterpretF64, I64RemS, I64RemU, I64Rotl,
  I64Rotr, I64Shl, I64ShrS, I64ShrU, I64Store, I64Store16, I64Store32, I64Store8,
  I64Sub, I64TruncF32S, I64TruncF32U, I64TruncF64S, I64TruncF64U,
  I64TruncSatF32S, I64TruncSatF32U, I64TruncSatF64S, I64TruncSatF64U,
}

pub fn const_(builder: ExpressionBuilder, val: I64) {
  builder
  |> expression.push(I64Const(val))
}

pub fn popcnt(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64Popcnt)
}

pub fn ctz(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64Ctz)
}

pub fn clz(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64Clz)
}

pub fn rotr(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64Rotr)
}

pub fn rotl(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64Rotl)
}

pub fn shr_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64ShrS)
}

pub fn shr_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64ShrU)
}

pub fn shl(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64Shl)
}

pub fn or(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64Or)
}

pub fn and(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64And)
}

pub fn rem_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64RemS)
}

pub fn rem_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64RemU)
}

pub fn div_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64DivS)
}

pub fn div_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64DivU)
}

pub fn mul(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64Mul)
}

pub fn sub(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64Sub)
}

pub fn add(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64Add)
}

pub fn eqz(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64Eqz)
}

pub fn ge_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64GeS)
}

pub fn ge_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64GeU)
}

pub fn le_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64LeS)
}

pub fn le_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64LeU)
}

pub fn gt_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64GtS)
}

pub fn gt_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64GtU)
}

pub fn lt_s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64LtS)
}

pub fn lt_u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64LtU)
}

pub fn ne(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64Ne)
}

pub fn eq(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64Eq)
}

pub fn extend32s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64Extend32S)
}

pub fn extend16s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64Extend16S)
}

pub fn extend8s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64Extend8S)
}

pub fn extend_i32s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64ExtendI32S)
}

pub fn extend_i32u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64ExtendI32U)
}

pub fn trunc_f64s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64TruncF64S)
}

pub fn trunc_f64u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64TruncF64U)
}

pub fn trunc_f32s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64TruncF32S)
}

pub fn trunc_f32u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64TruncF32U)
}

pub fn trunc_sat_f64s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64TruncSatF64S)
}

pub fn trunc_sat_f64u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64TruncSatF64U)
}

pub fn trunc_sat_f32s(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64TruncSatF32S)
}

pub fn trunc_sat_f32u(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64TruncSatF32U)
}

pub fn reinterpret_f64(builder: ExpressionBuilder) {
  builder
  |> expression.push(I64ReinterpretF64)
}

pub fn load(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(I64Load(mem_arg))
}

pub fn store(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(I64Store(mem_arg))
}

pub fn store8(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(I64Store8(mem_arg))
}

pub fn store16(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(I64Store16(mem_arg))
}

pub fn store32(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(I64Store32(mem_arg))
}

pub fn load16s(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(I64Load16S(mem_arg))
}

pub fn load16u(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(I64Load16U(mem_arg))
}

pub fn load8s(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(I64Load8S(mem_arg))
}

pub fn load8u(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(I64Load8U(mem_arg))
}

pub fn load32s(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(I64Load32S(mem_arg))
}

pub fn load32u(builder: ExpressionBuilder, mem_arg: MemArg) {
  builder
  |> expression.push(I64Load32U(mem_arg))
}
