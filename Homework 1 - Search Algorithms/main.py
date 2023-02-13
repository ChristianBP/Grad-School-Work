import sys

from collections import deque
from PriorityStack import *
from SlidePuzzle import *
from depth_first_search import depth_first_search
from iterative_deepening_search import iterative_deepening_search
from astar import astar

with open(sys.argv[2], 'r') as file:
    puzzle_start_position = file.read()
    starting_puzzle = input_to_slide_puzzle(puzzle_start_position)

if(sys.argv[1] == "dfs"):
    puzzle_stack = deque([starting_puzzle])
    depth_first_search(puzzle_stack)
elif(sys.argv[1] == "ids"):
    puzzle_stack = deque([starting_puzzle])
    iterative_deepening_search(puzzle_stack)
elif(sys.argv[1] == "astar1"):
    puzzle_stack = PriorityStack()
    puzzle_stack.put(starting_puzzle)
    astar(puzzle_stack, 1)
elif(sys.argv[1] == "astar2"):
    puzzle_stack = PriorityStack()
    puzzle_stack.put(starting_puzzle)
    astar(puzzle_stack, 2)