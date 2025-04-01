//
// Created by Brandon Howe on 3/18/25.
//

#include "assembly.h"

#include <assert.h>
#include <string.h>

#pragma region Assembly operations

void asm_list_append(ASMList* asm_list, const ASMInstr instr)
{
    asm_list->instructions[asm_list->instruction_count] = instr;
    asm_list->instruction_count += 1;
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

void asm_list_append_li(ASMList* asm_list, const ASMRegister reg, const int16_t immediate, const ASMImmediateUnits units)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_LI,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = reg },
            (ASMParam){ .type = ASM_PARAM_IMMEDIATE, .immediate = { .val = immediate, .units = units } }
        }
    });
}

void asm_list_append_la(ASMList* asm_list, const ASMRegister reg, const int16_t class_idx, const int16_t method_idx)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_LA,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = reg },
            (ASMParam){ .type = ASM_PARAM_METHOD, .method = { .class_idx = class_idx, .method_idx = method_idx } }
        }
    });
}

void asm_list_append_ld(ASMList* asm_list, const ASMRegister dest, const ASMRegister source, const int16_t offset)
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

void asm_list_append_syscall(ASMList* asm_list, const int16_t class_idx, const int16_t method_idx)
{
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_SYSCALL,
        .params = {
            (ASMParam){ .type = ASM_PARAM_METHOD, .method = { .class_idx = class_idx, .method_idx = method_idx } },
        }
    });
}

void asm_list_append_st(ASMList* asm_list, const ASMRegister dest, const int16_t offset, const ASMRegister source)
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
            const int16_t method_name_len = method.name.len + method.inherited_from.len + 1;
            char* method_name_buf = bh_alloc(asm_list->string_allocator, method_name_len);
            strncpy(method_name_buf, method.inherited_from.buf, method.inherited_from.len);
            strncpy(method_name_buf + method.inherited_from.len, ".", 1);
            strncpy(method_name_buf + method.inherited_from.len + 1, method.name.buf, method.name.len);
            asm_list_append_constant(asm_list, (bh_str){ .buf = method_name_buf, .len = method_name_len });
        }
    }
}

void asm_from_constructor(ASMList* asm_list, const ClassNode class_node, const int16_t class_idx)
{
    char* constructor_buf = bh_alloc(asm_list->string_allocator, class_node.name.len + 5);
    strncpy(constructor_buf, class_node.name.buf, class_node.name.len);
    strncpy(constructor_buf + class_node.name.len, "..new", 5);
    asm_list_append_label(asm_list, (bh_str){ .buf = constructor_buf, .len = class_node.name.len + 5 });

    // initialization stuff
    asm_list_append_push(asm_list, RBP);
    asm_list_append_mov(asm_list, RBP, RSP);
    asm_list_append_comment(asm_list, "stack room for temporaries");
    asm_list_append_li(asm_list, R14, 2, ASMImmediateUnitsWord);
    asm_list_append_arith(asm_list, ASM_OP_SUB, RSP, R14);

    // call malloc
    int16_t attribute_count = class_node.attribute_count;
    if (bh_str_equal_lit(class_node.name, "Bool") ||
        bh_str_equal_lit(class_node.name, "Int") ||
        bh_str_equal_lit(class_node.name, "String"))
    {
        attribute_count += 1;
    }
    int object_size = 3 + attribute_count;
    asm_list_append_li(asm_list, R12, object_size, ASMImmediateUnitsBase);
    asm_list_append(asm_list, (ASMInstr){
        .op = ASM_OP_ALLOC,
        .params = {
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R12 },
            (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R12 },
        }
    });

    // store class tag
    int16_t class_tag = class_idx;
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
    else
    {
        asm_list_append_comment(asm_list, "define attributes");
        for (int i = 0; i < class_node.attribute_count; i++) // define attributes
        {
            const ClassAttribute attribute = class_node.attributes[i];
            if (bh_str_equal_lit(attribute.type, "Int"))
            {
                asm_list_append_call_method(asm_list, 2, CONSTRUCTOR_METHOD);
            }
            else
            {
                asm_list_append_li(asm_list, R13, 0, ASMImmediateUnitsBase);
            }

            asm_list_append_st(asm_list, R12, 3 + i, R13);
        }

        asm_list_append_comment(asm_list, "initialize attributes");
        for (int i = 0; i < class_node.attribute_count; i++) // initialize attributes
        {
            const ClassAttribute attribute = class_node.attributes[i];

            // attribute initializer
            if (attribute.expr.type)
            {
                TACList list = (TACList)
                {
                    .allocator = asm_list->tac_allocator,
                    .capacity = 1000,
                    .count = 0,
                    .class_list = *asm_list->class_list,
                    .items = bh_alloc(asm_list->tac_allocator, 1000 * sizeof(TACExpr)),
                    ._bindings = bh_alloc(asm_list->tac_allocator, 1000 * sizeof(TACBinding)),
                    ._binding_count = 0
                };
                tac_list_from_expression(attribute.expr, &list, (TACSymbol){ 0 });
                asm_from_tac_list(asm_list, list);
                asm_list_append_st(asm_list, R12, i + 3, R13);
                arena_free_all(asm_list->tac_allocator);
            }
        }
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

void asm_list_append_call_method(ASMList* asm_list, const int16_t class_idx, const int16_t method_idx)
{
    bool is_comparison = class_idx == INTERNAL_CLASS &&
                         (method_idx == INTERNAL_EQ_HANDLER || method_idx == INTERNAL_LE_HANDLER || method_idx == INTERNAL_LT_HANDLER);
    if (is_comparison)
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

    if (is_comparison)
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
        asm_list_append_call_method(asm_list, 2, CONSTRUCTOR_METHOD);
        asm_list_append_li(asm_list, R14, symbol.integer, ASMImmediateUnitsBase);
        asm_list_append_st(asm_list, R13, 3, R14);
        break;
    case TAC_SYMBOL_TYPE_BOOL:
        asm_list_append_call_method(asm_list, 2, CONSTRUCTOR_METHOD);
        if (symbol.integer > 0)
        {
            asm_list_append_li(asm_list, R14, symbol.integer, ASMImmediateUnitsBase);
            asm_list_append_st(asm_list, R13, 3, R14);
        }
        break;
    case TAC_SYMBOL_TYPE_STRING:
        break;
    case TAC_SYMBOL_TYPE_SYMBOL:
        break;
    case TAC_SYMBOL_TYPE_VARIABLE:
        break;
    default:
        assert(0 && "Unhandled asm from tac symbol type");
    }
}

