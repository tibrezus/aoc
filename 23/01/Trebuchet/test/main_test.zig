const std = @import("std");
const main = @import("../src/main.zig");

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

        const first_digit_opt = main.findDigit(line, true);
        const last_digit_opt = main.findDigit(line, false);

        if (first_digit_opt != null and last_digit_opt != null) {
            const first_digit = first_digit_opt.?;
            const last_digit = last_digit_opt.?;
            sum += first_digit * 10 + last_digit;
        }
    }
    try stdout.print("Sum: {}\n", .{sum});
    std.testing.expectEqual(sum, 143);
}
