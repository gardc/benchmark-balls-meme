const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

pub fn main() !void {
    // Initialize window and OpenGL context
    ray.InitWindow(800, 600, "Simple 3D Scene");
    defer ray.CloseWindow();

    // Set target FPS to 60
    ray.SetTargetFPS(60);

    // Initialize camera
    var camera = ray.Camera3D{
        .position = .{ .x = 0.0, .y = 2.0, .z = 5.0 }, // Camera position
        .target = .{ .x = 0.0, .y = 0.0, .z = 0.0 }, // Camera looking at point
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 }, // Camera up vector
        .fovy = 45.0, // Field-of-view Y
        .projection = ray.CAMERA_PERSPECTIVE, // Perspective projection
    };

    // Movement speed
    const move_speed: f32 = 0.1;

    // Main game loop
    while (!ray.WindowShouldClose()) {
        // Update camera position based on input
        if (ray.IsKeyDown(ray.KEY_W)) {
            camera.position.z -= move_speed;
            camera.target.z -= move_speed;
        }
        if (ray.IsKeyDown(ray.KEY_S)) {
            camera.position.z += move_speed;
            camera.target.z += move_speed;
        }
        if (ray.IsKeyDown(ray.KEY_A)) {
            camera.position.x -= move_speed;
            camera.target.x -= move_speed;
        }
        if (ray.IsKeyDown(ray.KEY_D)) {
            camera.position.x += move_speed;
            camera.target.x += move_speed;
        }

        // Draw
        ray.BeginDrawing();
        defer ray.EndDrawing();

        ray.ClearBackground(ray.RAYWHITE);

        // Begin 3D mode with our camera
        ray.BeginMode3D(camera);
        defer ray.EndMode3D();

        // Draw ground plane
        ray.DrawPlane(.{ .x = 0.0, .y = 0.0, .z = 0.0 }, .{ .x = 10.0, .y = 10.0 }, ray.GREEN);

        // Draw some 3D cubes for reference
        ray.DrawCube(.{ .x = 0.0, .y = 1.0, .z = 0.0 }, 2.0, 2.0, 2.0, ray.RED);
        ray.DrawCube(.{ .x = -3.0, .y = 0.5, .z = -3.0 }, 1.0, 1.0, 1.0, ray.BLUE);
        ray.DrawCube(.{ .x = 3.0, .y = 0.5, .z = 3.0 }, 1.0, 1.0, 1.0, ray.PURPLE);

        // Draw grid for better reference
        ray.DrawGrid(10, 1.0);

        // Draw FPS counter
        ray.DrawFPS(
            50,
            50,
        );
    }
}
