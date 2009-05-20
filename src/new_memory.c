
#include <gc.h>
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

#define ONYX_INIT_OT_SIZE 1024
static uint32_t onyx_top_ote = ONYX_INIT_OT_SIZE;
static uint32_t onyx_next_ote = 0;
static struct object **onyx_object_table;

void
gcinit(int s, int d)
{
    GC_INIT();
    onyx_object_table = (struct object**)
        GC_MALLOC_ATOMIC(sizeof(struct object*) * ONYX_INIT_OT_SIZE);
}

/* FIXME: remove this function */
struct object*
staticAllocate(int size)
{
    return gcalloc(size);
}

static void
onyx_compact_object_table(void)
{
    uint32_t i, j, null_count, dest_size;
    struct object **new_object_table;

    fprintf(stderr, "[debug] compacting object table\n");
    null_count = 0;
    for (i=0; i < onyx_top_ote; i++)
    {
        if (onyx_object_table[i] == NULL)
            null_count++;
    }

    fprintf(stderr, "[debug] %d nulls found\n", null_count);
    if (null_count < onyx_top_ote / 2)
        dest_size = onyx_top_ote * 2;
    else
        dest_size = onyx_top_ote;

    fprintf(stderr, "[debug] object table size: %d -> %d\n", onyx_top_ote, dest_size);
    new_object_table = GC_MALLOC_ATOMIC(sizeof(struct object*) * dest_size);

    j = 0;
    for (i=0; i < onyx_top_ote; i++)
    {
        if (onyx_object_table[i] != NULL)
        {
            new_object_table[j] = onyx_object_table[i];
            j++;
        }
    }

    onyx_object_table = new_object_table;
    onyx_next_ote = j;
    onyx_top_ote = dest_size;
}

static void
onyx_unregister_oop(struct object* object, void *trash)
{
    uint32_t i;

    for (i=0; i < onyx_next_ote; i++)
    {
        if (onyx_object_table[i] == object)
        {
            onyx_object_table[i] = NULL;
            return;
        }
    }
}

static void
onyx_register_oop(struct object *object)
{
    if (onyx_next_ote >= onyx_top_ote)
        onyx_compact_object_table();

    onyx_object_table[onyx_next_ote] = object;
    onyx_next_ote++;

    GC_REGISTER_FINALIZER_NO_ORDER(object, onyx_unregister_oop, NULL, NULL, NULL);
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

    real_size = (size + BytesPerWord - 1) / BytesPerWord;
    /* FIXME: interior should not be traced */
    object = gcalloc(real_size);
    SETSIZE(object, size);
    object->size |= FLAG_BIN;
    return object;
}

struct object*
gcollect(int i)
{
    UNIMP
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

/* FIXME: should dynamically allocate this and let it get freed up when
 * we're done.  Also should probably be localized */
static struct object* onyx_indir_array[4096];
static uint32_t onyx_indir_top = 0;

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

        /* FIXME: default case */
    }

    return newObj;
}

int 
fileIn(FILE *fp)
{
    uint32_t i;

    nilObject = onyx_read_object(fp);
    trueObject = onyx_read_object(fp);
    falseObject = onyx_read_object(fp);
    globalsObject = onyx_read_object(fp);
    SmallIntClass = onyx_read_object(fp);
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
    UNIMP
}

void
exchangeObjects(struct object *a, struct object *b, uint size)
{
    UNIMP
}

