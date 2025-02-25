//
// Created by Brandon Howe on 2/12/25.
//

#include "class_map.h"

#include <assert.h>
#include <stdio.h>
#include <string.h>

#define RETURN_ERROR(line_num, message_cstr) return (CoolError){ .valid = true, .line = (line_num), .message = (message_cstr) }

#define RETURN_TYPE(type_str) return (CoolTypeOrError){ .is_error = false, .type = (type_str) }
#define RETURN_TYPE_ERROR(line_num, message_cstr) return (CoolTypeOrError){ .is_error = true, .error = { .valid = true, .line = (line_num), .message = (message_cstr) } }

// Fills in a ClassNode's parent and attributes based on data from the AST
CoolError fill_class_attributes(CoolAST AST, ClassNode* classes, int16_t class_idx, bh_allocator allocator)
{
    ClassNode* class = &classes[class_idx];
    if (class->attributes_filled) return (CoolError){ 0 };

    // No attributes for built-in classes
    if (class_idx < 5)
    {
        class->attributes_filled = true;
        return (CoolError){ 0 };
    }

    // Make sure the parent's attributes are filled in before we copy them
    int16_t inherited_attribute_counts = 0;
    if (class->parent)
    {
        int16_t parent_idx = class->parent - classes;
        fill_class_attributes(AST, classes, parent_idx, allocator);
        inherited_attribute_counts = class->parent->attribute_count;
    }

    // Count how many attributes there are so we can allocate memory
    class->attribute_count = inherited_attribute_counts;
    CoolClass ast_class = AST.classes[class_idx - 5];
    for (int i = 0; i < ast_class.feature_count; i++)
    {
        CoolFeature feature = ast_class.features[i];
        if (feature.is_method) continue;
        class->attribute_count += 1;
    }

    // Allocate memory and copy parent attributes if necessary
    class->attributes = bh_alloc(allocator, sizeof(ClassAttribute) * class->attribute_count);
    if (class->parent)
    {
        memcpy(class->attributes, class->parent->attributes, class->parent->attribute_count * sizeof(ClassAttribute));
    }

    // Fill in all the attributes
    int attribute_idx = 0;
    for (int i = 0; i < ast_class.feature_count; i++)
    {
        CoolFeature feature = ast_class.features[i];
        if (feature.is_method) continue;

        // Check the new attribute doesn't override an inherited or existing attribute
        for (int j = 0; j < inherited_attribute_counts + attribute_idx; j++)
        {
            if (bh_str_equal(class->attributes[j].name, feature.name.name))
            {
                RETURN_ERROR(feature.name.line_num, "Class redefines attribute");
            }
        }

        // Check the new attribute references a type that actually exists
        bool type_valid = false;
        for (int j = 0; j < AST.class_count + 5; j++)
        {
            if (bh_str_equal(classes[j].name, feature.type_name.name))
            {
                type_valid = true;
                break;
            }
        }
        if (!type_valid)
        {
            RETURN_ERROR(feature.type_name.line_num, "Class has attribute with unknown type");
        }

        class->attributes[inherited_attribute_counts + attribute_idx].name = feature.name.name;
        class->attributes[inherited_attribute_counts + attribute_idx].type = feature.type_name.name;
        class->attributes[inherited_attribute_counts + attribute_idx].expr = feature.body;
        attribute_idx += 1;
    }

    class->attributes_filled = true;

    return (CoolError){ 0 };
}

