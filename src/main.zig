const std = @import("std");
const ray = @cImport(@cInclude("raylib.h"));
const math = @import("std").math;

const target_fps = 120;

const Circle = struct {
    x: f32,
    y: f32,
    radius: f32,
    speed: f32,
    angle: f32,
    texture: ray.Texture2D,
};

pub fn main() !void {
    const screen_width = 1400;
    const screen_height = 800;
    const circle_radius: f32 = 30;

    // ray.SetTraceLogLevel(ray.LOG_WARNING); // Reduce logging

    ray.InitWindow(screen_width, screen_height, "Bouncing Language Icons");
    defer ray.CloseWindow();

    ray.SetTargetFPS(target_fps);

    // Load textures for all languages
    const c_texture = ray.LoadTexture("assets/c.png");
    const cpp_texture = ray.LoadTexture("assets/cpp.png");
    const rust_texture = ray.LoadTexture("assets/rust.png");
    const zig_texture = ray.LoadTexture("assets/zig.png");
    const go_texture = ray.LoadTexture("assets/go.png");
    const java_texture = ray.LoadTexture("assets/java.png");
    const kotlin_texture = ray.LoadTexture("assets/kotlin.png");
    const swift_texture = ray.LoadTexture("assets/swift.png");
    const csharp_texture = ray.LoadTexture("assets/csharp.png");
    const python_texture = ray.LoadTexture("assets/python.png");
    const ruby_texture = ray.LoadTexture("assets/ruby.png");
    const php_texture = ray.LoadTexture("assets/php.png");
    const ts_texture = ray.LoadTexture("assets/ts.png");
    const haskell_texture = ray.LoadTexture("assets/haskell.png");
    const nim_texture = ray.LoadTexture("assets/nim.png");

    defer {
        ray.UnloadTexture(c_texture);
        ray.UnloadTexture(cpp_texture);
        ray.UnloadTexture(rust_texture);
        ray.UnloadTexture(zig_texture);
        ray.UnloadTexture(go_texture);
        ray.UnloadTexture(java_texture);
        ray.UnloadTexture(kotlin_texture);
        ray.UnloadTexture(swift_texture);
        ray.UnloadTexture(csharp_texture);
        ray.UnloadTexture(python_texture);
        ray.UnloadTexture(ruby_texture);
        ray.UnloadTexture(php_texture);
        ray.UnloadTexture(ts_texture);
        ray.UnloadTexture(haskell_texture);
        ray.UnloadTexture(nim_texture);
    }

    var circles = [_]Circle{
        // Systems languages (fastest)
        .{ .x = 100, .y = 100, .radius = circle_radius, .speed = 12, .angle = 0, .texture = c_texture },
        .{ .x = 150, .y = 150, .radius = circle_radius, .speed = 11, .angle = 45, .texture = cpp_texture },
        .{ .x = 200, .y = 200, .radius = circle_radius, .speed = 11, .angle = 90, .texture = rust_texture },
        .{ .x = 250, .y = 250, .radius = circle_radius, .speed = 11, .angle = 135, .texture = zig_texture },

        // Fast compiled languages
        .{ .x = 300, .y = 300, .radius = circle_radius, .speed = 9, .angle = 0, .texture = go_texture },
        .{ .x = 350, .y = 350, .radius = circle_radius, .speed = 8, .angle = 45, .texture = swift_texture },
        .{ .x = 400, .y = 400, .radius = circle_radius, .speed = 8, .angle = 90, .texture = nim_texture },

        // JVM languages
        .{ .x = 450, .y = 450, .radius = circle_radius, .speed = 7, .angle = 0, .texture = java_texture },
        .{ .x = 500, .y = 500, .radius = circle_radius, .speed = 7, .angle = 45, .texture = kotlin_texture },

        // Managed languages
        .{ .x = 150, .y = 400, .radius = circle_radius, .speed = 6, .angle = 0, .texture = csharp_texture },

        // Interpreted/dynamic languages (slower)
        .{ .x = 200, .y = 450, .radius = circle_radius, .speed = 5, .angle = 45, .texture = python_texture },
        .{ .x = 250, .y = 500, .radius = circle_radius, .speed = 5, .angle = 90, .texture = ruby_texture },
        .{ .x = 300, .y = 550, .radius = circle_radius, .speed = 5, .angle = 135, .texture = php_texture },
        .{ .x = 350, .y = 100, .radius = circle_radius, .speed = 6, .angle = 0, .texture = ts_texture },

        // Functional language
        .{ .x = 400, .y = 150, .radius = circle_radius, .speed = 6, .angle = 45, .texture = haskell_texture },
    };

    var previous_fps: isize = target_fps; // Track previous FPS for drop detection
    var frame_drop_count: isize = 0; // Count frame drops

    while (!ray.WindowShouldClose()) {
        // Update circle positions
        for (&circles) |*circle| {
            // Update position based on angle
            circle.x += circle.speed * math.cos(circle.angle * (std.math.pi / 180.0));
            circle.y += circle.speed * math.sin(circle.angle * (std.math.pi / 180.0));

            // Bounce off screen edges
            if (circle.x - circle.radius <= 0 or circle.x + circle.radius >= screen_width) {
                circle.angle = 180 - circle.angle; // Reflect angle
            }
            if (circle.y - circle.radius <= 0 or circle.y + circle.radius >= screen_height) {
                circle.angle = -circle.angle; // Reflect angle
            }
        }

        // Drawing
        ray.BeginDrawing();
        defer ray.EndDrawing();

        ray.ClearBackground(ray.BLACK);

        // Draw circles with textures
        for (circles) |circle| {
            const tex_width = @as(f32, @floatFromInt(circle.texture.width));
            const tex_height = @as(f32, @floatFromInt(circle.texture.height));
            const aspect_ratio = tex_width / tex_height;

            // Calculate dimensions that maintain aspect ratio within the circle's bounds
            var dest_width: f32 = circle.radius * 2;
            var dest_height: f32 = dest_width / aspect_ratio;

            // If height is too big, scale based on height instead
            if (dest_height > circle.radius * 2) {
                dest_height = circle.radius * 2;
                dest_width = dest_height * aspect_ratio;
            }

            const source_rect = ray.Rectangle{
                .x = 0,
                .y = 0,
                .width = tex_width,
                .height = tex_height,
            };
            const dest_rect = ray.Rectangle{
                .x = circle.x - (dest_width / 2),
                .y = circle.y - (dest_height / 2),
                .width = dest_width,
                .height = dest_height,
            };
            const origin = ray.Vector2{ .x = 0, .y = 0 };
            ray.DrawTexturePro(circle.texture, source_rect, dest_rect, origin, 0, ray.WHITE);
        }

        // Draw FPS and frame drop information
        const current_fps = ray.GetFPS();
        if (current_fps < previous_fps and current_fps < 118) {
            frame_drop_count += 1;
        }
        previous_fps = current_fps;

        var buffer: [64:0]u8 = undefined; // Note the `:0` which makes this a sentinel-terminated array
        const fps_text = try std.fmt.bufPrintZ(&buffer, "FPS: {d}\nFrame Drops: {d}", .{ current_fps, frame_drop_count });

        ray.DrawText(fps_text.ptr, 10, screen_height - 50, 20, ray.GREEN);
    }
}
