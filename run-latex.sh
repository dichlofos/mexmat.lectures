#!/usr/bin/env bash

set -xe

latex_cmd="$1"
shift

function link_mask() {
    linked_files="../*.$1"
    for f in $linked_files ; do
        if ! [ -e "$f" ] ; then
            return 0
        fi
        if ! [ -e ./$(basename "$f") ] ; then
            ln -sf "$f" .
        fi
    done
}

mkdir -p generated
cd generated
link_mask "sty"
link_mask "tex"
link_mask "eps"
# pictures
#link "1"

log_file="run_latex.log"

if ! $latex_cmd "$@" > $log_file 2>&1 ; then
    echo "There was an error processing command:"
    echo "    $latex_cmd $@"
    echo "Removing output files"
    rm -f *.dvi
    rm -f *.aux
    echo "==================================== LATEX ERROR LOG ===="
    cat $log_file
    echo "==================================== END ================"
    exit 1
fi
if grep -q "Rerun" $log_file ; then
    echo "Rebuilding $@ to get proper xrefs"
    $latex_cmd "$@" > $log_file.2 2>&1

    if grep -q "Rerun" $log_file.2 ; then
        echo "Something goes wrong with xref rebuilding, please check $log_file.2"
        exit 1
    fi
fi
