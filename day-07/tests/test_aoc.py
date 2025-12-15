import unittest
from unittest import TestCase

from main import Cell, parse, solve_part_one, solve_part_two


def get_example_input() -> str:
    return """.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
"""


class TestParse(TestCase):
    def test_example(self):
        input = get_example_input()
        E, S, X = Cell.Empty, Cell.Start, Cell.Splitter
        expected = [
            [E, E, E, E, E, E, E, S, E, E, E, E, E, E, E],
            [E, E, E, E, E, E, E, X, E, E, E, E, E, E, E],
            [E, E, E, E, E, E, X, E, X, E, E, E, E, E, E],
            [E, E, E, E, E, X, E, X, E, X, E, E, E, E, E],
            [E, E, E, E, X, E, X, E, E, E, X, E, E, E, E],
            [E, E, E, X, E, X, E, E, E, X, E, X, E, E, E],
            [E, E, X, E, E, E, X, E, E, E, E, E, X, E, E],
            [E, X, E, X, E, X, E, X, E, X, E, E, E, X, E],
        ]

        input = get_example_input()

        actual = parse(input)

        self.maxDiff = None
        self.assertListEqual(expected, actual)


class TestAoc(TestCase):
    def test_part_one(self):
        input = parse(get_example_input())
        expected = 21

        actual = solve_part_one(input)

        self.assertEqual(expected, actual)

    def test_part_two(self):
        input = parse(get_example_input())

        actual = solve_part_two(input)

        self.assertEqual(expected, actual)


if __name__ == "__main__":
    unittest.main()
