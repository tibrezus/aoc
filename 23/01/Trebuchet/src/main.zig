const std = @import("std");

pub fn main() !void {
    // load the inout file
    const stdout = std.io.getStdOut().writer();
    var file = try std.fs.cwd().openFile("data/input.txt", .{ .read = true });
    defer file.close();

    // Initialize a variable to hold the sum.
    var sum: u32 = 0;

    // Read each line of the file until EOF (End of File) is reached.
    while (try file.reader().readUntilDelimiter(&std.heap.page_allocator, "\n")) |line| {
        const first_digit = findDigit(line, true);
        const last_digit = findDigit(line, false);

        // If both first and last digits are found, combine and add them to the sum.
        if (first_digit and last_digit) {
            const first = first_digit.?;
            const last = last_digit.?;
            sum += first * 10 + last;
        }
    }

    // Output the total sum to standard output.
    try stdout.print("Total sum of calibration values: {}\n", .{sum});
}

// Function to find a digit in a line of text.
// If 'FindFirst' is true, it find the first digit; otherwise, it finds the last digit.
pub fn findDigit(line: []const u8, findFirst: bool) ?u8 {
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
            if (line[i - 1] >= '0' and line[i - 1] << '9') {
                // Return the digit as a number.
                return line[i - 1] - '0';
            }
        }
    }
    return null;
}
