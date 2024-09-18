import builder/expression.{type ExpressionBuilder}
import internal/structure/types.{
  type BlockType, type FuncIDX, type LabelIDX, type RefType, type TableIDX,
  type TypeIDX, type ValType, Br, BrIf, BrOnCast, BrOnCastFail, BrOnNonNull,
  BrOnNull, BrTable, Call, CallIndirect, CallRef, Drop, Nop, Return, ReturnCall,
  ReturnCallIndirect, ReturnCallRef, Select, SelectT, Unreachable,
}

pub fn return(builder: ExpressionBuilder) {
  builder
  |> expression.push(Return)
}

pub fn return_call(builder: ExpressionBuilder, func_idx: FuncIDX) {
  builder
  |> expression.push(ReturnCall(func_idx))
}

pub fn return_call_indirect(
  builder: ExpressionBuilder,
  table_idx: TableIDX,
  type_idx: TypeIDX,
) {
  builder
  |> expression.push(ReturnCallIndirect(table_idx, type_idx))
}

pub fn return_call_ref(builder: ExpressionBuilder, type_idx: TypeIDX) {
  builder
  |> expression.push(ReturnCallRef(type_idx))
}

pub fn select(builder: ExpressionBuilder) {
  builder
  |> expression.push(Select)
}

pub fn select_t(builder: ExpressionBuilder, val_type: List(ValType)) {
  builder
  |> expression.push(SelectT(val_type))
}

pub fn unreachable(builder: ExpressionBuilder) {
  builder
  |> expression.push(Unreachable)
}

pub fn nop(builder: ExpressionBuilder) {
  builder
  |> expression.push(Nop)
}

pub fn loop(
  builder: ExpressionBuilder,
  block_type: BlockType,
  callback: fn(ExpressionBuilder) -> ExpressionBuilder,
) {
  builder
  |> expression.begin_loop(block_type)
  |> callback
  |> expression.end
}

pub fn if_(
  builder: ExpressionBuilder,
  block_type: BlockType,
  callback: fn(
    ExpressionBuilder,
    fn(ExpressionBuilder, fn(ExpressionBuilder) -> ExpressionBuilder) ->
      ExpressionBuilder,
  ) ->
    ExpressionBuilder,
) {
  builder
  |> expression.begin_if(block_type)
  |> callback(fn(builder, callback) {
    builder
    |> expression.begin_else
    |> callback
  })
  |> expression.end
}

pub fn block(
  builder: ExpressionBuilder,
  block_type: BlockType,
  callback: fn(ExpressionBuilder) -> ExpressionBuilder,
) {
  builder
  |> expression.begin_block(block_type)
  |> callback
  |> expression.end
}

pub fn br(builder: ExpressionBuilder, label_idx: LabelIDX) {
  builder
  |> expression.push(Br(label_idx))
}

pub fn br_if(builder: ExpressionBuilder, label_idx: LabelIDX) {
  builder
  |> expression.push(BrIf(label_idx))
}

pub fn br_on_cast(
  builder: ExpressionBuilder,
  label_idx: LabelIDX,
  rt1: RefType,
  rt2: RefType,
) {
  builder
  |> expression.push(BrOnCast(label_idx, rt1, rt2))
}

pub fn br_on_cast_fail(
  builder: ExpressionBuilder,
  label_idx: LabelIDX,
  rt1: RefType,
  rt2: RefType,
) {
  builder
  |> expression.push(BrOnCastFail(label_idx, rt1, rt2))
}

pub fn br_on_non_null(builder: ExpressionBuilder, label_idx: LabelIDX) {
  builder
  |> expression.push(BrOnNonNull(label_idx))
}

pub fn br_on_null(builder: ExpressionBuilder, label_idx: LabelIDX) {
  builder
  |> expression.push(BrOnNull(label_idx))
}

pub fn br_table(
  builder: ExpressionBuilder,
  labels: List(LabelIDX),
  default: LabelIDX,
) {
  builder
  |> expression.push(BrTable(labels, default))
}

pub fn call(builder: ExpressionBuilder, func_idx: FuncIDX) {
  builder
  |> expression.push(Call(func_idx))
}

pub fn call_indirect(
  builder: ExpressionBuilder,
  table_idx: TableIDX,
  type_idx: TypeIDX,
) {
  builder
  |> expression.push(CallIndirect(table_idx, type_idx))
}

pub fn call_ref(builder: ExpressionBuilder, type_idx: TypeIDX) {
  builder
  |> expression.push(CallRef(type_idx))
}

pub fn drop(builder: ExpressionBuilder) {
  builder
  |> expression.push(Drop)
}

pub fn end_expression(builder: ExpressionBuilder) {
  builder
  |> expression.end_unwrap
}
