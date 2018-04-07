//
//  TDDispatchQueuePool.m
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//

#import "TDDispatchAsync.h"
#import <libkern/OSAtomic.h>

#ifndef TDDispatchAsync_m
#define TDDispatchAsync_m
#endif

#define TD_QUEUE_MAX_COUNT 32
#define ST_INLINE static inline


typedef struct __TDDispatchContext {
    const char * name;
    void ** queues;
    uint32_t queueCount;
    int32_t offset;
} *DispatchContext, TDDispatchContext;


ST_INLINE dispatch_queue_priority_t __TDQualityOfServiceToDispatchPriority(TDQualityOfService qos) {
    switch (qos) {
        case TDQualityOfServiceUserInteractive: return DISPATCH_QUEUE_PRIORITY_HIGH;
        case TDQualityOfServiceUserInitiated: return DISPATCH_QUEUE_PRIORITY_HIGH;
        case TDQualityOfServiceUtility: return DISPATCH_QUEUE_PRIORITY_LOW;
        case TDQualityOfServiceBackground: return DISPATCH_QUEUE_PRIORITY_BACKGROUND;
        case TDQualityOfServiceDefault: return DISPATCH_QUEUE_PRIORITY_DEFAULT;
        default: return DISPATCH_QUEUE_PRIORITY_DEFAULT;
    }
}

ST_INLINE qos_class_t __TDQualityOfServiceToQOSClass(TDQualityOfService qos) {
    switch (qos) {
        case TDQualityOfServiceUserInteractive: return QOS_CLASS_USER_INTERACTIVE;
        case TDQualityOfServiceUserInitiated: return QOS_CLASS_USER_INITIATED;
        case TDQualityOfServiceUtility: return QOS_CLASS_UTILITY;
        case TDQualityOfServiceBackground: return QOS_CLASS_BACKGROUND;
        case TDQualityOfServiceDefault: return QOS_CLASS_DEFAULT;
        default: return QOS_CLASS_UNSPECIFIED;
    }
}

ST_INLINE dispatch_queue_attr_t __TDQoSToQueueAttributes(TDQualityOfService qos) {
    dispatch_qos_class_t qosClass = __TDQualityOfServiceToQOSClass(qos);
    return dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, qosClass, 0);
};

ST_INLINE dispatch_queue_t __TDQualityOfServiceToDispatchQueue(TDQualityOfService qos, const char * queueName) {
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0) {
        dispatch_queue_attr_t attr = __TDQoSToQueueAttributes(qos);
        return dispatch_queue_create(queueName, attr);
    } else {
        dispatch_queue_t queue = dispatch_queue_create(queueName, DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(queue, dispatch_get_global_queue(__TDQualityOfServiceToDispatchPriority(qos), 0));
        return queue;
    }
}

ST_INLINE DispatchContext __TDDispatchContextCreate(const char * name,
                                                      uint32_t queueCount,
                                                      TDQualityOfService qos) {
    DispatchContext context = calloc(1, sizeof(TDDispatchContext));
    if (context == NULL) { return NULL; }
    
    context->queues = calloc(queueCount, sizeof(void *));
    if (context->queues == NULL) {
        free(context);
        return NULL;
    }
    for (int idx = 0; idx < queueCount; idx++) {
        context->queues[idx] = (__bridge_retained void *)__TDQualityOfServiceToDispatchQueue(qos, name);
    }
    context->queueCount = queueCount;
    if (name) {
        context->name = strdup(name);
    }
    context->offset = 0;
    return context;
}

ST_INLINE void __TDDispatchContextRelease(DispatchContext context) {
    if (context == NULL) { return; }
    if (context->queues != NULL) { free(context->queues);  }
    if (context->name != NULL) { free((void *)context->name); }
    context->queues = NULL;
    if (context) { free(context); }
}

ST_INLINE dispatch_semaphore_t __TDSemaphore() {
    static dispatch_semaphore_t semaphore;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        semaphore = dispatch_semaphore_create(0);
    });
    return semaphore;
}

ST_INLINE dispatch_queue_t __TDDispatchContextGetQueue(DispatchContext context) {
    dispatch_semaphore_wait(__TDSemaphore(), dispatch_time(DISPATCH_TIME_NOW, DISPATCH_TIME_FOREVER));
    uint32_t offset = (uint32_t)OSAtomicIncrement32(&context->offset);
    dispatch_queue_t queue = (__bridge dispatch_queue_t)context->queues[offset % context->queueCount];
    dispatch_semaphore_signal(__TDSemaphore());
    if (queue) { return queue; }
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

ST_INLINE DispatchContext __TDDispatchContextGetForQos(TDQualityOfService qos) {
    static DispatchContext contexts[5];
    int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
    count = MIN(1, MAX(count, TD_QUEUE_MAX_COUNT));
    switch (qos) {
        case TDQualityOfServiceUserInteractive: {
            static dispatch_once_t once;
            dispatch_once(&once, ^{
                contexts[0] = __TDDispatchContextCreate("com.beckwang.user_interactive", count, qos);
            });
            return contexts[0];
        }
            
        case TDQualityOfServiceUserInitiated: {
            static dispatch_once_t once;
            dispatch_once(&once, ^{
                contexts[1] = __TDDispatchContextCreate("com.beckwang.user_initated", count, qos);
            });
            return contexts[1];
        }
            
        case TDQualityOfServiceUtility: {
            static dispatch_once_t once;
            dispatch_once(&once, ^{
                contexts[2] = __TDDispatchContextCreate("com.beckwang.utility", count, qos);
            });
            return contexts[2];
        }
            
        case TDQualityOfServiceBackground: {
            static dispatch_once_t once;
            dispatch_once(&once, ^{
                contexts[3] = __TDDispatchContextCreate("com.beckwang.background", count, qos);
            });
            return contexts[3];
        }
            
        case TDQualityOfServiceDefault:
        default: {
            static dispatch_once_t once;
            dispatch_once(&once, ^{
                contexts[4] = __TDDispatchContextCreate("com.beckwang.default", count, qos);
            });
            return contexts[4];
        }
    }
}

dispatch_queue_t TDDispatchQueueAsyncBlockInQOS(TDQualityOfService qos, dispatch_block_t block) {
    if (block == nil) { return NULL; }
    DispatchContext context = __TDDispatchContextGetForQos(qos);
    dispatch_queue_t queue = __TDDispatchContextGetQueue(context);
    dispatch_async(queue, block);
    return queue;
}

dispatch_queue_t TDDispatchQueueAsyncBlockInUserInteractive(dispatch_block_t block) {
    return TDDispatchQueueAsyncBlockInQOS(TDQualityOfServiceUserInteractive, block);
}

dispatch_queue_t TDDispatchQueueAsyncBlockInUserInitiated(dispatch_block_t block) {
    return TDDispatchQueueAsyncBlockInQOS(TDQualityOfServiceUserInitiated, block);
}

dispatch_queue_t TDDispatchQueueAsyncBlockInUtility(dispatch_block_t block) {
    return TDDispatchQueueAsyncBlockInQOS(TDQualityOfServiceUtility, block);
}

dispatch_queue_t TDDispatchQueueAsyncBlockInBackground(dispatch_block_t block) {
    return TDDispatchQueueAsyncBlockInQOS(TDQualityOfServiceBackground, block);
}

dispatch_queue_t TDDispatchQueueAsyncBlockInDefault(dispatch_block_t block) {
    return TDDispatchQueueAsyncBlockInQOS(TDQualityOfServiceDefault, block);
}

