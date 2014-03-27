#!/bin/bash
set -xe
dvips_cmd="$1"
shift
mkdir -p generated
( cd generated && $dvips_cmd $@ )