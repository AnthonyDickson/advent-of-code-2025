import gleam/int
import gleam/list

import digit

pub fn count_digits_test() {
  let input = 8_123_221_734
  let expected = 10

  let actual = digit.count(input)

  assert actual == expected
}

pub fn repeat_digits_test() {
  let cases = [
    #(1, 1, 1),
    #(1, 2, 11),
    #(1, 3, 111),
  ]

  list.each(cases, fn(case_) {
    let #(num, times, expected) = case_

    let actual = digit.repeat(num, times)

    assert actual == expected
      as {
        "Failed on input num="
        <> int.to_string(num)
        <> ", times="
        <> int.to_string(times)
        <> ", Expected "
        <> int.to_string(expected)
        <> ", got "
        <> int.to_string(actual)
      }
  })
}
