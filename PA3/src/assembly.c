//
// Created by Brandon Howe on 3/18/25.
//

#include "assembly.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>

#include "optimizer_tac.h"

#pragma region Assembly operations

ASMInstr* asm_list_append(ASMList* asm_list, const ASMInstr instr)
{
    if (asm_list->instruction_count + 1 >= asm_list->instruction_capacity)
    {
        asm_list->instruction_capacity *= 2;
        mprotect(asm_list->instructions, asm_list->instruction_capacity * sizeof(ASMInstr), PROT_READ | PROT_WRITE);
    }
    asm_list->instructions[asm_list->instruction_count] = instr;
    asm_list->instruction_count += 1;
    return &asm_list->instructions[asm_list->instruction_count - 1];
}

void asm_list_append_return(ASMList* asm_list)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_RETURN
    });
}

void asm_list_append_comment(ASMList* asm_list, const char* comment)
{
    bh_str comment_str = bh_str_from_cstr(comment);
    char* buf = bh_alloc(asm_list->string_allocator, comment_str.len);
    strncpy(buf, comment_str.buf, comment_str.len);
    comment_str.buf = buf;

    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_COMMENT,
        .params = {
            (ASMParam){ .type = ASM_PARAM_COMMENT, .comment = comment_str },
        }
    });
}

void asm_list_append_comment_str(ASMList* asm_list, bh_str comment_str)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_COMMENT,
        .params = {
            (ASMParam){ .type = ASM_PARAM_COMMENT, .comment = comment_str },
        }
    });
}

void asm_list_append_constant(ASMList* asm_list, bh_str constant_label)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_CONSTANT,
        .params = {
            (ASMParam){ .type = ASM_PARAM_CONSTANT, .constant = constant_label },
        }
    });
}

void asm_list_append_string_constant(ASMList* asm_list, bh_str constant_label)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_CONSTANT,
        .params = {
            (ASMParam){ .type = ASM_PARAM_STRING_CONSTANT, .constant = constant_label },
        }
    });
}

void asm_list_append_label(ASMList* asm_list, bh_str label)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_LABEL,
        .params = {
            (ASMParam){ .type = ASM_PARAM_LABEL, .label = label },
        }
    });
}

void asm_list_append_mov(ASMList* asm_list, const ASMRegister dest, const ASMRegister source)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_MOV,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = dest },
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = source }
        }
    });
}

void asm_list_append_push(ASMList* asm_list, const ASMRegister reg)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_PUSH,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = reg }
        }
    });
}

void asm_list_append_pop(ASMList* asm_list, const ASMRegister reg)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_POP,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = reg }
        }
    });
}

ASMInstr* asm_list_append_li(ASMList* asm_list, const ASMRegister reg, const int64_t immediate, const ASMImmediateUnits units)
{
    return asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_LI,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = reg },
            (ASMParam){ .type = ASM_PARAM_IMMEDIATE, .immediate = { .val = immediate, .units = units } }
        }
    });
}

void asm_list_append_la(ASMList* asm_list, const ASMRegister reg, const int64_t class_idx, const int64_t method_idx)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_LA,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = reg },
            (ASMParam){ .type = ASM_PARAM_METHOD, .method = { .class_idx = class_idx, .method_idx = method_idx } }
        }
    });
}

void asm_list_append_la_label(ASMList* asm_list, const ASMRegister reg, const bh_str label)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_LA,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = reg },
            (ASMParam){ .type = ASM_PARAM_STRING_LABEL, .label = label }
        }
    });
}

void asm_list_append_ld(ASMList* asm_list, const ASMRegister dest, const ASMRegister source, const int64_t offset)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_LD,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = { .name = dest } },
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = { .name = source, .offset = offset } }
        }
    });
}

void asm_list_append_call(ASMList* asm_list, const ASMRegister dest)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_CALL,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = { .name = dest } },
        }
    });
}

void asm_list_append_syscall(ASMList* asm_list, const int64_t class_idx, const int64_t method_idx)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_SYSCALL,
        .params = {
            (ASMParam){ .type = ASM_PARAM_METHOD, .method = { .class_idx = class_idx, .method_idx = method_idx } },
        }
    });
}

void asm_list_append_st(ASMList* asm_list, const ASMRegister dest, const int64_t offset, const ASMRegister source)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_ST,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = { .name = dest, .offset = offset } },
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = source },
        }
    });
}

void asm_list_append_beq(ASMList* asm_list, const ASMRegister arg1, const ASMRegister arg2, const bh_str label)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_BEQ,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = arg1 },
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = arg2 },
            (ASMParam){ .type = ASM_PARAM_LABEL, .label = label },
        }
    });
}

void asm_list_append_blt(ASMList* asm_list, const ASMRegister arg1, const ASMRegister arg2, const bh_str label)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_BLT,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = arg1 },
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = arg2 },
            (ASMParam){ .type = ASM_PARAM_LABEL, .label = label },
        }
    });
}

void asm_list_append_ble(ASMList* asm_list, const ASMRegister arg1, const ASMRegister arg2, const bh_str label)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_BLE,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = arg1 },
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = arg2 },
            (ASMParam){ .type = ASM_PARAM_LABEL, .label = label },
        }
    });
}

void asm_list_append_bz(ASMList* asm_list, const ASMRegister arg1, const bh_str label)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_BEQ,
        .params = {
            (ASMParam){ .type = ASM_PARAM_IMMEDIATE, .immediate = 0 },
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = arg1 },
            (ASMParam){ .type = ASM_PARAM_LABEL, .label = label },
        }
    });
}

void asm_list_append_bnz(ASMList* asm_list, const ASMRegister arg1, const bh_str label)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_BNZ,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = arg1 },
            (ASMParam){ .type = ASM_PARAM_LABEL, .label = label },
        }
    });
}

void asm_list_append_jmp(ASMList* asm_list, bh_str label)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_JMP,
        .params = {
            (ASMParam){ .type = ASM_PARAM_LABEL, .label = label },
        }
    });
}

void asm_list_append_to_stack(ASMList* asm_list, const ASMRegister source)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_ST,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = { .name = RBP, .offset = asm_list->_stack_depth++ } },
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = source },
        }
    });
}

void asm_list_append_arith(ASMList* asm_list, const ASMOpType operation, const ASMRegister reg1, const ASMRegister reg2)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = operation,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = reg1 },
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = reg2 },
        }
    });
}

void asm_list_append_and(ASMList* asm_list, const ASMRegister dest, const int64_t input)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_AND,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = dest },
            (ASMParam){ .type = ASM_PARAM_IMMEDIATE, .immediate = { .val = input, .units = ASMImmediateUnitsBase } },
        }
    });
}

void asm_list_append_align_sp(ASMList* asm_list)
{
    asm_list_append_and(asm_list, RSP, 0xFFFFFFFFFFFFFFF0);
}

void asm_list_append_st_tac_symbol(ASMList* asm_list, const ClassNode class_node, const ClassMethod method, const TACSymbol symbol)
{
    switch (symbol.type)
    {
    case TAC_SYMBOL_TYPE_SYMBOL:
        asm_list_append_st(asm_list, RBP, -symbol.symbol, R13);
        break;
    case TAC_SYMBOL_TYPE_VARIABLE:
        {
            // Look up the variable name from parameters
            int64_t attribute_idx = -1;
            for (int j = 0; j < method.parameter_count; j++)
            {
                if (bh_str_equal(method.parameters[j].name, symbol.variable.data))
                {
                    attribute_idx = j;
                    break;
                }
            }
            if (attribute_idx > -1)
            {
                int64_t offset = method.parameter_count - attribute_idx + 2;
                // asm_list_append_ld(asm_list, R13, RBP, offset);
                asm_list_append_st(asm_list, RBP, offset, R13);
            }
            else
            {
                // Look up the variable name from attributes
                for (int j = 0; j < class_node.attribute_count; j++)
                {
                    if (bh_str_equal(class_node.attributes[j].name, symbol.variable.data))
                    {
                        attribute_idx = j;
                        break;
                    }
                }
                assert(attribute_idx != -1 && "Could not find attribute for LHS");
                // asm_list_append_ld(asm_list, R13, R12, attribute_idx + 3);
                asm_list_append_st(asm_list, R12, attribute_idx + 3, R13);
            }
            break;
        }
    default:
        assert(0 && "Unhandled LHS of TAC");
    }
}

void asm_list_append_ld_tac_symbol(ASMList* asm_list, const ClassNode class_node, const ClassMethod method, const ASMRegister dest, const TACSymbol symbol)
{
    switch (symbol.type)
    {
    case TAC_SYMBOL_TYPE_SYMBOL:
        asm_list_append_ld(asm_list, dest, RBP, -symbol.symbol);
        break;
    case TAC_SYMBOL_TYPE_VARIABLE:
        {
            if (bh_str_equal_lit(symbol.variable.data, "self"))
            {
                asm_list_append_mov(asm_list, dest, R12);
                break;
            }
            // Check if the variable is bound from a case expression
            int64_t attribute_idx = -1;
            for (int j = asm_list->case_binding_count - 1; j >= 0; j--)
            {
                if (bh_str_equal(asm_list->case_bindings[j].name, symbol.variable.data))
                {
                    attribute_idx = asm_list->case_bindings[j].symbol;
                    break;
                }
            }
            if (attribute_idx > -1)
            {
                asm_list_append_ld(asm_list, dest, RBP, -attribute_idx);
                break;
            }

            // Look up the variable name from parameters
            for (int j = 0; j < method.parameter_count; j++)
            {
                if (bh_str_equal(method.parameters[j].name, symbol.variable.data))
                {
                    attribute_idx = j;
                    break;
                }
            }
            if (attribute_idx > -1)
            {
                int64_t offset = method.parameter_count - attribute_idx + 2;
                asm_list_append_ld(asm_list, dest, RBP, offset);
                break;
            }

            // Look up the variable name from attributes
            for (int j = 0; j < class_node.attribute_count; j++)
            {
                if (bh_str_equal(class_node.attributes[j].name, symbol.variable.data))
                {
                    attribute_idx = j;
                    break;
                }
            }
            assert(attribute_idx != -1 && "Could not find attribute for LHS");
            asm_list_append_ld(asm_list, dest, R12, attribute_idx + 3);
            break;
        }
    default:
        assert(0 && "Unhandled LHS of TAC");
    }
}

