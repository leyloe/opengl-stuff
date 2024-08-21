const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.host;
    const optimize = std.builtin.OptimizeMode.ReleaseSmall;

    const exe = b.addExecutable(.{
        .name = "main",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .single_threaded = true,
        .strip = true,
        .optimize = optimize,
    });

    exe.linkLibC();
    exe.linkSystemLibrary("glfw3");
    exe.linkSystemLibrary("gl");

    b.installArtifact(exe);
}
