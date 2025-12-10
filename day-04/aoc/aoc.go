package aoc

import (
	"strings"
)

// / Assumes input matching ([\.@]+\n)+
func ParseInput(input string) [][]uint8 {
	lines := strings.Split(strings.Trim(input, "\n "), "\n")

	rows := make([][]uint8, len(lines))

	lookup := [256]uint8{}
	lookup['.'] = 0
	lookup['@'] = 1

	for row_i, line := range lines {
		row := make([]uint8, len(line))

		for line_i := 0; line_i < len(line); line_i++ {
			char := line[line_i]
			row[line_i] = lookup[char]
		}

		rows[row_i] = row
	}

	return rows
}

func SolvePartOne(input string) int {
	grid := ParseInput(input)

	if len(grid) == 0 {
		return 0
	}

	directions := []int{-1, 0, 1}
	height := len(grid)
	width := len(grid[0])
	reachablePaperRolls := 0

	for row := range len(grid) {
		for col := range len(grid[row]) {
			isPaperRoll := grid[row][col] == 1

			if isPaperRoll && reachable(grid, row, col, height, width, directions) {
				reachablePaperRolls += 1
			}
		}
	}

	return reachablePaperRolls
}

func reachable(grid [][]uint8, row int, col int, height int, width int, directions []int) bool {
	adjacent := 0

	for _, dy := range directions {
		y := row + dy

		if y < 0 || y >= height {
			continue
		}

		for _, dx := range directions {
			x := col + dx

			if (x < 0 || x >= width) || (y == row && x == col) {
				continue
			}

			if grid[y][x] == 1 {
				adjacent += 1

				if adjacent == 4 {
					return false
				}
			}
		}
	}

	return true
}

func SolvePartTwo(input string) int {
	return 0
}
