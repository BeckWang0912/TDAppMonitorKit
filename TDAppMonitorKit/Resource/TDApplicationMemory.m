//
//  TDApplicationMemory.m
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//  应用Memory占用

#import "TDApplicationMemory.h"
#import <mach/mach.h>
#import <mach/task_info.h>

#ifndef NBYTE_PER_MB
#define NBYTE_PER_MB (1024 * 1024)
#endif

@implementation TDApplicationMemory

- (TDApplicationMemoryUsage)currentUsage {
    struct mach_task_basic_info info;
    mach_msg_type_number_t count = sizeof(info) / sizeof(integer_t);
    if (task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &count) == KERN_SUCCESS) {
        return (TDApplicationMemoryUsage){
            .usage = info.resident_size / NBYTE_PER_MB,
            .total = [NSProcessInfo processInfo].physicalMemory / NBYTE_PER_MB,
            .ratio = info.virtual_size / [NSProcessInfo processInfo].physicalMemory,
        };
    }
    return (TDApplicationMemoryUsage){ 0 };
}

@end
