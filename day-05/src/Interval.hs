module Interval (Interval (..), parse, contains, overlaps, merge, mergeOverlapping, range) where

data Interval = Interval {start :: Int, end :: Int} deriving (Show, Eq)

instance Ord Interval where
  compare (Interval start end) (Interval start' end')
    -- oo
    -- oo
    | start == start' && end == end' = EQ
    -- oo
    --    oo
    | end < start' = LT
    --    oo
    -- oo
    | start > end' = GT
    -- ooo
    -- oo
    | start == start' = if end > end' then GT else LT
    -- ooo
    --  oo
    | end == end' = if start < start' then LT else GT
    -- ooo
    --   ooo
    | end == start' = LT
    --   ooo
    -- ooo
    | start == end' = GT
    | otherwise = EQ

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

overlaps :: Interval -> Interval -> Bool
overlaps a@(Interval start end) b@(Interval start' end') =
  contains a start'
    || contains a end'
    || contains b start
    || contains b end

-- Assumes intervals are overlapping
merge :: Interval -> Interval -> Interval
merge a b =
  let start' = min (start a) (start b)
      end' = max (end a) (end b)
   in Interval start' end'

-- Assumes the input list is sorted
mergeOverlapping :: [Interval] -> [Interval]
mergeOverlapping [] = []
mergeOverlapping [x] = [x]
mergeOverlapping (a : b : t) =
  if overlaps a b
    then mergeOverlapping (merge a b : t)
    else a : mergeOverlapping (b : t)

range :: Interval -> Int
-- Need to add one because the intervals are inclusive on both ends
-- For example, 5 - 3 = 2, but [3, 5] contains 3, 4, 5 which is three numbers
range (Interval start' end') = end' - start' + 1