bh_str asm_list_create_label(ASMList* asm_list)
{
    bh_str_buf label_buf = bh_str_buf_init(asm_list->string_allocator, 5);
    bh_str_buf_append_format(&label_buf, "l%i", ++asm_list->_global_label);
    bh_str label_str = (bh_str){ .buf = label_buf.buf, .len = label_buf.len };

    return label_str;
}

bh_str asm_list_create_error_label(ASMList* asm_list)
{
    bh_str_buf label_buf = bh_str_buf_init(asm_list->string_allocator, 9);
    bh_str_buf_append_format(&label_buf, "error%i", ++asm_list->_error_label);
    bh_str label_str = (bh_str){ .buf = label_buf.buf, .len = label_buf.len };

    return label_str;
}

void asm_list_append_error_str(ASMList* asm_list, const bh_str label, const bh_str message)
{
    if (asm_list->error_str_count + 1 >= asm_list->error_str_capacity)
    {
        asm_list->error_str_capacity *= 2;
        mprotect(asm_list->error_strs, asm_list->error_str_capacity * sizeof(ASMInstr), PROT_READ | PROT_WRITE);
    }
    asm_list->error_strs[asm_list->error_str_count].label = label;
    asm_list->error_strs[asm_list->error_str_count].message = message;
    asm_list->error_str_count += 1;
}

void asm_list_append_runtime_error(ASMList* asm_list, const int64_t line_num, const char* message)
{
    // Create bh_str for error and message
    bh_str error_label = asm_list_create_error_label(asm_list);
    bh_str_buf message_buf = bh_str_buf_init(asm_list->string_allocator, 20);
    bh_str_buf_append_format(&message_buf, "ERROR: %i: Exception: ", line_num);
    bh_str_buf_append_lit(&message_buf, message);
    bh_str_buf_append_lit(&message_buf, "\\n");
    bh_str message_str = (bh_str){ .buf = message_buf.buf, .len = message_buf.len };

    // Add the strings to the list of strings
    asm_list_append_error_str(asm_list, error_label, message_str);

    // Call out_string andabort
    asm_list_append_la_label(asm_list, R13, error_label);
    asm_list_append_syscall(asm_list, asm_list->io_class_idx, 6);
    asm_list_append_syscall(asm_list, INTERNAL_CLASS, 0);
}

void asm_list_append_runtime_error_bh_str(ASMList* asm_list, const int64_t line_num, bh_str message)
{
    // Create bh_str for error and message
    bh_str error_label = asm_list_create_error_label(asm_list);
    bh_str_buf message_buf = bh_str_buf_init(asm_list->string_allocator, 20);
    bh_str_buf_append_format(&message_buf, "ERROR: %i: Exception: ", line_num);
    bh_str_buf_append(&message_buf, message);
    bh_str_buf_append_lit(&message_buf, "\\n");
    bh_str message_str = (bh_str){ .buf = message_buf.buf, .len = message_buf.len };

    // Add the strings to the list of strings
    asm_list_append_error_str(asm_list, error_label, message_str);

    asm_list_append_la_label(asm_list, R13, error_label);
    asm_list_append_syscall(asm_list, asm_list->io_class_idx, 6);
    asm_list_append_syscall(asm_list, INTERNAL_CLASS, 0);
}

void asm_list_push_case_binding(ASMList* asm_list, const bh_str label, const int64_t symbol)
{
    if (asm_list->case_binding_count + 1 >= asm_list->case_binding_capacity)
    {
        asm_list->case_binding_capacity *= 2;
        mprotect(asm_list->case_bindings, asm_list->case_binding_capacity * sizeof(ASMCaseBinding), PROT_READ | PROT_WRITE);
    }
    asm_list->case_bindings[asm_list->case_binding_count].name = label;
    asm_list->case_bindings[asm_list->case_binding_count].symbol = symbol;
    asm_list->case_binding_count++;
}

void asm_list_pop_case_binding(ASMList* asm_list)
{
    asm_list->case_binding_count--;
}

#pragma endregion

#pragma region TAC to assembly

void asm_from_vtable(ASMList* asm_list)
{
    asm_list_append_comment(asm_list, "vtable definitions");
    for (int i = 0; i < asm_list->class_list->class_count; i++)
    {
        const ClassNode class_node = asm_list->class_list->class_nodes[i];
        char* label_buf = bh_alloc(asm_list->string_allocator, class_node.name.len + 8);
        strncpy(label_buf, class_node.name.buf, class_node.name.len);
        strncpy(label_buf + class_node.name.len, "..vtable", 8);
        asm_list_append_label(asm_list, (bh_str){ .buf = label_buf, .len = class_node.name.len + 8 });

        char* name_constant_buf = bh_alloc(asm_list->string_allocator, class_node.name.len + 5);
        strncpy(name_constant_buf, class_node.name.buf, class_node.name.len);
        strncpy(name_constant_buf + class_node.name.len, "_name", 5);
        asm_list_append_constant(asm_list, (bh_str){ .buf = name_constant_buf, .len = class_node.name.len + 5 });

        char* constructor_buf = bh_alloc(asm_list->string_allocator, class_node.name.len + 5);
        strncpy(constructor_buf, class_node.name.buf, class_node.name.len);
        strncpy(constructor_buf + class_node.name.len, "..new", 5);
        asm_list_append_constant(asm_list, (bh_str){ .buf = constructor_buf, .len = class_node.name.len + 5 });

        for (int j = 0; j < class_node.method_count; j++)
        {
            const ClassMethod method = class_node.methods[j];
            const int64_t method_name_len = method.name.len + method.inherited_from.len + 1;
            char* method_name_buf = bh_alloc(asm_list->string_allocator, method_name_len);
            strncpy(method_name_buf, method.inherited_from.buf, method.inherited_from.len);
            strncpy(method_name_buf + method.inherited_from.len, ".", 1);
            strncpy(method_name_buf + method.inherited_from.len + 1, method.name.buf, method.name.len);
            asm_list_append_constant(asm_list, (bh_str){ .buf = method_name_buf, .len = method_name_len });
        }
    }
}

void asm_from_constructor(ASMList* asm_list, const ClassNode class_node, const int64_t class_idx)
{
    char* constructor_buf = bh_alloc(asm_list->string_allocator, class_node.name.len + 5);
    strncpy(constructor_buf, class_node.name.buf, class_node.name.len);
    strncpy(constructor_buf + class_node.name.len, "..new", 5);
    asm_list_append_label(asm_list, (bh_str){ .buf = constructor_buf, .len = class_node.name.len + 5 });

    // initialization stuff
    asm_list_append_push(asm_list, RBP);
    asm_list_append_mov(asm_list, RBP, RSP);
    asm_list_append_comment(asm_list, "stack room for temporaries");
    int64_t temp_count = 2;
    int64_t extra_temps = 0;
    ASMInstr* li_instr = asm_list_append_li(asm_list, R14, temp_count, ASMImmediateUnitsWord);
    asm_list_append_arith(asm_list, ASM_OP_SUB, RSP, R14);

    // call malloc
    int64_t attribute_count = class_node.attribute_count;
    if (bh_str_equal_lit(class_node.name, "Bool") ||
        bh_str_equal_lit(class_node.name, "Int") ||
        bh_str_equal_lit(class_node.name, "String"))
    {
        attribute_count += 1;
    }
    int object_size = 3 + attribute_count;
    asm_list_append_li(asm_list, R12, object_size, ASMImmediateUnitsBase);
    asm_list_append_align_sp(asm_list);
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_ALLOC,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R12 },
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R12 },
        }
    });

    // store class tag
    int64_t class_tag = class_idx;
    if (bh_str_equal_lit(class_node.name, "Bool")) class_tag = -1;
    if (bh_str_equal_lit(class_node.name, "Int")) class_tag = -2;
    if (bh_str_equal_lit(class_node.name, "String")) class_tag = -3;
    asm_list_append_comment(asm_list, "store class tag");
    asm_list_append_li(asm_list, R14, class_tag, ASMImmediateUnitsBase);
    asm_list_append_st(asm_list, R12, 0, R14);

    // store object size
    asm_list_append_comment(asm_list, "store object size");
    asm_list_append_li(asm_list, R14, object_size, ASMImmediateUnitsBase);
    asm_list_append_st(asm_list, R12, 1, R14);

    // store vtable pointer
    asm_list_append_comment(asm_list, "store vtable pointer");
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_LA,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R14 },
            (ASMParam){ .type = ASM_PARAM_METHOD, .method = { .class_idx = class_idx, .method_idx = -2 } }
        }
    });
    asm_list_append_st(asm_list, R12, 2, R14);

    if (bh_str_equal_lit(class_node.name, "Int") || bh_str_equal_lit(class_node.name, "Bool"))
    {
        asm_list_append_comment(asm_list, "define built-in attributes");
        asm_list_append_li(asm_list, R13, 0, ASMImmediateUnitsBase);
        asm_list_append_st(asm_list, R12, 3, R13);
    }
    else if (bh_str_equal_lit(class_node.name, "String"))
    {
        asm_list_append_comment(asm_list, "define built-in attributes");
        asm_list_append_la(asm_list, R13, INTERNAL_STRINGS, INTERNAL_EMPTY_STR);
        asm_list_append_st(asm_list, R12, 3, R13);
    }
    else
    {
        asm_list_append_comment(asm_list, "define attributes");
        for (int i = 0; i < class_node.attribute_count; i++) // define attributes
        {
            const ClassAttribute attribute = class_node.attributes[i];
            if (bh_str_equal_lit(attribute.type, "Int"))
            {
                asm_list_append_call_method(asm_list, asm_list->int_class_idx, CONSTRUCTOR_METHOD);
            }
            else if (bh_str_equal_lit(attribute.type, "String"))
            {
                asm_list_append_call_method(asm_list, asm_list->string_class_idx, CONSTRUCTOR_METHOD);
            }
            else if (bh_str_equal_lit(attribute.type, "Bool"))
            {
                asm_list_append_call_method(asm_list, asm_list->bool_class_idx, CONSTRUCTOR_METHOD);
            }
            else
            {
                asm_list_append_li(asm_list, R13, 0, ASMImmediateUnitsBase);
            }

            asm_list_append_st(asm_list, R12, 3 + i, R13);
        }

        asm_list_append_comment(asm_list, "initialize attributes");
        int64_t label = 0;
        for (int i = 0; i < class_node.attribute_count; i++) // initialize attributes
        {
            const ClassAttribute attribute = class_node.attributes[i];

            // attribute initializer
            if (attribute.expr.type)
            {
                TACList list = TAC_list_init(1000, asm_list->tac_allocator);
                list.class_list = *asm_list->class_list;
                list.class_idx = class_idx;
                list._curr_label = label;

                tac_list_from_expression(&attribute.expr, &list, (TACSymbol){ 0 }, false);
                optimize_tac_list(&list);
                asm_from_tac_list(asm_list, list);
                asm_list_append_st(asm_list, R12, i + 3, R13);
                // arena_free_all(asm_list->tac_allocator);

                label = list._curr_label;
                if (list._curr_symbol > extra_temps)
                {
                    extra_temps = list._curr_symbol;
                }
            }
            else if (bh_str_equal_lit(attribute.type, "Int"))
            {
                asm_list_append_call_method(asm_list, asm_list->int_class_idx, -1);
                asm_list_append_st(asm_list, R12, i + 3, R13);
            }
            else if (bh_str_equal_lit(attribute.type, "String"))
            {
                asm_list_append_call_method(asm_list, asm_list->string_class_idx, -1);
                asm_list_append_st(asm_list, R12, i + 3, R13);
            }
            else if (bh_str_equal_lit(attribute.type, "Bool"))
            {
                asm_list_append_call_method(asm_list, asm_list->bool_class_idx, -1);
                asm_list_append_st(asm_list, R12, i + 3, R13);
            }
        }

        li_instr->params[1].immediate.val = extra_temps + (extra_temps & 1);
    }

    asm_list_append_comment(asm_list, "return from constructor");

    // restore stack
    asm_list_append_mov(asm_list, R13, R12);
    asm_list_append_mov(asm_list, RSP, RBP);
    asm_list_append_pop(asm_list, RBP);
    // asm_list_append_pop(asm_list, RA);
    // asm_list_append_li(asm_list, R14, 2, ASMImmediateUnitsWord);
    // asm_list_append_arith(asm_list, ASM_OP_ADD, RSP, R14);
    asm_list_append_return(asm_list);
}

