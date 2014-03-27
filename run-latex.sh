#!/bin/bash
set -xe
latex_cmd="$1"
shift
mkdir -p generated
( cd generated && $latex_cmd $@ )