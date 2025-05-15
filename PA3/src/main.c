//
// Created by Brandon Howe on 3/5/25.
//

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>

#include "allocator.h"
#include "assembly.h"
#include "ast.h"
#include "profiler.h"
#include "tac.h"
#include "types.h"

typedef enum Mode
{
    MODE_NULL,
    MODE_TAC_ONLY,
    MODE_X86_ONLY,
    MODE_ASM_ONLY,
    MODE_TAC_SHOW_CASE,
    MODE_BOTH,
} Mode;

#define MODE MODE_X86_ONLY

void append_tac_symbol(bh_str_buf* str_buf, ClassNodeList class_list, TACSymbol symbol)
{
    switch (symbol.type)
    {
    case TAC_SYMBOL_TYPE_NULL: break;
    case TAC_SYMBOL_TYPE_SYMBOL: bh_str_buf_append_format(str_buf, "t$%i", symbol.symbol); break;
    case TAC_SYMBOL_TYPE_REGISTER:
        switch (symbol.reg)
        {
            case RBX: bh_str_buf_append_lit(str_buf, "rbx"); break;
            case RCX: bh_str_buf_append_lit(str_buf, "rcx"); break;
            case R8: bh_str_buf_append_lit(str_buf, "r8"); break;
            case R9: bh_str_buf_append_lit(str_buf, "r9"); break;
            case R10: bh_str_buf_append_lit(str_buf, "r10"); break;
            case R11: bh_str_buf_append_lit(str_buf, "r11"); break;
            default: assert(0 && "Unhandled register in TAC");
        }
        break;
    case TAC_SYMBOL_TYPE_VARIABLE:
        bh_str_buf_append(str_buf, symbol.variable.data);
        // bh_str_buf_append_format(str_buf, "$%i", symbol.variable.version);
        break;
    case TAC_SYMBOL_TYPE_INTEGER: bh_str_buf_append_format(str_buf, "%i", symbol.integer); break;
    case TAC_SYMBOL_TYPE_CLASSIDX:
        for (int i = 0; i < class_list.class_count; i++)
        {
            ClassNode class_node = class_list.class_nodes[i];
            int64_t class_tag = i;
            if (bh_str_equal_lit(class_node.name, "Bool")) class_tag = -1;
            if (bh_str_equal_lit(class_node.name, "Int")) class_tag = -2;
            if (bh_str_equal_lit(class_node.name, "String")) class_tag = -3;
            if (class_tag == symbol.integer)
            {
                bh_str_buf_append(str_buf, class_node.name);
                return;
            }
        }
        bh_str_buf_append_lit(str_buf, "invalid");
        break;
    case TAC_SYMBOL_TYPE_STRING: bh_str_buf_append(str_buf, symbol.string.data); break;
    case TAC_SYMBOL_TYPE_BOOL: bh_str_buf_append_format(str_buf, "%s", symbol.integer ? "true" : "false"); break;
    case TAC_SYMBOL_TYPE_METHOD:
        bh_str_buf_append(str_buf, class_list.class_nodes[symbol.method.class_idx].methods[symbol.method.method_idx].name);
        break;
    }
}

