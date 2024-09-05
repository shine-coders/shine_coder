import internal/structure/types.{
  type BlockType, type TypeIDX, type ValType, FuncTypeBlockType,
  ValTypeBlockType, VoidBlockType,
}

pub const void = VoidBlockType

pub fn val_type(vt: ValType) {
  ValTypeBlockType(vt)
}

pub fn func_type(idx: TypeIDX) {
  FuncTypeBlockType(idx)
}
