//
// Created by Brandon Howe on 2/12/25.
//

#ifndef CLASS_MAP_H
#define CLASS_MAP_H

#include <stdbool.h>

#include "parser.h"

typedef struct CoolError
{
    bool valid;
    uint32_t line;
    const char* message;
} CoolError;

CoolError generate_class_map(CoolAST AST, bh_str file_name, bh_allocator allocator);

#endif //CLASS_MAP_H
