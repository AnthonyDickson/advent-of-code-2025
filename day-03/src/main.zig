const std = @import("std");

const MAX_FILE_SIZE = 1024 * 1024; // 1 MiB
const INPUT_FILENAME = "input.txt";
const STDOUT_BUFFER_SIZE = 1024;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = std.fs.cwd().readFileAlloc(allocator, INPUT_FILENAME, MAX_FILE_SIZE) catch |err| {
        std.debug.print("Could not open {s}: {}\n", .{ INPUT_FILENAME, err });
        return err;
    };

    const part1_result = solve_part_one(input);
    const part2_result = solve_part_two(input);

    var stdout_buffer: [STDOUT_BUFFER_SIZE]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.print("{d}\n", .{part1_result});
    try stdout.print("{d}\n", .{part2_result});

    try stdout.flush();
}

fn solve_part_one(input: []const u8) u64 {
    var total_joltage: u64 = 0;
    var lines_iter = std.mem.splitScalar(u8, input, '\n');

    while (lines_iter.next()) |line| {
        if (line.len == 0) continue;

        total_joltage += get_max_joltage_pair(line);
    }

    return total_joltage;
}

/// Assumes input is a string matching `[1-9]+`.
fn get_max_joltage_pair(battery_bank: []const u8) u64 {
    var left_digit: u8 = '1';
    var right_digit: u8 = '1';

    for (battery_bank, 0..) |joltage, i| {
        const at_penultimate_battery = i + 1 == battery_bank.len;

        if (joltage > left_digit and !at_penultimate_battery) {
            left_digit = joltage;
            right_digit = battery_bank[i + 1];
        } else if (joltage > right_digit) {
            right_digit = joltage;
        }
    }

    const left = @as(u64, @intCast(left_digit - '0'));
    const right = @as(u64, @intCast(right_digit - '0'));

    return left * 10 + right;
}

/// Assumes input is a string matching `[1-9]+`.
fn get_max_joltage_12(battery_bank: []const u8) u64 {
    var digits = [12]u8{ '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1' };

    for (battery_bank, 0..) |joltage, i| {
        const batteries_left = battery_bank.len - i;

        for (0..12) |place| {
            if (batteries_left >= (12 - place) and joltage > digits[place]) {
                digits[place] = joltage;

                for (place + 1..12) |j| {
                    digits[j] = '1';
                }

                break;
            }
        }
    }

    var joltage: u64 = 0;

    for (digits, 1..) |digit, i| {
        const digit_as_int = @as(u64, @intCast((digit - '0')));
        joltage += digit_as_int * std.math.pow(u64, 10, 12 - i);
    }

    return joltage;
}

fn solve_part_two(input: []const u8) u64 {
    var total_joltage: u64 = 0;
    var lines_iter = std.mem.splitScalar(u8, input, '\n');

    while (lines_iter.next()) |line| {
        if (line.len == 0) continue;

        total_joltage += get_max_joltage_12(line);
    }

    return total_joltage;
}

test "test get max joltage pair" {
    const cases = [_]struct { []const u8, u64 }{
        .{ "987654321111111", 98 },
        .{ "811111111111119", 89 },
        .{ "234234234234278", 78 },
        .{ "818181911112111", 92 },
    };

    for (cases) |case| {
        const input, const expected = case;

        const actual = get_max_joltage_pair(input);

        std.testing.expectEqual(expected, actual) catch |err| {
            std.debug.print("failed on input {s}\n", .{input});
            return err;
        };
    }
}

test "test part one" {
    const input =
        \\987654321111111
        \\811111111111119
        \\234234234234278
        \\818181911112111
    ;
    const expected = 357;

    const actual = solve_part_one(input);

    try std.testing.expectEqual(expected, actual);
}

test "test get max joltage 12" {
    const cases = [_]struct { []const u8, u64 }{
        .{ "987654321111111", 987654321111 },
        .{ "811111111111119", 811111111119 },
        .{ "234234234234278", 434234234278 },
        .{ "818181911112111", 888911112111 },
    };

    for (cases) |case| {
        const input, const expected = case;

        const actual = get_max_joltage_12(input);

        std.testing.expectEqual(expected, actual) catch |err| {
            std.debug.print("failed on input {s}\n", .{input});
            return err;
        };
    }
}

test "test part two" {
    const input = "";
    const expected = 0;

    const actual = solve_part_two(input);

    try std.testing.expectEqual(expected, actual);
}
