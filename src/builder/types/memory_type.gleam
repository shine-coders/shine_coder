import gleam/option.{None, Some}
import internal/structure/numbers.{u32}
import internal/structure/types.{type MemType, Limits, MemType}

/// Create a new MemType with the given min value and max value set to None
pub fn new(min: Int) {
  let assert Ok(min) = u32(min)
  MemType(Limits(min, None))
}

/// Create a new MemType with the given min and max values
pub fn new_with_max(min: Int, max: Int) {
  let assert Ok(min) = u32(min)
  let assert Ok(max) = u32(max)
  MemType(Limits(min, Some(max)))
}
