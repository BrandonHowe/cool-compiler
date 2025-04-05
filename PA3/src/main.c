//
// Created by Brandon Howe on 3/5/25.
//

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>

#include "assembly.h"
#include "ast.h"
#include "cfg.h"
#include "tac.h"
#include "types.h"

void append_tac_symbol(bh_str_buf* str_buf, ClassNodeList class_list, TACSymbol symbol)
{
    switch (symbol.type)
    {
    case TAC_SYMBOL_TYPE_NULL: break;
    case TAC_SYMBOL_TYPE_SYMBOL: bh_str_buf_append_format(str_buf, "t$%i", symbol.symbol); break;
    case TAC_SYMBOL_TYPE_VARIABLE: bh_str_buf_append(str_buf, symbol.variable); break;
    case TAC_SYMBOL_TYPE_INTEGER: bh_str_buf_append_format(str_buf, "%i", symbol.integer); break;
    case TAC_SYMBOL_TYPE_STRING: bh_str_buf_append(str_buf, symbol.string); break;
    case TAC_SYMBOL_TYPE_BOOL: bh_str_buf_append_format(str_buf, "%s", symbol.integer ? "true" : "false"); break;
    case TAC_SYMBOL_TYPE_METHOD: bh_str_buf_append(str_buf, class_list.class_nodes[symbol.method.class_idx].methods[symbol.method.method_idx].name); break;
    }
}

