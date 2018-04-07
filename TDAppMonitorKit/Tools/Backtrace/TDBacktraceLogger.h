//
//  TDBacktraceLogger.h
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief 输出线程堆栈上下文
 */
@interface TDBacktraceLogger : NSObject

/**
 输出所有线程堆栈信息

 @return <#return value description#>
 */
+ (NSString *)td_backtraceOfAllThread;

/**
 输出主线程堆栈信息

 @return <#return value description#>
 */
+ (NSString *)td_backtraceOfMainThread;

/**
 输出当前线程堆栈信息

 @return <#return value description#>
 */
+ (NSString *)td_backtraceOfCurrentThread;


/**
 输出指定线程堆栈信息

 @param thread <#thread description#>
 @return <#return value description#>
 */
+ (NSString *)td_backtraceOfNSThread:(NSThread *)thread;

/**
 打印主线程堆栈
 */
+ (void)td_logMain;

/**
 打印当前线程堆栈
 */
+ (void)td_logCurrent;

/**
 打印所有线程堆栈
 */
+ (void)td_logAllThread;

/**
 创建日志文件

 @return return value description
 */
+ (NSString *)getBacktraceLogFilePath;

/**
 写入日志文件

 @param fileName <#fileName description#>
 */
+ (void)writeBacktraceLogWithFileName: (NSString *)fileName;

@end
