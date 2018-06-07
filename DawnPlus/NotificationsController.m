//
//  NotificationsController.m
//  DawnPlus
//
//  Created by Xinke Chen on 2018-03-05.
//  Copyright © 2018 Xinke Chen. All rights reserved.
//

#import "NotificationsController.h"

@interface NotificationsController()

@property (nonatomic, nonnull, readwrite) UNUserNotificationCenter *center;
@property (nonatomic, readwrite) BOOL isBackgroundAlarmsAllowed;

@end

@implementation NotificationsController

@synthesize center, isBackgroundAlarmsAllowed;

- (id)init {
    self = [super init];
    isBackgroundAlarmsAllowed = NO;
    center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions: (UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^ (BOOL granted, NSError * _Nullable error){
        if (error) {
            NSLog(@"Error in obtaining authorization for notifications %@",error);
        }
        if(granted == YES) {
            isBackgroundAlarmsAllowed = YES;
        }
    }];
    return self;
}

- (void)scheduleNotificationForAlarm:(AlarmObject *)alarm {
    [center getNotificationSettingsWithCompletionHandler:^ (UNNotificationSettings *settings) {
        if(settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            isBackgroundAlarmsAllowed = YES;
        }
    }];
    if(isBackgroundAlarmsAllowed == NO) {
        // Notifications not available
        return;
    }
    NSLog(@"Attempting to schedule alarm: %@", alarm);
    // Creating content for notifications
    UNMutableNotificationContent *alarmContent = [[UNMutableNotificationContent alloc] init];
    alarmContent.title = alarm.label;
    alarmContent.body = @"This is a placeholder until conditions are shimed in";
    // Replace once notifications are working
    alarmContent.sound = [UNNotificationSound defaultSound];
    // Creating notification trigger
    NSDateComponents *alarmDate = [self getAlarmDateComponents:alarm.alarmTime];
    UNCalendarNotificationTrigger *alarmTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:alarmDate repeats:YES];
    // Creating notification request
    UNNotificationRequest *alarmRequest = [UNNotificationRequest requestWithIdentifier:alarm.notificationID content:alarmContent trigger:alarmTrigger];
    // adding request
    [center addNotificationRequest:alarmRequest withCompletionHandler:^ (NSError *error) {
        if(error != nil) {
            NSLog(@"Error in scheduling local notifications: %@", error);
        }
        
    }];
}


- (void)handleForeGroundNotification {
    
}

- (void)handleBackGroundNotification {
    
}

- (NSDateComponents *)getAlarmDateComponents:(NSDate *)date {
    if(!date) {
        return nil;
    }
    NSCalendar * calender = [NSCalendar currentCalendar];
    return [calender components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
}

// User Notification Delegate Methods

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler {
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"Handling notification with ID: %@",notification.request.identifier);
}

@end
