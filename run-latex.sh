#!/usr/bin/env bash
set -xe
latex_cmd="$1"
shift

mkdir -p generated
cd generated
for i in ../*.{tex,sty,eps} ; do
    ln -sf "$i" .
done
$latex_cmd $@