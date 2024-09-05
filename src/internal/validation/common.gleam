import gleam/option.{type Option, None}
import internal/finger_tree.{type FingerTree}
import internal/structure/types.{
  type Data, type DefType, type Elem, type FuncIDX, type GlobalType, type Locals,
  type MemType, type RecType, type TableType, type ValType,
}

pub type Context {
  Context(
    types: FingerTree(DefType),
    funcs: FingerTree(DefType),
    tables: FingerTree(TableType),
    mems: FingerTree(MemType),
    globals: FingerTree(GlobalType),
    elems: FingerTree(Elem),
    data: FingerTree(Data),
    locals: FingerTree(Locals),
    labels: FingerTree(FingerTree(ValType)),
    return: Option(FingerTree(ValType)),
    refs: FingerTree(FuncIDX),
  )
}

pub const empty_context = Context(
  types: finger_tree.empty,
  funcs: finger_tree.empty,
  tables: finger_tree.empty,
  mems: finger_tree.empty,
  globals: finger_tree.empty,
  elems: finger_tree.empty,
  data: finger_tree.empty,
  locals: finger_tree.empty,
  labels: finger_tree.empty,
  return: None,
  refs: finger_tree.empty,
)

pub fn roll_rec_types(rec_type: RecType) -> FingerTree(DefType) {
  todo
}
