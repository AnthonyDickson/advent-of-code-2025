use std::fs;

fn main() {
    let input = fs::read_to_string("input.txt").unwrap();

    let part_one_solution = solve_part_one(&input);
    let part_two_solution = solve_part_two(&input);

    println!("{part_one_solution}");
    println!("{part_two_solution}");
}

fn solve_part_one(input: &str) -> i64 {
    let mut times_pointing_at_zero = 0;
    let mut current_angle = 50;

    for line in input.lines() {
        let angle = parse_angle(line);
        current_angle = (current_angle + angle) % 100;

        if current_angle == 0 {
            times_pointing_at_zero += 1;
        }
    }

    times_pointing_at_zero
}

fn solve_part_two(_input: &str) -> i64 {
    return 0;
}

fn parse_angle(angle_string: &str) -> i64 {
    assert!(angle_string.len() >= 2);

    let direction = angle_string.chars().nth(0);
    let angle = angle_string[1..].parse::<i64>().unwrap();

    match direction {
        Some('L') => -angle,
        Some('R') => angle,
        _ => {
            panic!("Invalid char '{direction:?}' for direction, expected 'L' or 'R'");
        }
    }
}

#[cfg(test)]
mod tests {
    use crate::{parse_angle, solve_part_one, solve_part_two};

    #[test]
    fn parses_angle() {
        let cases = [
            ("L68", -68),
            ("L30", -30),
            ("R48", 48),
            ("L5", -5),
            ("R60", 60),
            ("L55", -55),
            ("L1", -1),
            ("L99", -99),
            ("R14", 14),
            ("L82", -82),
        ];

        for (input, expected) in cases {
            let actual = parse_angle(input);

            assert_eq!(actual, expected, "failed on input {input}");
        }
    }

    #[test]
    fn solves_part_one() {
        let input = "L68\n\
            L30\n\
            R48\n\
            L5\n\
            R60\n\
            L55\n\
            L1\n\
            L99\n\
            R14\n\
            L82\n";
        let expected = 3;

        let actual = solve_part_one(input);

        assert_eq!(actual, expected)
    }

    #[test]
    fn solves_part_two() {
        let input = "";
        let expected = 0;

        let actual = solve_part_two(input);

        assert_eq!(actual, expected, "failed on input \"{input}\"")
    }
}
