//
//  TDGlobalTimer.h
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//  全局倒计时

#import <Foundation/Foundation.h>

@interface TDGlobalTimer : NSObject

/**
 注册定时器回调处理，返回时间戳作为key

 @param callback <#callback description#>
 @return <#return value description#>
 */
+ (NSString *)registerTimerCallback:(dispatch_block_t)callback;

/**
 注册定时器回调处理

 @param callback <#callback description#>
 @param key <#key description#>
 */
+ (void)registerTimerCallback:(dispatch_block_t)callback key: (NSString *)key;

/**
 取消定时器注册

 @param key <#key description#>
 */
+ (void)resignTimerCallbackWithKey: (NSString *)key;

/**
 设置定时器间隔，默认为2s

 @param interval <#interval description#>
 */
+ (void)setCallbackInterval: (NSUInteger)interval;

@end

