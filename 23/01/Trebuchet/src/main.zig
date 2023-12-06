const std = @import("std");

pub fn main() !void {
    // load the inout file
    const stdout = std.io.getStdOut().writer();
    var file = try std.fs.cwd().openFile("data/input", .{});
    defer file.close();

    // Initialize a variable to hold the sum.
    var sum_digit: u32 = 0;

    var sum_real: u32 = 0;

    // Create allocator to allocate memory for each line of the file.
    var allocator = std.heap.page_allocator;

    // Create a buffer to hold each line of the file.
    var buffer = try allocator.alloc(u8, 4096);
    defer allocator.free(buffer);


    // Read each line of the file until EOF (End of File) is reached.
    while (true) {
        const lineOpt = try file.reader().readUntilDelimiterOrEof(buffer, '\n');
        if (lineOpt == null) // EOF reached.
            break;

        const line = lineOpt.?;

        // Find the first and last digits in the line.
        const first_digit_opt = findDigit(line, true);
        const last_digit_opt = findDigit(line, false);
        const first_real_opt = findReal(line, true);
        const last_real_opt = findReal(line, false);

        // If both first and last digits are found, combine and add them to the sum.
        if (first_digit_opt != null and last_digit_opt != null) {
            const first_digit = first_digit_opt.?;
            const last_digit = last_digit_opt.?;
            sum_digit += first_digit * 10 + last_digit;
        }

        if (first_real_opt != null and last_real_opt != null) {
            const first_real = first_real_opt.?;
            const last_real = last_real_opt.?;
            sum_real += first_real * 10 + last_real;
        }
    }

    // Output the total sum to standard output.
    try stdout.print("Digit sum of calibration values: {}\n", .{sum_digit});
    try stdout.print("Real sum of calibration values: {}\n", .{sum_real});
}

// Function to find a digit in a line of text.
// If 'FindFirst' is true, it find the first digit; otherwise, it finds the last digit.
fn findDigit(line: []const u8, findFirst: bool) ?u8 {
    if (findFirst) {
        // Loop trough each caracter in the line and find the first digit.
        for (line) |char| {
            if (char >= '0' and char <= '9') {
                // Return the digit as a number.
                return char - '0';
            }
        }
    } else {
        // Start from the end of the line and move backwards to find the last digit.
        var i = line.len;
        while (i > 0) : (i -= 1) {
            if (line[i - 1] >= '0' and line[i - 1] <= '9') {
                // Return the digit as a number.
                return line[i - 1] - '0';
            }
        }
    }
    return null;
}

fn findReal(line: []const u8, findFirst: bool) ?u8 {
    const DigitPair = struct {
        key: []const u8,
        value: u8,
    };
    
    const digitMap = [_]DigitPair{
        DigitPair{ .key = "zero", .value = 0 },
        DigitPair{ .key = "one", .value = 1 },
        DigitPair{ .key = "two", .value = 2 },
        DigitPair{ .key = "three", .value = 3 },
        DigitPair{ .key = "four", .value = 4 },
        DigitPair{ .key = "five", .value = 5 },
        DigitPair{ .key = "six", .value = 6 },
        DigitPair{ .key = "seven", .value = 7 },
        DigitPair{ .key = "eight", .value = 8 },
        DigitPair{ .key = "nine", .value = 9 },
    };

    if (findFirst) {
        for (digitMap) |pair| {
            if (std.mem.indexOf(u8, line, pair.key)) |_| {
                return pair.value;
            }
        }
        // Fallback to numerical digits
        return findDigit(line, true);
    } else {
        for (digitMap) |pair| {
            if (std.mem.lastIndexOf(u8, line, pair.key)) |_| {
                return pair.value;
            }
        }
        // Fallback to numerical digits
        return findDigit(line, false);
    }
    return null;
}

test "Test using digit file" {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Opening file...\n", .{});
    var file = try std.fs.cwd().openFile("data/digit", .{});
    defer file.close();

    var sum: u32 = 0;

    var allocator = std.heap.page_allocator;

    var buffer = try allocator.alloc(u8, 4096);
    defer allocator.free(buffer);

    while (true) {
        const lineOpt = try file.reader().readUntilDelimiterOrEof(buffer, '\n');
        if (lineOpt == null) break;

        const line = lineOpt.?;

        const first_digit_opt = findDigit(line, true);
        const last_digit_opt = findDigit(line, false);

        if (first_digit_opt != null and last_digit_opt != null) {
            const first_digit = first_digit_opt.?;
            const last_digit = last_digit_opt.?;
            sum += first_digit * 10 + last_digit;
        }
    }
    try stdout.print("Sum: {}\n", .{sum});
    try std.testing.expectEqual(sum, 142);
}

test "Test using real file" {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Opening file...\n", .{});
    var file = try std.fs.cwd().openFile("data/real", .{});
    defer file.close();

    var sum: u32 = 0;

    var allocator = std.heap.page_allocator;

    var buffer = try allocator.alloc(u8, 4096);
    defer allocator.free(buffer);

    while (true) {
        const lineOpt = try file.reader().readUntilDelimiterOrEof(buffer, '\n');
        if (lineOpt == null) break;

        const line = lineOpt.?;

        const first_digit_opt = findReal(line, true);
        const last_digit_opt = findReal(line, false);

        if (first_digit_opt != null and last_digit_opt != null) {
            const first_digit = first_digit_opt.?;
            const last_digit = last_digit_opt.?;
            sum += first_digit * 10 + last_digit;
        }
    }
    try stdout.print("Sum: {}\n", .{sum});
    try std.testing.expectEqual(sum, 281);
}
