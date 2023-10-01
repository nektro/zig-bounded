const std = @import("std");
const bounded = @import("bounded");

test {
    const x = bounded.constant(10);
    const X = @TypeOf(x);
    try std.testing.expect(X.min == 10);
    try std.testing.expect(X.max == 10);
    try std.testing.expect(X.Repr == u0);
    try std.testing.expect(x.repr == 0);
}
