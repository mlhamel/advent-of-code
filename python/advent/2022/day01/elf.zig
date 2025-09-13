const std = @import("std");

pub fn main() void {
//    const stdout = std.io.getStdOut().writer();

    const calories = [_]i32{1000, 2000, 3000, 0, 4000, 0, 5000, 6000, 0, 7000, 8000, 9000, 10000};
    const data = `
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
    `

    for (calories) |calory| {
         std.debug.print("Calory: {}\n", .{calory});
    }

    std.debug.print(data)
}