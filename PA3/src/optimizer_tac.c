//
// Created by Brandon Howe on 4/7/25.
//

#include <string.h>
#include "optimizer_tac.h"

#include "profiler.h"

void remove_duplicate_phi_expressions(TACList* list)
{
    for (int i = 0; i < list->count; i++)
    {
        if (list->items[i].operation == TAC_OP_PHI)
        {
            for (int j = i + 1; j < list->count; j++)
            {
                if (list->items[j].operation == TAC_OP_PHI)
                {
                    if ((tac_symbol_equal(list->items[i].rhs1, list->items[j].rhs1) &&
                        tac_symbol_equal(list->items[i].rhs2, list->items[j].rhs2)) ||
                        (tac_symbol_equal(list->items[i].rhs1, list->items[j].rhs2) &&
                        tac_symbol_equal(list->items[i].rhs2, list->items[j].rhs1)))
                    {
                        list->items[j].operation = TAC_OP_ASSIGN;
                        list->items[j].rhs1 = list->items[i].lhs;
                        list->items[j].rhs2 = (TACSymbol){ 0 };
                    }
                }
            }
        }
    }
}

void remove_phi_expressions(TACList* list)
{
    int64_t max_phi = 0;
    for (int i = 0; i < list->count; i++)
    {
        if (list->items[i].operation == TAC_OP_PHI)
        {
            if (list->items[i].rhs1.symbol > max_phi) max_phi = list->items[i].rhs1.symbol;
            if (list->items[i].rhs2.symbol > max_phi) max_phi = list->items[i].rhs2.symbol;
        }
    }
    max_phi += 1;
    TACSymbol* phi_bindings = bh_alloc(GPA, max_phi * sizeof(TACSymbol));
    memset(phi_bindings, 0, max_phi * sizeof(TACSymbol));
    for (int i = 0; i < list->count; i++)
    {
        if (list->items[i].operation == TAC_OP_PHI)
        {
            phi_bindings[list->items[i].rhs1.symbol] = list->items[i].lhs;
            phi_bindings[list->items[i].rhs2.symbol] = list->items[i].lhs;
        }
    }

    PROFILE_BLOCK
    bool rerun_needed = true;
    while (rerun_needed)
    {
        rerun_needed = false;
        for (int i = 0; i < list->count; i++)
        {
            TACExpr e = list->items[i];
            // if (e.operation != TAC_OP_PHI)
            {
                if ((e.rhs1.type == TAC_SYMBOL_TYPE_VARIABLE || e.rhs1.type == TAC_SYMBOL_TYPE_SYMBOL || e.rhs1.type == TAC_SYMBOL_TYPE_REGISTER) &&
                    e.rhs1.symbol < max_phi &&
                    phi_bindings[e.rhs1.symbol].type > 0 &&
                    !tac_symbol_equal(list->items[i].rhs1, phi_bindings[e.rhs1.symbol]))
                {
                    list->items[i].rhs1 = phi_bindings[e.rhs1.symbol];
                    rerun_needed = true;
                }
                if ((e.rhs2.type == TAC_SYMBOL_TYPE_VARIABLE || e.rhs2.type == TAC_SYMBOL_TYPE_SYMBOL || e.rhs2.type == TAC_SYMBOL_TYPE_REGISTER) &&
                    e.rhs2.symbol < max_phi &&
                    phi_bindings[e.rhs2.symbol].type > 0 &&
                    !tac_symbol_equal(list->items[i].rhs2, phi_bindings[e.rhs2.symbol]))
                {
                    list->items[i].rhs2 = phi_bindings[e.rhs2.symbol];
                    rerun_needed = true;
                }
                for (int j = 0; j < e.arg_count; j++)
                {
                    TACSymbol arg = e.args[j];
                    if ((arg.type == TAC_SYMBOL_TYPE_VARIABLE || arg.type == TAC_SYMBOL_TYPE_SYMBOL || arg.type == TAC_SYMBOL_TYPE_REGISTER) &&
                        arg.symbol < max_phi &&
                        phi_bindings[arg.symbol].type > 0 &&
                        !tac_symbol_equal(list->items[i].args[j], phi_bindings[arg.symbol]))
                    {
                        list->items[i].args[j] = phi_bindings[arg.symbol];
                        rerun_needed = true;
                    }
                }
            }
            if ((e.lhs.type == TAC_SYMBOL_TYPE_VARIABLE || e.lhs.type == TAC_SYMBOL_TYPE_SYMBOL || e.lhs.type == TAC_SYMBOL_TYPE_REGISTER) && e.lhs.symbol < max_phi && phi_bindings[e.lhs.symbol].type > 0)
            {
                list->items[i].lhs = phi_bindings[e.lhs.symbol];
                rerun_needed = true;
            }
        }
        TACSymbol* phi_bindings_copy = bh_alloc(GPA, max_phi * sizeof(TACSymbol));
        //TODO: figure out cyclical phis
        for (int i = 0; i < max_phi; i++)
        {
            if (phi_bindings_copy[phi_bindings_copy[i].symbol].symbol > phi_bindings_copy[i].symbol)
            {
                phi_bindings[i] = phi_bindings_copy[phi_bindings_copy[i].symbol];
            }
        }
        bh_free(GPA, phi_bindings_copy);
    }
    bh_free(GPA, phi_bindings);

    for (int i = list->count - 1; i >= 0; i--)
    {
        if (list->items[i].operation == TAC_OP_PHI)
        {
            list->count -= 1;
            memmove(&list->items[i], &list->items[i + 1], (list->count - i) * sizeof(TACExpr));
        }
    }
}

