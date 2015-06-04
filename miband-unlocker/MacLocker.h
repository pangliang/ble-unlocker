//
//  MacLocker.h
//  miband-unlocker
//
//  Created by liangwei on 15/5/29.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MacLocker : NSObject

- (BOOL)isScreenLocked;
- (void)lock;
- (void)unlock;
- (void)setPassword:(NSString*)p;

@end
