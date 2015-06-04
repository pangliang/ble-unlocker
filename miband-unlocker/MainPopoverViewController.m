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


@interface MainPopoverViewController ()
@property(nonatomic,retain)IBOutlet NSTextField* rssiLabel;
@end

@implementation MainPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSThread detachNewThreadSelector:@selector(refreshDeviceRssi:) toTarget:self withObject:nil];
}

- (void) refreshDeviceRssi:(NSMutableArray *)toProceessDocids{
    while(true){
        dispatch_async(dispatch_get_main_queue(), ^{
            Device* device = (Device*)[[[BlutoothIO getInstance].devices allValues] objectAtIndex:0];
            [self.rssiLabel setStringValue:[device getRssi]];
        });
        [NSThread sleepForTimeInterval:0.3f];
    }
}

@end
