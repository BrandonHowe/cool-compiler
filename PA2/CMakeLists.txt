cmake_minimum_required(VERSION 3.28)
project(semantic_analyzer C)

set(CMAKE_C_STANDARD 11)

add_executable(semantic_analyzer main.c
        types.c
        types.h
        parser.c
        parser.h
        allocator.c
        allocator.h
        class_map.c
        class_map.h)
