//
// Created by Brandon Howe on 2/10/25.
//

#ifndef TYPES_H
#define TYPES_H
#include <stdint.h>

typedef struct bh_str
{
    const char* buf;
    uint32_t len;
} bh_str;

bh_str bh_str_from_cstr(const char* cstr);
int8_t bh_str_equal(const bh_str str1, const bh_str str2);
bh_str until_newline(const bh_str str);
bh_str eat_until_newline(bh_str* str);
int32_t eat_uint_until_newline(bh_str* str);
int32_t uint_from_str(const bh_str str);

#define bh_str_eat_chars(str, amount) do { (str).buf += (amount); (str).len -= (amount); } while (0)
#define bh_str_equal_lit(str, lit) bh_str_equal((str), bh_str_from_cstr(lit))

typedef struct bh_str_buf
{
    char* buf;
    uint32_t len;
    uint32_t cap;
} bh_str_buf;

#endif //TYPES_H
