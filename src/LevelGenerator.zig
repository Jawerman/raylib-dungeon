const std = @import("std");
const rl = @import("raylib");
const QuadMesh = @import("./QuadMesh.zig");

pub const QuadType = union(enum) {
    floor: [4]rl.Vector2,
    ceil: [4]rl.Vector2,
    front: [4]rl.Vector2,
    back: [4]rl.Vector2,
    left: [4]rl.Vector2,
    right: [4]rl.Vector2,
};

pub const SectorDescription = struct {
    position: rl.Vector3,
    quads_description: []QuadType,
};

const Self = @This();

pub fn generate_level(level_description: []SectorDescription) rl.Mesh {
    var mesh_builder = QuadMesh.gen_quads_mesh(calculate_level_quads(level_description));
    for (level_description) |value| {
        for (value.quads_description) |quad_description| {
            var quad = generate_quad(quad_description);
            _ = quad.transform_vertices(rl.Matrix.translate(value.position.x, value.position.y, value.position.z));
            _ = mesh_builder.add_quad(quad);
        }
    }
    return mesh_builder.upload_mesh(false);
}

pub fn calculate_level_quads(level_description: []SectorDescription) usize {
    var quads: usize = 0;
    for (level_description) |value| {
        quads += value.quads_description.len;
    }
    return quads;
}

pub fn generate_quad(quad: QuadType) QuadMesh.QuadData {
    return switch (quad) {
        .floor => |tex_coords| generate_floor_quad(tex_coords),
        .ceil => |tex_coords| generate_ceil_quad(tex_coords),
        .front => |tex_coords| generate_front_quad(tex_coords),
        .back => |tex_coords| generate_back_quad(tex_coords),
        .left => |tex_coords| generate_left_quad(tex_coords),
        .right => |tex_coords| generate_right_quad(tex_coords),
    };
}

pub fn generate_floor_quad(tex_coords: [4]rl.Vector2) QuadMesh.QuadData {
    const quad = QuadMesh.QuadData{
        .tex_coords = tex_coords,
    };
    return quad;
}

pub fn generate_ceil_quad(tex_coords: [4]rl.Vector2) QuadMesh.QuadData {
    var quad = QuadMesh.QuadData{
        .tex_coords = tex_coords,
    };
    const rotation = rl.Matrix.rotateX(std.math.pi).multiply(rl.Matrix.rotateY(std.math.pi));
    const traslation = rl.Matrix.translate(1, 1, 0);
    _ = quad.transform_vertices(rotation.multiply(traslation));
    _ = quad.transform_normal(rotation);
    return quad;
}

pub fn generate_front_quad(tex_coords: [4]rl.Vector2) QuadMesh.QuadData {
    var quad = QuadMesh.QuadData{
        .tex_coords = tex_coords,
    };
    const rotation = rl.Matrix.rotateX(std.math.pi / 2.0);
    const traslation = rl.Matrix.translate(0, 1, 1);
    _ = quad.transform_vertices(rotation.multiply(traslation));
    _ = quad.transform_normal(rotation);
    return quad;
}

pub fn generate_back_quad(tex_coords: [4]rl.Vector2) QuadMesh.QuadData {
    var quad = QuadMesh.QuadData{
        .tex_coords = tex_coords,
    };
    const rotation = rl.Matrix.rotateX(-std.math.pi / 2.0).multiply(rl.Matrix.rotateZ(std.math.pi));
    const traslation = rl.Matrix.translate(1, 1, 0);
    _ = quad.transform_vertices(rotation.multiply(traslation));
    _ = quad.transform_normal(rotation);
    return quad;
}

pub fn generate_left_quad(tex_coords: [4]rl.Vector2) QuadMesh.QuadData {
    var quad = QuadMesh.QuadData{
        .tex_coords = tex_coords,
    };
    const rotation = rl.Matrix.rotateX(std.math.pi / 2.0).multiply(rl.Matrix.rotateY(-std.math.pi / 2.0));
    const traslation = rl.Matrix.translate(0, 1, 0);
    _ = quad.transform_vertices(rotation.multiply(traslation));
    _ = quad.transform_normal(rotation);
    return quad;
}

pub fn generate_right_quad(tex_coords: [4]rl.Vector2) QuadMesh.QuadData {
    var quad = QuadMesh.QuadData{
        .tex_coords = tex_coords,
    };
    const rotation = rl.Matrix.rotateX(std.math.pi / 2.0).multiply(rl.Matrix.rotateY(std.math.pi / 2.0));
    const traslation = rl.Matrix.translate(1, 1, 1);
    _ = quad.transform_vertices(rotation.multiply(traslation));
    _ = quad.transform_normal(rotation);
    return quad;
}
