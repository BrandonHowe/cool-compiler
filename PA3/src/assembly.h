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
#define INTERNAL_EMPTY_STR (-1)
#define INTERNAL_ABORT_STR (-2)
#define INTERNAL_SUBSTR_RANGE_STR (-5)
#define INTERNAL_EQ_HANDLER (-3)
#define INTERNAL_LE_HANDLER (-4)
#define INTERNAL_LT_HANDLER (-5)
#define INTERNAL_STRCAT_HANDLER (-6)
#define INTERNAL_STRLEN_HANDLER (-7)
#define INTERNAL_SUBSTR_HANDLER (-8)
#define INTERNAL_COOLALLOC_INIT_HANDLER (-9)
#define INTERNAL_COOLOUT_FLUSH_HANDLER (-10)

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
    ASM_OP_AND,
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
    ASM_PARAM_COMMENT,
    ASM_PARAM_STRING_LABEL,
} ASMParamType;

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
        struct { int64_t val; ASMImmediateUnits units; } immediate;
        struct { ASMRegister name; int64_t offset; } reg;
        struct { int64_t class_idx; int64_t method_idx; } method;
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

typedef struct ASMErrorStr
{
    bh_str label;
    bh_str message;
} ASMErrorStr;

typedef struct ASMCaseBinding
{
    bh_str name;
    int64_t symbol;
} ASMCaseBinding;

typedef struct ASMList
{
    ASMInstr* instructions;
    int64_t instruction_count;
    int64_t instruction_capacity;
    bh_allocator tac_allocator;
    bh_allocator string_allocator;

    ClassNodeList* class_list;
    int64_t bool_class_idx;
    int64_t int_class_idx;
    int64_t io_class_idx;
    int64_t string_class_idx;

    ASMErrorStr* error_strs;
    int64_t error_str_count;
    int64_t error_str_capacity;

    ASMCaseBinding* case_bindings;
    int64_t case_binding_count;
    int64_t case_binding_capacity;

    int64_t _stack_depth;
    int64_t _global_label;
    int64_t _error_label;
    int64_t _string_counter;

    int64_t _registers_used;
} ASMList;

typedef struct MainData
{
    int64_t main_ctor_idx;
    int64_t main_class_idx;
    int64_t main_method_idx;
} MainData;

typedef struct CallData
{
    TACList tac_list;
    int64_t class_idx;
    int64_t method_idx;
    bool called;
} CallData;

MainData find_maindata(ASMList* asm_list);
void asm_from_vtable(ASMList* asm_list);
void asm_list_append_call_method(ASMList* asm_list, int64_t class_idx, int64_t method_idx);
void asm_from_constructor(ASMList* asm_list, ClassNode class_node, int64_t class_idx, CallData* call_data, int64_t total_method_count);
int64_t asm_from_tac_list(ASMList* asm_list, TACList tac_list);
void asm_from_method_stub(ASMList* asm_list, TACList tac_list);
void asm_from_method(ASMList* asm_list, TACList tac_list);
void peephole_optimize_asm_list(ASMList* asm_list);
ASMList asm_list_init(ClassNodeList* class_list);

void display_asm_list(bh_str_buf* str_buf, ASMList asm_list);
void x86_asm_list(bh_str_buf* str_buf, ASMList asm_list);

void builtin_append_string_helpers(bh_str_buf* buf);
void builtin_append_string_constants(ASMList* asm_list);
void builtin_append_comp_handler(ASMList* asm_list, TACOp op);
void builtin_append_start(ASMList* asm_list);

void fill_call_data_from_list(TACList list, CallData* call_data, int64_t total_method_count);

#endif //ASSEMBLY_H
