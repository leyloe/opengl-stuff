const SCR_WIDTH = 800;
const SCR_HEIGHT = 600;

const vertexShaderSource: ?[*:0]const u8 =
    \\#version 330 core
    \\layout (location = 0) in vec3 aPos;
    \\void main()
    \\{
    \\   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
    \\}
;

const std = @import("std");

const printf = std.c.printf;

const clib = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});

fn error_callback(_: c_int, description: [*c]const u8) callconv(.C) void {
    std.debug.print("{s}\n", .{description});
}

fn framebuffer_size_callback(_: ?*clib.GLFWwindow, width: c_int, height: c_int) callconv(.C) void {
    std.debug.print("the window is being resized to {} {}\n", .{ width, height });
    clib.glViewport(0, 0, width, height);
}

fn processInput(window: *clib.GLFWwindow) void {
    if (clib.glfwGetKey(window, clib.GLFW_KEY_ESCAPE) == clib.GLFW_PRESS)
        clib.glfwSetWindowShouldClose(window, clib.GLFW_TRUE);
}

pub fn main() void {
    if (clib.glfwSetErrorCallback(error_callback) != null) {
        _ = printf("glfwSetErrorCallback failed\n");
        return;
    }

    if (clib.glfwInit() != clib.GLFW_TRUE) {
        _ = printf("glfwInit failed\n");
        return;
    }

    defer clib.glfwTerminate();

    clib.glfwWindowHint(clib.GLFW_CONTEXT_VERSION_MAJOR, 4);
    clib.glfwWindowHint(clib.GLFW_CONTEXT_VERSION_MINOR, 6);
    clib.glfwWindowHint(clib.GLFW_OPENGL_PROFILE, clib.GLFW_OPENGL_CORE_PROFILE);

    const window: *clib.GLFWwindow = clib.glfwCreateWindow(SCR_WIDTH, SCR_HEIGHT, "My Title", null, null) orelse {
        _ = printf("glfwCreateWindow failed\n");
        return;
    };

    defer clib.glfwDestroyWindow(window);

    clib.glfwMakeContextCurrent(window);

    if (clib.glfwSetFramebufferSizeCallback(window, framebuffer_size_callback) != null) {
        _ = printf("glfwSetFramebufferSizeCallback failed\n");
        return;
    }

    if (clib.gladLoadGL() == 0) {
        _ = printf("Failed to initialize GLAD\n");
        return;
    }

    clib.glViewport(0, 0, 800, 600);

    const vertices = [_]f32{
        -0.5, -0.5, 0.0,
        0.5,  -0.5, 0.0,
        0.0,  0.5,  0.0,
    };

    var VBO: u32 = undefined;
    clib.glGenBuffers(1, &VBO);
    clib.glBindBuffer(clib.GL_ARRAY_BUFFER, VBO);
    clib.glBufferData(clib.GL_ARRAY_BUFFER, vertices.len * @sizeOf(f32), &vertices, clib.GL_STATIC_DRAW);

    const vertexShader: u32 = undefined;
    clib.glShaderSource(vertexShader, 1, &vertexShaderSource, null);
    clib.glCompileShader(vertexShader);

    var success: c_int = undefined;
    var infoLog: [512]u8 = undefined;
    clib.glGetShaderiv(vertexShader, clib.GL_COMPILE_STATUS, &success);

    if (success == 0) {
        clib.glGetShaderInfoLog(vertexShader, 512, null, &infoLog);
        _ = printf("ERROR::SHADER::VERTEX::COMPILATION_FAILED\n%s", &infoLog);
        return;
    }

    while (clib.glfwWindowShouldClose(window) == clib.GLFW_FALSE) {
        processInput(window);

        clib.glfwPollEvents();
        clib.glfwSwapBuffers(window);

        clib.glClearColor(0.2, 0.3, 0.3, 1.0);
        clib.glClear(clib.GL_COLOR_BUFFER_BIT);
    }
}
