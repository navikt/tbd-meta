#!/usr/bin/env bash

"$(dirname -- "$0")"/gw.sh dependencyUpdates --refresh-dependencies --init-script ../gradle/init/dependencies.gradle 2>&1 | grep '\->' | cut -d' ' -f3,4,5,6 | sed 's#\[##' | sed 's#\]##' | sort | uniq