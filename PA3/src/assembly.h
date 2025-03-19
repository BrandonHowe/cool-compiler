//
// Created by Brandon Howe on 3/18/25.
//

#ifndef ASSEMBLY_H
#define ASSEMBLY_H
#include <stdint.h>

#include "allocator.h"
#include "tac.h"

typedef enum ASMOpType
{
    ASM_OP_NULL,
    ASM_OP_PUSH,
    ASM_OP_POP,
    ASM_OP_LI,
    ASM_OP_LA,
    ASM_OP_CALL,
    ASM_OP_ST,
    ASM_OP_ADD
} ASMOpType;

typedef enum ASMParamType
{
    ASM_PARAM_NULL,
    ASM_PARAM_IMMEDIATE,
    ASM_PARAM_REGISTER,
    ASM_PARAM_METHOD
} ASMParamType;

typedef enum ASMRegister
{
    INVALID_REGISTER,
    RAX,
    RBX,
    RCX,
    RDX,
    RSI,
    RDI,
    RBP,
    RSP,
    R8,
    R9,
    R10,
    R11,
    R12,
    R13,
    R14,
    R15
} ASMRegister;

typedef struct ASMParam
{
    ASMParamType type;
    union
    {
        struct { int16_t val; } immediate;
        struct { ASMRegister name; int16_t offset; } reg;
        struct { int16_t class_idx; int16_t method_idx; } method;
    };
} ASMParam;

typedef struct ASMInstr
{
    ASMOpType op;
    ASMParam params[3];
} ASMInstr;

typedef struct ASMList
{
    ASMInstr* instructions;
    int16_t instruction_count;
    int16_t instruction_capacity;
    bh_allocator allocator;
} ASMList;

void asm_from_tac_list(ASMList* asm_list, TACList tac_slice);
ASMList asm_list_init(bh_allocator allocator);
void display_asm_list(bh_str_buf* str_buf, ASMList asm_list);

#endif //ASSEMBLY_H
