import builder/expression.{type ExpressionBuilder}
import internal/structure/types.{
  type DataIDX, MemoryCopy, MemoryFill, MemoryGrow, MemoryInit, MemorySize,
}

pub fn copy(builder: ExpressionBuilder) {
  builder
  |> expression.push(MemoryCopy)
}

pub fn fill(builder: ExpressionBuilder) {
  builder
  |> expression.push(MemoryFill)
}

pub fn grow(builder: ExpressionBuilder) {
  builder
  |> expression.push(MemoryGrow)
}

pub fn init(builder: ExpressionBuilder, data_idx: DataIDX) {
  builder
  |> expression.push(MemoryInit(data_idx))
}

pub fn size(builder: ExpressionBuilder) {
  builder
  |> expression.push(MemorySize)
}
