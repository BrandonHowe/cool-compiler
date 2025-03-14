//
// Created by Brandon Howe on 3/5/25.
//

#include "tac.h"

#include <assert.h>
#include <string.h>

TACExpr* TAC_list_append(TACList* list, TACExpr expr)
{
    expr.lhs = get_bound_symbol_variable(list, expr.lhs);
    expr.rhs1 = get_bound_symbol_variable(list, expr.rhs1);
    expr.rhs2 = get_bound_symbol_variable(list, expr.rhs2);
    if (list->count + 1 >= list->capacity)
    {
        bh_realloc(list->allocator, list->items, list->capacity * 2);
        list->capacity *= 2;
    }
    list->items[list->count] = expr;
    list->count += 1;
    return &list->items[list->count - 1];
}

TACSymbol TAC_request_symbol(TACList* list)
{
    const int16_t res = list->curr_symbol;
    list->curr_symbol += 1;
    return (TACSymbol){ .type = TAC_SYMBOL_TYPE_SYMBOL, .symbol = res };
}

const char* start_str = "start";
const char* object_str = "Object";
const char* then_str = "then branch";
const char* else_str = "else branch";
const char* if_join_str = "if-join";
const char* while_pred_str = "while-pred";
const char* while_join_str = "while-join";
const char* while_body_str = "while-body";

TACList tac_list_from_ast(CoolAST AST, bh_allocator allocator, ClassNodeList class_list)
{
    bh_str class_name = (bh_str){ 0 };
    bh_str method_name = (bh_str){ 0 };
    CoolExpression first_method_body = (CoolExpression){ 0 };
    for (int i = 0; i < class_list.class_count; i++)
    {
        if (bh_str_equal_lit(class_list.class_nodes[i].name, "Object")) continue;
        if (bh_str_equal_lit(class_list.class_nodes[i].name, "Int")) continue;
        if (bh_str_equal_lit(class_list.class_nodes[i].name, "Bool")) continue;
        if (bh_str_equal_lit(class_list.class_nodes[i].name, "String")) continue;
        if (bh_str_equal_lit(class_list.class_nodes[i].name, "IO")) continue;

        class_name = class_list.class_nodes[i].name;

        for (int j = 0; j < class_list.class_nodes[i].method_count; j++)
        {
            if (bh_str_equal_lit(class_list.class_nodes[i].methods[j].inherited_from, "Object")) continue;
            if (bh_str_equal_lit(class_list.class_nodes[i].methods[j].inherited_from, "Bool")) continue;
            if (bh_str_equal_lit(class_list.class_nodes[i].methods[j].inherited_from, "IO")) continue;
            if (bh_str_equal_lit(class_list.class_nodes[i].methods[j].inherited_from, "String")) continue;
            if (bh_str_equal_lit(class_list.class_nodes[i].methods[j].inherited_from, "Int")) continue;

            method_name = class_list.class_nodes[i].methods[j].name;
            first_method_body = class_list.class_nodes[i].methods[j].body;
            break;
        }

        if (method_name.len > 0) break;
    }

    int initial_size = 10000;
    TACList list = (TACList)
    {
        .allocator = allocator,
        .capacity = initial_size,
        .count = 0,
        .items = bh_alloc(allocator, initial_size * sizeof(TACExpr)),
        .bindings = bh_alloc(allocator, initial_size * sizeof(TACBinding)),
        .binding_count = 0
    };

    bh_str comment_start_str = bh_str_from_cstr(start_str);

    TAC_list_append(&list, (TACExpr){
        .operation = TAC_OP_COMMENT,
        .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = comment_start_str }
    });

    int method_label_len = class_name.len + method_name.len + 4;
    const char* method_label = bh_alloc(allocator, method_label_len);
    strncpy(method_label, class_name.buf, class_name.len);
    strncpy(method_label + class_name.len, "_", 1);
    strncpy(method_label + class_name.len + 1, method_name.buf, method_name.len);
    strncpy(method_label + class_name.len + method_name.len + 1, "_", 1);
    bh_str method_label_str = bh_str_from_cstr(method_label);
    list.label_base = method_label_str;

    TAC_list_append(&list, (TACExpr){
        .operation = TAC_OP_LABEL,
        .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list.curr_label++ }
    });

    TACSymbol result = tac_list_from_expression(first_method_body, &list, (TACSymbol){ 0 });

    TAC_list_append(&list, (TACExpr){
        .operation = TAC_OP_RETURN,
        .rhs1 = result
    });

    return list;
}

