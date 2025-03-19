//
// Created by Brandon Howe on 3/18/25.
//

#include "assembly.h"

#include <assert.h>

void asm_list_append(ASMList* asm_list, ASMInstr instr)
{
    asm_list->instructions[asm_list->instruction_count] = instr;
    asm_list->instruction_count += 1;
}

void asm_from_tac_symbol(ASMList* asm_list, TACSymbol symbol)
{
    switch (symbol.type)
    {
    case TAC_SYMBOL_TYPE_INTEGER:
        asm_list_append(asm_list, (ASMInstr){
            .op = ASM_OP_PUSH,
            .params = (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = RBP }
        });
        asm_list_append(asm_list, (ASMInstr){
            .op = ASM_OP_PUSH,
            .params = (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R12 }
        });
        asm_list_append(asm_list, (ASMInstr){
            .op = ASM_OP_LA,
            .params = {
                (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R14 },
                (ASMParam){ .type = ASM_PARAM_METHOD, .method = { .class_idx = 2, .method_idx = 1 } }
            }
        });
        asm_list_append(asm_list, (ASMInstr){
            .op = ASM_OP_CALL,
            .params = (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R14 }
        });
        asm_list_append(asm_list, (ASMInstr){
            .op = ASM_OP_POP,
            .params = (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R12 }
        });
        asm_list_append(asm_list, (ASMInstr){
            .op = ASM_OP_POP,
            .params = (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = RBP }
        });
        asm_list_append(asm_list, (ASMInstr){
            .op = ASM_OP_LI,
            .params = {
                (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R14 },
                (ASMParam){ .type = ASM_PARAM_IMMEDIATE, .immediate = symbol.integer }
            }
        });
        asm_list_append(asm_list, (ASMInstr){
            .op = ASM_OP_ST,
            .params = {
                (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = { .name = R13, .offset = 3 } },
                (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R14 }
            }
        });
        break;
    case TAC_SYMBOL_TYPE_SYMBOL:
        break;
    case TAC_SYMBOL_TYPE_VARIABLE:
        break;
    case TAC_SYMBOL_TYPE_BOOL:
        break;
    case TAC_SYMBOL_TYPE_STRING:
        break;
    default:
        assert(0 && "Unhandled asm from tac symbol type");
    }
}

void asm_from_tac_list(ASMList* asm_list, TACList tac_slice)
{
    for (int i = 0; i < tac_slice.count; i++)
    {
        TACExpr expr = tac_slice.items[i];

        switch (expr.operation)
        {
        case TAC_OP_ASSIGN: break;
        case TAC_OP_PLUS:
        case TAC_OP_MINUS:
        case TAC_OP_TIMES:
        case TAC_OP_DIVIDE:
            asm_from_tac_symbol(asm_list, expr.rhs1);
            asm_list_append(asm_list, (ASMInstr){
                .op = ASM_OP_PUSH,
                .params = (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R13 }
            });
            asm_from_tac_symbol(asm_list, expr.rhs2);
            asm_list_append(asm_list, (ASMInstr){
                .op = ASM_OP_POP,
                .params = (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R14 }
            });
            asm_list_append(asm_list, (ASMInstr){
                .op = ASM_OP_ADD + (expr.operation - TAC_OP_PLUS),
                .params = {
                    (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R13 },
                    (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R14 },
                    (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R13 },
                }
            });
            break;
        case TAC_OP_LT:
            break;
        case TAC_OP_LTE:
            break;
        case TAC_OP_EQ:
            break;
        case TAC_OP_INT: asm_from_tac_symbol(asm_list, expr.rhs1);
            break;
        case TAC_OP_STRING:
            break;
        case TAC_OP_BOOL:
            break;
        case TAC_OP_NOT:
            break;
        case TAC_OP_NEG:
            break;
        case TAC_OP_NEW:
            break;
        case TAC_OP_DEFAULT:
            break;
        case TAC_OP_ISVOID:
            break;
        case TAC_OP_CALL:
            break;
        case TAC_OP_JMP:
            break;
        case TAC_OP_LABEL:
            break;
        case TAC_OP_RETURN:
            break;
        case TAC_OP_COMMENT:
            break;
        case TAC_OP_BT:
            break;
        default:
            assert(0 && "Trying to convert unhandled tac expression to assembly");
        }
    }
}

