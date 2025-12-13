module Main (main) where

import Aoc

main :: IO ()
main = do
  contents <- readFile "input.txt"
  let (intervals, ingredients) = parseInput contents
  print (solvePartOne intervals ingredients)
  print (solvePartTwo intervals)
