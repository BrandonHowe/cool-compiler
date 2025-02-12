//
// Created by Brandon Howe on 2/10/25.
//

#ifndef PARSER_H
#define PARSER_H
#include "types.h"

typedef enum CoolNodeType
{
    COOL_NODE_TYPE_NULL,
    COOL_NODE_TYPE_AST,
    COOL_NODE_TYPE_CLASS,
    COOL_NODE_TYPE_IDENTIFIER,
    COOL_NODE_TYPE_FORMAL,
    COOL_NODE_TYPE_EXPRESSION,
    COOL_NODE_TYPE_FEATURE,
    COOL_NODE_TYPE_LET,
    COOL_NODE_TYPE_CASE,
    COOL_NODE_TYPE_COUNT
} CoolNodeType;

typedef enum CoolExpressionType {
    COOL_EXPR_TYPE_NULL,
    COOL_EXPR_TYPE_ASSIGN,
    COOL_EXPR_TYPE_DYNAMIC_DISPATCH,
    COOL_EXPR_TYPE_STATIC_DISPATCH,
    COOL_EXPR_TYPE_SELF_DISPATCH,
    COOL_EXPR_TYPE_IF,
    COOL_EXPR_TYPE_WHILE,
    COOL_EXPR_TYPE_BLOCK,
    COOL_EXPR_TYPE_NEW,
    COOL_EXPR_TYPE_ISVOID,
    COOL_EXPR_TYPE_PLUS,
    COOL_EXPR_TYPE_MINUS,
    COOL_EXPR_TYPE_TIMES,
    COOL_EXPR_TYPE_DIVIDE,
    COOL_EXPR_TYPE_LT,
    COOL_EXPR_TYPE_LE,
    COOL_EXPR_TYPE_EQ,
    COOL_EXPR_TYPE_NOT,
    COOL_EXPR_TYPE_NEGATE,
    COOL_EXPR_TYPE_INTEGER,
    COOL_EXPR_TYPE_STRING,
    COOL_EXPR_TYPE_IDENTIFIER,
    COOL_EXPR_TYPE_TRUE,
    COOL_EXPR_TYPE_FALSE,
    COOL_EXPR_TYPE_LET,
    COOL_EXPR_TYPE_CASE,
    COOL_EXPR_TYPE_COUNT
} CoolExpressionType;

typedef struct CoolAST
{
    CoolNodeType type;
    uint16_t class_count;
    struct CoolClass* classes;
} CoolAST;

typedef struct CoolIdentifier
{
    CoolNodeType type;
    uint32_t line_num;
    bh_str name;
} CoolIdentifier;

typedef struct CoolFormal
{
    CoolNodeType type;
    CoolIdentifier name;
    CoolIdentifier type_name;
} CoolFormal;

struct CoolExpression;

typedef struct CoolLetBinding
{
    CoolIdentifier variable;
    CoolIdentifier type_name;
    struct CoolExpression* exp;
} CoolLetBinding;

typedef struct CoolCaseElement
{
    CoolIdentifier variable;
    CoolIdentifier type_name;
    struct CoolExpression* body;
} CoolCaseElement;

typedef struct CoolExpression {
    CoolNodeType type;
    CoolExpressionType expression_type;
    int32_t line_num;
    union {
        struct { CoolIdentifier var; struct CoolExpression* rhs; } assign;
        struct { struct CoolExpression* e; CoolIdentifier method; uint16_t args_length; struct CoolExpression* args; } dynamic_dispatch;
        struct { struct CoolExpression* e; CoolIdentifier type_name; CoolIdentifier method; uint16_t args_length; struct CoolExpression* args; } static_dispatch;
        struct { CoolIdentifier method; uint16_t args_length; struct CoolExpression* args; } self_dispatch;
        struct { struct CoolExpression* predicate; struct CoolExpression* then_branch; struct CoolExpression* else_branch; } if_expr;
        struct { struct CoolExpression* predicate; struct CoolExpression* body; } while_expr;
        struct { uint32_t body_length; struct CoolExpression* body; } block;
        struct { CoolIdentifier class_name; } new_expr;
        struct { struct CoolExpression* e; } isvoid;
        struct { struct CoolExpression* x; struct CoolExpression* y; } binary;
        struct { struct CoolExpression* x; } unary;
        struct { int32_t value; } integer;
        struct { bh_str value; } string;
        struct { CoolIdentifier variable; } identifier;
        struct { uint16_t binding_count; CoolLetBinding* bindings; struct CoolExpression* expr; } let;
        struct { struct CoolExpression* expr; uint16_t element_count; CoolCaseElement* elements; } case_expr;
    } data;
} CoolExpression;

typedef struct CoolFeature
{
    CoolNodeType type;
    CoolIdentifier name;
    CoolIdentifier type_name;

    uint16_t formal_count;
    CoolFormal* formals;

    CoolExpression body;
} CoolFeature;

typedef struct CoolClass
{
    CoolNodeType type;
    CoolIdentifier name;
    CoolIdentifier inherits;

    uint16_t feature_count;
    CoolFeature* features;
} CoolClass;

CoolAST parse_ast(bh_str* str);
CoolClass parse_class(bh_str* str);
CoolIdentifier parse_identifier(bh_str* str);
CoolFeature parse_feature(bh_str* str);
CoolExpression parse_expression(bh_str* str);
CoolFormal parse_formal(bh_str* str);

#endif //PARSER_H