void asm_list_append_call_method(ASMList* asm_list, const int64_t class_idx, const int64_t method_idx)
{
    bool is_comparison = class_idx == INTERNAL_CLASS && method_idx <= INTERNAL_EQ_HANDLER;
    bool is_str_handler = class_idx == INTERNAL_CLASS && method_idx <= INTERNAL_STRCAT_HANDLER;
    if (is_str_handler)
    {

    }
    else if (is_comparison)
    {
        asm_list_append_push(asm_list, R12);
    }
    else
    {
        asm_list_append_push(asm_list, RBP);
        asm_list_append_push(asm_list, R12);
    }
    if (method_idx == -1) // Class constructor
    {
        asm_list_append(asm_list, (ASMInstr){
            .op = ASM_OP_LA,
            .params = {
                (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R14 },
                (ASMParam){ .type = ASM_PARAM_METHOD, .method = { .class_idx = class_idx, .method_idx = -1 } }
            }
        });
        asm_list_append(asm_list, (ASMInstr){
            .op = ASM_OP_CALL,
            .params = (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R14 }
        });
    }
    else
    {
        asm_list_append(asm_list, (ASMInstr){
            .op = ASM_OP_CALL,
            .params = (ASMParam){ .type = ASM_PARAM_METHOD, .method = { .class_idx = class_idx, .method_idx = method_idx } }
        });
    }

    if (is_str_handler)
    {

    }
    else if (is_comparison)
    {
        asm_list_append(asm_list, (ASMInstr){
            .op = ASM_OP_ADD,
            .params = {
                (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = RSP },
                (ASMParam){ .type = ASM_PARAM_IMMEDIATE, .immediate = { .val = 3, .units = ASMImmediateUnitsWord} }
            }
        });
        asm_list_append_pop(asm_list, RBP);
        asm_list_append_pop(asm_list, R12);
    }
    else
    {
        asm_list_append_pop(asm_list, R12);
        asm_list_append_pop(asm_list, RBP);
    }
}

void asm_from_tac_symbol(ASMList* asm_list, const TACSymbol symbol)
{
    switch (symbol.type)
    {
    case TAC_SYMBOL_TYPE_INTEGER:
        asm_list_append_call_method(asm_list, asm_list->int_class_idx, CONSTRUCTOR_METHOD);
        asm_list_append_li(asm_list, R14, symbol.integer, ASMImmediateUnitsBase);
        asm_list_append_st(asm_list, R13, 3, R14);
        break;
    case TAC_SYMBOL_TYPE_BOOL:
        asm_list_append_call_method(asm_list, asm_list->bool_class_idx, CONSTRUCTOR_METHOD);
        if (symbol.integer > 0)
        {
            asm_list_append_li(asm_list, R14, symbol.integer, ASMImmediateUnitsBase);
            asm_list_append_st(asm_list, R13, 3, R14);
        }
        break;
    case TAC_SYMBOL_TYPE_STRING:
        asm_list_append_call_method(asm_list, asm_list->string_class_idx, CONSTRUCTOR_METHOD);
        bh_str_buf label_buf = bh_str_buf_init(asm_list->string_allocator, 8);
        bh_str_buf_append_format(&label_buf, "string%i", asm_list->_string_counter++);
        bh_str label = (bh_str){ .buf = label_buf.buf, .len = label_buf.len };
        asm_list_append_error_str(asm_list, label, symbol.string.data);
        asm_list_append_la_label(asm_list, R14, label);
        // asm_list_append_la(asm_list, R14, INTERNAL_CUSTOM_STRINGS, asm_list->_string_counter++);
        asm_list_append_st(asm_list, R13, 3, R14);
        break;
    case TAC_SYMBOL_TYPE_SYMBOL:
        break;
    case TAC_SYMBOL_TYPE_VARIABLE:
        break;
    default:
        assert(0 && "Unhandled asm from tac symbol type");
        break;
    }
}

