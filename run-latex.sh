#!/usr/bin/env bash

set -e

latex_cmd="$1"
shift

function link() {
    linked_files="../*.$1"
    for f in $linked_files ; do
        if ! [ -e "$f" ] ; then
            return 0
        fi
        ln -sf "$f" .
    done
}

mkdir -p generated
cd generated
link "sty"
link "tex"
link "eps"
# pictures
link "1"

log_file="run_latex.log"

if ! $latex_cmd "$@" > $log_file 2>&1 ; then
    echo "There was an error processing command:"
    echo "    $latex_cmd $@"
    echo "Removing output files"
    rm -f *.dvi
    rm -f *.ps
    rm -f *.pdf
    rm -f *.aux
    echo "==================================== ERROR LOG =========="
    cat $log_file
    echo "==================================== END ================"
    exit 1
fi
