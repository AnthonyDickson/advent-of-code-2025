const std = @import("std");

const Allocator = std.mem.Allocator;

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

    const parsed_input = try parse_input(allocator, input);
    defer allocator.free(parsed_input.regions);

    const part1_result = solve_part_one(parsed_input);

    var stdout_buffer: [STDOUT_BUFFER_SIZE]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.print("{d}\n", .{part1_result});

    try stdout.flush();
}

fn solve_part_one(input: Input) u64 {
    var count_fit: u64 = 0;

    for (input.regions) |region| {
        const max_area = region.width * region.height;

        var total_area: u64 = 0;

        for (region.quantities, input.shapes) |quantity, shape| {
            total_area += shape.occupied_space * quantity;
        }

        if (total_area <= max_area) {
            count_fit += 1;
        }
    }

    return count_fit;
}

const Shape = struct {
    index: u64,
    /// How many squares out of the 3x3 grid are filled by the present?
    occupied_space: u64,
};

const Region = struct {
    width: u64,
    height: u64,
    /// The input will always have 6 shapes
    quantities: [6]u64,
};

const Input = struct { shapes: [6]Shape, regions: []Region };

const ParseError = error{
    /// Shapes should be four lines, but fewer or more were given.
    InvalidLineCount,
    InvalidShape,
    InvalidRegion,
} || Allocator.Error || std.fmt.ParseIntError;

fn parse_input(allocator: Allocator, input: []const u8) ParseError!Input {
    const trimmed = std.mem.trimEnd(u8, input, "\n\r");
    var sections = std.mem.splitSequence(u8, trimmed, "\n\n");

    var shapes: [6]Shape = undefined;
    var regions: []Region = undefined;

    var i: usize = 0;

    while (sections.next()) |section| {
        if (i < 6) {
            const shape = try parse_shape(section);
            shapes[i] = shape;
        } else {
            regions = try parse_regions(allocator, section);
            break;
        }

        i += 1;
    }

    return Input{ .shapes = shapes, .regions = regions };
}

const ParseShapeState = enum {
    in_index,
    in_shape,
};

fn parse_shape(text: []const u8) ParseError!Shape {
    var lines = std.mem.splitScalar(u8, text, '\n');
    var state: ParseShapeState = .in_index;

    var shape = Shape{ .index = 0, .occupied_space = 0 };

    while (lines.next()) |line| {
        switch (state) {
            .in_index => {
                shape.index = @as(usize, @intCast(line[0] - '0'));
                state = .in_shape;
                continue;
            },
            .in_shape => {
                for (line) |char| {
                    if (char == '#') {
                        shape.occupied_space += 1;
                    }
                }
            },
        }
    }

    return shape;
}

fn parse_regions(allocator: Allocator, text: []const u8) ParseError![]Region {
    var lines = std.mem.splitScalar(u8, text, '\n');
    var regions = try std.ArrayList(Region).initCapacity(allocator, 1);

    while (lines.next()) |line| {
        const region = try parse_region(line);
        try regions.append(allocator, region);
    }

    return try regions.toOwnedSlice(allocator);
}

const ParseRegionState = union(enum) {
    /// Parsing the multi-digit width, e.g. '42'
    width: struct { start: usize },
    /// The 'x' in the dimensions, e.g. '42x8'
    dimensions_separator: void,
    /// Parsing the multi-digit height, e.g. '8'
    height: struct { start: usize },
    between_quantities: struct { shape_index: usize },
    /// Parsing the multi-digit quantity for a given shape.
    quantities: struct { start: usize, shape_index: usize },
};

