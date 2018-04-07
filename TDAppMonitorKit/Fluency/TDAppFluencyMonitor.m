//
//  TDAppFluencyMonitor.m
//  TDAppMonitorKit
//
//  Created by 王志涛 on 2018/4/7.
//  Copyright © 2018年 beck.wang. All rights reserved.
//

#import "TDAppFluencyMonitor.h"
#import "TDBacktraceLogger.h"
#import <UIKit/UIKit.h>

#define TD_SEMAPHORE_SUCCESS 0
static BOOL td_is_monitoring = NO;
static dispatch_semaphore_t td_semaphore;
static NSTimeInterval td_time_out_interval = 0.5;

@implementation TDAppFluencyMonitor

static inline dispatch_queue_t __td_fluecy_monitor_queue() {
    static dispatch_queue_t td_fluecy_monitor_queue;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        td_fluecy_monitor_queue = dispatch_queue_create("com.beckwang.td_monitor_queue", NULL);
    });
    return td_fluecy_monitor_queue;
}

static inline void __td_monitor_init() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        td_semaphore = dispatch_semaphore_create(0);
    });
}

#pragma mark - Public
+ (instancetype)sharedMonitor {
    return [TDAppFluencyMonitor new];
}

- (void)startMonitoring {
#if DEBUG
    if (td_is_monitoring) { return; }
    td_is_monitoring = YES;
    __td_monitor_init();
    dispatch_async(__td_fluecy_monitor_queue(), ^{
        while (td_is_monitoring) {
            __block BOOL timeOut = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                timeOut = NO;
                dispatch_semaphore_signal(td_semaphore);
            });
            [NSThread sleepForTimeInterval: td_time_out_interval];
            if (timeOut) {
                [TDBacktraceLogger td_logMain];
            }
            dispatch_wait(td_semaphore, DISPATCH_TIME_FOREVER);
        }
    });
#endif
}

- (void)stopMonitoring {
    if (!td_is_monitoring) { return; }
    td_is_monitoring = NO;
}
@end
