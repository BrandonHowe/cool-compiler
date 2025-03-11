//
// Created by Brandon Howe on 3/5/25.
//

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ast.h"
#include "tac.h"
#include "types.h"

bh_str read_file_text(const char* file_name)
{
    FILE *file = fopen(file_name, "r");
    if (file == NULL) {
        perror("Failed to open file");
        return (bh_str){ 0 };
    }

    // Seek to the end to determine the file size
    fseek(file, 0, SEEK_END);
    long fileSize = ftell(file);
    rewind(file);

    // Allocate memory to hold the file content
    char* buffer = malloc(fileSize);
    if (buffer == NULL) {
        perror("Failed to allocate memory");
        fclose(file);
        return (bh_str){ 0 };
    }

    // Read the file into the buffer
    size_t bytesRead = fread(buffer, 1, fileSize, file);
    if (bytesRead != fileSize) {
        perror("Failed to read the file");
        free(buffer);
        fclose(file);
        return (bh_str){ 0 };
    }

    fclose(file);
    return (bh_str){ .buf = buffer, .len = bytesRead };
}

void append_tac_symbol(bh_str_buf* str_buf, TACSymbol symbol)
{
    switch (symbol.type)
    {
    case TAC_SYMBOL_TYPE_NULL: break;
    case TAC_SYMBOL_TYPE_SYMBOL: bh_str_buf_append_format(str_buf, "t$%i", symbol.symbol); break;
    case TAC_SYMBOL_TYPE_VARIABLE: bh_str_buf_append(str_buf, symbol.variable); break;
    case TAC_SYMBOL_TYPE_INTEGER: bh_str_buf_append_format(str_buf, "%i", symbol.integer); break;
    case TAC_SYMBOL_TYPE_STRING: bh_str_buf_append(str_buf, symbol.string); break;
    case TAC_SYMBOL_TYPE_BOOL: bh_str_buf_append_format(str_buf, "%s", symbol.integer ? "true" : "false"); break;
    }
}

int main(int argc, char* argv[])
{
    if (argc < 2) {
        printf("Usage: %s, <input_file>\n", argv[0]);
        return 1;
    }

    bh_str file = read_file_text(argv[1]);
    bh_str file_name = bh_str_from_cstr(argv[1]);

    // bh_allocator parser_arena = arena_init(1000000);
    bh_allocator parser_arena = GPA;
    ClassNodeList class_list = parse_class_map(&file, parser_arena);
    parse_implementation_map(&file, parser_arena, class_list);
    parse_parent_map(&file, parser_arena, class_list);
    CoolAST AST = parse_ast(&file, parser_arena);

    bh_allocator tac_arena = arena_init(100000);
    TACList tac_list = tac_list_from_ast(AST, tac_arena, class_list);

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
            bh_str_buf_append(&str_buf, tac_list.label_base);
            break;
        case TAC_OP_LABEL:
            bh_str_buf_append_lit(&str_buf, "label ");
            bh_str_buf_append(&str_buf, tac_list.label_base);
            break;
        case TAC_OP_RETURN: bh_str_buf_append_lit(&str_buf, "return "); break;
        case TAC_OP_COMMENT: bh_str_buf_append_lit(&str_buf, "comment "); break;
        case TAC_OP_BT: bh_str_buf_append_lit(&str_buf, "bt "); break;
        default: assert(0 && "Invalid expression"); break;
        }
        append_tac_symbol(&str_buf, expr.rhs1);
        if (expr.rhs2.type)
        {
            bh_str_buf_append_lit(&str_buf, " ");
        }
        if (expr.operation == TAC_OP_BT) bh_str_buf_append(&str_buf, tac_list.label_base);
        if (expr.operation == TAC_OP_CALL)
        {
            for (int i = 0; i < expr.arg_count; i++)
            {
                bh_str_buf_append_lit(&str_buf, " ");
                append_tac_symbol(&str_buf, expr.args[i]);
            }
        }
        append_tac_symbol(&str_buf, expr.rhs2);
        bh_str_buf_append_lit(&str_buf, "\n");
    }

    char* output_name = bh_alloc(GPA, file_name.len + 10);
    strncpy(output_name, file_name.buf, file_name.len - 4);
    strncpy(output_name + file_name.len - 4, "tac", 3);

    FILE* fptr;
    fptr = fopen(output_name, "wb");
    assert(fptr != NULL);
    fwrite(str_buf.buf, 1, str_buf.len, fptr);
    fclose(fptr);

    // fwrite(str_buf.buf, 1, str_buf.len, stdout);

    bh_str_buf_deinit(&str_buf);

    return 0;
}