// Fills in a ClassNode's methods based on data from the AST
CoolError fill_class_methods(CoolAST AST, ClassNode* classes, int16_t class_idx, bh_allocator allocator)
{
    ClassNode* class = &classes[class_idx];
    if (class->methods_filled) return (CoolError){ 0 };

    // No attributes for most built-in classes
    if (class_idx < 5)
    {
        class->method_count = 3;
        if (class_idx == 3) class->method_count = 6;
        if (class_idx == 4) class->method_count = 7;
        class->methods = bh_alloc(allocator, sizeof(ClassMethod) * class->method_count);

        // Object methods
        char* abort_buf = bh_alloc(allocator, 5);
        strncpy(abort_buf, "abort", 5);
        bh_str abort_str = (bh_str){ .buf = abort_buf, .len = 5 };
        class->methods[0].name = abort_str;
        class->methods[0].return_type = class->name;
        class->methods[0].inherited_from = classes[0].name;
        char* type_name_buf = bh_alloc(allocator, 9);
        strncpy(type_name_buf, "type_name", 9);
        bh_str type_name_str = (bh_str){ .buf = type_name_buf, .len = 9 };
        class->methods[2].name = type_name_str;
        class->methods[2].return_type = classes[3].name;
        class->methods[2].inherited_from = classes[0].name;
        char* copy_buf = bh_alloc(allocator, 4);
        strncpy(copy_buf, "copy", 4);
        bh_str copy_str = (bh_str){ .buf = copy_buf, .len = 4 };
        char* self_type_buf = bh_alloc(allocator, 9);
        strncpy(self_type_buf, "SELF_TYPE", 9);
        bh_str self_type_str = (bh_str){ .buf = self_type_buf, .len = 9 };
        class->methods[1].name = copy_str;
        class->methods[1].return_type = self_type_str;
        class->methods[1].inherited_from = classes[0].name;

        if (class_idx == 3) // String
        {
            bh_str concat_str = (bh_str){ .buf = bh_alloc(allocator, 6), .len = 6 };
            strncpy(concat_str.buf, "concat", 6);
            bh_str length_str = (bh_str){ .buf = bh_alloc(allocator, 6), .len = 6 };
            strncpy(length_str.buf, "length", 6);
            bh_str substr_str = (bh_str){ .buf = bh_alloc(allocator, 6), .len = 6 };
            strncpy(substr_str.buf, "substr", 6);
            class->methods[3].name = concat_str;
            class->methods[3].inherited_from = class->name;
            class->methods[3].return_type = class->name;
            class->methods[3].parameter_count = 1;
            class->methods[3].parameters = bh_alloc(allocator, sizeof(ClassMethodParameter));
            class->methods[3].parameters[0].name = (bh_str){ .buf = &substr_str.buf[0], .len = 1 };
            class->methods[3].parameters[0].type = class->name;

            class->methods[4].name = length_str;
            class->methods[4].inherited_from = class->name;
            class->methods[4].return_type = classes[2].name;
            class->methods[4].parameter_count = 0;

            class->methods[5].name = substr_str;
            class->methods[5].inherited_from = class->name;
            class->methods[5].return_type = class->name;
            class->methods[5].parameter_count = 2;
            class->methods[5].parameters = bh_alloc(allocator, sizeof(ClassMethodParameter) * 2);
            class->methods[5].parameters[0].name = (bh_str){ .buf = &class->name.buf[3], .len = 1 };
            class->methods[5].parameters[0].type = classes[2].name;
            class->methods[5].parameters[1].name = (bh_str){ .buf = &length_str.buf[0], .len = 1 };
            class->methods[5].parameters[1].type = classes[2].name;
        }
        if (class_idx == 4) // IO
        {
            char* x_str_buf = bh_alloc(allocator, 1);
            x_str_buf[0] = 'x';
            bh_str x_str = (bh_str){ .buf = x_str_buf, .len = 1 };

            bh_str out_string_str = (bh_str){ .buf = bh_alloc(allocator, 10), .len = 10 };
            strncpy(out_string_str.buf, "out_string", 10);
            class->methods[6].name = out_string_str;
            class->methods[6].return_type = self_type_str;
            class->methods[6].inherited_from = class->name;
            class->methods[6].parameter_count = 1;
            class->methods[6].parameters = bh_alloc(allocator, sizeof(ClassMethodParameter));
            class->methods[6].parameters[0].name = x_str;
            class->methods[6].parameters[0].type = classes[3].name;

            bh_str out_int_str = (bh_str){ .buf = bh_alloc(allocator, 7), .len = 7 };
            strncpy(out_int_str.buf, "out_int", 7);
            class->methods[5].name = out_int_str;
            class->methods[5].return_type = self_type_str;
            class->methods[5].inherited_from = class->name;
            class->methods[5].parameter_count = 1;
            class->methods[5].parameters = bh_alloc(allocator, sizeof(ClassMethodParameter) * 1);
            class->methods[5].parameters[0].name = x_str;
            class->methods[5].parameters[0].type = classes[2].name;

            bh_str in_string_str = (bh_str){ .buf = bh_alloc(allocator, 9), .len = 9 };
            strncpy(in_string_str.buf, "in_string", 9);
            class->methods[4].name = in_string_str;
            class->methods[4].return_type = classes[3].name;
            class->methods[4].inherited_from = class->name;

            bh_str in_int_str = (bh_str){ .buf = bh_alloc(allocator, 6), .len = 6 };
            strncpy(in_int_str.buf, "in_int", 6);
            class->methods[3].name = in_int_str;
            class->methods[3].return_type = classes[2].name;
            class->methods[3].inherited_from = class->name;
        }

        class->methods_filled = true;
        return (CoolError){ 0 };
    }

    // Make sure the parent's methods are filled in before we copy them
    int16_t inherited_method_count = 0;
    if (class->parent)
    {
        int16_t parent_idx = class->parent - classes;
        fill_class_methods(AST, classes, parent_idx, allocator);
        inherited_method_count = class->parent->method_count;
    }

    // Count how many methods there are so we can allocate memory
    class->method_count = inherited_method_count;
    CoolClass ast_class = AST.classes[class_idx - 5];
    for (int i = 0; i < ast_class.feature_count; i++)
    {
        CoolFeature feature = ast_class.features[i];
        if (!feature.is_method) continue;
        class->method_count += 1;
    }
    int method_count = class->method_count - inherited_method_count;

    // Allocate memory and copy parent methods if necessary
    class->methods = bh_alloc(allocator, sizeof(ClassMethod) * class->method_count);
    if (class->parent)
    {
        memcpy(class->methods, class->parent->methods, class->parent->method_count * sizeof(ClassMethod));
    }

    // Sort classes by name
    int16_t* sorted_indices = bh_alloc(allocator, method_count * sizeof(int16_t)); // 5 protected classes
    {
        int16_t sorted_count = 0;

        for (int i = 0; i < ast_class.feature_count; i++)
        {
            if (!ast_class.features[i].is_method) continue;
            bool inserted_in_middle = false;
            for (int j = 0; j < sorted_count; j++)
            {
                if (bh_str_cmp(ast_class.features[i].name.name, ast_class.features[sorted_indices[j]].name.name) < 0) {
                    for (int k = sorted_count; k > j; k--) {
                        sorted_indices[k] = sorted_indices[k - 1];
                    }
                    sorted_indices[j] = i;
                    inserted_in_middle = true;
                    break;
                }
            }
            if (!inserted_in_middle)
            {
                sorted_indices[sorted_count] = i;
            }
            sorted_count += 1;
        }
    }

    // Fill in all the methods
    bool is_main = bh_str_equal_lit(class->name, "Main");
    bool main_found = false;
    int method_idx = 0;
    for (int i = 0; i < method_count; i++)
    {
        CoolFeature feature = ast_class.features[sorted_indices[i]];
        if (!feature.is_method) continue;

        // Check the new method doesn't override an inherited or existing method incorrectly
        for (int j = 0; j < inherited_method_count + method_idx; j++)
        {
            if (!bh_str_equal(class->methods[j].name, feature.name.name)) continue;

            if (j >= inherited_method_count && bh_str_equal(class->methods[j].name, feature.name.name))
            {
                RETURN_ERROR(feature.name.line_num, "Duplicate method definition in class");
            }

            if (!bh_str_equal(class->methods[j].return_type, feature.type_name.name))
            {
                RETURN_ERROR(feature.type_name.line_num, "Return type differs between method implementations");
            }
            if (class->methods[j].parameter_count != feature.formal_count)
            {
                RETURN_ERROR(feature.type_name.line_num, "Parameter count differs between method implementations");
            }
            for (int k = 0; k < feature.formal_count; k++)
            {
                if (!bh_str_equal(class->methods[j].parameters[k].type, feature.formals[k].type_name.name))
                {
                    RETURN_ERROR(feature.formals[k].type_name.line_num, "Parameter type differs between method implementations");
                }
            }
        }

        if (bh_str_equal_lit(feature.name.name, "main") && feature.formal_count == 0)
        {
            main_found = true;
        }

        class->methods[inherited_method_count + method_idx].name = feature.name.name;
        class->methods[inherited_method_count + method_idx].inherited_from = class->name;
        class->methods[inherited_method_count + method_idx].return_type = feature.type_name.name;
        class->methods[inherited_method_count + method_idx].body = feature.body;
        class->methods[inherited_method_count + method_idx].parameter_count = feature.formal_count;
        if (feature.formal_count > 0)
        {
            class->methods[inherited_method_count + method_idx].parameters = bh_alloc(allocator, sizeof(ClassMethodParameter) * feature.formal_count);
        }

        // Fill in parameter info
        for (int j = 0; j < feature.formal_count; j++)
        {
            ClassMethodParameter* parameters = class->methods[inherited_method_count + method_idx].parameters;

            // Check that it wasn't used for a previous parameter
            for (int k = 0; k < j; k++)
            {
                if (bh_str_equal(parameters[k].name, feature.formals[j].name.name))
                {
                    RETURN_ERROR(feature.formals[j].name.line_num, "Class has method with duplicate formal parameter");
                }
            }

            parameters[j].name = feature.formals[j].name.name;
            parameters[j].type = feature.formals[j].type_name.name;

            // Check the type is valid
            bool class_valid = false;
            for (int k = 0; k < AST.class_count + 5; k++)
            {
                if (bh_str_equal(classes[k].name, feature.formals[j].type_name.name))
                {
                    class_valid = true;
                    break;
                }
            }

            if (!class_valid)
            {
                RETURN_ERROR(feature.formals[j].type_name.line_num, "Class has a parameter with unknown type");
            }
        }

        method_idx += 1;
    }

    class->methods_filled = true;

    if (is_main && !main_found) RETURN_ERROR(0, "class Main method main not found");

    return (CoolError){ 0 };
}