int64_t asm_from_tac_list(ASMList* asm_list, TACList tac_list)
{
    int64_t extra_symbols = 0;
    ClassNode curr_class_node = tac_list.class_list.class_nodes[tac_list.class_idx];
    ClassMethod curr_method = curr_class_node.methods[tac_list.method_idx];
    const bh_str class_name = curr_class_node.name;
    for (int i = 0; i < tac_list.count; i++)
    {
        const TACExpr expr = tac_list.items[i];

        switch (expr.operation)
        {
        case TAC_OP_ASSIGN:
        {
            asm_list_append_ld_tac_symbol(asm_list, curr_class_node, curr_method, R13, expr.rhs1);
            asm_list_append_st_tac_symbol(asm_list, curr_class_node, curr_method, expr.lhs);
            break;
        }
        case TAC_OP_PLUS:
        case TAC_OP_MINUS:
        case TAC_OP_TIMES:
        case TAC_OP_DIVIDE:
            asm_list_append_ld_tac_symbol(asm_list, curr_class_node, curr_method, R13, expr.rhs1);
            asm_list_append_ld_tac_symbol(asm_list, curr_class_node, curr_method, R14, expr.rhs2);
            asm_list_append_ld(asm_list, R13, R13, 3);
            asm_list_append_ld(asm_list, R14, R14, 3);
            if (expr.operation == TAC_OP_DIVIDE)
            {
                bh_str label = asm_list_create_label(asm_list);
                asm_list_append_bnz(asm_list, R14, label);
                asm_list_append_runtime_error(asm_list, expr.line_num, "division by zero");
                asm_list_append_label(asm_list, label);
            }
            asm_list_append(asm_list, (ASMInstr){
                .op = ASM_OP_ADD + (expr.operation - TAC_OP_PLUS),
                .params = {
                    (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R13 },
                    (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R14 },
                    (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R13 },
                }
            });
            asm_list_append_st_tac_symbol(asm_list, curr_class_node, curr_method, expr.lhs);
            asm_list_append_call_method(asm_list, asm_list->int_class_idx, -1);
            asm_list_append_ld_tac_symbol(asm_list, curr_class_node, curr_method, R14, expr.lhs);
            asm_list_append_st(asm_list, R13, 3, R14);
            asm_list_append_st_tac_symbol(asm_list, curr_class_node, curr_method, expr.lhs);
            break;
        case TAC_OP_LT:
        case TAC_OP_LTE:
        case TAC_OP_EQ:
            asm_list_append_ld(asm_list, R13, RBP, -0 - expr.rhs1.symbol);
            asm_list_append_ld(asm_list, R14, RBP, -0 - expr.rhs2.symbol);
            asm_list_append_push(asm_list, R13);
            asm_list_append_push(asm_list, R14);
            if (expr.operation == TAC_OP_LTE) asm_list_append_call_method(asm_list, INTERNAL_CLASS, INTERNAL_LE_HANDLER);
            if (expr.operation == TAC_OP_LT) asm_list_append_call_method(asm_list, INTERNAL_CLASS, INTERNAL_LT_HANDLER);
            if (expr.operation == TAC_OP_EQ) asm_list_append_call_method(asm_list, INTERNAL_CLASS, INTERNAL_EQ_HANDLER);
            asm_list_append_st_tac_symbol(asm_list, curr_class_node, curr_method, expr.lhs);
            break;
        case TAC_OP_INT:
            asm_list_append_comment(asm_list, "new Int");
            asm_from_tac_symbol(asm_list, expr.rhs1);
            asm_list_append_st_tac_symbol(asm_list, curr_class_node, curr_method, expr.lhs);
            break;
        case TAC_OP_STRING:
            asm_list_append_comment(asm_list, "new String");
            asm_from_tac_symbol(asm_list, expr.rhs1);
            asm_list_append_st_tac_symbol(asm_list, curr_class_node, curr_method, expr.lhs);
            break;
        case TAC_OP_BOOL:
            asm_list_append_comment(asm_list, "new Bool");
            asm_from_tac_symbol(asm_list, expr.rhs1);
            asm_list_append_st_tac_symbol(asm_list, curr_class_node, curr_method, expr.lhs);
            break;
        case TAC_OP_NOT:
        {
            bh_str label_str_1 = asm_list_create_label(asm_list);
            bh_str label_str_2 = asm_list_create_label(asm_list);
            bh_str label_str_3 = asm_list_create_label(asm_list);

            asm_list_append_ld(asm_list, R13, RBP, -0 - expr.rhs1.symbol);
            asm_list_append_ld(asm_list, R13, R13, 3);
            asm_list_append_bnz(asm_list, R13, label_str_1);

            asm_list_append_label(asm_list, label_str_2);
            asm_list_append_comment(asm_list, "false branch");
            asm_list_append_call_method(asm_list, asm_list->bool_class_idx, -1);
            asm_list_append_li(asm_list, R14, 1, ASMImmediateUnitsBase);
            asm_list_append_st(asm_list, R13, 3, R14);
            asm_list_append_jmp(asm_list, label_str_3);

            asm_list_append_label(asm_list, label_str_1);
            asm_list_append_comment(asm_list, "true branch");
            asm_list_append_call_method(asm_list, asm_list->bool_class_idx, -1);

            asm_list_append_label(asm_list, label_str_3);
            asm_list_append_st_tac_symbol(asm_list, curr_class_node, curr_method, expr.lhs);
            break;
        }
        case TAC_OP_NEG:
            asm_list_append_call_method(asm_list, asm_list->int_class_idx, -1);
            asm_list_append_push(asm_list, R13);
            asm_list_append_ld(asm_list, R14, R13, 3);
            asm_list_append_ld_tac_symbol(asm_list, curr_class_node, curr_method, R13, expr.rhs1);
            asm_list_append_ld(asm_list, R13, R13, 3);
            asm_list_append_arith(asm_list, ASM_OP_SUB, R14, R13);
            asm_list_append_pop(asm_list, R13);
            asm_list_append_st(asm_list, R13, 3, R14);
            asm_list_append_st_tac_symbol(asm_list, curr_class_node, curr_method, expr.lhs);
            break;
        case TAC_OP_NEW:
            {
                if (bh_str_equal_lit(expr.rhs1.variable.data, "SELF_TYPE"))
                {
                    asm_list_append_push(asm_list, RBP);
                    asm_list_append_push(asm_list, R12);
                    asm_list_append_ld(asm_list, R14, R12, 2);
                    asm_list_append_ld(asm_list, R14, R14, 1);
                    asm_list_append_call(asm_list, R14);
                    asm_list_append_pop(asm_list, R12);
                    asm_list_append_pop(asm_list, RBP);
                }
                else
                {
                    int64_t class_idx = -1;
                    for (int64_t j = 0; j < asm_list->class_list->class_count; j++)
                    {
                        if (bh_str_equal(asm_list->class_list->class_nodes[j].name, expr.rhs1.variable.data))
                        {
                            class_idx = j;
                        }
                    }
                    assert(class_idx != -1 && "TAC new expression did not match class");
                    asm_list_append_call_method(asm_list, class_idx, CONSTRUCTOR_METHOD);
                }
                asm_list_append_st_tac_symbol(asm_list, curr_class_node, curr_method, expr.lhs);
            }
            break;
        case TAC_OP_DEFAULT:
        {
            if (bh_str_equal_lit(expr.rhs1.variable.data, "Int"))
            {
                asm_list_append_comment(asm_list, "default constructor");
                asm_list_append_call_method(asm_list, asm_list->int_class_idx, -1);
                asm_list_append_st_tac_symbol(asm_list, curr_class_node, curr_method, expr.lhs);
            }
            else if (bh_str_equal_lit(expr.rhs1.variable.data, "String"))
            {
                asm_list_append_comment(asm_list, "default constructor");
                asm_list_append_call_method(asm_list, asm_list->string_class_idx, -1);
                asm_list_append_st_tac_symbol(asm_list, curr_class_node, curr_method, expr.lhs);
            }
            else if (bh_str_equal_lit(expr.rhs1.variable.data, "Bool"))
            {
                asm_list_append_comment(asm_list, "default constructor");
                asm_list_append_call_method(asm_list, asm_list->bool_class_idx, -1);
                asm_list_append_st_tac_symbol(asm_list, curr_class_node, curr_method, expr.lhs);
            }
            else
            {
                asm_list_append_comment(asm_list, "default constructor is void");
                asm_list_append_li(asm_list, R13, 0, ASMImmediateUnitsBase);
                asm_list_append_st_tac_symbol(asm_list, curr_class_node, curr_method, expr.lhs);
            }
            break;
        }
        case TAC_OP_ISVOID:
        {
            bh_str label_str_1 = asm_list_create_label(asm_list);
            bh_str label_str_2 = asm_list_create_label(asm_list);
            bh_str label_str_3 = asm_list_create_label(asm_list);

            asm_list_append_ld_tac_symbol(asm_list, curr_class_node, curr_method, R13, expr.rhs1);
            asm_list_append_bz(asm_list, R13, label_str_1);

            asm_list_append_label(asm_list, label_str_2);
            asm_list_append_comment(asm_list, "false branch");
            asm_list_append_call_method(asm_list, asm_list->bool_class_idx, -1);
            asm_list_append_jmp(asm_list, label_str_3);

            asm_list_append_label(asm_list, label_str_1);
            asm_list_append_comment(asm_list, "true branch");
            asm_list_append_call_method(asm_list, asm_list->bool_class_idx, -1);
            asm_list_append_li(asm_list, R14, 1, ASMImmediateUnitsBase);
            asm_list_append_st(asm_list, R13, 3, R14);

            asm_list_append_label(asm_list, label_str_3);
            asm_list_append_st_tac_symbol(asm_list, curr_class_node, curr_method, expr.lhs);
            break;
        }
        case TAC_OP_IGNORE:
            switch (expr.rhs1.integer)
            {
                case -1:
                    asm_list_append_push(asm_list, R12);
                    asm_list_append_push(asm_list, RBP);
                    break;
                default:
                    assert(0 && "Unhandled tac ignore");
                    break;
            }
            break;
        case TAC_OP_PHI:
            assert(0 && "Cannot generate asm for phi nodes");
            break;
        case TAC_OP_CALL:
        {
            int64_t is_self_dispatch = expr.args[expr.arg_count - 1].symbol == 0;
            // Check for void if not self dispatch
            if (!is_self_dispatch)
            {
                bh_str success_label = asm_list_create_label(asm_list);
                asm_list_append_bnz(asm_list, R13, success_label);
                asm_list_append_runtime_error(asm_list, expr.line_num, "dispatch on void");
                asm_list_append_label(asm_list, success_label);
            }

            // Push all the params onto the stack
            for (int j = 0; j < expr.arg_count; j++)
            {
                if (j == expr.arg_count - 1 && is_self_dispatch)
                {
                    asm_list_append_push(asm_list, R12);
                }
                else
                {
                    asm_list_append_ld_tac_symbol(asm_list, curr_class_node, curr_method, R13, expr.args[j]);
                    asm_list_append_push(asm_list, R13);
                }
            }

            // Perform the call
            if (is_self_dispatch)
            {
                asm_list_append_ld(asm_list, R14, R12, 2);
            }
            else if (expr.rhs1.method.class_idx < 0) // Static dispatch
            {
                asm_list_append_la(asm_list, R14, -expr.rhs1.method.class_idx - 1, -2);
            }
            else
            {
                asm_list_append_ld(asm_list, R14, R13, 2);
            }
            asm_list_append_ld(asm_list, R14, R14, expr.rhs1.method.method_idx + 2);
            asm_list_append_call(asm_list, R14);
            asm_list_append(asm_list, (ASMInstr){
                .op = ASM_OP_ADD,
                .params = {
                    (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = RSP },
                    (ASMParam){ .type = ASM_PARAM_IMMEDIATE, .immediate = { .val = expr.arg_count, .units = ASMImmediateUnitsWord }}
                }
            });
            asm_list_append_pop(asm_list, RBP);
            asm_list_append_pop(asm_list, R12);
            asm_list_append_st_tac_symbol(asm_list, curr_class_node, curr_method, expr.lhs);
            break;
        }
        case TAC_OP_JMP:
        case TAC_OP_LABEL:
        {
            bh_str_buf str_buf = bh_str_buf_init(asm_list->string_allocator, class_name.len + tac_list.method_name.len + 6);
            bh_str_buf_append(&str_buf, class_name);
            bh_str_buf_append_lit(&str_buf, "_");
            bh_str_buf_append(&str_buf, tac_list.method_name);
            bh_str_buf_append_format(&str_buf, "_%i", expr.rhs1.integer);
            if (expr.operation == TAC_OP_JMP)
            {
                asm_list_append_jmp(asm_list, (bh_str){ .buf = str_buf.buf, .len = str_buf.len });
            }
            else
            {
                asm_list_append_label(asm_list, (bh_str){ .buf = str_buf.buf, .len = str_buf.len });
            }
            break;
        }
        case TAC_OP_RETURN:
            asm_list_append_ld_tac_symbol(asm_list, curr_class_node, curr_method, R13, expr.rhs1);
            break;
        case TAC_OP_COMMENT:
            asm_list_append_comment_str(asm_list, expr.rhs1.string.data);
            break;
        case TAC_OP_BT:
        {
            bh_str_buf str_buf = bh_str_buf_init(asm_list->string_allocator, class_name.len + tac_list.method_name.len + 6);
            bh_str_buf_append(&str_buf, class_name);
            bh_str_buf_append_lit(&str_buf, "_");
            bh_str_buf_append(&str_buf, tac_list.method_name);
            bh_str_buf_append_format(&str_buf, "_%i", expr.rhs2.integer);
            asm_list_append_ld_tac_symbol(asm_list, curr_class_node, curr_method, R13, expr.rhs1);
            asm_list_append_ld(asm_list, R13, R13, 3);
            asm_list_append_bnz(asm_list, R13, (bh_str){ .buf = str_buf.buf, .len = str_buf.len });
            break;
        }
        case TAC_OP_IS_CLASS:
            // NOTE: This relies on the fact that an isclass op will always be succeeded by a bt op
            asm_list_append_ld(asm_list, R13, RBP, -0 - expr.rhs1.symbol);
            asm_list_append_ld(asm_list, R13, R13, 0);
            asm_list_append_li(asm_list, R14, expr.rhs2.integer, ASMImmediateUnitsBase);

            i++; // Now we handle the bt instruction

            bh_str_buf str_buf = bh_str_buf_init(asm_list->string_allocator, class_name.len + tac_list.method_name.len + 6);
            bh_str_buf_append(&str_buf, class_name);
            bh_str_buf_append_lit(&str_buf, "_");
            bh_str_buf_append(&str_buf, tac_list.method_name);
            bh_str_buf_append_format(&str_buf, "_%i", tac_list.items[i].rhs2.integer);
            asm_from_tac_symbol(asm_list, expr.rhs1);
            asm_list_append_beq(asm_list, R14, R13, (bh_str){ .buf = str_buf.buf, .len = str_buf.len });
            break;
        case TAC_OP_RUNTIME_ERROR:
            asm_list_append_runtime_error_bh_str(asm_list, expr.line_num, expr.rhs1.string.data);
            break;
        default:
            assert(0 && "Trying to convert unhandled tac expression to assembly");
            return 0;
        }
    }

    return extra_symbols;
}

