#include <stdio.h>
#include <stdlib.h>

#include "parser.h"
#include "types.h"

#define COOL_FILE "../primes.cl-ast"

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
    // if (argc == 0)
    // {
    //     printf("COOL semantic analyzer requires at least 1 target file.\n");
    //     return 0;
    // }
    bh_str file = read_file_text(COOL_FILE);
    CoolAST ast = parse_ast(&file);
    printf("Hello, World!\n");
    return 0;
}
