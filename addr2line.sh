#/bin/sh
ADDR=$1
/Users/amugana/Library/Android/ndk-r13b/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin/arm-linux-androideabi-addr2line -f -C -e platform/android/java/libs/release/armeabi-v7a/libgodot_android.so.sym $ADDR
