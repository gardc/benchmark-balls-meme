const std = @import("std");
const ray = @cImport(@cInclude("raylib.h"));
const math = @import("std").math;
const assets = @import("assets");

const target_fps = 120;

const Circle = struct {
    x: f32,
    y: f32,
    radius: f32,
    speed: f32,
    angle: f32,
    texture: ray.Texture2D,
};

fn HSVtoRGB(h: f32, s: f32, v: f32) ray.Color {
    const c: f32 = v * s;
    const x: f32 = c * (1.0 - @abs(@mod(h / 60.0, 2.0) - 1.0));
    const m: f32 = v - c;

    var r: f32 = 0.0;
    var g: f32 = 0.0;
    var b: f32 = 0.0;

    if (h < 60.0) {
        r = c;
        g = x;
        b = 0.0;
    } else if (h < 120.0) {
        r = x;
        g = c;
        b = 0.0;
    } else if (h < 180.0) {
        r = 0.0;
        g = c;
        b = x;
    } else if (h < 240.0) {
        r = 0.0;
        g = x;
        b = c;
    } else if (h < 300.0) {
        r = x;
        g = 0.0;
        b = c;
    } else {
        r = c;
        g = 0.0;
        b = x;
    }

    // Clamp values between 0 and 255
    const clamp = std.math.clamp;
    return ray.Color{
        .r = @intFromFloat(clamp((r + m) * 255, 0, 255)),
        .g = @intFromFloat(clamp((g + m) * 255, 0, 255)),
        .b = @intFromFloat(clamp((b + m) * 255, 0, 255)),
        .a = 255,
    };
}

const rand = std.crypto.random;

fn getRandomSpeed() f32 {
    return rand.float(f32) * 15 + 1;
}

fn getRandomAngle() f32 {
    return rand.float(f32) * 360.0;
}

