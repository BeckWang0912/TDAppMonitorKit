//
//  TDResourceMonitor.h
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//  硬件资源监控

#import <Foundation/Foundation.h>

#define TD_RESOURCEMONITOR [TDResourceMonitor new]

typedef NS_ENUM(NSInteger, TDResourceMonitorType)
{
    TDResourceMonitorTypeDefault = (1 << 2) | (1 << 3),
    TDResourceMonitorTypeSystemCpu = 1 << 0,   ///<    监控系统CPU使用率，优先级低
    TDResourceMonitorTypeSystemMemory = 1 << 1,    ///<    监控系统内存使用率，优先级低
    TDResourceMonitorTypeApplicationCpu = 1 << 2,  ///<    监控应用CPU使用率，优先级高
    TDResourceMonitorTypeApplicationMemoty = 1 << 3,   ///<    监控应用内存使用率，优先级高
};

@interface TDResourceMonitor : NSObject

+ (instancetype)monitorWithMonitorType: (TDResourceMonitorType)monitorType;
- (void)startMonitoring;
- (void)stopMonitoring;

@end
