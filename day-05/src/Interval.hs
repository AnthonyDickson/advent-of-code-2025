module Interval (Interval (..), parse, contains, merge, mergeAll, range) where

data Interval = Interval {start :: Int, end :: Int} deriving (Show, Eq)

instance Ord Interval where
  compare (Interval start end) (Interval start' end') =
    compare (start, end) (start', end')

parse :: String -> Interval
parse str = case split '-' str of
  (a : (b : _)) -> Interval (read a) (read b)
  _ -> error ("Expected a string formatted like \"5-13\" but got " ++ str)

split :: Char -> String -> [String]
split delimiter str = case break (== delimiter) str of
  (a, []) -> [a]
  (a, _ : b) -> a : split delimiter b

contains :: Interval -> Int -> Bool
contains interval num = start interval <= num && num <= end interval

canMerge :: Interval -> Interval -> Bool
canMerge (Interval start end) (Interval start' end') =
  (start <= end' && start' <= end) || end + 1 == start'

-- Assumes intervals are overlapping
merge :: Interval -> Interval -> Interval
merge a b =
  let start' = min (start a) (start b)
      end' = max (end a) (end b)
   in Interval start' end'

-- Assumes the input list is sorted
mergeAll :: [Interval] -> [Interval]
mergeAll [] = []
mergeAll [x] = [x]
mergeAll (a : b : t) =
  if canMerge a b
    then mergeAll (merge a b : t)
    else a : mergeAll (b : t)

range :: Interval -> Int
-- Need to add one because the intervals are inclusive on both ends
-- For example, 5 - 3 = 2, but [3, 5] contains 3, 4, 5 which is three numbers
range (Interval start' end') = end' - start' + 1
