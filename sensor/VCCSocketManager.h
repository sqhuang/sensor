//
//  VCCSocketManager.h
//  sensor
//
//  Created by qiu on 2018/10/24.
//  Copyright © 2018 qiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

NS_ASSUME_NONNULL_BEGIN
@class GCDAsyncSocket;

@interface VCCSocketManager : NSObject
@property (strong, nonatomic)GCDAsyncSocket * vccSocket;
+ (VCCSocketManager *)sharedSocketManager;
@end

NS_ASSUME_NONNULL_END
