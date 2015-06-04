//
//  BLEDevice.m
//  miband-unlocker
//
//  Created by liangwei on 15/6/4.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import "Device.h"

@interface Device()<CBPeripheralDelegate>

@property(nonatomic) CBPeripheral *peri;
@property(atomic,strong) NSNumber * rssi;
@property bool isStartAutoRefreshRssi;
@property long refreshRssiTimes;
@end

@implementation Device

- (id)init{
    self = [super init];
    return self;
}

- (void)setPeripheral:(CBPeripheral *)peripheral{
    self.peri = peripheral;
    self.peri.delegate = self;
}

- (CBPeripheral *)getPeripheral{
    return self.peri;
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"UpdateRSSI %ld,%@", self.refreshRssiTimes, peripheral.RSSI);
    
    self.rssi = peripheral.RSSI;
    
    [self refreshRssi:nil];
}

- (NSNumber*) getRssi{
    return self.rssi;
}

- (void)refreshRssi:(NSMutableArray *)toProceessDocids{
//    [NSThread sleepForTimeInterval:0.1f];
    if(self.isStartAutoRefreshRssi){
        self.refreshRssiTimes++;
        [self.peri readRSSI];
    }
}

- (void) startAutoRefreshRssi{
    NSLog(@"startAutoRefreshRssi: %@", self.peri.name);
    self.isStartAutoRefreshRssi = true;
    [NSThread detachNewThreadSelector:@selector(refreshRssi:) toTarget:self withObject:nil];
}

@end
