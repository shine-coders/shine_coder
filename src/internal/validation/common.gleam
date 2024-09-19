import gleam/int
import gleamy/red_black_tree_map.{type Map}
import internal/structure/numbers
import internal/structure/types.{
  type DefType, type RecType, type SubType, type TypeIDX, DefType, TypeIDX,
}
import shine_tree.{type ShineTree}

pub type TypeEntry {
  TypeEntry(
    type_idx: Int,
    def_type: DefType,
    rec_type: RecType,
    sub_type: SubType,
    rec_type_idx: Int,
  )
}

pub type Context {
  Context(types_length: Int, types: Map(TypeIDX, TypeEntry))
}

fn compare_type_idx(type_idx_a: TypeIDX, type_idx_b: TypeIDX) {
  let TypeIDX(type_idx_a) = type_idx_a
  let TypeIDX(type_idx_b) = type_idx_b
  let type_idx_a = numbers.unwrap_u32(type_idx_a)
  let type_idx_b = numbers.unwrap_u32(type_idx_b)
  int.compare(type_idx_a, type_idx_b)
}

pub fn new_context(rec_types: List(RecType)) {
  do_new_context(
    rec_types,
    0,
    Context(0, red_black_tree_map.new(compare_type_idx)),
  )
}

fn do_new_context(rec_types: List(RecType), type_idx: Int, acc: Context) {
  case rec_types {
    [] -> acc
    [rec_type, ..rec_types] ->
      do_new_sub_types(
        rec_type.sub_types,
        rec_type,
        rec_types,
        type_idx,
        0,
        acc,
      )
  }
}

fn do_new_sub_types(
  sub_types: List(SubType),
  rec_type: RecType,
  rec_types: List(RecType),
  type_idx: Int,
  rec_type_idx: Int,
  acc: Context,
) {
  case sub_types {
    [] -> do_new_context(rec_types, type_idx, acc)
    [sub_type, ..sub_types] -> {
      let assert Ok(type_idx_key) = numbers.u32(type_idx)

      do_new_sub_types(
        sub_types,
        rec_type,
        rec_types,
        type_idx + 1,
        rec_type_idx + 1,
        Context(
          types_length: acc.types_length + 1,
          types: red_black_tree_map.insert(
            acc.types,
            TypeIDX(type_idx_key),
            TypeEntry(
              type_idx,
              DefType(rec_type, rec_type_idx),
              rec_type,
              sub_type,
              rec_type_idx,
            ),
          ),
        ),
      )
    }
  }
}
