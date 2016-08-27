//
//  AlarmObject.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 6/29/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "AlarmObject.h"
@implementation AlarmObject

@synthesize alarmTime,enabled,notificationID,gentleWake;

//This is important to for saving the alarm object in user defaults
-(void)setAlarm;
{
    
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.alarmTime forKey:@"alarmTime"];
    [encoder encodeBool:self.enabled forKey:@"enabled"];
    [encoder encodeInt:self.notificationID forKey:@"notificationID"];
}
//This is important to for loading the alarm object from user defaults
-(id)initWithCoder:(NSCoder *)decoder
{
    self.alarmTime = [decoder decodeObjectForKey:@"timeToSetOff"];
    self.enabled = [decoder decodeBoolForKey:@"enabled"];
    self.notificationID = [decoder decodeIntForKey:@"notificationID"];
    return self;
}


@end