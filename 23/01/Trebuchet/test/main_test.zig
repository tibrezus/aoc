const std = @import("std");
const main = @import("../src/main.zig");

test "Test using example file" {
    const stdout = std.io.getStdOut().writer();
    var file = try std.fs.cwd().openFile("example", .{ .read = true });
    defer file.close();

    var sum: u32 = 0;

    while (try file.reader().readUntilDelimiter(&std.heap.page_allocator, "\n")) |line| {
        const first_digit = main.findDigit(line, true);
        const last_digit = main.findDigit(line, false);

        if (first_digit and last_digit) {
            const first = first_digit.?;
            const last = last_digit.?;
            sum += first * 10 + last;
        }
    }

    std.testing.expectEqual(sum, 143);
}
