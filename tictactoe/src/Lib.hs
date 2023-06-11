module Lib
    ( --someFunc
      emptyBoard,
      printBoard,
      getPlayerMove, 
      getCell,
      isValidMove,
      nextPlayer,
      setCell,
      isBoardFull,
      getRow,
      getColumns,
      getDiagonals,
      checkLine,
      checkWin,
      playGame,
      Player, 
      Cell, 
      Board,
      Row, 
      Line
    ) where


import Data.List
import Data.Maybe (isNothing, isJust, listToMaybe, catMaybes)

data Player = X | O deriving (Eq, Show)
type Cell = Maybe Player
type Row = (Cell, Cell, Cell)
type Board = (Row, Row, Row)
type Line = (Cell, Cell, Cell)

emptyBoard :: Board
emptyBoard = ((Nothing, Nothing, Nothing),
              (Nothing, Nothing, Nothing),
              (Nothing, Nothing, Nothing))

printBoard :: Board -> IO ()
printBoard = mapM_ putStrLn . boardStrings
  where
    playerString :: Cell -> String
    playerString Nothing = " "
    playerString (Just X) = "X"
    playerString (Just O) = "O"

    rowString :: Row -> String
    rowString (c1, c2, c3) = intercalate " | " (map playerString [c1, c2, c3])

    separator :: String
    separator = "---------"

    boardStrings :: Board -> [String]
    boardStrings ((r1, r2, r3), (r4, r5, r6), (r7, r8, r9)) =
      [rowString (r1, r2, r3), separator,
       rowString (r4, r5, r6), separator,
       rowString (r7, r8, r9)]

getPlayerMove :: Player -> IO (Int, Int)
getPlayerMove player = do
  putStrLn $ "Player " ++ show player ++ ", enter your move (row column):"
  input <- getLine
  let [row, column] = map read $ words input
  return (row, column)

nextPlayer :: Player -> Player
nextPlayer X = O
nextPlayer O = X

getCell :: Board -> (Int, Int) -> Cell
getCell ((r1, r2, r3), (r4, r5, r6), (r7, r8, r9)) (row, column) =
  case row of
    0 -> case column of
           0 -> r1
           1 -> r2
           2 -> r3
    1 -> case column of
           0 -> r4
           1 -> r5
           2 -> r6
    2 -> case column of
           0 -> r7
           1 -> r8
           2 -> r9

isValidMove :: Board -> (Int, Int) -> Bool
isValidMove board (row, column) =
  withinBounds && isNothing cell
  where
    withinBounds = row >= 0 && row <= 2 && column >= 0 && column <= 2
    cell = getCell board (row, column)

setCell :: Board -> (Int, Int) -> Cell -> Board
setCell ((r1, r2, r3), (r4, r5, r6), (r7, r8, r9)) (row, column) cell =
  case row of
    0 -> case column of
           0 -> ((cell, r2, r3), (r4, r5, r6), (r7, r8, r9))
           1 -> ((r1, cell, r3), (r4, r5, r6), (r7, r8, r9))
           2 -> ((r1, r2, cell), (r4, r5, r6), (r7, r8, r9))
    1 -> case column of
           0 -> ((r1, r2, r3), (cell, r5, r6), (r7, r8, r9))
           1 -> ((r1, r2, r3), (r4, cell, r6), (r7, r8, r9))
           2 -> ((r1, r2, r3), (r4, r5, cell), (r7, r8, r9))
    2 -> case column of
           0 -> ((r1, r2, r3), (r4, r5, r6), (cell, r8, r9))
           1 -> ((r1, r2, r3), (r4, r5, r6), (r7, cell, r9))
           2 -> ((r1, r2, r3), (r4, r5, r6), (r7, r8, cell))


isBoardFull :: Board -> Bool
isBoardFull = all isJust . flattenBoard
  where
    flattenBoard :: Board -> [Cell]
    flattenBoard ((r1, r2, r3), (r4, r5, r6), (r7, r8, r9)) =
      [r1, r2, r3, r4, r5, r6, r7, r8, r9]

getRow :: Board -> Int -> Maybe Row
getRow board@(r1, r2, r3) rowIndex
  | rowIndex == 0 = Just (getCell board (0, 0), getCell board (0, 1), getCell board (0, 2))
  | rowIndex == 1 = Just (getCell board (1, 0), getCell board (1, 1), getCell board (1, 2))
  | rowIndex == 2 = Just (getCell board (2, 0), getCell board (2, 1), getCell board (2, 2))
  | otherwise = Nothing


getColumns :: Board -> [Maybe Row]
getColumns ((r1, r2, r3), (r4, r5, r6), (r7, r8, r9)) =
  [ Just (r1, r4, r7)
  , Just (r2, r5, r8)
  , Just (r3, r6, r9)
  ]

getDiagonals :: Board -> [Maybe Row]
getDiagonals ((r1, _, r3), (_, r5, _), (r7, _, r9)) =
  [ Just (r1, r5, r9)
  , Just (r3, r5, r7)
  ]

checkLine :: Line -> Maybe Player
checkLine (cell1, cell2, cell3)
  | all (== cell1) [cell2, cell3] = cell1
  | otherwise = Nothing


checkWin :: Board -> Maybe Player
checkWin board =
  let rows = [getRow board 0, getRow board 1, getRow board 2]
      cols = getColumns board
      diags = getDiagonals board
  in checkLines (rows ++ cols ++ diags)
  where
    checkLines :: [Maybe Row] -> Maybe Player
    checkLines [] = Nothing
    checkLines (row : remainingRows) =
      case row of
        Just cells -> case checkLine cells of
          Just player -> Just player
          Nothing -> checkLines remainingRows
        Nothing -> checkLines remainingRows

playGame :: Board -> IO ()
playGame board = do
  printBoard board
  loop X board  -- Start with X as the first player
  where
    loop :: Player -> Board -> IO ()
    loop player board = do
      --putStrLn $ "Player " ++ show player ++ ", enter your move (row column):"
      move <- getPlayerMove player
      case move of
        (row, col) -> do
          let newBoard = setCell board (row, col) (Just player)
          printBoard newBoard
          case checkWin newBoard of
            Just winner -> putStrLn $ "Player " ++ show winner ++ " wins!"
            Nothing ->
              if isBoardFull newBoard
                then putStrLn "It's a draw!"
                else loop (nextPlayer player) newBoard
        -- Nothing -> do
        --   putStrLn "Invalid move. Please try again."
        --   loop player board


-- playGame :: Player -> Board -> IO ()
-- playGame player board = do
--   printBoard board
--   move <- getPlayerMove player
--   if isValidMove board move
--     then do
--       let newBoard = setCell board move (Just player)
--       case checkWin newBoard of
--         Just X -> putStrLn "Player X wins!"
--         Just O -> putStrLn "Player O wins!"
--         _ | isBoardFull newBoard -> putStrLn "It's a draw!"
--           | otherwise -> playGame (nextPlayer player) newBoard
--     else do
--       putStrLn "Invalid move. Try again."
--       playGame player board



-- main :: IO ()
-- main = playGame X emptyBoard

-- isBoardFull :: Board -> Bool
-- --isBoardFull = all isJust . concatMap (\(a, b, c) -> [a, b, c])
-- isBoardFull all (all isJust)
-- someFunc :: IO ()
-- someFunc = putStrLn "someFunc"
