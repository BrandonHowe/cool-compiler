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
    TAC_SYMBOL_TYPE_CLASSIDX,
    TAC_SYMBOL_TYPE_BOOL,
    TAC_SYMBOL_TYPE_STRING,
    TAC_SYMBOL_TYPE_METHOD,
    TAC_SYMBOL_TYPE_EXPRESSION
} TACSymbolType;

typedef struct TACSymbol
{
    TACSymbolType type;
    union
    {
        int64_t symbol;
        int64_t integer;
        struct { bh_str data; int64_t version; } string;
        struct { int64_t version; bh_str data; } variable;
        struct { int64_t class_idx; int64_t method_idx; } method;
        const CoolExpression* expression;
    };
} TACSymbol;

typedef struct TACBinding
{
    bh_str name;
    TACSymbol original_symbol;
    TACSymbol symbol;
} TACBinding;

typedef enum TACOp
{
    TAC_OP_NULL = (int64_t)0,
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
    TAC_OP_IS_CLASS,
    TAC_OP_PHI,
    TAC_OP_CALL,
    TAC_OP_JMP,
    TAC_OP_LABEL,
    TAC_OP_RETURN,
    TAC_OP_COMMENT,
    TAC_OP_BT,
    TAC_OP_RUNTIME_ERROR,
    TAC_OP_IGNORE
} TACOp;

typedef struct TACExpr
{
    TACSymbol lhs;
    TACSymbol rhs1;
    TACSymbol rhs2;
    TACOp operation;

    int64_t line_num;

    union
    {
        struct
        {
            int64_t arg_count;
            TACSymbol* args;
        };
        struct
        {
            int64_t branch_count;
            struct TACList* branches;
        };
    };
} TACExpr;

typedef struct TACList
{
    int64_t count;
    int64_t capacity;
    int64_t class_idx;
    int64_t method_idx;
    bh_str method_name;
    TACExpr* items;
    bh_allocator allocator;
    ClassNodeList class_list;

    int64_t _curr_label;
    int64_t _curr_symbol;

    TACBinding* _bindings;
    int64_t _binding_count;
} TACList;

// Non owning version of TACList (for CFG etc)
typedef struct TACSlice
{
    int64_t count;
    TACExpr* items;
} TACSlice;

TACExpr* TAC_list_append(TACList* list, TACExpr expr, bool add_phi);
TACList TAC_list_init(int64_t capacity, bh_allocator allocator);
TACSymbol TAC_request_symbol(TACList* list);
TACSymbol get_bound_symbol_variable(const TACList* list, TACSymbol symbol);
TACList tac_list_from_class_list(ClassNodeList class_list, bh_allocator allocator);
TACSymbol tac_list_from_expression(const CoolExpression* expr, TACList* list, TACSymbol destination, bool add_phi);
TACList tac_list_from_method(const ClassMethod* method, bh_allocator allocator);
bool tac_symbol_equal(TACSymbol s1, TACSymbol s2);

#endif //TAC_H
