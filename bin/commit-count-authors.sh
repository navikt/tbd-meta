#!/usr/bin/env bash

git fetch origin > /dev/null
# Different git date formats: https://git-scm.com/docs/pretty-formats
# Format-string for date: https://git-scm.com/docs/pretty-formats#_format_patch
mkdir -p ../counts
REPO=$(basename "$(pwd)" | sed 's#helse-##')
git log --pretty=format:"%ad,%(trailers:key=Co-authored-by,separator=%x2C,keyonly=true)" > ../counts/"$REPO".log
awk -F'Co-authored-by' '{print $1 "authors=" NF}' ../counts/"$REPO".log > ../counts/"$REPO".csv
rm ../counts/"$REPO".log
