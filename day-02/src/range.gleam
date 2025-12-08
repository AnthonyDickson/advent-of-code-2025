import gleam/int

pub type Range {
  Range(start: Int, end: Int)
}

pub fn to_string(range: Range) -> String {
  let Range(start, end) = range
  int.to_string(start) <> "-" <> int.to_string(end)
}
