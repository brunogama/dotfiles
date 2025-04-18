#!/bin/bash

type=$1
shift

if [ -z "$1" ]; then
    git commit -m "$type: " -e
else
    git commit -m "$type: $*"
fi