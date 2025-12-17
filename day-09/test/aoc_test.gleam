import aoc
import gleam/list
import gleam/string
import gleeunit
import point.{Point}

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_points_test() {
  let input =
    string.join(
      ["7,1", "11,1", "11,7", "9,7", "9,5", "2,5", "2,3", "7,3\n"],
      "\n",
    )
  let expected = [
    Point(7, 1),
    Point(11, 1),
    Point(11, 7),
    Point(9, 7),
    Point(9, 5),
    Point(2, 5),
    Point(2, 3),
    Point(7, 3),
  ]

  let actual = aoc.parse_input(input)

  assert actual == expected
}

pub fn area_test() {
  let cases = [
    #(Point(2, 5), Point(9, 7), 24),
    #(Point(7, 1), Point(11, 7), 35),
    #(Point(7, 3), Point(2, 3), 6),
    #(Point(2, 5), Point(11, 1), 50),
  ]

  list.each(cases, fn(case_) {
    let #(a, b, expected) = case_
    let actual = point.area(a, b)

    assert actual == expected
      as {
        "Failed on input: " <> point.to_string(a) <> ", " <> point.to_string(b)
      }
  })
}

pub fn part_one_test() {
  let input = [
    Point(7, 1),
    Point(11, 1),
    Point(11, 7),
    Point(9, 7),
    Point(9, 5),
    Point(2, 5),
    Point(2, 3),
    Point(7, 3),
  ]
  let expected = 50
  let actual = aoc.solve_part_one(input)

  assert actual == expected
}

pub fn part_two_test() {
  let input = ""
  let solution = aoc.solve_part_two(input)

  assert solution == 0
}
