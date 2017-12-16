#!/bin/sh
BIN=${ANDROID_NDK_ROOT}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin
STRIP=$BIN/arm-linux-androideabi-strip
OBJCOPY=$BIN/arm-linux-androideabi-objcopy

cp $1 $1.org
$OBJCOPY --only-keep-debug $1 $1.sym
$STRIP --strip-debug --strip-unneeded $1
$OBJCOPY --add-gnu-debuglink=$1.sym $1
