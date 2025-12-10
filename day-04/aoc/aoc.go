package aoc

import (
	"strings"
)

const (
	EMPTY      = 0
	PAPER_ROLL = 1
)

// / Assumes input matching ([\.@]+\n)+
func ParseInput(input string) [][]uint8 {
	lines := strings.Split(strings.Trim(input, "\n "), "\n")

	rows := make([][]uint8, len(lines))

	lookup := [256]uint8{}
	lookup['.'] = EMPTY
	lookup['@'] = PAPER_ROLL

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
			isPaperRoll := grid[row][col] == PAPER_ROLL

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

			if grid[y][x] == PAPER_ROLL {
				adjacent += 1

				if adjacent == 4 {
					return false
				}
			}
		}
	}

	return true
}

const MAX_LOOP = 100_000

func SolvePartTwo(input string) int {
	grid := ParseInput(input)

	if len(grid) == 0 {
		return 0
	}

	directions := []int{-1, 0, 1}
	height := len(grid)
	width := len(grid[0])
	removedPaperRollCount := 0

	for range MAX_LOOP {
		numRemoved := removeReachablePaperRolls(grid, height, width, directions)
		removedPaperRollCount += numRemoved

		if numRemoved == 0 {
			break
		}
	}

	return removedPaperRollCount
}

type Coord struct {
	row int
	col int
}

// Removes reachable paper rolls from the grid and returns the number of paper rolls removed.
// **Note**: Updates grid in-place
func removeReachablePaperRolls(grid [][]uint8, height int, width int, directions []int) int {
	reachablePaperRolls := 0

	var updates []Coord

	for row := range len(grid) {
		for col := range len(grid[row]) {
			isPaperRoll := grid[row][col] == PAPER_ROLL

			if isPaperRoll && reachable(grid, row, col, height, width, directions) {
				reachablePaperRolls += 1
				updates = append(updates, Coord{row, col})
			}
		}
	}

	for _, update := range updates {
		grid[update.row][update.col] = EMPTY
	}

	return reachablePaperRolls
}
