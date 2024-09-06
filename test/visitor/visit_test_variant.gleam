import gleeunit/should
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
) {
  let start_context = #(0, 0, 0, 0)
  let expected_context = #(1, 1, 1, 1)
  visitor.new()
  |> on_enter_type(fn(ctx, actual_value) {
    let #(a, b, c, d) = ctx
    actual_value |> should.equal(expected_value)
    Ok(#(#(a + 1, b, c, d), actual_value))
  })
  |> on_exit_type(fn(ctx, actual_value) {
    let #(a, b, c, d) = ctx
    actual_value |> should.equal(expected_value)
    Ok(#(#(a, b + 1, c, d), actual_value))
  })
  |> on_enter_variant(fn(ctx, actual_value) {
    let #(a, b, c, d) = ctx
    actual_value |> should.equal(expected_value)
    Ok(#(#(a, b, c + 1, d), actual_value))
  })
  |> on_exit_variant(fn(ctx, actual_value) {
    let #(a, b, c, d) = ctx
    actual_value |> should.equal(expected_value)
    Ok(#(#(a, b, c, d + 1), actual_value))
  })
  |> visit_func(start_context, expected_value)
  |> should.be_ok
  |> should.equal(#(expected_context, expected_value))
}
