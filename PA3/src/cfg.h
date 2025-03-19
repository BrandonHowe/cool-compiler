//
// Created by Brandon Howe on 3/14/25.
//

#ifndef CFG_H
#define CFG_H

#include "allocator.h"
#include "tac.h"

typedef struct CFGBlock
{
    int16_t id;
    TACSlice tac_contents;
    struct CFGBlock* next[2];
} CFGBlock;

typedef struct CFG
{
    CFGBlock* entry;
    CFGBlock* blocks;
    int16_t block_count;
    int16_t block_capacity;
} CFG;

CFG cfg_from_class_list(ClassNodeList class_list, bh_allocator tac_allocator);

#endif //CFG_H