/// Expects that `line` has no trailing newlines.
fn parse_region(line: []const u8) ParseError!Region {
    var state: ParseRegionState = .{ .width = .{ .start = 0 } };

    var region = Region{ .width = 0, .height = 0, .quantities = [_]u64{0} ** 6 };

    for (line, 0..) |char, i| {
        switch (state) {
            .width => |inner_state| {
                if (std.ascii.isDigit(char)) {
                    continue;
                }

                const end = i;
                const start = inner_state.start;

                region.width = try std.fmt.parseInt(u64, line[start..end], 10);

                state = .dimensions_separator;
            },
            .dimensions_separator => {
                if (char == 'x') {
                    continue;
                }

                state = .{ .height = .{ .start = i } };
            },
            .height => |inner_state| {
                if (std.ascii.isDigit(char)) {
                    continue;
                }

                const end = i;
                const start = inner_state.start;

                region.height = try std.fmt.parseInt(u64, line[start..end], 10);

                state = .{ .between_quantities = .{ .shape_index = 0 } };
            },
            .between_quantities => |inner_state| {
                if (!std.ascii.isDigit(char)) {
                    continue;
                }

                state = .{ .quantities = .{ .start = i, .shape_index = inner_state.shape_index } };
            },
            .quantities => |inner_state| {
                const is_last_char = i + 1 == line.len;

                if (std.ascii.isDigit(char) and !is_last_char) {
                    continue;
                }

                const start = inner_state.start;
                const end = if (is_last_char) line.len else i;
                const quantity = try std.fmt.parseInt(u64, line[start..end], 10);
                const shape_index = inner_state.shape_index;

                region.quantities[shape_index] = quantity;
                state = .{ .between_quantities = .{ .shape_index = shape_index + 1 } };
            },
        }
    }

    switch (state) {
        .quantities => |inner_state| {
            const start = inner_state.start;
            const end = line.len;
            const quantity = try std.fmt.parseInt(u64, line[start..end], 10);
            const shape_index = inner_state.shape_index;

            region.quantities[shape_index] = quantity;
            state = .{ .between_quantities = .{ .shape_index = shape_index + 1 } };
        },
        else => {},
    }

    return region;
}

test "parse shape" {
    const input =
        \\1:
        \\###
        \\##.
        \\.##
    ;
    const expected = Shape{ .index = 1, .occupied_space = 7 };

    const actual = parse_shape(input);

    try std.testing.expectEqualDeep(expected, actual);
}

test "parse region" {
    const input = "12x5: 1 0 1 0 2 2";
    const expected = Region{ .width = 12, .height = 5, .quantities = [6]u64{ 1, 0, 1, 0, 2, 2 } };

    const actual = parse_region(input);

    try std.testing.expectEqualDeep(expected, actual);
}

test "parse region multi-digit" {
    const input = "12x5: 1 90 1 0 2 23";
    const expected = Region{ .width = 12, .height = 5, .quantities = [6]u64{ 1, 90, 1, 0, 2, 23 } };

    const actual = parse_region(input);

    try std.testing.expectEqualDeep(expected, actual);
}

test "parse input" {
    const allocator = std.testing.allocator;
    const input =
        \\0:
        \\###
        \\##.
        \\##.
        \\
        \\1:
        \\###
        \\##.
        \\.##
        \\
        \\2:
        \\.##
        \\###
        \\##.
        \\
        \\3:
        \\##.
        \\###
        \\##.
        \\
        \\4:
        \\###
        \\#..
        \\###
        \\
        \\5:
        \\###
        \\.#.
        \\###
        \\
        \\4x4: 0 0 0 0 2 0
        \\12x5: 1 0 1 0 2 2
        \\12x5: 1 0 1 0 3 2
    ;

    var regions = [_]Region{
        Region{ .width = 4, .height = 4, .quantities = [_]u64{ 0, 0, 0, 0, 2, 0 } },
        Region{ .width = 12, .height = 5, .quantities = [_]u64{ 1, 0, 1, 0, 2, 2 } },
        Region{ .width = 12, .height = 5, .quantities = [_]u64{ 1, 0, 1, 0, 3, 2 } },
    };
    const expected = Input{ .shapes = [_]Shape{
        Shape{ .index = 0, .occupied_space = 7 },
        Shape{ .index = 1, .occupied_space = 7 },
        Shape{ .index = 2, .occupied_space = 7 },
        Shape{ .index = 3, .occupied_space = 7 },
        Shape{ .index = 4, .occupied_space = 7 },
        Shape{ .index = 5, .occupied_space = 7 },
    }, .regions = &regions };

    const actual = try parse_input(allocator, input);
    defer allocator.free(actual.regions);

    try std.testing.expectEqualDeep(expected, actual);
}

test "test part one" {
    var regions = [_]Region{
        Region{ .width = 4, .height = 4, .quantities = [_]u64{ 0, 0, 0, 0, 2, 0 } },
        Region{ .width = 12, .height = 5, .quantities = [_]u64{ 1, 0, 1, 0, 2, 2 } },
        Region{ .width = 12, .height = 5, .quantities = [_]u64{ 1, 0, 1, 0, 3, 2 } },
    };
    const input = Input{ .shapes = [_]Shape{
        Shape{ .index = 0, .occupied_space = 7 },
        Shape{ .index = 1, .occupied_space = 7 },
        Shape{ .index = 2, .occupied_space = 7 },
        Shape{ .index = 3, .occupied_space = 7 },
        Shape{ .index = 4, .occupied_space = 7 },
        Shape{ .index = 5, .occupied_space = 7 },
    }, .regions = &regions };
    const expected = 2;

    const actual = solve_part_one(input);

    try std.testing.expectEqual(expected, actual);
}
