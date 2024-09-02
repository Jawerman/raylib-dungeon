const rl = @import("raylib");
const LevelGenerator = @import("./LevelGenerator.zig");
const QuadMesh = @import("./QuadMesh.zig");

const size_size = 15;

pub fn generate_level_mesh() rl.Mesh {
    const floor_quad = LevelGenerator.QuadType{ .floor = QuadMesh.calculate_tex_coords(0, 6, 32, 32) };
    const ceil_quad = LevelGenerator.QuadType{ .ceil = QuadMesh.calculate_tex_coords(1, 0, 32, 32) };

    const front_quad = LevelGenerator.QuadType{ .front = QuadMesh.calculate_tex_coords(4, 4, 32, 32) };
    const back_quad = LevelGenerator.QuadType{ .back = QuadMesh.calculate_tex_coords(4, 4, 32, 32) };
    const left_quad = LevelGenerator.QuadType{ .left = QuadMesh.calculate_tex_coords(4, 4, 32, 32) };
    const right_quad = LevelGenerator.QuadType{ .right = QuadMesh.calculate_tex_coords(4, 4, 32, 32) };

    var empty = [_]LevelGenerator.QuadType{ floor_quad, ceil_quad };

    var left = [_]LevelGenerator.QuadType{left_quad};

    var right = [_]LevelGenerator.QuadType{right_quad};

    var front = [_]LevelGenerator.QuadType{front_quad};

    var back = [_]LevelGenerator.QuadType{back_quad};

    var level_description: [size_size * size_size]LevelGenerator.SectorDescription = undefined;

    for (0..size_size * size_size) |i| {
        const coord_x = i % size_size;
        const coord_y = i / size_size;

        if (coord_x == 0) {
            level_description[i] = .{
                .position = rl.Vector3.init(@floatFromInt(coord_x), 0, @floatFromInt(coord_y)),
                .quads_description = &right,
            };
        } else if (coord_x == (size_size - 1)) {
            level_description[i] = .{
                .position = rl.Vector3.init(@floatFromInt(coord_x), 0, @floatFromInt(coord_y)),
                .quads_description = &left,
            };
        } else if (coord_y == 0) {
            level_description[i] = .{
                .position = rl.Vector3.init(@floatFromInt(coord_x), 0, @floatFromInt(coord_y)),
                .quads_description = &front,
            };
        } else if (coord_y == (size_size - 1)) {
            level_description[i] = .{
                .position = rl.Vector3.init(@floatFromInt(coord_x), 0, @floatFromInt(coord_y)),
                .quads_description = &back,
            };
        } else {
            level_description[i] = .{
                .position = rl.Vector3.init(@floatFromInt(coord_x), 0, @floatFromInt(coord_y)),
                .quads_description = &empty,
            };
        }
    }

    return LevelGenerator.generate_level(&level_description);
}
