const rl = @import("raylib");

const Self = @This();

var mesh: rl.Mesh = undefined;

fn gen_quads_mesh() Self {
    return Self.gen_basic_mesh(2, 4, 6);
}

pub fn add_quad_vertices(self: *Self, index: u32) void {
    const quad_normal = rl.Vector3.init(0.0, 1.0, 0.0);

    self.mesh.vertices[index + 0] = 0.0;
    self.mesh.vertices[index + 1] = 0.0;
    self.mesh.vertices[index + 2] = 0.0;
    self.mesh.normals[index + 0] = quad_normal.x;
    self.mesh.normals[index + 1] = quad_normal.y;
    self.mesh.normals[index + 2] = quad_normal.z;

    self.mesh.vertices[index + 3] = 0.0;
    self.mesh.vertices[index + 4] = 0.0;
    self.mesh.vertices[index + 5] = 1.0;
    self.mesh.normals[index + 3] = quad_normal.x;
    self.mesh.normals[index + 4] = quad_normal.x;
    self.mesh.normals[index + 5] = quad_normal.x;

    self.mesh.vertices[index + 6] = 1.0;
    self.mesh.vertices[index + 7] = 0.0;
    self.mesh.vertices[index + 8] = 1.0;
    self.mesh.normals[index + 6] = quad_normal.x;
    self.mesh.normals[index + 7] = quad_normal.x;
    self.mesh.normals[index + 8] = quad_normal.x;

    self.mesh.vertices[index + 9] = 1.0;
    self.mesh.vertices[index + 10] = 0.0;
    self.mesh.vertices[index + 11] = 0.0;
    self.mesh.normals[index + 9] = quad_normal.x;
    self.mesh.normals[index + 10] = quad_normal.x;
    self.mesh.normals[index + 11] = quad_normal.x;
}

pub fn add_quad_indices(self: *Self, index: u32) void {
    self.mesh.indices[index + 0] = 0;
    self.mesh.indices[index + 1] = 1;
    self.mesh.indices[index + 2] = 2;

    self.mesh.indices[index + 3] = 0;
    self.mesh.indices[index + 4] = 2;
    self.mesh.indices[index + 5] = 3;
}

fn add_tex_coords(self: *Self, index: u32, tile_x_pos: u32, tile_y_pos: u32, tex_cols: u32, tex_rows: u32) void {
    const tile_width: f32 = (1.0 / @as(f32, @floatFromInt(tex_cols)));
    const tile_height: f32 = (1.0 / @as(f32, @floatFromInt(tex_rows)));

    self.mesh.texcoords[index + 0] = @as(f32, @floatFromInt(tile_x_pos)) * tile_width;
    self.mesh.texcoords[index + 1] = @as(f32, @floatFromInt(tile_y_pos)) * tile_height;

    self.mesh.texcoords[index + 2] = @as(f32, @floatFromInt(tile_x_pos)) * tile_width;
    self.mesh.texcoords[index + 3] = (@as(f32, @floatFromInt(tile_y_pos)) + 1) * tile_height;

    self.mesh.texcoords[index + 4] = (@as(f32, @floatFromInt(tile_x_pos)) + 1) * tile_width;
    self.mesh.texcoords[index + 5] = (@as(f32, @floatFromInt(tile_y_pos)) + 1) * tile_height;

    self.mesh.texcoords[index + 6] = (@as(f32, @floatFromInt(tile_x_pos)) + 1) * tile_width;
    self.mesh.texcoords[index + 7] = @as(f32, @floatFromInt(tile_y_pos)) * tile_height;
}

fn gen_basic_mesh(num_triangles: u32, num_vertices: u32, num_indices: u32) Self {
    const vertices: *[]f32 = @ptrCast(@alignCast(rl.memAlloc(num_vertices * 3 * @sizeOf(f32))));
    const normals: *[]f32 = @ptrCast(@alignCast(rl.memAlloc(num_vertices * 3 * @sizeOf(f32))));
    const texcoords: *[]f32 = @ptrCast(@alignCast(rl.memAlloc(num_vertices * 2 * @sizeOf(f32))));
    const indices: *[]u16 = @ptrCast(@alignCast(rl.memAlloc(num_indices * @sizeOf(u16))));

    return Self{ .mesh = rl.Mesh{
        .vertexCount = @intCast(num_vertices),
        .triangleCount = @intCast(num_triangles),
        .vertices = @ptrCast(vertices),
        .texcoords = @ptrCast(texcoords),
        .texcoords2 = null,
        .normals = @ptrCast(normals),
        .tangents = null,
        .colors = null,
        .indices = @ptrCast(indices),
        .animVertices = null,
        .animNormals = null,
        .boneIds = null,
        .boneWeights = null,
        .vaoId = 0,
        .vboId = null,
    } };
}

// pub fn gen_basic_mesh(num_triangles: u32, num_vertices: u32, num_indices: u32) rl.Mesh {
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
