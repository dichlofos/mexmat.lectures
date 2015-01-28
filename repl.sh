#!/usr/bin/env bash

filez=$(find . -name 'CMakeLists.txt')
for c in $filez ; do
    if ! grep -i mmtodo $c ; then
        continue
    fi
    d=$(dirname $c)
    sed -i -e 's:Add $d:Add:' $c
    echo $d
    echo $c
    echo '==='
done
