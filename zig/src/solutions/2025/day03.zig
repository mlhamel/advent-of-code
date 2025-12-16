const std = @import("std");

const Candidat = struct { index: usize, value: i32 };

fn evaluateCandidats(line: []const u8, taken_index: usize, start: usize, first: bool) Candidat {
    var value: Candidat = .{ .index = 0, .value = 0 };

    for (start..line.len) |i| {
        if (i == taken_index) continue;
        if (first and i >= line.len - 1) break; // for first candidat, avoid last char

        const char = line[i];
        const candidat = std.fmt.parseInt(i32, &.{char}, 10) catch continue;

        if (candidat > value.value) {
            value.index = i;
            value.value = candidat;
        }
    }
    return value;
}

pub fn part1(allocator: std.mem.Allocator, input: []const u8) !void {
    _ = allocator;
    var lines = std.mem.splitSequence(u8, input, "\n");
    var lines_sum: i32 = 0;
    while (lines.next()) |line| {
        const first = evaluateCandidats(line, std.math.maxInt(usize), 0, true);
        const second = evaluateCandidats(line, first.index, first.index, false);

        var buf: [2]u8 = undefined;
        const value = std.fmt.bufPrint(buf[0..], "{d}", .{first.value * 10 + second.value}) catch {
            std.debug.print("Error formatting output\n", .{});
            return error.FormattingError;
        };

        const line_value = std.fmt.parseInt(i32, value, 10) catch {
            std.debug.print("Error parsing output\n", .{});
            return error.ParsingError;
        };

        std.debug.print("   Line value: {d}\n", .{line_value});

        lines_sum += line_value;
    }

    std.debug.print("Final sum of line values: {d}\n", .{lines_sum});
}

pub fn part2(allocator: std.mem.Allocator, input: []const u8) !void {
    _ = allocator;
    _ = input;
    std.debug.print("Day 3, Part 2 solution not implemented yet.\n", .{});
}
