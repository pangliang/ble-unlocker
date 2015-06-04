//
//  BlutoothIO.m
//  miband-unlocker
//
//  Created by liangwei on 15/6/3.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import "BlutoothIO.h"
#import "Device.h"
@interface BlutoothIO()<CBCentralManagerDelegate>
@property (strong,nonatomic) CBCentralManager* central;
@end

NSLock *lock;
BlutoothIO* instance;

@implementation BlutoothIO

+ (BlutoothIO*) getInstance
{
    [lock lock];
    if(instance == NULL)
    {
        instance = [[BlutoothIO alloc] init];
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
    NSLog(@"centralManagerDidUpdateState:%ld",central.state);
    if (central.state == CBCentralManagerStatePoweredOn) {
        NSLog(@"scanForPeripheralsWithServices");
        [central scanForPeripheralsWithServices:nil
                                        options:nil];
        
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"Peripheral connected: %@",peripheral.name);
    
    Device* device = [self.devices valueForKey:peripheral.identifier.UUIDString];
    if(device == NULL)
    {
        device = [[Device alloc] init];
        [device setPeripheral:peripheral];
        [self.devices setValue:device forKey: peripheral.identifier.UUIDString];
    }
    [device startAutoRefreshRssi];
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

    
    Device* device = [self.devices valueForKey:peripheral.identifier.UUIDString];
    if(device == NULL)
    {
        device = [[Device alloc] init];
        [device setPeripheral:peripheral];
        [self.devices setValue:device forKey: peripheral.identifier.UUIDString];
        
        [central connectPeripheral:peripheral options:nil];
    }
}



@end
