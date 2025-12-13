module Aoc
  ( parseInput,
    solvePartOne,
    solvePartTwo,
  )
where

import Data.List (sort)
import Interval qualified as I

-- Get the list of fresh ID ranges and ingredient IDs
-- Assumes the input follows the format:
-- ```
-- 1-3\n
-- 2-8\n
-- \n
-- 2\n
-- 5\n
-- ```
parseInput :: String -> ([I.Interval], [Int])
parseInput str =
  (  I.mergeAll$ sort $ map I.parse intervals,
    -- Have to drop the first "ingredient" since it will be an empty string
    map read (drop 1 ingredients)
  )
  where
    lines' = lines str
    (intervals, ingredients) = break null lines'

solvePartOne :: [I.Interval] -> [Int] -> Int
solvePartOne intervals ingredients =
  let fresh ingredient = any (`I.contains` ingredient) intervals
   in length $ filter fresh ingredients

solvePartTwo :: [I.Interval] -> Int
solvePartTwo = sum . map I.range
