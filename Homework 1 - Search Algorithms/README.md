1. Instructions on how to run the program
2. Sample input and its corresponding output
3. Provide a short comparative analysis of two heuristics used for A* (10 point

For example: python homework1.py <algorithm_name> <input_file_path>



# Steps to run this program:
1) Set the contents of a file to be the starting position of the slide puzzle, delimited by spaces. For example set the contents of `input_file.txt` to be `6 7 1 8 2 3 5 4 *`
2) Run this command to solve the slide puzzle: ```py main.py <algorithm_name> <input_file_path>```
Where `<input_file_path>` is the file you created in step 1 (i.e. `input_file.txt`), and `<algorithm_name>` is any of the following
    - dfs for depth first search
    - ids for itereative deepening search
    - astar1 for A* search with the number of tiles in the wrong position heuristic
    - astar2 for A* search with the sum of the Manhattan distances of all tiles from their goal positions heuristic
3) If the algorithm finds a solution, the output will be a list of states, starting with the start state, and ending with the goal state, followed by the number of moves and number of states enqueued. If the algorithm does not find a solution, then the output will say *No solution found at depth X*, where X is the max depth allowed for the search, followed by the number of states enqueued.


Sample inputs and outputs:

## A* Analysis
The first heuristic that this program uses for A* is the number of tiles in the wrong position. This heuristic is calculating the cost of solving the puzzle if we change the rules to allow each tile to be moved to it's goal position in one move.
The second heuristic is the sum of the Manhattan distances of all tiles from their goal positions. This heuristic is calculating the cost of solving the puzzle if we can move all of the tiles along the shortest path to their goal position, without worrying about colliding with other tiles.
What we're looking for in an effective heuristic is to get as close to the ground truth as possible. If a position is 3 moves away from the solution, we want the heuristic to return 3 rather than 2. This prevents us from traveling down paths that the heuristic thinks are close to the goal when they actually aren't. For example, if we have a position that is 10 moves away from the solution, an admissable heuristic might tell us that we're 3 moves away from the solution. While we waste time searching that tree, there might be another solution in 6 moves along another path.

In order to be the better heuristic, the second heuristic must always be as close or closer to the ground truth than the first heuristic. We can prove this to be the case by looking at the edge cases for both heuristics.

Let's say we have a puzzle that is only one move away from completion:
7 8 1
* 6 2
5 4 3

The first heuristic would say that we are 1 away from the solution because only one tile is in the wrong position. The second heuristic would say that we are 1 away from the solution because every tile but the 6 is in the goal position and the 6 tile only needs to be moved once. In this example, the second heuristic is just as close as the first heuristic.

Let's say we have a puzzle that is only XXXXXXX

XXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXX moves away from completion:
7 8 1
6 * 2
5 4 3
