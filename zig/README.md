# Advent of Code - Zig

This project contains solutions for Advent of Code challenges written in Zig.

## Project Structure

```
.
├── src/
│   ├── main.zig              # CLI entry point
│   └── solutions/
│       └── 2024/
│           └── day01.zig     # Example solution template
├── inputs/
│   └── 2024/
│       └── day01.txt         # Example input file
└── build.zig
```

## Usage

Build the project:
```bash
zig build
```

Run a solution:
```bash
# Using installed binary
./zig-out/bin/aoc <year> <part> [-i/--input=<input_path>]

# Or via zig build
zig build run -- <year> <part> [-i/--input=<input_path>]
```

### Examples

```bash
# Run 2024 day 1 part 1 with default input
./zig-out/bin/aoc 2024 1

# Run 2024 day 1 part 2 with custom input
./zig-out/bin/aoc 2024 2 -i inputs/2024/day01.txt

# Using --input flag
./zig-out/bin/aoc 2024 1 --input=custom_input.txt
```

## Adding New Solutions

1. Create a new solution file: `src/solutions/<year>/day<XX>.zig`
2. Implement `part1` and `part2` functions
3. Add your input file: `inputs/<year>/day<XX>.txt`
4. Update main.zig to dispatch to your solution

## Testing

Run tests:
```bash
zig build test
```

## Template Solution

Each day's solution should follow this structure:

```zig
const std = @import("std");

pub fn part1(allocator: std.mem.Allocator, input: []const u8) !void {
    // Your solution here
}

pub fn part2(allocator: std.mem.Allocator, input: []const u8) !void {
    // Your solution here
}
```
