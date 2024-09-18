import gleam/list
import gleam/option.{type Option, None, Some}
import internal/structure/modules
import internal/structure/numbers
import internal/structure/types.{
  type DefType, type ExternType, type Global, type GlobalType, type Limits,
  type MemType, type RecType, type RefType, type Table, type TableType,
  type ValType, FuncCompositeType, FuncExternType, GlobalExternType,
  HeapTypeRefType, Limits, MemExternType, RefTypeValType, TableExternType,
}
import internal/validation/common.{type Context}

const limits_2_16 = 65_536

const limits_2_32_minus_1 = 4_294_967_295

pub fn expand(_: Context, def_type: DefType) {
  let sub_types = def_type.rt.sub_types
  let index = def_type.idx
  case list.drop(sub_types, index) {
    [] -> Error("Invalid DefType: RecType index out of bounds.")
    [sub_type, ..] -> Ok(sub_type.ct)
  }
}

pub fn def_type_is_function_type(ctx: Context, def_type: DefType) {
  case expand(ctx, def_type) {
    Ok(FuncCompositeType(_)) -> True
    _ -> False
  }
}

pub fn is_defaultable(val_type: ValType) {
  case val_type {
    RefTypeValType(HeapTypeRefType(_, False)) -> False
    _ -> True
  }
}

pub fn extern_type_is_valid(ctx: Context, extern_type: ExternType) {
  case extern_type {
    FuncExternType(def_type) ->
      def_type_is_valid(ctx, def_type)
      && def_type_is_function_type(ctx, def_type)
    TableExternType(table_type) -> table_type_is_valid(ctx, table_type)
    MemExternType(mem_type) -> mem_type_is_valid(ctx, mem_type)
    GlobalExternType(global_type) -> global_type_is_valid(ctx, global_type)
  }
}

pub fn global_is_valid(ctx: Context, global: Global) {
  global_type_is_valid(ctx, global.type_)
}

pub fn global_type_is_valid(ctx: Context, global_type: GlobalType) {
  val_type_is_valid(ctx, global_type.vt)
}

pub fn val_type_is_valid(ctx: Context, val_type: ValType) {
  todo
}

pub fn mem_type_is_valid(ctx: Context, mem_type: MemType) {
  limits_is_valid(ctx, mem_type.limits, limits_2_16)
}

pub fn limits_is_valid(_: Context, limits: Limits, range: Int) {
  case limits {
    Limits(n, None) -> {
      let n = numbers.unwrap_u32(n)
      n <= range
    }
    Limits(n, Some(m)) -> {
      let n = numbers.unwrap_u32(n)
      let m = numbers.unwrap_u32(m)
      n <= range && m <= range && n <= m
    }
  }
}

pub fn table_is_valid(ctx: Context, table: Table) {
  table_type_is_valid(ctx, table.type_)
}

pub fn table_type_is_valid(ctx: Context, table_type: TableType) {
  ref_type_is_valid(ctx, table_type.t)
  && limits_is_valid(ctx, table_type.limits, limits_2_32_minus_1)
}

pub fn def_type_is_valid(ctx: Context, def_type: DefType) {
  todo
}

pub fn ref_type_is_valid(ctx: Context, ref_type: RefType) {
  todo
}

pub fn rec_type_is_valid(ctx: Context, rec_type: RecType) {
  todo
}