void asm_from_tac_list(ASMList* asm_list, TACList tac_list)
{
    ClassNode curr_class_node = tac_list.class_list.class_nodes[tac_list.class_idx];
    const bh_str class_name = curr_class_node.name;
    int16_t bool_class_idx = -1;
    int16_t io_class_idx = -1;
    int16_t int_class_idx = -1;
    int16_t string_class_idx = -1;
    for (int i = 0; i < asm_list->class_list->class_count; i++)
    {
        ClassNode class_node = asm_list->class_list->class_nodes[i];
        if (bh_str_equal_lit(class_node.name, "Bool")) bool_class_idx = i;
        if (bh_str_equal_lit(class_node.name, "IO")) io_class_idx = i;
        if (bh_str_equal_lit(class_node.name, "Int")) int_class_idx = i;
        if (bh_str_equal_lit(class_node.name, "String")) string_class_idx = i;
        if (bool_class_idx > -1 && io_class_idx > -1 && int_class_idx > -1 && string_class_idx > -1) break;
    }
    for (int i = 0; i < tac_list.count; i++)
    {
        const TACExpr expr = tac_list.items[i];

        switch (expr.operation)
        {
        case TAC_OP_ASSIGN:
        {
            if (expr.rhs1.type == TAC_SYMBOL_TYPE_VARIABLE)
            {
                int16_t attribute_idx = 0;
                for (int j = 0; j < curr_class_node.attribute_count; j++)
                {
                    if (bh_str_equal(curr_class_node.attributes[j].name, expr.rhs1.variable))
                    {
                        attribute_idx = j;
                        break;
                    }
                }
                asm_list_append_ld(asm_list, R13, R12, attribute_idx + 3);
                asm_list_append_st(asm_list, RBP, -0 - expr.lhs.symbol, R13);
            }
            else if (expr.rhs1.type == TAC_SYMBOL_TYPE_SYMBOL)
            {
                asm_list_append_ld(asm_list, R13, RBP, -0 - expr.rhs1.symbol);
                asm_list_append_st(asm_list, RBP, -0 - expr.lhs.symbol, R13);
            }
            break;
        }
        case TAC_OP_PLUS:
        case TAC_OP_MINUS:
        case TAC_OP_TIMES:
        case TAC_OP_DIVIDE:
            asm_list_append_ld(asm_list, R13, RBP, -0 - expr.rhs1.symbol);
            asm_list_append_ld(asm_list, R13, R13, 3);
            asm_list_append_ld(asm_list, R14, RBP, -0 - expr.rhs2.symbol);
            asm_list_append_ld(asm_list, R14, R14, 3);
            asm_list_append(asm_list, (ASMInstr){
                .op = ASM_OP_ADD + (expr.operation - TAC_OP_PLUS),
                .params = {
                    (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R13 },
                    (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R14 },
                    (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = R13 },
                }
            });
            asm_list_append_st(asm_list, RBP, -0 - expr.lhs.symbol, R13);
            asm_list_append_call_method(asm_list, int_class_idx, -1);
            asm_list_append_ld(asm_list, R14, RBP, -0 - expr.lhs.symbol);
            asm_list_append_st(asm_list, R13, 3, R14);
            asm_list_append_st(asm_list, RBP, -0 - expr.lhs.symbol, R13);
            break;
        case TAC_OP_LT:
            asm_list_append_ld(asm_list, R13, RBP, -0 - expr.rhs1.symbol);
            asm_list_append_ld(asm_list, R14, RBP, -0 - expr.rhs2.symbol);
            asm_list_append_push(asm_list, R13);
            asm_list_append_push(asm_list, R14);
            asm_list_append_call_method(asm_list, INTERNAL_CLASS, INTERNAL_LT_HANDLER);
            asm_list_append_st(asm_list, RBP, -0 - expr.lhs.symbol, R13);
            break;
        case TAC_OP_LTE:
            asm_list_append_ld(asm_list, R13, RBP, -0 - expr.rhs1.symbol);
            asm_list_append_ld(asm_list, R14, RBP, -0 - expr.rhs2.symbol);
            asm_list_append_push(asm_list, R13);
            asm_list_append_push(asm_list, R14);
            asm_list_append_call_method(asm_list, INTERNAL_CLASS, INTERNAL_LE_HANDLER);
            asm_list_append_st(asm_list, RBP, -0 - expr.lhs.symbol, R13);
            break;
        case TAC_OP_EQ:
            asm_list_append_ld(asm_list, R13, RBP, -0 - expr.rhs1.symbol);
            asm_list_append_ld(asm_list, R14, RBP, -0 - expr.rhs2.symbol);
            asm_list_append_push(asm_list, R13);
            asm_list_append_push(asm_list, R14);
            asm_list_append_call_method(asm_list, INTERNAL_CLASS, INTERNAL_EQ_HANDLER);
            asm_list_append_st(asm_list, RBP, -0 - expr.lhs.symbol, R13);
            break;
        case TAC_OP_INT:
            asm_list_append_comment(asm_list, "new Int");
            asm_from_tac_symbol(asm_list, expr.rhs1);
            asm_list_append_st(asm_list, RBP, -0 - expr.lhs.symbol, R13);
            break;
        case TAC_OP_STRING:
            break;
        case TAC_OP_BOOL:
            asm_list_append_comment(asm_list, "new Bool");
            asm_from_tac_symbol(asm_list, expr.rhs1);
            asm_list_append_st(asm_list, RBP, -0 - expr.lhs.symbol, R13);
            break;
        case TAC_OP_NOT:
        {
            bh_str_buf label_buf_1 = bh_str_buf_init(asm_list->string_allocator, 4);
            bh_str_buf_append_format(&label_buf_1, "l%i", ++asm_list->_global_label);
            bh_str label_str_1 = (bh_str){ .buf = label_buf_1.buf, .len = label_buf_1.len };

            bh_str_buf label_buf_2 = bh_str_buf_init(asm_list->string_allocator, 4);
            bh_str_buf_append_format(&label_buf_2, "l%i", ++asm_list->_global_label);
            bh_str label_str_2 = (bh_str){ .buf = label_buf_2.buf, .len = label_buf_2.len };

            bh_str_buf label_buf_3 = bh_str_buf_init(asm_list->string_allocator, 4);
            bh_str_buf_append_format(&label_buf_3, "l%i", ++asm_list->_global_label);
            bh_str label_str_3 = (bh_str){ .buf = label_buf_3.buf, .len = label_buf_3.len };

            asm_list_append_ld(asm_list, R13, RBP, -0 - expr.rhs1.symbol);
            asm_list_append_ld(asm_list, R13, R13, 3);
            asm_list_append_bnz(asm_list, R13, label_str_1);

            asm_list_append_label(asm_list, label_str_2);
            asm_list_append_comment(asm_list, "false branch");
            asm_list_append_call_method(asm_list, bool_class_idx, -1);
            asm_list_append_li(asm_list, R14, 1, ASMImmediateUnitsBase);
            asm_list_append_st(asm_list, R13, 3, R14);
            asm_list_append_jmp(asm_list, label_str_3);

            asm_list_append_label(asm_list, label_str_1);
            asm_list_append_comment(asm_list, "true branch");
            asm_list_append_call_method(asm_list, bool_class_idx, -1);

            asm_list_append_label(asm_list, label_str_3);
            break;
        }
        case TAC_OP_NEG:
            asm_list_append_call_method(asm_list, int_class_idx, -1);
            asm_list_append_push(asm_list, R13);
            asm_list_append_ld(asm_list, R14, R13, 3);
            asm_list_append_ld(asm_list, R13, RBP, -0 - expr.rhs1.symbol);
            asm_list_append_ld(asm_list, R13, R13, 3);
            asm_list_append_arith(asm_list, ASM_OP_SUB, R14, R13);
            asm_list_append_pop(asm_list, R13);
            asm_list_append_st(asm_list, R13, 3, R14);
            asm_list_append_st(asm_list, RBP, -0 - expr.lhs.symbol, R13);
            break;
        case TAC_OP_NEW:
            {
                int16_t class_idx = -1;
                for (int16_t j = 0; j < asm_list->class_list->class_count; j++)
                {
                    if (bh_str_equal(asm_list->class_list->class_nodes[j].name, expr.rhs1.variable))
                    {
                        class_idx = j;
                    }
                }
                assert(class_idx != -1 && "TAC new expression did not match class");
                asm_list_append_call_method(asm_list, class_idx, CONSTRUCTOR_METHOD);
            }
            break;
        case TAC_OP_DEFAULT:
        {
            int16_t class_idx = -1;
            for (int j = 0; j < asm_list->class_list->class_count; j++)
            {
                if (bh_str_equal(asm_list->class_list->class_nodes[j].name, expr.rhs1.variable))
                {
                    class_idx = j;
                    break;
                }
            }
            assert(class_idx != -1 && "Unhandled default constructor call");
            asm_list_append_comment(asm_list, "default constructor");
            asm_list_append_call_method(asm_list, class_idx, -1);
            asm_list_append_st(asm_list, RBP, -0 - expr.lhs.symbol, R13);
            break;
        }
        case TAC_OP_ISVOID:
            break;
        case TAC_OP_IGNORE:
            switch (expr.rhs1.integer)
            {
                case -1:
                    asm_list_append_push(asm_list, R12);
                    asm_list_append_push(asm_list, RBP);
                    break;
                default:
                    assert(0 && "Unhandled tac ignore");
            }
            break;
        case TAC_OP_CALL:
        {
            int16_t is_self_dispatch = expr.args[expr.arg_count - 1].symbol == 0;
            // Check for void if not self dispatch
            if (!is_self_dispatch)
            {
                bh_str_buf label_buf = bh_str_buf_init(asm_list->string_allocator, 4);
                bh_str_buf_append_format(&label_buf, "l%i", ++asm_list->_global_label);
                bh_str label_str = (bh_str){ .buf = label_buf.buf, .len = label_buf.len };
                asm_list_append_bnz(asm_list, R13, label_str);
                asm_list_append_la(asm_list, R13, INTERNAL_STRINGS, INTERNAL_VOID_DISPATCH_START_STR);
                asm_list_append_syscall(asm_list, io_class_idx, 6);
                asm_list_append_li(asm_list, R13, expr.arg_count, ASMImmediateUnitsBase);
                asm_list_append_syscall(asm_list, io_class_idx, 5);
                asm_list_append_la(asm_list, R13, INTERNAL_STRINGS, INTERNAL_VOID_DISPATCH_END_STR);
                asm_list_append_syscall(asm_list, io_class_idx, 6);
                asm_list_append_syscall(asm_list, INTERNAL_CLASS, 0);
                asm_list_append_label(asm_list, label_str);
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
                    asm_list_append_ld(asm_list, R13, RBP, -0 - expr.args[j].symbol);
                    asm_list_append_push(asm_list, R13);
                }
            }

            // Perform the call
            asm_list_append_ld(asm_list, R14, is_self_dispatch ? R12 : R13, 2);
            asm_list_append_ld(asm_list, R14, R14, expr.rhs1.method.method_idx + 2);
            asm_list_append_call(asm_list, R14);
            // asm_list_append_push(asm_list, R15);
            // asm_list_append_li(asm_list, R15, expr.arg_count, ASMImmediateUnitsWord);
            // asm_list_append_arith(asm_list, ASM_OP_ADD, RSP, R15);
            // asm_list_append_pop(asm_list, R15);
            asm_list_append(asm_list, (ASMInstr){
                .op = ASM_OP_ADD,
                .params = {
                    (ASMParam){ .type = ASM_PARAM_REGISTER, .reg = RSP },
                    (ASMParam){ .type = ASM_PARAM_IMMEDIATE, .immediate = { .val = expr.arg_count, .units = ASMImmediateUnitsWord }}
                }
            });
            asm_list_append_pop(asm_list, RBP);
            asm_list_append_pop(asm_list, R12);
            asm_list_append_st(asm_list, RBP, -0 - expr.lhs.symbol, R13);
            break;
        }
        case TAC_OP_JMP:
        case TAC_OP_LABEL:
        {
            int16_t digits = expr.rhs1.integer > 9 ? 2 : 1;
            bh_str_buf str_buf = bh_str_buf_init(asm_list->string_allocator, class_name.len + tac_list.method_name.len + digits + 2);
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
            asm_list_append_ld(asm_list, R13, RBP, expr.rhs1.symbol);
            break;
        case TAC_OP_COMMENT:
            asm_list_append_comment_str(asm_list, expr.rhs1.string);
            break;
        case TAC_OP_BT:
        {
            int16_t digits = expr.rhs2.integer > 9 ? 2 : 1;
            bh_str_buf str_buf = bh_str_buf_init(asm_list->string_allocator, class_name.len + tac_list.method_name.len + digits + 2);
            bh_str_buf_append(&str_buf, class_name);
            bh_str_buf_append_lit(&str_buf, "_");
            bh_str_buf_append(&str_buf, tac_list.method_name);
            bh_str_buf_append_format(&str_buf, "_%i", expr.rhs2.integer);
            asm_from_tac_symbol(asm_list, expr.rhs1);
            asm_list_append_ld(asm_list, R13, R13, 3);
            asm_list_append_bnz(asm_list, R13, (bh_str){ .buf = str_buf.buf, .len = str_buf.len });
            break;
        }
        default:
            assert(0 && "Trying to convert unhandled tac expression to assembly");
        }
    }
}

