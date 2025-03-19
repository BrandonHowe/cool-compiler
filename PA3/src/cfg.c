//
// Created by Brandon Howe on 3/14/25.
//

#include "cfg.h"
#include <stdlib.h>

CFG cfg_from_class_list(ClassNodeList class_list, bh_allocator tac_allocator)
{
    // We reserve the cfg array up front, so the GPA is ok
    bh_allocator cfg_allocator = GPA;

    // Initialize the CFG
    CFG cfg = (CFG){
        .block_capacity = 1000,
        .blocks = bh_alloc(cfg_allocator, 1000 * sizeof(CFGBlock)),
        .block_count = 0,
        .entry = NULL
    };

    for (int i = 0; i < class_list.class_count; i++)
    {
        ClassNode class_node = class_list.class_nodes[i];

        for (int j = 0; j < class_node.method_count; j++)
        {
            if (bh_str_equal_lit(class_list.class_nodes[i].methods[j].inherited_from, "Object")) continue;
            if (bh_str_equal_lit(class_list.class_nodes[i].methods[j].inherited_from, "Bool")) continue;
            if (bh_str_equal_lit(class_list.class_nodes[i].methods[j].inherited_from, "IO")) continue;
            if (bh_str_equal_lit(class_list.class_nodes[i].methods[j].inherited_from, "String")) continue;
            if (bh_str_equal_lit(class_list.class_nodes[i].methods[j].inherited_from, "Int")) continue;

            // Generate TAC for our method
            ClassMethod method = class_node.methods[j];
            TACList tac_list = tac_list_from_method(method, tac_allocator);

            // Separate the TAC into parts based on control flow
            int block_len = 0;
            int block_start = 0;
            for (int k = 0; k < tac_list.count; k++)
            {
                block_len += 1;

                TACExpr expr = tac_list.items[k];
                if (expr.operation == TAC_OP_JMP ||
                    expr.operation == TAC_OP_BT)
                {
                    CFGBlock block = (CFGBlock){
                        .id = cfg.block_count + 1,
                        .tac_contents = (TACSlice){ .count = block_len, .items = &tac_list.items[block_start] }
                    };

                    if (expr.operation == TAC_OP_JMP)
                    {
                        block.next[0] = &cfg.blocks[expr.rhs1.integer + 1];
                    }
                    if (expr.operation == TAC_OP_BT)
                    {
                        block.next[0] = &cfg.blocks[cfg.block_count + 1];
                        block.next[1] = &cfg.blocks[expr.rhs2.integer + 1];
                    }

                    cfg.blocks[cfg.block_count++] = block;
                    block_len = 0;
                    block_start = k + 1;
                }
            }
        }
    }

    return cfg;
}