void mark_symbol_live(TACList* list, bool* live_status, TACSymbol symbol)
{
    if (symbol.type != TAC_SYMBOL_TYPE_SYMBOL && symbol.type != TAC_SYMBOL_TYPE_VARIABLE)
    {
        return;
    }
    for (int i = list->count - 1; i >= 0; i--)
    {
        bool is_live = false;
        if (live_status[i]) continue;
        if (symbol.type == TAC_SYMBOL_TYPE_SYMBOL)
        {
            if (list->items[i].lhs.type == TAC_SYMBOL_TYPE_SYMBOL && list->items[i].lhs.symbol == symbol.symbol)
            {
                is_live = true;
            }
        }
        else if (symbol.type == TAC_SYMBOL_TYPE_VARIABLE)
        {
            if (list->items[i].lhs.type == TAC_SYMBOL_TYPE_VARIABLE &&
                bh_str_equal(list->items[i].lhs.variable.data, symbol.variable.data) &&
                list->items[i].lhs.variable.version == symbol.variable.version)
            {
                is_live = true;
            }
        }
        if (is_live)
        {
            live_status[i] = true;
            if (!tac_symbol_equal(list->items[i].rhs1, list->items[i].lhs)) mark_symbol_live(list, live_status, list->items[i].rhs1);
            if (!tac_symbol_equal(list->items[i].rhs2, list->items[i].lhs)) mark_symbol_live(list, live_status, list->items[i].rhs2);
            for (int j = 0; j < list->items[i].arg_count; j++)
            {
                mark_symbol_live(list, live_status, list->items[i].args[j]);
            }
            break;
        }
    }
}

