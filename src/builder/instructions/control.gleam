import builder/expression_builder.{type ExpressionBuilder}
import internal/finger_tree.{type FingerTree}
import internal/structure/types.{
  type BlockType, type FuncIDX, type LabelIDX, type RefType, type TableIDX,
  type TypeIDX, type ValType, Br, BrIf, BrOnCast, BrOnCastFail, BrOnNonNull,
  BrOnNull, BrTable, Call, CallIndirect, CallRef, Drop, Nop, Return, ReturnCall,
  ReturnCallIndirect, ReturnCallRef, Select, SelectT, Unreachable,
}

pub fn return(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(Return)
}

pub fn return_call(builder: ExpressionBuilder, func_idx: FuncIDX) {
  builder
  |> expression_builder.push(ReturnCall(func_idx))
}

pub fn return_call_indirect(
  builder: ExpressionBuilder,
  table_idx: TableIDX,
  type_idx: TypeIDX,
) {
  builder
  |> expression_builder.push(ReturnCallIndirect(table_idx, type_idx))
}

pub fn return_call_ref(builder: ExpressionBuilder, type_idx: TypeIDX) {
  builder
  |> expression_builder.push(ReturnCallRef(type_idx))
}

pub fn select(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(Select)
}

pub fn select_t(builder: ExpressionBuilder, val_type: FingerTree(ValType)) {
  builder
  |> expression_builder.push(SelectT(val_type))
}

pub fn unreachable(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(Unreachable)
}

pub fn nop(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(Nop)
}

pub fn loop(
  builder: ExpressionBuilder,
  block_type: BlockType,
  callback: fn(ExpressionBuilder) -> ExpressionBuilder,
) {
  builder
  |> expression_builder.begin_loop(block_type)
  |> callback
  |> expression_builder.end
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
  |> expression_builder.begin_if(block_type)
  |> callback(fn(builder, callback) {
    builder
    |> expression_builder.begin_else
    |> callback
  })
  |> expression_builder.end
}

pub fn block(
  builder: ExpressionBuilder,
  block_type: BlockType,
  callback: fn(ExpressionBuilder) -> ExpressionBuilder,
) {
  builder
  |> expression_builder.begin_block(block_type)
  |> callback
  |> expression_builder.end
}

pub fn br(builder: ExpressionBuilder, label_idx: LabelIDX) {
  builder
  |> expression_builder.push(Br(label_idx))
}

pub fn br_if(builder: ExpressionBuilder, label_idx: LabelIDX) {
  builder
  |> expression_builder.push(BrIf(label_idx))
}

pub fn br_on_cast(
  builder: ExpressionBuilder,
  label_idx: LabelIDX,
  rt1: RefType,
  rt2: RefType,
) {
  builder
  |> expression_builder.push(BrOnCast(label_idx, rt1, rt2))
}

pub fn br_on_cast_fail(
  builder: ExpressionBuilder,
  label_idx: LabelIDX,
  rt1: RefType,
  rt2: RefType,
) {
  builder
  |> expression_builder.push(BrOnCastFail(label_idx, rt1, rt2))
}

pub fn br_on_non_null(builder: ExpressionBuilder, label_idx: LabelIDX) {
  builder
  |> expression_builder.push(BrOnNonNull(label_idx))
}

pub fn br_on_null(builder: ExpressionBuilder, label_idx: LabelIDX) {
  builder
  |> expression_builder.push(BrOnNull(label_idx))
}

pub fn br_table(
  builder: ExpressionBuilder,
  labels: FingerTree(LabelIDX),
  default: LabelIDX,
) {
  builder
  |> expression_builder.push(BrTable(labels, default))
}

pub fn call(builder: ExpressionBuilder, func_idx: FuncIDX) {
  builder
  |> expression_builder.push(Call(func_idx))
}

pub fn call_indirect(
  builder: ExpressionBuilder,
  table_idx: TableIDX,
  type_idx: TypeIDX,
) {
  builder
  |> expression_builder.push(CallIndirect(table_idx, type_idx))
}

pub fn call_ref(builder: ExpressionBuilder, type_idx: TypeIDX) {
  builder
  |> expression_builder.push(CallRef(type_idx))
}

pub fn drop(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(Drop)
}

pub fn end_expression(builder: ExpressionBuilder) {
  builder
  |> expression_builder.end_unwrap
}
