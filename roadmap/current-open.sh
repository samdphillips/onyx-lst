#!/bin/sh

COUNT=`find current/open -type f | wc -l`
if [ "$1" != "-s" ]; then
    printf "%d open issues." $COUNT
else
    echo $COUNT
fi

