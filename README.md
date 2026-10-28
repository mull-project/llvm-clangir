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

## CIR pass plugins

`patches/` is applied on top of llvm-project. It adds
`clang/CIR/CIRPassPlugin.h`: a plugin loaded with `-fplugin=` can register
passes that run on the CIR module right after CIRGen, before the built-in
CIR-to-CIR pipeline. It also keeps `mlir::`/`cir::` symbols exported from
`libclang-cpp`, so the plugin links against it alone.

```cpp
struct MyPlugin : cir::CIRPassPlugin {
  void registerPasses(mlir::OpPassManager &pm) override {
    pm.addPass(std::make_unique<MyModulePass>());              // whole TU
    pm.addNestedPass<cir::FuncOp>(std::make_unique<MyFuncPass>()); // per function
  }
};
static cir::CIRPassPluginRegistry::Add<MyPlugin> X("my-plugin", "...");
```

```sh
clang -fclangir -fplugin=libmy-plugin.so -c test.c
```

`tests/cir-pass-plugin` is a minimal plugin (rewrites `cir.add` into
`cir.sub`) that CI builds against each toolchain to check the integration.
