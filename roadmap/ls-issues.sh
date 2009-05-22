#!/bin/sh

RELEASE="new"

if [ ! -z "$1" ]; then
    RELEASE="$1"
fi

find "$RELEASE" -type f | xargs grep '^Description:'

