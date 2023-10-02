const std = @import("std");
const builtin = @import("builtin");

pub fn int(comptime minimum: comptime_int, comptime maximum: comptime_int) type {
    if (!(minimum <= maximum)) @compileLog(minimum, maximum); // error!

    return packed struct {
        repr: Repr,

        const A = @This();

        pub const min = minimum;
        pub const max = maximum;
        pub const Repr = std.math.IntFittingRange(0, max - min);
        pub const Real = std.math.IntFittingRange(@min(min, 0), @max(max, std.math.maxInt(Repr)));

        pub fn from(x: anytype) A {
            const X = @TypeOf(x);
            switch (@typeInfo(X)) {
                .ComptimeInt => {
                    return .{ .repr = x - minimum };
                },
                else => unreachable,
            }
        }

        pub fn add(a: A, b: anytype) int(A.min + @TypeOf(b).min, A.max + @TypeOf(b).max) {
            @setRuntimeSafety(builtin.mode == .Debug);
            const R = int(A.min + @TypeOf(b).min, A.max + @TypeOf(b).max);
            const P = R.Repr;
            return .{ .repr = @as(P, a.repr) + @as(P, b.repr) };
        }

        pub fn real(a: A) Real {
            return @as(Real, @intCast(a.repr)) + min;
        }

        pub fn format(a: A, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
            _ = fmt;
            _ = options;
            return std.fmt.formatInt(a.real(), 10, .lower, .{}, writer);
        }

        pub fn neg(a: A) Neg() {
            @setRuntimeSafety(builtin.mode == .Debug);
            const R = Neg();
            var x = @as(R.Repr, a.repr);
            x += (A.min - R.min);
            x -= a.repr;
            x = safe_sub(x, A.min * 2);
            x -= a.repr;
            return .{ .repr = x };
        }

        fn Neg() type {
            const l = @max(std.math.absCast(min), std.math.absCast(max));
            return int(-l, l);
        }
    };
}

pub fn from(comptime T: type) type {
    return switch (@typeInfo(T)) {
        .Int => int(std.math.minInt(T), std.math.maxInt(T)),
        else => unreachable,
    };
}

pub fn constant(comptime x: comptime_int) int(x, x) {
    return int(x, x).from(x);
}

pub const @"u8" = from(u8);
pub const @"u16" = from(u16);
pub const @"u32" = from(u32);
pub const @"u64" = from(u64);

pub const @"i8" = from(i8);
pub const @"i16" = from(i16);
pub const @"i32" = from(i32);
pub const @"i64" = from(i64);

//
//

inline fn safe_sub(x: anytype, y: anytype) @TypeOf(x) {
    if (y >= 0) {
        return x - @as(@TypeOf(x), @intCast(y));
    }
    return x + @as(@TypeOf(x), @intCast(-y));
}
