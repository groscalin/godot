#import "NotificationCenter.h"
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

#if VERSION_MAJOR == 3
#define CLASS_DB ClassDB
#else
#define CLASS_DB ObjectTypeDB
#endif

void NotificationCenter::init() {
    NSLog(@"NotificationCenter init");
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
       completionHandler:^(BOOL granted, NSError * _Nullable error) {
          // Enable or disable features based on authorization.
    }];
}

void NotificationCenter::scheduleLocal(const String& title, const String& msg, int intervalSec) {
    NSLog(@"NotificationCenter scheduleLocal");
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString stringWithCString:title.utf8().get_data() encoding: NSUTF8StringEncoding];
    content.body = [NSString stringWithCString:msg.utf8().get_data() encoding: NSUTF8StringEncoding];
    content.sound = [UNNotificationSound defaultSound];

    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
        triggerWithTimeInterval:intervalSec repeats: NO];

    UNNotificationRequest* request = [UNNotificationRequest
        requestWithIdentifier:@"GodotNotificationCenter" content:content trigger:trigger];

    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllPendingNotificationRequests];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

void NotificationCenter::_bind_methods() {
    CLASS_DB::bind_method("init",&NotificationCenter::init);
    CLASS_DB::bind_method("scheduleLocal",&NotificationCenter::scheduleLocal);
}
