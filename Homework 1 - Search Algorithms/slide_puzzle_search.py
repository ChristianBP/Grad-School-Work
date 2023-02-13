import sys

from collections import deque
from PriorityStack import *
from SlidePuzzle import *
from depth_first_search import depth_first_search
from iterative_deepening_search import iterative_deepening_search
from astar import astar

puzzle_start_position = "6 7 1 \n8 2 *\n5 4 3"

if(sys.argv[1] == "dfs"):
    puzzle_stack = deque([input_to_slide_puzzle(puzzle_start_position)])
    depth_first_search(puzzle_stack)
elif(sys.argv[1] == "ids"):
    puzzle_stack = deque([input_to_slide_puzzle(puzzle_start_position)])
    iterative_deepening_search(puzzle_stack)
elif(sys.argv[1] == "astar1"):
    puzzle_stack = PriorityStack()
    puzzle_stack.put(input_to_slide_puzzle(puzzle_start_position))
    astar(puzzle_stack, 1)
elif(sys.argv[1] == "astar2"):
    puzzle_stack = PriorityStack()
    puzzle_stack.put(input_to_slide_puzzle(puzzle_start_position))
    astar(puzzle_stack, 2)