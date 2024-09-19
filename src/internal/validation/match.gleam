import internal/structure/types.{
  type ArrayType, type CompositeType, type DefType, type FieldType,
  type FuncType, type HeapType, type RefType, type StorageType, type StructType,
  type ValType, AnyHeapType, AnyRefType, ArrayCompositeType, ArrayHeapType,
  ArrayRefType, ArrayType, BotHeapType, BotValType, ConcreteHeapType, Const,
  EqHeapType, EqRefType, ExternHeapType, ExternRefType, FieldType,
  FuncCompositeType, FuncHeapType, FuncRefType, FuncType, HeapTypeRefType,
  I31HeapType, I31RefType, NoExternHeapType, NoExternRefType, NoFuncHeapType,
  NoFuncRefType, NoneHeapType, NoneRefType, RefTypeValType, StructCompositeType,
  StructHeapType, StructRefType, StructType, SubType, TypeIDX,
  ValTypeStorageType, Var,
}

import internal/validation/common.{type Context}

pub fn matches_val_type(ctx: Context, val_type_1: ValType, val_type_2: ValType) {
  case val_type_1, val_type_2 {
    BotValType, _ -> True
    val_type_1, val_type_2 if val_type_1 == val_type_2 -> True
    RefTypeValType(ref_type_1), RefTypeValType(ref_type_2) ->
      matches_ref_type(ctx, ref_type_1, ref_type_2)
    _, _ -> False
  }
}

fn resolve_ref_type(ref_type: RefType) {
  case ref_type {
    HeapTypeRefType(heap_type, nullable) -> #(heap_type, nullable)
    AnyRefType -> #(AnyHeapType, True)
    EqRefType -> #(EqHeapType, True)
    I31RefType -> #(I31HeapType, True)
    StructRefType -> #(StructHeapType, True)
    ArrayRefType -> #(ArrayHeapType, True)
    FuncRefType -> #(FuncHeapType, True)
    ExternRefType -> #(ExternHeapType, True)
    NoneRefType -> #(NoneHeapType, True)
    NoFuncRefType -> #(NoFuncHeapType, True)
    NoExternRefType -> #(NoExternHeapType, True)
  }
}

pub fn matches_ref_type(ctx: Context, ref_type_1: RefType, ref_type_2) {
  case resolve_ref_type(ref_type_1), resolve_ref_type(ref_type_2) {
    ref_type_1, ref_type_2 if ref_type_1 == ref_type_2 -> True
    #(heap_type_1, False), #(heap_type_2, _)
    | #(heap_type_1, _), #(heap_type_2, True)
    -> matches_heap_type(ctx, heap_type_1, heap_type_2)
    _, _ -> False
  }
}

pub fn matches_heap_type(
  ctx: Context,
  heap_type_1: HeapType,
  heap_type_2: HeapType,
) {
  case heap_type_1, heap_type_2 {
    heap_type_1, heap_type_2 if heap_type_1 == heap_type_2 -> True
    BotHeapType, _
    | EqHeapType, AnyHeapType
    | I31HeapType, EqHeapType
    | StructHeapType, EqHeapType
    | ArrayHeapType, EqHeapType
    -> True

    // TODO: Fix how type indices are matched
    // ConcreteHeapType(DefTypeReference(def_type_1)),
    //   ConcreteHeapType(DefTypeReference(def_type_2))
    // -> matches_def_type(ctx, def_type_1, def_type_2)
    // ConcreteHeapType(DefTypeReference(def_type)), heap_type_2 -> {
    //   case types.def_type_expand(def_type), heap_type_2 {
    //     Ok(FuncCompositeType(_)), FuncHeapType
    //     | Ok(StructCompositeType(_)), StructHeapType
    //     | Ok(ArrayCompositeType(_)), ArrayHeapType
    //     -> True
    //     _, _ -> False
    //   }
    // }
    // ConcreteHeapType(TypeIDX(idx)), heap_type_2 ->
    //   case common.get_def_type(ctx, idx) {
    //     Ok(def_type) ->
    //       matches_heap_type(
    //         ctx,
    //         ConcreteHeapType(DefTypeReference(def_type)),
    //         heap_type_2,
    //       )
    //     _ -> False
    //   }
    // heap_type_1, ConcreteHeapType(TypeIDX(idx)) ->
    //   case common.get_def_type(ctx, idx) {
    //     Ok(def_type) ->
    //       matches_heap_type(
    //         ctx,
    //         heap_type_1,
    //         ConcreteHeapType(DefTypeReference(def_type)),
    //       )
    //     _ -> False
    //   }
    NoneHeapType, heap_type_2 ->
      matches_heap_type(ctx, heap_type_2, AnyHeapType)
    NoFuncHeapType, heap_type_2 ->
      matches_heap_type(ctx, heap_type_2, FuncHeapType)
    NoExternHeapType, heap_type_2 ->
      matches_heap_type(ctx, heap_type_2, ExternHeapType)

    // TODO: if heap_type_1 matches heap_type_prime and heap_type_prime matches
    //    heap_type_2
    _, _ -> False
  }
}

