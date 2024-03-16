#!/usr/bin/env bash

git fetch origin > /dev/null
# Different git date formats: https://git-scm.com/docs/pretty-formats
# Format-string for date: https://git-scm.com/docs/pretty-formats#_format_patch
REPO=$(basename "$(pwd)" | sed 's#helse-##')
REPO=$(printf "%24s" "$REPO")
git log --since="8 days" --pretty=format:"%Cgreen%cd%Creset - %Cred%h%Creset - $REPO - %<(80)%s   %C(bold blue)<%an>%Creset" --date=format-local:'%Y-%m-%d %H:%M' --abbrev-commit --abbrev=9 origin/HEAD
