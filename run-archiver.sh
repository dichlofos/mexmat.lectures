#!/bin/bash
set -e
archiver_cmd="$1"
shift
mkdir -p generated
cd generated
log_file="run_archiver.log"
if ! $archiver_cmd "$@" > $log_file 2>&1 ; then
    echo "There was an error processing command:"
    echo "    $archiver_cmd $@"
    echo "Removing output files"
    rm -f *.ps
    echo "==================================== ARCHIVER ERROR LOG ="
    cat $log_file
    echo "==================================== END ================"
    exit 1
fi
