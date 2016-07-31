module Main where

import Lib
import Data.Monoid

main :: IO ()
main = do
    putStrLn $ "Binary of 'attack at dusk' -> " <> concatMap show intercept
