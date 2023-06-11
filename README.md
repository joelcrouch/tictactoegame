# tictactoegame
A simple tictactoe game written in Haskell.
This is a tic-tac-toe game written in Haskell.  Download it into a folder, run 'stack build', and then 'stack run' and the game will start.  There is only one option for the players, enter a location  in the grid like so: 1 2.  The grid is set up to show this: 
  |  |        and currently does not have row or column numbers.  
---------
  |  |   
---------
  |  |     
Please refer to the column and rows like this     0  1  2  
                                               0    |  |  
                                                 ---------
                                               1    |  |
                                                 ----------
                                               2    |  | 
When a player has three x's or o's in a row, then the game will declare a winner.  
Here is an example of a game where X wins finally: 
PS C:\Users\joelc\OneDrive\Desktop\t3\tictactoe> stack build
PS C:\Users\joelc\OneDrive\Desktop\t3\tictactoe> stack run
  |   |  
---------
  |   |
---------
  |   |
Player X, enter your move (row column):
1 1
  |   |
---------
  | X |
---------
  |   |
Player O, enter your move (row column):
1 0
  |   |
---------
O | X |
---------
  |   |
Player X, enter your move (row column):
0 1
  | X |
---------
O | X |
---------
  |   |
Player O, enter your move (row column):
1 2
  | X |
---------
O | X | O
---------
  |   |
Player X, enter your move (row column):
2 2
  | X |
---------
O | X | O
---------
  |   | X
Player O, enter your move (row column):
0 2
  | X | O
---------
O | X | O
---------
  |   | X
Player X, enter your move (row column):
1 2
  | X | O
---------
O | X | X
---------
  |   | X
Player O, enter your move (row column):
2 1
  | X | O
---------
O | X | X
---------
  | O | X
Player X, enter your move (row column):
0 0
X | X | O
---------
O | X | X
---------
  | O | X
Player X wins!


Future work will include more error checking, effective error responses, and implementing a test suite.  Quickcheck will possibly be the appropriate 'library' to use for that. 
