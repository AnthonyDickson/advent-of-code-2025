import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import simplifile

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

pub fn solve_part_one(ranges: List(Range)) -> Int {
  ranges
  |> list.flat_map(get_invalid_ids)
  |> int.sum
}

pub fn get_invalid_ids(range: Range) -> List(Int) {
  let Range(start, end) = range
  let start_digit_count = count_digits(start)
  let end_digit_count = count_digits(end)
  let #(start_split_index, end_split_index) = case
    int.is_even(start_digit_count),
    int.is_even(end_digit_count)
  {
    // This handles cases like Range(9_999, 12_345) which would otherwise result
    // in a range start and end of 99 and 12 when we actually want 99 and 123
    True, False -> #(start_digit_count / 2, end_digit_count / 2 + 1)
    _, _ -> #(start_digit_count / 2, end_digit_count / 2)
  }

  list.range(
    split_num(start, start_split_index),
    split_num(end, end_split_index),
  )
  |> list.map(fn(num) {
    num
    |> int.to_string
    |> string.repeat(2)
    |> int.parse
    // Since we started with a valid integer, we should never get the default?
    |> result.unwrap(0)
  })
  |> list.filter(fn(x) { x >= start && x <= end })
}

fn split_num(num, index) -> Int {
  num
  |> int.to_string
  |> string.to_graphemes
  |> list.split(index)
  |> pair.first
  |> string.join("")
  |> int.parse
  // Since we started with a valid integer, we should never get the default?
  |> result.unwrap(0)
}

const ln_10 = 2.30258509299

pub fn count_digits(num: Int) -> Int {
  float.logarithm(int.to_float(num))
  |> result.try(float.divide(_, ln_10))
  |> result.map(float.truncate)
  |> result.map(int.add(_, 1))
  // Backup in case the above fails for some reason
  |> result.lazy_unwrap(fn() { num |> int.to_string |> string.length })
}

pub fn solve_part_two(_ranges: List(Range)) -> Int {
  // for all substring lengths up to half of the length of the range start to the range end
  // if substring length % length(start) != 0
  //   skip
  // else
  //   gen all repeating digit sequences from (start[:substring length] as int) to (end[:substring length] as int)
  0
}