pub fn matches_result_type(
  ctx: Context,
  result_type_1: List(ValType),
  result_type_2: List(ValType),
) {
  case result_type_1, result_type_2 {
    [val_type_1, ..result_type_1], [val_type_2, ..result_type_2] ->
      matches_val_type(ctx, val_type_1, val_type_2)
      && matches_result_type(ctx, result_type_1, result_type_2)
    [], [] -> True
    _, _ -> False
  }
}

pub fn matches_func_type(
  ctx: Context,
  func_type_1: FuncType,
  func_type_2: FuncType,
) {
  let FuncType(parameters_1, results_1) = func_type_1
  let FuncType(parameters_2, results_2) = func_type_2

  case matches_result_type(ctx, parameters_1, parameters_2) {
    True -> matches_result_type(ctx, results_1, results_2)
    False -> False
  }
}

pub fn matches_composite_type(
  ctx: Context,
  composite_type_1: CompositeType,
  composite_type_2: CompositeType,
) {
  case composite_type_1, composite_type_2 {
    FuncCompositeType(func_type_1), FuncCompositeType(func_type_2) ->
      matches_func_type(ctx, func_type_1, func_type_2)
    StructCompositeType(struct_type_1), StructCompositeType(struct_type_2) ->
      matches_struct_type(ctx, struct_type_1, struct_type_2)
    ArrayCompositeType(array_type_1), ArrayCompositeType(array_type_2) ->
      matches_array_type(ctx, array_type_1, array_type_2)
    _, _ -> False
  }
}

pub fn matches_struct_type(
  ctx: Context,
  struct_type_1: StructType,
  struct_type_2: StructType,
) {
  let StructType(field_types_1) = struct_type_1
  let StructType(field_types_2) = struct_type_2
  matches_field_types(ctx, field_types_1, field_types_2)
}

pub fn matches_field_types(
  ctx: Context,
  field_types_1: List(FieldType),
  field_types_2: List(FieldType),
) {
  case field_types_1, field_types_2 {
    [], _ -> True
    [field_type_1, ..field_types_1], [field_type_2, ..field_types_2] ->
      matches_field_type(ctx, field_type_1, field_type_2)
      && matches_field_types(ctx, field_types_1, field_types_2)
    _, [] -> False
  }
}

pub fn matches_field_type(
  ctx: Context,
  field_type_1: FieldType,
  field_type_2: FieldType,
) {
  case field_type_1, field_type_2 {
    FieldType(storage_type_1, Const), FieldType(storage_type_2, Const) ->
      matches_storage_type(ctx, storage_type_1, storage_type_2)
    FieldType(storage_type_1, Var), FieldType(storage_type_2, Var) ->
      matches_storage_type(ctx, storage_type_1, storage_type_2)
      && matches_storage_type(ctx, storage_type_2, storage_type_1)
    _, _ -> False
  }
}

pub fn matches_storage_type(
  ctx: Context,
  storage_type_1: StorageType,
  storage_type_2: StorageType,
) {
  case storage_type_1, storage_type_2 {
    storage_type_1, storage_type_2 if storage_type_1 == storage_type_2 -> True
    ValTypeStorageType(val_type_1), ValTypeStorageType(val_type_2) ->
      matches_val_type(ctx, val_type_1, val_type_2)
    _, _ -> False
  }
}

pub fn matches_array_type(
  ctx: Context,
  array_type_1: ArrayType,
  array_type_2: ArrayType,
) {
  let ArrayType(field_type_1) = array_type_1
  let ArrayType(field_type_2) = array_type_2

  matches_field_type(ctx, field_type_1, field_type_2)
}

pub fn matches_def_type(ctx: Context, def_type_1: DefType, def_type_2: DefType) {
  todo
  // def_type_1 == def_type_2
  // || close_def_type(def_type_1) == close_def_type(def_type_2)
  // || {
  //   case unroll_def_type_to_sub_type(def_type_1) {
  //     Ok(SubType(final, matches, comp_type)) ->
  //       matches_any_heap_type(
  //         ctx,
  //         matches,
  //         ConcreteHeapType(DefTypeReference(def_type_2)),
  //       )
  //     Error(_) -> False
  //   }
  // }
}

fn matches_any_heap_type(
  ctx: Context,
  heap_types: List(HeapType),
  target_heap_type: HeapType,
) {
  case heap_types {
    [heap_type, ..heap_types] ->
      matches_heap_type(ctx, heap_type, target_heap_type)
      || matches_any_heap_type(ctx, heap_types, target_heap_type)
    [] -> False
  }
}
