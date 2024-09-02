const std = @import("std");
const rl = @import("raylib");
const LevelGenerator = @import("./LevelGenerator.zig");
const QuadMesh = @import("./QuadMesh.zig");
const LevelBsp = @import("./LevelBsp.zig");
const level_test = @import("./level-test.zig");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    rl.setTraceLogLevel(rl.TraceLogLevel.log_error);

    const screenWidth = 1920;
    const screenHeight = 1080;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    rl.setMousePosition(screenWidth / 2, screenHeight / 2);
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    var camera = rl.Camera{
        .position = rl.Vector3.init(4.0, 0.5, 4.0),
        .target = rl.Vector3.init(0.0, 0.5, 0.0),
        .up = rl.Vector3.init(0.0, 1.0, 0.0),
        .fovy = 60.0,
        .projection = rl.CameraProjection.camera_perspective,
    };

    const atlas = rl.loadTexture("./assets/atlas.png");
    defer atlas.unload();

    _ = try LevelBsp.get_random_generator();

    //--------------------------------------------------------------------------------------

    var quad_mesh = level_test.generate_level_mesh();
    defer rl.unloadMesh(quad_mesh);

    var atlas_material = rl.loadMaterialDefault();
    atlas_material.maps[@intFromEnum(rl.MATERIAL_MAP_DIFFUSE)].texture = atlas;

    rl.disableCursor();

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------
        camera.update(rl.CameraMode.camera_first_person);

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.ray_white);

        {
            camera.begin();
            defer camera.end();

            quad_mesh.draw(atlas_material, rl.Matrix.identity());

            // rl.drawGrid(100, 0.25);
        }

        rl.drawFPS(10, 10);

        //----------------------------------------------------------------------------------
    }
}
