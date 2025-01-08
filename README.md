# What is this?

Zig + raylib = this, a simple example of how to build and use raylib in Zig. The rendering example is based off the language benchmark moving balls memes, but every language gets a random speed at runtime.

![screenshot](screenshot.png)

## Rendering

Right now it's capped at 120FPS to limit resource usage, but removing `ray.SetTargetFPS(120);` from `main.zig` will allow it to run at full speed.

## Build

`build.zig.zon` has been configured to install and build raylib as a dependency.

## Run

`zig build run` will build and run the program.
`zig build` will just build the program.
