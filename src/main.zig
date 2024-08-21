const std = @import("std");

const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});

fn error_callback(@"error": c_int, description: [*c]const u8) callconv(.C) void {
    std.debug.print("{s}\n", .{description});
    _ = @"error";
}

pub fn main() !void {
    const prev_error = c.glfwSetErrorCallback(error_callback);

    if (prev_error != null) {
        std.debug.print("glfwSetErrorCallback failed\n", .{});
        return;
    }

    std.debug.print("initializing glfw\n", .{});

    if (c.glfwInit() != c.GLFW_TRUE) {
        std.debug.print("glfwInit failed\n", .{});
        return;
    }

    defer c.glfwTerminate();

    std.debug.print("glfw initialized\n", .{});

    const window = c.glfwCreateWindow(640, 480, "My Title", null, null);

    if (window == null) {
        std.debug.print("glfwCreateWindow failed\n", .{});
        return;
    }

    c.glfwMakeContextCurrent(window);

    if (c.gladLoadGLLoader(@ptrCast(&c.glfwGetProcAddress)) == 0) {
        std.debug.print("Failed to initialize GLAD\n", .{});
        return;
    }

    while (c.glfwWindowShouldClose(window) == c.GLFW_FALSE) {
        c.glClear(c.GL_COLOR_BUFFER_BIT);

        c.glfwSwapBuffers(window);

        c.glfwPollEvents();
    }
}
