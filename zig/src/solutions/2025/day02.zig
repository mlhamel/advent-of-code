const std = @import("std");

const ItemProcessor = fn (item: i64) ?i64;

const Pair = struct {
    first: i64,
    second: i64,
};

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

fn foundDuplicateDigits(item: i64) !bool {
    var buf: [24]u8 = undefined;
    const s = std.fmt.bufPrint(buf[0..], "{}", .{item}) catch {
        std.debug.print("format failed\n", .{});
        return false;
    };

    for (1..s.len / 2 + 1) |pattern_len| {
        // Only consider patterns that divide the string evenly
        if (@mod(s.len, pattern_len) != 0) {
            continue;
        }

        const pattern = s[0..pattern_len];
        var is_repeating = true;

        var pos: usize = pattern_len;
        while (pos < s.len) : (pos += pattern_len) {
            const chunk = s[pos .. pos + pattern_len];
            if (!std.mem.eql(u8, pattern, chunk)) {
                is_repeating = false;
                break;
            }
        }

        if (is_repeating and pattern_len < s.len) {
            std.debug.print("Found repeating pattern '{s}' in item {d}\n", .{ pattern, item });
            return true;
        }
    }

    return false;
}

pub fn processItem(item: i64) ?i64 {
    const digits = digitsCountLoop(item);
    const halves = splitIntoHalves(item, digits);

    if (halves.left == halves.right) {
        return item;
    } else {
        return null;
    }
}

pub fn processItem2(item: i64) ?i64 {
    if (foundDuplicateDigits(item) catch {
        return null;
    }) {
        return item;
    } else {
        return null;
    }
}

pub fn processRange(allocator: std.mem.Allocator, processor: ItemProcessor, first_num_str: []const u8, second_num_str: []const u8) !i64 {
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

    var set = std.AutoArrayHashMap(i64, void).init(allocator);
    defer set.deinit();

    if (start <= end) {
        var v: i64 = start;
        while (v <= end) : (v += 1) {
            const res = processor(v);
            if (res) |val| {
                std.debug.print("Found invalid item: {d}\n", .{val});
                try set.put(val, {});
            }
        }
    } else {
        var v: i64 = start;
        while (v >= end) : (v -= 1) {
            const res = processor(v);
            if (res) |val| {
                std.debug.print("Found invalid item: {d}\n", .{val});
                try set.put(val, {});
            }
        }
    }

    for (set.keys()) |key| {
        result_sum += key;
    }

    std.debug.print("  Processed range {d} to {d}, partial sum: {d}\n", .{ start, end, result_sum });

    return result_sum;
}

pub fn make_pairs(allocator: std.mem.Allocator, input: []const u8) ![]Pair {
    const delim = ",";
    var it = std.mem.splitSequence(u8, input, delim);

    var pairs = std.ArrayList(Pair){};
    defer pairs.deinit(allocator);

    while (it.next()) |token| {
        if (token.len == 0) continue;
        const t = trimWhitespace(token);
        var sub_it = std.mem.splitSequence(u8, t, "-");
        const first_num_str = sub_it.next() orelse {
            std.debug.print("Warning: missing first number in token '{s}'\n", .{t});
            continue;
        };
        const second_num_str = sub_it.next() orelse {
            std.debug.print("Warning: missing second number in token '{s}'\n", .{t});
            continue;
        };

        const first_num = std.fmt.parseInt(i64, first_num_str, 10) catch |err| {
            std.debug.print("Error parsing first number in token '{s}': {s}\n", .{ t, @errorName(err) });
            continue;
        };
        const second_num = std.fmt.parseInt(i64, second_num_str, 10) catch |err| {
            std.debug.print("Error parsing second number in token '{s}': {s}\n", .{ t, @errorName(err) });
            continue;
        };

        const pair = Pair{
            .first = first_num,
            .second = second_num,
        };

        try pairs.append(allocator, pair);
    }
    return try pairs.toOwnedSlice(allocator);
}

pub fn part1(allocator: std.mem.Allocator, input: []const u8) !void {
    var item_sum: i64 = 0;

    const pairs = try make_pairs(allocator, input);
    defer allocator.free(pairs);

    for (pairs) |pair| {
        const first_num_str = std.fmt.allocPrint(allocator, "{d}", .{pair.first}) catch unreachable;
        defer allocator.free(first_num_str);
        const second_num_str = std.fmt.allocPrint(allocator, "{d}", .{pair.second}) catch unreachable;
        defer allocator.free(second_num_str);

        item_sum += try processRange(allocator, processItem, first_num_str, second_num_str);
    }

    std.debug.print("Final sum of lucky numbers: {d}\n", .{item_sum});
}

pub fn part2(allocator: std.mem.Allocator, input: []const u8) !void {
    var item_sum: i64 = 0;

    const pairs = try make_pairs(allocator, input);
    defer allocator.free(pairs);

    for (pairs) |pair| {
        const first_num_str = std.fmt.allocPrint(allocator, "{d}", .{pair.first}) catch unreachable;
        defer allocator.free(first_num_str);
        const second_num_str = std.fmt.allocPrint(allocator, "{d}", .{pair.second}) catch unreachable;
        defer allocator.free(second_num_str);

        item_sum += try processRange(allocator, processItem2, first_num_str, second_num_str);
    }

    std.debug.print("Final sum of lucky numbers: {d}\n", .{item_sum});
}
