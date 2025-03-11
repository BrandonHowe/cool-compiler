//
// Created by Brandon Howe on 3/5/25.
//

#ifndef TAC_H
#define TAC_H

#include <stdint.h>
#include "ast.h"

typedef enum TACSymbolType
{
    TAC_SYMBOL_TYPE_NULL,
    TAC_SYMBOL_TYPE_SYMBOL,
    TAC_SYMBOL_TYPE_VARIABLE,
    TAC_SYMBOL_TYPE_INTEGER,
    TAC_SYMBOL_TYPE_BOOL,
    TAC_SYMBOL_TYPE_STRING,
} TACSymbolType;

typedef struct TACSymbol
{
    TACSymbolType type;
    union
    {
        int16_t symbol;
        int16_t integer;
        bh_str string;
        bh_str variable;
    };
} TACSymbol;

typedef struct TACBinding
{
    bh_str name;
    TACSymbol symbol;
} TACBinding;

typedef enum TACOp
{
    TAC_OP_NULL = (int16_t)0,
    TAC_OP_ASSIGN,
    TAC_OP_PLUS,
    TAC_OP_MINUS,
    TAC_OP_TIMES,
    TAC_OP_DIVIDE,
    TAC_OP_LT,
    TAC_OP_LTE,
    TAC_OP_EQ,
    TAC_OP_INT,
    TAC_OP_STRING,
    TAC_OP_BOOL,
    TAC_OP_NOT,
    TAC_OP_NEG,
    TAC_OP_NEW,
    TAC_OP_DEFAULT,
    TAC_OP_ISVOID,
    TAC_OP_CALL,
    TAC_OP_JMP,
    TAC_OP_LABEL,
    TAC_OP_RETURN,
    TAC_OP_COMMENT,
    TAC_OP_BT
} TACOp;

typedef struct TACExpr
{
    TACSymbol lhs;
    TACSymbol rhs1;
    TACSymbol rhs2;
    TACOp operation;

    int16_t arg_count;
    TACSymbol* args;
} TACExpr;

typedef struct TACList
{
    int16_t count;
    int16_t capacity;
    int16_t curr_symbol;
    bh_str label_base;
    int16_t curr_label;
    TACExpr* items;
    bh_allocator allocator;

    TACBinding* bindings;
    int16_t binding_count;
} TACList;

TACExpr* TAC_list_append(TACList* list, TACExpr expr);
TACSymbol TAC_request_symbol(TACList* list);
TACList tac_list_from_ast(CoolAST AST, bh_allocator allocator, ClassNodeList class_list);
TACSymbol tac_list_from_expression(CoolExpression expr, TACList* list, TACSymbol destination);

#endif //TAC_H
