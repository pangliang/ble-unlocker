//
//  BLEDevice.m
//  miband-unlocker
//
//  Created by liangwei on 15/6/4.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import "Device.h"

@interface Device()<CBPeripheralDelegate>

@property bool isAutoRefreshRssi;
@property NSMutableArray* rssiList;

@end

int MaxRssiInStore = 10;

@implementation Device

- (id)init:(CBPeripheral *)peripheral{
    self = [super init];
    self.peripheral = peripheral;
    self.peripheral.delegate = self;
    self.refreshRssiTimes = 0;
    self.rssiList = [[NSMutableArray alloc] initWithCapacity:MaxRssiInStore];
    return self;
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"UpdateRSSI %@,%d,%d,%@",peripheral.name, self.refreshRssiTimes,(self.refreshRssiTimes % MaxRssiInStore), peripheral.RSSI);
    
    [self.rssiList setObject:peripheral.RSSI atIndexedSubscript:(self.refreshRssiTimes % MaxRssiInStore) ];
    self.refreshRssiTimes++;
    
    if(self.isAutoRefreshRssi && self.peripheral.state == CBPeripheralStateConnected){
        [self.peripheral readRSSI];
    }
    
//    NSLog(@"%@",self.rssiList);
}

- (float) getLastRssi{
    return [[self.rssiList objectAtIndex:(self.refreshRssiTimes % MaxRssiInStore)] floatValue];
}

- (float) getAvgRssi:(int) avgTimes{
    if(avgTimes > MaxRssiInStore)
        avgTimes = MaxRssiInStore;
    if(avgTimes > self.refreshRssiTimes)
        avgTimes = (int)self.refreshRssiTimes;
    float sum = 0;
    for(int i=1;i<=avgTimes;i++)
    {
        int index = (self.refreshRssiTimes % MaxRssiInStore) - i;
        if(index < 0)
            index = MaxRssiInStore + index;
//        printf("%1.0f,",[((NSNumber*)[self.rssiList objectAtIndex:index]) floatValue]);
        sum += [((NSNumber*)[self.rssiList objectAtIndex:index]) floatValue];
    }
    
//    printf("\n");
    
    return sum/avgTimes;
}

- (void) autoRefreshRssi{
    NSLog(@"autoRefreshRssi: %@",self.peripheral.name);
    self.isAutoRefreshRssi = true;
    [self.peripheral readRSSI];
}

@end
