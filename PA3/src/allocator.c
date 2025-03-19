//
// Created by Brandon Howe on 2/10/25.
//

#include "allocator.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Procedure for general purpose allocator (GPA)
void* gpa_proc(struct bh_allocator* this_allocator, bh_allocator_mode mode, bh_allocator_args args)
{
    switch (mode)
    {
    case bh_allocator_mode_alloc:
        return calloc(args.size, 1);
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
    bh_arena_data* data = this_allocator->data;

    switch (mode)
    {
    case bh_allocator_mode_realloc:
        if (args.ptr == &data->buffer[data->prev_offset])
        {
            data->used = data->prev_offset + args.size;
            assert(data->used < data->capacity);
            return &data->buffer[data->prev_offset];
        }
    case bh_allocator_mode_alloc:
        {
            void* ptr = &data->buffer[data->used];
            data->prev_offset = data->used;
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
    bh_arena_data* data = calloc(sizeof(bh_arena_data) + buffer_size, 1);
    memset(data, 0, sizeof(bh_arena_data) + buffer_size);
    data->used = 0;
    data->capacity = buffer_size;
    data->buffer = &data[1];

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

uint32_t arena_save(bh_allocator allocator)
{
    bh_arena_data* data = allocator.data;
    data->savepoint = data->used;
    data->savepoint_prev = data->prev_offset;
    return data->used;
}

void arena_load(bh_allocator allocator)
{
    bh_arena_data* data = allocator.data;
    data->used = data->savepoint;
    data->prev_offset = data->savepoint_prev;
}

void arena_load_manual(bh_allocator allocator, uint32_t savepoint)
{
    bh_arena_data* data = allocator.data;
    data->used = savepoint;
    data->prev_offset = data->savepoint_prev;
}

void arena_deinit(bh_allocator allocator)
{
    bh_arena_data* data = allocator.data;
    free(data);
}

// Procedure for an arena allocator
void* pool_proc(bh_allocator* this_allocator, bh_allocator_mode mode, bh_allocator_args args)
{
    bh_pool_data* data = this_allocator->data;
    bh_pool_free_node* node = data->head;

    switch (mode)
    {
    case bh_allocator_mode_alloc:

        if (node == NULL) {
            assert(0 && "Pool allocator has no free memory");
            return NULL;
        }

        data->head = data->head->next;
        memset(node, 0, data->chunk_size);
        return node;
    case bh_allocator_mode_realloc:
        assert(0);
    case bh_allocator_mode_free:
        {
            void* start = data->buf;
            void* end = &data->buf[data->buf_len];

            if (args.ptr == NULL) {
                // Ignore NULL pointers
                return NULL;
            }

            if (!(start <= args.ptr && args.ptr < end)) {
                assert(0 && "Memory is out of bounds of the buffer in this pool");
                return NULL;
            }

            // Push free node
            node = (bh_pool_free_node *)args.ptr;
            node->next = data->head;
            data->head = node;
            return NULL;
        }
    default:
        assert(0);
        return NULL;
    }
}

bh_allocator pool_init(uint32_t buffer_size, uint32_t chunk_size)
{
    bh_pool_data* p = calloc(sizeof(bh_pool_data) + buffer_size, 1);

    // Assert that the parameters passed are valid
    assert(chunk_size >= sizeof(bh_pool_free_node) &&
           "Chunk size is too small");
    assert(buffer_size >= chunk_size &&
           "Backing buffer length is smaller than the chunk size");

    // Store the adjusted parameters
    p->buf_len = buffer_size;
    p->chunk_size = chunk_size;
    p->head = NULL; // Free List Head
    p->buf = &p[1];

    bh_allocator allocator = (bh_allocator){
        .data = p,
        .proc = &pool_proc
    };

    // Set up the free list for free chunks
    pool_free_all(allocator);

    return allocator;
}

void pool_free_all(bh_allocator allocator) {
    bh_pool_data* data = allocator.data;
    size_t chunk_count = data->buf_len / data->chunk_size;

    // Set all chunks to be free
    for (uint32_t i = 0; i < chunk_count; i++) {
        void *ptr = &data->buf[i * data->chunk_size];
        bh_pool_free_node* node = (bh_pool_free_node*)ptr;
        // Push free node onto thte free list
        node->next = data->head;
        data->head = node;
    }
}