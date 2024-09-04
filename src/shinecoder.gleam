import builder/expression_builder
import builder/instructions/i32
import builder/instructions/local
import builder/module
import builder/types/rec_type
import builder/types/val_type

pub fn main() {
  let assert Ok(type_idx_0) = module.type_idx(0)
  let assert Ok(local_idx_0) = module.local_idx(0)
  let assert Ok(local_idx_1) = module.local_idx(1)

  module.new()
  |> module.add_type(
    rec_type.func_type([val_type.i32, val_type.i32], [val_type.i32]),
  )
  |> module.add_function_type(type_idx_0)
  |> module.add_code(
    [val_type.i32, val_type.i32],
    expression_builder.new()
      |> local.get(local_idx_0)
      |> local.get(local_idx_1)
      |> i32.add
      |> expression_builder.end_unwrap(),
  )
}
