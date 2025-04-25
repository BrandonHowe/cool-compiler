//
// Created by Brandon Howe on 3/5/25.
//

#include "tac.h"

#include <assert.h>
#include <string.h>
#include <sys/mman.h>

#include "optimizer_tac.h"

TACList TAC_list_init(const int64_t capacity, bh_allocator allocator)
{
#ifdef WIN32
    TACExpr* data = VirtualAlloc(NULL, 1000000000, MEM_RESERVE, PAGE_NOACCESS);
    VirtualAlloc(data, base_capacity * sizeof(TACExpr), MEM_COMMIT, PAGE_READWRITE);
#else
    TACExpr* data = mmap(NULL, 100000000000, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    mprotect(data, capacity * sizeof(TACExpr), PROT_READ | PROT_WRITE);
#endif
    TACList list = (TACList)
    {
        .allocator = allocator,
        .capacity = capacity,
        .count = 0,
        .items = data,
        ._bindings = bh_alloc(allocator, 100 * sizeof(TACBinding)),
        ._binding_count = 0
    };
    return list;
}

TACList TAC_list_init_no_bindings(const int64_t capacity, bh_allocator allocator)
{
#ifdef WIN32
    TACExpr* data = VirtualAlloc(NULL, 100000000000, MEM_RESERVE, PAGE_NOACCESS);
    VirtualAlloc(data, base_capacity * sizeof(TACExpr), MEM_COMMIT, PAGE_READWRITE);
#else
    TACExpr* data = mmap(NULL, 100000000000, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    mprotect(data, capacity * sizeof(TACExpr), PROT_READ | PROT_WRITE);
#endif
    TACList list = (TACList)
    {
        .allocator = allocator,
        .capacity = capacity,
        .count = 0,
        .items = data
    };
    return list;
}

void TAC_list_deinit(TACList list)
{
    munmap(list.items, 10000000);
    bh_free(list.allocator, list._bindings);
}

TACSymbol TAC_request_symbol(TACList* list)
{
    const int64_t res = list->_curr_symbol;
    list->_curr_symbol += 1;
    return (TACSymbol){ .type = TAC_SYMBOL_TYPE_SYMBOL, .symbol = res };
}

TACExpr* TAC_list_append(TACList* list, TACExpr expr, bool add_phi)
{
    // expr.lhs = get_bound_symbol_variable(list, expr.lhs);
    if (expr.lhs.type == TAC_SYMBOL_TYPE_VARIABLE)
    {
        for (int i = list->_binding_count - 1; i >= 0; i--)
        {
            if (bh_str_equal(expr.lhs.variable.data, list->_bindings[i].name))
            {
                TACSymbol new_symbol = TAC_request_symbol(list);
                if (list->_bindings[i].symbol.type == TAC_SYMBOL_TYPE_VARIABLE)
                {
                    list->_bindings[i].symbol.variable.version = new_symbol.symbol;
                    new_symbol = list->_bindings[i].symbol;
                }
                else
                {
                    list->_bindings[i].symbol = new_symbol;
                }
                expr.lhs = new_symbol;
            }
        }
    }
    if (expr.rhs1.type == TAC_SYMBOL_TYPE_VARIABLE)
    {
        for (int i = list->_binding_count - 1; i >= 0; i--)
        {
            if (bh_str_equal(expr.rhs1.variable.data, list->_bindings[i].name))
            {
                if (add_phi && !tac_symbol_equal(list->_bindings[i].symbol, list->_bindings[i].original_symbol))
                {
                    expr.operation = TAC_OP_PHI;
                    expr.rhs1 = list->_bindings[i].original_symbol;
                    expr.rhs2 = list->_bindings[i].symbol;
                }
                else
                {
                    expr.rhs1 = list->_bindings[i].symbol;
                }
                break;
            }
        }
    }
    expr.rhs2 = get_bound_symbol_variable(list, expr.rhs2);
    if (list->count + 1 >= list->capacity)
    {
        list->capacity *= 2;
        mprotect(list->items, list->capacity * sizeof(TACExpr), PROT_READ | PROT_WRITE);
    }
    list->items[list->count] = expr;
    list->count += 1;
    return &list->items[list->count - 1];
}

TACExpr* TAC_list_insert_at(TACList* list, TACExpr expr, int64_t index)
{
    // expr.lhs = get_bound_symbol_variable(list, expr.lhs);
    // if (expr.lhs.type == TAC_SYMBOL_TYPE_VARIABLE)
    // {
    //     for (int i = list->_binding_count - 1; i >= 0; i--)
    //     {
    //         if (bh_str_equal(expr.lhs.variable.data, list->_bindings[i].name))
    //         {
    //             TACSymbol new_symbol = TAC_request_symbol(list);
    //             list->_bindings[i].symbol = new_symbol;
    //             expr.lhs = new_symbol;
    //         }
    //     }
    // }
    // if (expr.rhs1.type == TAC_SYMBOL_TYPE_VARIABLE)
    // {
    //     for (int i = list->_binding_count - 1; i >= 0; i--)
    //     {
    //         if (bh_str_equal(expr.rhs1.variable.data, list->_bindings[i].name))
    //         {
    //             expr.rhs1 = list->_bindings[i].symbol;
    //         }
    //     }
    // }
    // expr.rhs2 = get_bound_symbol_variable(list, expr.rhs2);
    if (list->count + 1 >= list->capacity)
    {
        list->capacity *= 2;
        mprotect(list->items, list->capacity * sizeof(TACExpr), PROT_READ | PROT_WRITE);
    }
    memmove(&list->items[index + 1], &list->items[index], (list->count - index) * sizeof(TACExpr));
    list->items[index] = expr;
    list->count += 1;
    return &list->items[index];
}

const char* start_str = "start";
const char* object_str = "Object";
const char* then_str = "then branch";
const char* else_str = "else branch";
const char* if_join_str = "if-join";
const char* while_pred_str = "while-pred";
const char* while_join_str = "while-join";
const char* while_body_str = "while-body";

TACList tac_list_from_class_list(ClassNodeList class_list, bh_allocator allocator)
{
    int64_t class_idx = 0;
    int64_t method_idx = 0;
    bh_str method_name = (bh_str){ 0 };
    CoolExpression* first_method_body = NULL;
    for (int i = 0; i < class_list.class_count; i++)
    {
        if (bh_str_equal_lit(class_list.class_nodes[i].name, "Object")) continue;
        if (bh_str_equal_lit(class_list.class_nodes[i].name, "Int")) continue;
        if (bh_str_equal_lit(class_list.class_nodes[i].name, "Bool")) continue;
        if (bh_str_equal_lit(class_list.class_nodes[i].name, "String")) continue;
        if (bh_str_equal_lit(class_list.class_nodes[i].name, "IO")) continue;

        class_idx = i;

        for (int j = 0; j < class_list.class_nodes[i].method_count; j++)
        {
            if (bh_str_equal_lit(class_list.class_nodes[i].methods[j].inherited_from, "Object")) continue;
            if (bh_str_equal_lit(class_list.class_nodes[i].methods[j].inherited_from, "Bool")) continue;
            if (bh_str_equal_lit(class_list.class_nodes[i].methods[j].inherited_from, "IO")) continue;
            if (bh_str_equal_lit(class_list.class_nodes[i].methods[j].inherited_from, "String")) continue;
            if (bh_str_equal_lit(class_list.class_nodes[i].methods[j].inherited_from, "Int")) continue;

            method_idx = j;
            method_name = class_list.class_nodes[i].methods[j].name;
            first_method_body = &class_list.class_nodes[i].methods[j].body;
            break;
        }

        if (method_name.len > 0) break;
    }

    int initial_size = 10000;
    TACList list = TAC_list_init(initial_size, allocator);
    list.class_list = class_list;
    list.class_idx = class_idx;
    list.method_idx = method_idx;
    list.method_name = method_name;

    list._binding_count = class_list.class_nodes[class_idx].attribute_count;
    for (int i = 0; i < class_list.class_nodes[class_idx].attribute_count; i++)
    {
        list._bindings[i].name = class_list.class_nodes[class_idx].attributes[i].name;
        list._bindings[i].symbol.type = TAC_SYMBOL_TYPE_VARIABLE;
        list._bindings[i].symbol.variable.data = class_list.class_nodes[class_idx].attributes[i].name;
        list._bindings[i].symbol.variable.version = TAC_request_symbol(&list).symbol;
        list._bindings[i].original_symbol = list._bindings[i].symbol;
    }

    bh_str comment_start_str = bh_str_from_cstr(start_str);

    TAC_list_append(&list, (TACExpr){
                        .operation = TAC_OP_COMMENT,
                        .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = comment_start_str }
                    }, false);

    TAC_list_append(&list, (TACExpr){
                        .operation = TAC_OP_LABEL,
                        .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list._curr_label++ }
                    }, false);

    TACSymbol result = tac_list_from_expression(first_method_body, &list, (TACSymbol){ 0 }, false);
    TAC_list_append(&list, (TACExpr){
                        .operation = TAC_OP_RETURN,
                        .rhs1 = result
                    }, false);

    optimize_tac_list(&list);

    return list;
}

