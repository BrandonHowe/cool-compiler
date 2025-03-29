//
// Created by Brandon Howe on 2/10/25.
//

#ifndef TYPES_H
#define TYPES_H

#include <stdarg.h>
#include <stdint.h>
#include "allocator.h"

// Non-owning string view type
typedef struct bh_str
{
    const char* buf;
    uint32_t len;
} bh_str;

bh_str bh_str_from_cstr(const char* cstr);
bh_str bh_str_alloc_cstr(bh_allocator allocator, const char* cstr);
int8_t bh_str_equal(const bh_str str1, const bh_str str2);
int8_t bh_str_cmp(const bh_str str1, const bh_str str2);
bh_str until_newline(const bh_str str);
bh_str eat_until_newline(bh_str* str);
int32_t eat_uint_until_newline(bh_str* str);
int32_t uint_from_str(const bh_str str);

#define bh_str_eat_chars(str, amount) do { (str).buf += (amount); (str).len -= (amount); } while (0)
#define bh_str_equal_lit(str, lit) bh_str_equal((str), bh_str_from_cstr(lit))

// Owning string buffer type, backed by an allocator
typedef struct bh_str_buf
{
    char* buf;
    uint32_t len;
    uint32_t cap;
    bh_allocator allocator;
} bh_str_buf;

bh_str_buf bh_str_buf_init(bh_allocator allocator, uint32_t capacity);
void bh_str_buf_append(bh_str_buf* str_buf, bh_str str);
void bh_str_buf_append_str_buf(bh_str_buf* str_buf, bh_str_buf str_buf_2);
void bh_str_buf_append_format(bh_str_buf* buf, const char* format, ...);
void bh_str_buf_reserve(bh_str_buf* str_buf, uint32_t capacity);
void bh_str_buf_clear(bh_str_buf* str_buf);
void bh_str_buf_deinit(bh_str_buf* str_buf);
void bh_str_buf_append_lit(bh_str_buf* str_buf, const char* cstr);

bh_str read_file_text(const char* file_name);

#endif //TYPES_H
