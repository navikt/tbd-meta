#!/usr/bin/env bash

# This script is used to commit a dependency bump in one project.

# The script is used in the following way:

#  bin/commit_dependency_bump.sh "Bump blah-blah"

# 1. If a commit message is given as an argument, use that as a core (skip the next part)
if [[ -n $1 ]]
then
  COMMIT_MESSAGE=$1
else
  # Ask the user if it is one dependency only or multiple dependencies (default 1).
  echo "Are you commiting ONE dependency bump only? (Y/n)"
  read -r ONE_DEPENDENCY

  # 2. If it is one dependency, ask for the dependency name and the new version.
  if [[ "$ONE_DEPENDENCY" == "n" ]]
  then
    # 3. If it is multiple dependencies, ask for a commit message.
    echo "Please specify the commit message:"
    read -r COMMIT_MESSAGE
  else
    echo "Please specify the dependency (group:name):"
    read -r DEPENDENCY
    echo "Please specify the new version:"
    read -r NEW_VERSION
    COMMIT_MESSAGE="Bump $DEPENDENCY to $NEW_VERSION"
  fi
fi

# 3. Check if the repo uses gitmoji, and whether it prepends or appends the gitmoji.
# We look this up in a json file, based on the current folder.
# If there is no entry for the current folder, we fail.
# The file is commit_style.json, and it looks like this:
# { "repo1": "prepend gitmoji", "repo2": "append gitmoji", "repo3": "plain", "repo4": "arlo" }
# We use jq to look up the current folder, and get the value.
REPO=$(basename "$(pwd)")
COMMIT_STYLE=$(jq -r ".\"$REPO\"" ../bin/commit_style.json)

# 4. Build the right type of commit message:
case "$COMMIT_STYLE" in
  "prepend gitmoji") COMMIT_MESSAGE="⬆️ $COMMIT_MESSAGE";;
  "append gitmoji") COMMIT_MESSAGE="$COMMIT_MESSAGE ⬆️";;
  "plain") COMMIT_MESSAGE="$COMMIT_MESSAGE";;
  "arlo") COMMIT_MESSAGE="U - $COMMIT_MESSAGE";;
  *) echo "Commit style not found"; exit 1;;
esac

echo "Commit message: $COMMIT_MESSAGE"

# 5. Commit the change already added to the index.
git commit -m"$COMMIT_MESSAGE"

