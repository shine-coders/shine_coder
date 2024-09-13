import gleam/option.{type Option, None, Some}
import gleam/result
import internal/structure/modules.{type BinaryModule, TypeSection}
import internal/structure/types.{type RecType}
import internal/validation/common.{
  type Context, Context, empty_context, roll_rec_types,
}
import internal/validation/types.{validate_rec_type} as _validation_types
import shine_tree

pub fn validate_type(ctx_prime: Context, rec_type: RecType) {
  let def_types = rec_type |> roll_rec_types
  let ctx =
    Context(..ctx_prime, types: shine_tree.append(ctx_prime.types, def_types))
  use _ <- result.map(validate_rec_type(ctx, rec_type))
  ctx
}

pub fn validate_module(module: BinaryModule) {
  use context <- result.try(case module.types {
    Some(TypeSection(types)) ->
      shine_tree.try_foldl(types, empty_context, validate_type)
    None -> Ok(empty_context)
  })

  Ok(context)
}
