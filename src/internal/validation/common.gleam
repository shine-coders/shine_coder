import gleam/option.{type Option, None}
import internal/structure/types.{
  type Data, type DefType, type Elem, type FuncIDX, type GlobalType, type Locals,
  type MemType, type RecType, type TableType, type ValType,
}
import shine_tree.{type ShineTree}

pub type Context {
  Context(
    types: ShineTree(DefType),
    funcs: ShineTree(DefType),
    tables: ShineTree(TableType),
    mems: ShineTree(MemType),
    globals: ShineTree(GlobalType),
    elems: ShineTree(Elem),
    data: ShineTree(Data),
    locals: ShineTree(Locals),
    labels: ShineTree(ShineTree(ValType)),
    return: Option(ShineTree(ValType)),
    refs: ShineTree(FuncIDX),
  )
}

pub const empty_context = Context(
  types: shine_tree.empty,
  funcs: shine_tree.empty,
  tables: shine_tree.empty,
  mems: shine_tree.empty,
  globals: shine_tree.empty,
  elems: shine_tree.empty,
  data: shine_tree.empty,
  locals: shine_tree.empty,
  labels: shine_tree.empty,
  return: None,
  refs: shine_tree.empty,
)

pub fn roll_rec_types(rec_type: RecType) -> ShineTree(DefType) {
  todo
}
