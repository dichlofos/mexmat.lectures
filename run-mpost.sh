#!/usr/bin/env bash

set -e

done_fn="$1"
mpost_cmd="$2"
shift 2
mkdir -p generated
cd generated
log_file="run_mpost.log"
if ! $mpost_cmd "$@" > $log_file 2>&1 ; then
    echo "There was an error processing command:"
    echo "    $mpost_cmd $@"
    echo "Removing output files"
    echo "==================================== MPOST ERROR LOG ===="
    cat $log_file
    echo "==================================== END ================"
    exit 1
fi
touch $done_fn
