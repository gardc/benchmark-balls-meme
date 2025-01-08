const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Only use raylib dependency for native builds
    if (target.result.os.tag != .wasi) {
        // Native build
        const native_exe = b.addExecutable(.{
            .name = "balls-native",
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        });
        const raylib_native = b.dependency("raylib", .{
            .target = target,
            .optimize = optimize,
            .shared = true,
        });
        native_exe.linkLibrary(raylib_native.artifact("raylib"));

        b.installArtifact(native_exe);

        const assets = b.addModule("assets", .{
            .root_source_file = b.path("assets/assets.zig"),
        });
        native_exe.root_module.addImport("assets", assets);

        // Run step for native build
        const run_cmd = b.addRunArtifact(native_exe);
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }
        const run_step = b.step("run", "Run the native app");
        run_step.dependOn(&run_cmd.step);

        // 3D test
        const threedtest_step = b.step("3dtest", "Test 3D");
        const threedtest_exe = b.addExecutable(.{
            .name = "3dtest",
            .root_source_file = b.path("src/3dtest.zig"),
            .target = target,
            .optimize = optimize,
        });

        // Link raylib to threedtest_exe
        threedtest_exe.linkLibrary(raylib_native.artifact("raylib"));

        b.installArtifact(threedtest_exe);
        const run_threedtest_cmd = b.addRunArtifact(threedtest_exe);

        // Make threedtest_step depend on the run command
        threedtest_step.dependOn(&run_threedtest_cmd.step);

        // The rest can stay the same
        run_threedtest_cmd.step.dependOn(b.getInstallStep());
        const run_threedtest_step = b.step("run-3d", "Run 3D test");
        run_threedtest_step.dependOn(&run_threedtest_cmd.step);
    }

    // // WASM build
    // const wasm_step = b.step("wasm", "Build WASM version");

    // if (target.result.os.tag == .emscripten and target.result.cpu.arch == .wasm32) {
    //     const wasm = b.addExecutable(.{
    //         .name = "game",
    //         .root_source_file = b.path("src/main.zig"),
    //         .target = target,
    //         .optimize = optimize,
    //     });

    //     // Add raylib-wasm dependency
    //     const raylib_wasm = b.dependency("raylib-wasm", .{
    //         .target = target,
    //         .optimize = optimize,
    //     });

    //     // Link with raylib-wasm and add include path
    //     wasm.addObjectFile(raylib_wasm.path("lib/libraylib.a"));
    //     wasm.addIncludePath(raylib_wasm.path("include"));

    //     // Add emscripten-specific flags
    //     wasm.linkLibC();
    //     // wasm.linking

    //     // Export necessary symbols
    //     wasm.root_module.export_symbol_names = &[_][]const u8{
    //         "main",
    //         "_start",
    //         "__wasm_call_ctors",
    //     };

    //     // Add assets module for WASM build
    //     const assets = b.addModule("assets", .{
    //         .root_source_file = b.path("assets/assets.zig"),
    //     });
    //     wasm.root_module.addImport("assets", assets);

    //     // Install to 'zig-out/web'
    //     const install_web = b.addInstallArtifact(wasm, .{
    //         .dest_dir = .{ .override = .{ .custom = "web" } },
    //     });
    //     wasm_step.dependOn(&install_web.step);

    //     // Copy raylib.js and other necessary files
    //     const copy_js = b.addSystemCommand(&[_][]const u8{
    //         "cp",
    //         raylib_wasm.path("raylib.js").getPath(b),
    //         "zig-out/web/raylib.js",
    //     });
    //     copy_js.step.dependOn(&install_web.step);
    //     wasm_step.dependOn(&copy_js.step);

    //     // Copy index.html
    //     const copy_html = b.addSystemCommand(&[_][]const u8{
    //         "cp",
    //         "index.html",
    //         "zig-out/web/index.html",
    //     });
    //     copy_html.step.dependOn(&install_web.step);
    //     wasm_step.dependOn(&copy_html.step);
    // }
}
