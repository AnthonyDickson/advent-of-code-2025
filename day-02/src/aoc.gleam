import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

import range.{type Range, Range}
import solution.{solve_part_one, solve_part_two}

pub fn main() {
  let input_result =
    simplifile.read("input.txt")
    |> result.map_error(FileError)
    |> result.try(parse_input)

  case input_result {
    Ok(parsed) -> {
      parsed
      |> solve_part_one
      |> int.to_string
      |> io.println

      parsed
      |> solve_part_two
      |> int.to_string
      |> io.println
    }
    Error(FileError(error)) -> {
      io.println_error(
        "Could not load \"input.txt\": " <> simplifile.describe_error(error),
      )
    }
    Error(NotAPairError(pair_string)) -> {
      io.println_error("Got a bad pair string: " <> pair_string)
    }
    Error(IntParseError(num_string)) -> {
      io.println_error("Got a bad integer string: " <> num_string)
    }
  }
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
  let parse_int = fn(int_string) {
    int.parse(int_string)
    |> result.replace_error(IntParseError(int_string))
  }

  let parts =
    pair_string
    |> string.trim_end
    |> string.split("-")

  case parts {
    [first, second] -> {
      use start <- result.try(parse_int(first))
      use end <- result.try(parse_int(second))
      Ok(Range(start, end))
    }
    _ -> Error(NotAPairError(pair_string))
  }
}
