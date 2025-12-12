module Range (Range, fromInts, fromString, contains) where

data Range = Range {start :: Int, end :: Int} deriving (Show, Eq)

fromInts :: Int -> Int -> Range
fromInts = Range

fromString :: String -> Range
fromString str = case split '-' str of
  (a : (b : _)) -> Range (read a) (read b)
  _ -> error ("Expected a string formatted like \"5-13\" but got " ++ str)

split :: Char -> String -> [String]
split delimiter str = case break (== delimiter) str of
  (a, []) -> [a]
  (a, _ : b) -> a : split delimiter b

contains :: Range -> Int -> Bool
contains range num = start range <= num && num <= end range
