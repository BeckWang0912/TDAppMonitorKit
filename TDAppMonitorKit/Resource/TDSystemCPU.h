//
//  TDSystemCPU.h
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//  系统CPU占用

#import <Foundation/Foundation.h>

typedef struct TDSystemCPUUsage
{
    double system;  ///< 系统占用率
    double user;    ///< user占用率
    double nice;    ///< 加权user占用率
    double idle;    ///< 空闲率
} TDSystemCPUUsage;

@interface TDSystemCPU : NSObject

@property (nonatomic, readonly) double systemRatio;
@property (nonatomic, readonly) double userRatio;
@property (nonatomic, readonly) double niceRatio;
@property (nonatomic, readonly) double idleRatio;

- (TDSystemCPUUsage)currentUsage;

@end
