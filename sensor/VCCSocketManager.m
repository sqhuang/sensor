//
//  VCCSocketManager.m
//  sensor
//
//  Created by qiu on 2018/10/24.
//  Copyright © 2018 qiu. All rights reserved.
//

#import "VCCSocketManager.h"

@implementation VCCSocketManager
+ (VCCSocketManager *)sharedSocketManager
{
    static VCCSocketManager *socket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socket = [[VCCSocketManager alloc] init];
    });
    return socket;
}
@end
