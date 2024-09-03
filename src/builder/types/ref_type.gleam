import internal/structure/types.{
  type HeapType, type RefType, AnyRefType, ArrayRefType, EqRefType,
  ExternRefType, FuncRefType, HeapTypeRefType, I31RefType, NoExternRefType,
  NoFuncRefType, NoneRefType, StructRefType,
}

pub fn from_heap_type(heap_type: HeapType, nullable: Bool) -> RefType {
  HeapTypeRefType(heap_type, nullable)
}

/// Shorthand for (ref null Any)
pub const any = AnyRefType

/// Shorthand for (ref null Eq)
pub const eq = EqRefType

/// Shorthand for (ref null I31)
pub const i31 = I31RefType

/// Shorthand for (ref null Struct)
pub const struct = StructRefType

/// Shorthand for (ref null Array)
pub const array = ArrayRefType

/// Shorthand for (ref null Func)
pub const func = FuncRefType

/// Shorthand for (ref null Extern)
pub const extern = ExternRefType

/// Shorthand for (ref null None)
pub const none = NoneRefType

/// Shorthand for (ref null NoFunc)
pub const no_func = NoFuncRefType

/// Shorthand for (ref null NoExtern)
pub const no_extern = NoExternRefType
