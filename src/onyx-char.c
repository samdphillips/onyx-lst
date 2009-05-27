
#include <stdint.h>
#include "onyx-char.h"

struct object*
onyx_char_tag(char c)
{
    return (struct object*)(((uint32_t)c << 4) | ONYX_CHAR_TAG);
}

char
onyx_char_untag(struct object* obj)
{
    /* FIXME: maybe check tag */
    return (char)(((uint32_t)obj >> 4) & 0xFF);
}

bool
onyx_is_char(struct object* obj)
{
    return ONYX_CHAR_TAG == ((uint32_t)obj & 0xF);
}

