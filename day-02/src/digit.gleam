import gleam/bool
import gleam/float
import gleam/int
import gleam/result
import gleam/string

const ln_10 = 2.30258509299

/// Count the digits in a number
///
/// # Examples
///
/// ```gleam
/// count_digits(12345)
/// // -> 5
/// ```
pub fn count(num: Int) -> Int {
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
pub fn take(num: Int, n: Int) -> Int {
  let len = count(num)
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
pub fn repeat(num: Int, times n: Int) -> Int {
  use <- bool.guard(n < 2, num)
  let len = count(num)

  // This should not panic because the base is always positive
  let assert Ok(left_shift) =
    float.power(10.0, int.to_float(len * { n - 1 }))
    |> result.map(float.truncate)

  num * left_shift + repeat(num, n - 1)
}
