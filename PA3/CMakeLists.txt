cmake_minimum_required(VERSION 3.28)
project(code_generator C)

set(CMAKE_C_STANDARD 11)

file(COPY ${CMAKE_SOURCE_DIR}/cool_programs DESTINATION ${CMAKE_BINARY_DIR})
file(COPY ${CMAKE_SOURCE_DIR}/src/string_helpers.txt DESTINATION ${CMAKE_BINARY_DIR})
file(COPY ${CMAKE_SOURCE_DIR}/src/coolalloc.txt DESTINATION ${CMAKE_BINARY_DIR})
file(COPY ${CMAKE_SOURCE_DIR}/src/coolout.txt DESTINATION ${CMAKE_BINARY_DIR})

add_executable(semantic_analyzer src/main.c
        src/types.c
        src/types.h
        src/allocator.c
        src/allocator.h
        src/ast.c
        src/ast.h
        src/tac.c
        src/tac.h
        src/assembly.c
        src/assembly.h
        src/optimizer_tac.c
        src/optimizer_tac.h
        src/profiler.h
        src/profiler.c)

