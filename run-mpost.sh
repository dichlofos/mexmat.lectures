#!/bin/bash
set -xe
done_fn="$1"
mpost_cmd="$2"
shift 2
mkdir -p generated
( cd generated && $mpost_cmd $@ && touch $done_fn )