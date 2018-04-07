//
//  TDMemoryUsage.h
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved
//  系统内存使用

#import <Foundation/Foundation.h>

typedef struct TDSystemMemoryUsage
{
    double free;    ///< 自由内存(MB)
    double wired;   ///< 固定内存(MB)
    double active;  ///< 正在使用的内存(MB)
    double inactive;    ///< 缓存、后台内存(MB)
    double compressed;  ///< 压缩内存(MB)
    double total;   ///< 总内存(MB)
} TDSystemMemoryUsage;

@interface TDSystemMemory : NSObject

- (TDSystemMemoryUsage)currentUsage;

@end
