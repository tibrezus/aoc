const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const exe = b.addExecutable("main", "src/main.zig");
    exe.setBuildMode(mode);
    exe.install();

    const test_exe = b.addTest("src/main_test.zig");
    test_exe.setBuildMode(mode);
}