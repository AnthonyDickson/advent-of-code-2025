module Main where

import AocTests (aocTestSuite)
import IntervalTests (intervalTestSuite)
import System.Exit (exitFailure)
import Test.HUnit

allTests :: Test
allTests =
  TestList
    [ TestLabel "Main Solution Tests" aocTestSuite,
      TestLabel "Interval Tests" intervalTestSuite
    ]

main :: IO Counts
main = do
  counts <- runTestTT allTests
  if failures counts > 0 then exitFailure else return counts
