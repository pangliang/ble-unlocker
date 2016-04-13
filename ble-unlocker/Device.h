//
//  BLEDevice.h
//  miband-unlocker
//
//  Created by liangwei on 15/6/4.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface Device : NSObject
- (id)init:(CBPeripheral *)peripheral;
- (float) getLastRssi;
- (float) getAvgRssi:(int) avgTimes;
- (void) autoRefreshRssi;
@property int refreshRssiTimes;
@property(nonatomic) CBPeripheral *peripheral;
@end
