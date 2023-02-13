from SlidePuzzle import *

# astar1 - The heuristic is the number of tiles in the wrong position.
# astar2 - The heuristic is the sum of the Manhattan distances of all tiles from their goal positions.
def astar(puzzle_stack, one_or_two):
    solution = False
    enqueued = 0

    while(not solution):
        # Exit the loop if we've run out of frontier to search
        if(puzzle_stack.empty()):
            solution = True
            continue

        current_puzzle = puzzle_stack.get()

        if current_puzzle.isSolved():
            solution = current_puzzle 
            continue
        if current_puzzle.depth > SlidePuzzle.MAX_DEPTH:
            continue

        # Check if we can move in a direction
        # If so, then make the move and add the new node to the queue
        if current_puzzle.move_down():
            new_puzzle = current_puzzle.shift(3)
            puzzle_stack.put(new_puzzle, heuristic(new_puzzle, one_or_two))
            enqueued += 1
        if current_puzzle.move_right():
            new_puzzle = current_puzzle.shift(1)
            puzzle_stack.put(new_puzzle, heuristic(new_puzzle, one_or_two))
            enqueued += 1
        if current_puzzle.move_up():
            new_puzzle = current_puzzle.shift(-3)
            puzzle_stack.put(new_puzzle, heuristic(new_puzzle, one_or_two))
            enqueued += 1
        if current_puzzle.move_left():
            new_puzzle = current_puzzle.shift(-1)
            puzzle_stack.put(new_puzzle, heuristic(new_puzzle, one_or_two))
            enqueued += 1

    if(solution == True):
        print("No solution found at depth 10")
    else:
        solution.print_history()

    print(f"Number of moves = {solution.depth}")
    print(f"Number of states enqueued = {str(enqueued)}")


def heuristic(puzzle, one_or_two):
    return puzzle.heuristic1() if one_or_two == 1 else puzzle.heuristic2()
        