//
// Created by Brandon Howe on 3/5/25.
//

#include "ast.h"

#include <alloca.h>
#include <assert.h>
#include <stddef.h>

ClassNodeList parse_class_map(bh_str* str, bh_allocator allocator)
{
    bh_str class_map_word = eat_until_newline(str);
    assert(bh_str_equal_lit(class_map_word, "class_map"));

    int class_map_count = eat_uint_until_newline(str);

    ClassNodeList list = (ClassNodeList){
        .class_count = class_map_count,
        .class_nodes = bh_alloc(allocator, class_map_count * sizeof(ClassNode))
    };

    for (int i = 0; i < class_map_count; i++)
    {
        bh_str class_name = eat_until_newline(str);
        list.class_nodes[i].name = class_name;
        int attribute_count = eat_uint_until_newline(str);
        list.class_nodes[i].attribute_count = attribute_count;
        list.class_nodes[i].attributes = bh_alloc(allocator, attribute_count * sizeof(ClassAttribute));
        for (int j = 0; j < attribute_count; j++)
        {
            bh_str initializer_status = eat_until_newline(str);
            bh_str attribute_name = eat_until_newline(str);
            bh_str type_name = eat_until_newline(str);
            list.class_nodes[i].attributes[j].name = attribute_name;
            list.class_nodes[i].attributes[j].type = type_name;
            if (bh_str_equal_lit(initializer_status, "initializer"))
            {
                CoolExpression expression = parse_expression(str, allocator);
                list.class_nodes[i].attributes[j].expr = expression;
            }
        }

        list.class_nodes[i].attributes_filled = true;
    }

    return list;
}

void parse_implementation_map(bh_str* str, bh_allocator allocator, ClassNodeList list)
{
    bh_str implementation_map_word = eat_until_newline(str);
    assert(bh_str_equal_lit(implementation_map_word, "implementation_map"));

    int implementation_map_count = eat_uint_until_newline(str);

    for (int i = 0; i < implementation_map_count; i++)
    {
        bh_str class_name = eat_until_newline(str);
        int method_count = eat_uint_until_newline(str);
        list.class_nodes[i].method_count = method_count;
        list.class_nodes[i].methods = bh_alloc(allocator, sizeof(ClassMethod) * method_count);
        for (int j = 0; j < method_count; j++)
        {
            bh_str method_name = eat_until_newline(str);
            list.class_nodes[i].methods[j].name = method_name;
            int formal_count = eat_uint_until_newline(str);
            list.class_nodes[i].methods[j].parameter_count = formal_count;
            list.class_nodes[i].methods[j].parameters = bh_alloc(allocator, sizeof(ClassMethodParameter) * formal_count);
            for (int k = 0; k < formal_count; k++)
            {
                bh_str formal_name = eat_until_newline(str);
                list.class_nodes[i].methods[j].parameters[k].name = formal_name;
            }
            bh_str inherited_from = eat_until_newline(str);
            list.class_nodes[i].methods[j].inherited_from = inherited_from;
            CoolExpression expression = parse_expression(str, allocator);
            list.class_nodes[i].methods[j].body = expression;
        }
    }
}

void parse_parent_map(bh_str* str, bh_allocator allocator, ClassNodeList list)
{
    bh_str parent_map_word = eat_until_newline(str);
    assert(bh_str_equal_lit(parent_map_word, "parent_map"));

    int relation_count = eat_uint_until_newline(str);

    for (int i = 0; i < relation_count; i++)
    {
        bh_str child_name = eat_until_newline(str);
        bh_str parent_name = eat_until_newline(str);

        for (int j = 0; j < list.class_count; j++)
        {
            if (bh_str_equal(list.class_nodes[j].name, child_name))
            {
                int64_t parent_idx = 0;
                for (int k = 0; k < list.class_count; k++)
                {
                    if (bh_str_equal(list.class_nodes[k].name, parent_name))
                    {
                        parent_idx = k;
                        break;
                    }
                }
                list.class_nodes[j].parent = &list.class_nodes[parent_idx];
                break;
            }
        }
    }
}