TACList tac_list_from_method(const ClassMethod* method, bh_allocator allocator)
{
    int64_t capacity = 100;
    TACList list = (TACList)
    {
        .allocator = allocator,
        .capacity = capacity,
        .count = 0,
        ._bindings = bh_alloc(allocator, 100 * sizeof(TACBinding)),
        .items = bh_alloc(allocator, capacity * sizeof(TACExpr)),
        ._binding_count = 0
    };

    TACSymbol result = tac_list_from_expression(&method->body, &list, (TACSymbol){ 0 }, false);
    TAC_list_append(&list, (TACExpr){
                        .operation = TAC_OP_RETURN,
                        .rhs1 = result
                    }, false);
    optimize_tac_list(&list);

    return list;
}

TACSymbol get_bound_symbol_variable(const TACList* list, const TACSymbol symbol)
{
    if (symbol.type == TAC_SYMBOL_TYPE_VARIABLE)
    {
        for (int i = list->_binding_count - 1; i >= 0; i--)
        {
            if (bh_str_equal(symbol.variable.data, list->_bindings[i].name))
            {
                return list->_bindings[i].symbol;
            }
        }
    }
    return symbol;
}

int64_t get_symbol_version_for_variable(const TACList* list, const bh_str str)
{
    for (int i = list->count - 1; i >= 0; i--)
    {
        if (list->items[i].lhs.type != TAC_SYMBOL_TYPE_VARIABLE) continue;
        if (bh_str_equal(list->items[i].lhs.variable.data, str))
        {
            return list->items[i].lhs.variable.version;
        }
    }
    return 0;
}

