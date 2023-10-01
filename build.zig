const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.option(std.builtin.Mode, "mode", "") orelse .Debug;

    const mod = b.addModule("bounded", .{ .source_file = .{ .path = "bounded.zig" } });

    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "test.zig" },
        .target = target,
        .optimize = mode,
    });
    unit_tests.addModule("bounded", mod);

    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
