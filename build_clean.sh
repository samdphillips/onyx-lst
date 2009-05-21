#!/bin/sh

git clean -fd &&
    git reset --hard &&
    autoreconf -vi &&
    ./configure &&
    make

