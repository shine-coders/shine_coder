import gleam/list
import gleam/option.{type Option, None, Some}
import internal/structure/types.{
  type BlockType, type Expr, type Instruction, Block, Expr, If, Loop,
}

type BlockDefinition {
  EmptyTop
  OuterMostBlock(instructions: List(Instruction))
  IfBlock(bt: BlockType, instructions: List(Instruction))
  ElseBlock(
    bt: BlockType,
    if_instructions: List(Instruction),
    else_instructions: List(Instruction),
  )
  LoopBlock(bt: BlockType, instructions: List(Instruction))
  InlineBlock(bt: BlockType, instructions: List(Instruction))
}

pub opaque type ExpressionBuilder {
  ExpressionBuilder(
    result: Option(Expr),
    top: BlockDefinition,
    block_stack: List(BlockDefinition),
  )
}

pub fn new() -> ExpressionBuilder {
  ExpressionBuilder(None, OuterMostBlock([]), [])
}

pub fn begin_if(builder: ExpressionBuilder, bt: BlockType) -> ExpressionBuilder {
  let ExpressionBuilder(result, top, block_stack) = builder
  ExpressionBuilder(result, IfBlock(bt, []), [top, ..block_stack])
}

pub fn begin_else(builder: ExpressionBuilder) {
  case builder.top {
    IfBlock(bt, instructions) ->
      ExpressionBuilder(..builder, top: ElseBlock(bt, instructions, []))
    EmptyTop -> panic as "Stack state underflow"
    _ -> panic as "Invalid stack state, cannot start else block"
  }
}

pub fn begin_loop(
  builder: ExpressionBuilder,
  bt: BlockType,
) -> ExpressionBuilder {
  ExpressionBuilder(builder.result, LoopBlock(bt, []), [
    builder.top,
    ..builder.block_stack
  ])
}

pub fn begin_block(
  builder: ExpressionBuilder,
  bt: BlockType,
) -> ExpressionBuilder {
  ExpressionBuilder(builder.result, InlineBlock(bt, []), [
    builder.top,
    ..builder.block_stack
  ])
}

pub fn end(builder: ExpressionBuilder) {
  case builder {
    ExpressionBuilder(None, OuterMostBlock(instructions), block_stack)
      if block_stack == []
    ->
      Ok(ExpressionBuilder(
        Some(Expr(instructions |> list.reverse)),
        EmptyTop,
        block_stack,
      ))
    ExpressionBuilder(None, IfBlock(bt, if_instructions), block_stack) ->
      do_append(block_stack, If(bt, if_instructions |> list.reverse, None))
    ExpressionBuilder(
      None,
      ElseBlock(bt, if_instructions, else_instructions),
      block_stack,
    ) ->
      do_append(
        block_stack,
        If(
          bt,
          if_instructions |> list.reverse,
          Some(else_instructions |> list.reverse),
        ),
      )
    ExpressionBuilder(None, LoopBlock(bt, loop_instructions), block_stack) ->
      do_append(block_stack, Loop(bt, Expr(loop_instructions |> list.reverse)))
    ExpressionBuilder(None, InlineBlock(bt, block_instructions), block_stack) ->
      do_append(
        block_stack,
        Block(bt, Expr(block_instructions |> list.reverse)),
      )
    ExpressionBuilder(_, EmptyTop, _) -> Error("Stack state underflow")
    _ -> Error("Invalid stack state")
  }
}

fn do_append(next_stack: List(BlockDefinition), next_instruction: Instruction) {
  case next_stack {
    [OuterMostBlock(outer_instructions), ..next_stack] ->
      Ok(ExpressionBuilder(
        None,
        OuterMostBlock([next_instruction, ..outer_instructions]),
        next_stack,
      ))

    [IfBlock(outer_bt, outer_if_instructions), ..next_stack] ->
      Ok(ExpressionBuilder(
        None,
        IfBlock(outer_bt, [next_instruction, ..outer_if_instructions]),
        next_stack,
      ))
    [
      ElseBlock(outer_bt, outer_if_instructions, outer_else_instructions),
      ..next_stack
    ] ->
      Ok(ExpressionBuilder(
        None,
        ElseBlock(outer_bt, outer_if_instructions, [
          next_instruction,
          ..outer_else_instructions
        ]),
        next_stack,
      ))

    [LoopBlock(outer_bt, outer_instructions), ..next_stack] ->
      Ok(ExpressionBuilder(
        None,
        LoopBlock(outer_bt, [next_instruction, ..outer_instructions]),
        next_stack,
      ))

    [InlineBlock(outer_bt, outer_instructions), ..next_stack] ->
      Ok(ExpressionBuilder(
        None,
        InlineBlock(outer_bt, [next_instruction, ..outer_instructions]),
        next_stack,
      ))
    _ -> Error("Stack state underflow")
  }
}

pub fn push(builder: ExpressionBuilder, inst: Instruction) {
  case builder.top {
    OuterMostBlock(instructions) ->
      ExpressionBuilder(
        None,
        OuterMostBlock([inst, ..instructions]),
        builder.block_stack,
      )
    IfBlock(bt, instructions) ->
      ExpressionBuilder(
        None,
        IfBlock(bt, [inst, ..instructions]),
        builder.block_stack,
      )
    ElseBlock(bt, if_instructions, else_instructions) ->
      ExpressionBuilder(
        None,
        ElseBlock(bt, if_instructions, else_instructions |> list.append([inst])),
        builder.block_stack,
      )
    LoopBlock(bt, instructions) ->
      ExpressionBuilder(
        None,
        LoopBlock(bt, [inst, ..instructions]),
        builder.block_stack,
      )
    InlineBlock(bt, instructions) ->
      ExpressionBuilder(
        None,
        InlineBlock(bt, [inst, ..instructions]),
        builder.block_stack,
      )
    _ -> panic as "Expression completed, cannot push instruction"
  }
}

pub fn end_unwrap(builder) {
  case builder {
    ExpressionBuilder(None, OuterMostBlock(instructions), stack) if stack == [] ->
      Expr(instructions |> list.reverse)
    _ -> panic as "Unable to unwrap, invalid expression state"
  }
}