void asm_from_method(ASMList* asm_list, const TACList tac_list)
{
    const bh_str class_name = tac_list.class_list.class_nodes[tac_list.class_idx].name;

    // Construct method name
    int64_t label_len = class_name.len + tac_list.method_name.len + 1;
    char* label_buf = bh_alloc(asm_list->string_allocator, label_len + 4);
    strncpy(label_buf, class_name.buf, class_name.len);
    label_buf[class_name.len] = '.';
    strncpy(label_buf + class_name.len + 1, tac_list.method_name.buf, tac_list.method_name.len);
    strncpy(label_buf + class_name.len + tac_list.method_name.len + 1, ".end", 4);
    asm_list_append_label(asm_list, (bh_str){ .buf = label_buf, .len = label_len });
    asm_list_append_comment(asm_list, "method definition");

    // Setup stack and stuff
    // asm_list_append_push(asm_list, RA);
    asm_list_append_push(asm_list, RBP);
    asm_list_append_mov(asm_list, RBP, RSP);
    asm_list_append_ld(asm_list, R12, RBP, 2);
    asm_list_append_comment(asm_list, "stack room for temporaries");
    int64_t temp_count = tac_list._curr_symbol + (tac_list._curr_symbol & 1);
    ASMInstr* temp_space_instr = asm_list_append_li(asm_list, R14, temp_count, ASMImmediateUnitsWord);
    asm_list_append_arith(asm_list, ASM_OP_SUB, RSP, R14);

    asm_list_append_comment(asm_list, "method body begins");
    if (bh_str_equal_lit(class_name, "Object"))
    {
        if (bh_str_equal_lit(tac_list.method_name, "abort"))
        {
            asm_list_append_la(asm_list, R13, INTERNAL_CLASS, INTERNAL_ABORT_STR); // Fix this jawn
            asm_list_append_align_sp(asm_list);
            asm_list_append_syscall(asm_list, asm_list->io_class_idx, 6);
            asm_list_append_align_sp(asm_list);
            asm_list_append_syscall(asm_list, -1, 0); // Exit
        }
        if (bh_str_equal_lit(tac_list.method_name, "copy"))
        {
            bh_str label_str_1 = asm_list_create_label(asm_list);
            bh_str label_str_2 = asm_list_create_label(asm_list);

            asm_list_append_ld(asm_list, R14, R12, 1);
            asm_list_append_align_sp(asm_list);
            asm_list_append(asm_list, (ASMInstr){
                .op = ASM_OP_ALLOC,
                .params = {
                    (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R13 },
                    (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R14 },
                }
            });
            asm_list_append_push(asm_list, R13);

            asm_list_append_label(asm_list, label_str_1);
            asm_list_append_bz(asm_list, R14, label_str_2);
            asm_list_append_ld(asm_list, R15, R12, 0);
            asm_list_append_st(asm_list, R13, 0, R15);
            asm_list_append_li(asm_list, R15, 1, ASMImmediateUnitsWord);
            asm_list_append_arith(asm_list, ASM_OP_ADD, R12, R15);
            asm_list_append_arith(asm_list, ASM_OP_ADD, R13, R15);
            asm_list_append_li(asm_list, R15, 1, ASMImmediateUnitsBase);
            asm_list_append_arith(asm_list, ASM_OP_SUB, R14, R15);
            asm_list_append_jmp(asm_list, label_str_1);

            asm_list_append_label(asm_list, label_str_2);
            asm_list_append_pop(asm_list, R13);
        }
        if (bh_str_equal_lit(tac_list.method_name, "type_name"))
        {
            asm_list_append_call_method(asm_list, asm_list->string_class_idx, CONSTRUCTOR_METHOD);
            asm_list_append_ld(asm_list, R14, R12, 2);
            asm_list_append_ld(asm_list, R14, R14, 0);
            asm_list_append_st(asm_list, R13, 3, R14);
        }
    }
    else if (bh_str_equal_lit(class_name, "IO"))
    {
        if (bh_str_equal_lit(tac_list.method_name, "in_int"))
        {
            asm_list_append_call_method(asm_list, asm_list->int_class_idx, CONSTRUCTOR_METHOD);
            asm_list_append_mov(asm_list, R14, R13);
            asm_list_append_syscall(asm_list, asm_list->io_class_idx, 3);
            asm_list_append_st(asm_list, R14, 3, R13);
            asm_list_append_mov(asm_list, R13, R14);
        }
        if (bh_str_equal_lit(tac_list.method_name, "in_string"))
        {
            asm_list_append_call_method(asm_list, asm_list->string_class_idx, CONSTRUCTOR_METHOD);
            asm_list_append_mov(asm_list, R14, R13);
            asm_list_append_align_sp(asm_list);
            asm_list_append_syscall(asm_list, asm_list->io_class_idx, 4);
            asm_list_append_st(asm_list, R14, 3, R13);
            asm_list_append_mov(asm_list, R13, R14);
        }
        if (bh_str_equal_lit(tac_list.method_name, "out_int"))
        {
            asm_list_append_ld(asm_list, R14, RBP, 3);
            asm_list_append_ld(asm_list, R13, R14, 3);
            asm_list_append_align_sp(asm_list);
            asm_list_append_syscall(asm_list, asm_list->io_class_idx, 5);
            asm_list_append_mov(asm_list, R13, R12);
        }
        if (bh_str_equal_lit(tac_list.method_name, "out_string"))
        {
            asm_list_append_ld(asm_list, R14, RBP, 3);
            asm_list_append_ld(asm_list, R13, R14, 3);
            asm_list_append_align_sp(asm_list);
            asm_list_append_syscall(asm_list, asm_list->io_class_idx, 6);
            asm_list_append_mov(asm_list, R13, R12);
        }
    }
    else if (bh_str_equal_lit(class_name, "String"))
    {
        if (bh_str_equal_lit(tac_list.method_name, "concat"))
        {
            asm_list_append_call_method(asm_list, asm_list->string_class_idx, CONSTRUCTOR_METHOD);
            asm_list_append_mov(asm_list, R15, R13);
            asm_list_append_ld(asm_list, R14, RBP, 3);
            asm_list_append_ld(asm_list, R14, R14, 3);
            asm_list_append_ld(asm_list, R13, R12, 3);
            asm_list_append_mov(asm_list, RDI, R13);
            asm_list_append_mov(asm_list, RSI, R14);
            asm_list_append_align_sp(asm_list);
            asm_list_append_call_method(asm_list, INTERNAL_CLASS, INTERNAL_STRCAT_HANDLER);
            asm_list_append_mov(asm_list, R13, RAX);
            asm_list_append_st(asm_list, R15, 3, R13);
            asm_list_append_mov(asm_list, R13, R15);
        }
        if (bh_str_equal_lit(tac_list.method_name, "length"))
        {
            asm_list_append_call_method(asm_list, asm_list->int_class_idx, CONSTRUCTOR_METHOD);
            asm_list_append_mov(asm_list, R14, R13);
            asm_list_append_ld(asm_list, R13, R12, 3);
            asm_list_append_mov(asm_list, RDI, R13);
            asm_list_append_li(asm_list, RAX, 0, ASMImmediateUnitsBase);
            asm_list_append_align_sp(asm_list);
            asm_list_append_call_method(asm_list, INTERNAL_CLASS, INTERNAL_STRLEN_HANDLER);
            asm_list_append_mov(asm_list, R13, RAX);
            asm_list_append_st(asm_list, R14, 3, R13);
            asm_list_append_mov(asm_list, R13, R14);
        }
        if (bh_str_equal_lit(tac_list.method_name, "substr"))
        {
            bh_str label_str = asm_list_create_label(asm_list);

            asm_list_append_call_method(asm_list, asm_list->string_class_idx, CONSTRUCTOR_METHOD);
            asm_list_append_mov(asm_list, R15, R13);
            asm_list_append_ld(asm_list, R14, RBP, 3);
            asm_list_append_ld(asm_list, R14, R14, 3);
            asm_list_append_ld(asm_list, R13, RBP, 4);
            asm_list_append_ld(asm_list, R13, R13, 3);
            asm_list_append_ld(asm_list, R12, R12, 3);
            asm_list_append_mov(asm_list, RDI, R12);
            asm_list_append_mov(asm_list, RSI, R13);
            asm_list_append_mov(asm_list, RDX, R14);
            asm_list_append_align_sp(asm_list);
            asm_list_append_call_method(asm_list, INTERNAL_CLASS, INTERNAL_SUBSTR_HANDLER);
            asm_list_append_mov(asm_list, R13, RAX);
            asm_list_append_bnz(asm_list, R13, label_str);
            asm_list_append_la(asm_list, R13, INTERNAL_STRINGS, INTERNAL_SUBSTR_RANGE_STR);
            asm_list_append_align_sp(asm_list);
            asm_list_append_syscall(asm_list, asm_list->io_class_idx, 6);
            asm_list_append_li(asm_list, RDI, 0, ASMImmediateUnitsBase);
            asm_list_append_align_sp(asm_list);
            asm_list_append_syscall(asm_list, INTERNAL_CLASS, 0); // exit

            asm_list_append_label(asm_list, label_str);
            asm_list_append_st(asm_list, R15, 3, R13);
            asm_list_append_mov(asm_list, R13, R15);
        }
    }
    else
    {
        int64_t extra_symbols = asm_from_tac_list(asm_list, tac_list);
        if (extra_symbols > 0)
        {
            temp_count += extra_symbols;
            temp_count = temp_count + (temp_count & 1);
        }
        temp_space_instr->params[1].immediate.val = temp_count;
    }

    asm_list_append_label(asm_list, (bh_str){ .buf = label_buf, .len = label_len + 4 });
    asm_list_append_mov(asm_list, RSP, RBP);
    asm_list_append_pop(asm_list, RBP);
    asm_list_append_return(asm_list);

    asm_list_append_comment(asm_list, ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"); // Spacer
}

#pragma endregion

#pragma region Built in helpers

void builtin_append_string_helpers(bh_str_buf* buf)
{
    bh_str file_text = read_file_text("./string_helpers.txt");
    bh_str_buf_append(buf, file_text);

    bh_str alloc_text = read_file_text("./coolalloc.txt");
    bh_str_buf_append(buf, alloc_text);
}

void builtin_append_string_constants(ASMList* asm_list)
{
    asm_list_append_comment(asm_list, "global string constants");
    asm_list_append_label(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, "the_empty_string"));
    asm_list_append_string_constant(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, ""));
    asm_list_append_label(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, "string_abort"));
    asm_list_append_string_constant(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, "abort\\n"));
    asm_list_append_label(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, "percent.d"));
    asm_list_append_string_constant(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, "%ld"));
    asm_list_append_label(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, "percent.ld"));
    asm_list_append_string_constant(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, " %ld"));
    asm_list_append_label(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, "substr_out_of_range"));
    asm_list_append_string_constant(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, "ERROR: 0: Exception: String.substr out of range\\n"));
    for (int i = 0; i < asm_list->class_list->class_count; i++)
    {
        const ClassNode class_node = asm_list->class_list->class_nodes[i];
        char* buf = bh_alloc(asm_list->string_allocator, class_node.name.len + 5);
        strncpy(buf, class_node.name.buf, class_node.name.len);
        strncpy(buf + class_node.name.len, "_name", 5);
        bh_str label = (bh_str){ .buf = buf, .len = class_node.name.len + 5 };

        asm_list_append_label(asm_list, label);
        asm_list_append_string_constant(asm_list, class_node.name);
    }
    for (int i = 0; i < asm_list->error_str_count; i++)
    {
        asm_list_append_label(asm_list, asm_list->error_strs[i].label);
        asm_list_append_string_constant(asm_list, asm_list->error_strs[i].message);
    }
}

