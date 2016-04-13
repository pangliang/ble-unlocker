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
@property(nonatomic,retain)IBOutlet NSTextField* lockSliderValueLabel;
@property(nonatomic,retain)IBOutlet NSTextField* unlockSliderValueLabel;

@property(nonatomic,retain)IBOutlet NSSlider* sensitivitySlider;
@property(nonatomic,retain)IBOutlet NSSlider* rssiSlider;
@property(nonatomic,retain)IBOutlet NSSlider* lockSlider;
@property(nonatomic,retain)IBOutlet NSSlider* unlockSlider;
@property MacLocker* macLocker;
@end


int lockUnlockSpace = 10;

@implementation MainPopoverViewController

- (id)init{
    self = [super init];
    self.macLocker = [[MacLocker alloc] init];
    [NSThread detachNewThreadSelector:@selector(refreshDeviceRssi:) toTarget:self withObject:nil];
    return self;
}

- (IBAction)lockSliderMove:(id)sender{
    float rssiToLock = [self reverseVal:self.lockSlider];
    float rssiToUnlock = [self reverseVal:self.unlockSlider];
    
    if(rssiToLock > rssiToUnlock - lockUnlockSpace )
    {
        rssiToLock = rssiToUnlock - lockUnlockSpace;
        [self setReverseVal:self.lockSlider value:rssiToLock];
    }
    
    [self.lockSliderValueLabel setStringValue: [NSString stringWithFormat:@"%4.1f",rssiToLock]];
}

- (IBAction)unlockSliderMove:(id)sender{
    float rssiToLock = [self reverseVal:self.lockSlider];
    float rssiToUnlock = [self reverseVal:self.unlockSlider];
    
    if(rssiToUnlock < rssiToLock + lockUnlockSpace )
    {
        rssiToUnlock = rssiToLock + lockUnlockSpace;
        [self setReverseVal:self.unlockSlider value:rssiToUnlock];
    }
    
    [self.unlockSliderValueLabel setStringValue: [NSString stringWithFormat:@"%4.1f",rssiToUnlock]];
}

- (float)reverseVal:(NSSlider*) slider{
    return [slider maxValue] - [slider intValue] + [slider minValue];
}

- (void)setReverseVal:(NSSlider*)slider value:(float)value{
    float reverseVal = [slider maxValue] - value + [slider minValue];
    [slider setFloatValue:reverseVal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self lockSliderMove:nil];
    [self unlockSliderMove:nil];
}

- (void) refreshDeviceRssi:(NSMutableArray *)toProceessDocids{
    while(true){
        int sensitivity = [self reverseVal:self.sensitivitySlider];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if([[BLEDeviceManager getInstance].devices count] > 0)
            {
                Device* device = (Device*)[[[BLEDeviceManager getInstance].devices allValues] objectAtIndex:0];
                
                if( device.refreshRssiTimes >= sensitivity )
                {
                    float avgRssi =  [device getAvgRssi: sensitivity];
                    [self.rssiLabel setStringValue: [NSString stringWithFormat:@"%4.1f",avgRssi]];
                    [self setReverseVal:self.rssiSlider value:avgRssi];
                    
                    if(avgRssi < [self reverseVal:self.lockSlider])
                    {
                        [self.macLocker lock];
                    }else if(avgRssi > [self reverseVal:self.unlockSlider]){
                        [self.macLocker unlock];
                    }
                }
            }
        });
        [NSThread sleepForTimeInterval:0.5f+sensitivity/2];
    }
}

@end
