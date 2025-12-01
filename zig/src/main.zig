const std = @import("std");
const day01 = @import("solutions/2025/day01.zig");

fn printUsage() void {
    std.debug.print(
        \\Usage: aoc <year> <part> [-i/--input=<input_path>]
        \\Arguments:
        \\  year        Year of the challenge (e.g., 2024)
        \\  part        Part number (1 or 2)
        \\Options:
        \\  -i, --input Path to input file (default: inputs/<year>/day<day>.txt)
        \\
    , .{});
}
const Config = struct {
    year: u32,
    part: u8,
    input_path: ?[]const u8,
};

fn parseArgs(allocator: std.mem.Allocator) !Config {
    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    // Skip program name
    _ = args.skip();

    // Parse year
    const year_str = args.next() orelse {
        printUsage();
        return error.MissingYear;
    };
    const year = try std.fmt.parseInt(u32, year_str, 10);

    // Parse part
    const part_str = args.next() orelse {
        printUsage();
        return error.MissingPart;
    };
    const part = try std.fmt.parseInt(u8, part_str, 10);
    if (part != 1 and part != 2) {
        std.debug.print("Error: Part must be 1 or 2\n", .{});
        return error.InvalidPart;
    }

    // Parse optional input path
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
        }
    }

    return Config{
        .year = year,
        .part = part,
        .input_path = input_path,
    };
}

fn readFile(allocator: std.mem.Allocator, file_path: []const u8) ![]const u8 {
    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    const file_size = try file.getEndPos();
    const buffer = try allocator.alloc(u8, file_size);

    const bytes_read = try file.readAll(buffer);
    if (bytes_read != file_size) {
        return error.IncompleteRead;
    }

    return buffer;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const config = parseArgs(allocator) catch |err| {
        if (err == error.MissingYear or err == error.MissingPart) {
            std.process.exit(1);
        }
        return err;
    };

    std.debug.print("Advent of Code {d} - Part {d}\n", .{ config.year, config.part });

    const input_path = config.input_path orelse blk: {
        const buffer = try allocator.alloc(u8, 256);
        const path = try std.fmt.bufPrint(buffer, "inputs/{d}/day01.txt", .{config.year});
        break :blk path;
    };
    defer if (config.input_path == null) allocator.free(input_path);

    const input = try readFile(allocator, input_path);
    defer allocator.free(input);

    std.debug.print("Using input file: {s}\n", .{input_path});

    if (config.part == 1) {
        try day01.part1(allocator, input);
    } else {
        try day01.part2(allocator, input);
    }
}
