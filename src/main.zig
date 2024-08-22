const std = @import("std");

const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});

fn error_callback(@"error": c_int, description: [*c]const u8) callconv(.C) void {
    std.debug.print("{s}\n", .{description});
    _ = @"error";
}

fn framebuffer_size_callback(_: ?*c.GLFWwindow, width: c_int, height: c_int) callconv(.C) void {
    c.glViewport(0, 0, width, height);
}

fn processInput(window: *c.GLFWwindow) void {
    if (c.glfwGetKey(window, c.GLFW_KEY_ESCAPE) == c.GLFW_PRESS)
        c.glfwSetWindowShouldClose(window, c.GLFW_TRUE);
}

pub fn main() void {
    // Set error callback
    if (c.glfwSetErrorCallback(error_callback) != null) {
        std.debug.print("glfwSetErrorCallback failed\n", .{});
        return;
    }

    if (c.glfwInit() != c.GLFW_TRUE) {
        std.debug.print("glfwInit failed\n", .{});
        return;
    }

    defer c.glfwTerminate();

    // Window hints
    // OpenGL 4.6
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 4);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 6);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);

    // Create window
    const window: *c.GLFWwindow = c.glfwCreateWindow(800, 600, "My Title", null, null) orelse {
        std.debug.print("glfwCreateWindow failed\n", .{});
        return;
    };

    // Defer runs stuff when the function returns or ends I guess
    defer c.glfwDestroyWindow(window);

    c.glfwMakeContextCurrent(window);

    if (c.glfwSetFramebufferSizeCallback(window, framebuffer_size_callback) != null) {
        std.debug.print("glfwSetFramebufferSizeCallback failed\n", .{});
        return;
    }

    if (c.gladLoadGL() == 0) {
        std.debug.print("Failed to initialize GLAD\n", .{});
        return;
    }

    c.glViewport(0, 0, 800, 600);

    // render loop
    while (c.glfwWindowShouldClose(window) == c.GLFW_FALSE) {
        // input
        processInput(window);

        // rendering commands here
        // check and call events and swap the buffers
        c.glfwPollEvents();
        c.glfwSwapBuffers(window);

        // color
        c.glClearColor(0.2, 0.3, 0.3, 1.0);
        c.glClear(c.GL_COLOR_BUFFER_BIT);
    }
}
