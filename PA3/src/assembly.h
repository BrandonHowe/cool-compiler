//
// Created by Brandon Howe on 3/18/25.
//

#ifndef ASSEMBLY_H
#define ASSEMBLY_H
#include <stdint.h>

#include "allocator.h"
#include "tac.h"

#define CONSTRUCTOR_METHOD (-1)
#define INTERNAL_CLASS (-1)
#define INTERNAL_STRINGS (-2)
#define INTERNAL_CUSTOM_STRINGS (-3)
#define INTERNAL_ABORT_STR (-2)
#define INTERNAL_VOID_DISPATCH_START_STR (-3)
#define INTERNAL_VOID_DISPATCH_END_STR (-4)
#define INTERNAL_EQ_HANDLER (-3)
#define INTERNAL_LE_HANDLER (-4)
#define INTERNAL_LT_HANDLER (-5)

typedef enum ASMOpType
{
    ASM_OP_NULL,
    ASM_OP_PUSH,
    ASM_OP_POP,
    ASM_OP_MOV,
    ASM_OP_LI,
    ASM_OP_LA,
    ASM_OP_LD,
    ASM_OP_CALL,
    ASM_OP_SYSCALL,
    ASM_OP_RETURN,
    ASM_OP_ALLOC,
    ASM_OP_ST,
    ASM_OP_JMP,
    ASM_OP_BEQ,
    ASM_OP_BLT,
    ASM_OP_BLE,
    ASM_OP_BNZ,
    ASM_OP_ADD,
    ASM_OP_SUB,
    ASM_OP_MUL,
    ASM_OP_DIV,
    ASM_OP_LABEL,
    ASM_OP_CONSTANT,
    ASM_OP_COMMENT,
} ASMOpType;

typedef enum ASMParamType
{
    ASM_PARAM_NULL,
    ASM_PARAM_IMMEDIATE,
    ASM_PARAM_REGISTER,
    ASM_PARAM_METHOD,
    ASM_PARAM_CONSTANT,
    ASM_PARAM_STRING_CONSTANT,
    ASM_PARAM_LABEL,
    ASM_PARAM_COMMENT
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
    R15,
    RA, // Not a real register
} ASMRegister;

typedef enum ASMImmediateUnits
{
    ASMImmediateUnitsBase,
    ASMImmediateUnitsWord
} ASMImmediateUnits;

typedef struct ASMParam
{
    ASMParamType type;
    union
    {
        struct { int16_t val; ASMImmediateUnits units; } immediate;
        struct { ASMRegister name; int16_t offset; } reg;
        struct { int16_t class_idx; int16_t method_idx; } method;
        bh_str label;
        bh_str comment;
        bh_str constant;
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
    bh_allocator tac_allocator;
    bh_allocator string_allocator;
    ClassNodeList* class_list;

    int16_t _stack_depth;
    int16_t _global_label;
    int16_t _string_counter;
} ASMList;

void asm_from_vtable(ASMList* asm_list);
void asm_list_append_call_method(ASMList* asm_list, int16_t class_idx, int16_t method_idx);
void asm_from_constructor(ASMList* asm_list, ClassNode class_node, int16_t class_idx);
void asm_from_tac_list(ASMList* asm_list, TACList tac_list);
void asm_from_method(ASMList* asm_list, TACList tac_list);
ASMList asm_list_init();

void display_asm_list(bh_str_buf* str_buf, ASMList asm_list);
void x86_asm_list(bh_str_buf* str_buf, ASMList asm_list);

void builtin_append_string_helpers(bh_str_buf* buf);
void builtin_append_string_constants(ASMList* asm_list);
void builtin_append_comp_handler(ASMList* asm_list, TACOp op);
void builtin_append_start(ASMList* asm_list);
void builtin_append_custom_string_constant(ASMList* asm_list, bh_str label, bh_str data);

#endif //ASSEMBLY_H