// This macro does 2 things:
// 1. It automatically fills in the parameters of get_expression_type that don't change (like classes, class_idx)
// 2. It automatically returns the type in case it's an error (hence "try")
#define TRY_GET_EXPRESSION_TYPE(type_name, expression) \
    get_expression_type(ctx, (expression)); \
    if ((type_name).is_error) return (type_name) \

ClassNode find_class_by_name(ClassNode* classes, int16_t class_count, bh_str class_name)
{
    for (int i = 0; i < class_count; i++)
    {
        if (bh_str_equal(classes[i].name, class_name))
        {
            return classes[i];
        }
    }
    return (ClassNode){ 0 };
}

// Checks if subclass is a subtype of the parent class
bool is_class_subtype_of(ClassNode subclass, ClassNode parent_class)
{
    if (bh_str_equal(subclass.name, parent_class.name)) return true;

    ClassNode* parent = subclass.parent;
    while (parent != NULL)
    {
        if (bh_str_equal(parent->name, parent_class.name))
        {
            return true;
        }
        parent = parent->parent;
    }
    return false;
}

bool is_type_subtype_of(ClassNode* classes, int16_t class_count, CoolTypeOrError subtype, CoolTypeOrError parent_type)
{
    ClassNode subclass = { 0 };
    ClassNode parent_class = { 0 };

    for (int i = 0; i < class_count; i++)
    {
        if (bh_str_equal(classes[i].name, subtype.type))
        {
            subclass = classes[i];
        }
        if (bh_str_equal(classes[i].name, parent_type.type))
        {
            parent_class = classes[i];
        }
        if (subclass.name.len && parent_class.name.len)
        {
            break;
        }
    }

    return is_class_subtype_of(subclass, parent_class);
}

