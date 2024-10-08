import internal/structure/types.{
  type TypeIDX, AnyHeapType, ArrayHeapType, BotHeapType, ConcreteHeapType,
  EqHeapType, ExternHeapType, FuncHeapType, I31HeapType, NoExternHeapType,
  NoFuncHeapType, NoneHeapType, StructHeapType,
}

pub const func = FuncHeapType

pub const no_func = NoFuncHeapType

pub const extern = ExternHeapType

pub const no_extern = NoExternHeapType

pub const any = AnyHeapType

pub const eq = EqHeapType

pub const i31 = I31HeapType

pub const struct = StructHeapType

pub const array = ArrayHeapType

pub const none = NoneHeapType

pub const bot = BotHeapType

pub fn from_type_index(idx: TypeIDX) {
  ConcreteHeapType(idx)
}
