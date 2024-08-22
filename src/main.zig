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
    // Error callback
    const prev_error = c.glfwSetErrorCallback(error_callback);

    if (prev_error != null) {
        std.debug.print("glfwSetErrorCallback failed\n", .{});
        return;
    }

    // Initialize GLFW
    std.debug.print("initializing glfw\n", .{});

    if (c.glfwInit() != c.GLFW_TRUE) {
        std.debug.print("glfwInit failed\n", .{});
        return;
    }

    defer c.glfwTerminate();

    std.debug.print("glfw initialized\n", .{});

    // Window hints
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 4);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);

    // Create window
    const window = c.glfwCreateWindow(800, 600, "My Title", null, null);

    if (window == null) {
        std.debug.print("glfwCreateWindow failed\n", .{});
        return;
    }

    defer c.glfwDestroyWindow(window);

    c.glfwMakeContextCurrent(window);

    if (c.gladLoadGL() == 0) {
        std.debug.print("Failed to initialize GLAD\n", .{});
        return;
    }

    // Viewer
    c.glViewport(0, 0, 800, 600);

    c.glClearColor(0.07, 0.13, 0.17, 1.0);
    c.glClear(c.GL_COLOR_BUFFER_BIT);
    c.glfwSwapBuffers(window);

    while (c.glfwWindowShouldClose(window) == c.GLFW_FALSE) {
        c.glfwPollEvents();
    }
}
