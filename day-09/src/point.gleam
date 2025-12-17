import gleam/int
import gleam/string

pub type Point {
  Point(x: Int, y: Int)
}

pub fn parse(str: String) -> Point {
  let assert Ok(#(a, b)) = string.split_once(str, ",")
  let assert Ok(x) = int.parse(a)
  let assert Ok(y) = int.parse(b)
  Point(x, y)
}

pub fn to_string(p: Point) {
  "(" <> int.to_string(p.x) <> ", " <> int.to_string(p.y) <> ")"
}

pub fn area(a: Point, b: Point) -> Int {
  let height = 1 + int.absolute_value(a.x - b.x)
  let width = 1 + int.absolute_value(a.y - b.y)
  height * width
}
