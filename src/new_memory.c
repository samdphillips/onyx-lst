
#include <stdio.h>
#include <stdlib.h>

#include "memory.h"
#include "globs.h"

#define UNIMP fprintf(stderr,"%s: Unimplemented\n", __FUNCTION__); exit(1);

/* since libgc:
 *  1) is non-moving (I think)
 *  2) is conservative
 *
 *  I don't think we need to be so strict about having a rootStack.  For now it
 *  is easier to keep it because a large number of lines in interp.c would have
 *  to be modified to remove it.
 */
/* FIXME: make dynamic sized */
struct object *rootStack[ROOTSTACKLIMIT];
int rootTop = 0;

/* Technically everything is static since libgc is a non-moving collector */
/* FIXME: make dynamic sized */
#define STATICROOTLIMIT (200)
static struct object *staticRoots[STATICROOTLIMIT];
static int staticRootTop = 0;

void
gcinit(int s, int d)
{
    UNIMP
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

int 
fileIn(FILE *fp)
{
    UNIMP
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

