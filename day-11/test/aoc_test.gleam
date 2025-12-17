import aoc
import gleam/dict
import gleam/string
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_input_test() {
  let input =
    string.join(
      [
        "aaa: you hhh",
        "you: bbb ccc",
        "bbb: ddd eee",
        "ccc: ddd eee fff",
        "ddd: ggg",
        "eee: out",
        "fff: out",
        "ggg: out",
        "hhh: ccc fff iii",
        "iii: out\n",
      ],
      "\n",
    )

  let expected =
    dict.from_list([
      #("aaa", ["you", "hhh"]),
      #("you", ["bbb", "ccc"]),
      #("bbb", ["ddd", "eee"]),
      #("ccc", ["ddd", "eee", "fff"]),
      #("ddd", ["ggg"]),
      #("eee", ["out"]),
      #("fff", ["out"]),
      #("ggg", ["out"]),
      #("hhh", ["ccc", "fff", "iii"]),
      #("iii", ["out"]),
    ])

  let actual = aoc.parse_input(input)

  assert actual == expected
}

pub fn part_one_test() {
  let input =
    dict.from_list([
      #("aaa", ["you", "hhh"]),
      #("you", ["bbb", "ccc"]),
      #("bbb", ["ddd", "eee"]),
      #("ccc", ["ddd", "eee", "fff"]),
      #("ddd", ["ggg"]),
      #("eee", ["out"]),
      #("fff", ["out"]),
      #("ggg", ["out"]),
      #("hhh", ["ccc", "fff", "iii"]),
      #("iii", ["out"]),
    ])
  let expected = 5
  let actual = aoc.solve_part_one(input)

  assert actual == expected
}

pub fn part_two_test() {
  let input =
    dict.from_list([
      #("svr", ["aaa", "bbb"]),
      #("aaa", ["fft"]),
      #("fft", ["ccc"]),
      #("bbb", ["tty"]),
      #("tty", ["ccc"]),
      #("ccc", ["ddd", "eee"]),
      #("ddd", ["hub"]),
      #("hub", ["fff"]),
      #("eee", ["dac"]),
      #("dac", ["fff"]),
      #("fff", ["ggg", "hhh"]),
      #("ggg", ["out"]),
      #("hhh", ["out"]),
    ])
  let expected = 2
  let actual = aoc.solve_part_two(input)

  assert actual == expected
}
