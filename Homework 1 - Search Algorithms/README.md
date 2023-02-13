1. Instructions on how to run the program
2. Sample input and its corresponding output
3. Provide a short comparative analysis of two heuristics used for A* (10 point

For example: python homework1.py <algorithm_name> <input_file_path>



Steps to run this program:
1) Set the contents of a file to be the starting position of the slide puzzle, delimited by spaces. For example set the contents of input_file.txt to be `6 7 1 8 2 3 5 4 *`
2) Run this command to solve the slide puzzle: py main.py <algorithm_name> <input_file_path>
    Where <input_file_path> is the file you created in step 1 (i.e. input_file.txt)
    and <algorithm_name> is any of the following
    1) dfs for depth first search
    2) ids for itereative deepening search
    3) astar1 for A* search with the number of tiles in the wrong position heuristic
    4) astar2 for A* search with the sum of the Manhattan distances of all tiles from their goal positions heuristic
3) If the algorithm finds a solution, the output will be a list of states, starting with the start state, and ending with the goal state, followed by the number of moves and number of states enqueued. If the algorithm does not find a solution, then the output will say `No solution found at depth X`, where X is the max depth allowed for the search, followed by the number of states enqueued.


Sample inputs and outputs:
