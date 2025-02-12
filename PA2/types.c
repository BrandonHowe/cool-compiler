//
// Created by Brandon Howe on 2/10/25.
//

#include "types.h"

#include <string.h>

bh_str bh_str_from_cstr(const char* cstr)
{
    return (bh_str){ .buf = cstr, .len = strlen(cstr) };
}

int8_t bh_str_equal(const bh_str str1, const bh_str str2)
{
    if (str1.len != str2.len) return 0;
    for (int i = 0; i < str1.len; i++)
    {
        if (str1.buf[i] != str2.buf[i])
        {
            return 0;
        }
    }
    return 1;
}

bh_str until_newline(const bh_str str)
{
    for (int i = 0; i < str.len; i++)
    {
        if (str.buf[i] == '\n')
        {
            return (bh_str){ .buf = str.buf, .len = i };
        }
    }
    return str;
}

bh_str eat_until_newline(bh_str* str)
{
    bh_str res = { 0 };
    for (int i = 0; i < str->len; i++)
    {
        if (str->buf[i] == '\n')
        {
            res = (bh_str){ .buf = str->buf, .len = i };
            str->buf += i + 1;
            str->len -= i + 1;
            return res;
        }
    }
    res = (bh_str){ .buf = str->buf, .len = str->len };
    str->buf += str->len;
    str->len -= str->len;
    return res;
}

int32_t eat_uint_until_newline(bh_str* str)
{
    bh_str res = { 0 };
    for (int i = 0; i < str->len; i++)
    {
        if (str->buf[i] == '\n')
        {
            res = (bh_str){ .buf = str->buf, .len = i };
            str->buf += i + 1;
            str->len -= i + 1;
            return uint_from_str(res);
        }
    }
    res = (bh_str){ .buf = str->buf, .len = str->len };
    str->buf += str->len;
    str->len -= str->len;
    return uint_from_str(res);
}

int32_t uint_from_str(const bh_str str)
{
    int32_t res = 0;
    for (int i = 0; i < str.len; i++)
    {
        if (str.buf[i] >= '0' && str.buf[i] <= '9')
        {
            res *= 10;
            res += str.buf[i] - '0';
        }
        else
        {
            return -1;
        }
    }
    return res;
}