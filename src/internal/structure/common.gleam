/// This method returns `True` if the value is between `range.0` inclusive and `range.1` inclusive
pub fn between(val: Int, range: #(Int, Int)) {
  val >= range.0 && val <= range.1
}
