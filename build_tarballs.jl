using BinaryBuilder

# Collection of sources required to build Python
sources = [
    "https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tar.xz" =>
    "f434053ba1b5c8a5cc597e966ead3c5143012af827fd3f0697d21450bb8d87a6"
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/Python-3.6.5/
make distclean
./configure --prefix=${prefix} --host=${target} --build=x86_64-linux-gnu
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Windows(:i686),
    Windows(:x86_64),
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc),
    Linux(:powerpc64le, :glibc),
    MacOS()
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libpython", :libpython),
    ExecutableProduct(prefix, "python", :python)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/staticfloat/ZlibBuilder/releases/download/v1.2.11-3/build.jl",
    "https://github.com/staticfloat/Bzip2Builder/releases/download/v1.0.6-0/build.jl",
]


# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "Python", sources, script, platforms, products, dependencies)
