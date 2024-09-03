import builder/expression_builder.{type ExpressionBuilder}
import internal/structure/types.{
  type DataIDX, MemoryCopy, MemoryFill, MemoryGrow, MemoryInit, MemorySize,
}

pub fn copy(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(MemoryCopy)
}

pub fn fill(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(MemoryFill)
}

pub fn grow(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(MemoryGrow)
}

pub fn init(builder: ExpressionBuilder, data_idx: DataIDX) {
  builder
  |> expression_builder.push(MemoryInit(data_idx))
}

pub fn size(builder: ExpressionBuilder) {
  builder
  |> expression_builder.push(MemorySize)
}
