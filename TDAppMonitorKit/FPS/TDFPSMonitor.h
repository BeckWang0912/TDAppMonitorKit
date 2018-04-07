//
//  TDFPSMonitor.h
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//  监听FPS

#import <Foundation/Foundation.h>

#define TD_FPSMONITOR [TDFPSMonitor sharedMonitor]

@interface TDFPSMonitor : NSObject

+ (instancetype)sharedMonitor;
- (void)startMonitoring;
- (void)stopMonitoring;

@end
