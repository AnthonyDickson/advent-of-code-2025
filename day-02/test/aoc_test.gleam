import aoc
import gleam/list
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_input_test() {
  let input =
    "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
  let expected =
    Ok([
      aoc.Range(11, 22),
      aoc.Range(95, 115),
      aoc.Range(998, 1012),
      aoc.Range(1_188_511_880, 1_188_511_890),
      aoc.Range(222_220, 222_224),
      aoc.Range(1_698_522, 1_698_528),
      aoc.Range(446_443, 446_449),
      aoc.Range(38_593_856, 38_593_862),
      aoc.Range(565_653, 565_659),
      aoc.Range(824_824_821, 824_824_827),
      aoc.Range(2_121_212_118, 2_121_212_124),
    ])

  let actual = aoc.parse_input(input)

  assert expected == actual
}

pub fn parse_input_individual_test() {
  let cases = [
    #("11-22", Ok([aoc.Range(11, 22)])),
    #("95-115", Ok([aoc.Range(95, 115)])),
    #("998-1012", Ok([aoc.Range(998, 1012)])),
    #("1188511880-1188511890", Ok([aoc.Range(1_188_511_880, 1_188_511_890)])),
    #("222220-222224", Ok([aoc.Range(222_220, 222_224)])),
    #("1698522-1698528", Ok([aoc.Range(1_698_522, 1_698_528)])),
    #("446443-446449", Ok([aoc.Range(446_443, 446_449)])),
    #("38593856-38593862", Ok([aoc.Range(38_593_856, 38_593_862)])),
    #("565653-565659", Ok([aoc.Range(565_653, 565_659)])),
    #("824824821-824824827", Ok([aoc.Range(824_824_821, 824_824_827)])),
    #("2121212118-2121212124", Ok([aoc.Range(2_121_212_118, 2_121_212_124)])),
  ]

  list.each(cases, fn(case_) {
    let #(input, expected) = case_

    let actual = aoc.parse_input(input)

    assert expected == actual
  })
}

pub fn get_invalid_ids_test() {
  let cases = [
    #(aoc.Range(11, 22), [11, 22]),
    #(aoc.Range(95, 115), [99]),
    #(aoc.Range(998, 1012), [1010]),
    #(aoc.Range(1_188_511_880, 1_188_511_890), [1_188_511_885]),
    #(aoc.Range(222_220, 222_224), [222_222]),
    #(aoc.Range(1_698_522, 1_698_528), []),
    #(aoc.Range(446_443, 446_449), [446_446]),
    #(aoc.Range(38_593_856, 38_593_862), [38_593_859]),
    #(aoc.Range(565_653, 565_659), []),
    #(aoc.Range(824_824_821, 824_824_827), []),
    #(aoc.Range(2_121_212_118, 2_121_212_124), []),
    #(aoc.Range(8_123_221_734, 8_123_333_968), [8_123_281_232]),
    #(aoc.Range(1233, 1772), [1313, 1414, 1515, 1616, 1717]),
    #(aoc.Range(2, 15), [11]),
    #(aoc.Range(2, 2), []),
    #(aoc.Range(668, 1146), [1010, 1111]),
  ]

  list.each(cases, fn(case_) {
    let #(input, expected) = case_

    let actual = aoc.get_invalid_ids(input)

    assert actual == expected
      as { "failed on input " <> aoc.range_to_string(input) }
  })
}

pub fn part_one_test() {
  let input = [
    aoc.Range(11, 22),
    aoc.Range(95, 115),
    aoc.Range(998, 1012),
    aoc.Range(1_188_511_880, 1_188_511_890),
    aoc.Range(222_220, 222_224),
    aoc.Range(1_698_522, 1_698_528),
    aoc.Range(446_443, 446_449),
    aoc.Range(38_593_856, 38_593_862),
    aoc.Range(565_653, 565_659),
    aoc.Range(824_824_821, 824_824_827),
    aoc.Range(2_121_212_118, 2_121_212_124),
  ]
  let expected = 1_227_775_554

  let actual = aoc.solve_part_one(input)

  assert actual == expected
}

pub fn count_digits_test() {
  let input = 8_123_221_734
  let expected = 10

  let actual = aoc.count_digits(input)

  assert actual == expected
}

pub fn part_two_test() {
  let input = []
  let solution = aoc.solve_part_two(input)

  assert solution == 0
}
