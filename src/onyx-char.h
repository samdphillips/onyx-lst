
#include <stdbool.h>

#define ONYX_CHAR_TAG   0xA

struct object* onyx_char_tag(char);
char onyx_char_untag(struct object*);
bool onyx_is_char(struct object*);