void asm_from_method(ASMList* asm_list, const TACList tac_list)
{
    const bh_str class_name = tac_list.class_list.class_nodes[tac_list.class_idx].name;
    ClassMethod method = tac_list.class_list.class_nodes[tac_list.class_idx].methods[tac_list.method_idx];

    // Construct method name
    int16_t label_len = class_name.len + tac_list.method_name.len + 1;
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
    int16_t temp_count = tac_list._curr_symbol + (tac_list._curr_symbol & 1);
    asm_list_append_li(asm_list, R14, temp_count, ASMImmediateUnitsWord);
    asm_list_append_arith(asm_list, ASM_OP_SUB, RSP, R14);

    asm_list_append_comment(asm_list, "method body begins");
    int16_t io_class_idx = -1;
    int16_t int_class_idx = -1;
    int16_t string_class_idx = -1;
    for (int i = 0; i < asm_list->class_list->class_count; i++)
    {
        ClassNode class_node = asm_list->class_list->class_nodes[i];
        if (bh_str_equal_lit(class_node.name, "IO")) io_class_idx = i;
        if (bh_str_equal_lit(class_node.name, "Int")) int_class_idx = i;
        if (bh_str_equal_lit(class_node.name, "String")) string_class_idx = i;
        if (io_class_idx > -1 && int_class_idx > -1 && string_class_idx > -1) break;
    }
    if (bh_str_equal_lit(class_name, "Object"))
    {
        if (bh_str_equal_lit(tac_list.method_name, "abort"))
        {
            asm_list_append_la(asm_list, R13, INTERNAL_CLASS, INTERNAL_ABORT_STR); // Fix this jawn
            asm_list_append_syscall(asm_list, io_class_idx, 6);
            asm_list_append_syscall(asm_list, -1, 0); // Exit
        }
        if (bh_str_equal_lit(tac_list.method_name, "copy"))
        {
            // implement pa3
        }
        if (bh_str_equal_lit(tac_list.method_name, "type_name"))
        {
            // implement pa3
        }
    }
    else if (bh_str_equal_lit(class_name, "IO"))
    {
        if (bh_str_equal_lit(tac_list.method_name, "in_int"))
        {
            asm_list_append_call_method(asm_list, int_class_idx, CONSTRUCTOR_METHOD);
            asm_list_append_mov(asm_list, R14, R13);
            asm_list_append_syscall(asm_list, io_class_idx, 3);
            asm_list_append_st(asm_list, R14, 3, R13);
            asm_list_append_mov(asm_list, R13, R14);
        }
        if (bh_str_equal_lit(tac_list.method_name, "in_string"))
        {
            asm_list_append_call_method(asm_list, string_class_idx, CONSTRUCTOR_METHOD);
            asm_list_append_mov(asm_list, R14, R13);
            asm_list_append_syscall(asm_list, io_class_idx, 4);
            asm_list_append_st(asm_list, R14, 3, R13);
            asm_list_append_mov(asm_list, R13, R14);
        }
        if (bh_str_equal_lit(tac_list.method_name, "out_int"))
        {
            asm_list_append_ld(asm_list, R14, RBP, 3);
            asm_list_append_ld(asm_list, R13, R14, 3);
            asm_list_append_syscall(asm_list, io_class_idx, 5);
            asm_list_append_mov(asm_list, R13, R12);
        }
        if (bh_str_equal_lit(tac_list.method_name, "out_string"))
        {
            asm_list_append_ld(asm_list, R14, RBP, 2);
            asm_list_append_ld(asm_list, R13, R14, 3);
            asm_list_append_syscall(asm_list, io_class_idx, 6);
        }
    }
    else if (bh_str_equal_lit(class_name, "String"))
    {
        if (bh_str_equal_lit(tac_list.method_name, "length"))
        {
            // implement pa3
        }
        if (bh_str_equal_lit(tac_list.method_name, "substr"))
        {
            // implement pa3
        }
    }
    else
    {
        asm_from_tac_list(asm_list, tac_list);
    }

    asm_list_append_label(asm_list, (bh_str){ .buf = label_buf, .len = label_len + 4 });
    asm_list_append_mov(asm_list, RSP, RBP);
    asm_list_append_pop(asm_list, RBP);
    // asm_list_append_pop(asm_list, RA);
    // asm_list_append_li(asm_list, R14, temp_count, ASMImmediateUnitsWord);
    // asm_list_append_arith(asm_list, ASM_OP_ADD, RSP, R14);
    asm_list_append_return(asm_list);

    asm_list_append_comment(asm_list, ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"); // Spacer
}

#pragma endregion

#pragma region Built in helpers

void builtin_append_string_helpers(bh_str_buf* buf)
{
    bh_str file_text = read_file_text("./string_helpers.txt");
    bh_str_buf_append(buf, file_text);
}

void builtin_append_string_constants(ASMList* asm_list)
{
    asm_list_append_comment(asm_list, "global string constants");
    asm_list_append_label(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, "string_abort"));
    asm_list_append_string_constant(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, "abort\\n"));
    asm_list_append_label(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, "percent.d"));
    asm_list_append_string_constant(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, "%ld"));
    asm_list_append_label(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, "percent.ld"));
    asm_list_append_string_constant(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, " %ld"));
    asm_list_append_label(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, "void_dispatch_error_begin"));
    asm_list_append_string_constant(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, "ERROR: "));
    asm_list_append_label(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, "void_dispatch_error_end"));
    asm_list_append_string_constant(asm_list, bh_str_alloc_cstr(asm_list->string_allocator, ": Exception: dispatch on void\\n"));
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
}

