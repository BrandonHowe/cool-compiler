//
// Created by Brandon Howe on 2/12/25.
//

#ifndef CLASS_MAP_H
#define CLASS_MAP_H

#include <stdbool.h>

#include "parser.h"

typedef struct ClassAttribute
{
    bh_str name;
    bh_str type;
    CoolExpression expr;
} ClassAttribute;

typedef struct ClassMethodParameter
{
    bh_str name;
    bh_str type;
} ClassMethodParameter;

typedef struct ClassMethod
{
    bh_str name;
    bh_str inherited_from;
    bh_str return_type;
    int16_t parameter_count;
    ClassMethodParameter* parameters;
    CoolExpression body;
} ClassMethod;

typedef struct ClassNode
{
    bh_str name;
    struct ClassNode* parent;

    int16_t attribute_count;
    ClassAttribute* attributes;

    int16_t method_count;
    ClassMethod* methods;

    bool attributes_filled;
    bool methods_filled;
} ClassNode;

typedef struct CoolError
{
    bool valid;
    uint32_t line;
    const char* message;
} CoolError;

typedef struct CoolTypeOrError
{
    bool is_error;
    union
    {
        struct
        {
            bh_str type;
            bh_str self_type_class;
        };
        CoolError error;
    };
} CoolTypeOrError;

typedef struct ContextObject
{
    bh_str name;
    bh_str type;
    struct ContextObject* shadowing;
    struct ContextObject* next;
} ContextObject;

typedef struct ClassContext
{
    ContextObject* object_environment_head;
    bh_allocator object_environment_allocator;

    ClassNode* classes;
    int16_t class_count;
    int16_t class_idx;
} ClassContext;

CoolTypeOrError get_expression_type(ClassContext ctx, CoolExpression expr);
CoolError generate_class_map(CoolAST AST, bh_str file_name, bh_allocator allocator);

#endif //CLASS_MAP_H
