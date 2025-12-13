module AocTests (aocTestSuite) where

import Aoc
import Interval qualified as I
import Test.HUnit

testParseInput :: Test
testParseInput = TestCase (assertEqual "Test Parse Input" expected actual)
  where
    expected = ([I.Interval 3 5], [6])
    actual = parseInput "3-5\n\n6\n"

testPartOne :: Test
testPartOne = TestCase (assertEqual "Test Part One" expected actual)
  where
    expected = 3
    actual =
      solvePartOne
        [I.Interval 3 5, I.Interval 10 20]
        [1, 5, 8, 11, 17, 32]

testPartTwo :: Test
testPartTwo = TestCase (assertEqual "Test Part Two" expected actual)
  where
    expected = 14
    actual =
      solvePartTwo [I.Interval 3 5, I.Interval 10 20]

aocTestSuite :: Test
aocTestSuite =
  TestList
    [ TestLabel "Parse Input" testParseInput,
      TestLabel "Part One" testPartOne,
      TestLabel "Part Two" testPartTwo
    ]
