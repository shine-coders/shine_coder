import gleam/bool
import gleam/option.{type Option, None, Some}
import gleam/result.{map}
import gleam/set.{type Set}
import internal/structure/modules.{type BinaryModule}
import internal/structure/numbers
import internal/structure/types.{
  type HeapType, type TypeIDX, ConcreteHeapType, RecTypeIDX, TypeIDX,
}
import visitor

pub type RecTypeContext =
  Option(#(BinaryModule, Int))

pub type EqualityElement {
  EqualityHeapType(heap_type1: HeapType, heap_type2: HeapType)
  EqualityTypeIDX(type_idx1: TypeIDX, type_idx2: TypeIDX)
}

pub fn heap_types_equal(
  heap_type1: HeapType,
  heap_type2: HeapType,
  cache: Set(EqualityElement),
  rec_type_context: RecTypeContext,
) {
  use <- bool.guard(heap_type1 == heap_type2, Ok(Nil))
  use <- bool.guard(
    cache |> set.contains(EqualityHeapType(heap_type1, heap_type2)),
    Ok(Nil),
  )
  case heap_type1, heap_type2 {
    ConcreteHeapType(type_idx1), ConcreteHeapType(type_idx2) ->
      type_indexes_equal(
        type_idx1,
        type_idx2,
        cache |> set.insert(EqualityHeapType(heap_type1, heap_type2)),
        rec_type_context,
      )
    _, _ -> Error("Heap types are not equal")
  }
}

pub fn unroll_type_idx(start: Int, index: TypeIDX) {
  case index {
    RecTypeIDX(rec_type_idx) -> {
      let rec_type_idx = numbers.unwrap_u32(rec_type_idx)
      use type_idx <- map(numbers.u32(rec_type_idx + start))
      TypeIDX(type_idx)
    }
    _ -> Ok(index)
  }
}

pub fn type_indexes_equal(
  type_idx1: TypeIDX,
  type_idx2: TypeIDX,
  cache: Set(EqualityElement),
  rec_type_context: RecTypeContext,
) {
  use <- bool.guard(type_idx1 == type_idx2, Ok(Nil))
  use <- bool.guard(
    cache |> set.contains(EqualityTypeIDX(type_idx1, type_idx2)),
    Ok(Nil),
  )
  case type_idx1, type_idx2, rec_type_context {
    _, _, None -> Error("Type indexes are not equal")
    a, b, Some(#(_, index)) -> {
      visitor.empty_visitor
      |> visitor.on_enter_type_idx(unroll_type_idx)
      |> visitor.visit_type_idx()
    }
  }
}
