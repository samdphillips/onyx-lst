
#include <gc.h>
#include <gc_typed.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

#include "memory.h"
#include "globs.h"

#define UNIMP fprintf(stderr,"%s: Unimplemented\n", __FUNCTION__); exit(1);

/* since libgc:
 *  1) is non-moving (I think)
 *  2) is conservative
 *
 *  I don't think we need to be so strict about having a rootStack.  For
 *  now it is easier to keep it because a large number of lines in
 *  interp.c would have to be modified to remove it.
 */
/* FIXME: make dynamic sized */
struct object *rootStack[ROOTSTACKLIMIT];
int rootTop = 0;

/* Technically everything is static since libgc is a non-moving
 * collector (may not be a root though) */
/* FIXME: make dynamic sized */
#define STATICROOTLIMIT (200)
static struct object *staticRoots[STATICROOTLIMIT];
static int staticRootTop = 0;

/* FIXME: tunable param */
#define ONYX_INIT_OT_SIZE 1024

struct onyx_object_table
{
    struct onyx_object_table*   next_table;
    uint32_t                    size;
    uint32_t                    next_free;
    struct object*              ote[0];
};

static void onyx_register_oop_in_table(struct object*, struct onyx_object_table*);

struct onyx_object_table* object_table;
static GC_descr T_object_table;
static GC_descr T_byte_object;

struct onyx_object_table*
onyx_object_table_new(uint32_t size)
{
    struct onyx_object_table *ot;
    uint32_t ot_size;

    ot_size = sizeof(struct onyx_object_table) + 
        sizeof(struct object*) * size;
    ot = GC_MALLOC_EXPLICITLY_TYPED(ot_size, T_object_table);

    return ot;
}

void
gcinit(int s, int d)
{
    GC_word T_ot_bitmap[GC_BITMAP_SIZE(struct onyx_object_table)] = {0},
            T_bytes_bitmap[GC_BITMAP_SIZE(struct object)] = {0};

    GC_INIT();

    /* set up type descriptor for object tables */
    GC_set_bit(T_ot_bitmap, 
            GC_WORD_OFFSET(struct onyx_object_table, next_table));
    T_object_table = GC_make_descriptor(T_ot_bitmap, 
            GC_WORD_LEN(struct onyx_object_table));

    /* set up type descriptor for byte objects */
    GC_set_bit(T_bytes_bitmap,
            GC_WORD_OFFSET(struct object, class));
    T_byte_object = GC_make_descriptor(T_bytes_bitmap,
            GC_WORD_LEN(struct object));

    object_table = onyx_object_table_new(ONYX_INIT_OT_SIZE);
}

/* FIXME: remove this function */
struct object*
staticAllocate(int size)
{
    return gcalloc(size);
}

static void
onyx_promote_objects(struct onyx_object_table *table)
{
    uint32_t i;

    if (table->next_table == NULL)
        table->next_table = onyx_object_table_new(table->size);

    for (i=0; i < table->size; i++)
    {
        if (table->ote[i] != NULL)
        {
            onyx_register_oop_in_table(table->ote[i], table->next_table);
            table->ote[i] = NULL;
        }
    }

    table->next_free = 0;
}

static void
onyx_unregister_oop(struct object* object, void *trash)
{
    uint32_t i;
    struct onyx_object_table *cur_table;

    for (cur_table = object_table; cur_table != NULL; cur_table=cur_table->next_table)
    {
        for (i=0; i < cur_table->next_free; i++)
        {
            if (cur_table->ote[i] == object)
            {
                cur_table->ote[i] = NULL;
                return;
            }
        }
    }
}

static void
onyx_register_oop_in_table(struct object *object, struct onyx_object_table *table)
{

    if (table->next_free >= table->size)
        onyx_promote_objects(table);

    table->ote[table->next_free] = object;
    table->next_free++;

    GC_REGISTER_FINALIZER_NO_ORDER(object, onyx_unregister_oop, NULL, NULL, NULL);
}

static void
onyx_register_oop(struct object *object)
{
    onyx_register_oop_in_table(object, object_table);
}


struct object*
gcalloc(int size)
{
    struct object *object;
    object = GC_MALLOC((size + 2) * sizeof(void*));
    SETSIZE(object, size);
    onyx_register_oop(object);
    return object;
}

