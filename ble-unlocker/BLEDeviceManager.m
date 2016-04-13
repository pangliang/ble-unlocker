//
//  BlutoothIO.m
//  miband-unlocker
//
//  Created by liangwei on 15/6/3.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import "BLEDeviceManager.h"
#import "Device.h"
@interface BLEDeviceManager()<CBCentralManagerDelegate>
@property (strong,nonatomic) CBCentralManager* central;
@end

NSLock *lock;
BLEDeviceManager* instance;

@implementation BLEDeviceManager

+ (BLEDeviceManager*) getInstance
{
    [lock lock];
    if(instance == NULL)
    {
        instance = [[BLEDeviceManager alloc] init];
    }
    [lock unlock];
    return instance;
}

- (id)init
{
    if ((self = [super init]))
    {
        self.central = [[CBCentralManager alloc]initWithDelegate:self queue:nil options:nil];
        self.devices=[[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    self.central = central;
    self.central.delegate = self;
    NSLog(@"centralManagerDidUpdateState:%ld",central.state);
    if (central.state == CBCentralManagerStatePoweredOn) {
        NSLog(@"scanForPeripheralsWithServices");
        [central scanForPeripheralsWithServices:nil
                                        options:nil];
        
        if([self.devices count] >0)
        {
            Device* device = (Device*)[[self.devices allValues] objectAtIndex:0];
            
            NSArray* knowPeripherals = [self.central retrievePeripheralsWithIdentifiers:[NSArray arrayWithObject:device.peripheral.identifier]];
            NSLog(@"%@",knowPeripherals);
            if([knowPeripherals count] == 1 && ((CBPeripheral *)[knowPeripherals objectAtIndex:0]).identifier == device.peripheral.identifier)
            {
                [self.central connectPeripheral:[knowPeripherals objectAtIndex:0] options:nil];
            }
        }
        
        
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"Peripheral connected: %@",peripheral.name);
    
    Device* device = [self.devices valueForKey:peripheral.identifier.UUIDString];
    if(device == NULL)
    {
        device = [[Device alloc] init:peripheral];
        [self.devices setValue:device forKey: peripheral.identifier.UUIDString];
    }
    [device autoRefreshRssi];
    
    [peripheral discoverServices:nil];
    
}

- (void)centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error{
    NSLog(@"didFailToConnectPeripheral: %@, error:%@",peripheral.name,error);
    
    Device* device = [self.devices valueForKey:peripheral.identifier.UUIDString];
    if(device != NULL)
    {
        NSArray* knowPeripherals = [self.central retrievePeripheralsWithIdentifiers:[NSArray arrayWithObject:peripheral.identifier]];
        NSLog(@"%@",knowPeripherals);
        if([knowPeripherals count] == 1 && ((CBPeripheral *)[knowPeripherals objectAtIndex:0]).identifier == peripheral.identifier)
        {
            [self.central connectPeripheral:peripheral options:nil];
        }else{
            [self.devices removeObjectForKey:peripheral.identifier.UUIDString];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    NSLog(@"didDisconnectPeripheral: %@, error:%@",peripheral.name,error);
    
    Device* device = [self.devices valueForKey:peripheral.identifier.UUIDString];
    if(device != NULL)
    {
        NSArray* knowPeripherals = [self.central retrievePeripheralsWithIdentifiers:[NSArray arrayWithObject:peripheral.identifier]];
        NSLog(@"%@",knowPeripherals);
        if([knowPeripherals count] == 1 && ((CBPeripheral *)[knowPeripherals objectAtIndex:0]).identifier == peripheral.identifier)
        {
            [self.central connectPeripheral:peripheral options:nil];
        }else{
            [self.devices removeObjectForKey:peripheral.identifier.UUIDString];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *) advertisementData
                  RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Discovered %@,%@", peripheral.name, peripheral.identifier.UUIDString);
//    [central stopScan];
    
    Device* device = [self.devices valueForKey:peripheral.identifier.UUIDString];
    if(device == NULL)
    {
        device = [[Device alloc] init:peripheral];
        [self.devices setValue:device forKey: peripheral.identifier.UUIDString];
    }
    
    if(peripheral.state == CBPeripheralStateDisconnected)
    {
        [central connectPeripheral:peripheral options:nil];
    }
}



@end
