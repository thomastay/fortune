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

// Module level constants, change accordingly
const fortuneFile = @embedFile("./fortune.txt");
const fortuneOut = "fortunes-all.dat";
// size of OS page (or multiple of)
const pageSize = 4096;
const headerLocation = "header2.txt";
const maxIntSizeInBytes = 5;
const fortuneSeparator = "\r\n%\r\n";
// Fixed sized buffer so we don't have to allocate
var buf = [_]u8{0} ** pageSize;

pub fn main() !void {
    // Open files
    var headerFile = try fs.Dir.createFile(fs.cwd(), headerLocation, .{});
    defer headerFile.close();

    var fortuneIt = split(u8, fortuneFile, fortuneSeparator);
    var maxFortuneLen: u32 = 0;
    var numFortunes: u32 = 0;
    while (fortuneIt.next()) |fortune| : (numFortunes += 1) {
        if (fortune.len > pageSize) {
            print("Fortune {s} too large. Extend the page size.\n", .{fortune});
            return error.FortuneTooLarge;
        }
        if (fortune.len > maxFortuneLen) maxFortuneLen = @intCast(u32, fortune.len);
    }
    try headerFile.writer().writeIntNative(u32, maxFortuneLen);
    try headerFile.writer().writeIntNative(u32, numFortunes);

    var fortuneOutFile = try fs.Dir.createFile(fs.cwd(), fortuneOut, .{});
    defer fortuneOutFile.close();

    var fortuneBuf = buf[0..maxFortuneLen];
    fortuneIt = split(u8, fortuneFile, fortuneSeparator);
    while (fortuneIt.next()) |fortune| {
        std.mem.set(u8, fortuneBuf, 0);
        std.mem.copy(u8, fortuneBuf, fortune);
        _ = try fortuneOutFile.write(fortuneBuf);
    }
}
