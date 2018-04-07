//
//  TDDispatchOperation.h
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//  派发任务封装

#import <Foundation/Foundation.h>

@class TDDispatchOperation;
typedef void(^TDCancelableBlock)(TDDispatchOperation * operation);

@interface TDDispatchOperation : NSObject

@property (nonatomic, readonly) BOOL isCanceled;
@property (nonatomic, readonly) dispatch_queue_t queue;

+ (instancetype)dispatchOperationWithBlock: (dispatch_block_t)block;
+ (instancetype)dispatchOperationWithBlock: (dispatch_block_t)block inQoS: (NSQualityOfService)qos;
+ (instancetype)dispatchOperationWithCancelableBlock:(TDCancelableBlock)block;
+ (instancetype)dispatchOperationWithCancelableBlock:(TDCancelableBlock)block inQos: (NSQualityOfService)qos;

- (void)start;
- (void)cancel;

@end
