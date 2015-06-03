//
//  BlutoothIO.m
//  miband-unlocker
//
//  Created by liangwei on 15/6/3.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import "BlutoothIO.h"
@interface BlutoothIO()
@property (strong,nonatomic) CBCentralManager* central;
@end

@implementation BlutoothIO

- (id)init
{
    if ((self = [super init]))
    {
        self.central = [[CBCentralManager alloc]initWithDelegate:self queue:nil options:nil];
        self.peripherals=[NSMutableArray new];
    }
    return self;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState:%ld",central.state);
    if (central.state == CBCentralManagerStatePoweredOn) {
        NSLog(@"scanForPeripheralsWithServices");
        [central scanForPeripheralsWithServices:nil
                                        options:nil];
        
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"Peripheral connected: %@",peripheral.name);
    [peripheral readRSSI];
}

- (void)centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error{
    NSLog(@"didFailToConnectPeripheral: %@, error:%@",peripheral.name,error);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *) advertisementData
                  RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Discovered %@,%@", peripheral.name, peripheral.identifier.UUIDString);
    [central stopScan];
    
    [self.peripherals addObject:peripheral];
    peripheral.delegate = self;
    [central connectPeripheral:peripheral options:nil];
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral
                          error:(NSError *)error{
    NSLog(@"peripheralDidUpdateRSSI %@", peripheral.RSSI);

}

@end
