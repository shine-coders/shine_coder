import builder/expression_builder.{type ExpressionBuilder}
import internal/structure/types.{type LocalIDX, LocalGet, LocalSet, LocalTee}

pub fn get(builder: ExpressionBuilder, local_idx: LocalIDX) {
  builder
  |> expression_builder.push(LocalGet(local_idx))
}

pub fn set(builder: ExpressionBuilder, local_idx: LocalIDX) {
  builder
  |> expression_builder.push(LocalSet(local_idx))
}

pub fn tee(builder: ExpressionBuilder, local_idx: LocalIDX) {
  builder
  |> expression_builder.push(LocalTee(local_idx))
}
