import gleam/bool
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set
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
    take_digits(start, start_split_index),
    take_digits(end, end_split_index),
  )
  |> list.map(repeat_digits(_, 2))
  |> list.filter(fn(x) { x >= start && x <= end })
}

pub fn solve_part_two(ranges: List(Range)) -> Int {
  ranges
  |> list.flat_map(generate_invalid_ids)
  |> int.sum
}

pub fn generate_invalid_ids(range: Range) -> List(Int) {
  let len = count_digits(range.end)
  // This should not panic because the base is always positive
  let assert Ok(step) =
    float.power(10.0, int.to_float(len / 2)) |> result.map(float.truncate)

  make_range(range.start, range.end, step)
  |> list.flat_map(gen_seq)
  |> set.from_list
  |> set.to_list
  |> list.filter(fn(num) { range.start <= num && num <= range.end })
}

fn make_range(start, end, step) -> List(Int) {
  make_range_aux(start, end, step, [])
  |> list.reverse
}

fn make_range_aux(start, end, step, acc) -> List(Int) {
  use <- bool.guard(start > end, [start, ..acc])

  make_range_aux(start + step, end, step, [start, ..acc])
}

fn gen_seq(num: Int) -> List(Int) {
  use <- bool.guard(num < 10, [])
  let len = count_digits(num)

  list.range(1, len / 2)
  |> list.filter(fn(subseq_len) { len % subseq_len == 0 })
  |> list.map(fn(subseq_len) {
    let times = len / subseq_len
    let leading_digits = take_digits(num, subseq_len)
    repeat_digits(leading_digits, times)
  })
}

const ln_10 = 2.30258509299

/// Count the digits in a number
///
/// # Examples
///
/// ```gleam
/// count_digits(12345)
/// // -> 5
/// ```
pub fn count_digits(num: Int) -> Int {
  float.logarithm(int.to_float(num))
  |> result.try(float.divide(_, ln_10))
  |> result.map(float.truncate)
  |> result.map(int.add(_, 1))
  // Backup in case the above fails for some reason
  |> result.lazy_unwrap(fn() { num |> int.to_string |> string.length })
}

/// Take the first `n` digits of a number
///
/// # Examples
/// ```gleam
/// take_digits(12345, 2)
/// // -> 12
/// ```
fn take_digits(num: Int, n: Int) -> Int {
  let len = count_digits(num)
  let p = int.max(0, len - n)

  // This should not panic because the base is always positive
  let assert Ok(right_shift) =
    float.power(10.0, int.to_float(p))
    |> result.map(float.truncate)

  num / right_shift
}

/// Repeat a number like a string
///
/// # Examples
/// ```gleam
/// repeat(123, 3)
/// // -> 123_123_123
/// ```
pub fn repeat_digits(num: Int, times n: Int) -> Int {
  use <- bool.guard(n < 2, num)
  let len = count_digits(num)

  // This should not panic because the base is always positive
  let assert Ok(left_shift) =
    float.power(10.0, int.to_float(len * { n - 1 }))
    |> result.map(float.truncate)

  num * left_shift + repeat_digits(num, n - 1)
}
