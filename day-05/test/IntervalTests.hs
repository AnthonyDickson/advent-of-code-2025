module IntervalTests (intervalTestSuite) where

import Interval
import Test.HUnit

parseTests :: [(String, String, Interval)]
parseTests =
  [ ("parses correctly", "3-5", Interval 3 5),
    ("parses correctly", "10-14", Interval 10 14),
    ("parses correctly", "16-20", Interval 16 20),
    ("parses correctly", "12-18", Interval 12 18)
  ]

makeParseTest :: (String, String, Interval) -> Test
makeParseTest (description, input, expected) = TestCase (assertEqual description expected actual)
  where
    actual = parse input

compareTests :: [(String, Interval, Interval, Ordering)]
compareTests =
  [ ("1-5 is less than 6-10", Interval 1 5, Interval 6 10, LT),
    ("6-10 is greater than 1-5", Interval 6 10, Interval 1 5, GT),
    ("5-10 is greater than 1-5", Interval 5 10, Interval 1 5, GT),
    ("1-5 is less than 5-10", Interval 1 5, Interval 5 10, LT),
    ("same start left end > right end", Interval 1 10, Interval 1 5, GT),
    ("same start left end < right end", Interval 1 10, Interval 1 20, LT),
    ("left == right", Interval 1 10, Interval 1 10, EQ),
    ("left start > right start, same end", Interval 10 20, Interval 1 20, GT),
    ("left start < right start, same end", Interval 1 20, Interval 10 20, LT),
    ("left start < right start, left end == right start == right end", Interval 1 20, Interval 20 20, LT),
    ("left start == left end == right start, right end > left end", Interval 1 1, Interval 1 20, LT)
  ]

makeCompareTest :: (String, Interval, Interval, Ordering) -> Test
makeCompareTest (description, a, b, expected) = TestCase (assertEqual description expected actual)
  where
    actual = compare a b

mergeTests :: [(String, Interval, Interval, Interval)]
mergeTests =
  [ ("merges overlapping interval smallest first", Interval 1 5, Interval 5 10, Interval 1 10),
    ("merges overlapping interval largest first", Interval 5 10, Interval 1 5, Interval 1 10),
    ("interval contained in another interval", Interval 1 10, Interval 2 5, Interval 1 10),
    ("merges neighbouring", Interval 1 5, Interval 6 10, Interval 1 10),
    ("merges left start < end start, left end == right start == right end", Interval 1 5, Interval 6 10, Interval 1 10)
  ]

makeMergeTest :: (String, Interval, Interval, Interval) -> Test
makeMergeTest (description, a, b, expected) = TestCase (assertEqual description expected actual)
  where
    actual = merge a b

intervalTestSuite :: Test
intervalTestSuite =
  TestList
    [ TestLabel "Parse Intervals" $ TestList $ map makeParseTest parseTests,
      TestLabel "Compare Intervals" $ TestList $ map makeCompareTest compareTests,
      TestLabel "Merge Intervals" $ TestList $ map makeMergeTest mergeTests
    ]
