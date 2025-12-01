const std = @import("std");

fn trimWhitespace(s: []const u8) []const u8 {
    var i: usize = 0;
    while (i < s.len) {
        const c = s[i];
        if (c != ' ' and c != '\t' and c != '\r' and c != '\n') break;
        i += 1;
    }
    var j: usize = s.len;
    while (j > i) {
        const c = s[j - 1];
        if (c != ' ' and c != '\t' and c != '\r' and c != '\n') break;
        j -= 1;
    }
    return s[i..j];
}

pub fn part1(allocator: std.mem.Allocator, input: []const u8) !void {
    _ = allocator;

    var start: i32 = 50;
    var zero_count: u32 = 0;
    var lines = std.mem.splitSequence(u8, input, "\n");

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        std.debug.print("Processing: {s}\n", .{line});

        if (std.mem.startsWith(u8, line, "R")) {
            const raw = trimWhitespace(line[1..]);
            const value = try std.fmt.parseInt(i32, raw, 10);
            start += value;
        } else if (std.mem.startsWith(u8, line, "L")) {
            const raw = trimWhitespace(line[1..]);
            const value = try std.fmt.parseInt(i32, raw, 10);
            start -= value;
        }

        // Wrap into 0..99 correctly (handles negatives like -18 -> 82)
        start = @mod(start, 100);
        if (start < 0) start += 100;
        
        if (start == 0) {
            zero_count += 1;
        }
        
        std.debug.print("  Result: {d}\n", .{start});
    }

    std.debug.print("Final result: {d}\n", .{start});
    std.debug.print("Times value was 0: {d}\n", .{zero_count});
}

pub fn part2(allocator: std.mem.Allocator, input: []const u8) !void {
    _ = allocator;

    std.debug.print("Input:\n{s}\n", .{input});
    std.debug.print("Day 1 Part 2 solution\n", .{});
}
