cmake_minimum_required(VERSION 3.20)
project(cir-pass-plugin CXX)
set(CMAKE_CXX_STANDARD 17)

find_package(Clang REQUIRED CONFIG)

add_library(add-to-sub MODULE AddToSub.cpp)
target_include_directories(add-to-sub PRIVATE ${LLVM_INCLUDE_DIRS} ${CLANG_INCLUDE_DIRS})
# clang, cir and mlir all come from the host's libclang-cpp
target_link_libraries(add-to-sub PRIVATE clang-cpp)
