//
// Created by Brandon Howe on 2/12/25.
//

#include "type_checker.h"

#include <assert.h>
#include <stdio.h>
#include <string.h>

#define RETURN_ERROR(line_num, message_cstr) return (CoolError){ .valid = true, .line = (line_num), .message = (message_cstr) }

#define RETURN_TYPE(type_str) return (CoolTypeOrError){ .is_error = false, .type = (type_str), .self_type_class = { 0 } }
#define RETURN_SELF_TYPE(type_str, class_name) return (CoolTypeOrError){ .is_error = false, .type = (type_str), .self_type_class = (class_name) }
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

        // Make sure it's not called self
        if (bh_str_equal_lit(feature.name.name, "self"))
        {
            RETURN_ERROR(feature.name.line_num, "Class has an attribute called self");
        }

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
            if (bh_str_equal_lit(feature.type_name.name, "SELF_TYPE"))
            {
                type_valid = true;
                break;
            }
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

    // Define methods for most built-in classes
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
        class->methods[0].return_type = classes[0].name;
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

    // Allocate memory and copy parent methods if necessary
    class->methods = bh_alloc(allocator, sizeof(ClassMethod) * class->method_count);
    memcpy(class->methods, class->parent->methods, sizeof(ClassMethod) * inherited_method_count);

    // Fill in all the methods
    bool is_main = bh_str_equal_lit(class->name, "Main");
    bool main_found = false;
    int method_idx = 0;
    for (int i = 0; i < ast_class.feature_count; i++)
    {
        CoolFeature feature = ast_class.features[i];
        if (!feature.is_method) continue;

        int class_idx = inherited_method_count + method_idx;
        bool overriding = false;

        // Check the new method doesn't override an inherited or existing method incorrectly
        for (int j = 0; j < inherited_method_count + method_idx; j++)
        {
            if (!bh_str_equal(class->methods[j].name, feature.name.name)) continue;

            if (bh_str_equal(class->methods[j].name, feature.name.name))
            {
                if (j >= inherited_method_count)
                {
                    RETURN_ERROR(feature.name.line_num, "Duplicate method definition in class");
                }
                else
                {
                    class_idx = j;
                    overriding = true;
                }
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

        class->methods[class_idx].name = feature.name.name;
        class->methods[class_idx].name_line_num = feature.name.line_num;
        class->methods[class_idx].inherited_from = class->name;
        class->methods[class_idx].return_type = feature.type_name.name;
        class->methods[class_idx].body = feature.body;
        class->methods[class_idx].parameter_count = feature.formal_count;
        if (feature.formal_count > 0)
        {
            class->methods[class_idx].parameters = bh_alloc(allocator, sizeof(ClassMethodParameter) * feature.formal_count);
        }

        // Fill in parameter info
        for (int j = 0; j < feature.formal_count; j++)
        {
            ClassMethodParameter* parameters = class->methods[class_idx].parameters;

            // Make sure it's not called self
            if (bh_str_equal_lit(feature.formals[j].name.name, "self"))
            {
                RETURN_ERROR(feature.formals[j].name.line_num, "Class has method with formal parameter named self");
            }

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

        if (!overriding)
        {
            method_idx += 1;
        }
        else
        {
            class->method_count -= 1;
        }
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

// Gets a ClassNode from a bh_str
ClassNode find_class_by_type(ClassNode* classes, int16_t class_count, CoolTypeOrError type)
{
    bh_str type_name = type.type;
    if (bh_str_equal_lit(type_name, "SELF_TYPE")) type_name = type.self_type_class;

    for (int i = 0; i < class_count; i++)
    {
        if (bh_str_equal(classes[i].name, type_name))
        {
            return classes[i];
        }
    }
    return (ClassNode){ 0 };
}

// Checks if subclass is a subtype of the parent class. Is not called directly and does not support SELF_TYPE directly
bool is_class_subtype_of(ClassNode subclass, ClassNode parent_class)
{
    if (bh_str_equal(subclass.name, parent_class.name)) return true;

    // Walk through the subclass's parents until we find the parent class
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

// Checks if a type is a subtype of another, including support for SELF_TYPE
bool is_type_subtype_of(ClassContext ctx, CoolTypeOrError subtype, CoolTypeOrError parent_type)
{
    ClassNode* classes = ctx.classes;
    int16_t class_count = ctx.class_count;

    ClassNode subclass = { 0 };
    ClassNode parent_class = { 0 };

    // Special rules for SELF_TYPE
    bool subtype_is_self_type = bh_str_equal_lit(subtype.type, "SELF_TYPE");
    bool parent_is_self_type = bh_str_equal_lit(parent_type.type, "SELF_TYPE");

    if (subtype_is_self_type && parent_is_self_type) return true;
    if (!subtype_is_self_type && parent_is_self_type) return false;

    // Find the classes
    for (int i = 0; i < class_count; i++)
    {
        if (bh_str_equal(classes[i].name, subtype_is_self_type ? subtype.self_type_class : subtype.type))
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

// Finds the least upper bound type of 2 classes. Is not called directly
CoolTypeOrError lub_class(ClassNode a, ClassNode b)
{
    // Find the "depth" of each class in the inheritance tree
    int16_t a_depth = 0;
    ClassNode a_depth_tester = a;
    while (!bh_str_equal_lit(a_depth_tester.name, "Object"))
    {
        a_depth += 1;
        a_depth_tester = *a_depth_tester.parent;
    }
    int16_t b_depth = 0;
    ClassNode b_depth_tester = b;
    while (!bh_str_equal_lit(b_depth_tester.name, "Object"))
    {
        b_depth += 1;
        b_depth_tester = *b_depth_tester.parent;
    }

    // Now we find the deepest ancestor of both nodes and start walking up from there
    a_depth_tester = a;
    b_depth_tester = b;
    if (a_depth > b_depth)
    {
        for (int i = 0; i < a_depth - b_depth; i++)
        {
            a_depth_tester = *a_depth_tester.parent;
        }
    }
    else if (a_depth < b_depth)
    {
        for (int i = 0; i < b_depth - a_depth; i++)
        {
            b_depth_tester = *b_depth_tester.parent;
        }
    }

    while (!bh_str_equal(a_depth_tester.name, b_depth_tester.name))
    {
        a_depth_tester = *a_depth_tester.parent;
        b_depth_tester = *b_depth_tester.parent;
    }

    RETURN_TYPE(a_depth_tester.name);
}

// Finds the least upper bound of two types, with support for SELF_TYPE
CoolTypeOrError lub_type(ClassNode* classes, int16_t class_count, CoolTypeOrError a, CoolTypeOrError b)
{
    ClassNode a_class = { 0 };
    ClassNode b_class = { 0 };

    // Custom logic for handling self type
    bool a_is_self_type = bh_str_equal_lit(a.type, "SELF_TYPE");
    bool b_is_self_type = bh_str_equal_lit(b.type, "SELF_TYPE");

    bh_str a_name = a.type;
    bh_str b_name = b.type;

    if (a_is_self_type && b_is_self_type)
    {
        return a;
    }
    if (a_is_self_type) a_name = a.self_type_class;
    if (b_is_self_type) b_name = b.self_type_class;

    for (int i = 0; i < class_count; i++)
    {
        if (bh_str_equal(classes[i].name, a_name))
        {
            a_class = classes[i];
        }
        if (bh_str_equal(classes[i].name, b_name))
        {
            b_class = classes[i];
        }
        if (a_class.name.len && b_class.name.len)
        {
            break;
        }
    }

    return lub_class(a_class, b_class);
}

// Finds the identifier type from the context, or returns an error if it's not there
CoolTypeOrError get_identifier_type_from_context(ClassContext ctx, CoolIdentifier identifier)
{
    if (bh_str_equal_lit(identifier.name, "self"))
    {
        // SELF_TYPE
        RETURN_SELF_TYPE(ctx.classes[0].methods[1].return_type, ctx.classes[ctx.class_idx].name);
    }

    // We check for let bindings first since those will shadow any attributes
    ContextObject* current_node = ctx.object_environment_head;
    while (current_node != NULL)
    {
        if (bh_str_equal(current_node->name, identifier.name))
        {
            RETURN_TYPE(current_node->type);
        }

        current_node = current_node->next;
    }

    // Then we check for attributes in the current class
    ClassNode class = ctx.classes[ctx.class_idx];
    for (int i = 0; i < class.attribute_count; i++)
    {
        if (bh_str_equal(class.attributes[i].name, identifier.name))
        {
            if (bh_str_equal_lit(class.attributes[i].type, "SELF_TYPE"))
            {
                RETURN_SELF_TYPE(class.attributes[i].type, class.name);
            }
            else
            {
                RETURN_TYPE(class.attributes[i].type);
            }
        }
    }

    RETURN_TYPE_ERROR(identifier.line_num, "The identifier could not be found");
}

// Make sure the type actually exists
bool is_type_real(ClassContext ctx, CoolTypeOrError type)
{
    for (int i = 0; i < ctx.class_count; i++)
    {
        if (bh_str_equal(type.type, ctx.classes[i].name))
        {
            return true;
        }
    }
    return false;
}

// Gets the type of an expression or returns an error
CoolTypeOrError get_expression_type(ClassContext ctx, CoolExpression expr)
{
    ClassNode* classes = ctx.classes;
    int16_t class_count = ctx.class_count;
    ClassNode class = ctx.classes[ctx.class_idx];
    // We switch over all the different expression types now
    switch (expr.expression_type)
    {
    case COOL_EXPR_TYPE_ASSIGN:
        {
            CoolTypeOrError t = get_identifier_type_from_context(ctx, expr.data.assign.var);
            if (t.is_error) return t;
            CoolTypeOrError t_prime = TRY_GET_EXPRESSION_TYPE(t_prime, *expr.data.assign.rhs);
            if (!is_type_subtype_of(ctx, t_prime, t))
            {
                RETURN_TYPE_ERROR(expr.line_num, "Assigning value of invalid type to identifier");
            }
            return t_prime;
        }
    case COOL_EXPR_TYPE_IDENTIFIER:
        return get_identifier_type_from_context(ctx, expr.data.identifier.variable);
    case COOL_EXPR_TYPE_LET:
        {
            for (int i = 0; i < expr.data.let.binding_count; i++)
            {
                CoolLetBinding binding = expr.data.let.bindings[i];
                if (bh_str_equal_lit(binding.variable.name, "self"))
                {
                    RETURN_TYPE_ERROR(expr.line_num, "Binding self in a let is not allowed");
                }
                CoolTypeOrError t0 = (CoolTypeOrError){ .type = binding.type_name.name };
                if (!is_type_real(ctx, t0))
                {
                    RETURN_TYPE_ERROR(expr.line_num, "Unknown type annotation");
                }
                if (binding.exp != NULL)
                {
                    CoolTypeOrError t1 = TRY_GET_EXPRESSION_TYPE(t1, *binding.exp);
                    if (!is_type_subtype_of(ctx, t1, t0))
                    {
                        RETURN_TYPE_ERROR(expr.line_num, "Let binding's initialized value is not subtype of parent type");
                    }
                }

                // Allocate the new object into the object environment
                ContextObject* new_object = bh_alloc(ctx.object_environment_allocator, 1);
                new_object->name = binding.variable.name;
                new_object->type = binding.type_name.name;
                new_object->next = ctx.object_environment_head;
                ctx.object_environment_head = new_object;
            }

            CoolTypeOrError t2 = TRY_GET_EXPRESSION_TYPE(t2, *expr.data.let.expr);

            // Free all the allocated objects
            for (int i = 0; i < expr.data.let.binding_count; i++)
            {
                ContextObject* old_head = ctx.object_environment_head;
                ctx.object_environment_head = old_head->next;
                bh_free(ctx.object_environment_allocator, old_head);
            }

            return t2;
        }
    case COOL_EXPR_TYPE_DYNAMIC_DISPATCH:
    case COOL_EXPR_TYPE_STATIC_DISPATCH:
    case COOL_EXPR_TYPE_SELF_DISPATCH:
        {
            ClassNode t0;
            CoolExpression* args;
            int16_t args_length;
            bh_str method_name;

            // It's also a self dispatch if we are dynamically dispatching on SELF_TYPE
            bool effectively_self_dispatch = expr.expression_type == COOL_EXPR_TYPE_SELF_DISPATCH;

            // These are mostly the same. The code is different to handle different tagged union branches and SELF_TYPE
            if (expr.expression_type == COOL_EXPR_TYPE_SELF_DISPATCH)
            {
                t0 = class;
                args = expr.data.self_dispatch.args;
                args_length = expr.data.self_dispatch.args_length;
                method_name = expr.data.self_dispatch.method.name;
            }
            else if (expr.expression_type == COOL_EXPR_TYPE_DYNAMIC_DISPATCH)
            {
                CoolTypeOrError class_type = TRY_GET_EXPRESSION_TYPE(class_type, *expr.data.dynamic_dispatch.e);
                if (bh_str_equal_lit(class_type.type, "SELF_TYPE") && bh_str_equal(class_type.self_type_class, class.name))
                {
                    effectively_self_dispatch = true;
                }
                t0 = find_class_by_type(classes, class_count, class_type);
                if (t0.name.len == 0) RETURN_TYPE_ERROR(expr.line_num, "Unknown class in dispatch");
                args = expr.data.dynamic_dispatch.args;
                args_length = expr.data.dynamic_dispatch.args_length;
                method_name = expr.data.dynamic_dispatch.method.name;
            }
            else if (expr.expression_type == COOL_EXPR_TYPE_STATIC_DISPATCH)
            {
                CoolTypeOrError expr_type = TRY_GET_EXPRESSION_TYPE(expr_type, *expr.data.static_dispatch.e);
                CoolTypeOrError class_type = (CoolTypeOrError){ .type = expr.data.static_dispatch.type_name.name };
                if (!is_type_subtype_of(ctx, expr_type, class_type))
                {
                    RETURN_TYPE_ERROR(expr.line_num, "Cannot static dispatch on subtype");
                }
                t0 = find_class_by_type(classes, class_count, class_type);
                if (t0.name.len == 0) RETURN_TYPE_ERROR(expr.line_num, "Unkonwn class in static dispatch");
                args = expr.data.static_dispatch.args;
                args_length = expr.data.static_dispatch.args_length;
                method_name = expr.data.static_dispatch.method.name;
            }

            for (int i = 0; i < t0.method_count; i++)
            {
                // Find the method in the method map
                ClassMethod method = t0.methods[i];
                if (!bh_str_equal(method.name, method_name)) continue;

                // Check method arguments count matches parameter count
                if (args_length != method.parameter_count)
                {
                    RETURN_TYPE_ERROR(expr.line_num, "Method called with wrong number of arguments");
                }

                // Check each method argument is a subtype of parameter
                for (int j = 0; j < method.parameter_count; j++)
                {
                    CoolTypeOrError argument_type = TRY_GET_EXPRESSION_TYPE(argument_type, args[j]);
                    CoolTypeOrError parameter_type = (CoolTypeOrError){ .type = method.parameters[j].type };
                    if (!is_type_subtype_of(ctx, argument_type, parameter_type))
                    {
                        RETURN_TYPE_ERROR(expr.line_num, "Method called with argument that is not assignable to parameter");
                    }
                }

                bh_str tfinal = method.return_type;
                if (bh_str_equal_lit(method.return_type, "SELF_TYPE"))
                {
                    if (effectively_self_dispatch)
                    {
                        RETURN_SELF_TYPE(tfinal, t0.name);
                    }
                    else
                    {
                        RETURN_TYPE(t0.name);
                    }
                }
                else
                {
                    RETURN_TYPE(tfinal);
                }
            }
            RETURN_TYPE_ERROR(expr.line_num, "No method found with specified name");
        }
    case COOL_EXPR_TYPE_BLOCK:
        {
            // Return the type of the last expression
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
                RETURN_TYPE_ERROR(expr.line_num, "If statement predicate must be bool");
            }
            CoolTypeOrError then_type = TRY_GET_EXPRESSION_TYPE(then_type, *expr.data.if_expr.then_branch);
            CoolTypeOrError else_type = TRY_GET_EXPRESSION_TYPE(else_type, *expr.data.if_expr.else_branch);
            return lub_type(classes, class_count, then_type, else_type);
        }
    case COOL_EXPR_TYPE_CASE:
        {
            CoolTypeOrError t0 = TRY_GET_EXPRESSION_TYPE(t0, *expr.data.case_expr.expr);
            CoolTypeOrError tfinal = (CoolTypeOrError){ 0 };
            for (int i = 0; i < expr.data.case_expr.element_count; i++)
            {
                CoolCaseElement element = expr.data.case_expr.elements[i];

                // Make sure SELF_TYPE is not allowed
                if (bh_str_equal_lit(element.type_name.name, "SELF_TYPE"))
                {
                    RETURN_TYPE_ERROR(expr.line_num, "SELF_TYPE is not allowed in case statement");
                }

                // Make sure the case branch isn't bound multiple times
                for (int j = 0; j < i; j++)
                {
                    CoolCaseElement prev_element = expr.data.case_expr.elements[j];

                    if (bh_str_equal(prev_element.type_name.name, element.type_name.name))
                    {
                        RETURN_TYPE_ERROR(expr.line_num, "Case branch is bound multiple times");
                    }
                }

                // Make sure identifiers are bound in the scope
                ContextObject* new_object = bh_alloc(ctx.object_environment_allocator, 1);
                new_object->name = element.variable.name;
                new_object->type = element.type_name.name;
                new_object->next = ctx.object_environment_head;
                ctx.object_environment_head = new_object;

                CoolTypeOrError t1 = TRY_GET_EXPRESSION_TYPE(t1, *element.body);

                // And free them when we're done
                ContextObject* old_head = ctx.object_environment_head;
                ctx.object_environment_head = old_head->next;
                bh_free(ctx.object_environment_allocator, old_head);

                if (tfinal.type.len == 0)
                {
                    tfinal = t1;
                }
                else
                {
                    tfinal = lub_type(classes, class_count, t1, tfinal);
                }
            }
            return tfinal;
        }
    case COOL_EXPR_TYPE_WHILE:
        {
            CoolTypeOrError predicate_type = TRY_GET_EXPRESSION_TYPE(predicate_type, *expr.data.while_expr.predicate);
            if (!bh_str_equal_lit(predicate_type.type, "Bool"))
            {
                RETURN_TYPE_ERROR(expr.line_num, "Loop predicate must be bool");
            }
            CoolTypeOrError t2 = TRY_GET_EXPRESSION_TYPE(t2, *expr.data.while_expr.body);
            RETURN_TYPE(classes[0].name);
        }
    case COOL_EXPR_TYPE_NEW:
        {
            bh_str t_prime = expr.data.new_expr.class_name.name;
            if (bh_str_equal_lit(t_prime, "SELF_TYPE"))
            {
                RETURN_SELF_TYPE(t_prime, class.name);
            }
            RETURN_TYPE(t_prime);
        }
    case COOL_EXPR_TYPE_PLUS:
    case COOL_EXPR_TYPE_MINUS:
    case COOL_EXPR_TYPE_TIMES:
    case COOL_EXPR_TYPE_DIVIDE:
        {
            CoolTypeOrError expr_type_1 = TRY_GET_EXPRESSION_TYPE(expr_type_1, *expr.data.binary.x);
            CoolTypeOrError expr_type_2 = TRY_GET_EXPRESSION_TYPE(expr_type_2, *expr.data.binary.y);
            if (!bh_str_equal_lit(expr_type_1.type, "Int")) RETURN_TYPE_ERROR(expr.line_num, "Cannot add non-integer");
            if (!bh_str_equal_lit(expr_type_2.type, "Int")) RETURN_TYPE_ERROR(expr.line_num, "Cannot add non-integer");
            RETURN_TYPE(expr_type_1.type);
        }
    case COOL_EXPR_TYPE_EQ:
    case COOL_EXPR_TYPE_LT:
    case COOL_EXPR_TYPE_LE:
        {
            CoolTypeOrError expr_type_1 = TRY_GET_EXPRESSION_TYPE(expr_type_1, *expr.data.binary.x);
            CoolTypeOrError expr_type_2 = TRY_GET_EXPRESSION_TYPE(expr_type_2, *expr.data.binary.y);
            bool t1_is_int = bh_str_equal_lit(expr_type_1.type, "Int");
            bool t1_is_bool = bh_str_equal_lit(expr_type_1.type, "Bool");
            bool t1_is_string = bh_str_equal_lit(expr_type_1.type, "String");
            bool t2_is_int = bh_str_equal_lit(expr_type_2.type, "Int");
            bool t2_is_bool = bh_str_equal_lit(expr_type_2.type, "Bool");
            bool t2_is_string = bh_str_equal_lit(expr_type_2.type, "String");
            // Non-primitive classes can be compared freely
            if (!t1_is_int && !t1_is_bool && !t1_is_string && !t2_is_int && !t2_is_bool && !t2_is_string)
            {
                RETURN_TYPE(classes[1].name);
            }
            // Primitive classes must be the same
            if (!bh_str_equal(expr_type_1.type, expr_type_2.type))
            {
                RETURN_TYPE_ERROR(expr.line_num, "Different primitive types cannot be compared");
            }

            RETURN_TYPE(classes[1].name);
        }
    case COOL_EXPR_TYPE_NOT:
        {
            CoolTypeOrError expr_type = TRY_GET_EXPRESSION_TYPE(expr_type, *expr.data.unary.x);
            if (!bh_str_equal_lit(expr_type.type, "Bool")) RETURN_TYPE_ERROR(expr.line_num, "Cannot take not of non-bool");
            RETURN_TYPE(expr_type.type);
        }
    case COOL_EXPR_TYPE_NEGATE:
        {
            CoolTypeOrError expr_type = TRY_GET_EXPRESSION_TYPE(expr_type, *expr.data.unary.x);
            if (!bh_str_equal_lit(expr_type.type, "Int")) RETURN_TYPE_ERROR(expr.line_num, "Cannot take negation of non-int");
            RETURN_TYPE(expr_type.type);
        }
    case COOL_EXPR_TYPE_ISVOID:
        {
            // We still need to type check the expression even if we don't use it
            CoolTypeOrError t1 = TRY_GET_EXPRESSION_TYPE(t1, *expr.data.isvoid.e);
            RETURN_TYPE(classes[1].name);
        }
    case COOL_EXPR_TYPE_INTEGER: RETURN_TYPE(classes[2].name);
    case COOL_EXPR_TYPE_STRING: RETURN_TYPE(classes[3].name);
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

// These name concat macros aren't important, it's just to get C to concatenate __LINE__ as
// a line number and not a literal. TRY_EXPRESSION_TO_STR is the important one
#define NAME_CONCAT2(a, b) a##b
#define NAME_CONCAT(a, b) NAME_CONCAT2(a, b)
#define TRY_EXPRESSION_TO_STR(expression, provided_type) CoolTypeOrError NAME_CONCAT(result, __LINE__) = expression_to_str(ctx, str_buf, (provided_type), (expression)); if (NAME_CONCAT(result, __LINE__).is_error) return NAME_CONCAT(result, __LINE__)

// Appends an expression as an AST string to a buffer
CoolTypeOrError expression_to_str(ClassContext ctx, bh_str_buf* str_buf, bh_str provided_type, CoolExpression expr)
{
    bh_str_buf_append_format(str_buf, "%i\n", expr.line_num);
    // We do all the type checking up front, but then we also
    // type check the subexpressions later. It's a bit redundant
    CoolTypeOrError expr_type_or_error = get_expression_type(ctx, expr);
    if (provided_type.len == 0 && expr_type_or_error.is_error) return expr_type_or_error;
    bh_str expr_type = provided_type.len == 0 ? expr_type_or_error.type : provided_type;
    bh_str_buf_append(str_buf, expr_type);
    bh_str_buf_append_lit(str_buf, "\n");
    switch (expr.expression_type)
    {
    case COOL_EXPR_TYPE_NULL: assert(false); break;
    case COOL_EXPR_TYPE_ASSIGN:
        bh_str_buf_append_lit(str_buf, "assign\n");
        identifier_to_str(str_buf, expr.data.assign.var);
        expression_to_str(ctx, str_buf, (bh_str){ 0 }, *expr.data.assign.rhs);
        break;
    case COOL_EXPR_TYPE_DYNAMIC_DISPATCH:
        bh_str_buf_append_lit(str_buf, "dynamic_dispatch\n");
        expression_to_str(ctx, str_buf, (bh_str){ 0 }, *expr.data.dynamic_dispatch.e);
        identifier_to_str(str_buf, expr.data.dynamic_dispatch.method);
        bh_str_buf_append_format(str_buf, "%i\n", expr.data.dynamic_dispatch.args_length);
        for (int i = 0; i < expr.data.dynamic_dispatch.args_length; i++)
        {
            expression_to_str(ctx, str_buf, (bh_str){ 0 }, expr.data.dynamic_dispatch.args[i]);
        }
        break;
    case COOL_EXPR_TYPE_STATIC_DISPATCH:
        bh_str_buf_append_lit(str_buf, "static_dispatch\n");
        expression_to_str(ctx, str_buf, (bh_str){ 0 }, *expr.data.static_dispatch.e);
        identifier_to_str(str_buf, expr.data.static_dispatch.type_name);
        identifier_to_str(str_buf, expr.data.static_dispatch.method);
        bh_str_buf_append_format(str_buf, "%i\n", expr.data.static_dispatch.args_length);
        for (int i = 0; i < expr.data.static_dispatch.args_length; i++)
        {
            expression_to_str(ctx, str_buf, (bh_str){ 0 }, expr.data.static_dispatch.args[i]);
        }
        break;
    case COOL_EXPR_TYPE_SELF_DISPATCH:
        bh_str_buf_append_lit(str_buf, "self_dispatch\n");
        identifier_to_str(str_buf, expr.data.self_dispatch.method);
        bh_str_buf_append_format(str_buf, "%i\n", expr.data.self_dispatch.args_length);
        for (int i = 0; i < expr.data.self_dispatch.args_length; i++)
        {
            expression_to_str(ctx, str_buf, (bh_str){ 0 }, expr.data.self_dispatch.args[i]);
        }
        break;
    case COOL_EXPR_TYPE_IF:
        bh_str_buf_append_lit(str_buf, "if\n");
        expression_to_str(ctx, str_buf, (bh_str){ 0 }, *expr.data.if_expr.predicate);
        expression_to_str(ctx, str_buf, (bh_str){ 0 }, *expr.data.if_expr.then_branch);
        expression_to_str(ctx, str_buf, (bh_str){ 0 }, *expr.data.if_expr.else_branch);
        break;
    case COOL_EXPR_TYPE_WHILE:
        bh_str_buf_append_lit(str_buf, "while\n");
        expression_to_str(ctx, str_buf, (bh_str){ 0 }, *expr.data.while_expr.predicate);
        expression_to_str(ctx, str_buf, (bh_str){ 0 }, *expr.data.while_expr.body);
        break;
    case COOL_EXPR_TYPE_BLOCK:
        bh_str_buf_append_lit(str_buf, "block\n");
        bh_str_buf_append_format(str_buf, "%i\n", expr.data.block.body_length);
        for (int i = 0; i < expr.data.block.body_length; i++)
        {
            CoolTypeOrError block_expr_type = get_expression_type(ctx, expr.data.block.body[i]);
            if (block_expr_type.is_error) return block_expr_type;
            TRY_EXPRESSION_TO_STR(expr.data.block.body[i], block_expr_type.type);
        }
        break;
    case COOL_EXPR_TYPE_NEW:
        bh_str_buf_append_lit(str_buf, "new\n");
        identifier_to_str(str_buf, expr.data.new_expr.class_name);
        break;
    case COOL_EXPR_TYPE_ISVOID:
        bh_str_buf_append_lit(str_buf, "isvoid\n");
        expression_to_str(ctx, str_buf, (bh_str){ 0 }, *expr.data.isvoid.e);
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
        if (expr.expression_type >= COOL_EXPR_TYPE_PLUS && expr.expression_type <= COOL_EXPR_TYPE_DIVIDE)
        {
            TRY_EXPRESSION_TO_STR(*expr.data.binary.x, bh_str_from_cstr("Int"));
            TRY_EXPRESSION_TO_STR(*expr.data.binary.y, bh_str_from_cstr("Int"));
        }
        else
        {
            expression_to_str(ctx, str_buf, (bh_str){ 0 }, *expr.data.binary.x);
            expression_to_str(ctx, str_buf, (bh_str){ 0 }, *expr.data.binary.y);
        }
        break;
    case COOL_EXPR_TYPE_NOT:
    case COOL_EXPR_TYPE_NEGATE:
        if (expr.expression_type == COOL_EXPR_TYPE_NOT) bh_str_buf_append_lit(str_buf, "not\n");
        if (expr.expression_type == COOL_EXPR_TYPE_NEGATE) bh_str_buf_append_lit(str_buf, "negate\n");
        expression_to_str(ctx, str_buf, (bh_str){ 0 }, *expr.data.unary.x);
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
                expression_to_str(ctx, str_buf, (bh_str){ 0 }, *binding.exp);
            }

            // Allocate the new object into the object environment
            ContextObject* new_object = bh_alloc(ctx.object_environment_allocator, 1);
            new_object->name = binding.variable.name;
            new_object->type = binding.type_name.name;
            new_object->next = ctx.object_environment_head;
            ctx.object_environment_head = new_object;
        }
        TRY_EXPRESSION_TO_STR(*expr.data.let.expr, (bh_str){ 0 });

        // Free all the allocated objects
        for (int i = 0; i < expr.data.let.binding_count; i++)
        {
            ContextObject* old_head = ctx.object_environment_head;
            ctx.object_environment_head = old_head->next;
            bh_free(ctx.object_environment_allocator, old_head);
        }
        break;
    case COOL_EXPR_TYPE_CASE:
        bh_str_buf_append_lit(str_buf, "case\n");
        expression_to_str(ctx, str_buf, (bh_str){ 0 }, *expr.data.case_expr.expr);
        bh_str_buf_append_format(str_buf, "%i\n", expr.data.case_expr.element_count);
        for (int i = 0; i < expr.data.case_expr.element_count; i++)
        {
            CoolCaseElement element = expr.data.case_expr.elements[i];
            identifier_to_str(str_buf, element.variable);
            identifier_to_str(str_buf, element.type_name);

            // Allocate the new object into the object environment
            ContextObject* new_object = bh_alloc(ctx.object_environment_allocator, 1);
            new_object->name = element.variable.name;
            new_object->type = element.type_name.name;
            new_object->next = ctx.object_environment_head;
            ctx.object_environment_head = new_object;

            expression_to_str(ctx, str_buf, (bh_str){ 0 }, *element.body);

            // Free its memory
            ContextObject* old_head = ctx.object_environment_head;
            ctx.object_environment_head = old_head->next;
            bh_free(ctx.object_environment_allocator, old_head);
        }
        break;
    default:
        assert(false);
    }

    if (bh_str_equal_lit(expr_type, "SELF_TYPE") && expr_type_or_error.self_type_class.len)
    {
        RETURN_SELF_TYPE(expr_type, expr_type_or_error.self_type_class);
    }
    if (bh_str_equal_lit(expr_type, "SELF_TYPE") && !expr_type_or_error.self_type_class.len)
    {
        RETURN_SELF_TYPE(expr_type, ctx.classes[ctx.class_idx].name);
        // RETURN_SELF_TYPE(expr_type, expr_type_or_error.self_type_class);
    }
    RETURN_TYPE(expr_type);
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
    bh_allocator object_environment_allocator = pool_init(sizeof(ContextObject) * 1000, sizeof(ContextObject));

    ClassContext class_context = (ClassContext)
    {
        .classes = class_nodes,
        .class_count = class_count,
        .class_idx = 0,
        .object_environment_head = NULL,
        .object_environment_allocator = object_environment_allocator
    };

    if (true) // Write class map to file in order
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
                    CoolTypeOrError result = expression_to_str(class_context, &str_buf, (bh_str){ 0 }, attr.expr);
                    if (result.is_error) return result.error;
                }
            }
        }
    }

    if (true) // Write implementation map to file in order
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
                class_context.method_idx = j;
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
                    // Allocate the new formals into the object environment
                    for (int k = 0; k < method.parameter_count; k++)
                    {
                        ContextObject* new_object = bh_alloc(class_context.object_environment_allocator, 1);
                        new_object->name = method.parameters[k].name;
                        new_object->type = method.parameters[k].type;
                        new_object->next = class_context.object_environment_head;
                        class_context.object_environment_head = new_object;
                    }

                    CoolTypeOrError result = expression_to_str(class_context, &str_buf, (bh_str){ 0 }, method.body);
                    if (result.is_error) return result.error;

                    if (!is_type_subtype_of(class_context, result, (CoolTypeOrError){ .type = method.return_type }))
                    {
                        RETURN_ERROR(method.name_line_num, "Method body type does not conform");
                    }

                    // Free the formals
                    for (int k = 0; k < method.parameter_count; k++)
                    {
                        ContextObject* old_head = class_context.object_environment_head;
                        class_context.object_environment_head = old_head->next;
                        bh_free(class_context.object_environment_allocator, old_head);
                    }

                    if (result.is_error) return result.error;
                }
            }
        }

        char* output_name = bh_alloc(allocator, file_name.len + 10);
        strncpy(output_name, file_name.buf, file_name.len - 3);
        strncpy(output_name + file_name.len - 3, "type", 4);
    }

    if (true) // Write parent map to file
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

    if (true) // Write the annotated AST
    {
        bh_str_buf_append_format(&str_buf, "%i\n", AST.class_count);
        for (int i = 0; i < AST.class_count; i++)
        {
            CoolClass class = AST.classes[i];
            class_context.class_idx = i + 5;
            identifier_to_str(&str_buf, class.name);
            if (class.inherits.type)
            {
                bh_str_buf_append_lit(&str_buf, "inherits\n");
                identifier_to_str(&str_buf, class.inherits);
            }
            else
            {
                bh_str_buf_append_lit(&str_buf, "no_inherits\n");
            }

            bh_str_buf_append_format(&str_buf, "%i\n", class.feature_count);
            int method_idx = 0;
            for (int j = 0; j < class.feature_count; j++)
            {
                CoolFeature feature = class.features[j];
                class_context.method_idx = method_idx;
                if (feature.is_method)
                {
                    bh_str_buf_append_lit(&str_buf, "method\n");
                }
                else if (feature.body.type)
                {
                    bh_str_buf_append_lit(&str_buf, "attribute_init\n");
                }
                else
                {
                    bh_str_buf_append_lit(&str_buf, "attribute_no_init\n");
                }
                identifier_to_str(&str_buf, feature.name);
                if (feature.is_method)
                {
                    bh_str_buf_append_format(&str_buf, "%i\n", feature.formal_count);
                    for (int k = 0; k < feature.formal_count; k++)
                    {
                        identifier_to_str(&str_buf, feature.formals[k].name);
                        identifier_to_str(&str_buf, feature.formals[k].type_name);
                    }
                }
                identifier_to_str(&str_buf, feature.type_name);
                if (feature.is_method || feature.body.type)
                {
                    // Allocate the new formals into the object environment
                    for (int k = 0; k < feature.formal_count; k++)
                    {
                        ContextObject* new_object = bh_alloc(class_context.object_environment_allocator, 1);
                        new_object->name = feature.formals[k].name.name;
                        new_object->type = feature.formals[k].type_name.name;
                        new_object->next = class_context.object_environment_head;
                        class_context.object_environment_head = new_object;
                    }

                    CoolTypeOrError result = expression_to_str(class_context, &str_buf, (bh_str){ 0 }, feature.body);
                    if (!feature.is_method)
                    {
                        if (!is_type_subtype_of(class_context, result, (CoolTypeOrError){ .type = feature.type_name.name }))
                        {
                            RETURN_ERROR(feature.name.line_num, "Initialized attribute value does not conform to type");
                        }
                    }

                    // Free the formals from the object environment
                    for (int k = 0; k < feature.formal_count; k++)
                    {
                        ContextObject* old_head = class_context.object_environment_head;
                        class_context.object_environment_head = old_head->next;
                        bh_free(class_context.object_environment_allocator, old_head);
                    }
                    if (result.is_error) return result.error;
                    if (feature.is_method) method_idx += 1;
                }
            }
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