const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "trebuchet",
        .root_source_file = .{ .path = "src/main.zig"},
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const exe_test = b.addTest(.{
        .name = "trebuchet_test",
        .root_source_file = .{ .path = "src/main.zig"},
        .target = target,
        .optimize = optimize,
    });

    const run_exe_test = b.addRunArtifact(exe_test);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_exe_test.step);
}