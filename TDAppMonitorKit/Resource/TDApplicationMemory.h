//
//  TDApplicationMemory.h
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//  应用Memory占用

#import <Foundation/Foundation.h>

typedef struct TDApplicationMemoryUsage
{
    double usage;   ///< 已用内存(MB)
    double total;   ///< 总内存(MB)
    double ratio;   ///< 占用比率
} TDApplicationMemoryUsage;

@interface TDApplicationMemory : NSObject

- (TDApplicationMemoryUsage)currentUsage;

@end