TACSymbol get_bound_symbol_variable(const TACList* list, const TACSymbol symbol)
{
    for (int i = list->binding_count - 1; i >= 0; i--)
    {
        if (bh_str_equal(symbol.variable, list->bindings[i].name))
        {
            return list->bindings[i].symbol;
        }
    }
    return symbol;
}

TACSymbol tac_list_from_expression(CoolExpression expr, TACList* list, TACSymbol destination)
{
    if (destination.type == TAC_SYMBOL_TYPE_NULL) destination = TAC_request_symbol(list);
    switch (expr.expression_type)
    {
    case COOL_EXPR_TYPE_ASSIGN:
        {
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_ASSIGN,
                .lhs = destination,
                .rhs1 = tac_list_from_expression(*expr.data.assign.rhs, list, (TACSymbol){ .type = TAC_SYMBOL_TYPE_VARIABLE, .variable = expr.data.assign.var.name })
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_DYNAMIC_DISPATCH:
    case COOL_EXPR_TYPE_STATIC_DISPATCH:
    case COOL_EXPR_TYPE_SELF_DISPATCH:
        {
            TACExpr tac = (TACExpr){
                .operation = TAC_OP_CALL,
                .lhs = destination,
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = expr.data.dynamic_dispatch.method.name }
            };
            tac.arg_count = expr.data.dynamic_dispatch.args_length;
            tac.args = bh_alloc(list->allocator, tac.arg_count * sizeof(TACSymbol));
            for (int i = 0; i < expr.data.dynamic_dispatch.args_length; i++)
            {
                TACSymbol arg_symbol = tac_list_from_expression(expr.data.dynamic_dispatch.args[i], list, (TACSymbol){ 0 });
                tac.args[i] = arg_symbol;
            }
            if (expr.expression_type != COOL_EXPR_TYPE_SELF_DISPATCH)
            {
                tac_list_from_expression(*expr.data.dynamic_dispatch.e, list, (TACSymbol){ 0 });
            }
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_INTERNAL:
        {
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_CALL,
                .lhs = destination,
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = expr.data.internal.method }
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_IF:
        {
            TACSymbol cond = tac_list_from_expression(*expr.data.if_expr.predicate, list, (TACSymbol){ 0 });
            const TACExpr not_cond = (TACExpr){
                .operation = TAC_OP_NOT,
                .lhs = TAC_request_symbol(list),
                .rhs1 = cond
            };
            TAC_list_append(list, not_cond);
            const TACExpr bt_false = (TACExpr){
                .operation = TAC_OP_BT,
                .lhs = TAC_request_symbol(list),
                .rhs1 = not_cond.lhs,
                .rhs2 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list->curr_label + 1 }
            };
            TAC_list_append(list, bt_false);
            const TACExpr bt_true = (TACExpr){
                .operation = TAC_OP_BT,
                .lhs = TAC_request_symbol(list),
                .rhs1 = cond,
                .rhs2 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list->curr_label }
            };
            TAC_list_append(list, bt_true);
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(then_str) }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list->curr_label++ }});
            tac_list_from_expression(*expr.data.if_expr.then_branch, list, destination);
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_JMP, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list->curr_label + 1 }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(else_str) }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list->curr_label++ }});
            tac_list_from_expression(*expr.data.if_expr.else_branch, list, destination);
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_JMP, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list->curr_label }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(if_join_str) }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list->curr_label++ }});
            return destination;
        }
    case COOL_EXPR_TYPE_WHILE:
        {
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_JMP, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list->curr_label }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(while_pred_str) }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list->curr_label++ }});
            TACSymbol cond = tac_list_from_expression(*expr.data.while_expr.predicate, list, (TACSymbol){ 0 });
            const TACExpr not_cond = (TACExpr){ .operation = TAC_OP_NOT, .lhs = destination, .rhs1 = cond };
            TACExpr* not_cond_ptr = TAC_list_append(list, not_cond);
            const TACExpr bt_false = (TACExpr){
                .operation = TAC_OP_BT,
                .lhs = destination,
                .rhs1 = not_cond.lhs,
                .rhs2 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list->curr_label + 1 }
            };
            TACExpr* bt_false_ptr = TAC_list_append(list, bt_false);
            const TACExpr bt_true = (TACExpr){
                .operation = TAC_OP_BT,
                .lhs = destination,
                .rhs1 = cond,
                .rhs2 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list->curr_label }
            };
            TAC_list_append(list, bt_true);

            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(while_body_str) }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list->curr_label++ }});
            tac_list_from_expression(*expr.data.while_expr.body, list, TAC_request_symbol(list));
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_JMP, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list->curr_label - 2 }});

            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(while_join_str) }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list->curr_label++ }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_DEFAULT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(object_str) }});

            return destination;
        }
        break;
    case COOL_EXPR_TYPE_BLOCK:
        {
            for (int i = 0; i < expr.data.block.body_length; i++)
            {
                int is_last = i == expr.data.block.body_length - 1;
                tac_list_from_expression(expr.data.block.body[i], list, is_last ? destination : (TACSymbol){ 0 });
            }
            return destination;
        }
    case COOL_EXPR_TYPE_NEW:
        {
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_NEW,
                .lhs = destination,
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_VARIABLE, .variable = expr.data.new_expr.class_name.name }
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_ISVOID:
        {
            TACSymbol ta1 = tac_list_from_expression(*expr.data.isvoid.e, list, (TACSymbol){ 0 });
            TACExpr tac = (TACExpr) {
                .operation = TAC_OP_ISVOID,
                .lhs = destination,
                .rhs1 = ta1,
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_PLUS:
    case COOL_EXPR_TYPE_MINUS:
    case COOL_EXPR_TYPE_TIMES:
    case COOL_EXPR_TYPE_DIVIDE:
    case COOL_EXPR_TYPE_LT:
    case COOL_EXPR_TYPE_LE:
    case COOL_EXPR_TYPE_EQ:
        {
            TACSymbol dest1 = TAC_request_symbol(list);
            TACSymbol dest2 = TAC_request_symbol(list);
            TACSymbol ta1 = tac_list_from_expression(*expr.data.binary.x, list, dest1);
            TACSymbol ta2 = tac_list_from_expression(*expr.data.binary.y, list, dest2);
            TACExpr tac = (TACExpr) {
                .operation = expr.expression_type - (COOL_EXPR_TYPE_PLUS - TAC_OP_PLUS),
                .lhs = destination,
                .rhs1 = ta1,
                .rhs2 = ta2
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_NOT:
    case COOL_EXPR_TYPE_NEGATE:
        {
            TACSymbol ta1 = tac_list_from_expression(*expr.data.unary.x, list, (TACSymbol){ 0 });
            TACExpr tac = (TACExpr) {
                .operation = expr.expression_type - (COOL_EXPR_TYPE_NOT - TAC_OP_NOT),
                .lhs = destination,
                .rhs1 = ta1,
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_INTEGER:
        {
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_INT,
                .lhs = destination,
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = expr.data.integer.value }
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_STRING:
        {
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_STRING,
                .lhs = destination,
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = expr.data.string.value }
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_IDENTIFIER:
        {
            TACSymbol rhs = (TACSymbol){
                .type = TAC_SYMBOL_TYPE_VARIABLE,
                .variable = expr.data.identifier.variable.name
            };
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_ASSIGN,
                .lhs = destination,
                .rhs1 = rhs
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_TRUE:
    case COOL_EXPR_TYPE_FALSE:
        {
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_BOOL,
                .lhs = destination,
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_BOOL, .integer = expr.expression_type == COOL_EXPR_TYPE_TRUE }
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_LET:
        {
            int16_t initial_binding_count = list->binding_count;
            for (int i = 0; i < expr.data.let.binding_count; i++)
            {
                list->bindings[list->binding_count] = (TACBinding){
                    .name = expr.data.let.bindings[i].variable.name,
                    .symbol = TAC_request_symbol(list)
                };

                if (expr.data.let.bindings[i].exp)
                {
                    tac_list_from_expression(*expr.data.let.bindings[i].exp, list, list->bindings[list->binding_count].symbol);
                }
                else
                {
                    TACExpr default_expr = (TACExpr){
                        .operation = TAC_OP_DEFAULT,
                        .lhs = list->bindings[list->binding_count].symbol,
                        .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_VARIABLE, .variable = expr.data.let.bindings[i].type_name.name }
                    };
                    TAC_list_append(list, default_expr);
                }

                list->binding_count += 1;
            }
            tac_list_from_expression(*expr.data.let.expr, list, destination);
            list->binding_count = initial_binding_count;
            return destination;
        }
    case COOL_EXPR_TYPE_CASE:
        break;
    default:
        assert(0 && "Unhandled expression type when generating TAC");
        break;
    }
}
