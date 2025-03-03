cmake_minimum_required(VERSION 3.28)
project(semantic_analyzer C)

set(CMAKE_C_STANDARD 11)

file(COPY ${CMAKE_SOURCE_DIR}/cool_programs DESTINATION ${CMAKE_BINARY_DIR})

add_executable(semantic_analyzer src/main.c
        src/types.c
        src/types.h
        src/parser.c
        src/parser.h
        src/allocator.c
        src/allocator.h
        src/type_checker.c
        src/type_checker.h)
