#!/bin/bash

set -u

SOURCE_PATH="$1"

magick "$SOURCE_PATH" -define bmp:format=bmp3 -depth 8 -colors 256 icon.bmp
magick "$SOURCE_PATH" -alpha extract -threshold 0 -negate -define bmp:format=bmp3 -type bilevel mask.bmp
wine ~/Downloads/bmconv/Bmconv.exe icon.mbm /c8icon.bmp mask.bmp
