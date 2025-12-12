module Main where

import Aoc
import Range qualified
import System.Exit (exitFailure)
import Test.HUnit

parseRangeTests :: [(String, String, Range.Range)]
parseRangeTests =
  [ ("parses correctly", "3-5", Range.fromInts 3 5),
    ("parses correctly", "10-14", Range.fromInts 10 14),
    ("parses correctly", "16-20", Range.fromInts 16 20),
    ("parses correctly", "12-18", Range.fromInts 12 18)
  ]

makeParseRangeTest :: (String, String, Range.Range) -> Test
makeParseRangeTest (description, input, expected) = TestCase (assertEqual description expected actual)
  where
    actual = Range.fromString input

testParseInput :: Test
testParseInput = TestCase (assertEqual "Test Parse Input" expected actual)
  where
    expected = ([Range.fromInts 3 5], [5])
    actual = parseInput "3-5\n\n5\n"

testPartOne :: Test
testPartOne = TestCase (assertEqual "Test Part One" expected actual)
  where
    expected = 3
    actual = solvePartOne (unlines
      [ "3-5"
      , "10-14"
      , "16-20"
      , "12-18"
      , ""
      , "1"
      , "5"
      , "8"
      , "11"
      , "17"
      , "32"
      ])

testPartTwo :: Test
testPartTwo = TestCase (assertEqual "Test Part Two" expected actual)
  where
    expected = 0
    actual = solvePartTwo ""

tests :: Test
tests =
  TestList
    [ TestLabel "Parse Ranges" $ TestList $ map makeParseRangeTest parseRangeTests,
      TestLabel "Parse Input" testParseInput,
      TestLabel "Part One" testPartOne,
      TestLabel "Part Two" testPartTwo
    ]

main :: IO Counts
main = do
  counts <- runTestTT tests
  if failures counts > 0 then exitFailure else return counts
