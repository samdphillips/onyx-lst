
#include <gc.h>
#include <stdio.h>
#include <stdlib.h>

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
static uint32_t onyx_next_ote = 0;
static struct object **onyx_object_table;

void
gcinit(int s, int d)
{
    GC_INIT();
    onyx_object_table = (struct object**)
        GC_MALLOC_ATOMIC(sizeof(struct object*) * ONYX_INIT_OT_SIZE);
}

struct object*
staticAllocate(int size)
{
    UNIMP
}

struct object*
gcalloc(int size)
{
    UNIMP
}

struct object*
gcialloc(int size)
{
    UNIMP
}

struct object*
gcollect(int i)
{
    UNIMP
}

void
addStaticRoot(struct object **oop)
{
    UNIMP
}

int
isDynamicMemory(struct object *oop)
{
    UNIMP
}

/* FIXME: should dynamically allocate this and let it get freed up when
 * we're done. */
static struct object* onyx_indir_array[4096];
static uint32_t onyx_indir_top = 0;

struct object*
onyx_read_object(FILE *fp)
{
    UNIMP
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

