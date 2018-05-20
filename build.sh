#!/bin/sh

function failed()
{
    error=${1:-Undefined error}
    echo "FAIL: $error" >&2
    exit 1
}

export SCRIPT_AES256_ENCRYPTION_KEY="75327ac9b681239ae686177bc0945d9d8a43642279f363a5011021774c4ff83e"

#osx
echo "######################## OSX ############################"
scons -j 8 p=osx tools=yes verbose=no warnings=no 
[ $? -eq 0 ] || failed osx
cp bin/godot.osx.tools.32 /usr/local/bin/godot

#android
echo "######################## Android(armv7-release) ############################"
rm platform/android/java/libs/release/armeabi-v7a/*

scons -j 8 p=android target=release tools=no deprecated=no gdscript=yes minizip=no xml=no disable_3d=yes disable_advanced_gui=yes verbose=no warnings=no builtin_freetype=yes builtin_glew=yes builtin_libmpcdec=no builtin_libogg=no builtin_libpng=yes builtin_libtheora=no builtin_libvorbis=no builtin_libwebp=yes builtin_openssl=no builtin_opus=no builtin_speex=no builtin_squish=no builtin_zlib=yes android_neon=yes game_center=no store_kit=no icloud=no ios_gles22_override=yes ios_exceptions=no ios_triple=no ios_sim=no force_32_bits=no module_chibi_enabled=no module_cscript_enabled=no module_dds_enabled=no module_dlscript_enabled=no module_enet_enabled=no module_etc_enabled=no module_etc1_enabled=no module_freetype_enabled=yes module_gdnative_enabled=no module_gdscript_enabled=yes module_gridmap_enabled=no module_hdr_enabled=no module_ik_enabled=no module_jpg_enabled=no module_mpc_enabled=no module_ogg_enabled=no module_openssl_enabled=no module_opus_enabled=no module_pbm_enabled=no module_pvr_enabled=no module_regex_enabled=no module_speex_enabled=no module_squish_enabled=no module_stb_vorbis_enabled=no module_sumator_enabled=no module_tga_enabled=no module_theora_enabled=no module_tinyexr_enabled=no module_visual_script_enabled=no module_vorbis_enabled=no module_webm_enabled=no module_webp_enabled=yes
[ $? -eq 0 ] || failed android

sh strip.sh platform/android/java/libs/release/armeabi-v7a/libgodot_android.so
cd platform/android/java
./gradlew assembleRelease
cd ../../..
cp bin/android_release.apk ~/.godot/templates

echo "######################## Android(armv7-debug) ############################"
rm platform/android/java/libs/debug/armeabi-v7a/*

scons -j 8 p=android target=debug_release tools=no deprecated=no gdscript=yes minizip=no xml=no disable_3d=yes disable_advanced_gui=yes verbose=no warnings=no builtin_freetype=yes builtin_glew=yes builtin_libmpcdec=no builtin_libogg=no builtin_libpng=yes builtin_libtheora=no builtin_libvorbis=no builtin_libwebp=yes builtin_openssl=no builtin_opus=no builtin_speex=no builtin_squish=no builtin_zlib=yes android_neon=yes game_center=no store_kit=no icloud=no ios_gles22_override=yes ios_exceptions=no ios_triple=no ios_sim=no force_32_bits=no module_chibi_enabled=no module_cscript_enabled=no module_dds_enabled=no module_dlscript_enabled=no module_enet_enabled=no module_etc_enabled=no module_etc1_enabled=no module_freetype_enabled=yes module_gdnative_enabled=no module_gdscript_enabled=yes module_gridmap_enabled=no module_hdr_enabled=no module_ik_enabled=no module_jpg_enabled=no module_mpc_enabled=no module_ogg_enabled=no module_openssl_enabled=no module_opus_enabled=no module_pbm_enabled=no module_pvr_enabled=no module_regex_enabled=no module_speex_enabled=no module_squish_enabled=no module_stb_vorbis_enabled=no module_sumator_enabled=no module_tga_enabled=no module_theora_enabled=no module_tinyexr_enabled=no module_visual_script_enabled=no module_vorbis_enabled=no module_webm_enabled=no module_webp_enabled=yes
[ $? -eq 0 ] || failed android

cd platform/android/java
./gradlew assembleDebug
cd ../../..
cp bin/android_debug.apk ~/.godot/templates

echo "######################## iOS (32bit) ############################"
scons -j 8 p=iphone target=release tools=no deprecated=no gdscript=yes minizip=no xml=no disable_3d=yes disable_advanced_gui=yes verbose=no warnings=no builtin_freetype=yes builtin_glew=yes builtin_libmpcdec=no builtin_libogg=no builtin_libpng=yes builtin_libtheora=no builtin_libvorbis=no builtin_libwebp=yes builtin_openssl=no builtin_opus=no builtin_speex=no builtin_squish=no builtin_zlib=yes android_neon=no module_chibi_enabled=no module_cscript_enabled=no module_dds_enabled=no module_dlscript_enabled=no module_enet_enabled=no module_etc_enabled=no module_etc1_enabled=no module_freetype_enabled=yes module_gdnative_enabled=no module_gdscript_enabled=yes module_gridmap_enabled=no module_hdr_enabled=no module_ik_enabled=no module_jpg_enabled=no module_mpc_enabled=no module_ogg_enabled=no module_openssl_enabled=no module_opus_enabled=no module_pbm_enabled=no module_pvr_enabled=no module_regex_enabled=no module_speex_enabled=no module_squish_enabled=no module_stb_vorbis_enabled=no module_sumator_enabled=no module_tga_enabled=no module_theora_enabled=no module_tinyexr_enabled=no module_visual_script_enabled=no module_vorbis_enabled=no module_webm_enabled=no module_webp_enabled=yes icloud=no IPHONESDK="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS11.3.sdk" bits=32 arch=arm
[ $? -eq 0 ] || failed ios

echo "######################## iOS (64bit) ############################"
scons -j 8 p=iphone target=release tools=no deprecated=no gdscript=yes minizip=no xml=no disable_3d=yes disable_advanced_gui=yes verbose=no warnings=no builtin_freetype=yes builtin_glew=yes builtin_libmpcdec=no builtin_libogg=no builtin_libpng=yes builtin_libtheora=no builtin_libvorbis=no builtin_libwebp=yes builtin_openssl=no builtin_opus=no builtin_speex=no builtin_squish=no builtin_zlib=yes android_neon=no module_chibi_enabled=no module_cscript_enabled=no module_dds_enabled=no module_dlscript_enabled=no module_enet_enabled=no module_etc_enabled=no module_etc1_enabled=no module_freetype_enabled=yes module_gdnative_enabled=no module_gdscript_enabled=yes module_gridmap_enabled=no module_hdr_enabled=no module_ik_enabled=no module_jpg_enabled=no module_mpc_enabled=no module_ogg_enabled=no module_openssl_enabled=no module_opus_enabled=no module_pbm_enabled=no module_pvr_enabled=no module_regex_enabled=no module_speex_enabled=no module_squish_enabled=no module_stb_vorbis_enabled=no module_sumator_enabled=no module_tga_enabled=no module_theora_enabled=no module_tinyexr_enabled=no module_visual_script_enabled=no module_vorbis_enabled=no module_webm_enabled=no module_webp_enabled=yes icloud=no IPHONESDK="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS11.3.sdk" bits=64 arch=arm64
[ $? -eq 0 ] || failed ios

lipo -create bin/godot.iphone.opt.arm bin/godot.iphone.opt.arm64 -output bin/godot.iphone.opt.universal
cp bin/godot.iphone.opt.universal ~/Projects/godot/godot_ios_xcode/godot.iphone.opt.universal
