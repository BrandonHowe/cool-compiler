//
// Created by Brandon Howe on 2/10/25.
//

#include <stdio.h>
#include <stdlib.h>

#include "class_map.h"
#include "parser.h"
#include "types.h"

bh_str read_file_text(const char* file_name)
{
    FILE *file = fopen(file_name, "r");
    if (file == NULL) {
        perror("Failed to open file");
        return (bh_str){ 0 };
    }

    // Seek to the end to determine the file size
    fseek(file, 0, SEEK_END);
    long fileSize = ftell(file);
    rewind(file);

    // Allocate memory to hold the file content
    char* buffer = malloc(fileSize);
    if (buffer == NULL) {
        perror("Failed to allocate memory");
        fclose(file);
        return (bh_str){ 0 };
    }

    // Read the file into the buffer
    size_t bytesRead = fread(buffer, 1, fileSize, file);
    if (bytesRead != fileSize) {
        perror("Failed to read the file");
        free(buffer);
        fclose(file);
        return (bh_str){ 0 };
    }

    fclose(file);
    return (bh_str){ .buf = buffer, .len = bytesRead };
}

int main(int argc, char* argv[])
{
    if (argc < 2) {
        printf("Usage: %s, <input_file>\n", argv[0]);
        return 1;
    }

    bh_str file = read_file_text(argv[1]);
    bh_str file_name = bh_str_from_cstr(argv[1]);

    bh_allocator ast_arena = arena_init(500000);
    CoolAST ast = parse_ast(&file, ast_arena);

    bh_allocator class_map_arena = arena_init(500000);
    CoolError error = generate_class_map(ast, file_name, class_map_arena);

    if (error.valid)
    {
        printf("ERROR: %i: Type-Check: %s", error.line, error.message);
        return 0;
    }

    arena_deinit(ast_arena);
    arena_deinit(class_map_arena);

    return 0;
}
