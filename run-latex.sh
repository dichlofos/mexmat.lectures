#!/usr/bin/env bash
set -xe
latex_cmd="$1"
shift

function link() {
    if ! [ -e ../*.$1 ] ; then
        return 0
    fi
    for i in ../*.$1 ; do
        ln -sf "$i" .
    done
}

mkdir -p generated
cd generated
link "tex"
link "eps"
$latex_cmd $@