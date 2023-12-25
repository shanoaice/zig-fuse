const std = @import("std");

pub const c_bindings = @cImport({
    @cInclude("errno.h");

    @cInclude("linux/fuse.h");
});
