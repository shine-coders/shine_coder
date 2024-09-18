import gleam/list
import gleam/option.{None, Some}
import gleam/result
import internal/structure/modules.{type BinaryModule, TypeSection}
import internal/structure/types.{type RecType}
import internal/validation/common.{
  type Context, Context, empty_context, roll_rec_types,
}
import internal/validation/types.{rec_type_is_valid} as _validation_types

pub fn validate_type(ctx_prime: Context, rec_type: RecType) {
  let def_types = rec_type |> roll_rec_types
  let ctx = Context(..ctx_prime, types: list.append(ctx_prime.types, def_types))
  use _ <- result.map(rec_type_is_valid(ctx, rec_type))
  ctx
}

pub fn validate_module(module: BinaryModule) {
  use context <- result.try(case module.types {
    Some(TypeSection(types)) ->
      list.try_fold(types, empty_context, validate_type)
    None -> Ok(empty_context)
  })

  Ok(context)
}
