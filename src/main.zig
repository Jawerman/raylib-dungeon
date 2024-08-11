// raylib-zig (c) Nikolas Wipper 2023
const std = @import("std");
const rl = @import("raylib");

fn genPlaneMesh(tile_x_pos: u32, tile_y_pos: u32, tex_cols: u32, tex_rows: u32) rl.Mesh {
    const tile_width: f32 = (1.0 / @as(f32, @floatFromInt(tex_cols)));
    const tile_height: f32 = (1.0 / @as(f32, @floatFromInt(tex_rows)));

    var mesh = genBasicMesh(2);

    mesh.vertices[0] = 0.0;
    mesh.vertices[1] = 0.0;
    mesh.vertices[2] = 0.0;
    mesh.normals[0] = 0.0;
    mesh.normals[1] = 1.0;
    mesh.normals[2] = 0.0;
    mesh.texcoords[0] = @as(f32, @floatFromInt(tile_x_pos)) * tile_width;
    mesh.texcoords[1] = @as(f32, @floatFromInt(tile_y_pos)) * tile_height;

    mesh.vertices[3] = 0.0;
    mesh.vertices[4] = 0.0;
    mesh.vertices[5] = 1.0;
    mesh.normals[3] = 0.0;
    mesh.normals[4] = 1.0;
    mesh.normals[5] = 0.0;
    mesh.texcoords[2] = @as(f32, @floatFromInt(tile_x_pos)) * tile_width;
    mesh.texcoords[3] = (@as(f32, @floatFromInt(tile_y_pos)) + 1) * tile_height;

    mesh.vertices[6] = 1.0;
    mesh.vertices[7] = 0.0;
    mesh.vertices[8] = 1.0;
    mesh.normals[6] = 0.0;
    mesh.normals[7] = 1.0;
    mesh.normals[8] = 0.0;
    mesh.texcoords[4] = (@as(f32, @floatFromInt(tile_x_pos)) + 1) * tile_width;
    mesh.texcoords[5] = (@as(f32, @floatFromInt(tile_y_pos)) + 1) * tile_height;

    mesh.vertices[9] = 0.0;
    mesh.vertices[10] = 0.0;
    mesh.vertices[11] = 0.0;
    mesh.normals[9] = 0.0;
    mesh.normals[10] = 1.0;
    mesh.normals[11] = 0.0;
    mesh.texcoords[6] = @as(f32, @floatFromInt(tile_x_pos)) * tile_width;
    mesh.texcoords[7] = @as(f32, @floatFromInt(tile_y_pos)) * tile_height;

    mesh.vertices[12] = 1.0;
    mesh.vertices[13] = 0.0;
    mesh.vertices[14] = 1.0;
    mesh.normals[12] = 0.0;
    mesh.normals[13] = 1.0;
    mesh.normals[14] = 0.0;
    mesh.texcoords[8] = (@as(f32, @floatFromInt(tile_x_pos)) + 1) * tile_width;
    mesh.texcoords[9] = (@as(f32, @floatFromInt(tile_y_pos)) + 1) * tile_height;

    mesh.vertices[15] = 1.0;
    mesh.vertices[16] = 0.0;
    mesh.vertices[17] = 0.0;
    mesh.normals[15] = 0.0;
    mesh.normals[16] = 1.0;
    mesh.normals[17] = 0.0;
    mesh.texcoords[10] = (@as(f32, @floatFromInt(tile_x_pos)) + 1) * tile_width;
    mesh.texcoords[11] = @as(f32, @floatFromInt(tile_y_pos)) * tile_height;

    return mesh;
}

fn genBasicMesh(num_triangles: u32) rl.Mesh {
    const num_vertices = num_triangles * 3;

    const vertices: *[]f32 = @ptrCast(@alignCast(rl.memAlloc(num_vertices * 3 * @sizeOf(f32))));
    const normals: *[]f32 = @ptrCast(@alignCast(rl.memAlloc(num_vertices * 3 * @sizeOf(f32))));
    const texcoords: *[]f32 = @ptrCast(@alignCast(rl.memAlloc(num_vertices * 2 * @sizeOf(f32))));

    return rl.Mesh{
        .vertexCount = @intCast(num_vertices),
        .triangleCount = @intCast(num_triangles),
        .vertices = @ptrCast(vertices),
        .texcoords = @ptrCast(texcoords),
        .texcoords2 = null,
        .normals = @ptrCast(normals),
        .tangents = null,
        .colors = null,
        .indices = null,
        .animVertices = null,
        .animNormals = null,
        .boneIds = null,
        .boneWeights = null,
        .vaoId = 0,
        .vboId = null,
    };
}

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    rl.setTraceLogLevel(rl.TraceLogLevel.log_error);

    const screenWidth = 1920;
    const screenHeight = 1080;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    var camera = rl.Camera{
        .position = rl.Vector3.init(4.0, 4.0, 4.0),
        .target = rl.Vector3.init(0.0, 0.0, 0.0),
        .up = rl.Vector3.init(0.0, 1.0, 0.0),
        .fovy = 60.0,
        .projection = rl.CameraProjection.camera_perspective,
    };

    const atlas = rl.loadTexture("./assets/atlas.png");
    defer atlas.unload();

    //--------------------------------------------------------------------------------------

    var plane_mesh = genPlaneMesh(7, 4, 32, 32);
    rl.uploadMesh(&plane_mesh, false);

    const plane_model = rl.loadModelFromMesh(plane_mesh);
    defer plane_model.unload();

    plane_model.materials[0].maps[@intFromEnum(rl.MATERIAL_MAP_DIFFUSE)].texture = atlas;

    var atlas_material = rl.loadMaterialDefault();
    atlas_material.maps[@intFromEnum(rl.MATERIAL_MAP_DIFFUSE)].texture = atlas;

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------
        // camera.update(rl.CameraMode.camera_orbital);

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.ray_white);

        {
            camera.begin();
            defer camera.end();

            // var vertex = [_]rl.Vector3{
            //     rl.Vector3.init(0, 0, 0),
            //     rl.Vector3.init(1, 0, 0),
            //     rl.Vector3.init(0, 1, 0),
            //     rl.Vector3.init(1, 1, 0),
            // };
            // rl.drawTriangleStrip3D(&vertex, rl.Color.blue);
            // plane_model.draw(rl.Vector3.init(0, 0, 0), 1, rl.Color.white);
            plane_mesh.draw(atlas_material, rl.Matrix.identity());

            rl.drawGrid(100, 0.25);
        }

        rl.drawFPS(10, 10);

        //----------------------------------------------------------------------------------
    }
}
