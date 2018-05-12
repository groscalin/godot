def can_build(plat):
    return plat == "iphone" or plat == "android" 

def configure(env):
    if (env['platform'] == 'android'):
        env.android_add_dependency("compile 'com.facebook.android:facebook-android-sdk:4.10.0'")
        env.android_add_to_manifest("android/AndroidManifestChunk.xml")
        env.android_add_java_dir("android/src/")
        env.disable_module()
    if (env['platform'] == 'iphone'):
        env.Append(FRAMEWORKPATH=['modules/GodotFacebook/ios/lib'])
        env.Append(LINKFLAGS=['-ObjC', '-framework','Bolts', '-framework','FBSDKCoreKit'])
