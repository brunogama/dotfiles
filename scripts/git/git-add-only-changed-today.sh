#!/usr/bin/env bash

git add $(git diff --name-only --diff-filter=ACMRT --since="yesterday")