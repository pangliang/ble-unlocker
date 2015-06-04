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
@property(nonatomic,retain)IBOutlet NSTextField* sensitivityLabel;
@property(nonatomic,retain)IBOutlet NSSlider* sensitivitySlider;
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

- (IBAction)sliderMove:(id)sender{
    [self.sensitivityLabel setStringValue: [NSString stringWithFormat:@"%d",[self.sensitivitySlider intValue]]];
}

- (void) refreshDeviceRssi:(NSMutableArray *)toProceessDocids{
    while(true){
        dispatch_async(dispatch_get_main_queue(), ^{
            if([[BLEDeviceManager getInstance].devices count] > 0)
            {
                Device* device = (Device*)[[[BLEDeviceManager getInstance].devices allValues] objectAtIndex:0];
                
                int sensitivity = 10 - [self.sensitivitySlider intValue] + 1;
                
                if( device.refreshRssiTimes >= sensitivity )
                {
                    float avgRssi =  [device getAvgRssi: sensitivity];
                    [self.rssiLabel setStringValue: [NSString stringWithFormat:@"%4.1f",avgRssi]];
                    
                    if(avgRssi < -83)
                    {
                        [self.macLocker lock];
                    }else if(avgRssi > -70){
                        [self.macLocker unlock];
                    }
                }
                
            }
        });
        [NSThread sleepForTimeInterval:0.7f];
    }
}

@end
