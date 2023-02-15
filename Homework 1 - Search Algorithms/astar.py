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
        # The priority of each node is set to (new_puzzle.depth + heuristic)
        # where the depth is g*(n) (the cost from the start node to the current node)
        # and the heuristic is h*(n) (the minimum cost from the current node to the goal node).
        if current_puzzle.move_down() and current_puzzle.previous_move != -3:
            new_puzzle = current_puzzle.shift(3)
            puzzle_stack.put(new_puzzle, new_puzzle.depth + heuristic(new_puzzle, one_or_two))
            enqueued += 1
        if current_puzzle.move_right() and current_puzzle.previous_move != -1:
            new_puzzle = current_puzzle.shift(1)
            puzzle_stack.put(new_puzzle, new_puzzle.depth + heuristic(new_puzzle, one_or_two))
            enqueued += 1
        if current_puzzle.move_up() and current_puzzle.previous_move != 3:
            new_puzzle = current_puzzle.shift(-3)
            puzzle_stack.put(new_puzzle, new_puzzle.depth + heuristic(new_puzzle, one_or_two))
            enqueued += 1
        if current_puzzle.move_left() and current_puzzle.previous_move != 1:
            new_puzzle = current_puzzle.shift(-1)
            puzzle_stack.put(new_puzzle, new_puzzle.depth + heuristic(new_puzzle, one_or_two))
            enqueued += 1

    print_solution(solution, enqueued)

def heuristic(puzzle, one_or_two):
    return puzzle.heuristic1() if one_or_two == 1 else puzzle.heuristic2()
        