// I used the reference compiler's output for this code
void builtin_append_start(ASMList* asm_list)
{
    int64_t main_ctor_idx = -1;
    int64_t main_class_idx = -1;
    int64_t main_method_idx = -1;
    for (int i = 0; i < asm_list->class_list->class_count; i++)
    {
        ClassNode class_node = asm_list->class_list->class_nodes[i];
        if (bh_str_equal_lit(class_node.name, "Main"))
        {
            main_ctor_idx = i;
            for (int j = 0; j < class_node.method_count; j++)
            {
                if (bh_str_equal_lit(class_node.methods[j].name, "main"))
                {
                    for (int k = 0; k < asm_list->class_list->class_count; k++)
                    {
                        if (bh_str_equal(asm_list->class_list->class_nodes[k].name, class_node.methods[j].inherited_from))
                        {
                            main_class_idx = k;
                            break;
                        }
                    }
                    main_method_idx = j;
                    break;
                }
            }
        }
        if (main_class_idx > -1) break;
    }

    char* start_buf = bh_alloc(asm_list->string_allocator, 5);
    strncpy(start_buf, "start", 5);
    bh_str start_str = (bh_str){ .buf = start_buf, .len = 5 };

    asm_list_append_comment(asm_list, "program begins here");
    asm_list_append_label(asm_list, start_str);
    asm_list_append_syscall(asm_list, INTERNAL_CLASS, INTERNAL_COOLALLOC_INIT_HANDLER);
    asm_list_append_la(asm_list, R14, main_ctor_idx, -1);
    asm_list_append_push(asm_list, RBP);
    asm_list_append_call(asm_list, R14);
    asm_list_append_push(asm_list, RBP);
    asm_list_append_push(asm_list, R13);
    asm_list_append_la(asm_list, R14, main_class_idx, main_method_idx);
    asm_list_append_call(asm_list, R14);
    asm_list_append_syscall(asm_list, -1, 0);
}

#pragma endregion

#pragma region Display COOL-ASM

void display_asm_param_internal(bh_str_buf* str_buf, const ClassNodeList class_list, const ASMParam param, const bool force_offset)
{
    if (param.type != ASM_PARAM_LABEL && param.type != ASM_PARAM_COMMENT)
    {
        bh_str_buf_append_lit(str_buf, " ");
    }
    switch (param.type)
    {
    case ASM_PARAM_NULL:
        break;
    case ASM_PARAM_IMMEDIATE:
        bh_str_buf_append_format(str_buf, "$%i", param.immediate.val);
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
        case RBP: bh_str_buf_append_lit(str_buf, "fp"); break;
        case RSP: bh_str_buf_append_lit(str_buf, "sp"); break;
        case R8: bh_str_buf_append_lit(str_buf, "r8"); break;
        case R9: bh_str_buf_append_lit(str_buf, "r9"); break;
        case R10: bh_str_buf_append_lit(str_buf, "r10"); break;
        case R11: bh_str_buf_append_lit(str_buf, "r11"); break;
        case R12: bh_str_buf_append_lit(str_buf, "r0"); break;
        case R13: bh_str_buf_append_lit(str_buf, "r1"); break;
        case R14: bh_str_buf_append_lit(str_buf, "r2"); break;
        case R15: bh_str_buf_append_lit(str_buf, "r3"); break;
        case RA: bh_str_buf_append_lit(str_buf, "ra"); break;
        }
        if (param.reg.offset || force_offset)
        {
            int64_t offset = param.reg.offset;
            // if (param.reg.name == RBP) offset += 1; // MAKES COOL-ASM WORK
            bh_str_buf_append_format(str_buf, "[%i]", offset);
        }
        break;
    case ASM_PARAM_METHOD:
        if (param.method.class_idx == INTERNAL_CLASS) // Builtin class handler
        {
            switch (param.method.method_idx)
            {
            case 0:
                bh_str_buf_append_lit(str_buf, "exit");
                break;
            case -2:
                bh_str_buf_append_lit(str_buf, "string_abort");
                break;
            case INTERNAL_LE_HANDLER:
                bh_str_buf_append_lit(str_buf, "le_handler");
                break;
            case INTERNAL_EQ_HANDLER:
                bh_str_buf_append_lit(str_buf, "eq_handler");
                break;
            case INTERNAL_LT_HANDLER:
                bh_str_buf_append_lit(str_buf, "lt_handler");
                break;
            default:
                assert(0 && "Unhandled internal method");
                break;
            }
        }
        else if (param.method.class_idx == INTERNAL_STRINGS)
        {
            switch (param.method.method_idx)
            {
            case INTERNAL_ABORT_STR:
                bh_str_buf_append_lit(str_buf, "string_abort");
                break;
            case INTERNAL_SUBSTR_RANGE_STR:
                bh_str_buf_append_lit(str_buf, "substr_out_of_range");
                break;
            default:
                assert(0 && "Unhandled internal string");
                break;
            }
        }
        else if (param.method.class_idx == INTERNAL_CUSTOM_STRINGS)
        {
            bh_str_buf_append_format(str_buf, "string%i", param.method.method_idx);
        }
        else
        {
            bh_str_buf_append(str_buf, class_list.class_nodes[param.method.class_idx].name);
            if (param.method.method_idx == -2) // vtable reference
            {
                bh_str_buf_append_lit(str_buf, "..vtable");
            }
            else if (param.method.method_idx == -1) // Constructor call
            {
                bh_str_buf_append_lit(str_buf, "..new");
            }
            else
            {
                bh_str_buf_append_lit(str_buf, ".");
                const bh_str method_name = class_list.class_nodes[param.method.class_idx].methods[param.method.method_idx].name;
                bh_str_buf_append(str_buf, method_name);
            }
        }
        break;
    case ASM_PARAM_LABEL:
        bh_str_buf_append(str_buf, param.label);
        break;
    case ASM_PARAM_COMMENT:
        bh_str_buf_append_lit(str_buf, ";; ");
        bh_str_buf_append(str_buf, param.comment);
        break;
    case ASM_PARAM_CONSTANT:
        bh_str_buf_append(str_buf, param.constant);
        break;
    case ASM_PARAM_STRING_LABEL:
        bh_str_buf_append_lit(str_buf, "$");
        bh_str_buf_append(str_buf, param.constant);
        break;
    case ASM_PARAM_STRING_CONSTANT:
        bh_str_buf_append_lit(str_buf, "\"");
        bh_str_buf_append(str_buf, param.constant);
        bh_str_buf_append_lit(str_buf, "\"");
        break;
    }
}

void display_asm_param(bh_str_buf* str_buf, const ClassNodeList class_list, const ASMParam param)
{
    display_asm_param_internal(str_buf, class_list, param, false);
}

