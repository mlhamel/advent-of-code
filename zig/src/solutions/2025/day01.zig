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

    var position: i32 = 50;
    var zero_count: i32 = 0;
    var lines = std.mem.splitSequence(u8, input, "\n");

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        std.debug.print("Processing: {s}\n", .{line});
        std.debug.print("  Starting position: {d}\n", .{position});

        var rotation: i32 = 0;
        if (std.mem.startsWith(u8, line, "R")) {
            const raw = trimWhitespace(line[1..]);
            rotation = try std.fmt.parseInt(i32, raw, 10);
        } else if (std.mem.startsWith(u8, line, "L")) {
            const raw = trimWhitespace(line[1..]);
            rotation = -(try std.fmt.parseInt(i32, raw, 10));
        }

        std.debug.print("  Rotation: {d}\n", .{rotation});

        // Count zero crossings based on the R1000 example:
        // R1000 from position 50 hits 0 exactly 10 times during rotation
        // This suggests we count floor(abs_rotation / 100) for complete cycles
        // Plus 1 more if the partial rotation crosses a boundary

        var zero_crossings: i32 = 0;

        if (rotation != 0) {
            const abs_rotation = if (rotation >= 0) rotation else -rotation;

            // Count complete 100-unit cycles
            zero_crossings += @divTrunc(abs_rotation, 100);

            // Check if the remaining partial rotation crosses 0
            const remaining = @mod(abs_rotation, 100);
            if (remaining > 0) {
                if (rotation > 0) {
                    // Clockwise: cross 0 if we go from position to position + remaining > 100
                    if (position + remaining > 100) {
                        zero_crossings += 1;
                    }
                } else {
                    // Counter-clockwise: cross 0 if we go from position > 0 to position - remaining < 0
                    if (position > 0 and position - remaining < 0) {
                        zero_crossings += 1;
                    }
                }
            }
        }

        std.debug.print("  Zero crossings during rotation: {d}\n", .{zero_crossings});
        zero_count += zero_crossings;

        // Update position
        position += rotation;
        position = @mod(position, 100);
        if (position < 0) position += 100;

        // Check if we end at 0 (this is separate from crossings during rotation)
        if (position == 0) {
            zero_count += 1;
            std.debug.print("  Ended at 0, incrementing count\n", .{});
        }

        std.debug.print("  Final position: {d}\n", .{position});
        std.debug.print("  Total zero count so far: {d}\n", .{zero_count});
    }

    std.debug.print("Final answer: {d}\n", .{zero_count});
}
