//
// Created by Brandon Howe on 2/10/25.
//

#ifndef ALLOCATOR_H
#define ALLOCATOR_H

#include <stdint.h>

typedef enum bh_allocator_mode
{
    bh_allocator_mode_unknown = 0,
    bh_allocator_mode_alloc,
    bh_allocator_mode_free,
    bh_allocator_mode_realloc
} bh_allocator_mode;

typedef struct bh_allocator_args
{
    /**
     * Used in case of bh_allocator_mode_free or bh_allocator_mode_realloc
     */
    void* ptr;
    /**
     * Used in case of bh_allocator_mode_alloc or bh_allocator_mode_realloc
     */
    uint32_t size;
    /**
     * Used in case of bh_allocator_mode_realloc
     */
    uint32_t old_size;
} bh_allocator_args;

struct bh_allocator;

// Allocator procedure function
typedef void* (bh_allocator_proc)(struct bh_allocator* this_allocator, bh_allocator_mode mode, bh_allocator_args args);

typedef struct bh_allocator
{
    void* data;
    bh_allocator_proc* proc;
} bh_allocator;

#define bh_alloc(allocator, alloc_size) (allocator).proc(&(allocator), bh_allocator_mode_alloc, (bh_allocator_args){ .size = (alloc_size) })
#define bh_realloc(allocator, pointer, alloc_size) (allocator).proc(&(allocator), bh_allocator_mode_realloc, (bh_allocator_args){ .size = (alloc_size), .ptr = (pointer) })
#define bh_free(allocator, pointer) (allocator).proc(&(allocator), bh_allocator_mode_free, (bh_allocator_args){ .ptr = (pointer) })

bh_allocator_proc gpa_proc;
bh_allocator_proc arena_proc;

bh_allocator GPA;

typedef struct bh_arena_data
{
    uint32_t capacity;
    uint32_t used;
    void* buffer;
} bh_arena_data;

bh_allocator arena_init(uint32_t buffer_size);
void arena_free_all(bh_allocator allocator);
void arena_deinit(bh_allocator allocator);

#endif //ALLOCATOR_H
