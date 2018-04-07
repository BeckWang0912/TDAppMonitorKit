//
//  TDAppFluencyMonitor.h
//  TDAppMonitorKit
//
//  Created by 王志涛 on 2018/4/7.
//  Copyright © 2018年 beck.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TD_FLUENCYMONITOR [TDAppFluencyMonitor sharedMonitor]

@interface TDAppFluencyMonitor : NSObject

+ (instancetype)sharedMonitor;
- (void)startMonitoring;
- (void)stopMonitoring;

@end
