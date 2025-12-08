import gleam/bool
import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/set

import digit
import range.{type Range, Range}

pub fn solve_part_one(ranges: List(Range)) -> Int {
  ranges
  |> list.flat_map(get_invalid_ids)
  |> int.sum
}

pub fn get_invalid_ids(range: Range) -> List(Int) {
  let Range(start, end) = range
  let start_digit_count = digit.count(start)
  let end_digit_count = digit.count(end)
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
    digit.take(start, start_split_index),
    digit.take(end, end_split_index),
  )
  |> list.map(digit.repeat(_, 2))
  |> list.filter(fn(x) { x >= start && x <= end })
}

pub fn solve_part_two(ranges: List(Range)) -> Int {
  ranges
  |> list.flat_map(generate_invalid_ids)
  |> int.sum
}

pub fn generate_invalid_ids(range: Range) -> List(Int) {
  let len = digit.count(range.end)
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
  let len = digit.count(num)

  list.range(1, len / 2)
  |> list.filter(fn(subseq_len) { len % subseq_len == 0 })
  |> list.map(fn(subseq_len) {
    let times = len / subseq_len
    let leading_digits = digit.take(num, subseq_len)
    digit.repeat(leading_digits, times)
  })
}
