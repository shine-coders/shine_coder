import gleam/option.{type Option, None}
import internal/structure/types.{
  type Data, type DefType, type Elem, type FuncIDX, type GlobalType, type Locals,
  type MemType, type RecType, type TableType, type ValType,
}

pub type Context {
  Context(
    types: List(DefType),
    funcs: List(DefType),
    tables: List(TableType),
    mems: List(MemType),
    globals: List(GlobalType),
    elems: List(Elem),
    data: List(Data),
    locals: List(Locals),
    labels: List(List(ValType)),
    return: Option(List(ValType)),
    refs: List(FuncIDX),
  )
}

pub const empty_context = Context(
  types: [],
  funcs: [],
  tables: [],
  mems: [],
  globals: [],
  elems: [],
  data: [],
  locals: [],
  labels: [],
  return: None,
  refs: [],
)

pub fn roll_rec_types(rec_type: RecType) -> List(DefType) {
  todo
}
