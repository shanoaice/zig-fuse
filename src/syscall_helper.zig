const std = @import("std");

const c_bindings = @import("./c_bindings.zig").c_bindings;

const Allocator = std.mem.Allocator;

pub const AF_UNIX: i32 = 1;

pub const SOCK_STREAM: i32 = 1;

pub const FdCommands = enum(i32) {
    SETFD = 1,
    GETFD = 2,
};

// should've been provided by stdlib IMHO
// though this is only a wish, so here's some thin wrapper to handle errno
pub fn socketpair(domain: i32, protocol: i32) std.os.SocketError![2]i32 {
    const SocketError = std.os.SocketError;

    var fd_s: [2]i32 = undefined;

    const rc = std.os.linux.socketpair(domain, protocol, 0, &fd_s);
    if (rc < 0) {
        switch (std.os.errno(rc)) {
            c_bindings.EACCES => return SocketError.PermissionDenied,
            c_bindings.EINVAL => return SocketError.InvalidArgument,
            c_bindings.ENOMEM => return SocketError.SystemResources,
            c_bindings.EAFNOSUPPORT => return SocketError.AddressFamilyNotSupported,
            c_bindings.ENFILE => return SocketError.SystemFdQuotaExceeded,
            c_bindings.EMFILE => return SocketError.ProcessFdQuotaExceeded,
            c_bindings.EPROTONOSUPPORT => return SocketError.ProtocolFamilyNotAvailable,
            c_bindings.EOPNOTSUPP => return SocketError.SocketTypeNotSupported,
            else => |_| return std.os.UnexpectedError,
        }
    }

    return fd_s;
}
