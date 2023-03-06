from collections import deque
from SlidePuzzle import *

def iterative_deepening_search(puzzle_stack):
    solution = False
    deeper_stack = deque()
    enqueued = 0
    current_max_depth = 2
    DEEPENING_RATE = 3

    while(not solution):
        # Exit the loop if we've run out of frontier to search
        if(len(puzzle_stack) == 0 and len(deeper_stack) == 0):
            solution = True
            continue
        
        # len(deeper_stack) > 0 is guaranteed to be True if we reach here
        # Travel to the next layer if we've explored up to the current depth
        if(len(puzzle_stack) == 0):
            puzzle_stack = deeper_stack
            deeper_stack = deque()
            current_max_depth = current_max_depth + DEEPENING_RATE

        current_puzzle = puzzle_stack.pop()

        if current_puzzle.isSolved():
            solution = current_puzzle 
            continue

        if current_puzzle.depth > SlidePuzzle.MAX_DEPTH:
            continue
        # Save anything past the max depth of this layer for the next layer.
        # Append left maintains our depth first search across layers.
        # This makes certain that the first node we travel to
        # from the next layer is on top of the stack.
        elif current_puzzle.depth > current_max_depth:
            deeper_stack.appendleft(current_puzzle)
            continue

        for puzzle in current_puzzle.get_next_moves():
            puzzle_stack.append(puzzle)
            enqueued += 1

    print_solution(solution, enqueued)