const std = @import("std");
const bounded = @import("bounded");

fn expect(
    z: anytype,
    comptime z_min: comptime_int,
    comptime z_max: comptime_int,
    comptime z_repr: comptime_int,
    comptime z_real: comptime_int,
) !void {
    const Z = @TypeOf(z);
    try std.testing.expect(Z.min == z_min);
    try std.testing.expect(Z.max == z_max);
    try std.testing.expect(z.repr == z_repr);
    try std.testing.expect(z.real() == z_real);
    try std.testing.expectFmt(std.fmt.comptimePrint("{d}", .{z_real}), "{}", .{z});
}

test {
    const x = bounded.constant(10);
    const X = @TypeOf(x);
    try std.testing.expect(X.Repr == u0);
    try expect(
        x,
        10,
        10,
        0,
        10,
    );
}

test "int.add" {
    const x = bounded.int(1, 100).from(42);
    const y = bounded.int(-3, 7).from(2);
    const z = x.add(y);
    try expect(
        z,
        -2,
        107,
        46,
        44,
    );
}

test "int.add minimum" {
    const x = bounded.int(1, 100).from(1);
    const y = bounded.int(-3, 7).from(-3);
    const z = x.add(y);
    try expect(
        z,
        -2,
        107,
        0,
        -2,
    );
}

test "int.add maximum" {
    const x = bounded.int(1, 100).from(100);
    const y = bounded.int(-3, 7).from(7);
    const z = x.add(y);
    try expect(
        z,
        -2,
        107,
        109,
        107,
    );
}

test "int.add const" {
    const x = bounded.constant(10);
    const y = bounded.constant(20);
    const z = x.add(y);
    try expect(
        z,
        30,
        30,
        0,
        30,
    );
}
