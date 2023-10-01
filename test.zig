const std = @import("std");
const bounded = @import("bounded");

fn expectEqual(actual: anytype, expected: @TypeOf(actual)) !void {
    return std.testing.expectEqual(expected, actual);
}

fn expect(
    z: anytype,
    comptime z_min: comptime_int,
    comptime z_max: comptime_int,
    comptime z_repr: comptime_int,
    comptime z_real: comptime_int,
) !void {
    const Z = @TypeOf(z);
    try expectEqual(Z.min, z_min);
    try expectEqual(Z.max, z_max);
    try expectEqual(z.repr, z_repr);
    try expectEqual(z.real(), z_real);
    try std.testing.expectFmt(std.fmt.comptimePrint("{d}", .{z_real}), "{}", .{z});
}

test {
    const x = bounded.constant(10); //0
    const X = @TypeOf(x);
    try std.testing.expect(X.Repr == u0);
    try expect(x, 10, 10, 0, 10);
}

test "int.add" {
    const x = bounded.int(1, 100).from(42); //41
    const y = bounded.int(-3, 7).from(2);
    const z = x.add(y);
    try expect(z, -2, 107, 46, 44);
}

test "int.add minimum" {
    const x = bounded.int(1, 100).from(1); //0
    const y = bounded.int(-3, 7).from(-3); //0
    const z = x.add(y);
    try expect(z, -2, 107, 0, -2);
}

test "int.add maximum" {
    const x = bounded.int(1, 100).from(100); //99
    const y = bounded.int(-3, 7).from(7); //10
    const z = x.add(y);
    try expect(z, -2, 107, 109, 107);
}

test "int.add const" {
    const x = bounded.constant(10); //0
    const y = bounded.constant(20); //0
    const z = x.add(y);
    try expect(z, 30, 30, 0, 30);
}
