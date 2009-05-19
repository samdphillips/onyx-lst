
#include <stdio.h>
#include <stdlib.h>

#include "memory.h"
#include "globs.h"

#define UNIMP fprintf(stderr,"Unimplemented\n"); exit(1);

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
