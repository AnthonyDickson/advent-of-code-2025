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

fn solve_part_two(input: &str) -> u64 {
    let mut times_pointing_at_zero = 0;
    let mut current_angle = 50;
    println!("The dial starts by pointing at {current_angle}");

    for line in input.lines() {
        let angle = parse_angle(line);

        let times_passing_zero = count_times_passed_zero(current_angle, angle);
        times_pointing_at_zero += times_passing_zero;

        current_angle = (current_angle + angle) % 100;
        if current_angle < 0 {
            current_angle += 100
        }

        if current_angle == 0 {
            times_pointing_at_zero += 1;
        }

        print!("The dial is rotated {line} to point at {current_angle}");

        if times_passing_zero > 0 {
            println!("; during it's rotation it passed zero {times_passing_zero} times.");
        } else {
            println!(".");
        }
        println!("{times_pointing_at_zero}")
    }

    println!("");

    times_pointing_at_zero
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

fn count_times_passed_zero(current_angle: i64, delta_angle: i64) -> u64 {
    let count = if delta_angle < 0 {
        if current_angle + delta_angle < 0 {
            let count: u64 = ((current_angle + delta_angle) / 100)
                .abs()
                .try_into()
                .unwrap();
            count + 1
        } else {
            0
        }
    } else {
        ((current_angle + delta_angle) / 100).try_into().unwrap()
    };

    let starts_on_zero = current_angle == 0;
    let ends_on_zero = (current_angle + delta_angle) % 100 == 0;

    let count = if count > 0 && starts_on_zero {
        count - 1
    } else {
        count
    };
    let count = if count > 0 && ends_on_zero {
        count - 1
    } else {
        count
    };

    count
}

#[cfg(test)]
mod tests {
    use crate::{count_times_passed_zero, parse_angle, solve_part_one, solve_part_two};

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

            assert_eq!(
                actual, expected,
                "failed on input {input}, expect {expected} but got {actual}"
            );
        }
    }

    #[test]
    fn counts_times_passing_zero() {
        let cases = [
            (50, -68, 1),
            (82, -30, 0),
            (52, 48, 0),
            (0, -5, 0),
            (95, 60, 1),
            (55, -55, 0),
            (0, -1, 0),
            (99, -99, 0),
            (0, 14, 0),
            (14, -82, 1),
            (50, 1000, 10),
            (50, -1000, 10),
            (58, 808, 8),
            (0, -988, 9),
            (0, 100, 0),
            (0, -100, 0),
            (0, -988, 9),
        ];

        for (current_angle, delta_angle, expected) in cases {
            let actual = count_times_passed_zero(current_angle, delta_angle);

            assert_eq!(
                actual, expected,
                "failed for input {current_angle}, {delta_angle}: expected {expected} but got {actual}"
            )
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
        let expected = 6;

        let actual = solve_part_two(input);

        assert_eq!(actual, expected, "failed on input \"{input}\"")
    }
}
