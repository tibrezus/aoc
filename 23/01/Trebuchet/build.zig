const std = @import("std");

pub fn build(b: *std.Build) void {
    
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    // const mode = b.standardReleaseOptions();
    const exe = b.addExecutable(.{
        .name = "trebuchet",
        .root_source_file = .{ .path = "src/main.zig"},
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);

    const run_step = b.step("run", "Run the program");
    run_step.dependOn(&run_exe.step);

    const test_step = b.step("test", "Run the tests");

    const int_test = b.addTest(.{
        .name = "integration",
        .root_source_file = .{ .path = "src/main.zig"},
        .target = target,
        .optimize = optimize,
    });

    test_step.dependOn(&int_test.step);
}
