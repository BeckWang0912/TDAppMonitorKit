//
//  TDGlobalTimer.m
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//

#import "TDGlobalTimer.h"
#import "TDDispatchAsync.h"

static NSUInteger td_timer_time_interval = 2;
static dispatch_source_t td_global_timer = NULL;
static CFMutableDictionaryRef td_global_callbacks = NULL;

@implementation TDGlobalTimer

CF_INLINE void __TDSyncExecute(dispatch_block_t block) {
    TDDispatchQueueAsyncBlockInBackground(^{
        assert(block != nil);
        block();
    });
}

CF_INLINE void __TDInitGlobalCallbacks() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        td_global_callbacks = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    });
}

CF_INLINE void __TDResetTimer() {
    if (td_global_timer != NULL) {
        dispatch_source_cancel(td_global_timer);
    }
    td_global_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, TDDispatchQueueAsyncBlockInDefault(^{}));
    dispatch_source_set_timer(td_global_timer, DISPATCH_TIME_NOW, td_timer_time_interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(td_global_timer, ^{
        NSUInteger count = CFDictionaryGetCount(td_global_callbacks);
        void * callbacks[count];
        CFDictionaryGetKeysAndValues(td_global_callbacks, NULL, (const void **)callbacks);
        for (uint idx = 0; idx < count; idx++) {
            dispatch_block_t callback = (__bridge dispatch_block_t)callbacks[idx];
            callback();
        }
    });
}

CF_INLINE void __TDAutoSwitchTimer() {
    if (CFDictionaryGetCount(td_global_callbacks) > 0) {
        if (td_global_timer == NULL) {
            __TDResetTimer();
            dispatch_resume(td_global_timer);
        }
    } else {
        if (td_global_timer != NULL) {
            dispatch_source_cancel(td_global_timer);
            td_global_timer = NULL;
        }
    }
}

+ (NSString *)registerTimerCallback: (dispatch_block_t)callback {
    NSString * key = [NSString stringWithFormat: @"%.2f", [[NSDate date] timeIntervalSince1970]];
    [self registerTimerCallback: callback key: key];
    return key;
}

+ (void)registerTimerCallback: (dispatch_block_t)callback key: (NSString *)key {
    if (!callback) { return; }
    __TDInitGlobalCallbacks();
    __TDSyncExecute(^{
        CFDictionarySetValue(td_global_callbacks, (__bridge void *)key, (__bridge void *)[callback copy]);
        __TDAutoSwitchTimer();
    });
}

+ (void)resignTimerCallbackWithKey: (NSString *)key {
    if (key == nil) { return; }
    __TDInitGlobalCallbacks();
    __TDSyncExecute(^{
        CFDictionaryRemoveValue(td_global_callbacks, (__bridge void *)key);
        __TDAutoSwitchTimer();
    });
}

+ (void)setCallbackInterval: (NSUInteger)interval {
    if (interval <= 0) { interval = 1; }
    td_timer_time_interval = interval;
}

@end

