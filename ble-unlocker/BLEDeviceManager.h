//
//  BlutoothIO.h
//  miband-unlocker
//
//  Created by liangwei on 15/6/3.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEDeviceManager : NSObject
@property (strong,atomic) NSMutableDictionary *devices;
+ (BLEDeviceManager*) getInstance;
@end