pub fn main() !void {
    const screen_width = 1400;
    const screen_height = 800;
    const circle_radius: f32 = 40;

    ray.InitWindow(screen_width, screen_height, "(deez) language ballz");
    ray.SetConfigFlags(ray.FLAG_VSYNC_HINT);
    defer ray.CloseWindow();

    ray.SetTargetFPS(target_fps);

    // Load textures from embedded files
    const c_texture = ray.LoadTextureFromImage(ray.LoadImageFromMemory(".png", assets.c_icon, assets.c_icon.len));
    const cpp_texture = ray.LoadTextureFromImage(ray.LoadImageFromMemory(".png", assets.cpp_icon, assets.cpp_icon.len));
    const rust_texture = ray.LoadTextureFromImage(ray.LoadImageFromMemory(".png", assets.rust_icon, assets.rust_icon.len));
    const zig_texture = ray.LoadTextureFromImage(ray.LoadImageFromMemory(".png", assets.zig_icon, assets.zig_icon.len));
    const go_texture = ray.LoadTextureFromImage(ray.LoadImageFromMemory(".png", assets.go_icon, assets.go_icon.len));
    const java_texture = ray.LoadTextureFromImage(ray.LoadImageFromMemory(".png", assets.java_icon, assets.java_icon.len));
    const kotlin_texture = ray.LoadTextureFromImage(ray.LoadImageFromMemory(".png", assets.kotlin_icon, assets.kotlin_icon.len));
    const swift_texture = ray.LoadTextureFromImage(ray.LoadImageFromMemory(".png", assets.swift_icon, assets.swift_icon.len));
    const csharp_texture = ray.LoadTextureFromImage(ray.LoadImageFromMemory(".png", assets.csharp_icon, assets.csharp_icon.len));
    const python_texture = ray.LoadTextureFromImage(ray.LoadImageFromMemory(".png", assets.python_icon, assets.python_icon.len));
    const ruby_texture = ray.LoadTextureFromImage(ray.LoadImageFromMemory(".png", assets.ruby_icon, assets.ruby_icon.len));
    const php_texture = ray.LoadTextureFromImage(ray.LoadImageFromMemory(".png", assets.php_icon, assets.php_icon.len));
    const ts_texture = ray.LoadTextureFromImage(ray.LoadImageFromMemory(".png", assets.ts_icon, assets.ts_icon.len));
    const haskell_texture = ray.LoadTextureFromImage(ray.LoadImageFromMemory(".png", assets.haskell_icon, assets.haskell_icon.len));
    const nim_texture = ray.LoadTextureFromImage(ray.LoadImageFromMemory(".png", assets.nim_icon, assets.nim_icon.len));

    const textures = [_]ray.Texture2D{ c_texture, cpp_texture, rust_texture, zig_texture, go_texture, java_texture, kotlin_texture, swift_texture, csharp_texture, python_texture, ruby_texture, php_texture, ts_texture, haskell_texture, nim_texture };

    defer {
        for (textures) |texture| {
            ray.UnloadTexture(texture);
        }
    }

    var circles = [_]Circle{
        // Systems languages (fastest)
        .{ .x = 100, .y = 100, .radius = circle_radius, .speed = 12, .angle = getRandomAngle(), .texture = c_texture },
        .{ .x = 150, .y = 150, .radius = circle_radius, .speed = 11, .angle = getRandomAngle(), .texture = cpp_texture },
        .{ .x = 200, .y = 200, .radius = circle_radius, .speed = getRandomSpeed(), .angle = getRandomAngle(), .texture = rust_texture },
        .{ .x = 250, .y = 250, .radius = circle_radius + 30, .speed = getRandomSpeed(), .angle = getRandomAngle(), .texture = zig_texture },

        // Fast compiled languages
        .{ .x = 300, .y = 300, .radius = circle_radius + 30, .speed = getRandomSpeed(), .angle = getRandomAngle(), .texture = go_texture },
        .{ .x = 350, .y = 350, .radius = circle_radius, .speed = getRandomSpeed(), .angle = getRandomAngle(), .texture = swift_texture },
        .{ .x = 400, .y = 400, .radius = circle_radius, .speed = getRandomSpeed(), .angle = getRandomAngle(), .texture = nim_texture },

        // JVM languages
        .{ .x = 450, .y = 450, .radius = circle_radius, .speed = getRandomSpeed(), .angle = getRandomAngle(), .texture = java_texture },
        .{ .x = 500, .y = 500, .radius = circle_radius, .speed = getRandomSpeed(), .angle = getRandomAngle(), .texture = kotlin_texture },

        // Managed languages
        .{ .x = 150, .y = 400, .radius = circle_radius, .speed = getRandomSpeed(), .angle = getRandomAngle(), .texture = csharp_texture },

        // Interpreted/dynamic languages (slower)
        .{ .x = 200, .y = 450, .radius = circle_radius, .speed = getRandomSpeed(), .angle = getRandomAngle(), .texture = python_texture },
        .{ .x = 250, .y = 500, .radius = circle_radius, .speed = getRandomSpeed(), .angle = getRandomAngle(), .texture = ruby_texture },
        .{ .x = 300, .y = 550, .radius = circle_radius, .speed = getRandomSpeed(), .angle = getRandomAngle(), .texture = php_texture },
        .{ .x = 350, .y = 100, .radius = circle_radius, .speed = getRandomSpeed(), .angle = getRandomAngle(), .texture = ts_texture },

        // Functional languages
        .{ .x = 400, .y = 150, .radius = circle_radius, .speed = getRandomSpeed(), .angle = getRandomAngle(), .texture = haskell_texture },
    };

    // Rainbow background
    var hue: f32 = 0.0;
    const hue_speed: f32 = 0.5;

    while (!ray.WindowShouldClose()) {
        // Update circle positionss
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

        // Update background hue
        hue += hue_speed;
        if (hue >= 360.0) hue = 0.0;

        // Drawing
        ray.BeginDrawing();
        defer ray.EndDrawing();

        // Draw rainbow background
        const bg_color = HSVtoRGB(hue, 1.0, 1.0);
        ray.ClearBackground(bg_color);

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

        var buffer: [64:0]u8 = undefined; // Note the `:0` which makes this a sentinel-terminated array
        const fps_text = try std.fmt.bufPrintZ(&buffer, "FPS: {d}", .{current_fps});

        ray.DrawText(fps_text.ptr, 10, screen_height - 30, 15, ray.GREEN);
    }
}
