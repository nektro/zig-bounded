const std = @import("std");

pub fn int(comptime minimum: comptime_int, comptime maximum: comptime_int) type {
    std.debug.assert(minimum <= maximum);

    return packed struct {
        repr: Repr,

        const Self = @This();

        pub const min = minimum;
        pub const max = maximum;
        pub const Repr = std.math.IntFittingRange(0, max - min);

        pub fn from(x: anytype) Self {
            const X = @TypeOf(x);
            switch (@typeInfo(X)) {
                .ComptimeInt => {
                    return .{ .repr = x - minimum };
                },
                else => unreachable,
            }
        }

        pub fn add(a: Self, b: anytype) int(Self.min + @TypeOf(b).min, Self.max + @TypeOf(b).max) {
            @setRuntimeSafety(false);
            const R = int(Self.min + @TypeOf(b).min, Self.max + @TypeOf(b).max);
            const P = R.Repr;
            return .{ .repr = @as(P, a.repr) + @as(P, b.repr) };
        }
    };
}

pub fn from(comptime T: type) type {
    return int(std.math.minInt(T), std.math.maxInt(T));
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