void display_asm_list(bh_str_buf* str_buf, const ASMList asm_list)
{
    const ClassNodeList class_list = *asm_list.class_list;
    for (int i = 0; i < asm_list.instruction_count; i++)
    {
        const ASMInstr instr = asm_list.instructions[i];
        switch (instr.op)
        {
        case ASM_OP_NULL:
            bh_str_buf_append_lit(str_buf, "NULL");
            break;
        case ASM_OP_JMP:
            bh_str_buf_append_lit(str_buf, "jmp ");
            display_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_COMMENT:
            display_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_LABEL:
            display_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, ":");
            break;
        case ASM_OP_CONSTANT:
            bh_str_buf_append_lit(str_buf, "constant");
            display_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_PUSH:
            bh_str_buf_append_lit(str_buf, "push");
            display_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_POP:
            bh_str_buf_append_lit(str_buf, "pop");
            display_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_MOV:
            bh_str_buf_append_lit(str_buf, "mov");
            display_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, " <-");
            display_asm_param(str_buf, class_list, instr.params[1]);
            break;
        case ASM_OP_LI:
            bh_str_buf_append_lit(str_buf, "li");
            display_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, " <-");
            display_asm_param(str_buf, class_list, instr.params[1]);
            break;
        case ASM_OP_LA:
            bh_str_buf_append_lit(str_buf, "la");
            display_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, " <-");
            display_asm_param(str_buf, class_list, instr.params[1]);
            break;
        case ASM_OP_LD:
            bh_str_buf_append_lit(str_buf, "ld");
            display_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, " <-");
            display_asm_param_internal(str_buf, class_list, instr.params[1], true);
            break;
        case ASM_OP_SYSCALL:
            bh_str_buf_append_lit(str_buf, "sys");
        case ASM_OP_CALL:
            bh_str_buf_append_lit(str_buf, "call");
            display_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_ST:
            bh_str_buf_append_lit(str_buf, "st");
            display_asm_param_internal(str_buf, class_list, instr.params[0], true);
            bh_str_buf_append_lit(str_buf, " <-");
            display_asm_param(str_buf, class_list, instr.params[1]);
            break;
        case ASM_OP_BEQ:
            bh_str_buf_append_lit(str_buf, "beq");
            display_asm_param(str_buf, class_list, instr.params[0]);
            display_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, " ");
            display_asm_param(str_buf, class_list, instr.params[2]);
            break;
        case ASM_OP_BLT:
            bh_str_buf_append_lit(str_buf, "blt");
            display_asm_param(str_buf, class_list, instr.params[0]);
            display_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, " ");
            display_asm_param(str_buf, class_list, instr.params[2]);
            break;
        case ASM_OP_BLE:
            bh_str_buf_append_lit(str_buf, "ble");
            display_asm_param(str_buf, class_list, instr.params[0]);
            display_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, " ");
            display_asm_param(str_buf, class_list, instr.params[2]);
            break;
        case ASM_OP_BNZ:
            bh_str_buf_append_lit(str_buf, "bnz");
            display_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, " ");
            display_asm_param(str_buf, class_list, instr.params[1]);
            break;
        case ASM_OP_ADD:
            bh_str_buf_append_lit(str_buf, "add");
            display_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, " <-");
            display_asm_param(str_buf, class_list, instr.params[0]);
            display_asm_param(str_buf, class_list, instr.params[1]);
            break;
        case ASM_OP_SUB:
            bh_str_buf_append_lit(str_buf, "sub");
            display_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, " <-");
            display_asm_param(str_buf, class_list, instr.params[0]);
            display_asm_param(str_buf, class_list, instr.params[1]);
            break;
        case ASM_OP_MUL:
            bh_str_buf_append_lit(str_buf, "mul");
            display_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, " <-");
            display_asm_param(str_buf, class_list, instr.params[0]);
            display_asm_param(str_buf, class_list, instr.params[1]);
            break;
        case ASM_OP_DIV:
            bh_str_buf_append_lit(str_buf, "div");
            display_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, " <-");
            display_asm_param(str_buf, class_list, instr.params[0]);
            display_asm_param(str_buf, class_list, instr.params[1]);
            break;
        case ASM_OP_AND:
            bh_str_buf_append_lit(str_buf, "and");
            display_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, " <-");
            display_asm_param(str_buf, class_list, instr.params[1]);
            break;
        case ASM_OP_ALLOC:
            bh_str_buf_append_lit(str_buf, "alloc");
            display_asm_param(str_buf, class_list, instr.params[0]);
            display_asm_param(str_buf, class_list, instr.params[1]);
            break;
        case ASM_OP_RETURN:
            bh_str_buf_append_lit(str_buf, "return");
            break;
        default:
            assert(0 && "Unhandled asm instruction in display");
            break;
        }
        bh_str_buf_append_lit(str_buf, "\n");
    }
}

#pragma endregion

#pragma region Display x86

void x86_asm_param_internal(bh_str_buf* str_buf, const ClassNodeList class_list, const ASMParam param, const bool force_offset)
{
    if (param.type != ASM_PARAM_LABEL && param.type != ASM_PARAM_COMMENT)
    {
        bh_str_buf_append_lit(str_buf, " ");
    }
    switch (param.type)
    {
    case ASM_PARAM_NULL:
        break;
    case ASM_PARAM_IMMEDIATE:
    {
        int64_t num = param.immediate.val;
        if (param.immediate.units == ASMImmediateUnitsWord) num *= 8;
        bh_str_buf_append_format(str_buf, "$%i", num);
        break;
    }
    case ASM_PARAM_REGISTER:
        if (param.reg.offset || force_offset)
        {
            int64_t offset = param.reg.offset * 8;
            bh_str_buf_append_format(str_buf, "%i(", offset);
        }
        switch (param.reg.name)
        {
        case INVALID_REGISTER: bh_str_buf_append_lit(str_buf, "RINVALID"); break;
        case RAX: bh_str_buf_append_lit(str_buf, "%rax"); break;
        case RBX: bh_str_buf_append_lit(str_buf, "%rbx"); break;
        case RCX: bh_str_buf_append_lit(str_buf, "%rcx"); break;
        case RDX: bh_str_buf_append_lit(str_buf, "%rdx"); break;
        case RSI: bh_str_buf_append_lit(str_buf, "%rsi"); break;
        case RDI: bh_str_buf_append_lit(str_buf, "%rdi"); break;
        case RBP: bh_str_buf_append_lit(str_buf, "%rbp"); break;
        case RSP: bh_str_buf_append_lit(str_buf, "%rsp"); break;
        case R8: bh_str_buf_append_lit(str_buf, "%r8"); break;
        case R9: bh_str_buf_append_lit(str_buf, "%r9"); break;
        case R10: bh_str_buf_append_lit(str_buf, "%r10"); break;
        case R11: bh_str_buf_append_lit(str_buf, "%r11"); break;
        case R12: bh_str_buf_append_lit(str_buf, "%r12"); break;
        case R13: bh_str_buf_append_lit(str_buf, "%r13"); break;
        case R14: bh_str_buf_append_lit(str_buf, "%r14"); break;
        case R15: bh_str_buf_append_lit(str_buf, "%r15"); break;
        case RA: bh_str_buf_append_lit(str_buf, "ra"); break;
        }
        if (param.reg.offset || force_offset)
        {
            bh_str_buf_append_format(str_buf, ")", param.reg.offset);
        }
        break;
    case ASM_PARAM_METHOD:
        if (param.method.class_idx == INTERNAL_CLASS) // Builtin class handler
        {
            switch (param.method.method_idx)
            {
            case 0:
                bh_str_buf_append_lit(str_buf, "movl $0, %edi\ncall exit");
                break;
            case -2:
                bh_str_buf_append_lit(str_buf, "$string_abort");
                break;
            case INTERNAL_EQ_HANDLER:
                bh_str_buf_append_lit(str_buf, "eq_handler");
                break;
            case INTERNAL_LE_HANDLER:
                bh_str_buf_append_lit(str_buf, "le_handler");
                break;
            case INTERNAL_LT_HANDLER:
                bh_str_buf_append_lit(str_buf, "lt_handler");
                break;
            case INTERNAL_STRCAT_HANDLER:
                bh_str_buf_append_lit(str_buf, "coolstrcat");
                break;
            case INTERNAL_STRLEN_HANDLER:
                bh_str_buf_append_lit(str_buf, "coolstrlen");
                break;
            case INTERNAL_SUBSTR_HANDLER:
                bh_str_buf_append_lit(str_buf, "coolsubstr");
                break;
            case INTERNAL_COOLALLOC_INIT_HANDLER:
                bh_str_buf_append_lit(str_buf, "call coolalloc_init");
                break;
            default:
                assert(0 && "Unhandled internal method");
                break;
            }
        }
        else if (param.method.class_idx == INTERNAL_STRINGS)
        {
            switch (param.method.method_idx)
            {
            case INTERNAL_EMPTY_STR:
                bh_str_buf_append_lit(str_buf, "$the_empty_string");
                break;
            case INTERNAL_ABORT_STR:
                bh_str_buf_append_lit(str_buf, "$string_abort");
                break;
            case INTERNAL_SUBSTR_RANGE_STR:
                bh_str_buf_append_lit(str_buf, "$substr_out_of_range");
                break;
            default:
                assert(0 && "Unhandled internal string");
                break;
            }
        }
        else if (param.method.class_idx == INTERNAL_CUSTOM_STRINGS)
        {
            bh_str_buf_append_format(str_buf, "$string%i", param.method.method_idx);
        }
        else if (bh_str_equal_lit(class_list.class_nodes[param.method.class_idx].name, "IO") && param.method.method_idx >= 3)
        {
            if (param.method.method_idx == 3) // in_int
            {
                bh_str_buf_append_lit(str_buf, "movl $1, %esi\nmovl $4096, %edi\ncall calloc\npushq %rax\nmovq %rax, %rdi\n");
                bh_str_buf_append_lit(str_buf, "movq $4096, %rsi\nmovq stdin(%rip), %rdx\ncall fgets\npopq %rdi\nmovl $0, %eax\n");
                bh_str_buf_append_lit(str_buf, "pushq %rax\nmovq %rsp, %rdx\nmovq $percent.ld, %rsi\ncall sscanf\npopq %rax\n");
                bh_str_buf_append_lit(str_buf, "movq $0, %rsi\ncmpq $2147483647, %rax\ncmovg %rsi, %rax\ncmpq $-2147483648, %rax\n");
                bh_str_buf_append_lit(str_buf, "cmovl %rsi, %rax\nmovq %rax, %r13");
            }
            else if (param.method.method_idx == 4) // in_string
            {
                bh_str_buf_append_lit(str_buf, "call coolgetstr\nmov %rax, %r13");
            }
            if (param.method.method_idx == 5) // out_int
            {
                bh_str_buf_append_lit(str_buf, "## guarantee 16-byte alignment before call\nandq $0xFFFFFFFFFFFFFFF0, %rsp\n");
                bh_str_buf_append_lit(str_buf, "movq $percent.d, %rdi\nmovl %r13d, %eax\ncdqe\nmovq %rax, %rsi\nmovl $0, %eax\ncall printf");
            }
            else if (param.method.method_idx == 6) // out_string
            {
                bh_str_buf_append_lit(str_buf, "movq %r13, %rdi\ncall cooloutstr");
            }
        }
        else
        {
            bh_str_buf_append_lit(str_buf, "$");
            bh_str_buf_append(str_buf, class_list.class_nodes[param.method.class_idx].name);
            if (param.method.method_idx == -2) // vtable reference
            {
                bh_str_buf_append_lit(str_buf, "..vtable");
            }
            else if (param.method.method_idx == -1) // Constructor call
            {
                bh_str_buf_append_lit(str_buf, "..new");
            }
            else
            {
                bh_str_buf_append_lit(str_buf, ".");
                const bh_str method_name = class_list.class_nodes[param.method.class_idx].methods[param.method.method_idx].name;
                bh_str_buf_append(str_buf, method_name);
            }
        }
        break;
    case ASM_PARAM_LABEL:
        bh_str_buf_append(str_buf, param.label);
        break;
    case ASM_PARAM_COMMENT:
        bh_str_buf_append_lit(str_buf, "## ");
        bh_str_buf_append(str_buf, param.comment);
        break;
    case ASM_PARAM_CONSTANT:
        bh_str_buf_append(str_buf, param.constant);
        break;
    case ASM_PARAM_STRING_LABEL:
        bh_str_buf_append_lit(str_buf, "$");
        bh_str_buf_append(str_buf, param.constant);
        break;
    case ASM_PARAM_STRING_CONSTANT:
        for (int i = 0; i < param.constant.len; i++)
        {
            const char c = param.constant.buf[i];
            bh_str_buf_append_format(str_buf, ".byte %i # '%c'\n", c, c);
        }
        bh_str_buf_append_format(str_buf, ".byte 0\n");
        break;
    }
}