TACSymbol tac_list_from_expression(const CoolExpression* expr, TACList* list, TACSymbol destination, bool add_phi)
{
    if (destination.type == TAC_SYMBOL_TYPE_NULL) destination = TAC_request_symbol(list);
    switch (expr->expression_type)
    {
    case COOL_EXPR_TYPE_ASSIGN:
        {
            TACSymbol dest = (TACSymbol){
                .type = TAC_SYMBOL_TYPE_VARIABLE,
                .variable = {
                    .data = expr->data.assign.var.name,
                    .version = TAC_request_symbol(list).symbol
                }
            };
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_ASSIGN,
                .line_num = expr->line_num,
                .lhs = destination,
                .rhs1 = tac_list_from_expression(expr->data.assign.rhs, list, dest, add_phi)
            };
            TAC_list_append(list, tac, add_phi);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_DYNAMIC_DISPATCH:
    case COOL_EXPR_TYPE_STATIC_DISPATCH:
    case COOL_EXPR_TYPE_SELF_DISPATCH:
        {
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_IGNORE, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = -1 } }, add_phi);
            TACExpr tac = (TACExpr){
                .operation = TAC_OP_CALL,
                .line_num = expr->line_num,
                .lhs = destination,
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_METHOD, .method = { .class_idx = 0, .method_idx = 0 } }
            };
            tac.arg_count = expr->data.dynamic_dispatch.args_length + 1;
            tac.args = bh_alloc(list->allocator, tac.arg_count * sizeof(TACSymbol));
            for (int i = 0; i < expr->data.dynamic_dispatch.args_length; i++)
            {
                TACSymbol arg_symbol = tac_list_from_expression(&expr->data.dynamic_dispatch.args[i], list, (TACSymbol){ 0 }, add_phi);
                tac.args[i] = arg_symbol;
            }

            int64_t class_idx = list->class_idx;
            if (expr->expression_type == COOL_EXPR_TYPE_DYNAMIC_DISPATCH)
            {
                for (int i = 0; i < list->class_list.class_count; i++)
                {
                    if (bh_str_equal(list->class_list.class_nodes[i].name, expr->data.dynamic_dispatch.e->expression_typename))
                    {
                        class_idx = i;
                        break;
                    }
                }
            }
            else if (expr->expression_type == COOL_EXPR_TYPE_STATIC_DISPATCH)
            {
                for (int i = 0; i < list->class_list.class_count; i++)
                {
                    if (bh_str_equal(list->class_list.class_nodes[i].name, expr->data.static_dispatch.type_name.name))
                    {
                        class_idx = -i - 1;
                        break;
                    }
                }
            }

            if (expr->expression_type != COOL_EXPR_TYPE_SELF_DISPATCH)
            {
                TACSymbol result = tac_list_from_expression(expr->data.dynamic_dispatch.e, list, (TACSymbol){ 0 }, add_phi);
                tac.args[tac.arg_count - 1] = result;
            }

            int64_t method_idx = 0;
            ClassNode class_node = list->class_list.class_nodes[class_idx < 0 ? -class_idx - 1 : class_idx];
            for (int i = 0; i < class_node.method_count; i++)
            {
                if (bh_str_equal(class_node.methods[i].name, expr->data.dynamic_dispatch.method.name))
                {
                    method_idx = i;
                    break;
                }
            }

            tac.rhs1.method.class_idx = class_idx;
            tac.rhs1.method.method_idx = method_idx;

            TAC_list_append(list, tac, add_phi);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_INTERNAL:
        {
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_CALL,
                .line_num = expr->line_num,
                .lhs = destination,
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_VARIABLE, .variable = { .data = expr->data.internal.method } }
            };
            TAC_list_append(list, tac, add_phi);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_IF:
        {
            int64_t label_else = list->_curr_label++;
            int64_t label_then = list->_curr_label++;
            int64_t label_join = list->_curr_label++;
            TACSymbol cond = tac_list_from_expression(expr->data.if_expr.predicate, list, (TACSymbol){ 0 }, add_phi);
            const TACExpr bt_true = (TACExpr){
                .operation = TAC_OP_BT,
                .line_num = expr->line_num,
                .lhs = TAC_request_symbol(list),
                .rhs1 = cond,
                .rhs2 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_then }
            };
            TAC_list_append(list, bt_true, add_phi);
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(else_str) }}, add_phi);
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_else }}, add_phi);
            TACSymbol symbol1 = TAC_request_symbol(list);
            int64_t original_binding_count = list->_binding_count;
            TACBinding* original_bindings = bh_alloc(GPA, list->_binding_count * sizeof(TACBinding));
            memcpy(original_bindings, list->_bindings, list->_binding_count * sizeof(TACBinding));
            tac_list_from_expression(expr->data.if_expr.else_branch, list, symbol1, add_phi);
            TACBinding* branch1_bindings = bh_alloc(GPA, list->_binding_count * sizeof(TACBinding));
            memcpy(branch1_bindings, list->_bindings, list->_binding_count * sizeof(TACBinding));
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_JMP, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_join }}, add_phi);
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(then_str) }}, add_phi);
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_then }}, add_phi);
            TACSymbol symbol2 = TAC_request_symbol(list);
            memcpy(list->_bindings, original_bindings, original_binding_count * sizeof(TACBinding));
            list->_binding_count = original_binding_count;
            tac_list_from_expression(expr->data.if_expr.then_branch, list, symbol2, add_phi);
            TACBinding* branch2_bindings = list->_bindings;

            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(if_join_str) }}, add_phi);
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_join }}, add_phi);
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_PHI, .lhs = destination, .rhs1 = symbol1, .rhs2 = symbol2 }, add_phi);
            for (int i = 0; i < original_binding_count; i++)
            {
                if (!tac_symbol_equal(branch1_bindings[i].symbol, branch2_bindings[i].symbol))
                {
                    TACSymbol new_symbol = TAC_request_symbol(list);
                    TAC_list_append(list, (TACExpr){ .operation = TAC_OP_PHI, .lhs = new_symbol, .rhs1 = branch1_bindings[i].symbol, .rhs2 = branch2_bindings[i].symbol }, add_phi);
                    list->_bindings[i].symbol = new_symbol;
                }
            }
            bh_free(GPA, original_bindings);
            bh_free(GPA, branch1_bindings);
            return destination;
        }
    case COOL_EXPR_TYPE_WHILE:
        {
            int64_t label_cond = list->_curr_label++;
            int64_t label_join = list->_curr_label++;

            int64_t original_binding_count = list->_binding_count;
            TACBinding* original_bindings = bh_alloc(GPA, list->_binding_count * sizeof(TACBinding));
            memcpy(original_bindings, list->_bindings, list->_binding_count * sizeof(TACBinding));

            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(while_pred_str) }}, add_phi);
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_cond }}, add_phi);
            int64_t cond_start = list->count;
            TACSymbol cond = tac_list_from_expression(expr->data.while_expr.predicate, list, (TACSymbol){ 0 }, add_phi);
            TACSymbol not_cond_symbol = TAC_request_symbol(list);
            const TACExpr not_cond = (TACExpr){ .operation = TAC_OP_NOT, .lhs = not_cond_symbol, .rhs1 = cond };
            TAC_list_append(list, not_cond, add_phi);
            const TACExpr bt_false = (TACExpr){
                .operation = TAC_OP_BT,
                .line_num = expr->line_num,
                .lhs = (TACSymbol){ 0 },
                .rhs1 = not_cond_symbol,
                .rhs2 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_join }
            };
            TAC_list_append(list, bt_false, add_phi);
            TACSlice cond_slice = (TACSlice){ .items = &list->items[cond_start], .count = list->count - cond_start };

            int64_t body_start = list->count;
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(while_body_str) }}, add_phi);
            tac_list_from_expression(expr->data.while_expr.body, list, TAC_request_symbol(list), add_phi);
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_JMP, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_cond }}, add_phi);
            TACSlice body_slice = (TACSlice){ .items = &list->items[body_start], .count = list->count - body_start };

            for (int i = 0; i < original_binding_count; i++)
            {
                if (!tac_symbol_equal(list->_bindings[i].symbol, original_bindings[i].symbol))
                {
                    TACSymbol new_symbol = TAC_request_symbol(list);
                    if (list->_bindings[i].symbol.type == TAC_SYMBOL_TYPE_VARIABLE)
                    {
                        new_symbol.type = TAC_SYMBOL_TYPE_VARIABLE;
                        new_symbol.variable.data = list->_bindings[i].symbol.variable.data;
                    }
                    const TACExpr phi = (TACExpr){
                        .operation = TAC_OP_PHI,
                        .line_num = expr->line_num,
                        .lhs = new_symbol,
                        .rhs1 = list->_bindings[i].symbol,
                        .rhs2 = original_bindings[i].symbol
                    };
                    TAC_list_insert_at(list, phi, cond_start);
                    cond_slice.count += 1;
                    list->_bindings[i].symbol = new_symbol;

                    for (int j = i; j < cond_slice.count; j++)
                    {
                        if (tac_symbol_equal(cond_slice.items[j].rhs1, original_bindings[i].symbol))
                        {
                            cond_slice.items[j].rhs1 = new_symbol;
                        }
                        if (tac_symbol_equal(cond_slice.items[j].rhs2, original_bindings[i].symbol))
                        {
                            cond_slice.items[j].rhs2 = new_symbol;
                        }
                    }

                    for (int j = 0; j < body_slice.count; j++)
                    {
                        if (tac_symbol_equal(body_slice.items[j].rhs1, original_bindings[i].symbol))
                        {
                            body_slice.items[j].rhs1 = new_symbol;
                        }
                        if (tac_symbol_equal(body_slice.items[j].rhs2, original_bindings[i].symbol))
                        {
                            body_slice.items[j].rhs2 = new_symbol;
                        }
                    }
                }
            }

            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(while_join_str) }}, add_phi);
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_join } }, add_phi);
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_DEFAULT, .lhs = destination, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(object_str) }}, add_phi);

            bh_free(GPA, original_bindings);
            return destination;
        }
        break;
    case COOL_EXPR_TYPE_BLOCK:
        {
            for (int i = 0; i < expr->data.block.body_length; i++)
            {
                int is_last = i == expr->data.block.body_length - 1;
                tac_list_from_expression(&expr->data.block.body[i], list, is_last ? destination : (TACSymbol){ 0 }, add_phi);
            }
            return destination;
        }
    case COOL_EXPR_TYPE_NEW:
        {
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_NEW,
                .line_num = expr->line_num,
                .lhs = destination,
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_VARIABLE, .variable = { .data = expr->data.new_expr.class_name.name } }
            };
            TAC_list_append(list, tac, add_phi);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_ISVOID:
        {
            TACSymbol ta1 = tac_list_from_expression(expr->data.isvoid.e, list, (TACSymbol){ 0 }, add_phi);
            TACExpr tac = (TACExpr) {
                .operation = TAC_OP_ISVOID,
                .line_num = expr->line_num,
                .lhs = destination,
                .rhs1 = ta1,
            };
            TAC_list_append(list, tac, add_phi);
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
            if (expr->expression_type == COOL_EXPR_TYPE_LT ||
                expr->expression_type == COOL_EXPR_TYPE_EQ ||
                expr->expression_type == COOL_EXPR_TYPE_LE)
            {
                TAC_list_append(list, (TACExpr){ .operation = TAC_OP_IGNORE, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = -1 } }, add_phi);
            }
            TACSymbol dest1 = TAC_request_symbol(list);
            TACSymbol dest2 = TAC_request_symbol(list);
            TACSymbol ta1 = tac_list_from_expression(expr->data.binary.x, list, dest1, add_phi);
            TACSymbol ta2 = tac_list_from_expression(expr->data.binary.y, list, dest2, add_phi);
            TACExpr tac = (TACExpr) {
                .operation = expr->expression_type - (COOL_EXPR_TYPE_PLUS - TAC_OP_PLUS),
                .line_num = expr->line_num,
                .lhs = destination,
                .rhs1 = ta1,
                .rhs2 = ta2
            };
            TAC_list_append(list, tac, add_phi);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_NOT:
    case COOL_EXPR_TYPE_NEGATE:
        {
            TACSymbol ta1 = tac_list_from_expression(expr->data.unary.x, list, (TACSymbol){ 0 }, add_phi);
            TACExpr tac = (TACExpr) {
                .operation = expr->expression_type - (COOL_EXPR_TYPE_NOT - TAC_OP_NOT),
                .line_num = expr->line_num,
                .lhs = destination,
                .rhs1 = ta1,
            };
            TAC_list_append(list, tac, add_phi);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_INTEGER:
        {
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_INT,
                .line_num = expr->line_num,
                .lhs = destination,
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = expr->data.integer.value }
            };
            TAC_list_append(list, tac, add_phi);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_STRING:
        {
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_STRING,
                .line_num = expr->line_num,
                .lhs = destination,
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = expr->data.string.value }
            };
            TAC_list_append(list, tac, add_phi);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_IDENTIFIER:
        {
            TACSymbol rhs = (TACSymbol){
                .type = TAC_SYMBOL_TYPE_VARIABLE,
                .variable = {
                    .data = expr->data.identifier.variable.name,
                    .version = get_symbol_version_for_variable(list, expr->data.identifier.variable.name)
                }
            };
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_ASSIGN,
                .line_num = expr->line_num,
                .lhs = destination,
                .rhs1 = rhs
            };
            TAC_list_append(list, tac, add_phi);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_TRUE:
    case COOL_EXPR_TYPE_FALSE:
        {
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_BOOL,
                .line_num = expr->line_num,
                .lhs = destination,
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_BOOL, .integer = expr->expression_type == COOL_EXPR_TYPE_TRUE }
            };
            TAC_list_append(list, tac, add_phi);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_LET:
        {
            int64_t initial_binding_count = list->_binding_count;
            for (int i = 0; i < expr->data.let.binding_count; i++)
            {
                TACSymbol new_symbol = TAC_request_symbol(list);
                list->_bindings[list->_binding_count] = (TACBinding){
                    .name = expr->data.let.bindings[i].variable.name,
                    .symbol = new_symbol,
                    .original_symbol = new_symbol
                };

                if (expr->data.let.bindings[i].exp)
                {
                    tac_list_from_expression(expr->data.let.bindings[i].exp, list, list->_bindings[list->_binding_count].symbol, add_phi);
                }
                else
                {
                    TACExpr default_expr = (TACExpr){
                        .operation = TAC_OP_DEFAULT,
                        .lhs = list->_bindings[list->_binding_count].symbol,
                        .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_VARIABLE, .variable = { .data = expr->data.let.bindings[i].type_name.name } }
                    };
                    TAC_list_append(list, default_expr, add_phi);
                }

                list->_bindings[list->_binding_count] = (TACBinding){
                    .name = expr->data.let.bindings[i].variable.name,
                    .symbol = new_symbol,
                    .original_symbol = new_symbol
                };

                list->_binding_count += 1;
            }
            tac_list_from_expression(expr->data.let.expr, list, destination, add_phi);
            list->_binding_count = initial_binding_count;
            return destination;
        }
    case COOL_EXPR_TYPE_CASE:
        {
            // Generate all the if statements
            TACSymbol expr_symbol = TAC_request_symbol(list);
            tac_list_from_expression(expr->data.case_expr.expr, list, expr_symbol, add_phi);

            int64_t void_label = list->_curr_label++;
            int64_t error_label = list->_curr_label++;
            int64_t case_count = expr->data.case_expr.element_count;

            TACSymbol expr_is_void = TAC_request_symbol(list);
            TACExpr isvoid_expr = (TACExpr) {
                .operation = TAC_OP_ISVOID,
                .line_num = expr->line_num,
                .lhs = expr_is_void,
                .rhs1 = expr_symbol,
            };
            TAC_list_append(list, isvoid_expr, add_phi);
            TAC_list_append(list, (TACExpr){
                .operation = TAC_OP_BT,
                .line_num = expr->line_num,
                .rhs1 = expr_is_void,
                .rhs2 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = void_label }
            }, add_phi);

            // Figre out which class maps to which label
            for (int i = 0; i < list->class_list.class_count; i++)
            {
                ClassNode class_node = list->class_list.class_nodes[i];
                int64_t class_tag = i;
                if (bh_str_equal_lit(class_node.name, "Bool")) class_tag = -1;
                if (bh_str_equal_lit(class_node.name, "Int")) class_tag = -2;
                if (bh_str_equal_lit(class_node.name, "String")) class_tag = -3;

                // figure out which case branch it is mapped to
                ClassNode* branch_class = &class_node;
                int64_t correct_branch = -1;
                while (branch_class != NULL && correct_branch == -1)
                {
                    for (int k = 0; k < case_count; k++)
                    {
                        CoolCaseElement element = expr->data.case_expr.elements[k];
                        if (bh_str_equal(element.type_name.name, branch_class->name))
                        {
                            correct_branch = k;
                            break;
                        }
                    }

                    branch_class = branch_class->parent;
                }

                // generate the TAC expressions to branch to the correct label
                TACSymbol cond = TAC_request_symbol(list);
                TAC_list_append(list, (TACExpr){
                    .operation = TAC_OP_IS_CLASS,
                    .lhs = cond,
                    .rhs1 = expr_symbol,
                    .rhs2 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_CLASSIDX, .integer = class_tag }
                }, add_phi);
                if (correct_branch == -1)
                {
                    TAC_list_append(list, (TACExpr){
                        .operation = TAC_OP_BT,
                        .rhs1 = cond,
                        .rhs2 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = error_label }
                    }, add_phi);
                }
                else
                {
                    TAC_list_append(list, (TACExpr){
                        .operation = TAC_OP_BT,
                        .rhs1 = cond,
                        .rhs2 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list->_curr_label + correct_branch }
                    }, add_phi);
                }
            }

            // TODO: remove codegen for unnecessary labels that are never hit (look at AST types)

            int64_t join_label = list->_curr_label + expr->data.case_expr.element_count;

            // if value is void
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = void_label }}, add_phi);
            bh_str void_str = bh_str_alloc_cstr(list->allocator, "case on void");
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_RUNTIME_ERROR, .line_num = expr->line_num, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = void_str }}, add_phi);

            // if no matching branch found
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = error_label }}, add_phi);
            bh_str error_str = bh_str_alloc_cstr(list->allocator, "case without matching branch");
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_RUNTIME_ERROR, .line_num = expr->line_num, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = error_str }}, add_phi);

            // each branch expressions as TAC
            int64_t base_label = list->_curr_label;
            int64_t base_dest = list->_curr_symbol;
            list->_curr_label += expr->data.case_expr.element_count + 1;
            list->_curr_symbol += expr->data.case_expr.element_count;
            for (int i = 0; i < expr->data.case_expr.element_count; i++)
            {
                // Label setup
                TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = base_label + i }}, add_phi);
                TACSymbol branch_dest = (TACSymbol){ .type = TAC_SYMBOL_TYPE_SYMBOL, .symbol = base_dest + i };

                // Add binding
                list->_bindings[list->_binding_count] = (TACBinding){
                    .name = expr->data.case_expr.elements[i].variable.name,
                    .symbol = expr_symbol,
                    .original_symbol = expr_symbol
                };
                list->_binding_count += 1;

                tac_list_from_expression(expr->data.case_expr.elements[i].body, list, branch_dest, add_phi);

                list->_binding_count -= 1;

                if (i < expr->data.case_expr.element_count - 1) // no need to jump on the last one
                {
                    TAC_list_append(list, (TACExpr){ .operation = TAC_OP_JMP, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = join_label }}, add_phi);
                }
            }

            // case join (phi functions)
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = join_label } }, add_phi);
            TACSymbol last_symbol = (TACSymbol){ .type = TAC_SYMBOL_TYPE_SYMBOL, .symbol = base_dest };
            for (int i = 1; i < expr->data.case_expr.element_count; i++)
            {
                TACSymbol new_symbol = i == expr->data.case_expr.element_count - 1 ? destination : TAC_request_symbol(list);
                TACSymbol branch_dest = (TACSymbol){ .type = TAC_SYMBOL_TYPE_SYMBOL, .symbol = base_dest + i };
                TAC_list_append(list, (TACExpr){ .operation = TAC_OP_PHI, .lhs = new_symbol, .rhs1 = last_symbol, .rhs2 = branch_dest }, add_phi);
                last_symbol = new_symbol;
            }
            if (expr->data.case_expr.element_count == 1)
            {
                TAC_list_append(list, (TACExpr){ .operation = TAC_OP_ASSIGN, .lhs = destination, .rhs1 = last_symbol }, add_phi);
            }
            return destination;
        }
    default:
        assert(0 && "Unhandled expression type when generating TAC");
        break;
    }

    return (TACSymbol){ 0 };
}

