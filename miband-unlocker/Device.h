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
- (void)setPeripheral:(CBPeripheral *)peripheral;
- (CBPeripheral *)getPeripheral;
- (NSNumber *) getRssi;
- (void) startAutoRefreshRssi;
@end
