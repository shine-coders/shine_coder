import builder/expression
import builder/instructions/i32
import builder/instructions/local
import builder/module
import builder/types/rec_type
import builder/types/val_type
import simplifile

pub fn main() {
  let assert Ok(type_idx_0) = module.type_idx(0)
  let assert Ok(local_idx_0) = module.local_idx(0)
  let assert Ok(local_idx_1) = module.local_idx(1)
  let assert Ok(func_idx_0) = module.func_idx(0)

  let assert Ok(add_module) =
    module.new()
    |> module.add_type(
      rec_type.func_type([val_type.i32, val_type.i32], [val_type.i32]),
    )
    |> module.append_function_type_index(type_idx_0)
    |> module.add_code(
      [val_type.i32, val_type.i32],
      expression.new()
        |> local.get(local_idx_0)
        |> local.get(local_idx_1)
        |> i32.add
        |> expression.end_unwrap(),
    )
    |> module.export_func("add", func_idx_0)
    |> module.encode

  let assert Ok(Nil) = simplifile.write_bits("shinecoder.wasm", add_module)
}