// I used the reference compiler's output for this code
void builtin_append_comp_handler(ASMList* asm_list, const TACOp op)
{
    int16_t bool_class_idx = -1;
    for (int i = 0; i < asm_list->class_list->class_count; i++)
    {
        ClassNode class_node = asm_list->class_list->class_nodes[i];
        if (bh_str_equal_lit(class_node.name, "Bool")) bool_class_idx = i;
        if (bool_class_idx > -1) break;
    }

    const char* prefix = op == TAC_OP_EQ ? "eq_" : op == TAC_OP_LT ? "lt_" : "le_";

    char* eq_handler_buf = bh_alloc(asm_list->string_allocator, 10);
    strncpy(eq_handler_buf, prefix, 3); strncpy(eq_handler_buf + 3, "handler", 7);
    bh_str eq_handler = (bh_str){ .buf = eq_handler_buf, .len = 10 };
    char* eq_true_buf = bh_alloc(asm_list->string_allocator, 7);
    strncpy(eq_true_buf, prefix, 3); strncpy(eq_true_buf + 3, "true", 4);
    bh_str eq_true = (bh_str){ .buf = eq_true_buf, .len = 7 };
    char* eq_false_buf = bh_alloc(asm_list->string_allocator, 8);
    strncpy(eq_false_buf, prefix, 3); strncpy(eq_false_buf + 3, "false", 5);
    bh_str eq_false = (bh_str){ .buf = eq_false_buf, .len = 8 };
    char* eq_bool_buf = bh_alloc(asm_list->string_allocator, 7);
    strncpy(eq_bool_buf, prefix, 3); strncpy(eq_bool_buf + 3, "bool", 4);
    bh_str eq_bool = (bh_str){ .buf = eq_bool_buf, .len = 7 };
    char* eq_int_buf = bh_alloc(asm_list->string_allocator, 6);
    strncpy(eq_int_buf, prefix, 3); strncpy(eq_int_buf + 3, "int", 3);
    bh_str eq_int = (bh_str){ .buf = eq_int_buf, .len = 6 };
    char* eq_string_buf = bh_alloc(asm_list->string_allocator, 9);
    strncpy(eq_string_buf, prefix, 3); strncpy(eq_string_buf + 3, "string", 6);
    bh_str eq_string = (bh_str){ .buf = eq_string_buf, .len = 9 };
    char* eq_end_buf = bh_alloc(asm_list->string_allocator, 6);
    strncpy(eq_end_buf, prefix, 3); strncpy(eq_end_buf + 3, "end", 3);
    bh_str eq_end = (bh_str){ .buf = eq_end_buf, .len = 6 };

    asm_list_append_label(asm_list, eq_handler);
    asm_list_append_mov(asm_list, RBP, RSP);
    asm_list_append_pop(asm_list, R12);
    asm_list_append_push(asm_list, RA);
    asm_list_append_ld(asm_list, R13, RBP, 3);
    asm_list_append_ld(asm_list, R14, RBP, 2);
    asm_list_append_beq(asm_list, R13, R14, eq_true);
    asm_list_append_li(asm_list, R15, 0, ASMImmediateUnitsBase);
    asm_list_append_beq(asm_list, R13, R15, eq_false);
    asm_list_append_beq(asm_list, R14, R15, eq_false);
    asm_list_append_ld(asm_list, R13, R13, 0);
    asm_list_append_ld(asm_list, R14, R14, 0);
    asm_list_append_comment(asm_list, "place the sum of the type tags in r1");
    asm_list_append_arith(asm_list, ASM_OP_ADD, R13, R14);
    asm_list_append_li(asm_list, R14, -2, ASMImmediateUnitsBase);
    asm_list_append_beq(asm_list, R13, R14, eq_bool);
    asm_list_append_li(asm_list, R14, -4, ASMImmediateUnitsBase);
    asm_list_append_beq(asm_list, R13, R14, eq_int);
    asm_list_append_li(asm_list, R14, -6, ASMImmediateUnitsBase);
    asm_list_append_beq(asm_list, R13, R14, eq_string);
    if (op == TAC_OP_LT)
    {
        asm_list_append_comment(asm_list, "for non-primitive, < is always false");
    }
    else
    {
        asm_list_append_comment(asm_list, "otherwise, use pointer comparison");
        asm_list_append_ld(asm_list, R13, RBP, 3);
        asm_list_append_ld(asm_list, R13, RBP, 2);
        asm_list_append_beq(asm_list, R13, R14, eq_true);
    }
    asm_list_append_label(asm_list, eq_false);
    asm_list_append_comment(asm_list, "not equal");
    asm_list_append_call_method(asm_list, bool_class_idx, -1);
    asm_list_append_jmp(asm_list, eq_end);
    asm_list_append_label(asm_list, eq_true);
    asm_list_append_comment(asm_list, "equal");
    asm_list_append_call_method(asm_list, bool_class_idx, -1);
    asm_list_append_li(asm_list, R14, 1, ASMImmediateUnitsBase);
    asm_list_append_st(asm_list, R13, 3, R14);
    asm_list_append_jmp(asm_list, eq_end);
    asm_list_append_label(asm_list, eq_bool);
    asm_list_append_comment(asm_list, "two Bools");
    asm_list_append_label(asm_list, eq_int);
    asm_list_append_comment(asm_list, "two Ints");
    asm_list_append_ld(asm_list, R13, RBP, 3);
    asm_list_append_ld(asm_list, R14, RBP, 2);
    asm_list_append_ld(asm_list, R13, R13, 3);
    asm_list_append_ld(asm_list, R14, R14, 3);
    if (op == TAC_OP_EQ) asm_list_append_beq(asm_list, R13, R14, eq_true);
    if (op == TAC_OP_LT) asm_list_append_blt(asm_list, R13, R14, eq_true);
    if (op == TAC_OP_LTE) asm_list_append_ble(asm_list, R13, R14, eq_true);
    asm_list_append_jmp(asm_list, eq_false);
    asm_list_append_label(asm_list, eq_string);
    asm_list_append_comment(asm_list, "two Strings");
    asm_list_append_ld(asm_list, R13, RBP, 3);
    asm_list_append_ld(asm_list, R14, RBP, 2);
    asm_list_append_ld(asm_list, R13, R13, 3);
    asm_list_append_ld(asm_list, R14, R14, 3);
    asm_list_append_ld(asm_list, R13, R13, 0);
    asm_list_append_ld(asm_list, R14, R14, 0);
    if (op == TAC_OP_EQ) asm_list_append_beq(asm_list, R13, R14, eq_true);
    if (op == TAC_OP_LT) asm_list_append_blt(asm_list, R13, R14, eq_true);
    if (op == TAC_OP_LTE) asm_list_append_ble(asm_list, R13, R14, eq_true);
    asm_list_append_jmp(asm_list, eq_false);
    asm_list_append_label(asm_list, eq_end);
    asm_list_append_pop(asm_list, RA);
    asm_list_append_li(asm_list, R14, 2, ASMImmediateUnitsBase);
    asm_list_append_arith(asm_list, ASM_OP_ADD, RSP, R14);
    asm_list_append_return(asm_list);
}

