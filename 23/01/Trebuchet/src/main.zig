const std = @import("std");

pub fn main() !void {
    // load the inout file
    const stdout = std.io.getStdOut().writer();
    var file = try std.fs.cwd().openFile("data/input", .{});
    defer file.close();

    // Initialize a variable to hold the sum.
    var sum: u32 = 0;

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

        // If both first and last digits are found, combine and add them to the sum.
        if (first_digit_opt != null and last_digit_opt != null) {
            const first_digit = first_digit_opt.?;
            const last_digit = last_digit_opt.?;
            sum += first_digit * 10 + last_digit;
        }
    }

    // Output the total sum to standard output.
    try stdout.print("Total sum of calibration values: {}\n", .{sum});
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

test "Test using example file" {
    const stdout = std.io.getStdOut().writer();
    var file = try std.fs.cwd().openFile("data/example", .{});
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
    try std.testing.expectEqual(sum, 143);
}
