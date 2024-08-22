const std = @import("std");

const clib = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});

fn error_callback(_: c_int, description: [*c]const u8) callconv(.C) void {
    std.debug.print("{s}\n", .{description});
}

fn framebuffer_size_callback(_: ?*clib.GLFWwindow, width: c_int, height: c_int) callconv(.C) void {
    clib.glViewport(0, 0, width, height);
}

fn processInput(window: *clib.GLFWwindow) void {
    if (clib.glfwGetKey(window, clib.GLFW_KEY_ESCAPE) == clib.GLFW_PRESS)
        clib.glfwSetWindowShouldClose(window, clib.GLFW_TRUE);
}

pub fn main() void {
    // Set error callback
    if (clib.glfwSetErrorCallback(error_callback) != null) {
        std.debug.print("glfwSetErrorCallback failed\n", .{});
        return;
    }

    if (clib.glfwInit() != clib.GLFW_TRUE) {
        std.debug.print("glfwInit failed\n", .{});
        return;
    }

    defer clib.glfwTerminate();

    // Window hints
    // OpenGL 4.6
    clib.glfwWindowHint(clib.GLFW_CONTEXT_VERSION_MAJOR, 4);
    clib.glfwWindowHint(clib.GLFW_CONTEXT_VERSION_MINOR, 6);
    clib.glfwWindowHint(clib.GLFW_OPENGL_PROFILE, clib.GLFW_OPENGL_CORE_PROFILE);

    // Create window
    const window: *clib.GLFWwindow = clib.glfwCreateWindow(800, 600, "My Title", null, null) orelse {
        std.debug.print("glfwCreateWindow failed\n", .{});
        return;
    };

    // Defer runs stuff when the function returns or ends I guess
    defer clib.glfwDestroyWindow(window);

    clib.glfwMakeContextCurrent(window);

    if (clib.glfwSetFramebufferSizeCallback(window, framebuffer_size_callback) != null) {
        std.debug.print("glfwSetFramebufferSizeCallback failed\n", .{});
        return;
    }

    if (clib.gladLoadGL() == 0) {
        std.debug.print("Failed to initialize GLAD\n", .{});
        return;
    }

    clib.glViewport(0, 0, 800, 600);

    // render loop
    while (clib.glfwWindowShouldClose(window) == clib.GLFW_FALSE) {
        // input
        processInput(window);

        // rendering commands here
        // check and call events and swap the buffers
        clib.glfwPollEvents();
        clib.glfwSwapBuffers(window);

        // color
        clib.glClearColor(0.2, 0.3, 0.3, 1.0);
        clib.glClear(clib.GL_COLOR_BUFFER_BIT);
    }
}
