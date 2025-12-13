module Main (main) where

import Aoc
import System.IO

main :: IO ()
main = do
  handle <- openFile "input.txt" ReadMode
  contents <- hGetContents handle
  let (intervals, ingredients) = parseInput contents
  print (solvePartOne intervals ingredients)
  print (solvePartTwo intervals)
