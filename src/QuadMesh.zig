const std = @import("std");
const rl = @import("raylib");

const Self = @This();

mesh: rl.Mesh,
added_quads_count: u32 = 0,
num_quads: usize = undefined,

pub const QuadData = struct {
    vertices: [4]rl.Vector3 = .{
        rl.Vector3.init(0, 0, 0),
        rl.Vector3.init(0, 0, 1),
        rl.Vector3.init(1, 0, 1),
        rl.Vector3.init(1, 0, 0),
    },
    normal: rl.Vector3 = rl.Vector3.init(0, 1, 0),
    indices: [6]u16 = .{ 0, 1, 2, 0, 2, 3 },
    tex_coords: [4]rl.Vector2 = undefined,

    pub fn transform_vertices(self: *@This(), mat: rl.Matrix) *@This() {
        for (0..self.vertices.len) |i| {
            self.vertices[i] = self.vertices[i].transform(mat);
        }
        return self;
    }

    pub fn transform_normal(self: *@This(), mat: rl.Matrix) *@This() {
        self.normal = self.normal.transform(mat);
        return self;
    }
};

pub fn generate_mesh(quads_data: []QuadData) Self {
    var mesh_builder = gen_quads_mesh(quads_data.len);
    for (0..quads_data.len) |i| {
        _ = mesh_builder.set_quad(@intCast(i), quads_data[i]);
    }
    return mesh_builder;
}

pub fn add_quad(self: *Self, data: QuadData) *Self {
    defer self.added_quads_count += 1;
    return self.set_quad(self.added_quads_count, data);
}

fn set_quad(self: *Self, index: u32, data: QuadData) *Self {
    return self
        .add_quad_normals(index, data.normal)
        .add_quad_indices(index, data.indices)
        .add_tex_coords(index, data.tex_coords)
        .add_quad_vertices(index, data.vertices);
}

pub fn gen_quads_mesh(num_quads: usize) Self {
    const num_triangles = num_quads * 2;
    const num_vertices = num_quads * 4;
    const num_indices = num_quads * 6;

    return Self{
        .mesh = Self.gen_basic_mesh(@intCast(num_triangles), @intCast(num_vertices), @intCast(num_indices)),
        .num_quads = num_quads,
    };
}

pub fn unload_mesh(self: *Self) void {
    rl.unloadMesh(self.mesh);
}

pub fn upload_mesh(self: *Self, dynamic: bool) rl.Mesh {
    rl.uploadMesh(&(self.mesh), dynamic);
    return self.mesh;
}

fn add_quad_vertices(self: *Self, index: u32, vertices: [4]rl.Vector3) *Self {
    const quad_offset = 12 * index;
    for (0..4) |i| {
        const offset = i * 3;
        self.mesh.vertices[quad_offset + offset + 0] = vertices[i].x;
        self.mesh.vertices[quad_offset + offset + 1] = vertices[i].y;
        self.mesh.vertices[quad_offset + offset + 2] = vertices[i].z;
    }
    return self;
}

fn add_quad_normals(self: *Self, index: u32, normal: rl.Vector3) *Self {
    const quad_offset = 12 * index;
    for (0..4) |i| {
        const offset = i * 3;
        self.mesh.normals[quad_offset + offset + 0] = normal.x;
        self.mesh.normals[quad_offset + offset + 1] = normal.y;
        self.mesh.normals[quad_offset + offset + 2] = normal.z;
    }
    return self;
}

fn add_quad_indices(self: *Self, index: u32, indices: [6]u16) *Self {
    const quad_index_offset = index * 4;
    const quad_offset = index * 6;

    for (0..6) |i| {
        self.mesh.indices[i + quad_offset] = @intCast(indices[i] + quad_index_offset);
    }
    return self;
}

fn add_tex_coords(self: *Self, index: u32, tex_coords: [4]rl.Vector2) *Self {
    const quad_offset = index * 8;
    for (0..4) |i| {
        const offset = i * 2;
        self.mesh.texcoords[quad_offset + offset + 0] = tex_coords[i].x;
        self.mesh.texcoords[quad_offset + offset + 1] = tex_coords[i].y;
    }
    return self;
}

pub fn calculate_tex_coords(tile_x_pos: u32, tile_y_pos: u32, tex_cols: u32, tex_rows: u32) [4]rl.Vector2 {
    var result: [4]rl.Vector2 = undefined;

    const tile_width: f32 = (1.0 / @as(f32, @floatFromInt(tex_cols)));
    const tile_height: f32 = (1.0 / @as(f32, @floatFromInt(tex_rows)));

    result[0].x = @as(f32, @floatFromInt(tile_x_pos)) * tile_width;
    result[0].y = @as(f32, @floatFromInt(tile_y_pos)) * tile_height;

    result[1].x = @as(f32, @floatFromInt(tile_x_pos)) * tile_width;
    result[1].y = (@as(f32, @floatFromInt(tile_y_pos)) + 1) * tile_height;

    result[2].x = (@as(f32, @floatFromInt(tile_x_pos)) + 1) * tile_width;
    result[2].y = (@as(f32, @floatFromInt(tile_y_pos)) + 1) * tile_height;

    result[3].x = (@as(f32, @floatFromInt(tile_x_pos)) + 1) * tile_width;
    result[3].y = @as(f32, @floatFromInt(tile_y_pos)) * tile_height;

    return result;
}

fn gen_basic_mesh(num_triangles: u32, num_vertices: u32, num_indices: u32) rl.Mesh {
    const vertices: *[]f32 = @ptrCast(@alignCast(rl.memAlloc(num_vertices * 3 * @sizeOf(f32))));
    const normals: *[]f32 = @ptrCast(@alignCast(rl.memAlloc(num_vertices * 3 * @sizeOf(f32))));
    const texcoords: *[]f32 = @ptrCast(@alignCast(rl.memAlloc(num_vertices * 2 * @sizeOf(f32))));
    const indices: *[]u16 = @ptrCast(@alignCast(rl.memAlloc(num_indices * @sizeOf(u16))));

    return rl.Mesh{
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
    };
}