int main(int argc, char* argv[])
{
    if (argc < 2) {
        printf("Usage: %s, <input_file>\n", argv[0]);
        return 0;
    }

    bh_str file = read_file_text(argv[1]);
    bh_str file_name = bh_str_from_cstr(argv[1]);

    bh_allocator parser_arena = arena_init(1000000);
    ClassNodeList class_list = parse_class_map(&file, parser_arena);
    parse_implementation_map(&file, parser_arena, class_list);
    parse_parent_map(&file, parser_arena, class_list);

    bh_allocator tac_allocator = GPA;
    ASMList asm_list = asm_list_init(&class_list);
    asm_list.tac_allocator = tac_allocator;
    asm_list.string_allocator = arena_init(1000000);
    asm_from_vtable(&asm_list);

    for (int i = 0; i < class_list.class_count; i++)
    {
        asm_from_constructor(&asm_list, class_list.class_nodes[i], i);
    }

    for (int i = 0; i < class_list.class_count; i++)
    {
        for (int j = 0; j < class_list.class_nodes[i].method_count; j++)
        {
            const ClassMethod method = class_list.class_nodes[i].methods[j];

            if (bh_str_equal(method.inherited_from, class_list.class_nodes[i].name))
            {
                arena_free_all(tac_allocator);

                TACList list = TAC_list_init(100, GPA);
                list.class_list = class_list;
                list.class_idx = i;
                list.method_idx = j;
                list.method_name = method.name;

                tac_list_from_expression(&method.body, &list, (TACSymbol){ 0 });

                asm_from_method(&asm_list, list);
            }
        }
    }

    builtin_append_string_constants(&asm_list);
    builtin_append_start(&asm_list);

    if (false) // PA3c2 -- output first method as TAC
    {
        bh_allocator tac_arena = arena_init(500000);
        TACList tac_list = tac_list_from_class_list(class_list, tac_arena);
        const bh_str class_name = tac_list.class_list.class_nodes[tac_list.class_idx].name;

        bh_str_buf str_buf = bh_str_buf_init(GPA, 10000);
        for (int i = 0; i < tac_list.count; i++)
        {
            TACExpr expr = tac_list.items[i];
            if (expr.operation <= TAC_OP_CALL)
            {
                if (expr.lhs.type == TAC_SYMBOL_TYPE_VARIABLE)
                {
                    bh_str_buf_append(&str_buf, expr.lhs.variable);
                    bh_str_buf_append_lit(&str_buf, " <- ");
                }
                else
                {
                    bh_str_buf_append_format(&str_buf, "t$%i <- ", expr.lhs.symbol);
                }
            }
            switch (expr.operation)
            {
            case TAC_OP_IGNORE: bh_str_buf_append_lit(&str_buf, "init call");
            case TAC_OP_ASSIGN: bh_str_buf_append_lit(&str_buf, ""); break;
            case TAC_OP_PLUS: bh_str_buf_append_lit(&str_buf, "+ "); break;
            case TAC_OP_MINUS: bh_str_buf_append_lit(&str_buf, "- "); break;
            case TAC_OP_TIMES: bh_str_buf_append_lit(&str_buf, "* "); break;
            case TAC_OP_DIVIDE: bh_str_buf_append_lit(&str_buf, "/ "); break;
            case TAC_OP_LT: bh_str_buf_append_lit(&str_buf, "< "); break;
            case TAC_OP_LTE: bh_str_buf_append_lit(&str_buf, "<= "); break;
            case TAC_OP_EQ: bh_str_buf_append_lit(&str_buf, "= "); break;
            case TAC_OP_INT: bh_str_buf_append_lit(&str_buf, "int "); break;
            case TAC_OP_STRING: bh_str_buf_append_lit(&str_buf, "string\n"); break;
            case TAC_OP_BOOL: bh_str_buf_append_lit(&str_buf, "bool "); break;
            case TAC_OP_NOT: bh_str_buf_append_lit(&str_buf, "not "); break;
            case TAC_OP_NEG: bh_str_buf_append_lit(&str_buf, "~ "); break;
            case TAC_OP_NEW: bh_str_buf_append_lit(&str_buf, "new "); break;
            case TAC_OP_DEFAULT: bh_str_buf_append_lit(&str_buf, "default "); break;
            case TAC_OP_ISVOID: bh_str_buf_append_lit(&str_buf, "isvoid "); break;
            case TAC_OP_CALL: bh_str_buf_append_lit(&str_buf, "call "); break;
            case TAC_OP_JMP:
                bh_str_buf_append_lit(&str_buf, "jmp ");
                bh_str_buf_append(&str_buf, class_name);
                bh_str_buf_append_lit(&str_buf, "_");
                bh_str_buf_append(&str_buf, tac_list.method_name);
                bh_str_buf_append_lit(&str_buf, "_");
                break;
            case TAC_OP_LABEL:
                bh_str_buf_append_lit(&str_buf, "label ");
                bh_str_buf_append(&str_buf, class_name);
                bh_str_buf_append_lit(&str_buf, "_");
                bh_str_buf_append(&str_buf, tac_list.method_name);
                bh_str_buf_append_lit(&str_buf, "_");
                break;
            case TAC_OP_RETURN: bh_str_buf_append_lit(&str_buf, "return "); break;
            case TAC_OP_COMMENT: bh_str_buf_append_lit(&str_buf, "comment "); break;
            case TAC_OP_BT: bh_str_buf_append_lit(&str_buf, "bt "); break;
            default: assert(0 && "Invalid expression"); break;
            }
            append_tac_symbol(&str_buf, class_list, expr.rhs1);
            if (expr.rhs2.type)
            {
                bh_str_buf_append_lit(&str_buf, " ");
            }
            if (expr.operation == TAC_OP_BT)
            {
                bh_str_buf_append(&str_buf, class_name);
                bh_str_buf_append_lit(&str_buf, "_");
                bh_str_buf_append(&str_buf, tac_list.method_name);
                bh_str_buf_append_lit(&str_buf, "_");
            }
            if (expr.operation == TAC_OP_CALL)
            {
                for (int i = 0; i < expr.arg_count; i++)
                {
                    bh_str_buf_append_lit(&str_buf, " ");
                    append_tac_symbol(&str_buf, class_list, expr.args[i]);
                }
            }
            append_tac_symbol(&str_buf, class_list, expr.rhs2);
            bh_str_buf_append_lit(&str_buf, "\n");
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

    if (false) // Write asm to file
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

    if (true) // Write x86 to file
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
}