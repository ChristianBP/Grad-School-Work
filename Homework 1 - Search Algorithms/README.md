# Steps to run this program:
1) Set the contents of a file to be the starting position of the slide puzzle, delimited by spaces. For example set the contents of `input_file.txt` to be `6 7 1 8 2 3 5 4 *`
2) Run this command to solve the slide puzzle: `py main.py <algorithm_name> <input_file_path>`, where `<input_file_path>` is the file you created in step 1 (i.e. `input_file.txt`), and `<algorithm_name>` is any of the following
    - dfs for depth first search
    - ids for itereative deepening search
    - astar1 for A* search with the *number of tiles in the wrong position* heuristic
    - astar2 for A* search with the sum of the Manhattan distances of all tiles from their goal positions heuristic
3) If the algorithm finds a solution, the output will be a list of states, starting with the start state, and ending with the goal state, followed by the number of moves and number of states enqueued. If the algorithm does not find a solution, then the output will say *No solution found at depth X*, where X is the max depth allowed for the search, followed by the number of states enqueued.


Sample inputs and outputs:

$ py main.py dfs input_file.txt 

List of states starting from input to goal state, if found

Initial input state  
```7 8 1
6 4 *
5 3 2

7 8 1
6 * 4
5 3 2

7 8 1
6 3 4
5 * 2

7 8 1
6 3 4
5 2 *

7 8 1
6 3 *
5 2 4

7 8 1
6 * 3
5 2 4

7 8 1
6 2 3
5 * 4

7 8 1
6 2 3
5 4 *

7 8 1
6 2 *
5 4 3

7 8 1
6 * 2
5 4 3```
Goal state

Number of moves = 9
Number of states enqueued = 457


$ py main.py ids input_file.txt

List of states starting from input to goal state, if found

Initial input state
```7 8 1
6 4 *
5 3 2

7 8 1
6 4 2
5 3 *

7 8 1
6 4 2
5 * 3

7 8 1
6 * 2
5 4 3```
Goal state

Number of moves = 3
Number of states enqueued = 18


$ py main.py astar1 input_file.txt

List of states starting from input to goal state, if found

Initial input state
```7 8 1
6 4 *
5 3 2

7 8 1
6 4 2
5 3 *

7 8 1
6 4 2
5 * 3

7 8 1
6 * 2
5 4 3```
Goal state

Number of moves = 3
Number of states enqueued = 9


$ py main.py astar2 input_file.txt

List of states starting from input to goal state, if found

Initial input state
```7 8 1
6 4 *
5 3 2

7 8 1
6 4 2
5 3 *

7 8 1
6 4 2
5 * 3

7 8 1
6 * 2
5 4 3```
Goal state

Number of moves = 3
Number of states enqueued = 6


## A* Analysis
- The first heuristic that this program uses for A* is the *number of tiles in the wrong position*. This heuristic is calculating the cost of solving the puzzle if we change the rules to allow each tile to be moved to it's goal position in one move.
- The second heuristic is the sum of the Manhattan distances of all tiles from their goal positions. This heuristic is calculating the cost of solving the puzzle if we can move all of the tiles along the shortest path to their goal position, without worrying about colliding with other tiles.
- What we're looking for in an effective heuristic is to get as close to the ground truth as possible, without overestimating. If a position is 3 moves away from the solution, we want the heuristic to return 3 rather than 2. This prevents us from traveling down paths that the heuristic thinks are close to the goal when they actually aren't. For example, if we have a position that is 10 moves away from the solution, an admissable heuristic might tell us that we're 3 moves away from the solution. While we waste time searching that tree, there might be a 6 move solution along a different path.
- The accuracy of the heuristic depends on how well it maps onto the problem. The Manhattan distance maps onto the slide puzzle problem well because it takes into account the distance a tile has to move, rather than assuming the tile can jump straight to it's goal position. This provides a more accurate estimate of the remaining cost to reach the goal state and allows the algorithm to make more informed decisions about which states to explore. Given a more accurate a heuristic, the A* algorithm will narrow down the search space greatly, generating the optimal solution much faster. With this in mind, we can see that the Manhattan distance is a more effective heuristic because it maps onto the problem better and provides more information than the *number of tiles in the wrong position* heuristic.