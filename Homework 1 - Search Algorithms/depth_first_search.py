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

        # Check if we can move in a direction
        # If so, then make the move and add the new node to the stack
        if current_puzzle.move_down():
            puzzle_stack.append(current_puzzle.shift(3))
            enqueued += 1
        if current_puzzle.move_right():
            puzzle_stack.append(current_puzzle.shift(1))
            enqueued += 1
        if current_puzzle.move_up():
            puzzle_stack.append(current_puzzle.shift(-3))
            enqueued += 1
        if current_puzzle.move_left():
            puzzle_stack.append(current_puzzle.shift(-1))
            enqueued += 1

    print_solution(solution, enqueued)