// Finds the least upper bound type of 2 types
CoolTypeOrError lub_type(ClassNode a, ClassNode b)
{

}

// Gets the type of an expression or returns an error
CoolTypeOrError get_expression_type(ClassContext ctx, CoolExpression expr)
{
    ClassNode* classes = ctx.classes;
    int16_t class_idx = ctx.class_idx;
    int16_t class_count = ctx.class_count;
    ClassNode class = ctx.classes[ctx.class_idx];
    switch (expr.expression_type)
    {
    case COOL_EXPR_TYPE_DYNAMIC_DISPATCH:
    case COOL_EXPR_TYPE_STATIC_DISPATCH:
    case COOL_EXPR_TYPE_SELF_DISPATCH:
        {
            ClassNode t0;
            CoolExpression* args;
            int16_t args_length;
            bh_str method_name;
            int16_t line_num;

            if (expr.expression_type == COOL_EXPR_TYPE_SELF_DISPATCH)
            {
                t0 = class;
                args = expr.data.self_dispatch.args;
                args_length = expr.data.self_dispatch.args_length;
                method_name = expr.data.self_dispatch.method.name;
                line_num = expr.data.self_dispatch.method.line_num;
            }
            else if (expr.expression_type == COOL_EXPR_TYPE_DYNAMIC_DISPATCH)
            {
                CoolTypeOrError class_type = TRY_GET_EXPRESSION_TYPE(class_type, *expr.data.dynamic_dispatch.e);
                t0 = find_class_by_name(classes, class_count, class_type.type);
                args = expr.data.dynamic_dispatch.args;
                args_length = expr.data.dynamic_dispatch.args_length;
                method_name = expr.data.dynamic_dispatch.method.name;
                line_num = expr.data.dynamic_dispatch.method.line_num;
            }
            else if (expr.expression_type == COOL_EXPR_TYPE_STATIC_DISPATCH)
            {
                CoolTypeOrError expr_type = TRY_GET_EXPRESSION_TYPE(expr_type, *expr.data.static_dispatch.e);
                CoolTypeOrError class_type = (CoolTypeOrError){ .type = expr.data.static_dispatch.type_name.name };
                if (!is_type_subtype_of(classes, class_count, expr_type, class_type))
                {
                    RETURN_TYPE_ERROR(expr.data.static_dispatch.type_name.line_num, "Cannot static dispatch on subtype");
                }
                t0 = find_class_by_name(classes, class_count, class_type.type);
                args = expr.data.static_dispatch.args;
                args_length = expr.data.static_dispatch.args_length;
                method_name = expr.data.static_dispatch.method.name;
                line_num = expr.data.static_dispatch.method.line_num;
            }

            for (int i = 0; i < t0.method_count; i++)
            {
                // Find the method in the method map
                ClassMethod method = t0.methods[i];
                if (!bh_str_equal(method.name, method_name)) continue;

                // Check method arguments count matches parameter count
                if (args_length != method.parameter_count)
                {
                    // TODO: Check line number for error
                    RETURN_TYPE_ERROR(expr.line_num, "Method called with wrong number of arguments");
                }

                // Check each method argument is a subtype of parameter
                for (int j = 0; j < method.parameter_count; j++)
                {
                    CoolTypeOrError argument_type = TRY_GET_EXPRESSION_TYPE(argument_type, args[j]);
                    CoolTypeOrError parameter_type = (CoolTypeOrError){ .type = method.parameters[j].type };
                    if (!is_type_subtype_of(classes, class_count, argument_type, parameter_type))
                    {
                        RETURN_TYPE_ERROR(args[j].line_num, "Method called with argument that is not assignable to parameter");
                    }
                }

                // bh_str tfinal = bh_str_equal_lit(method.return_type, "SELF_TYPE")
                //     ? class.name
                //     : method.return_type;

                bh_str tfinal = method.return_type;

                RETURN_TYPE(tfinal);
            }
            RETURN_TYPE_ERROR(line_num, "No method found with specified name");
        }
    case COOL_EXPR_TYPE_BLOCK:
        {
            CoolTypeOrError last_type;
            for (int i = 0; i < expr.data.block.body_length; i++)
            {
                last_type = TRY_GET_EXPRESSION_TYPE(last_type, expr.data.block.body[i]);
            }
            return last_type;
        }
    case COOL_EXPR_TYPE_IF:
        {
            CoolTypeOrError predicate_type = TRY_GET_EXPRESSION_TYPE(predicate_type, *expr.data.if_expr.predicate);
            if (!bh_str_equal_lit(predicate_type.type, "Bool"))
            {
                RETURN_TYPE_ERROR(expr.data.if_expr.predicate->line_num, "If statement predicate must be bool");
            }
            CoolTypeOrError then_type = TRY_GET_EXPRESSION_TYPE(then_type, *expr.data.if_expr.then_branch);
            CoolTypeOrError else_type = TRY_GET_EXPRESSION_TYPE(else_type, *expr.data.if_expr.else_branch);
            // Implement lub
        }
    case COOL_EXPR_TYPE_PLUS:
    case COOL_EXPR_TYPE_MINUS:
    case COOL_EXPR_TYPE_TIMES:
    case COOL_EXPR_TYPE_DIVIDE:
        {
            CoolTypeOrError expr_type_1 = TRY_GET_EXPRESSION_TYPE(expr_type_1, *expr.data.binary.x);
            CoolTypeOrError expr_type_2 = TRY_GET_EXPRESSION_TYPE(expr_type_2, *expr.data.binary.y);
            if (!bh_str_equal_lit(expr_type_1.type, "Int")) RETURN_TYPE_ERROR(expr.data.binary.x->line_num, "Cannot add non-integer");
            if (!bh_str_equal_lit(expr_type_2.type, "Int")) RETURN_TYPE_ERROR(expr.data.binary.y->line_num, "Cannot add non-integer");
            RETURN_TYPE(expr_type_1.type);
        }
    case COOL_EXPR_TYPE_INTEGER: RETURN_TYPE(classes[2].name);
    case COOL_EXPR_TYPE_STRING:
        RETURN_TYPE(classes[3].name);
    case COOL_EXPR_TYPE_TRUE: RETURN_TYPE(classes[1].name);
    case COOL_EXPR_TYPE_FALSE: RETURN_TYPE(classes[1].name);
    default:
        RETURN_TYPE_ERROR(expr.line_num, "Unhandled type rule");
    }
}

