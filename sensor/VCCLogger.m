//
//  VCCLogger.m
//  sensor
//
//  Created by qiu on 2018/10/18.
//  Copyright © 2018 qiu. All rights reserved.
//

#import "VCCLogger.h"

@implementation VCCLogger


+(NSString *)nowString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss.SSSSSS";
    
    NSDate *now = [NSDate date];
    NSString *nowString = [formatter stringFromDate:now];
    return nowString;
}
@end