void x86_asm_param(bh_str_buf* str_buf, const ClassNodeList class_list, const ASMParam param)
{
    x86_asm_param_internal(str_buf, class_list, param, false);
}

void x86_asm_list(bh_str_buf* str_buf, const ASMList asm_list)
{
    const ClassNodeList class_list = *asm_list.class_list;
    for (int i = 0; i < asm_list.instruction_count; i++)
    {
        const ASMInstr instr = asm_list.instructions[i];
        switch (instr.op)
        {
        case ASM_OP_NULL:
            bh_str_buf_append_lit(str_buf, "NULL");
            break;
        case ASM_OP_JMP:
            bh_str_buf_append_lit(str_buf, "jmp ");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_COMMENT:
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_LABEL:
            bh_str_buf_append_lit(str_buf, ".globl ");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, "\n");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, ":");
            if (bh_str_equal_lit(instr.params[0].label, "start"))
            {
                bh_str_buf_append_lit(str_buf, "\n.globl main\n.type main, @function\nmain:");
            }
            break;
        case ASM_OP_CONSTANT:
            if (instr.params[0].type != ASM_PARAM_STRING_CONSTANT)
            {
                bh_str_buf_append_lit(str_buf, ".quad");
            }
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_PUSH:
            bh_str_buf_append_lit(str_buf, "pushq");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_POP:
            // if (instr.params[0].reg.name == RA)
            // {
            //     bh_str_buf_append_lit(str_buf, "movq %rbp, %rsp\npopq %rbp");
            //     i += 2;
            //     break;
            // }
            bh_str_buf_append_lit(str_buf, "popq");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_MOV:
        case ASM_OP_LI:
        case ASM_OP_LA:
            bh_str_buf_append_lit(str_buf, "movq");
            x86_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, ",");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_LD:
            bh_str_buf_append_lit(str_buf, "movq");
            x86_asm_param_internal(str_buf, class_list, instr.params[1], true);
            bh_str_buf_append_lit(str_buf, ",");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_ST:
            bh_str_buf_append_lit(str_buf, "movq");
            x86_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, ",");
            x86_asm_param_internal(str_buf, class_list, instr.params[0], true);
            break;
        case ASM_OP_SYSCALL:
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_CALL:
            bh_str_buf_append_lit(str_buf, "call");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_BEQ:
            bh_str_buf_append_lit(str_buf, "cmpq");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, ",");
            x86_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, "\nje ");
            x86_asm_param(str_buf, class_list, instr.params[2]);
            break;
        case ASM_OP_BLT:
            bh_str_buf_append_lit(str_buf, "cmpq");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, ",");
            x86_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, "\njl ");
            x86_asm_param(str_buf, class_list, instr.params[2]);
            break;
        case ASM_OP_BLE:
            bh_str_buf_append_lit(str_buf, "cmpq");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, ",");
            x86_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, "\njle ");
            x86_asm_param(str_buf, class_list, instr.params[2]);
            break;
        case ASM_OP_BNZ:
            bh_str_buf_append_lit(str_buf, "cmpq $0,");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, "\n jne ");
            x86_asm_param(str_buf, class_list, instr.params[1]);
            break;
        case ASM_OP_ADD:
            bh_str_buf_append_lit(str_buf, "addq");
            x86_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, ",");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_SUB:
            bh_str_buf_append_lit(str_buf, "subq");
            x86_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, ",");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_MUL:
            bh_str_buf_append_lit(str_buf, "movq");
            x86_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, ", %rax\nimull");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, "d, %eax\nshlq $32, %rax\nshrq $32, %rax\nmovl %eax,");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            bh_str_buf_append_lit(str_buf, "d");
            break;
        case ASM_OP_DIV:
            bh_str_buf_append_lit(str_buf, "movq $0, %rdx\nmovq");
            x86_asm_param(str_buf, class_list, instr.params[2]);
            bh_str_buf_append_lit(str_buf, ", %rax\ncdq\nidivl");
            x86_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, "d\nmovq %rax,");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_AND:
            bh_str_buf_append_lit(str_buf, "andq");
            x86_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, ",");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_ALLOC:
            bh_str_buf_append_lit(str_buf, "## guarantee 16-byte alignment before call\nandq $0xFFFFFFFFFFFFFFF0, %rsp\n");
            bh_str_buf_append_lit(str_buf, "movq");
            x86_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, ", %rdi\ncall coolalloc\nmovq %rax,");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_RETURN:
            bh_str_buf_append_lit(str_buf, "ret");
            break;
        default:
            assert(0 && "Unhandled asm instruction in display");
            break;
        }
        bh_str_buf_append_lit(str_buf, "\n");
    }
}

#pragma endregion

ASMList asm_list_init(ClassNodeList* class_list)
{
    int64_t base_capacity = 100;
#ifdef WIN32
    ASMInstr* data = VirtualAlloc(NULL, 100000000000, MEM_RESERVE, PAGE_NOACCESS);
    VirtualAlloc(data, base_capacity * sizeof(ASMInstr), MEM_COMMIT, PAGE_READWRITE);
    ASMErrorStr* error_strs = VirtualAlloc(NULL, 1000 * sizeof(ASMErrorStr), MEM_RESERVE, PAGE_NOACCESS);
    VirtualAlloc(error_strs, base_capacity * sizeof(ASMErrorStr), MEM_COMMIT, PAGE_READWRITE);
    ASMCaseBinding* case_bindings = VirtualAlloc(NULL, 80 * sizeof(ASMCaseBinding), MEM_RESERVE, PAGE_NOACCESS);
    VirtualAlloc(case_bindings, 10 * sizeof(ASMCaseBinding), MEM_COMMIT, PAGE_READWRITE);
#else
    ASMInstr* data = mmap(NULL, 100000000000, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    mprotect(data, base_capacity * sizeof(ASMInstr), PROT_READ | PROT_WRITE);
    ASMErrorStr* error_strs = mmap(NULL, 1000 * sizeof(ASMErrorStr), PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    mprotect(error_strs, base_capacity * sizeof(ASMErrorStr), PROT_READ | PROT_WRITE);
    ASMCaseBinding* case_bindings = mmap(NULL, 80 * sizeof(ASMCaseBinding), PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    mprotect(case_bindings, 10 * sizeof(ASMCaseBinding), PROT_READ | PROT_WRITE);
#endif
    ASMList list = (ASMList){
        .instruction_capacity = base_capacity,
        .instructions = data,
        .instruction_count = 0,
        .error_strs = error_strs,
        .error_str_count = 0,
        .error_str_capacity = base_capacity,
        .class_list = class_list,
        .case_bindings = case_bindings,
        .case_binding_count = 0,
        .case_binding_capacity = 10
    };

    int64_t bool_class_idx = -1;
    int64_t io_class_idx = -1;
    int64_t int_class_idx = -1;
    int64_t string_class_idx = -1;
    for (int i = 0; i < class_list->class_count; i++)
    {
        const ClassNode class_node = class_list->class_nodes[i];
        if (bh_str_equal_lit(class_node.name, "Bool")) bool_class_idx = i;
        if (bh_str_equal_lit(class_node.name, "IO")) io_class_idx = i;
        if (bh_str_equal_lit(class_node.name, "Int")) int_class_idx = i;
        if (bh_str_equal_lit(class_node.name, "String")) string_class_idx = i;
        if (bool_class_idx > -1 && io_class_idx > -1 && int_class_idx > -1 && string_class_idx > -1) break;
    }

    list.bool_class_idx = bool_class_idx;
    list.io_class_idx = io_class_idx;
    list.int_class_idx = int_class_idx;
    list.string_class_idx = string_class_idx;

    return list;
}