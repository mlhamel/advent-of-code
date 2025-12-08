const std = @import("std");

fn trimWhitespace(s: []const u8) []const u8 {
    var i: usize = 0;
    while (i < s.len and (s[i] == ' ' or s[i] == '\t' or s[i] == '\r' or s[i] == '\n')) i += 1;
    var j: usize = s.len;
    while (j > i and (s[j - 1] == ' ' or s[j - 1] == '\t' or s[j - 1] == '\r' or s[j - 1] == '\n')) j -= 1;
    return s[i..j];
}

fn pow10_i64(exp: usize) i64 {
    var p: i64 = 1;
    var i: usize = 0;
    while (i < exp) : (i += 1) {
        p *= 10;
    }
    return p;
}

fn splitIntoHalves(item: i64, digits: usize) struct { left: i64, right: i64 } {
    // half = floor(digits / 2). For even digits you'll get equal-digit halves.
    // Example: item=1010, digits=4 -> half=2 -> pow=100 -> left=1010/100=10, right=1010%100=10
    const half = digits / 2;
    const pow = pow10_i64(half);
    return .{ .left = @divTrunc(item, pow), .right = @mod(item, pow) };
}

fn digitsCountLoop(n: i64) usize {
    if (n == 0) return 1;
    var v: i64 = @intCast(n);
    if (v < 0) v = -v; // use i64 to avoid overflow for i32.min
    var cnt: usize = 0;
    while (v != 0) : (v = @divTrunc(v, 10)) {
        cnt += 1;
    }
    return cnt;
}

pub fn processItem(item: i64) ?i64 {
    const digits = digitsCountLoop(item);
    const halves = splitIntoHalves(item, digits);

    if (halves.left == halves.right) {
        std.debug.print("  -> Lucky number! {d} {d}\n", .{ halves.left, halves.right });
        return item;
    } else {
        std.debug.print("  -> Not a lucky number.\n", .{});
        return null;
    }
}

pub fn processRange(first_num_str: []const u8, second_num_str: []const u8) !i64 {
    const start_str = trimWhitespace(first_num_str);
    const end_str = trimWhitespace(second_num_str);

    var result_sum: i64 = 0;

    if (start_str.len == 0 or end_str.len == 0) {
        std.debug.print("Warning: empty number string: '{s}' or '{s}'\n", .{ start_str, end_str });
        return error.EmptyNumberString;
    }

    const start = std.fmt.parseInt(i64, start_str, 10) catch |err| {
        std.debug.print("Error parsing start: '{s}'\n", .{start_str});
        return err;
    };
    const end = std.fmt.parseInt(i64, end_str, 10) catch |err| {
        std.debug.print("Error parsing end: '{s}'\n", .{end_str});
        return err;
    };

    std.debug.print("as int: {d}\n", .{start});
    std.debug.print("as int2: {d}\n", .{end});

    if (start <= end) {
        var v: i64 = start;
        while (v <= end) : (v += 1) {
            const res = processItem(v);
            if (res) |val| {
                result_sum += val;
            }
        }
    } else {
        var v: i64 = start;
        while (v >= end) : (v -= 1) {
            const res = processItem(v);
            if (res) |val| {
                result_sum += val;
            }
        }
    }
    return result_sum;
}

pub fn part1(allocator: std.mem.Allocator, input: []const u8) !void {
    _ = allocator;

    const delim = ",";
    var it = std.mem.splitSequence(u8, input, delim);
    var item_sum: i64 = 0;

    while (it.next()) |token| {
        if (token.len == 0) continue;
        const t = trimWhitespace(token);
        std.debug.print("token: {s}\n", .{t});

        var sub_it = std.mem.splitSequence(u8, t, "-");
        const first_num_str = sub_it.next() orelse {
            std.debug.print("Warning: missing first number in token '{s}'\n", .{t});
            continue;
        };
        const second_num_str = sub_it.next() orelse {
            std.debug.print("Warning: missing second number in token '{s}'\n", .{t});
            continue;
        };

        item_sum += try processRange(first_num_str, second_num_str);
    }

    std.debug.print("Final sum of lucky numbers: {d}\n", .{item_sum});
}

pub fn part2(allocator: std.mem.Allocator, input: []const u8) !void {
    _ = allocator;
    _ = input;
    std.debug.print("Day 2 Part 2: Not yet implemented\n", .{});
}
