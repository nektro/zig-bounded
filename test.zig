const std = @import("std");
const bounded = @import("bounded");

test {
    const x = bounded.constant(10);
    const X = @TypeOf(x);
    try std.testing.expect(X.min == 10);
    try std.testing.expect(X.max == 10);
    try std.testing.expect(X.Repr == u0);
    try std.testing.expect(x.repr == 0);
    try std.testing.expect(x.real() == 10);
    try std.testing.expectFmt("10", "{}", .{x});
}

test "int.add" {
    const x = bounded.int(1, 100).from(42);
    const y = bounded.int(-3, 7).from(2);
    const z = x.add(y);
    const Z = @TypeOf(z);

    try std.testing.expect(Z.min == -2);
    try std.testing.expect(Z.max == 107);
    try std.testing.expect(z.repr == 46);
    try std.testing.expect(z.real() == 44);
    try std.testing.expectFmt("44", "{}", .{z});
}

test "int.add minimum" {
    const x = bounded.int(1, 100).from(1);
    const y = bounded.int(-3, 7).from(-3);
    const z = x.add(y);
    const Z = @TypeOf(z);

    try std.testing.expect(Z.min == -2);
    try std.testing.expect(Z.max == 107);
    try std.testing.expect(z.repr == 0);
    try std.testing.expect(z.real() == -2);
    try std.testing.expectFmt("-2", "{}", .{z});
}

test "int.add maximum" {
    const x = bounded.int(1, 100).from(100);
    const y = bounded.int(-3, 7).from(7);
    const z = x.add(y);
    const Z = @TypeOf(z);

    try std.testing.expect(Z.min == -2);
    try std.testing.expect(Z.max == 107);
    try std.testing.expect(z.repr == 109);
    try std.testing.expect(z.real() == 107);
    try std.testing.expectFmt("107", "{}", .{z});
}

test "int.add const" {
    const x = bounded.constant(10);
    const y = bounded.constant(20);
    const z = x.add(y);
    const Z = @TypeOf(z);

    try std.testing.expect(Z.min == 30);
    try std.testing.expect(Z.max == 30);
    try std.testing.expect(z.repr == 0);
    try std.testing.expect(z.real() == 30);
    try std.testing.expectFmt("30", "{}", .{z});
}
