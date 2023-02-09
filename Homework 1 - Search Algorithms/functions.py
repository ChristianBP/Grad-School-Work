class SlidePuzzle():
    puzzle_string = None
    blank_index = None
    previous_position = None
    depth = 0

    def __init__(self, puzzle_string, previous_puzzle=None, depth=0):
        self.puzzle_string = puzzle_string
        self.blank_index = puzzle_string.index('*')
        self.previous_puzzle = previous_puzzle
        self.depth = depth

    def isSolved(self):
        return self.puzzle_string == "12345678*"

# 1 2 *
# 4 5 3
# 7 8 6

    def move_right(self):
        return self.blank_index in [0,1,3,4,6,7]

    def move_left(self):
        return self.blank_index in [1,2,4,5,7,8]

    def move_up(self):
        return self.blank_index in range(3,9)
        
    def move_down(self):
        return self.blank_index in range(0,6)

    # Switch the blank tile for the tile in the direction specified
    def shift(self, direction):
        new_position = list(self.puzzle_string)
        new_position[self.blank_index], new_position[self.blank_index + direction] = new_position[self.blank_index + direction], new_position[self.blank_index]
        return SlidePuzzle(puzzle_string=''.join(new_position), previous_puzzle=self, depth=self.depth + 1)

    def print_history(self):
        if self.previous_puzzle:
            self.previous_puzzle.print_history()
        print(self, end='\n\n')

    def __str__(self):
        return self.puzzle_string[:3] + "\n" + self.puzzle_string[3:6] + "\n" + self.puzzle_string[6:]


# Converts a string like:
# 1 2 3
# 4 5 6
# 7 8 *
# to a string we can manipulate easily:
# 12345678*
# and then creates a slide puzzle_string object with the new string
def input_to_slide_puzzle(input_string):
    return SlidePuzzle(puzzle_string=''.join([x.strip() for x in input_string.split()]))