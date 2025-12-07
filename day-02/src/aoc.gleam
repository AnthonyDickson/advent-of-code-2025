import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() -> Int {
  case get_parsed_input() {
    Ok(parsed) -> {
      parsed
      |> solve_part_one
      |> int.to_string
      |> io.println

      parsed
      |> solve_part_two
      |> int.to_string
      |> io.println

      0
    }
    Error(FileError(error)) -> {
      io.println_error(
        "Could not load \"input.txt\": " <> simplifile.describe_error(error),
      )
      1
    }
    Error(NotAPairError(pair_string)) -> {
      io.println_error("Got a bad pair string: " <> pair_string)
      1
    }
    Error(IntParseError(num_string)) -> {
      io.println_error("Got a bad integer string: " <> num_string)
      1
    }
  }
}

fn get_parsed_input() -> Result(List(Range), Error) {
  case simplifile.read("input.txt") {
    Ok(input) -> {
      parse_input(input)
    }
    Error(error) -> Error(FileError(error))
  }
}

pub type Range {
  Range(start: Int, end: Int)
}

pub fn range_to_string(range: Range) -> String {
  let Range(start, end) = range
  int.to_string(start) <> "-" <> int.to_string(end)
}

pub type Error {
  FileError(simplifile.FileError)
  IntParseError(String)
  NotAPairError(String)
}

pub fn parse_input(input: String) -> Result(List(Range), Error) {
  input
  |> string.split(on: ",")
  |> list.map(with: parse_range_string)
  |> result.all
}

fn parse_range_string(pair_string: String) -> Result(Range, Error) {
  case string.split(pair_string, on: "-") {
    [first, second] -> {
      use start <- result.try(result.replace_error(
        int.parse(first),
        IntParseError(first),
      ))
      use end <- result.try(result.replace_error(
        int.parse(second),
        IntParseError(second),
      ))
      Ok(Range(start, end))
    }
    _ -> Error(NotAPairError(pair_string))
  }
}

pub fn solve_part_one(ranges: List(Range)) -> Int {
  ranges
  |> list.map(with: get_invalid_ids)
  |> list.fold(0, fn(acc, x) { acc + int.sum(x) })
}

pub fn get_invalid_ids(range: Range) -> List(Int) {
  let Range(start, end) = range
  list.range(start, end)
  |> list.filter(is_repeating)
}

fn is_repeating(num: Int) -> Bool {
  let num_as_string = int.to_string(num)
  let len = string.length(num_as_string)
  case int.is_odd(len) {
    True -> False
    False -> {
      let #(first_half, last_half) =
        num_as_string
        |> string.to_graphemes
        |> list.split(len / 2)
      first_half == last_half
    }
  }
}

pub fn solve_part_two(_ranges: List(Range)) -> Int {
  0
}
