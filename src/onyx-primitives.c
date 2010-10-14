
#include <string.h>

#include "globs.h"
#include "memory.h"

/*
	primitive handler
	(note that many primitives are handled in the interpreter)
*/

#define FILEMAX 20
static FILE *filePointers[FILEMAX];

static char *tmpdir;

static void
getUnixString(char *to, int size, struct object *from)
{
	int i;
	int fsize = SIZE(from);
	struct byteObject *bobj = (struct byteObject *) from;

	if (fsize > size) {
		sysError("error converting text into unix string", fsize);
	}
	for (i = 0; i < fsize; i++) {
		to[i] = bobj->bytes[i];
	}
	to[i] = '\0';	/* put null terminator at end */
}

struct object *
onyx_prim_file_open(struct object *args, int *failed)
{
    FILE *fp;
    int i;
    char nameBuffer[80], modeBuffer[10];
    struct object *returnedValue = nilObject;

    getUnixString(nameBuffer, 80, args->data[0]);
    getUnixString(modeBuffer, 10, args->data[1]);
    fp = fopen(nameBuffer, modeBuffer);
    if (fp != NULL) {
        for (i = 0; i < FILEMAX; ++i) {
            if (filePointers[i] == NULL) {
                break;
            }
        }
        if (i >= FILEMAX) {
            sysError("too many open files", 0);
            fclose(fp);
            *failed = 1;
        } else {
            returnedValue = newInteger(i);
            filePointers[i] = fp;
        }
    } else {
        *failed = 1;
    }

    return returnedValue;
}

struct object*
onyx_prim_file_read_char(struct object *args, int *failed)
{
    int i;
    FILE *fp;
    struct object *returnedValue = nilObject;

    i = integerValue(args->data[0]);
    if ((i < 0) || (i >= FILEMAX) || !(fp = filePointers[i])) {
        *failed = 1;
        return returnedValue;
    }
    i = fgetc(fp);
    if (i != EOF) {
        returnedValue = newInteger(i);
    }

    return returnedValue;
}

struct object*
onyx_prim_file_write_char(struct object *args, int *failed)
{
    int i;
    FILE *fp;

    i = integerValue(args->data[0]);
    if ((i < 0) || (i >= FILEMAX) || !(fp = filePointers[i])) {
        *failed = 1;
    } else {
        fputc(integerValue(args->data[1]), fp);
    }

    return nilObject;
}

struct object *
onyx_prim_file_close(struct object *args, int *failed)
{
    int i;
    FILE *fp;

    i = integerValue(args->data[0]);
    if ((i < 0) || (i >= FILEMAX) || !(fp = filePointers[i])) {
        *failed = 1;
    } else {
        fclose(fp);
        filePointers[i] = NULL;
    }

    return nilObject;
}

struct object *
onyx_prim_image_fileout(struct object *args, int *failed)
{
    int i;
    FILE *fp;

    i = integerValue(args->data[0]);
    if ((i < 0) || (i >= FILEMAX) || !(fp = filePointers[i])) {
        *failed = 1;
    } else {
        fileOut(fp);
    }
    return nilObject;
}

struct object *
onyx_prim_file_read_bytes(struct object *args, int *failed)
{
    int i;
    FILE *fp;
    struct object *bytes;

    /* File descriptor */
    i = integerValue(args->data[0]);
    if ((i < 0) || (i >= FILEMAX) || !(fp = filePointers[i])) {
        *failed = 1;
        return nilObject;
    }

    /* Make sure we're populating an array of bytes */
    bytes = args->data[1];
    if ((bytes->size & FLAG_BIN) == 0) {
        *failed = 1;
        return nilObject;
    }

    /* Sanity check on I/O count */
    i = integerValue(args->data[2]);
    if ((i < 0) || (i > SIZE(bytes))) {
        *failed = 1;
        return nilObject;
    }

    /* Do the I/O */
    i = fread(bytePtr(bytes), sizeof(char), i, fp);
    if (i < 0) {
        *failed = 1;
        return nilObject;
    }
    return newInteger(i);
}

struct object *
onyx_prim_file_write_bytes(struct object *args, int *failed)
{
    int i;
    FILE *fp;
    struct object *bytes;

    /* File descriptor */
    i = integerValue(args->data[0]);
    if ((i < 0) || (i >= FILEMAX) || !(fp = filePointers[i])) {
        *failed = 1;
        return nilObject;
    }

    /* Make sure we're writing an array of bytes */
    bytes = args->data[1];
    if ((bytes->size & FLAG_BIN) == 0) {
        *failed = 1;
        return nilObject;
    }

    /* Sanity check on I/O count */
    i = integerValue(args->data[2]);
    if ((i < 0) || (i > SIZE(bytes))) {
        *failed = 1;
        return nilObject;
    }

    /* Do the I/O */
    i = fwrite(bytePtr(bytes), sizeof(char), i, fp);
    if (i < 0) {
        *failed = 1;
        return nilObject;
    }
    return newInteger(i);
}

struct object *
onyx_prim_file_seek(struct object *args, int *failed)
{
    int i;
    FILE *fp;

    /* File descriptor */
    i = integerValue(args->data[0]);
    if ((i < 0) || (i >= FILEMAX) || !(fp = filePointers[i])) {
        *failed = 1;
        return nilObject;
    }

    /* File position */
    i = integerValue(args->data[1]);
    if ((i < 0) || ((i = fseek(fp, i, SEEK_SET)) < 0)) {
        *failed = 1;
        return nilObject;
    }

    /* Return position as our value */
    return newInteger(i);
}

struct object *
primitive(int primitiveNumber, struct object *args, int *failed)
{
	struct object *returnedValue = nilObject;

	*failed = 0;
	switch(primitiveNumber) {
	case 100: 	/* open a file */
        returnedValue = onyx_prim_file_open(args, failed);
		break;

	case 101:	/* read a single character from a file */
        returnedValue = onyx_prim_file_read_char(args, failed);
		break;

	case 102:	/* write a single character to a file */
        returnedValue = onyx_prim_file_write_char(args, failed);
		break;

	case 103:	/* close file */
        returnedValue = onyx_prim_file_close(args, failed);
		break;

	case 104:	/* file out image */
        returnedValue = onyx_prim_image_fileout(args, failed);
		break;

	case 105:	/* edit a string */
        *failed = 1;
		break;

	case 106:	/* Read into ByteArray */
        returnedValue = onyx_prim_file_read_bytes(args, failed);
		break;

	case 107:	/* Write from ByteArray */
        returnedValue = onyx_prim_file_write_bytes(args, failed);
		break;

	case 108:	/* Seek to file position */
        returnedValue = onyx_prim_file_seek(args, failed);
		break;

	default:
		sysError("unknown primitive", primitiveNumber);
	}
	return(returnedValue);
}