void eliminate_dead_tac(TACList* list)
{
    bh_allocator allocator = GPA;
    if (list->count > 2000) return;

    bool* live_status = bh_alloc(allocator, sizeof(bool) * list->count);

    for (int i = 0; i < list->count; i++)
    {
        if (list->items[i].operation == TAC_OP_CALL)
        {
            // live_status[i] = true;
            mark_symbol_live(list, live_status, list->items[i].lhs);
        }
        if (list->items[i].operation == TAC_OP_JMP || list->items[i].operation == TAC_OP_LABEL)
        {
            live_status[i] = true;
        }
        if (list->items[i].operation == TAC_OP_BT)
        {
            live_status[i] = true;
            mark_symbol_live(list, live_status, list->items[i].rhs1);
        }
        if (list->items[i].operation == TAC_OP_PHI)
        {
            live_status[i] = true;
            mark_symbol_live(list, live_status, list->items[i].rhs1);
            mark_symbol_live(list, live_status, list->items[i].rhs2);
        }
        if (list->items[i].operation == TAC_OP_RETURN || list->items[i].operation == TAC_OP_IGNORE)
        {
            live_status[i] = true;
        }
        if (list->items[i].operation == TAC_OP_RUNTIME_ERROR)
        {
            live_status[i] = true;
        }
        if (list->items[i].lhs.type == TAC_SYMBOL_TYPE_VARIABLE)
        {
            // live_status[i] = true;
            mark_symbol_live(list, live_status, list->items[i].lhs);
        }
    }
    if (list->items[list->count - 1].operation == TAC_OP_RETURN)
    {
        mark_symbol_live(list, live_status, list->items[list->count - 1].rhs1);
    }
    else
    {
        mark_symbol_live(list, live_status, (TACSymbol){ .type = TAC_SYMBOL_TYPE_SYMBOL, .symbol = 0 });
    }

    // Remove unused expressions
    int64_t unused_count = 0;
    for (int i = 0; i < list->count; i++)
    {
        if (live_status[i])
        {
            list->items[i - unused_count] = list->items[i];
        }
        else
        {
            unused_count += 1;
        }
    }
    list->count -= unused_count;
}

int64_t compress_tac_symbols(TACList* list, int64_t* symbols, int64_t old_max_symbol, int64_t starting_symbol)
{
    int64_t max_symbol = old_max_symbol;
    for (int i = 0; i < list->count; i++)
    {
        TACExpr e = list->items[i];
        if ((e.lhs.type == TAC_SYMBOL_TYPE_SYMBOL || e.lhs.type == TAC_SYMBOL_TYPE_VARIABLE) && e.lhs.symbol > max_symbol) max_symbol = e.lhs.symbol;
        if ((e.rhs1.type == TAC_SYMBOL_TYPE_SYMBOL || e.rhs1.type == TAC_SYMBOL_TYPE_VARIABLE) && e.rhs1.symbol > max_symbol) max_symbol = e.rhs1.symbol;
        if ((e.rhs2.type == TAC_SYMBOL_TYPE_SYMBOL || e.rhs2.type == TAC_SYMBOL_TYPE_VARIABLE) && e.rhs2.symbol > max_symbol) max_symbol = e.rhs2.symbol;
    }
    max_symbol += 1;

    symbols = bh_realloc(GPA, symbols, max_symbol * sizeof(int64_t));
    memset(&symbols[old_max_symbol], -1, (max_symbol - old_max_symbol) * sizeof(int64_t));

    int64_t current_symbol = starting_symbol;
    for (int i = 0; i < list->count; i++)
    {
        if (list->items[i].rhs1.type == TAC_SYMBOL_TYPE_SYMBOL || list->items[i].rhs1.type == TAC_SYMBOL_TYPE_VARIABLE)
        {
            if (symbols[list->items[i].rhs1.symbol] > -1)
            {
                list->items[i].rhs1.symbol = symbols[list->items[i].rhs1.symbol];
            }
            else
            {
                symbols[list->items[i].rhs1.symbol] = current_symbol;
                list->items[i].rhs1.symbol = current_symbol;
                current_symbol++;
            }
        }
        if (list->items[i].rhs2.type == TAC_SYMBOL_TYPE_SYMBOL || list->items[i].rhs2.type == TAC_SYMBOL_TYPE_VARIABLE)
        {
            if (symbols[list->items[i].rhs2.symbol] > -1)
            {
                list->items[i].rhs2.symbol = symbols[list->items[i].rhs2.symbol];
            }
            else
            {
                symbols[list->items[i].rhs2.symbol] = current_symbol;
                list->items[i].rhs2.symbol = current_symbol;
                current_symbol++;
            }
        }
        if (list->items[i].lhs.type == TAC_SYMBOL_TYPE_SYMBOL || list->items[i].lhs.type == TAC_SYMBOL_TYPE_VARIABLE)
        {
            if (symbols[list->items[i].lhs.symbol] > -1)
            {
                list->items[i].lhs.symbol = symbols[list->items[i].lhs.symbol];
            }
            else
            {
                symbols[list->items[i].lhs.symbol] = current_symbol;
                list->items[i].lhs.symbol = current_symbol;
                current_symbol++;
            }
        }
        for (int j = 0; j < list->items[i].arg_count; j++)
        {
            if (list->items[i].args[j].type == TAC_SYMBOL_TYPE_SYMBOL || list->items[i].args[j].type == TAC_SYMBOL_TYPE_VARIABLE)
            {
                if (symbols[list->items[i].args[j].symbol] > -1)
                {
                    list->items[i].args[j].symbol = symbols[list->items[i].args[j].symbol];
                }
                else
                {
                    symbols[list->items[i].args[j].symbol] = current_symbol;
                    list->items[i].args[j].symbol = current_symbol;
                    current_symbol++;
                }
            }
        }
    }

    list->_curr_symbol = current_symbol;
    return current_symbol;
}

