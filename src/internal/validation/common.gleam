import gleam/dict.{type Dict}
import gleam/list
import internal/structure/numbers.{type U32}
import internal/structure/types.{
  type Data, type DefType, type Elem, type FuncIDX, type GlobalType, type Locals,
  type MemType, type RecType, type TableType, type ValType,
}

pub type Context {
  Context(types: List(DefType))
}

pub const empty_context = Context(types: [])

pub fn get_def_type(ctx: Context, idx: U32) {
  let idx = numbers.unwrap_u32(idx)
  case list.drop(ctx.types, idx) {
    [def_type, ..] -> Ok(def_type)
    _ -> Error("Invalid TypeIDX")
  }
}

pub fn roll_rec_type(ctx: Context, rec_type: RecType) {
  todo
}