CoolAST parse_ast(bh_str* str, bh_allocator allocator)
{
    CoolAST AST = (CoolAST){ .type = COOL_NODE_TYPE_AST };

    int class_count = eat_uint_until_newline(str);

    AST.class_count = class_count;
    AST.classes = bh_alloc(allocator, class_count * sizeof(CoolClass));

    for (int i = 0; i < class_count; i++)
    {
        AST.classes[i] = parse_class(str, allocator);
    }

    return AST;
}

CoolClass parse_class(bh_str* str, bh_allocator allocator)
{
    CoolClass class = (CoolClass){ .type = COOL_NODE_TYPE_CLASS };

    class.name = parse_identifier(str);

    bh_str next_line = eat_until_newline(str);
    if (bh_str_equal(next_line, bh_str_from_cstr("inherits")))
    {
        class.inherits = parse_identifier(str);
    }

    class.feature_count = eat_uint_until_newline(str);
    class.features = bh_alloc(allocator, class.feature_count * sizeof(CoolFeature));

    for (int i = 0; i < class.feature_count; i++)
    {
        class.features[i] = parse_feature(str, allocator);
    }

    return class;
}

CoolIdentifier parse_identifier(bh_str* str)
{
    CoolIdentifier identifier = (CoolIdentifier){ .type = COOL_NODE_TYPE_IDENTIFIER };
    identifier.line_num = eat_uint_until_newline(str);
    identifier.name = eat_until_newline(str);
    return identifier;
}

CoolFormal parse_formal(bh_str* str)
{
    CoolFormal identifier = (CoolFormal){ .type = COOL_NODE_TYPE_FORMAL };
    identifier.name = parse_identifier(str);
    identifier.type_name = parse_identifier(str);
    return identifier;
}

CoolFeature parse_feature(bh_str* str, bh_allocator allocator)
{
    CoolFeature feature = (CoolFeature){ .type = COOL_NODE_TYPE_FEATURE };

    bh_str feature_name_str = eat_until_newline(str);
    feature.name = parse_identifier(str);

    if (bh_str_equal(feature_name_str, bh_str_from_cstr("method")))
    {
        bh_str formal_count_str = until_newline(*str);
        int formal_count = uint_from_str(formal_count_str);
        bh_str_eat_chars(*str, formal_count_str.len + 1);

        feature.formal_count = formal_count;
        feature.formals = bh_alloc(allocator, formal_count * sizeof(CoolFormal));

        for (int i = 0; i < formal_count; i++)
        {
            feature.formals[i] = parse_formal(str);
        }
        feature.is_method = true;
    }

    feature.type_name = parse_identifier(str);

    if (bh_str_equal(feature_name_str, bh_str_from_cstr("attribute_init"))) feature.body = parse_expression(str, allocator);
    else if (bh_str_equal(feature_name_str, bh_str_from_cstr("method"))) feature.body = parse_expression(str, allocator);
    else feature.body = (CoolExpression){ 0 };

    return feature;
}