void remove_double_nots(TACList* list)
{
    for (int i = 0; i < list->count - 1; i++)
    {
        if (list->items[i].operation == TAC_OP_NOT && list->items[i + 1].operation == TAC_OP_NOT)
        {
            if (tac_symbol_equal(list->items[i + 1].rhs1, list->items[i].lhs))
            {
                list->items[i].operation = TAC_OP_ASSIGN;
                list->items[i].lhs = list->items[i + 1].lhs;
                list->items[i + 1] = (TACExpr){ 0 };
            }
        }
        if (list->items[i].operation == TAC_OP_NEG && list->items[i + 1].operation == TAC_OP_NEG)
        {
            if (tac_symbol_equal(list->items[i + 1].rhs1, list->items[i].lhs))
            {
                list->items[i].operation = TAC_OP_ASSIGN;
                list->items[i].lhs = list->items[i + 1].lhs;
                list->items[i + 1] = (TACExpr){ 0 };
            }
        }
    }
}

void perform_substitutions(TACList* list)
{
    // TODO: use a fake hashmap to make this O(n) instead of O(n2)
    for (int i = 0; i < list->count; i++)
    {
        TACExpr e = list->items[i];
        if (e.operation == TAC_OP_ASSIGN && e.lhs.type == TAC_SYMBOL_TYPE_SYMBOL && e.rhs1.type == TAC_SYMBOL_TYPE_SYMBOL)
        {
            for (int j = i; j < list->count; j++)
            {
                if (i == j) continue;
                TACExpr e2 = list->items[j];
                if (e2.operation == TAC_OP_PHI) continue;
                // if (e2.lhs.symbol == e.lhs.symbol) list->items[j].lhs.symbol = e.rhs1.symbol;
                if (tac_symbol_equal(e2.rhs1, e.lhs)) list->items[j].rhs1.symbol = e.rhs1.symbol;
                if (tac_symbol_equal(e2.rhs2, e.lhs)) list->items[j].rhs2.symbol = e.rhs1.symbol;
                for (int k = 0; k < e2.arg_count; k++)
                {
                    if (tac_symbol_equal(e2.args[k], e.lhs)) list->items[j].args[k].symbol = e.rhs1.symbol;
                }
            }
        }
    }
}