void display_asm_param(bh_str_buf* str_buf, const ASMParam param)
{
    bh_str_buf_append_lit(str_buf, " ");
    switch (param.type)
    {
    case ASM_PARAM_NULL:
        break;
    case ASM_PARAM_IMMEDIATE:
        bh_str_buf_append_format(str_buf, "%i", param.immediate.val);
        break;
    case ASM_PARAM_REGISTER:
        switch (param.reg.name)
        {
        case INVALID_REGISTER: bh_str_buf_append_lit(str_buf, "RINVALID"); break;
        case RAX: bh_str_buf_append_lit(str_buf, "rax"); break;
        case RBX: bh_str_buf_append_lit(str_buf, "rbx"); break;
        case RCX: bh_str_buf_append_lit(str_buf, "rcx"); break;
        case RDX: bh_str_buf_append_lit(str_buf, "rdx"); break;
        case RSI: bh_str_buf_append_lit(str_buf, "rsi"); break;
        case RDI: bh_str_buf_append_lit(str_buf, "rdi"); break;
        case RBP: bh_str_buf_append_lit(str_buf, "rbp"); break;
        case RSP: bh_str_buf_append_lit(str_buf, "rsp"); break;
        case R8: bh_str_buf_append_lit(str_buf, "r8"); break;
        case R9: bh_str_buf_append_lit(str_buf, "r9"); break;
        case R10: bh_str_buf_append_lit(str_buf, "r10"); break;
        case R11: bh_str_buf_append_lit(str_buf, "r11"); break;
        case R12: bh_str_buf_append_lit(str_buf, "r12"); break;
        case R13: bh_str_buf_append_lit(str_buf, "r13"); break;
        case R14: bh_str_buf_append_lit(str_buf, "r14"); break;
        case R15: bh_str_buf_append_lit(str_buf, "r15"); break;
        }
        if (param.reg.offset)
        {
            bh_str_buf_append_format(str_buf, "[%i]", param.reg.offset);
        }
        break;
    case ASM_PARAM_METHOD:
        bh_str_buf_append_format(str_buf, "method", param.immediate.val);
        break;
    }
}

void display_asm_list(bh_str_buf* str_buf, const ASMList asm_list)
{
    for (int i = 0; i < asm_list.instruction_count; i++)
    {
        const ASMInstr instr = asm_list.instructions[i];
        switch (instr.op)
        {
        case ASM_OP_NULL:
            bh_str_buf_append_lit(str_buf, "NULL");
        case ASM_OP_PUSH:
            bh_str_buf_append_lit(str_buf, "push");
            display_asm_param(str_buf, instr.params[0]);
            break;
        case ASM_OP_POP:
            bh_str_buf_append_lit(str_buf, "pop");
            display_asm_param(str_buf, instr.params[0]);
            break;
        case ASM_OP_LI:
            bh_str_buf_append_lit(str_buf, "li");
            display_asm_param(str_buf, instr.params[0]);
            bh_str_buf_append_lit(str_buf, " <-");
            display_asm_param(str_buf, instr.params[1]);
            break;
        case ASM_OP_LA:
            bh_str_buf_append_lit(str_buf, "la");
            display_asm_param(str_buf, instr.params[0]);
            bh_str_buf_append_lit(str_buf, " <-");
            display_asm_param(str_buf, instr.params[1]);
            break;
        case ASM_OP_CALL:
            bh_str_buf_append_lit(str_buf, "call");
            display_asm_param(str_buf, instr.params[0]);
            break;
        case ASM_OP_ST:
            bh_str_buf_append_lit(str_buf, "st");
            display_asm_param(str_buf, instr.params[0]);
            bh_str_buf_append_lit(str_buf, " <-");
            display_asm_param(str_buf, instr.params[1]);
            break;
        case ASM_OP_ADD:
            bh_str_buf_append_lit(str_buf, "add");
            display_asm_param(str_buf, instr.params[0]);
            bh_str_buf_append_lit(str_buf, " <-");
            display_asm_param(str_buf, instr.params[1]);
            display_asm_param(str_buf, instr.params[2]);
            break;
        }
        bh_str_buf_append_lit(str_buf, "\n");
    }
}

ASMList asm_list_init(bh_allocator allocator)
{
    return (ASMList){
        .allocator = allocator,
        .instruction_capacity = 1000,
        .instructions = bh_alloc(allocator, 1000 * sizeof(ASMInstr)),
        .instruction_count = 0
    };
}