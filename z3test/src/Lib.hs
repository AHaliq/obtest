module Lib
    ( someFunc
    , someStr
    , somePrc
    ) where

import System.Process (runInteractiveProcess)

someFunc :: IO ()
someFunc = putStrLn "someFunc"

someStr :: String
someStr = "hello from z3 test"

somePrc :: String -> IO ()
somePrc x = do
    runInteractiveProcess x [] Nothing Nothing
    pure ()

