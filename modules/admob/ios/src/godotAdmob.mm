#include "godotAdmob.h"
#import "app_delegate.h"
#import <GoogleMobileAds/GADMobileAds.h>

#if VERSION_MAJOR == 3
#define CLASS_DB ClassDB
#else
#define CLASS_DB ObjectTypeDB
#endif


GodotAdmob::GodotAdmob() {
    NSLog(@"GodotAdmob construct");
    ERR_FAIL_COND(instance != NULL);
    instance = this;
    initialized = false;
}

GodotAdmob::~GodotAdmob() {
    instance = NULL;
}

void GodotAdmob::init(bool isReal, const String &appId, int instanceId) {
    if (initialized) {
        NSLog(@"GodotAdmob Module already initialized");
        return;
    }
    
    initialized = true;

    NSString *appIdStr = [NSString stringWithCString:appId.utf8().get_data() encoding: NSUTF8StringEncoding];
    [GADMobileAds configureWithApplicationID:appIdStr];
    
    banner = [AdmobBanner alloc];
    [banner initialize :isReal :instanceId];
    
    interstitial = [AdmobInterstitial alloc];
    [interstitial initialize:isReal :instanceId];
    
    rewarded = [AdmobRewarded alloc];
    [rewarded initialize:isReal :instanceId];
}


void GodotAdmob::loadBanner(const String &bannerId, bool isOnTop) {
    if (!initialized) {
        NSLog(@"GodotAdmob Module not initialized");
        return;
    }
    
    NSString *idStr = [NSString stringWithCString:bannerId.utf8().get_data() encoding: NSUTF8StringEncoding];
    [banner loadBanner:idStr :isOnTop];

}

void GodotAdmob::showBanner() {
    if (!initialized) {
        NSLog(@"GodotAdmob Module not initialized");
        return;
    }
    
    [banner showBanner];
}

void GodotAdmob::hideBanner() {
    if (!initialized) {
        NSLog(@"GodotAdmob Module not initialized");
        return;
    }
    [banner hideBanner];
}


void GodotAdmob::resize() {
    if (!initialized) {
        NSLog(@"GodotAdmob Module not initialized");
        return;
    }
    [banner resize];
}

int GodotAdmob::getBannerWidth() {
    if (!initialized) {
        NSLog(@"GodotAdmob Module not initialized");
        return 0;
    }
    return (uintptr_t)[banner getBannerWidth];
}

int GodotAdmob::getBannerHeight() {
    if (!initialized) {
        NSLog(@"GodotAdmob Module not initialized");
        return 0;
    }
    return (uintptr_t)[banner getBannerHeight];
}

void GodotAdmob::loadInterstitial(const String &interstitialId) {
    if (!initialized) {
        NSLog(@"GodotAdmob Module not initialized");
        return;
    }
    
    NSString *idStr = [NSString stringWithCString:interstitialId.utf8().get_data() encoding: NSUTF8StringEncoding];
    [interstitial loadInterstitial:idStr];

}

void GodotAdmob::showInterstitial() {
    if (!initialized) {
        NSLog(@"GodotAdmob Module not initialized");
        return;
    }
    
    [interstitial showInterstitial];
    
}

void GodotAdmob::loadRewardedVideo(const String &rewardedId) {
    //init
    if (!initialized) {
        NSLog(@"GodotAdmob Module not initialized");
        return;
    }
    
    NSString *idStr = [NSString stringWithCString:rewardedId.utf8().get_data() encoding: NSUTF8StringEncoding];
    [rewarded loadRewardedVideo: idStr];
    
}

void GodotAdmob::showRewardedVideo() {
    //show
    if (!initialized) {
        NSLog(@"GodotAdmob Module not initialized");
        return;
    }
    
    [rewarded showRewardedVideo];
}



void GodotAdmob::_bind_methods() {
    CLASS_DB::bind_method("init",&GodotAdmob::init);
    CLASS_DB::bind_method("loadBanner",&GodotAdmob::loadBanner);
    CLASS_DB::bind_method("showBanner",&GodotAdmob::showBanner);
    CLASS_DB::bind_method("hideBanner",&GodotAdmob::hideBanner);
    CLASS_DB::bind_method("loadInterstitial",&GodotAdmob::loadInterstitial);
    CLASS_DB::bind_method("showInterstitial",&GodotAdmob::showInterstitial);
    CLASS_DB::bind_method("loadRewardedVideo",&GodotAdmob::loadRewardedVideo);
    CLASS_DB::bind_method("showRewardedVideo",&GodotAdmob::showRewardedVideo);
    CLASS_DB::bind_method("resize",&GodotAdmob::resize);
    CLASS_DB::bind_method("getBannerWidth",&GodotAdmob::getBannerWidth);
    CLASS_DB::bind_method("getBannerHeight",&GodotAdmob::getBannerHeight);
    CLASS_DB::bind_method("setMuted",&GodotAdmob::setMuted);
}

void GodotAdmob::setMuted(bool mute) {
    if (!initialized) {
        NSLog(@"GodotAdmob Module not initialized");
        return;
    }
    NSLog(@"GodotAdmob setMuted");
    [GADMobileAds sharedInstance].applicationMuted = YES;
    if(mute)
        [GADMobileAds sharedInstance].applicationVolume = 0.0;
    else
        [GADMobileAds sharedInstance].applicationVolume = 1.0;
}
