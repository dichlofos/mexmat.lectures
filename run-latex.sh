#!/usr/bin/env bash

set -e

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
link "sty"
link "tex"
link "eps"
if ! $latex_cmd "$@" ; then
    rm -f *.dvi
    rm -f *.ps
    rm -f *.pdf
    rm -f *.aux
    echo "There was an error processing command:"
    echo "    $latex_cmd $@"
    echo "Removing output files"
    exit 1
fi
