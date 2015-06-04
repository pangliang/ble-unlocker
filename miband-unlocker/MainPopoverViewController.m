//
//  MainPopoverViewController.m
//  miband-unlocker
//
//  Created by liangwei on 15/6/3.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import "MainPopoverViewController.h"
#import "BlutoothIO.h"
#import "Device.h"
#import "MacLocker.h"

@interface MainPopoverViewController ()
@property(nonatomic,retain)IBOutlet NSTextField* rssiLabel;
@property MacLocker* macLocker;
@end

@implementation MainPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.macLocker = [[MacLocker alloc] init];
    [NSThread detachNewThreadSelector:@selector(refreshDeviceRssi:) toTarget:self withObject:nil];
}

- (void) refreshDeviceRssi:(NSMutableArray *)toProceessDocids{
    while(true){
        dispatch_async(dispatch_get_main_queue(), ^{
            if([[BlutoothIO getInstance].devices count] > 0)
            {
                Device* device = (Device*)[[[BlutoothIO getInstance].devices allValues] objectAtIndex:0];
                
                if( [device getRssi] != nil)
                {
                    [self.rssiLabel setStringValue: [[device getRssi] stringValue]];
                    
                    if([[device getRssi] floatValue] < -83)
                    {
                        [self.macLocker lock];
                    }else if([[device getRssi] floatValue] > -70){
                        [self.macLocker unlock];
                    }
                }
                
            }
        });
        [NSThread sleepForTimeInterval:0.3f];
    }
}

@end
