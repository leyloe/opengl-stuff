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

    exe.addIncludePath(b.path("Libraries/include"));

    // Sources
    exe.addCSourceFile(.{ .file = b.path("Libraries/src/glad.c") });

    // Libraries
    exe.linkLibC();
    exe.linkSystemLibrary("glfw3");

    b.installArtifact(exe);
}
