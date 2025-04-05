//
// Created by Brandon Howe on 3/5/25.
//

#include "tac.h"

#include <assert.h>
#include <string.h>
#include <sys/mman.h>

TACExpr* TAC_list_append(TACList* list, TACExpr expr)
{
    expr.lhs = get_bound_symbol_variable(list, expr.lhs);
    expr.rhs1 = get_bound_symbol_variable(list, expr.rhs1);
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

TACList TAC_list_init(const int64_t capacity, bh_allocator allocator)
{
#ifdef WIN32
    TACExpr* data = VirtualAlloc(NULL, 10000000, MEM_RESERVE, PAGE_NOACCESS);
    VirtualAlloc(data, base_capacity * sizeof(TACExpr), MEM_COMMIT, PAGE_READWRITE);
#else
    TACExpr* data = mmap(NULL, 10000000, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
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

    bh_str comment_start_str = bh_str_from_cstr(start_str);

    TAC_list_append(&list, (TACExpr){
        .operation = TAC_OP_COMMENT,
        .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = comment_start_str }
    });

    TAC_list_append(&list, (TACExpr){
        .operation = TAC_OP_LABEL,
        .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list._curr_label++ }
    });

    TACSymbol result = tac_list_from_expression(first_method_body, &list, (TACSymbol){ 0 });

    TAC_list_append(&list, (TACExpr){
        .operation = TAC_OP_RETURN,
        .rhs1 = result
    });

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

    TACSymbol result = tac_list_from_expression(&method->body, &list, (TACSymbol){ 0 });

    TAC_list_append(&list, (TACExpr){
        .operation = TAC_OP_RETURN,
        .rhs1 = result
    });

    return list;
}

TACSymbol get_bound_symbol_variable(const TACList* list, const TACSymbol symbol)
{
    if (symbol.type == TAC_SYMBOL_TYPE_VARIABLE)
    {
        for (int i = list->_binding_count - 1; i >= 0; i--)
        {
            if (bh_str_equal(symbol.variable, list->_bindings[i].name))
            {
                return list->_bindings[i].symbol;
            }
        }
    }
    return symbol;
}

