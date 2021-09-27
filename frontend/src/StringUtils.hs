
module StringUtils
  ( indent
  , breaki
  ) where

import Data.List (intercalate)

indent :: String -> String
indent [] = []
indent xs = intercalate "\n" $ map (\(s, i) -> replicate (i*2) ' ' ++ s ) $ breaki 0 xs

breaki :: Int -> String -> [(String, Int)]
breaki i [] = [([], i)]
breaki i (x:xs) = 
  if x `elem` ['(', '[', '{'] then
    (x:"", i):breaki (i + 1) xs
  else if x `elem` [')', ']', '}'] then
    case breaki (i - 1) xs of
      (str, i'):rs -> ("", i):(x:str, i'):rs
      _ -> error "invalid breaki on dedent"
  else
    case breaki i xs of
      (str, i'):rs -> (x:str, i'):rs
      _ -> error "invalid breaki on same indent"