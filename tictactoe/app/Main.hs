module Main (main) where

import Lib (Player, playGame, emptyBoard)

main :: IO ()
main = playGame  emptyBoard