void display_tac_expr(bh_str_buf* str_buf, TACList tac_list, TACExpr expr)
{
    const bh_str class_name = tac_list.class_list.class_nodes[tac_list.class_idx].name;

    if (expr.operation <= TAC_OP_CALL)
    {
        if (expr.lhs.type == TAC_SYMBOL_TYPE_VARIABLE)
        {
            bh_str_buf_append(str_buf, expr.lhs.variable.data);
            bh_str_buf_append_format(str_buf, "$%i", expr.lhs.variable.version);
            bh_str_buf_append_lit(str_buf, " <- ");
        }
        else
        {
            if (expr.lhs.type == TAC_SYMBOL_TYPE_SYMBOL)
            {
                bh_str_buf_append_format(str_buf, "t$%i <- ", expr.lhs.symbol);
            }
            else
            {
                switch (expr.lhs.reg)
                {
                case RBX: bh_str_buf_append_lit(str_buf, "rbx <- "); break;
                case RCX: bh_str_buf_append_lit(str_buf, "rcx <- "); break;
                case R8: bh_str_buf_append_lit(str_buf, "r8 <- "); break;
                case R9: bh_str_buf_append_lit(str_buf, "r9 <- "); break;
                case R10: bh_str_buf_append_lit(str_buf, "r10 <- "); break;
                case R11: bh_str_buf_append_lit(str_buf, "r11 <- "); break;
                default: assert(0 && "Unhandled register in TAC");
                }
            }
        }
    }
    if (MODE == MODE_TAC_ONLY && expr.operation == TAC_OP_IGNORE) return;
    switch (expr.operation)
    {
    case TAC_OP_IGNORE: if (MODE != MODE_TAC_ONLY) bh_str_buf_append_lit(str_buf, "init call"); break;
    case TAC_OP_ASSIGN: bh_str_buf_append_lit(str_buf, ""); break;
    case TAC_OP_PLUS: bh_str_buf_append_lit(str_buf, "+ "); break;
    case TAC_OP_MINUS: bh_str_buf_append_lit(str_buf, "- "); break;
    case TAC_OP_TIMES: bh_str_buf_append_lit(str_buf, "* "); break;
    case TAC_OP_DIVIDE: bh_str_buf_append_lit(str_buf, "/ "); break;
    case TAC_OP_LT: bh_str_buf_append_lit(str_buf, "< "); break;
    case TAC_OP_LTE: bh_str_buf_append_lit(str_buf, "<= "); break;
    case TAC_OP_EQ: bh_str_buf_append_lit(str_buf, "= "); break;
    case TAC_OP_INT: bh_str_buf_append_lit(str_buf, "int "); break;
    case TAC_OP_STRING: bh_str_buf_append_lit(str_buf, "string\n"); break;
    case TAC_OP_BOOL: bh_str_buf_append_lit(str_buf, "bool "); break;
    case TAC_OP_NOT: bh_str_buf_append_lit(str_buf, "not "); break;
    case TAC_OP_NEG: bh_str_buf_append_lit(str_buf, "~ "); break;
    case TAC_OP_NEW: bh_str_buf_append_lit(str_buf, "new "); break;
    case TAC_OP_DEFAULT: bh_str_buf_append_lit(str_buf, "default "); break;
    case TAC_OP_ISVOID: bh_str_buf_append_lit(str_buf, "isvoid "); break;
    case TAC_OP_IS_CLASS: bh_str_buf_append_lit(str_buf, "isclass "); break;
    case TAC_OP_PHI:bh_str_buf_append_lit(str_buf, "phi "); break;
    case TAC_OP_CALL: bh_str_buf_append_lit(str_buf, "call "); break;
    case TAC_OP_JMP:
        bh_str_buf_append_lit(str_buf, "jmp ");
        bh_str_buf_append(str_buf, class_name);
        bh_str_buf_append_lit(str_buf, "_");
        bh_str_buf_append(str_buf, tac_list.method_name);
        bh_str_buf_append_lit(str_buf, "_");
        break;
    case TAC_OP_LABEL:
        bh_str_buf_append_lit(str_buf, "label ");
        bh_str_buf_append(str_buf, class_name);
        bh_str_buf_append_lit(str_buf, "_");
        bh_str_buf_append(str_buf, tac_list.method_name);
        bh_str_buf_append_lit(str_buf, "_");
        break;
    case TAC_OP_RETURN: bh_str_buf_append_lit(str_buf, "return "); break;
    case TAC_OP_COMMENT: bh_str_buf_append_lit(str_buf, "comment "); break;
    case TAC_OP_BT: bh_str_buf_append_lit(str_buf, "bt "); break;
    case TAC_OP_RUNTIME_ERROR:
        bh_str_buf_append_format(str_buf, "ERROR %i: Exception: ", expr.line_num);
        break;
    default: assert(0 && "Invalid expression");
    }
    append_tac_symbol(str_buf, tac_list.class_list, expr.rhs1);
    if (expr.rhs2.type)
    {
        bh_str_buf_append_lit(str_buf, " ");
    }
    if (expr.operation == TAC_OP_BT)
    {
        bh_str_buf_append(str_buf, class_name);
        bh_str_buf_append_lit(str_buf, "_");
        bh_str_buf_append(str_buf, tac_list.method_name);
        bh_str_buf_append_lit(str_buf, "_");
    }
    if (expr.operation == TAC_OP_CALL)
    {
        for (int i = 0; i < expr.arg_count; i++)
        {
            bh_str_buf_append_lit(str_buf, " ");
            append_tac_symbol(str_buf, tac_list.class_list, expr.args[i]);
        }
    }
    append_tac_symbol(str_buf, tac_list.class_list, expr.rhs2);
    bh_str_buf_append_lit(str_buf, "\n");
}

