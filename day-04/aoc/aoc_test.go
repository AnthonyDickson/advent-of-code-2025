package aoc_test

import (
	"reflect"
	"testing"

	"github.com/anthonydickson/advent-of-code-2025/aoc"
)

const example_input = `..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.`

func TestParseInput(t *testing.T) {
	expected := [][]uint8{
		{0, 0, 1, 1, 0, 1, 1, 1, 1, 0},
		{1, 1, 1, 0, 1, 0, 1, 0, 1, 1},
		{1, 1, 1, 1, 1, 0, 1, 0, 1, 1},
		{1, 0, 1, 1, 1, 1, 0, 0, 1, 0},
		{1, 1, 0, 1, 1, 1, 1, 0, 1, 1},
		{0, 1, 1, 1, 1, 1, 1, 1, 0, 1},
		{0, 1, 0, 1, 0, 1, 0, 1, 1, 1},
		{1, 0, 1, 1, 1, 0, 1, 1, 1, 1},
		{0, 1, 1, 1, 1, 1, 1, 1, 1, 0},
		{1, 0, 1, 0, 1, 1, 1, 0, 1, 0},
	}

	actual := aoc.ParseInput(example_input)

	if !reflect.DeepEqual(expected, actual) {
		t.Errorf("expected\n%v\ngot\n%v", expected, actual)
	}
}

func BenchmarkParseInput(b *testing.B) {
	for b.Loop() {
		aoc.ParseInput(example_input)
	}
}

func TestPartOne(t *testing.T) {
	tests := []struct {
		name     string
		input    string
		expected int
	}{
		{"Example input", example_input, 13},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			actual := aoc.SolvePartOne(tt.input)

			if actual != tt.expected {
				t.Errorf("failed for %s %q: expected %d, got %d", tt.name, tt.input, tt.expected, actual)
			}
		})
	}
}

func BenchmarkSolvePartOne(b *testing.B) {
	for b.Loop() {
		aoc.SolvePartOne(example_input)
	}
}

func TestPartTwo(t *testing.T) {
	tests := []struct {
		name     string
		input    string
		expected int
	}{
		{"example 1", "test input", 0},
		// {"example 2", "other input", 42},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			actual := aoc.SolvePartTwo(tt.input)

			if actual != tt.expected {
				t.Errorf("failed for %s %q: expected %d, got %d", tt.name, tt.input, tt.expected, actual)
			}
		})
	}
}