// Appends an identifier as an AST string to a buffer
void identifier_to_str(bh_str_buf* str_buf, CoolIdentifier identifier)
{
    bh_str_buf_append_format(str_buf, "%i\n", identifier.line_num);
    bh_str_buf_append(str_buf, identifier.name);
    bh_str_buf_append_lit(str_buf, "\n");
}

// Appends an expression as an AST string to a buffer
CoolTypeOrError expression_to_str(ClassContext ctx, bh_str_buf* str_buf, CoolExpression expr)
{
    bh_str_buf_append_format(str_buf, "%i\n", expr.line_num);
    CoolTypeOrError expr_type_or_error = get_expression_type(ctx, expr);
    if (expr_type_or_error.is_error) return expr_type_or_error;
    bh_str expr_type = expr_type_or_error.type;
    bh_str_buf_append(str_buf, expr_type);
    bh_str_buf_append_lit(str_buf, "\n");
    switch (expr.expression_type)
    {
    case COOL_EXPR_TYPE_NULL: assert(false); break;
    case COOL_EXPR_TYPE_ASSIGN:
        bh_str_buf_append_lit(str_buf, "assign\n");
        identifier_to_str(str_buf, expr.data.assign.var);
        expression_to_str(ctx, str_buf, *expr.data.assign.rhs);
        break;
    case COOL_EXPR_TYPE_DYNAMIC_DISPATCH:
        bh_str_buf_append_lit(str_buf, "dynamic_dispatch\n");
        expression_to_str(ctx, str_buf, *expr.data.dynamic_dispatch.e);
        identifier_to_str(str_buf, expr.data.dynamic_dispatch.method);
        bh_str_buf_append_format(str_buf, "%i\n", expr.data.dynamic_dispatch.args_length);
        for (int i = 0; i < expr.data.dynamic_dispatch.args_length; i++)
        {
            expression_to_str(ctx, str_buf, expr.data.dynamic_dispatch.args[i]);
        }
        break;
    case COOL_EXPR_TYPE_STATIC_DISPATCH:
        bh_str_buf_append_lit(str_buf, "static_dispatch\n");
        expression_to_str(ctx, str_buf, *expr.data.static_dispatch.e);
        identifier_to_str(str_buf, expr.data.static_dispatch.type_name);
        identifier_to_str(str_buf, expr.data.static_dispatch.method);
        bh_str_buf_append_format(str_buf, "%i\n", expr.data.static_dispatch.args_length);
        for (int i = 0; i < expr.data.static_dispatch.args_length; i++)
        {
            expression_to_str(ctx, str_buf, expr.data.static_dispatch.args[i]);
        }
        break;
    case COOL_EXPR_TYPE_SELF_DISPATCH:
        bh_str_buf_append_lit(str_buf, "self_dispatch\n");
        identifier_to_str(str_buf, expr.data.self_dispatch.method);
        bh_str_buf_append_format(str_buf, "%i\n", expr.data.self_dispatch.args_length);
        for (int i = 0; i < expr.data.self_dispatch.args_length; i++)
        {
            expression_to_str(ctx, str_buf, expr.data.self_dispatch.args[i]);
        }
        break;
    case COOL_EXPR_TYPE_IF:
        bh_str_buf_append_lit(str_buf, "if\n");
        expression_to_str(ctx, str_buf, *expr.data.if_expr.predicate);
        expression_to_str(ctx, str_buf, *expr.data.if_expr.then_branch);
        expression_to_str(ctx, str_buf, *expr.data.if_expr.else_branch);
        break;
    case COOL_EXPR_TYPE_WHILE:
        bh_str_buf_append_lit(str_buf, "while\n");
        expression_to_str(ctx, str_buf, *expr.data.while_expr.predicate);
        expression_to_str(ctx, str_buf, *expr.data.while_expr.body);
        break;
    case COOL_EXPR_TYPE_BLOCK:
        bh_str_buf_append_lit(str_buf, "block\n");
        bh_str_buf_append_format(str_buf, "%i\n", expr.data.block.body_length);
        for (int i = 0; i < expr.data.block.body_length; i++)
        {
            CoolTypeOrError block_expr_type = get_expression_type(ctx, expr.data.block.body[i]);
            if (block_expr_type.is_error) return block_expr_type;
            expression_to_str(ctx, str_buf, expr.data.block.body[i]);
        }
        break;
    case COOL_EXPR_TYPE_NEW:
        bh_str_buf_append_lit(str_buf, "new\n");
        identifier_to_str(str_buf, expr.data.new_expr.class_name);
        break;
    case COOL_EXPR_TYPE_ISVOID:
        bh_str_buf_append_lit(str_buf, "isvoid\n");
        expression_to_str(ctx, str_buf, *expr.data.isvoid.e);
        break;
    case COOL_EXPR_TYPE_PLUS:
    case COOL_EXPR_TYPE_MINUS:
    case COOL_EXPR_TYPE_TIMES:
    case COOL_EXPR_TYPE_DIVIDE:
    case COOL_EXPR_TYPE_LT:
    case COOL_EXPR_TYPE_LE:
    case COOL_EXPR_TYPE_EQ:
        if (expr.expression_type == COOL_EXPR_TYPE_PLUS) bh_str_buf_append_lit(str_buf, "plus\n");
        if (expr.expression_type == COOL_EXPR_TYPE_MINUS) bh_str_buf_append_lit(str_buf, "minus\n");
        if (expr.expression_type == COOL_EXPR_TYPE_TIMES) bh_str_buf_append_lit(str_buf, "times\n");
        if (expr.expression_type == COOL_EXPR_TYPE_DIVIDE) bh_str_buf_append_lit(str_buf, "divide\n");
        if (expr.expression_type == COOL_EXPR_TYPE_LT) bh_str_buf_append_lit(str_buf, "lt\n");
        if (expr.expression_type == COOL_EXPR_TYPE_LE) bh_str_buf_append_lit(str_buf, "le\n");
        if (expr.expression_type == COOL_EXPR_TYPE_EQ) bh_str_buf_append_lit(str_buf, "eq\n");
        expression_to_str(ctx, str_buf, *expr.data.binary.x);
        expression_to_str(ctx, str_buf, *expr.data.binary.y);
        break;
    case COOL_EXPR_TYPE_NOT:
    case COOL_EXPR_TYPE_NEGATE:
        if (expr.expression_type == COOL_EXPR_TYPE_NOT) bh_str_buf_append_lit(str_buf, "not\n");
        if (expr.expression_type == COOL_EXPR_TYPE_NEGATE) bh_str_buf_append_lit(str_buf, "negate\n"); break;
        expression_to_str(ctx, str_buf, *expr.data.unary.x);
        break;
    case COOL_EXPR_TYPE_INTEGER:
        bh_str_buf_append_format(str_buf, "integer\n%i\n", expr.data.integer.value);
        break;
    case COOL_EXPR_TYPE_STRING:
        bh_str_buf_append_lit(str_buf, "string\n");
        bh_str_buf_append(str_buf, expr.data.string.value);
        bh_str_buf_append_lit(str_buf, "\n");
        break;
    case COOL_EXPR_TYPE_IDENTIFIER:
        bh_str_buf_append_lit(str_buf, "identifier\n");
        identifier_to_str(str_buf, expr.data.identifier.variable);
        break;
    case COOL_EXPR_TYPE_TRUE: bh_str_buf_append_lit(str_buf, "true\n"); break;
    case COOL_EXPR_TYPE_FALSE: bh_str_buf_append_lit(str_buf, "false\n"); break;
    case COOL_EXPR_TYPE_LET:
        bh_str_buf_append_lit(str_buf, "let\n");
        bh_str_buf_append_format(str_buf, "%i\n", expr.data.let.binding_count);
        for (int i = 0; i < expr.data.let.binding_count; i++)
        {
            CoolLetBinding binding = expr.data.let.bindings[i];
            if (binding.exp != NULL)
            {
                bh_str_buf_append_lit(str_buf, "let_binding_init\n");
            }
            else
            {
                bh_str_buf_append_lit(str_buf, "let_binding_no_init\n");
            }
            identifier_to_str(str_buf, binding.variable);
            identifier_to_str(str_buf, binding.type_name);
            if (binding.exp != NULL)
            {
                expression_to_str(ctx, str_buf, *binding.exp);
            }
        }
        expression_to_str(ctx, str_buf, *expr.data.let.expr);
        break;
    case COOL_EXPR_TYPE_CASE:
        bh_str_buf_append_lit(str_buf, "case\n");
        expression_to_str(ctx, str_buf, *expr.data.case_expr.expr);
        bh_str_buf_append_format(str_buf, "%i\n", expr.data.case_expr.element_count);
        for (int i = 0; i < expr.data.case_expr.element_count; i++)
        {
            CoolCaseElement element = expr.data.case_expr.elements[i];
            identifier_to_str(str_buf, element.variable);
            identifier_to_str(str_buf, element.type_name);
            expression_to_str(ctx, str_buf, *element.body);
        }
        break;
    default:
        assert(false);
    }

    return (CoolTypeOrError){ 0 };
}