TACSymbol tac_list_from_expression(const CoolExpression* expr, TACList* list, TACSymbol destination)
{
    if (destination.type == TAC_SYMBOL_TYPE_NULL) destination = TAC_request_symbol(list);
    switch (expr->expression_type)
    {
    case COOL_EXPR_TYPE_ASSIGN:
        {
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_ASSIGN,
                .lhs = destination,
                .rhs1 = tac_list_from_expression(expr->data.assign.rhs, list, (TACSymbol){ .type = TAC_SYMBOL_TYPE_VARIABLE, .variable = expr->data.assign.var.name })
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_DYNAMIC_DISPATCH:
    case COOL_EXPR_TYPE_STATIC_DISPATCH:
    case COOL_EXPR_TYPE_SELF_DISPATCH:
        {
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_IGNORE, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = -1 } });
            TACExpr tac = (TACExpr){
                .operation = TAC_OP_CALL,
                .lhs = destination,
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_METHOD, .method = { .class_idx = 0, .method_idx = 0 } }
            };
            tac.arg_count = expr->data.dynamic_dispatch.args_length + 1;
            tac.args = bh_alloc(list->allocator, tac.arg_count * sizeof(TACSymbol));
            for (int i = 0; i < expr->data.dynamic_dispatch.args_length; i++)
            {
                TACSymbol arg_symbol = tac_list_from_expression(&expr->data.dynamic_dispatch.args[i], list, (TACSymbol){ 0 });
                tac.args[i] = arg_symbol;
            }

            int64_t class_idx = list->class_idx;
            if (expr->expression_type != COOL_EXPR_TYPE_SELF_DISPATCH)
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

            if (expr->expression_type != COOL_EXPR_TYPE_SELF_DISPATCH)
            {
                TACSymbol result = tac_list_from_expression(expr->data.dynamic_dispatch.e, list, (TACSymbol){ 0 });
                tac.args[tac.arg_count - 1] = result;
            }

            int64_t method_idx = 0;
            ClassNode class_node = list->class_list.class_nodes[class_idx];
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

            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_INTERNAL:
        {
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_CALL,
                .lhs = destination,
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = expr->data.internal.method }
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_IF:
        {
            int64_t label_else = list->_curr_label++;
            int64_t label_then = list->_curr_label++;
            int64_t label_join = list->_curr_label++;
            TACSymbol cond = tac_list_from_expression(expr->data.if_expr.predicate, list, (TACSymbol){ 0 });
            const TACExpr bt_true = (TACExpr){
                .operation = TAC_OP_BT,
                .lhs = TAC_request_symbol(list),
                .rhs1 = cond,
                .rhs2 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_then }
            };
            TAC_list_append(list, bt_true);
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(else_str) }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_else }});
            tac_list_from_expression(expr->data.if_expr.else_branch, list, destination);
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_JMP, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_join }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(then_str) }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_then }});
            tac_list_from_expression(expr->data.if_expr.then_branch, list, destination);
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_JMP, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_join }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(if_join_str) }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_join }});
            return destination;
        }
    case COOL_EXPR_TYPE_WHILE:
        {
            int64_t label_cond = list->_curr_label++;
            int64_t label_join = list->_curr_label++;

            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(while_pred_str) }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_cond }});
            TACSymbol cond = tac_list_from_expression(expr->data.while_expr.predicate, list, (TACSymbol){ 0 });
            const TACExpr not_cond = (TACExpr){ .operation = TAC_OP_NOT, .lhs = destination, .rhs1 = cond };
            TAC_list_append(list, not_cond);
            const TACExpr bt_false = (TACExpr){
                .operation = TAC_OP_BT,
                .lhs = destination,
                .rhs1 = not_cond.lhs,
                .rhs2 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_join }
            };
            TAC_list_append(list, bt_false);

            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(while_body_str) }});
            tac_list_from_expression(expr->data.while_expr.body, list, TAC_request_symbol(list));
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_JMP, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = list->_curr_label - 2 }});

            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_COMMENT, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(while_join_str) }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_LABEL, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = label_join }});
            TAC_list_append(list, (TACExpr){ .operation = TAC_OP_DEFAULT, .lhs = destination, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = bh_str_from_cstr(object_str) }});

            return destination;
        }
        break;
    case COOL_EXPR_TYPE_BLOCK:
        {
            for (int i = 0; i < expr->data.block.body_length; i++)
            {
                int is_last = i == expr->data.block.body_length - 1;
                tac_list_from_expression(&expr->data.block.body[i], list, is_last ? destination : (TACSymbol){ 0 });
            }
            return destination;
        }
    case COOL_EXPR_TYPE_NEW:
        {
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_NEW,
                .lhs = destination,
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_VARIABLE, .variable = expr->data.new_expr.class_name.name }
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_ISVOID:
        {
            TACSymbol ta1 = tac_list_from_expression(expr->data.isvoid.e, list, (TACSymbol){ 0 });
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
            if (expr->expression_type == COOL_EXPR_TYPE_LT ||
                expr->expression_type == COOL_EXPR_TYPE_EQ ||
                expr->expression_type == COOL_EXPR_TYPE_LE)
            {
                TAC_list_append(list, (TACExpr){ .operation = TAC_OP_IGNORE, .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = -1 } });
            }
            TACSymbol dest1 = TAC_request_symbol(list);
            TACSymbol dest2 = TAC_request_symbol(list);
            TACSymbol ta1 = tac_list_from_expression(expr->data.binary.x, list, dest1);
            TACSymbol ta2 = tac_list_from_expression(expr->data.binary.y, list, dest2);
            TACExpr tac = (TACExpr) {
                .operation = expr->expression_type - (COOL_EXPR_TYPE_PLUS - TAC_OP_PLUS),
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
            TACSymbol ta1 = tac_list_from_expression(expr->data.unary.x, list, (TACSymbol){ 0 });
            TACExpr tac = (TACExpr) {
                .operation = expr->expression_type - (COOL_EXPR_TYPE_NOT - TAC_OP_NOT),
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
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = expr->data.integer.value }
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_STRING:
        {
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_STRING,
                .lhs = destination,
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = expr->data.string.value }
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_IDENTIFIER:
        {
            TACSymbol rhs = (TACSymbol){
                .type = TAC_SYMBOL_TYPE_VARIABLE,
                .variable = expr->data.identifier.variable.name
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
                .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_BOOL, .integer = expr->expression_type == COOL_EXPR_TYPE_TRUE }
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    case COOL_EXPR_TYPE_LET:
        {
            int64_t initial_binding_count = list->_binding_count;
            for (int i = 0; i < expr->data.let.binding_count; i++)
            {
                list->_bindings[list->_binding_count] = (TACBinding){
                    .name = expr->data.let.bindings[i].variable.name,
                    .symbol = TAC_request_symbol(list)
                };

                if (expr->data.let.bindings[i].exp)
                {
                    tac_list_from_expression(expr->data.let.bindings[i].exp, list, list->_bindings[list->_binding_count].symbol);
                }
                else
                {
                    TACExpr default_expr = (TACExpr){
                        .operation = TAC_OP_DEFAULT,
                        .lhs = list->_bindings[list->_binding_count].symbol,
                        .rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_VARIABLE, .variable = expr->data.let.bindings[i].type_name.name }
                    };
                    TAC_list_append(list, default_expr);
                }

                list->_binding_count += 1;
            }
            tac_list_from_expression(expr->data.let.expr, list, destination);
            list->_binding_count = initial_binding_count;
            return destination;
        }
    case COOL_EXPR_TYPE_CASE:
        {
            TACSymbol dest1 = TAC_request_symbol(list);
            tac_list_from_expression(expr->data.case_expr.expr, list, dest1);
            const TACExpr tac = (TACExpr){
                .operation = TAC_OP_CASE,
                .lhs = destination,
                .rhs1 = dest1,
                .rhs2 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_EXPRESSION, .expression = expr },
            };
            TAC_list_append(list, tac);
            return tac.lhs;
        }
    default:
        assert(0 && "Unhandled expression type when generating TAC");
        break;
    }

    return (TACSymbol){ 0 };
}
