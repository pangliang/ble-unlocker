//
//  AppDelegate.m
//  miband-unlocker
//
//  Created by liangwei on 15/5/29.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import "AppDelegate.h"
#import "BlutoothIO.h"


@interface AppDelegate()
@property (atomic,strong) BlutoothIO* io;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.io = [[BlutoothIO alloc] init];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}


@end