bool tac_symbol_equal(const TACSymbol s1, const TACSymbol s2)
{
    if (s1.type != s2.type) return false;
    switch (s1.type) {
    case TAC_SYMBOL_TYPE_SYMBOL:
        return s1.symbol == s2.symbol;
    case TAC_SYMBOL_TYPE_INTEGER:
        return s1.integer == s2.integer;
    case TAC_SYMBOL_TYPE_STRING:
        return s1.string.version == s2.string.version && bh_str_equal(s1.string.data, s2.string.data);
    case TAC_SYMBOL_TYPE_VARIABLE:
        return s1.variable.version == s2.variable.version && bh_str_equal(s1.variable.data, s2.variable.data);
    case TAC_SYMBOL_TYPE_METHOD:
        return s1.method.class_idx == s2.method.class_idx && s1.method.method_idx == s2.method.method_idx;
    case TAC_SYMBOL_TYPE_EXPRESSION:
        return s1.expression == s2.expression;  // Compare pointers to expressions
    default:
        return false;  // Unknown type
    }
}

void generate_cfg_for_tac_list(TACList* tac_list)
{
    CFG cfg = (CFG){ 0 };
    cfg.block_capacity = 1;
    cfg.blocks = bh_alloc(tac_list->allocator, sizeof(CFGBlock) * 1);

    // Separate the TAC into parts based on control flow
    int block_len = 0;
    int block_start = 0;
    for (int k = 0; k < tac_list->count; k++)
    {
        block_len += 1;

        TACExpr expr = tac_list->items[k];
        if (expr.operation == TAC_OP_JMP ||
            expr.operation == TAC_OP_BT)
        {
            CFGBlock block = (CFGBlock){
                .id = cfg.block_count + 1,
                .tac_contents = (TACSlice){ .count = block_len, .items = &tac_list->items[block_start] }
            };

            if (expr.operation == TAC_OP_JMP)
            {
                block.next[0] = &cfg.blocks[expr.rhs1.integer + 1];
            }
            if (expr.operation == TAC_OP_BT)
            {
                block.next[0] = &cfg.blocks[cfg.block_count + 1];
                block.next[1] = &cfg.blocks[expr.rhs2.integer + 1];
            }

            if (cfg.block_count + 1 > cfg.block_capacity)
            {
                cfg.blocks = bh_realloc(tac_list->allocator, cfg.blocks, sizeof(CFGBlock) * cfg.block_capacity * 2);
                cfg.block_capacity *= 2;
            }

            cfg.blocks[cfg.block_count++] = block;
            block_len = 0;
            block_start = k + 1;
        }
    }

    if (block_len > 0)
    {
        CFGBlock block = (CFGBlock){
            .id = cfg.block_count + 1,
            .tac_contents = (TACSlice){ .count = block_len, .items = &tac_list->items[block_start] }
        };

        if (cfg.block_count + 1 > cfg.block_capacity)
        {
            bh_realloc(tac_list->allocator, cfg.blocks, sizeof(CFGBlock) * cfg.block_capacity * 2);
            cfg.block_capacity *= 2;
        }

        cfg.blocks[cfg.block_count++] = block;
    }

    tac_list->cfg = cfg;
}