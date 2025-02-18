//
// Created by Brandon Howe on 2/10/25.
//

#include "allocator.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

// Procedure for general purpose allocator (GPA)
void* gpa_proc(struct bh_allocator* this_allocator, bh_allocator_mode mode, bh_allocator_args args)
{
    switch (mode)
    {
    case bh_allocator_mode_alloc:
        return malloc(args.size);
    case bh_allocator_mode_realloc:
        return realloc(args.ptr, args.size);
    case bh_allocator_mode_free:
        free(args.ptr);
        return NULL;
    default:
        assert(0);
        return NULL;
    }
}

// General-purpose heap allocator (wrapper around malloc)
bh_allocator GPA = (bh_allocator)
{
    .data = NULL,
    .proc = &gpa_proc
};

// Procedure for an arena allocator
void* arena_proc(bh_allocator* this_allocator, bh_allocator_mode mode, bh_allocator_args args)
{
    switch (mode)
    {
    case bh_allocator_mode_alloc:
    case bh_allocator_mode_realloc:
        {
            bh_arena_data* data = this_allocator->data;
            void* ptr = &data->buffer[data->used];
            data->used += args.size;
            // printf("Allocating %i bytes, used: %i, cap: %i\n", args.size, data->used, data->capacity);
            assert(data->used < data->capacity);
            return ptr;
        }
    case bh_allocator_mode_free:
        return NULL;
    default:
        assert(0);
        return NULL;
    }
}

bh_allocator arena_init(uint32_t buffer_size)
{
    bh_arena_data* data = malloc(sizeof(bh_arena_data) + buffer_size);
    data->used = 0;
    data->capacity = buffer_size;
    data->buffer = &data[__offsetof(bh_arena_data, used)];

    bh_allocator allocator = (bh_allocator){
        .data = data,
        .proc = &arena_proc
    };

    return allocator;
}

void arena_free_all(bh_allocator allocator)
{
    bh_arena_data* data = allocator.data;
    data->used = 0;
}

void arena_deinit(bh_allocator allocator)
{
    bh_arena_data* data = allocator.data;
    free(data);
}