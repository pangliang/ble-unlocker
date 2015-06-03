//
//  MacLocker.m
//  miband-unlocker
//
//  Created by liangwei on 15/5/29.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import "MacLocker.h"

NSString *password = @"xmdb7lwc";

@implementation MacLocker

+ (BOOL)isScreenLocked
{
    BOOL locked = NO;
    
    CFDictionaryRef CGSessionCurrentDictionary = CGSessionCopyCurrentDictionary();
    id o = [(__bridge NSDictionary*)CGSessionCurrentDictionary objectForKey:@"CGSSessionScreenIsLocked"];
    if (o) {
        locked = [o boolValue];
    }
    CFRelease(CGSessionCurrentDictionary);
    
    return locked;
}

+ (void)setPassword:(NSString*)p
{
    password = [p copy];
}

+ (void)lock
{
    if ([self isScreenLocked]) return;
    io_registry_entry_t r = IORegistryEntryFromPath(kIOMasterPortDefault, "IOService:/IOResources/IODisplayWrangler");
    if (r) {
        IORegistryEntrySetCFProperty(r, CFSTR("IORequestIdle"), kCFBooleanTrue);
        IOObjectRelease(r);
    }
    
    // show login window 1s after display idle
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // wakeup display from idle status to show login window
        io_registry_entry_t r = IORegistryEntryFromPath(kIOMasterPortDefault, "IOService:/IOResources/IODisplayWrangler");
        if (r) {
            IORegistryEntrySetCFProperty(r, CFSTR("IORequestIdle"), kCFBooleanFalse);
            IOObjectRelease(r);
        }
    });
    
    
}

+ (void)unlock
{
    if (![self isScreenLocked]) return;
    io_registry_entry_t r = IORegistryEntryFromPath(kIOMasterPortDefault, "IOService:/IOResources/IODisplayWrangler");
    if (r) {
        IORegistryEntrySetCFProperty(r, CFSTR("IORequestIdle"), kCFBooleanFalse);
        IOObjectRelease(r);
    }
    // use Apple Script to input password and unlock Mac
    NSString *s = @"tell application \"System Events\" to keystroke \"%@\"\n\
    tell application \"System Events\" to keystroke return";
    
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:[NSString stringWithFormat:s, password]];
    [script executeAndReturnError:nil];
}

@end
