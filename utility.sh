#!/usr/bin/env bash

function subdirs_generate() {
    for dir in $(ls -1)
    do
        if test -d "$dir" ; then
            echo "add_subdirectory(${dir})"
        fi
    done
}
