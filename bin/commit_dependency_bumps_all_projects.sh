#!/usr/bin/env bash

# This script is used to build commit messages and committing when bumping one dependency across many projects.

# The functionality is as follows:
# 1. Ask the user if it is one dependency only or multiple dependencies (default 1).
# 2. If it is one dependency, ask for the dependency name and the new version.
# 3. If it is multiple dependencies, ask for a commit message.
# For each project (we use meta by mateodelnorte)
  # 5. Call meta wxec with commit_dependency_bump.sh and the commit message

# The script is used in the following way:

#   bin/commit_dependency_bumps_all_projects.sh

# 1. Ask the user if it is one dependency only or multiple dependencies (default 1).
echo "Are you commiting ONE dependency bump only? (Y/n)"
read -r ONE_DEPENDENCY

# 2. If it is one dependency, ask for the dependency name and the new version.
if [[ "$ONE_DEPENDENCY" == "n" ]]
then
  # 3. If it is multiple dependencies, ask for a commit message.
  echo "Please specify the commit message:"
  read -r COMMIT_MESSAGE
else
  echo "Please specify the dependency name:"
  read -r DEPENDENCY
  echo "Please specify the new version:"
  read -r NEW_VERSION
  COMMIT_MESSAGE="Bump $DEPENDENCY to $NEW_VERSION"
fi

# 7. Commit the change already added to the index.
# Let's check if there is anything in the index first
meta exec "test -z \"\$(git diff --cached)\" || sh -c '../bin/commit_dependency_bump.sh \"$COMMIT_MESSAGE\"'" --parallel --exclude "$(basename $(pwd))"
