const std = @import("std");

pub const glfw = @cImport({
    @cInclude("GLFW/glfw3.h");
});

pub const gl = @cImport({
    @cInclude("GL/gl.h");
});

pub fn main() !void {
    std.debug.print("initializing glfw\n", .{});

    if (glfw.glfwInit() != glfw.GLFW_TRUE) {
        std.debug.print("glfwInit failed\n", .{});
        return;
    }

    defer glfw.glfwTerminate();

    std.debug.print("glfw initialized\n", .{});

    const window = glfw.glfwCreateWindow(640, 480, "My Title", null, null);

    if (window == null) {
        std.debug.print("glfwCreateWindow failed\n", .{});
        return;
    }

    glfw.glfwMakeContextCurrent(window);

    while (glfw.glfwWindowShouldClose(window) == glfw.GLFW_FALSE) {
        gl.glClear(gl.GL_COLOR_BUFFER_BIT);

        glfw.glfwSwapBuffers(window);

        glfw.glfwPollEvents();
    }
}