struct object*
gcialloc(int size)
{
    uint32_t real_size;
    struct object *object;

    real_size = ((size + BytesPerWord - 1) / BytesPerWord + 2) *
        sizeof(struct object*);
    object = GC_MALLOC_EXPLICITLY_TYPED(real_size, T_byte_object);
    SETSIZE(object, size);
    object->size |= FLAG_BIN;
    onyx_register_oop(object);
    return object;
}

void
addStaticRoot(struct object **oop)
{
    if (staticRootTop >= STATICROOTLIMIT)
    {
        sysError("addStaticRoot: too many static references", (unsigned int)oop);
    }

    staticRoots[staticRootTop] = *oop;
    staticRootTop++;
}

int
isDynamicMemory(struct object *oop)
{
    return 0;
}

struct object*
onyx_object_class(struct object *obj)
{
    if (IS_SMALLINT(obj))
        return SmallIntClass;
    else if (onyx_is_char(obj))
        return CharClass;
    return obj->class;
}

/* FIXME: should dynamically allocate this and let it get freed up when
 * we're done.  Also should probably be localized */
static struct object* onyx_indir_array[4096];
static uint32_t onyx_indir_top;

/* FIXME: these names should be more specific to their task */

static unsigned int
onyx_read_word(FILE *fp)
{
    unsigned int i = 0;
    unsigned int c;

    while(true)
    {
        c = fgetc(fp);
        if (c == EOF)
            sysError("unexpected end of file reading image file", 0);

        i += c;

        if (c != 255)
            break;
    }

    return i;
}

static struct object*
onyx_read_object(FILE *fp)
{
    int type, size, i;
    struct object *newObj = 0;
    struct byteObject *bnewObj;

    type = onyx_read_word(fp);

    switch (type) {
        case 0: /* nil obj */
            sysError("read in a null object", (int)newObj);

        case 1: /* ordinary object */
            size = onyx_read_word(fp);
            newObj = gcalloc(size);
            onyx_indir_array[onyx_indir_top++] = newObj;
            newObj->class = onyx_read_object(fp);
            for (i = 0; i < size; i++) {
                newObj->data[i] = onyx_read_object(fp);
            }
            break;

        case 2: /* integer */
            {
                int val;

                (void)fread(&val, sizeof(val), 1, fp);
                newObj = newInteger(val);
            }
            break;

        case 3: /* byte arrays */
            size = onyx_read_word(fp);
            newObj = gcialloc(size);
            onyx_indir_array[onyx_indir_top++] = newObj;
            bnewObj = (struct byteObject *) newObj;
            for (i = 0; i < size; i++) 
            {
                type = onyx_read_word(fp);
                bnewObj->bytes[i] = type;
            }
            bnewObj->class = onyx_read_object(fp);
            break;

        case 4: /* previous object */
            size = onyx_read_word(fp);
            newObj = onyx_indir_array[size];
            break;

        case 5: /* object 0 (nil object) */
            newObj = onyx_indir_array[0];
            break;

        case 6: /* Char object */
            {
                uint32_t val;
                (void)fread(&val, sizeof(val), 1, fp);
                newObj = (struct object*)val;
            }
            break;

        default:
            sysError("bad image typecode", type);

    }

    return newObj;
}

int 
fileIn(FILE *fp)
{
    uint32_t i;

    onyx_indir_top = 0;

    nilObject = onyx_read_object(fp);
    trueObject = onyx_read_object(fp);
    falseObject = onyx_read_object(fp);
    globalsObject = onyx_read_object(fp);
    SmallIntClass = onyx_read_object(fp);
    CharClass = onyx_read_object(fp);
    IntegerClass = onyx_read_object(fp);
    ArrayClass = onyx_read_object(fp);
    BlockClass = onyx_read_object(fp);
    ContextClass = onyx_read_object(fp);
    initialMethod = onyx_read_object(fp);
    for (i = 0; i < 3; i++) {
        binaryMessages[i] = onyx_read_object(fp);
    }
    badMethodSym = onyx_read_object(fp);

    return onyx_indir_top;
}
    

int 
fileOut(FILE *fp)
{
    uint32_t i;
    onyx_indir_top = 0;
    UNIMP
}

void
exchangeObjects(struct object *a, struct object *b, uint size)
{
    UNIMP
}

