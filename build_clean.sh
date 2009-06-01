#!/bin/sh

echo -n 'Are you sure? '; read YN

if [ "$YN" != "Y" ]; then
    exit 1
fi

git clean -fd &&
    git reset --hard &&
    autoreconf -vi &&
    ./configure &&
    make

