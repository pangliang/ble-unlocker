//
//  MainPopoverViewController.m
//  miband-unlocker
//
//  Created by liangwei on 15/6/3.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import "MainPopoverViewController.h"
#import "BLEDeviceManager.h"
#import "Device.h"
#import "MacLocker.h"

@interface MainPopoverViewController ()
@property(nonatomic,retain)IBOutlet NSTextField* rssiLabel;
@property MacLocker* macLocker;
@end

@implementation MainPopoverViewController

- (id)init{
    self = [super init];
    self.macLocker = [[MacLocker alloc] init];
    [NSThread detachNewThreadSelector:@selector(refreshDeviceRssi:) toTarget:self withObject:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) refreshDeviceRssi:(NSMutableArray *)toProceessDocids{
    while(true){
        dispatch_async(dispatch_get_main_queue(), ^{
            if([[BLEDeviceManager getInstance].devices count] > 0)
            {
                Device* device = (Device*)[[[BLEDeviceManager getInstance].devices allValues] objectAtIndex:0];
                
                if( device.refreshRssiTimes >=5 )
                {
                    [self.rssiLabel setStringValue: [NSString stringWithFormat:@"%4.1f", [device getAvgRssi:5]]];
                    
                    if([device getAvgRssi:5] < -83)
                    {
                        [self.macLocker lock];
                    }else if([device getAvgRssi:5] > -70){
                        [self.macLocker unlock];
                    }
                }
                
            }
        });
        [NSThread sleepForTimeInterval:0.7f];
    }
}

@end