void perform_constant_folding(TACList* list)
{
    int64_t string_class_idx = -1;
    for (int i = 0; i < list->class_list.class_count; i++)
    {
        const ClassNode class_node = list->class_list.class_nodes[i];
        if (bh_str_equal_lit(class_node.name, "String")) string_class_idx = i;
        if (string_class_idx > -1) break;
    }

    int64_t max_symbol = list->_curr_symbol + 1;
    TACSymbol* constants = bh_alloc(GPA, max_symbol * sizeof(TACSymbol));
    for (int i = 0; i < max_symbol; i++)
    {
        constants[i] = (TACSymbol){ 0 };
    }

    bool rerun_needed = true;
    while (rerun_needed)
    {
        rerun_needed = false;
        // Collect constants
        for (int i = 0; i < list->count; i++)
        {
            TACExpr e = list->items[i];

            if ((e.operation == TAC_OP_INT || e.operation == TAC_OP_BOOL || e.operation == TAC_OP_STRING) && e.lhs.type == TAC_SYMBOL_TYPE_SYMBOL)
            {
                constants[e.lhs.symbol] = e.rhs1;
            }
        }

        for (int i = 0; i < list->count; i++)
        {
            TACExpr e = list->items[i];

            bool is_comparison = e.operation == TAC_OP_EQ || e.operation == TAC_OP_LTE || e.operation == TAC_OP_LT;
            if (e.operation == TAC_OP_PLUS ||
                e.operation == TAC_OP_MINUS ||
                e.operation == TAC_OP_TIMES ||
                e.operation == TAC_OP_DIVIDE ||
                is_comparison)
            {
                TACSymbol c1 = constants[e.rhs1.symbol];
                TACSymbol c2 = constants[e.rhs2.symbol];
                if (e.rhs1.type == TAC_SYMBOL_TYPE_SYMBOL && c1.type == TAC_SYMBOL_TYPE_BOOL &&
                    e.rhs2.type == TAC_SYMBOL_TYPE_SYMBOL && c2.type == TAC_SYMBOL_TYPE_BOOL)
                {
                    if (e.operation == TAC_OP_EQ)
                    {
                        list->items[i].operation = TAC_OP_BOOL;
                        list->items[i].rhs2 = (TACSymbol){ 0 };
                        list->items[i].rhs1.type = TAC_SYMBOL_TYPE_BOOL;
                        list->items[i].rhs1.integer = c1.integer == c2.integer;
                    }
                }
                if (e.rhs1.type == TAC_SYMBOL_TYPE_SYMBOL && c1.type == TAC_SYMBOL_TYPE_INTEGER &&
                    e.rhs2.type == TAC_SYMBOL_TYPE_SYMBOL && c2.type == TAC_SYMBOL_TYPE_INTEGER)
                {
                    int64_t v1 = c1.integer;
                    int64_t v2 = c2.integer;
                    if (e.operation == TAC_OP_DIVIDE && v2 == 0) continue; // No division by 0
                    list->items[i].operation = is_comparison ? TAC_OP_BOOL : TAC_OP_INT;
                    int64_t result = e.operation == TAC_OP_PLUS ? v1 + v2
                        : e.operation == TAC_OP_MINUS ? v1 - v2
                        : e.operation == TAC_OP_TIMES ? v1 * v2
                        : e.operation == TAC_OP_DIVIDE ? v1 / v2
                        : e.operation == TAC_OP_LTE ? v1 <= v2
                        : e.operation == TAC_OP_LT ? v1 < v2
                        : v1 == v2;
                    list->items[i].rhs1 = (TACSymbol){
                        .type = is_comparison ? TAC_SYMBOL_TYPE_BOOL : TAC_SYMBOL_TYPE_INTEGER,
                        .integer = result
                    };
                    list->items[i].rhs2 = (TACSymbol){ 0 };
                    rerun_needed = true;
                }
                // Strength reduction ops
                // else if ((e.rhs1.type == TAC_SYMBOL_TYPE_SYMBOL && c1.type == TAC_SYMBOL_TYPE_INTEGER && c1.integer == 0) ||
                //          (e.rhs2.type == TAC_SYMBOL_TYPE_SYMBOL && c2.type == TAC_SYMBOL_TYPE_INTEGER && c2.integer == 0))
                // {
                //     if (e.operation == TAC_OP_PLUS)
                //     {
                //         list->items[i].operation = TAC_OP_ASSIGN;
                //         list->items[i].rhs2 = (TACSymbol){ 0 };
                //         rerun_needed = true;
                //     }
                //     if (e.operation == TAC_OP_TIMES)
                //     {
                //         list->items[i].operation = TAC_OP_ASSIGN;
                //         list->items[i].rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = 0 };
                //         list->items[i].rhs2 = (TACSymbol){ 0 };
                //         rerun_needed = true;
                //     }
                //     if (e.operation == TAC_OP_MINUS && c2.type == TAC_SYMBOL_TYPE_INTEGER && c2.integer == 0)
                //     {
                //         list->items[i].operation = TAC_OP_ASSIGN;
                //         list->items[i].rhs2 = (TACSymbol){ 0 };
                //         rerun_needed = true;
                //     }
                // }
            }
            if (e.operation == TAC_OP_NEG)
            {
                TACSymbol c1 = constants[e.rhs1.symbol];
                if (e.rhs1.type == TAC_SYMBOL_TYPE_SYMBOL && c1.type == TAC_SYMBOL_TYPE_INTEGER)
                {
                    list->items[i].operation = TAC_OP_INT;
                    int64_t result = -c1.integer;
                    list->items[i].rhs1 = (TACSymbol){
                        .type = TAC_SYMBOL_TYPE_INTEGER,
                        .integer = result
                    };
                    list->items[i].rhs2 = (TACSymbol){ 0 };
                    rerun_needed = true;
                }
            }
            if (e.operation == TAC_OP_NOT)
            {
                TACSymbol c1 = constants[e.rhs1.symbol];
                if (e.rhs1.type == TAC_SYMBOL_TYPE_SYMBOL && c1.type == TAC_SYMBOL_TYPE_BOOL)
                {
                    list->items[i].operation = TAC_OP_BOOL;
                    int64_t result = c1.integer == 0 ? 1 : 0;
                    list->items[i].rhs1 = (TACSymbol){
                        .type = TAC_SYMBOL_TYPE_BOOL,
                        .integer = result
                    };
                    list->items[i].rhs2 = (TACSymbol){ 0 };
                    rerun_needed = true;
                }
            }
            if (e.operation == TAC_OP_BT)
            {
                TACSymbol c1 = constants[e.rhs1.symbol];
                if (e.rhs1.type == TAC_SYMBOL_TYPE_SYMBOL && c1.type == TAC_SYMBOL_TYPE_BOOL)
                {
                    if (c1.integer)
                    {
                        list->items[i].operation = TAC_OP_JMP;
                        list->items[i].rhs1 = list->items[i].rhs2;
                        list->items[i].rhs2 = (TACSymbol){ 0 };
                    }
                    else
                    {
                        list->items[i].operation = TAC_OP_ASSIGN;
                        list->items[i].lhs = list->items[i].rhs1;
                        list->items[i].rhs2 = (TACSymbol){ 0 };
                    }
                }
            }
            if (e.operation == TAC_OP_CALL)
            {
                if (e.rhs1.method.class_idx == string_class_idx && e.rhs1.method.method_idx == 3) // substr
                {
                    TACSymbol c2 = constants[e.args[0].symbol];
                    TACSymbol c1 = constants[e.args[1].symbol];
                    if (c1.type == TAC_SYMBOL_TYPE_STRING && c2.type == TAC_SYMBOL_TYPE_STRING)
                    {
                        list->items[i].operation = TAC_OP_STRING;
                        bh_str_buf new_str_buf = bh_str_buf_init(list->allocator, c2.string.data.len + c1.string.data.len); // NOTE: maybe make it use a string allocator?
                        bh_str_buf_append(&new_str_buf, c1.string.data);
                        bh_str_buf_append(&new_str_buf, c2.string.data);
                        bh_str new_str = (bh_str){ .buf = new_str_buf.buf, .len = new_str_buf.len };
                        list->items[i].rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = new_str };
                        list->items[i].arg_count = 0;
                        rerun_needed = true;
                    }
                }
                if (e.rhs1.method.class_idx == string_class_idx && e.rhs1.method.method_idx == 4) // strlen
                {
                    TACSymbol c1 = constants[e.args[0].symbol];
                    if (c1.type == TAC_SYMBOL_TYPE_STRING)
                    {
                        list->items[i].operation = TAC_OP_INT;
                        list->items[i].rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_INTEGER, .integer = c1.string.data.len };
                        list->items[i].arg_count = 0;
                        rerun_needed = true;
                    }
                }
                if (e.rhs1.method.class_idx == string_class_idx && e.rhs1.method.method_idx == 5) // substr
                {
                    TACSymbol c2 = constants[e.args[0].symbol];
                    TACSymbol c3 = constants[e.args[1].symbol];
                    TACSymbol c1 = constants[e.args[2].symbol];
                    if (c1.type == TAC_SYMBOL_TYPE_STRING && c2.type == TAC_SYMBOL_TYPE_INTEGER && c3.type == TAC_SYMBOL_TYPE_INTEGER)
                    {
                        // Check in range
                        if (c2.integer >= 0 && c3.integer >= 0 && c2.integer + c3.integer <= c1.string.data.len)
                        {
                            list->items[i].operation = TAC_OP_STRING;
                            bh_str new_str = c1.string.data;
                            new_str.buf += c2.integer;
                            new_str.len = c3.integer;
                            list->items[i].rhs1 = (TACSymbol){ .type = TAC_SYMBOL_TYPE_STRING, .string = new_str };
                            list->items[i].arg_count = 0;
                            rerun_needed = true;
                        }
                    }
                }
            }
        }
    }

    bh_free(GPA, constants);
}

