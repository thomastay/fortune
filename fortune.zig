// convenience imports
const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Str = []const u8;
const BitSet = std.DynamicBitSet;
const StrMap = std.StringHashMap;
const HashMap = std.HashMap;
const Map = std.AutoHashMap;
const PriorityQueue = std.PriorityQueue;
const assert = std.debug.assert;
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const print = std.debug.print;
const parseInt = std.fmt.parseInt;
const abs = std.math.absInt;
const OOM = error{OutOfMemory};
const fs = std.fs;
fn sort(comptime T: type, items: []T) void {
    std.sort.sort(T, items, {}, comptime std.sort.asc(T));
}
fn println(x: Str) void {
    print("{s}\n", .{x});
}

const header = @embedFile("./header2.txt");
var argBuffer: [1000 + std.fs.MAX_PATH_BYTES]u8 = undefined;
const fortuneFilename = "/fortunes-all.dat"; // TODO workaround for std.fs.cwd() not being able to run at compile time

comptime {
    assert(header.len == 8);
}
const maxFortuneLen = std.mem.readIntNative(u32, header[0..4]);
const numFortunes = std.mem.readIntNative(u32, header[4..8]);
var fortuneBuffer: [maxFortuneLen]u8 = undefined;

pub fn main() !void {
    const fortuneFullFilename = std.fs.path.dirname(@src().file).? ++ fortuneFilename;
    const stdout = std.io.getStdOut().writer();
    const allocator = std.heap.FixedBufferAllocator.init(&argBuffer).allocator();
    var argsIt = std.process.args();
    _ = try argsIt.next(allocator);
    const first_ = try argsIt.next(allocator);
    if (first_) |first| {
        const fortuneNum = try parseInt(u32, first, 10);
        if (fortuneNum >= numFortunes) {
            println("Number exceeds num fortunes");
            return error.InvalidArgument;
        }
        const fortuneFile = try fs.Dir.openFile(fs.cwd(), fortuneFullFilename, .{});
        defer fortuneFile.close();
        _ = try fortuneFile.pread(&fortuneBuffer, fortuneNum * maxFortuneLen);
        // look for null byte in fortuneBuffer
        const end = std.mem.indexOfScalar(u8, &fortuneBuffer, 0) orelse fortuneBuffer.len;

        try stdout.writeAll("Your lucky number is ");
        try stdout.writeAll(first);
        try stdout.writeByte('\n');
        try stdout.writeAll(fortuneBuffer[0..end]);
        try stdout.writeByte('\n');
    } else {
        println("Please enter a number");
        return error.NoArgument;
    }
}
