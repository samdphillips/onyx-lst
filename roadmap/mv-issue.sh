#!/bin/sh

DEST="$2"
SRC="$1"

uudir () { echo "$1" | sed 's/^\(..\).*$/\1/'; }
uubase () { echo "$1" | sed 's/^..\(.*\)$/\1/'; }

uuid_for () {
    sed 's,^\(.*/\(..\)/\([^/]\+\)\)$,\1 \2\3,'
}

if [ -z "$SRC" -o -z "$DEST" ]; then
    echo "$0 src dest"
    exit 1
fi

SRCFILE="`find {new,v*} -type f | uuid_for | grep $SRC`"

if [ -z "$SRCFILE" ]; then
    echo No match
    exit 1
fi

MATCH_COUNT="`echo $SRCFILE | wc -w`"

if [ "$MATCH_COUNT" -gt "2" ]; then
    echo Matched
    echo "$SRCFILE"
    exit 1
fi

ID="`echo $SRCFILE | cut -f2 -d' '`"
SRCFILE="`echo $SRCFILE | cut -f1 -d' '`"

DIR="$DEST/`uudir $ID`"
DESTFILE="$DIR/`uubase $ID`"

[ ! -d "$DIR" ] && mkdir -p $DIR

mv $SRCFILE $DESTFILE