void remove_empty_exprs(TACList* list)
{
    int64_t new_count = 0;

    for (int64_t i = 0; i < list->count; i++) {
        TACExpr expr = list->items[i];
        if (expr.operation == TAC_OP_NULL) continue;
        list->items[new_count++] = expr;
    }

    list->count = new_count;
}

typedef struct SymbolUsage
{
    int64_t symbol;
    int64_t live_start;
    int64_t live_end;
    bool register_viable;
} SymbolUsage;

typedef struct RegisterUsage
{
    ASMRegister reg;
    int64_t live_end;
    int64_t used_by_symbol;
} RegisterUsage;

void convert_symbols_to_registers(TACList* list)
{
    int64_t symbol_cap = 500000;
    SymbolUsage* symbols = bh_alloc(GPA, sizeof(SymbolUsage) * symbol_cap);

    for (int i = 0; i < list->cfg.block_count; i++)
    {
        int64_t used_symbols = 0;

        CFGBlock block = list->cfg.blocks[i];
        int64_t block_start_idx = block.tac_contents.items - list->items;
        int64_t block_last_idx = block_start_idx + block.tac_contents.count - 1;

        // First figure out all the used symbols to look for
        for (int j = 0; j < block.tac_contents.count; j++)
        {
            TACExpr e = block.tac_contents.items[j];
            if (e.lhs.type != TAC_SYMBOL_TYPE_SYMBOL) continue;

            // Check that we haven't already added this symbol, probably useless but whatever
            bool symbol_used = false;
            for (int k = 0; k < used_symbols; k++)
            {
                if (symbols[k].symbol == e.lhs.symbol)
                {
                    symbol_used = true;
                    break;
                }
            }
            if (!symbol_used)
            {
                symbols[used_symbols] = (SymbolUsage){
                    .symbol = e.lhs.symbol,
                    .register_viable = true,
                    .live_start = j,
                    .live_end = 0
                };
                used_symbols++;
                if (used_symbols >= symbol_cap)
                {
                    symbols = bh_realloc(GPA, symbols, symbol_cap * 2 * sizeof(SymbolUsage));
                    symbol_cap *= 2;
                }
            }
        }

        // Now see if the symbols are used in any other blocks
        for (int j = 0; j < list->count; j++)
        {
            if (j >= block_start_idx && j <= block_last_idx) continue;

            TACExpr e = list->items[j];

            if (e.operation == TAC_OP_RETURN)
            {

            }

            for (int k = 0; k < used_symbols; k++)
            {
                if (e.rhs1.type == TAC_SYMBOL_TYPE_SYMBOL && symbols[k].symbol == e.rhs1.symbol) symbols[k].register_viable = false;
                if (e.rhs2.type == TAC_SYMBOL_TYPE_SYMBOL && symbols[k].symbol == e.rhs2.symbol) symbols[k].register_viable = false;
                for (int l = 0; l < e.arg_count; l++)
                {
                    if (e.args[l].type == TAC_SYMBOL_TYPE_SYMBOL && symbols[k].symbol == e.args[l].symbol) symbols[k].register_viable = false;
                }
            }
        }

        // Next figure out the live ranges
        for (int j = 0; j < block.tac_contents.count; j++)
        {
            TACExpr e = block.tac_contents.items[j];
            // if (e.operation != TAC_OP_RETURN) continue;

            for (int k = 0; k < used_symbols; k++)
            {
                if (!symbols[k].register_viable) continue;
                if (e.rhs1.type == TAC_SYMBOL_TYPE_SYMBOL && symbols[k].symbol == e.rhs1.symbol)
                {
                    if (k == 6)
                    {

                    }
                    symbols[k].live_end = j;
                }
                if (e.rhs2.type == TAC_SYMBOL_TYPE_SYMBOL && symbols[k].symbol == e.rhs2.symbol)
                {
                    symbols[k].live_end = j;
                }
                for (int l = 0; l < e.arg_count; l++)
                {
                    if (e.args[l].type == TAC_SYMBOL_TYPE_SYMBOL && symbols[k].symbol == e.args[l].symbol)
                    {
                        symbols[k].live_end = j;
                    }
                }
            }
        }

        // Finally assign registers greedily
        int64_t register_count = 3;
        RegisterUsage registers[3] = {
            { .reg = RBX, .used_by_symbol = -1 },
            // { .reg = RCX, .used_by_symbol = -1 },
            // { .reg = R8, .used_by_symbol = -1 },
            // { .reg = R9, .used_by_symbol = -1 },
            { .reg = R10, .used_by_symbol = -1 },
            { .reg = R11, .used_by_symbol = -1 },
        };
        for (int j = 0; j < block.tac_contents.count; j++)
        {
            TACExpr e = block.tac_contents.items[j];

            // Apply registers and remove any registers that are no longer in use
            for (int k = 0; k < register_count; k++)
            {
                if (e.rhs1.type == TAC_SYMBOL_TYPE_SYMBOL && e.rhs1.symbol == registers[k].used_by_symbol)
                {
                    block.tac_contents.items[j].rhs1.type = TAC_SYMBOL_TYPE_REGISTER;
                    block.tac_contents.items[j].rhs1.reg = registers[k].reg;
                }
                if (e.rhs2.type == TAC_SYMBOL_TYPE_SYMBOL && e.rhs2.symbol == registers[k].used_by_symbol)
                {
                    block.tac_contents.items[j].rhs2.type = TAC_SYMBOL_TYPE_REGISTER;
                    block.tac_contents.items[j].rhs2.reg = registers[k].reg;
                }
                for (int l = 0; l < e.arg_count; l++)
                {
                    if (e.args[l].type == TAC_SYMBOL_TYPE_SYMBOL && e.args[l].symbol == registers[k].used_by_symbol)
                    {
                        block.tac_contents.items[j].args[l].type = TAC_SYMBOL_TYPE_REGISTER;
                        block.tac_contents.items[j].args[l].reg = registers[k].reg;
                    }
                }
                if (registers[k].live_end <= j)
                {
                    registers[k].live_end = 0;
                    registers[k].used_by_symbol = -1;
                }
            }

            SymbolUsage symbol_usage = { 0 };
            // Figure out symbol data
            for (int k = 0; k < used_symbols; k++)
            {
                if (e.lhs.type == TAC_SYMBOL_TYPE_SYMBOL && symbols[k].symbol == e.lhs.symbol)
                {
                    symbol_usage = symbols[k];
                }
            }
            if (!symbol_usage.register_viable) continue;

            // Place the result in the first available register if possible
            for (int k = 0; k < register_count; k++)
            {
                if (registers[k].used_by_symbol == -1)
                {
                    registers[k].live_end = symbol_usage.live_end;
                    registers[k].used_by_symbol = e.lhs.symbol;
                    block.tac_contents.items[j].lhs.type = TAC_SYMBOL_TYPE_REGISTER;
                    block.tac_contents.items[j].lhs.symbol = registers[k].reg;
                    break;
                }
            }
        }
    }

    bh_free(GPA, symbols);
}

void optimize_tac_list(TACList* list)
{
    PROFILE_BLOCK
    {
        remove_duplicate_phi_expressions(list);
        eliminate_dead_tac(list);
        remove_double_nots(list);
        perform_substitutions(list);
        perform_constant_folding(list);
        perform_substitutions(list);
        eliminate_dead_tac(list);
        remove_empty_exprs(list);
        remove_phi_expressions(list);
        generate_cfg_for_tac_list(list);
        convert_symbols_to_registers(list);
        compress_tac_symbols(list, NULL, 0, 1);
    }
}