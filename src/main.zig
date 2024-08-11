// raylib-zig (c) Nikolas Wipper 2023
const std = @import("std");
const rl = @import("raylib");
const QuadMesh = @import("./QuadMesh.zig");

fn genPlaneMesh() rl.Mesh {
    return QuadMesh.gen_basic_mesh(2, 4, 6);
}

fn addQuad(index: u32, mesh: *rl.Mesh) void {
    mesh.vertices[index + 0] = 0.0;
    mesh.vertices[index + 1] = 0.0;
    mesh.vertices[index + 2] = 0.0;
    mesh.normals[index + 0] = 0.0;
    mesh.normals[index + 1] = 1.0;
    mesh.normals[index + 2] = 0.0;

    mesh.vertices[index + 3] = 0.0;
    mesh.vertices[index + 4] = 0.0;
    mesh.vertices[index + 5] = 1.0;
    mesh.normals[index + 3] = 0.0;
    mesh.normals[index + 4] = 1.0;
    mesh.normals[index + 5] = 0.0;

    mesh.vertices[index + 6] = 1.0;
    mesh.vertices[index + 7] = 0.0;
    mesh.vertices[index + 8] = 1.0;
    mesh.normals[index + 6] = 0.0;
    mesh.normals[index + 7] = 1.0;
    mesh.normals[index + 8] = 0.0;

    mesh.vertices[index + 9] = 1.0;
    mesh.vertices[index + 10] = 0.0;
    mesh.vertices[index + 11] = 0.0;
    mesh.normals[index + 9] = 0.0;
    mesh.normals[index + 10] = 1.0;
    mesh.normals[index + 11] = 0.0;

    mesh.indices[index + 0] = 0;
    mesh.indices[index + 1] = 1;
    mesh.indices[index + 2] = 2;

    mesh.indices[index + 3] = 0;
    mesh.indices[index + 4] = 2;
    mesh.indices[index + 5] = 3;
}

fn addTextCoords(mesh: *rl.Mesh, index: u32, tile_x_pos: u32, tile_y_pos: u32, tex_cols: u32, tex_rows: u32) void {
    const tile_width: f32 = (1.0 / @as(f32, @floatFromInt(tex_cols)));
    const tile_height: f32 = (1.0 / @as(f32, @floatFromInt(tex_rows)));

    mesh.texcoords[index + 0] = @as(f32, @floatFromInt(tile_x_pos)) * tile_width;
    mesh.texcoords[index + 1] = @as(f32, @floatFromInt(tile_y_pos)) * tile_height;

    mesh.texcoords[index + 2] = @as(f32, @floatFromInt(tile_x_pos)) * tile_width;
    mesh.texcoords[index + 3] = (@as(f32, @floatFromInt(tile_y_pos)) + 1) * tile_height;

    mesh.texcoords[index + 4] = (@as(f32, @floatFromInt(tile_x_pos)) + 1) * tile_width;
    mesh.texcoords[index + 5] = (@as(f32, @floatFromInt(tile_y_pos)) + 1) * tile_height;

    mesh.texcoords[index + 6] = (@as(f32, @floatFromInt(tile_x_pos)) + 1) * tile_width;
    mesh.texcoords[index + 7] = @as(f32, @floatFromInt(tile_y_pos)) * tile_height;
}

// fn genBasicMesh(num_triangles: u32, num_vertices: u32, num_indices: u32) rl.Mesh {
//     const vertices: *[]f32 = @ptrCast(@alignCast(rl.memAlloc(num_vertices * 3 * @sizeOf(f32))));
//     const normals: *[]f32 = @ptrCast(@alignCast(rl.memAlloc(num_vertices * 3 * @sizeOf(f32))));
//     const texcoords: *[]f32 = @ptrCast(@alignCast(rl.memAlloc(num_vertices * 2 * @sizeOf(f32))));
//     const indices: *[]u16 = @ptrCast(@alignCast(rl.memAlloc(num_indices * @sizeOf(u16))));
//
//     return rl.Mesh{
//         .vertexCount = @intCast(num_vertices),
//         .triangleCount = @intCast(num_triangles),
//         .vertices = @ptrCast(vertices),
//         .texcoords = @ptrCast(texcoords),
//         .texcoords2 = null,
//         .normals = @ptrCast(normals),
//         .tangents = null,
//         .colors = null,
//         .indices = @ptrCast(indices),
//         .animVertices = null,
//         .animNormals = null,
//         .boneIds = null,
//         .boneWeights = null,
//         .vaoId = 0,
//         .vboId = null,
//     };
// }

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

    var plane_mesh = genPlaneMesh();
    addQuad(0, &plane_mesh);
    addTextCoords(&plane_mesh, 0, 7, 4, 32, 32);
    rl.uploadMesh(&plane_mesh, false);

    var plane_mesh_2 = genPlaneMesh();
    addQuad(0, &plane_mesh_2);
    addTextCoords(&plane_mesh_2, 0, 7, 5, 32, 32);
    rl.uploadMesh(&plane_mesh_2, false);

    var atlas_material = rl.loadMaterialDefault();
    atlas_material.maps[@intFromEnum(rl.MATERIAL_MAP_DIFFUSE)].texture = atlas;

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------
        camera.update(rl.CameraMode.camera_orbital);

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.ray_white);

        {
            camera.begin();
            defer camera.end();

            plane_mesh.draw(atlas_material, rl.Matrix.identity());
            plane_mesh_2.draw(atlas_material, rl.Matrix.rotateX(std.math.pi / 2.0).multiply(rl.Matrix.translate(0, 1, 0)));

            rl.drawGrid(100, 0.25);
        }

        rl.drawFPS(10, 10);

        //----------------------------------------------------------------------------------
    }
}
