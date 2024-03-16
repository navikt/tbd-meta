#!/usr/bin/env bash

source $(dirname -- "$0")/java_use.sh
DEFAULT_JAVA=11
export JAVA_VERSION=$(test -f .java-version && cat .java-version || echo "$DEFAULT_JAVA")
java_use $JAVA_VERSION

if test -f build.gradle || test -f build.gradle.kts; then
  if [ -z ${GRADLEW_VERSION+x} ]; then
    echo "GRADLEW_VERSION must be set";
  else
    echo "Stashing ..."
    git stash -u
    echo "Upgrading ..."
    ./gradlew wrapper --gradle-version "$GRADLEW_VERSION" --distribution-type all
    echo "Building post-upgrade ..."
    $(dirname -- "$0")/build.sh
    echo "Committing changes ..."
    git add gradle gradlew.bat gradlew

    REPO=$(basename "$(pwd)")
    COMMIT_STYLE=$(jq -r ".\"$REPO\"" ../bin/commit_style.json)
    COMMIT_MESSAGE="Upgrade Gradle wrapper to $GRADLEW_VERSION"
    case "$COMMIT_STYLE" in
      "prepend gitmoji") COMMIT_MESSAGE="⬆️ $COMMIT_MESSAGE";;
      "append gitmoji") COMMIT_MESSAGE="$COMMIT_MESSAGE ⬆️";;
      "plain") COMMIT_MESSAGE="$COMMIT_MESSAGE";;
      "arlo") COMMIT_MESSAGE="U - $COMMIT_MESSAGE";;
      *) echo "Commit style not found"; exit 1;;
    esac
    git commit -m"$COMMIT_MESSAGE"
  fi
else
  echo "Not a gradle project."
fi