int main(int argc, char* argv[])
{
    if (argc < 2) {
        printf("Usage: %s, <input_file>\n", argv[0]);
        return 0;
    }

    InitProfiler();

    bh_str file = read_file_text(argv[1]);
    bh_str file_name = bh_str_from_cstr(argv[1]);

    bh_allocator parser_arena = arena_init(1000000);
    ClassNodeList class_list = parse_class_map(&file, parser_arena);
    parse_implementation_map(&file, parser_arena, class_list);
    parse_parent_map(&file, parser_arena, class_list);

    bh_allocator tac_allocator = GPA;
    bh_allocator string_allocator = arena_init(1000000);
    ASMList asm_list = asm_list_init(&class_list);
    if (MODE == MODE_X86_ONLY || MODE == MODE_BOTH)
    {
        asm_list.tac_allocator = tac_allocator;
        asm_list.string_allocator = string_allocator;
        asm_from_vtable(&asm_list);

        // Count how many total methods there are to allocate space
        int64_t total_method_count = 0;
        for (int i = 0; i < class_list.class_count; i++)
        {
            for (int j = 0; j < class_list.class_nodes[i].method_count; j++)
            {
                const ClassMethod method = class_list.class_nodes[i].methods[j];

                if (bh_str_equal(method.inherited_from, class_list.class_nodes[i].name))
                {
                    total_method_count += 1;
                }
            }
        }
        CallData* call_data = bh_alloc(GPA, sizeof(CallData) * total_method_count);
        // Init the call data fields
        total_method_count = 0;
        for (int i = 0; i < class_list.class_count; i++)
        {
            for (int j = 0; j < class_list.class_nodes[i].method_count; j++)
            {
                const ClassMethod method = class_list.class_nodes[i].methods[j];

                if (bh_str_equal(method.inherited_from, class_list.class_nodes[i].name))
                {
                    call_data[total_method_count].class_idx = i;
                    call_data[total_method_count].method_idx = j;
                    total_method_count += 1;
                }
            }
        }

        for (int i = 0; i < class_list.class_count; i++)
        {
            asm_from_constructor(&asm_list, class_list.class_nodes[i], i, call_data, total_method_count);
        }

        int64_t method_idx = 0;
        for (int i = 0; i < class_list.class_count; i++)
        {
            for (int j = 0; j < class_list.class_nodes[i].method_count; j++)
            {
                const ClassMethod method = class_list.class_nodes[i].methods[j];

                if (bh_str_equal(method.inherited_from, class_list.class_nodes[i].name))
                {
                    TACList list = TAC_list_init(100, GPA);
                    list.class_list = class_list;
                    list.class_idx = i;
                    list.method_idx = j;
                    list.method_name = method.name;

                    TACSymbol result = tac_list_from_expression(&method.body, &list, (TACSymbol){ 0 }, false);
                    TAC_list_append(&list, (TACExpr){ .operation = TAC_OP_RETURN, .rhs1 = result }, false);
                    optimize_tac_list(&list);

                    call_data[method_idx].tac_list = list;

                    fill_call_data_from_list(list, call_data, total_method_count);

                    method_idx++;
                }
            }
        }

        MainData main_data = find_maindata(&asm_list);
        for (int i = 0; i < total_method_count; i++)
        {
            if (call_data[i].called ||
                (call_data[i].class_idx == main_data.main_class_idx && call_data[i].method_idx == main_data.main_method_idx))
            {
                asm_from_method(&asm_list, call_data[i].tac_list);
                peephole_optimize_asm_list(&asm_list);
            }
            else
            {
                asm_from_method_stub(&asm_list, call_data[i].tac_list);
            }
        }

        builtin_append_string_constants(&asm_list);
        builtin_append_start(&asm_list);
    }

    if (MODE == MODE_TAC_ONLY || MODE == MODE_TAC_SHOW_CASE || MODE == MODE_BOTH) // PA3c2 -- output first method as TAC
    {
        bh_allocator tac_arena = arena_init(500000);
        TACList tac_list = tac_list_from_class_list(class_list, tac_arena);
        const bh_str class_name = tac_list.class_list.class_nodes[tac_list.class_idx].name;

        bh_str_buf str_buf = bh_str_buf_init(GPA, 10000);
        for (int i = 0; i < tac_list.count; i++)
        {
            TACExpr expr = tac_list.items[i];
            display_tac_expr(&str_buf, tac_list, expr);
        }

        char* output_name  = bh_alloc(GPA, file_name.len + 10);
        strncpy(output_name, file_name.buf, file_name.len - 4);
        strncpy(output_name + file_name.len - 4, "tac", 3);

        FILE* fptr;
        fptr = fopen(output_name, "wb");
        assert(fptr != NULL);
        fwrite(str_buf.buf, 1, str_buf.len, fptr);
        fclose(fptr);

        fwrite(str_buf.buf, 1, str_buf.len, stdout);

        bh_str_buf_deinit(&str_buf);
    }

    if (MODE == MODE_ASM_ONLY) // Write asm to file
    {
        bh_str_buf asm_display = bh_str_buf_init(GPA, 10000);
        display_asm_list(&asm_display, asm_list);

        char* output_name  = bh_alloc(GPA, file_name.len + 10);
        strncpy(output_name, file_name.buf, file_name.len - 4);
        strncpy(output_name + file_name.len - 4, "asm", 3);

        FILE* fptr;
        fptr = fopen(output_name, "wb");
        assert(fptr != NULL);
        fwrite(asm_display.buf, 1, asm_display.len, fptr);
        fclose(fptr);
    }

    if (MODE == MODE_BOTH || MODE == MODE_X86_ONLY) // Write x86 to file
    {
        bh_str_buf asm_display = bh_str_buf_init(GPA, 1000000);
        x86_asm_list(&asm_display, asm_list);
        builtin_append_string_helpers(&asm_display);

        char* output_name  = bh_alloc(GPA, file_name.len + 8);
        strncpy(output_name, file_name.buf, file_name.len - 7);
        strncpy(output_name + file_name.len - 7, "s", 1);

        FILE* fptr;
        fptr = fopen(output_name, "wb");
        assert(fptr != NULL);
        fwrite(asm_display.buf, 1, asm_display.len, fptr);
        fclose(fptr);
    }

    EndProfilerPrintProfile();
}