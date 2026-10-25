# LLVM + clang with ClangIR, laid out like a distro package so mull can build
# its plugins against it (headers, libLLVM, libclang-cpp, CMake configs)

# ClangIR is an MLIR dialect, so it needs mlir
set(LLVM_ENABLE_PROJECTS "clang;mlir" CACHE STRING "")
set(CLANG_ENABLE_CIR ON CACHE BOOL "")

set(CMAKE_BUILD_TYPE Release CACHE STRING "")
set(LLVM_TARGETS_TO_BUILD Native CACHE STRING "")
set(LLVM_CCACHE_BUILD ON CACHE BOOL "")

# Same shape as Homebrew and apt.llvm.org: mull links against these dylibs
set(LLVM_BUILD_LLVM_DYLIB ON CACHE BOOL "")
set(LLVM_LINK_LLVM_DYLIB ON CACHE BOOL "")
set(CLANG_LINK_CLANG_DYLIB ON CACHE BOOL "")
set(LLVM_ENABLE_RTTI ON CACHE BOOL "")

# FileCheck and friends, used by mull's tests
set(LLVM_INSTALL_UTILS ON CACHE BOOL "")

# Keep the package free of dependencies the target machine may not have
set(LLVM_ENABLE_ZSTD OFF CACHE BOOL "")
set(LLVM_ENABLE_LIBXML2 OFF CACHE BOOL "")
set(LLVM_ENABLE_LIBEDIT OFF CACHE BOOL "")

set(LLVM_INCLUDE_TESTS OFF CACHE BOOL "")
set(LLVM_INCLUDE_BENCHMARKS OFF CACHE BOOL "")
set(LLVM_INCLUDE_EXAMPLES OFF CACHE BOOL "")
set(LLVM_INCLUDE_DOCS OFF CACHE BOOL "")
set(MLIR_INCLUDE_TESTS OFF CACHE BOOL "")
set(MLIR_INCLUDE_INTEGRATION_TESTS OFF CACHE BOOL "")
set(CLANG_INCLUDE_TESTS OFF CACHE BOOL "")
