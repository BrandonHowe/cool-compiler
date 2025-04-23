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
            if (e.operation != TAC_OP_PHI)
            {
                if ((e.rhs1.type == TAC_SYMBOL_TYPE_VARIABLE || e.rhs1.type == TAC_SYMBOL_TYPE_SYMBOL) &&
                    e.rhs1.symbol < max_phi &&
                    phi_bindings[e.rhs1.symbol].type > 0 &&
                    !tac_symbol_equal(list->items[i].rhs1, phi_bindings[e.rhs1.symbol]))
                {
                    list->items[i].rhs1 = phi_bindings[e.rhs1.symbol];
                    rerun_needed = true;
                }
                if ((e.rhs2.type == TAC_SYMBOL_TYPE_VARIABLE || e.rhs2.type == TAC_SYMBOL_TYPE_SYMBOL) &&
                    e.rhs2.symbol < max_phi &&
                    phi_bindings[e.rhs2.symbol].type > 0 &&
                    !tac_symbol_equal(list->items[i].rhs1, phi_bindings[e.rhs1.symbol]))
                {
                    list->items[i].rhs2 = phi_bindings[e.rhs2.symbol];
                    rerun_needed = true;
                }
            }
            if ((e.lhs.type == TAC_SYMBOL_TYPE_VARIABLE || e.lhs.type == TAC_SYMBOL_TYPE_SYMBOL) && e.lhs.symbol < max_phi && phi_bindings[e.lhs.symbol].type > 0)
            {
                list->items[i].lhs = phi_bindings[e.lhs.symbol];
                rerun_needed = true;
            }
        }
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
            mark_symbol_live(list, live_status, list->items[i].rhs1);
            mark_symbol_live(list, live_status, list->items[i].rhs2);
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
            live_status[i] = true;
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
    }
    mark_symbol_live(list, live_status, (TACSymbol){ .type = TAC_SYMBOL_TYPE_SYMBOL, .symbol = 0 });

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

void perform_substitutions(TACList* list)
{
    // TODO: use a fake hashmap to make this O(n) instead of O(n2)
    for (int i = 0; i < list->count; i++)
    {
        TACExpr e = list->items[i];
        if (e.operation == TAC_OP_ASSIGN && e.lhs.type == TAC_SYMBOL_TYPE_SYMBOL && e.rhs1.type == TAC_SYMBOL_TYPE_SYMBOL)
        {
            for (int j = 0; j < list->count; j++)
            {
                TACExpr e2 = list->items[j];
                // if (e2.lhs.symbol == e.lhs.symbol) list->items[j].lhs.symbol = e.rhs1.symbol;
                if (e2.rhs1.symbol == e.lhs.symbol) list->items[j].rhs1.symbol = e.rhs1.symbol;
                if (e2.rhs2.symbol == e.lhs.symbol) list->items[j].rhs2.symbol = e.rhs1.symbol;
            }
            list->items[i] = (TACExpr){ 0 };
        }
    }
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

void optimize_tac_list(TACList* list)
{
    PROFILE_BLOCK
    {
        remove_duplicate_phi_expressions(list);
        // eliminate_dead_tac(list);
        // perform_substitutions(list);
        // remove_empty_exprs(list);
        remove_phi_expressions(list);
        // compress_tac_symbols(list, NULL, 0, 1);
    }
}