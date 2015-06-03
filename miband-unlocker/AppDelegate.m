//
//  AppDelegate.m
//  miband-unlocker
//
//  Created by liangwei on 15/5/29.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import "AppDelegate.h"
#import "MacLocker.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface AppDelegate ()<CBCentralManagerDelegate>
@property (strong,nonatomic) CBCentralManager* central;
@end

@implementation AppDelegate

- (id)init
{
    NSLog(@"hello init");
    if ((self = [super init]))
    {
//        self.central = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    return self;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.central = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {

}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn) {
        NSLog(@"scanForPeripheralsWithServices");
        [central scanForPeripheralsWithServices:nil
                                        options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
        
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"Peripheral connected");
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Discovered %@", peripheral.name);
    [central stopScan];
}



@end



