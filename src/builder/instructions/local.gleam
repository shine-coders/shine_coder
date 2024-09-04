import builder/expression.{type ExpressionBuilder}
import internal/structure/types.{type LocalIDX, LocalGet, LocalSet, LocalTee}

pub fn get(builder: ExpressionBuilder, local_idx: LocalIDX) {
  builder
  |> expression.push(LocalGet(local_idx))
}

pub fn set(builder: ExpressionBuilder, local_idx: LocalIDX) {
  builder
  |> expression.push(LocalSet(local_idx))
}

pub fn tee(builder: ExpressionBuilder, local_idx: LocalIDX) {
  builder
  |> expression.push(LocalTee(local_idx))
}
