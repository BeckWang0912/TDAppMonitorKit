//
//  TDResourceMonitor.m
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//  硬件资源监控

#import "TDResourceMonitor.h"
#import "TDSystemCPU.h"
#import "TDApplicationCPU.h"
#import "TDSystemMemory.h"
#import "TDApplicationMemory.h"
#import "TDMonitorUI.h"
#import "TDGlobalTimer.h"
#import "TDCPUDisplayer.h"
#import "TDMemoryDisplayer.h"

@interface TDResourceMonitor ()

@property (nonatomic, strong) TDSystemCPU * sysCpu;
@property (nonatomic, strong) TDApplicationCPU * appCpu;
@property (nonatomic, strong) TDSystemMemory * sysMemory;
@property (nonatomic, strong) TDApplicationMemory * appMemory;
@property (nonatomic, strong) TDCPUDisplayer * cpuDisplayer;
@property (nonatomic, strong) TDMemoryDisplayer * memoryDisplayer;

@end

@implementation TDResourceMonitor

+ (instancetype)monitorWithMonitorType: (TDResourceMonitorType)monitorType {
    return [[self alloc] initWithMonitorType: monitorType];
}

- (instancetype)init {
    return [self initWithMonitorType: TDResourceMonitorTypeDefault];
}

- (instancetype)initWithMonitorType: (TDResourceMonitorType)monitorType {
    if (self = [super init]) {
        BOOL cpuMonitorEnabled = YES, memoryMonitorEnabled = YES;
        if (monitorType & TDResourceMonitorTypeApplicationCpu) {
            self.appCpu = [TDApplicationCPU new];
        } else if (monitorType & TDResourceMonitorTypeSystemCpu) {
            self.sysCpu = [TDSystemCPU new];
        } else {
            cpuMonitorEnabled = NO;
        }
        if (monitorType & TDResourceMonitorTypeApplicationMemoty) {
            self.appMemory = [TDApplicationMemory new];
        } else if (monitorType & TDResourceMonitorTypeSystemMemory) {
            self.sysMemory = [TDSystemMemory new];
        } else {
            memoryMonitorEnabled = NO;
        }
        if (!(cpuMonitorEnabled | memoryMonitorEnabled)) {
            @throw [NSException exceptionWithName: NSInvalidArgumentException reason: [NSString stringWithFormat: @"[%@ initWithMonitorType]: cannot create %@ instance without monitor type", [self class], [self class]] userInfo: nil];
        }
        
        if (cpuMonitorEnabled) {
            self.cpuDisplayer = [[TDCPUDisplayer alloc] initWithFrame: CGRectMake(0, 30, 60, 20)];
        }
        if (memoryMonitorEnabled) {
            self.memoryDisplayer = [[TDMemoryDisplayer alloc] initWithFrame: CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 120 - 60, 30, 60, 20)];
        }
    }
    return self;
}

static NSString * td_resource_monitor_callback_key;

- (void)startMonitoring {
#if DEBUG
    if (td_resource_monitor_callback_key != nil) { return; }
    td_resource_monitor_callback_key = [[TDGlobalTimer registerTimerCallback: ^{
        double cpuUsage, memoryUsage;
        if (_appCpu) {
            cpuUsage = [_appCpu currentUsage];
        } else {
            TDSystemCPUUsage usage = [_sysCpu currentUsage];
            cpuUsage = usage.user + usage.system + usage.nice;
        }
        if (_appMemory) {
            TDApplicationMemoryUsage usage = [_appMemory currentUsage];
            memoryUsage = usage.usage;
        } else {
            TDSystemMemoryUsage usage = [_sysMemory currentUsage];
            memoryUsage = (usage.wired + usage.active);
        }
        [self.cpuDisplayer displayCPUUsage: cpuUsage];
        [self.memoryDisplayer displayUsage: memoryUsage];
    }] copy];
    [[TDTopWindow topWindow] addSubview: self.cpuDisplayer];
    [[TDTopWindow topWindow] addSubview: self.memoryDisplayer];
#endif
}

- (void)stopMonitoring {
    if (td_resource_monitor_callback_key == nil) { return; }
    [TDGlobalTimer resignTimerCallbackWithKey: td_resource_monitor_callback_key];
    [self.cpuDisplayer removeFromSuperview];
    [self.memoryDisplayer removeFromSuperview];
}

@end
