module Aoc
  ( parseInput,
    solvePartOne,
    solvePartTwo,
  )
where

import Range qualified

-- Get the list of fresh ID ranges and ingredient IDs
-- Assumes the input follows the format:
-- ```
-- 1-3\n
-- 2-8\n
-- \n
-- 2\n
-- 5\n
-- ```
parseInput :: String -> ([Range.Range], [Int])
parseInput str =
  ( map Range.fromString ranges,
    -- Have to drop the first "ingredient" since it will be an empty string
    map read (drop 1 ingredients)
  )
  where
    lines' = lines str
    (ranges, ingredients) = break null lines'

solvePartOne :: String -> Int
solvePartOne input =
  let
    (ranges, ingredients) = parseInput input
    isFresh ingredient = or $ map (\range -> Range.contains range ingredient) ranges 
  in 
    length $ filter isFresh ingredients


solvePartTwo :: String -> Int
solvePartTwo _input = 0
