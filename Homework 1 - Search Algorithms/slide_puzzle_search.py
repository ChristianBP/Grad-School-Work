from collections import deque
from functions import *
# 1 2 *
# 4 5 3
# 7 8 6
puzzle_start_position = "1 2 *\n4 5 3\n7 8 6"
solution = False

puzzle_stack = deque([input_to_slide_puzzle(puzzle_start_position)])



# It works but I'm not convinced it's actually running depth first search




while(not solution):
    if(len(puzzle_stack) == 0):
        solution = True
        continue

    current_puzzle = puzzle_stack.pop()

    if current_puzzle.isSolved():
        solution = current_puzzle 
        continue
    if current_puzzle.depth > 2:
        continue

    if current_puzzle.move_up():
        puzzle_stack.append(current_puzzle.shift(-3))
    if current_puzzle.move_left():
        puzzle_stack.append(current_puzzle.shift(-1))
    if current_puzzle.move_right():
        puzzle_stack.append(current_puzzle.shift(1))
    if current_puzzle.move_down():
        puzzle_stack.append(current_puzzle.shift(3))

solution.print_history()