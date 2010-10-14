/*
	Little Smalltalk main program, unix version
	Written by Tim Budd, budd@cs.orst.edu
	All rights reserved, no guarantees given whatsoever.
	May be freely redistributed if not for profit.

	starting point, primitive handler for unix
	version of the little smalltalk system
*/
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <limits.h>
#include <unistd.h>
#include "globs.h"

/*
	the following defaults must be set

*/
#define DefaultImageFile "systemImage"
#define DefaultStaticSize 40000
#define DefaultDynamicSize 40000
#define DefaultTmpdir "/tmp"

/*
--------------------
*/

#include "memory.h"
#include "interp.h"
#include <stdio.h>

/* #define COUNTTEMPS */

unsigned int debugging = 0, cacheHit = 0, cacheMiss = 0, gccount = 0;
static char *tmpdir = DefaultTmpdir;

void
sysError(char * a, unsigned int b)
{
	fprintf(stderr,"unrecoverable system error: %s 0x%x\n", a, b);
	exit(1);
}

static void
backTrace(struct object * aContext)
{
	printf("back trace\n");
	while (aContext && (aContext != nilObject)) {
		struct object * arguments; int i;
		printf("message %s ", 
			bytePtr(aContext->data[methodInContext]
				->data[nameInMethod]));
		arguments = aContext->data[argumentsInContext];
		if (arguments && (arguments != nilObject)) {
			printf("(");
			for (i = 0; i < SIZE(arguments); i++)
				printf("%s%s", 
				((i == 0) ? "" : ", "),
				bytePtr(arguments->data[i]->class->
					data[nameInClass]));
			printf(")");
			}
		printf("\n");
		aContext = aContext->data[previousContextInContext];
		}
}

# ifdef COUNTTEMPS
FILE * tempFile;
# endif

int
main(int argc, char ** argv)
{
	struct object *aProcess, *aContext, *o;
	int size, i, staticSize, dynamicSize;
	FILE *fp;
	char imageFileName[120], *p;

	strcpy(imageFileName, DefaultImageFile);
	staticSize = DefaultStaticSize;
	dynamicSize = DefaultDynamicSize;

	/*
	 * See if our environment tells us what TMPDIR to use
	 */
	p = getenv("TMPDIR");
	if (p) {
		tmpdir = strdup(p);
	}

	/* first parse arguments */
	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "-v") == 0) {
			printf("Little Smalltalk, version 4.01\n");
			}
		else if (strcmp(argv[i], "-s") == 0) {
			staticSize = atoi(argv[++i]);
		} else if (strcmp(argv[i], "-d") == 0) {
			dynamicSize = atoi(argv[++i]);
		} else if (strcmp(argv[i], "-g") == 0) {
			debugging = 1;
		} else {
			strcpy(imageFileName, argv[i]);
			}
		}

# ifdef COUNTTEMPS
	tempFile = fopen("/usr/tmp/counts", "w");
# endif

	gcinit(staticSize, dynamicSize);

	/* read in the method from the image file */
	fp = fopen(imageFileName, "r");
	if (! fp) {
		fprintf(stderr,"cannot open image file: %s\n", imageFileName);
		exit(1);
		}

	printf("%d objects in image\n", fileIn(fp));
	fclose(fp);

	/* build a context around it */

	aProcess = staticAllocate(3);
		/* context should be dynamic */
	aContext = gcalloc(contextSize);
	aContext->class = ContextClass;


	aProcess->data[contextInProcess] = aContext;
	size = integerValue(initialMethod->data[stackSizeInMethod]);
	aContext->data[stackInContext] = staticAllocate(size);
	aContext->data[argumentsInContext] = nilObject;

	aContext->data[temporariesInContext] = staticAllocate(19);
	aContext->data[bytePointerInContext] = newInteger(0);
	aContext->data[stackTopInContext] = newInteger(0);
	aContext->data[previousContextInContext] = nilObject;
	aContext->data[methodInContext] = initialMethod;

	/* now go do it */
	rootStack[rootTop++] = aProcess;

	switch(execute(aProcess, 0)) {
		case 2: printf("User defined return\n"); break;

		case 3: printf("can't find method in call\n"); 
			aProcess = rootStack[--rootTop];
			o = aProcess->data[resultInProcess];
			printf("Unknown method: %s\n", bytePtr(o));
			aContext = aProcess->data[contextInProcess];
			backTrace(aContext);
			break;

		case 4: printf("\nnormal return\n"); break;

		case 5: printf("time out\n"); break;

		default: printf("unknown return code\n"); break;
	}
	printf("cache hit %u miss %u", cacheHit, cacheMiss);
#define SCALE (1000)
	while ((cacheHit > INT_MAX/SCALE) || (cacheMiss > INT_MAX/SCALE)) {
		cacheHit /= 10;
		cacheMiss /= 10;
	}
	i = (SCALE * cacheHit) / (cacheHit + cacheMiss);
	printf(" ratio %u.%u%%\n", i / 10, i % 10);
	printf("%u garbage collections\n", gccount);
	return(0);
}

