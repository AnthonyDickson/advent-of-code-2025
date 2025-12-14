import enum


def main():
    with open("input.txt", "r") as f:
        input = f.read()

    grid = parse(input)
    print(solve_part_one(grid))
    print(solve_part_two(input))


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
    return [list(map(Cell, line)) for line in input.splitlines()]


def solve_part_one(grid: Grid) -> int:
    num_splits = 0

    for row, line in enumerate(grid):
        for col, cell in enumerate(line):
            match cell:
                case Cell.Start:
                    grid[row + 1][col] = Cell.Beam
                case Cell.Splitter if row > 1 and grid[row - 1][col] == Cell.Beam:
                    num_splits += 1
                    grid[row][col - 1] = Cell.Beam
                    grid[row][col + 1] = Cell.Beam
                case Cell.Empty if row > 1 and grid[row - 1][col] == Cell.Beam:
                    grid[row][col] = Cell.Beam

    # print_grid(grid)

    return num_splits


def solve_part_two(_input: str) -> int:
    return 0


if __name__ == "__main__":
    main()
