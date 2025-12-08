const std = @import("std");
const day01 = @import("solutions/2025/day01.zig");
const day02 = @import("solutions/2025/day02.zig");

fn printUsage() void {
    std.debug.print(
        \\Usage: aoc <year> <day> <part> [-i/--input=<input_path>]
        \\Arguments:
        \\  year        Year of the challenge (e.g., 2025)
        \\  day         Day number (1-25)
        \\  part        Part number (1 or 2)
        \\Options:
        \\  -i, --input Path to input file (default: inputs/<year>/day<day>.txt)
        \\
    , .{});
}
const Config = struct {
    year: u32,
    day: u8,
    part: u8,
    input_path: ?[]const u8,
};

fn parseArgs(allocator: std.mem.Allocator) !Config {
    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    // Skip program name
    _ = args.skip();

    var positional_args = std.ArrayList([]const u8){};
    defer positional_args.deinit(allocator);

    var input_path: ?[]const u8 = null;

    while (args.next()) |arg| {
        if (std.mem.startsWith(u8, arg, "-i=")) {
            input_path = arg[3..];
        } else if (std.mem.startsWith(u8, arg, "--input=")) {
            input_path = arg[8..];
        } else if (std.mem.eql(u8, arg, "-i") or std.mem.eql(u8, arg, "--input")) {
            input_path = args.next() orelse {
                std.debug.print("Error: -i/--input requires a value\n", .{});
                return error.MissingInputValue;
            };
        } else {
            try positional_args.append(allocator, arg);
        }
    }

    if (positional_args.items.len < 3) {
        printUsage();
        if (positional_args.items.len < 1) return error.MissingYear;
        if (positional_args.items.len < 2) return error.MissingDay;
        if (positional_args.items.len < 3) return error.MissingPart;
    }

    const year_str = positional_args.items[0];
    const year = try std.fmt.parseInt(u32, year_str, 10);

    const day_str = positional_args.items[1];
    const day = try std.fmt.parseInt(u8, day_str, 10);
    if (day < 1 or day > 25) {
        std.debug.print("Error: Day must be between 1 and 25\n", .{});
        return error.InvalidDay;
    }

    const part_str = positional_args.items[2];
    const part = try std.fmt.parseInt(u8, part_str, 10);
    if (part != 1 and part != 2) {
        std.debug.print("Error: Part must be 1 or 2\n", .{});
        return error.InvalidPart;
    }

    return Config{
        .year = year,
        .day = day,
        .part = part,
        .input_path = input_path,
    };
}

fn readFile(allocator: std.mem.Allocator, file_path: []const u8) ![]const u8 {
    const file = std.fs.cwd().openFile(file_path, .{}) catch |err| {
        switch (err) {
            error.FileNotFound => {
                std.debug.print("Error: Input file '{s}' not found.\n", .{file_path});
                std.debug.print("Please create the file or use -i/--input to specify a different path.\n", .{});
                return error.FileNotFound;
            },
            else => return err,
        }
    };
    defer file.close();

    const file_size = try file.getEndPos();
    const buffer = try allocator.alloc(u8, file_size);

    const bytes_read = try file.readAll(buffer);
    if (bytes_read != file_size) {
        return error.IncompleteRead;
    }

    return buffer;
}

fn runSolution(allocator: std.mem.Allocator, input: []const u8, day: u8, part: u8) !void {
    switch (day) {
        1 => {
            if (part == 1) {
                try day01.part1(allocator, input);
            } else {
                try day01.part2(allocator, input);
            }
        },
        2 => {
            if (part == 1) {
                try day02.part1(allocator, input);
            } else {
                try day02.part2(allocator, input);
            }
        },
        else => {
            std.debug.print("Day {d} not implemented yet\n", .{day});
            return error.DayNotImplemented;
        },
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const config = parseArgs(allocator) catch |err| {
        if (err == error.MissingYear or err == error.MissingDay or err == error.MissingPart) {
            std.process.exit(1);
        }
        return err;
    };

    std.debug.print("Advent of Code {d} - Day {d} - Part {d}\n", .{ config.year, config.day, config.part });

    var allocated_buffer: ?[]u8 = null;
    const input_path = config.input_path orelse blk: {
        const buffer = try allocator.alloc(u8, 256);
        allocated_buffer = buffer;
        const path = try std.fmt.bufPrint(buffer, "inputs/{d}/day{d:0>2}.txt", .{ config.year, config.day });
        break :blk path;
    };
    defer if (allocated_buffer) |buffer| allocator.free(buffer);

    const input = readFile(allocator, input_path) catch |err| {
        if (err == error.FileNotFound) {
            std.process.exit(1);
        }
        return err;
    };
    defer allocator.free(input);

    std.debug.print("Using input file: {s}\n", .{input_path});

    try runSolution(allocator, input, config.day, config.part);
}
