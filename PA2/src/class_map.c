//
// Created by Brandon Howe on 2/12/25.
//

#include "class_map.h"

#include <assert.h>
#include <stdio.h>
#include <string.h>

typedef struct ClassAttribute
{
    bh_str name;
    bh_str type;
    CoolExpression expr;
} ClassAttribute;

typedef struct ClassNode
{
    bh_str name;
    struct ClassNode* parent;

    int16_t attribute_count;
    ClassAttribute* attributes;
    bool attributes_filled;
} ClassNode;

#define RETURN_ERROR(line_num, message_cstr) return (CoolError){ .valid = true, .line = (line_num), .message = (message_cstr) }

// Fills in a ClassNode based on data from the AST
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

        // Check the new attribute doesn't override an inherited attribute
        for (int j = 0; j < inherited_attribute_counts; j++)
        {
            if (bh_str_equal(class->attributes[j].name, feature.name.name))
            {
                RETURN_ERROR(feature.name.line_num, "Class redefines attribute");
            }
        }

        class->attributes[inherited_attribute_counts + attribute_idx].name = feature.name.name;
        class->attributes[inherited_attribute_counts + attribute_idx].type = feature.type_name.name;
        class->attributes[inherited_attribute_counts + attribute_idx].expr = feature.body;
        attribute_idx += 1;
    }

    class->attributes_filled = true;

    return (CoolError){ 0 };
}

// Appends an identifier as an AST string to a buffer
void identifier_to_str(bh_str_buf* str_buf, CoolIdentifier identifier)
{
    bh_str_buf_append_format(str_buf, "%i\n", identifier.line_num);
    bh_str_buf_append(str_buf, identifier.name);
    bh_str_buf_append_lit(str_buf, "\n");
}

