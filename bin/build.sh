#!/bin/sh -e

VERSION=1.0

# Navigate to the directory of this script
cd $(dirname $(readlink -f $0))
cd ..

build() {
    if [ "$(uname)" == "Darwin" ]; then
       ./bin/macos-build.sh $@
    elif [ "$(uname)" == "Linux" ]; then
       ./bin/linux-build.sh $@
    else
       echo "Unknown platform"
    fi
}

build
