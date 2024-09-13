import gleam/option.{type Option, None, Some}
import gleeunit/should
import shine_tree
import visitor.{type BinaryModuleVisitor}

type VisitCallback(u) =
  fn(VisitorContext, u) -> Result(#(VisitorContext, u), String)

type VisitorContext =
  #(Int, Int, Int, Int)

type VisitorEventCallback(u) =
  fn(BinaryModuleVisitor(VisitorContext), VisitCallback(u)) ->
    BinaryModuleVisitor(VisitorContext)

type DoVisitCallback(u) =
  fn(BinaryModuleVisitor(VisitorContext), VisitorContext, u) ->
    Result(#(VisitorContext, u), String)

pub fn run(
  expected_value: u,
  on_enter_type: VisitorEventCallback(u),
  on_exit_type: VisitorEventCallback(u),
  on_enter_variant: VisitorEventCallback(u),
  on_exit_variant: VisitorEventCallback(u),
  visit_func: DoVisitCallback(u),
  equality_callback: Option(fn(u, u) -> Bool),
) {
  let start_context = #(0, 0, 0, 0)
  let expected_context = #(1, 1, 1, 1)
  let #(actual_context, actual_value) =
    visitor.new()
    |> on_enter_type(fn(ctx, actual_value) {
      case actual_value == expected_value {
        True -> {
          let #(a, b, c, d) = ctx
          Ok(#(#(a + 1, b, c, d), actual_value))
        }
        False -> Ok(#(ctx, actual_value))
      }
    })
    |> on_exit_type(fn(ctx, actual_value) {
      case actual_value == expected_value {
        True -> {
          let #(a, b, c, d) = ctx
          Ok(#(#(a, b + 1, c, d), actual_value))
        }
        False -> Ok(#(ctx, actual_value))
      }
    })
    |> on_enter_variant(fn(ctx, actual_value) {
      case actual_value == expected_value {
        True -> {
          let #(a, b, c, d) = ctx
          Ok(#(#(a, b, c + 1, d), actual_value))
        }
        False -> Ok(#(ctx, actual_value))
      }
    })
    |> on_exit_variant(fn(ctx, actual_value) {
      case actual_value == expected_value {
        True -> {
          let #(a, b, c, d) = ctx
          Ok(#(#(a, b, c, d + 1), actual_value))
        }
        False -> Ok(#(ctx, actual_value))
      }
    })
    |> visit_func(start_context, expected_value)
    |> should.be_ok

  actual_context
  |> should.equal(expected_context)

  case equality_callback {
    Some(equality_callback) ->
      equality_callback(expected_value, actual_value)
      |> should.be_true
    None ->
      { expected_value == actual_value }
      |> should.be_true
  }
}
