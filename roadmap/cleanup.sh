#!/bin/sh

find new/ -type d | 
    while read D; do 
        echo -n "$D "
        ls $D | wc -l
    done | 
    awk '$2 == 0 { print $1 }' | 
    xargs -r rm -rf