CoolExpression parse_expression(bh_str* str, bh_allocator allocator)
{
    CoolExpression expression = (CoolExpression){ .type = COOL_NODE_TYPE_EXPRESSION };

    bh_str line_num_str = until_newline(*str);
    expression.line_num = uint_from_str(line_num_str);
    bh_str_eat_chars(*str, line_num_str.len + 1);

    expression.expression_typename = eat_until_newline(str);

    bh_str name_str = eat_until_newline(str);

    if (bh_str_equal_lit(name_str, "internal"))
    {
        expression.data.internal.method = eat_until_newline(str);
        expression.expression_type = COOL_EXPR_TYPE_INTERNAL;
        return expression;
    }

    if (bh_str_equal_lit(name_str, "assign")) expression.expression_type = COOL_EXPR_TYPE_ASSIGN;
    else if (bh_str_equal_lit(name_str, "dynamic_dispatch")) expression.expression_type = COOL_EXPR_TYPE_DYNAMIC_DISPATCH;
    else if (bh_str_equal_lit(name_str, "static_dispatch")) expression.expression_type = COOL_EXPR_TYPE_STATIC_DISPATCH;
    else if (bh_str_equal_lit(name_str, "self_dispatch")) expression.expression_type = COOL_EXPR_TYPE_SELF_DISPATCH;
    else if (bh_str_equal_lit(name_str, "if")) expression.expression_type = COOL_EXPR_TYPE_IF;
    else if (bh_str_equal_lit(name_str, "while")) expression.expression_type = COOL_EXPR_TYPE_WHILE;
    else if (bh_str_equal_lit(name_str, "block")) expression.expression_type = COOL_EXPR_TYPE_BLOCK;
    else if (bh_str_equal_lit(name_str, "new")) expression.expression_type = COOL_EXPR_TYPE_NEW;
    else if (bh_str_equal_lit(name_str, "isvoid")) expression.expression_type = COOL_EXPR_TYPE_ISVOID;
    else if (bh_str_equal_lit(name_str, "plus")) expression.expression_type = COOL_EXPR_TYPE_PLUS;
    else if (bh_str_equal_lit(name_str, "minus")) expression.expression_type = COOL_EXPR_TYPE_MINUS;
    else if (bh_str_equal_lit(name_str, "times")) expression.expression_type = COOL_EXPR_TYPE_TIMES;
    else if (bh_str_equal_lit(name_str, "divide")) expression.expression_type = COOL_EXPR_TYPE_DIVIDE;
    else if (bh_str_equal_lit(name_str, "lt")) expression.expression_type = COOL_EXPR_TYPE_LT;
    else if (bh_str_equal_lit(name_str, "le")) expression.expression_type = COOL_EXPR_TYPE_LE;
    else if (bh_str_equal_lit(name_str, "eq")) expression.expression_type = COOL_EXPR_TYPE_EQ;
    else if (bh_str_equal_lit(name_str, "not")) expression.expression_type = COOL_EXPR_TYPE_NOT;
    else if (bh_str_equal_lit(name_str, "negate")) expression.expression_type = COOL_EXPR_TYPE_NEGATE;
    else if (bh_str_equal_lit(name_str, "integer")) expression.expression_type = COOL_EXPR_TYPE_INTEGER;
    else if (bh_str_equal_lit(name_str, "string")) expression.expression_type = COOL_EXPR_TYPE_STRING;
    else if (bh_str_equal_lit(name_str, "identifier")) expression.expression_type = COOL_EXPR_TYPE_IDENTIFIER;
    else if (bh_str_equal_lit(name_str, "true")) expression.expression_type = COOL_EXPR_TYPE_TRUE;
    else if (bh_str_equal_lit(name_str, "false")) expression.expression_type = COOL_EXPR_TYPE_FALSE;
    else if (bh_str_equal_lit(name_str, "let")) expression.expression_type = COOL_EXPR_TYPE_LET;
    else if (bh_str_equal_lit(name_str, "case")) expression.expression_type = COOL_EXPR_TYPE_CASE;

    switch (expression.expression_type)
    {
    case COOL_EXPR_TYPE_ASSIGN:
        expression.data.assign.var = parse_identifier(str);
        expression.data.assign.rhs = bh_alloc(allocator, sizeof(CoolExpression));
        *expression.data.assign.rhs = parse_expression(str, allocator);
        break;
    case COOL_EXPR_TYPE_DYNAMIC_DISPATCH:
        expression.data.dynamic_dispatch.e = bh_alloc(allocator, sizeof(CoolExpression));
        *expression.data.dynamic_dispatch.e = parse_expression(str, allocator);
        expression.data.dynamic_dispatch.method = parse_identifier(str);
        expression.data.dynamic_dispatch.args_length = eat_uint_until_newline(str);
        expression.data.dynamic_dispatch.args = bh_alloc(allocator, expression.data.dynamic_dispatch.args_length * sizeof(CoolExpression));
        for (int i = 0; i < expression.data.dynamic_dispatch.args_length; i++)
        {
            expression.data.dynamic_dispatch.args[i] = parse_expression(str, allocator);
        }
        break;
    case COOL_EXPR_TYPE_STATIC_DISPATCH:
        expression.data.static_dispatch.e = bh_alloc(allocator, sizeof(CoolExpression));
        *expression.data.static_dispatch.e = parse_expression(str, allocator);
        expression.data.static_dispatch.type_name = parse_identifier(str);
        expression.data.static_dispatch.method = parse_identifier(str);
        expression.data.static_dispatch.args_length = eat_uint_until_newline(str);
        expression.data.static_dispatch.args = bh_alloc(allocator, expression.data.static_dispatch.args_length * sizeof(CoolExpression));
        for (int i = 0; i < expression.data.static_dispatch.args_length; i++)
        {
            expression.data.static_dispatch.args[i] = parse_expression(str, allocator);
        }
        break;
    case COOL_EXPR_TYPE_SELF_DISPATCH:
        expression.data.self_dispatch.method = parse_identifier(str);
        expression.data.self_dispatch.args_length = eat_uint_until_newline(str);
        expression.data.self_dispatch.args = bh_alloc(allocator, expression.data.self_dispatch.args_length * sizeof(CoolExpression));
        for (int i = 0; i < expression.data.self_dispatch.args_length; i++)
        {
            expression.data.self_dispatch.args[i] = parse_expression(str, allocator);
        }
        break;
    case COOL_EXPR_TYPE_IF:
        expression.data.if_expr.predicate = bh_alloc(allocator, sizeof(CoolExpression));
        *expression.data.if_expr.predicate = parse_expression(str, allocator);
        expression.data.if_expr.then_branch = bh_alloc(allocator, sizeof(CoolExpression));
        *expression.data.if_expr.then_branch = parse_expression(str, allocator);
        expression.data.if_expr.else_branch = bh_alloc(allocator, sizeof(CoolExpression));
        *expression.data.if_expr.else_branch = parse_expression(str, allocator);
        break;
    case COOL_EXPR_TYPE_WHILE:
        expression.data.while_expr.predicate = bh_alloc(allocator, sizeof(CoolExpression));
        *expression.data.while_expr.predicate = parse_expression(str, allocator);
        expression.data.while_expr.body = bh_alloc(allocator, sizeof(CoolExpression));
        *expression.data.while_expr.body = parse_expression(str, allocator);
        break;
    case COOL_EXPR_TYPE_BLOCK:
        {
            bh_str num_str = eat_until_newline(str);
            expression.data.block.body_length = uint_from_str(num_str);
            expression.data.block.body = bh_alloc(allocator, sizeof(CoolExpression) * expression.data.block.body_length);
            for (int i = 0; i < expression.data.block.body_length; i++)
            {
                expression.data.block.body[i] = parse_expression(str, allocator);
            }
            break;
        }
    case COOL_EXPR_TYPE_NEW:
        expression.data.new_expr.class_name = parse_identifier(str);
        break;
    case COOL_EXPR_TYPE_ISVOID:
        expression.data.isvoid.e = bh_alloc(allocator, sizeof(CoolExpression));
        *expression.data.isvoid.e = parse_expression(str, allocator);
        break;
    case COOL_EXPR_TYPE_PLUS:
    case COOL_EXPR_TYPE_MINUS:
    case COOL_EXPR_TYPE_TIMES:
    case COOL_EXPR_TYPE_DIVIDE:
    case COOL_EXPR_TYPE_LT:
    case COOL_EXPR_TYPE_LE:
    case COOL_EXPR_TYPE_EQ:
        expression.data.binary.x = bh_alloc(allocator, sizeof(CoolExpression));
        *expression.data.binary.x = parse_expression(str, allocator);
        expression.data.binary.y = bh_alloc(allocator, sizeof(CoolExpression));
        *expression.data.binary.y = parse_expression(str, allocator);
        break;
    case COOL_EXPR_TYPE_NOT:
    case COOL_EXPR_TYPE_NEGATE:
        expression.data.unary.x = bh_alloc(allocator, sizeof(CoolExpression));
        *expression.data.unary.x = parse_expression(str, allocator);
        break;
    case COOL_EXPR_TYPE_INTEGER:
        expression.data.integer.value = eat_uint_until_newline(str);
        break;
    case COOL_EXPR_TYPE_STRING:
        expression.data.string.value = eat_until_newline(str);
        break;
    case COOL_EXPR_TYPE_IDENTIFIER:
        expression.data.identifier.variable = parse_identifier(str);
        break;
    case COOL_EXPR_TYPE_TRUE:
    case COOL_EXPR_TYPE_FALSE:
        break;
    case COOL_EXPR_TYPE_LET:
        expression.data.let.binding_count = eat_uint_until_newline(str);
        expression.data.let.bindings = bh_alloc(allocator, expression.data.let.binding_count * sizeof(CoolLetBinding));
        for (int i = 0; i < expression.data.let.binding_count; i++)
        {
            bh_str binding_type = eat_until_newline(str);
            expression.data.let.bindings[i].variable = parse_identifier(str);
            expression.data.let.bindings[i].type_name = parse_identifier(str);
            if (bh_str_equal_lit(binding_type, "let_binding_init"))
            {
                expression.data.let.bindings[i].exp = bh_alloc(allocator, sizeof(CoolExpression));
                *expression.data.let.bindings[i].exp = parse_expression(str, allocator);
            }
        }
        expression.data.let.expr = bh_alloc(allocator, sizeof(CoolExpression));
        *expression.data.let.expr = parse_expression(str, allocator);
        break;
    case COOL_EXPR_TYPE_CASE:
        expression.data.case_expr.expr = bh_alloc(allocator, sizeof(CoolExpression));
        *expression.data.case_expr.expr = parse_expression(str, allocator);
        expression.data.case_expr.element_count = eat_uint_until_newline(str);
        expression.data.case_expr.elements = bh_alloc(allocator, expression.data.case_expr.element_count * sizeof(CoolCaseElement));
        for (int i = 0; i < expression.data.case_expr.element_count; i++)
        {
            expression.data.case_expr.elements[i].variable = parse_identifier(str);
            expression.data.case_expr.elements[i].type_name = parse_identifier(str);
            expression.data.case_expr.elements[i].body = bh_alloc(allocator, sizeof(CoolExpression));
            *expression.data.case_expr.elements[i].body = parse_expression(str, allocator);
        }
        break;
    default:
        assert("Unhandled expression type in AST");
        break;
    }

    return expression;
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

ClassNode class_node_from_id(ClassNodeList list, int64_t id)
{
    // if (id == -1 || id == -2 || id == -3)
    // {
    //     for (int i = 0; i < list.class_count; i++)
    //     {
    //         if (id == -1 && bh_str_equal_lit(list.class_nodes[i].name, "Bool")) return list.class_nodes[i];
    //         if (id == -2 && bh_str_equal_lit(list.class_nodes[i].name, "Int")) return list.class_nodes[i];
    //         if (id == -3 && bh_str_equal_lit(list.class_nodes[i].name, "String")) return list.class_nodes[i];
    //     }
    // }
    if (id < 0)
    {
        id = -id - 1;
    }
    return list.class_nodes[id];
}