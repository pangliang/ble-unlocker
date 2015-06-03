//
//  MainPopoverViewController.m
//  miband-unlocker
//
//  Created by liangwei on 15/6/3.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import "MainPopoverViewController.h"
#import "BlutoothIO.h"

@interface MainPopoverViewController ()
@property (atomic,strong) BlutoothIO* io;

@end

@implementation MainPopoverViewController

- (id)init{
    
    if ((self = [super init]))
    {
        self.io = [[BlutoothIO alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.io.peripherals count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    CBPeripheral *peripheral = [self.io.peripherals objectAtIndex:rowIndex];
    if(peripheral == NULL)
        return @"";
    if([[aTableColumn identifier] isEqualToString:@"deviceName"])
        return peripheral.name;
    else if([[aTableColumn identifier] isEqualToString:@"uuid"])
        return peripheral.identifier.UUIDString;
    return @"";
}

@end
