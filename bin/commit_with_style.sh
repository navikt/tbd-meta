#!/bin/bash


# Get the commit style for a given repository based on the commit_style.json file.
repo_name=$(basename "$(pwd)")

# Look up the value in commit_style.json
commit_style=$(jq -r ".\"$repo_name\"" ../bin/commit_style.json)

# Build the right type of commit message based on the commit style.
commit_emoji="$1"
commit_message="$2"

case "$commit_style" in
    "prepend gitmoji") COMMIT_MESSAGE="$commit_emoji $commit_message";;
    "append gitmoji") COMMIT_MESSAGE="$commit_message $commit_emoji";;
    "plain") COMMIT_MESSAGE="$commit_message";;
    "arlo") COMMIT_MESSAGE="U - $commit_message";;
    *) echo "Commit style not found"; exit 1;;
esac

git commit -m "$COMMIT_MESSAGE"
