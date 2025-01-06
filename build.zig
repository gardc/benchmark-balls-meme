const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Native build
    const native_exe = b.addExecutable(.{
        .name = "game-native",
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

    // Run step for native build
    const run_cmd = b.addRunArtifact(native_exe);
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the native app");
    run_step.dependOn(&run_cmd.step);

    // WASM build
    const wasm_step = b.step("wasm", "Build WASM version");

    // Only build WASM if specifically requested
    if (target.result.os.tag == .wasi and target.result.cpu.arch == .wasm32) {
        const wasm = b.addExecutable(.{
            .name = "game",
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        });

        const raylib_wasm = b.dependency("raylib", .{
            .target = target,
            .optimize = optimize,
            .shared = false,
        });

        wasm.root_module.export_symbol_names = &[_][]const u8{"main"};
        wasm.linkLibC();
        wasm.linkLibrary(raylib_wasm.artifact("raylib"));
        b.installArtifact(wasm);

        const install_wasm = b.addInstallArtifact(wasm, .{});
        wasm_step.dependOn(&install_wasm.step);
    }
}
