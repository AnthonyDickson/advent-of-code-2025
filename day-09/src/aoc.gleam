import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/result
import gleam/string
import point.{type Point}
import simplifile

pub fn main() {
  case simplifile.read("input.txt") {
    Ok(input) -> {
      let points = parse_input(input)

      points
      |> solve_part_one
      |> int.to_string
      |> io.println

      input
      |> solve_part_two
      |> int.to_string
      |> io.println
    }
    Error(error) -> {
      io.println_error(
        "Could not load \"input.txt\": " <> simplifile.describe_error(error),
      )
    }
  }
}

pub fn parse_input(file_contents: String) -> List(Point) {
  file_contents
  |> string.trim_end
  |> string.split("\n")
  |> list.map(point.parse)
}

pub fn solve_part_one(points: List(Point)) -> Int {
  let area_of_points = fn(points_tuple: #(Point, Point)) -> Int {
    point.area(points_tuple.0, points_tuple.1)
  }

  let sort_decreasing_area = fn(a, b) { int.compare(a, b) |> order.negate }

  points
  |> list.combination_pairs
  |> list.map(area_of_points)
  |> list.sort(sort_decreasing_area)
  |> list.first
  |> result.unwrap(0)
}

pub fn solve_part_two(_input: String) -> Int {
  0
}
