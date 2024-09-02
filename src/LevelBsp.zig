const std = @import("std");
const Self = @This();

leftChild: ?Self = null,
rightChild: ?Self = null,

// pub fn generateLevelBsp(width: usize, height: usize, max_deep: u32, deep: u32) Self {
//     const is_vertical_split = std.rand.DefaultPrng.init(blk: {
//         var seed: u64 = undefined;
//         try std.os.getrandom(std.mem.asBytes(&seed));
//         break :blk seed;
//     });
// }

pub fn get_random_generator() !std.rand.Random.Xoshiro256 {
    return std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
}