// Detect class inherited cycles using DFS
bool dfs_detect_cycle(ClassNode* node, ClassNode* visited[]) {
    if (node == NULL) return false;

    // Check if node is already in the visited set (cycle detected)
    for (int i = 0; visited[i] != NULL; i++) {
        if (visited[i] == node) {
            return true;
        }
    }

    // Add current node to visited set
    int index = 0;
    while (visited[index] != NULL) index++;
    visited[index] = node;
    visited[index + 1] = NULL;

    // Recurse on parent
    bool has_cycle = dfs_detect_cycle(node->parent, visited);

    // Remove node from visited set
    visited[index] = NULL;

    return has_cycle;
}

// Generate a class map based on an AST
CoolError generate_class_map(CoolAST AST, bh_str file_name, bh_allocator allocator)
{
    int class_count = AST.class_count + 5;
    // Create class nodes
    ClassNode* class_nodes = bh_alloc(allocator, sizeof(ClassNode) * (5 + AST.class_count));
    {
        // Define built-in classes
        class_nodes[0] = (ClassNode){ .name = bh_str_from_cstr("Object"), .parent = 0 };
        class_nodes[1] = (ClassNode){ .name = bh_str_from_cstr("Bool"), .parent = class_nodes };
        class_nodes[2] = (ClassNode){ .name = bh_str_from_cstr("Int"), .parent = class_nodes };
        class_nodes[3] = (ClassNode){ .name = bh_str_from_cstr("String"), .parent = class_nodes };
        class_nodes[4] = (ClassNode){ .name = bh_str_from_cstr("IO"), .parent = class_nodes };

        int named_classes = 5;
        // Fill in all the names first, so we can check for missing classes after
        for (int i = 0; i < AST.class_count; i++)
        {
            if (bh_str_equal_lit(AST.classes[i].name.name, "SELF_TYPE"))
            {
                RETURN_ERROR(AST.classes[i].name.line_num, "Cannot have a class named SELF_TYPE");
            }

            for (int j = 0; j < named_classes; j++)
            {
                if (bh_str_equal(AST.classes[i].name.name, class_nodes[j].name))
                {
                    RETURN_ERROR(AST.classes[i].name.line_num, "Redefinition of class");
                }
            }

            class_nodes[5 + i].name = AST.classes[i].name.name;
            named_classes += 1;
        }

        // Check that for all subclasses, the parent class actually exists and is not protected,
        // otherwise set it to inherit from Object
        for (int i = 0; i < AST.class_count; i++)
        {
            bh_str parent_str = AST.classes[i].inherits.name;
            if (parent_str.len == 0)
            {
                class_nodes[5 + i].parent = &class_nodes[0];
            }
            else
            {
                int parent_class_idx = -1;
                for (int j = 0; j < 5 + AST.class_count; j++)
                {
                    if (bh_str_equal(class_nodes[j].name, parent_str))
                    {
                        parent_class_idx = j;
                        break;
                    }
                }
                if (parent_class_idx == -1)
                {
                    RETURN_ERROR(AST.classes[i].inherits.line_num, "Class inherits from nonexistent class");
                }
                else if (parent_class_idx > 0 && parent_class_idx < 4)
                {
                    RETURN_ERROR(AST.classes[i].inherits.line_num, "Cannot inherit from protected class");
                }
                else
                {
                    class_nodes[5 + i].parent = &class_nodes[parent_class_idx];
                }
            }
        }

        // Check for a main class
        bool main_found = false;
        for (int i = 5; i < 5 + AST.class_count; i++)
        {
            if (bh_str_equal_lit(class_nodes[i].name, "Main"))
            {
                main_found = true;
                break;
            }
        }
        if (!main_found) RETURN_ERROR(0, "No main class found");
    }

    // Sort classes by name
    int16_t* sorted_indices = bh_alloc(allocator, (AST.class_count + 5) * sizeof(int16_t)); // 5 protected classes
    {
        int16_t sorted_count = 0;

        for (int i = 0; i < AST.class_count + 5; i++)
        {
            bool inserted_in_middle = false;
            for (int j = 0; j < sorted_count; j++)
            {
                if (bh_str_cmp(class_nodes[i].name, class_nodes[sorted_indices[j]].name) < 0) {
                    for (int k = sorted_count; k > j; k--) {
                        sorted_indices[k] = sorted_indices[k - 1];
                    }
                    sorted_indices[j] = i;
                    inserted_in_middle = true;
                    break;
                }
            }
            if (!inserted_in_middle)
            {
                sorted_indices[sorted_count] = i;
            }
            sorted_count += 1;
        }
    }

    // Check for inheritance cycles
    {
        ClassNode* visited[100] = { 0 };
        for (int i = 0; i < AST.class_count + 5; i++)
        {
            if (dfs_detect_cycle(&class_nodes[i], visited))
            {
                RETURN_ERROR(0, "Inheritance cycle detected");
            }
        }
    }

    // Filling in class map with attributes and methods
    {
        for (int i = 5; i < AST.class_count + 5; i++)
        {
            CoolError error = fill_class_attributes(AST, class_nodes, i, allocator);
            if (error.valid)
            {
                return error;
            }
        }

        for (int i = 0; i < AST.class_count + 5; i++)
        {
            CoolError error = fill_class_methods(AST, class_nodes, i, allocator);
            if (error.valid)
            {
                return error;
            }
        }
    }

    bh_str_buf str_buf = bh_str_buf_init(GPA, 10000);

    ClassContext class_context = (ClassContext)
    {
        .classes = class_nodes,
        .class_count = class_count,
        .class_idx = 0
    };

    // Write class map to file in order
    if (false)
    {
        bh_str_buf_append_format(&str_buf, "class_map\n%i\n", AST.class_count + 5);
        for (int i = 0; i < 5 + AST.class_count; i++)
        {
            ClassNode class = class_nodes[sorted_indices[i]];
            class_context.class_idx = sorted_indices[i];
            bh_str_buf_append(&str_buf, class.name);
            bh_str_buf_append_format(&str_buf, "\n%i\n", class.attribute_count);
            for (int j = 0; j < class.attribute_count; j++)
            {
                ClassAttribute attr = class.attributes[j];
                bh_str_buf_append_lit(&str_buf, attr.expr.type ? "initializer\n" : "no_initializer\n");
                bh_str_buf_append(&str_buf, attr.name);
                bh_str_buf_append_lit(&str_buf, "\n");
                bh_str_buf_append(&str_buf, attr.type);
                bh_str_buf_append_lit(&str_buf, "\n");
                if (attr.expr.type != COOL_EXPR_TYPE_NULL)
                {
                    CoolTypeOrError result = expression_to_str(class_context, &str_buf, attr.expr);
                    if (result.is_error) return result.error;
                }
            }
        }
    }

    // Write implementation map to file in order
    if (true)
    {
        bh_str_buf_append_format(&str_buf, "implementation_map\n%i\n", AST.class_count + 5);
        for (int i = 0; i < 5 + AST.class_count; i++)
        {
            // Output name and method count
            ClassNode class = class_nodes[sorted_indices[i]];
            class_context.class_idx = sorted_indices[i];
            bh_str_buf_append(&str_buf, class.name);
            bh_str_buf_append_format(&str_buf, "\n%i\n", class.method_count);
            // Iterate over methods
            for (int j = 0; j < class.method_count; j++)
            {
                ClassMethod method = class.methods[j];
                // Output method name and formal count
                bh_str_buf_append(&str_buf, method.name);
                bh_str_buf_append_format(&str_buf, "\n%i\n", method.parameter_count);
                // Iterate over formals
                for (int k = 0; k < method.parameter_count; k++)
                {
                    // Output formal name
                    bh_str_buf_append(&str_buf, method.parameters[k].name);
                    bh_str_buf_append_lit(&str_buf, "\n");
                }
                // Output which class the method was inherited from
                bh_str_buf_append(&str_buf, method.inherited_from);
                bh_str_buf_append_lit(&str_buf, "\n");
                // If a method is internal, it won't have a body
                if (method.body.type == COOL_NODE_TYPE_NULL)
                {
                    bh_str_buf_append_lit(&str_buf, "0\n");
                    // We have to look up the specified return type of the internal method
                    for (int k = 0; k < AST.class_count + 5; k++)
                    {
                        if (bh_str_equal(class_nodes[k].name, method.inherited_from))
                        {
                            // Now we iterate over the class's methods
                            for (int l = 0; l < class_nodes[k].method_count; l++)
                            {
                                if (bh_str_equal(class_nodes[k].methods[l].name, method.name))
                                {
                                    bh_str_buf_append(&str_buf, class_nodes[k].methods[l].return_type);
                                    break;
                                }
                            }
                            break;
                        }
                    }
                    bh_str_buf_append_lit(&str_buf, "\ninternal\n");
                    bh_str_buf_append(&str_buf, method.inherited_from);
                    bh_str_buf_append_lit(&str_buf, ".");
                    bh_str_buf_append(&str_buf, method.name);
                    bh_str_buf_append_lit(&str_buf, "\n");
                }
                else
                {
                    CoolTypeOrError result = expression_to_str(class_context, &str_buf, method.body);
                    if (result.is_error) return result.error;
                }
            }
        }

        char* output_name = bh_alloc(allocator, file_name.len + 10);
        strncpy(output_name, file_name.buf, file_name.len - 3);
        strncpy(output_name + file_name.len - 3, "type", 4);
    }

    // Write parent map to file
    if (false)
    {
        bh_str_buf_append_format(&str_buf, "parent_map\n%i\n", AST.class_count + 5 - 1);
        for (int i = 0; i < 5 + AST.class_count; i++)
        {
            int class_idx = sorted_indices[i];
            if (class_idx == 0) continue; // Object has no parent
            ClassNode class = class_nodes[class_idx];
            bh_str_buf_append(&str_buf, class.name);
            bh_str_buf_append_lit(&str_buf, "\n");
            bh_str_buf_append(&str_buf, class.parent->name);
            bh_str_buf_append_lit(&str_buf, "\n");
        }
    }

    char* output_name = bh_alloc(allocator, file_name.len + 10);
    strncpy(output_name, file_name.buf, file_name.len - 3);
    strncpy(output_name + file_name.len - 3, "type", 4);

    FILE* fptr;
    fptr = fopen(output_name, "wb");
    assert(fptr != NULL);
    fwrite(str_buf.buf, 1, str_buf.len, fptr);
    fclose(fptr);

    bh_str_buf_deinit(&str_buf);

    return (CoolError){ 0 };
}