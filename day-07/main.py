import enum
import functools


def main():
    with open("input.txt", "r") as f:
        input = f.read()

    grid = parse(input)
    print(solve_part_one(grid))
    print(solve_part_two(grid))


class Cell(enum.Enum):
    Empty = "."
    Start = "S"
    Splitter = "^"
    Beam = "|"


Grid = list[list[Cell]]


def print_grid(grid: Grid):
    for row in grid:
        row_str = "".join(map(lambda c: c.value, row))
        print(row_str)


def parse(input: str) -> Grid:
    # Every second line is empty and there can be skipped
    return [list(map(Cell, line)) for line in input.splitlines()[0::2]]


def solve_part_one(grid: Grid) -> int:
    num_splits = 0

    for row, line in enumerate(grid):
        for col, cell in enumerate(line):
            match cell:
                case Cell.Splitter if row > 0 and (grid[row - 1][col] == Cell.Beam or grid[row - 1][col] == Cell.Start):
                    grid[row][col - 1] = Cell.Beam
                    grid[row][col + 1] = Cell.Beam
                    num_splits += 1
                case Cell.Empty if row > 0 and grid[row - 1][col] == Cell.Beam:
                    grid[row][col] = Cell.Beam

    return num_splits


def solve_part_two(grid: Grid) -> int:
    @functools.cache
    def count_leaves_depth_first(row: int, col: int) -> int:
        if row == len(grid):
            return 1

        if grid[row][col] != Cell.Splitter:
            return count_leaves_depth_first(row + 1, col)

        return count_leaves_depth_first(row + 1, col - 1) + count_leaves_depth_first(row + 1, col + 1)

    return count_leaves_depth_first(1, grid[1].index(Cell.Splitter))


if __name__ == "__main__":
    main()
