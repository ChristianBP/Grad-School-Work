from SlidePuzzle import *

def depth_first_search(puzzle_stack):
    solution = False
    enqueued = 0

    while(not solution):
        # Exit the loop if we've run out of frontier to search
        if(len(puzzle_stack) == 0):
            solution = True
            continue

        current_puzzle = puzzle_stack.pop()

        if current_puzzle.isSolved():
            solution = current_puzzle 
            continue
        if current_puzzle.depth > SlidePuzzle.MAX_DEPTH:
            continue

        for puzzle in current_puzzle.get_next_moves():
            puzzle_stack.append(puzzle)
            enqueued += 1

    print_solution(solution, enqueued)