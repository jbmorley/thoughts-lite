#!/bin/bash

# Copyright (c) 2024 Jason Morley
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -e
set -o pipefail
set -x
set -u

SCRIPTS_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROOT_DIRECTORY="$SCRIPTS_DIRECTORY/.."
BUILD_DIRECTORY="$ROOT_DIRECTORY/build"
PACKAGE_DIRECTORY="$BUILD_DIRECTORY/package"

function compile {
    lua "$SCRIPTS_DIRECTORY/opolua/src/compile.lua" "$@"
}

function makesis {
    lua "$SCRIPTS_DIRECTORY/opolua/src/makesis.lua" "$@"
}

# Create the build directory.
if [ -d "$BUILD_DIRECTORY" ] ; then
    rm -rf "$BUILD_DIRECTORY"
fi
mkdir -p "$BUILD_DIRECTORY"
mkdir -p "$PACKAGE_DIRECTORY"

cd "$PACKAGE_DIRECTORY"
compile --aif "$ROOT_DIRECTORY/Thoughts/Thoughts.opp" "Thoughts.app"
cp "$ROOT_DIRECTORY/Thoughts/Editor (Black & White).sis" .
cp "$ROOT_DIRECTORY/Thoughts/Editor (Black & White).sis" .
cp "$ROOT_DIRECTORY/Thoughts/Editor (Colour).sis" .
cp "$ROOT_DIRECTORY/Thoughts/Systinfo.sis" .
cp "$ROOT_DIRECTORY/Thoughts/Thoughts.pkg" .
makesis "Thoughts.pkg" "$BUILD_DIRECTORY/Thoughts.sis"

# Archive the build directory.
ZIP_BASENAME="build.zip"
ZIP_PATH="$BUILD_DIRECTORY/$ZIP_BASENAME"
pushd "$BUILD_DIRECTORY"
zip -r "$ZIP_BASENAME" .
popd
