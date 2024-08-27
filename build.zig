const std = @import("std");

const C_FILES = &.{ "libraries/src/glad.c", "src/main.c" };

pub fn build(b: *std.Build) void {
    const target = b.host;
    const optimize = std.builtin.OptimizeMode.ReleaseFast;

    const exe = b.addExecutable(.{
        .name = "main",
        .target = target,
        .single_threaded = true,
        .strip = true,
        .optimize = optimize,
    });

    exe.addIncludePath(b.path("libraries/include"));

    exe.addCSourceFiles(.{ .files = C_FILES });

    exe.linkLibC();
    exe.linkSystemLibrary("glfw3");

    b.installArtifact(exe);
}
