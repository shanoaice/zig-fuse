# zig-fuse

zig-fuse is a Zig library for implementation of FUSE filesystems in userspace. Due to libfuse's extensive usage of C bitfields, it is almost impossible to create a Zig binding / wrapper for it. Thus, this library is a completely from-scratch implementation based on the raw `/dev/fuse` interface.