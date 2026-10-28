# llvm-clangir

Experimental LLVM builds with [ClangIR](https://llvm.github.io/clangir/)
enabled (`-DCLANG_ENABLE_CIR=ON`), which neither Homebrew nor apt.llvm.org
ship.

Each CI run uploads a GitHub Actions artifact per platform (`Darwin-aarch64`,
`Linux-aarch64`, `Linux-x86_64`), and runs on `main` or started manually also
publish them as a release tagged with the workflow run id. Each one is
`clangir-<OS>-<ARCH>.tar.xz`: an
install tree of LLVM, clang and MLIR with headers, `libLLVM`, `libclang-cpp`,
CMake configs and the LLVM utilities (`FileCheck`, ...). The exact
llvm-project commit is in `LLVM_REVISION`.

Builds track llvm-project `main`. Run the workflow manually to build another
branch, tag or commit.

Usage:

```sh
clang -fclangir -emit-cir test.c -o test.cir   # ClangIR
clang -fclangir test.c -o test                 # compile through ClangIR
```

The configuration lives in `ClangIR.cmake`.