// I used the reference compiler's output for this code
void builtin_append_start(ASMList* asm_list)
{
    int16_t main_class_idx = -1;
    int16_t main_method_idx = -1;
    for (int i = 0; i < asm_list->class_list->class_count; i++)
    {
        ClassNode class_node = asm_list->class_list->class_nodes[i];
        if (bh_str_equal_lit(class_node.name, "Main"))
        {
            main_class_idx = i;
            for (int j = 0; j < class_node.method_count; j++)
            {
                if (bh_str_equal_lit(class_node.methods[j].name, "main"))
                {
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
    asm_list_append_la(asm_list, R14, main_class_idx, -1);
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
            int16_t offset = param.reg.offset;
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
            }
        }
        else if (param.method.class_idx == INTERNAL_STRINGS)
        {
            switch (param.method.method_idx)
            {
            case INTERNAL_ABORT_STR:
                bh_str_buf_append_lit(str_buf, "string_abort");
                break;
            case INTERNAL_VOID_DISPATCH_START_STR:
                bh_str_buf_append_lit(str_buf, "void_dispatch_error_begin");
                break;
            case INTERNAL_VOID_DISPATCH_END_STR:
                bh_str_buf_append_lit(str_buf, "void_dispatch_error_end");
                break;
            default:
                assert(0 && "Unhandled internal string");
            }
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
        int16_t num = param.immediate.val;
        if (param.immediate.units == ASMImmediateUnitsWord) num *= 8;
        bh_str_buf_append_format(str_buf, "$%i", num);
        break;
    }
    case ASM_PARAM_REGISTER:
        if (param.reg.offset || force_offset)
        {
            int16_t offset = param.reg.offset * 8;
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
                bh_str_buf_append_lit(str_buf, "call exit");
                break;
            case -2:
                bh_str_buf_append_lit(str_buf, "string_abort");
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
            default:
                assert(0 && "Unhandled internal method");
            }
        }
        else if (param.method.class_idx == INTERNAL_STRINGS)
        {
            switch (param.method.method_idx)
            {
            case INTERNAL_ABORT_STR:
                bh_str_buf_append_lit(str_buf, "string_abort");
                break;
            case INTERNAL_VOID_DISPATCH_START_STR:
                bh_str_buf_append_lit(str_buf, "void_dispatch_error_begin");
                break;
            case INTERNAL_VOID_DISPATCH_END_STR:
                bh_str_buf_append_lit(str_buf, "void_dispatch_error_end");
                break;
            default:
                assert(0 && "Unhandled internal string");
            }
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
            // if (bh_str_equal_lit(instr.params[0].comment, "method definition"))
            // {
            //     bh_str_buf_append_lit(str_buf, "\npushq %rbp\nmovq %rsp, %rbp\nmovq 16(%rbp), %r12");
            //     i += 2;
            // }
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
        case ASM_OP_LD:
            bh_str_buf_append_lit(str_buf, "movq");
            x86_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, ",");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_SYSCALL:
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_CALL:
            bh_str_buf_append_lit(str_buf, "call");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_ST:
            bh_str_buf_append_lit(str_buf, "mov");
            x86_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, ",");
            x86_asm_param_internal(str_buf, class_list, instr.params[0], true);
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
        case ASM_OP_ALLOC:
            bh_str_buf_append_lit(str_buf, "## guarantee 16-byte alignment before call\nandq $0xFFFFFFFFFFFFFFF0, %rsp\n");
            bh_str_buf_append_lit(str_buf, "movq $8, %rsi\nmovq");
            x86_asm_param(str_buf, class_list, instr.params[1]);
            bh_str_buf_append_lit(str_buf, ", %rdi\ncall calloc\nmovq %rax,");
            x86_asm_param(str_buf, class_list, instr.params[0]);
            break;
        case ASM_OP_RETURN:
            bh_str_buf_append_lit(str_buf, "ret");
            break;
        default:
            assert(0 && "Unhandled asm instruction in display");
        }
        bh_str_buf_append_lit(str_buf, "\n");
    }
}

#pragma endregion

ASMList asm_list_init(bh_allocator allocator)
{
    return (ASMList){
        .allocator = allocator,
        .instruction_capacity = 1000,
        .instructions = bh_alloc(allocator, 1000 * sizeof(ASMInstr)),
        .instruction_count = 0
    };
}