// Appends an expression as an AST string to a buffer
void expression_to_str(bh_str_buf* str_buf, CoolExpression expr)
{
    bh_str_buf_append_format(str_buf, "%i\n", expr.line_num);
    switch (expr.expression_type)
    {
    case COOL_EXPR_TYPE_NULL: assert(false); break;
    case COOL_EXPR_TYPE_ASSIGN:
        bh_str_buf_append_lit(str_buf, "assign\n");
        identifier_to_str(str_buf, expr.data.assign.var);
        expression_to_str(str_buf, *expr.data.assign.rhs);
        break;
    case COOL_EXPR_TYPE_DYNAMIC_DISPATCH:
        bh_str_buf_append_lit(str_buf, "dynamic_dispatch");
        expression_to_str(str_buf, *expr.data.dynamic_dispatch.e);
        identifier_to_str(str_buf, expr.data.dynamic_dispatch.method);
        for (int i = 0; i < expr.data.dynamic_dispatch.args_length; i++)
        {
            expression_to_str(str_buf, expr.data.dynamic_dispatch.args[i]);
        }
        break;
    case COOL_EXPR_TYPE_STATIC_DISPATCH:
        bh_str_buf_append_lit(str_buf, "static_dispatch\n");
        expression_to_str(str_buf, *expr.data.static_dispatch.e);
        identifier_to_str(str_buf, expr.data.static_dispatch.type_name);
        identifier_to_str(str_buf, expr.data.static_dispatch.method);
        for (int i = 0; i < expr.data.static_dispatch.args_length; i++)
        {
            expression_to_str(str_buf, expr.data.static_dispatch.args[i]);
        }
        break;
    case COOL_EXPR_TYPE_SELF_DISPATCH:
        bh_str_buf_append_lit(str_buf, "self_dispatch\n");
        identifier_to_str(str_buf, expr.data.self_dispatch.method);
        for (int i = 0; i < expr.data.self_dispatch.args_length; i++)
        {
            expression_to_str(str_buf, expr.data.self_dispatch.args[i]);
        }
        break;
    case COOL_EXPR_TYPE_IF:
        bh_str_buf_append_lit(str_buf, "if\n");
        expression_to_str(str_buf, *expr.data.if_expr.predicate);
        expression_to_str(str_buf, *expr.data.if_expr.then_branch);
        expression_to_str(str_buf, *expr.data.if_expr.else_branch);
        break;
    case COOL_EXPR_TYPE_WHILE:
        bh_str_buf_append_lit(str_buf, "while\n");
        expression_to_str(str_buf, *expr.data.while_expr.predicate);
        expression_to_str(str_buf, *expr.data.while_expr.body);
        break;
    case COOL_EXPR_TYPE_BLOCK:
        bh_str_buf_append_lit(str_buf, "block\n");
        for (int i = 0; i < expr.data.block.body_length; i++)
        {
            expression_to_str(str_buf, expr.data.block.body[i]);
        }
        break;
    case COOL_EXPR_TYPE_NEW:
        bh_str_buf_append_lit(str_buf, "new\n");
        identifier_to_str(str_buf, expr.data.new_expr.class_name);
        break;
    case COOL_EXPR_TYPE_ISVOID:
        bh_str_buf_append_lit(str_buf, "isvoid\n");
        expression_to_str(str_buf, *expr.data.isvoid.e);
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
        expression_to_str(str_buf, *expr.data.binary.x);
        expression_to_str(str_buf, *expr.data.binary.y);
        break;
    case COOL_EXPR_TYPE_NOT:
    case COOL_EXPR_TYPE_NEGATE:
        if (expr.expression_type == COOL_EXPR_TYPE_NOT) bh_str_buf_append_lit(str_buf, "not\n");
        if (expr.expression_type == COOL_EXPR_TYPE_NEGATE) bh_str_buf_append_lit(str_buf, "negate\n"); break;
        expression_to_str(str_buf, *expr.data.unary.x);
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
                expression_to_str(str_buf, *binding.exp);
            }
        }
        break;
    case COOL_EXPR_TYPE_CASE:
        bh_str_buf_append_lit(str_buf, "case\n");
        expression_to_str(str_buf, *expr.data.case_expr.expr);
        for (int i = 0; i < expr.data.case_expr.element_count; i++)
        {
            CoolCaseElement element = expr.data.case_expr.elements[i];
            identifier_to_str(str_buf, element.variable);
            identifier_to_str(str_buf, element.type_name);
            expression_to_str(str_buf, *element.body);
        }
        break;
    default:
        assert(false);
    }
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
    // Create class nodes
    ClassNode* class_nodes = bh_alloc(allocator, sizeof(ClassNode) * (5 + AST.class_count));
    {
        // Define built-in classes
        class_nodes[0] = (ClassNode){ .name = bh_str_from_cstr("Bool"), .parent = 0 };
        class_nodes[1] = (ClassNode){ .name = bh_str_from_cstr("Int"), .parent = 0 };
        class_nodes[2] = (ClassNode){ .name = bh_str_from_cstr("Object"), .parent = 0 };
        class_nodes[3] = (ClassNode){ .name = bh_str_from_cstr("String"), .parent = 0 };
        class_nodes[4] = (ClassNode){ .name = bh_str_from_cstr("IO"), .parent = 0 };

        // Fill in all the names first, so we can check for missing classes after
        for (int i = 0; i < AST.class_count; i++)
        {
            class_nodes[5 + i].name = AST.classes[i].name.name;
        }

        // Check that for all subclasses, the parent class actually exists and is not protected
        for (int i = 0; i < AST.class_count; i++)
        {
            bh_str parent_str = AST.classes[i].inherits.name;
            if (parent_str.len == 0) continue;
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
            else if (parent_class_idx < 4)
            {
                RETURN_ERROR(AST.classes[i].inherits.line_num, "Cannot inherit from protected class");
            }
            else
            {
                class_nodes[5 + i].parent = &class_nodes[parent_class_idx];
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

    // Filling in class map with attributes
    {
        for (int i = 5; i < AST.class_count + 5; i++)
        {
            CoolError error = fill_class_attributes(AST, class_nodes, i, allocator);
            if (error.valid)
            {
                return error;
            }
        }
    }

    // Write class map to file in order
    {
        bh_str_buf str_buf = bh_str_buf_init(GPA, 1000);

        bh_str_buf_append_format(&str_buf, "class_map\n%i\n", AST.class_count + 5);
        for (int i = 0; i < 5 + AST.class_count; i++)
        {
            ClassNode class = class_nodes[sorted_indices[i]];
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
                if (attr.expr.type)
                {
                    expression_to_str(&str_buf, attr.expr);
                }
            }
        }

        char* output_name = bh_alloc(allocator, file_name.len + 10);
        strncpy(output_name, file_name.buf, file_name.len - 3);
        strncpy(output_name + file_name.len - 3, "type", 4);

        FILE* fptr;
        fptr = fopen(output_name, "w");
        assert(fptr != NULL);

        fwrite(str_buf.buf, 1, str_buf.len, fptr);

        fclose(fptr);
    }

    arena_free_all(allocator);

    return (CoolError){ 0 };
}