//
//  TDFPSMonitor.m
//  TDAppFluencyMonitor
//
//  Created by linxinda on 2017/3/24.
//  Copyright © 2017年 Jolimark. All rights reserved.
//

#import "TDFPSMonitor.h"
#import "TDMonitorUI.h"
#import "TDWeakProxy.h"
#import "TDFPSDisplayer.h"
#import "TDBacktraceLogger.h"

@interface TDFPSMonitor ()

@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) BOOL isMonitoring;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) TDFPSDisplayer * displayer;
@property (nonatomic, strong) CADisplayLink * displayLink;

@end

@implementation TDFPSMonitor

#pragma mark - Singleton
+ (instancetype)sharedMonitor {
    static TDFPSMonitor * sharedMonitor;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedMonitor = [[super allocWithZone: NSDefaultMallocZone()] init];
    });
    return sharedMonitor;
}

+ (instancetype)allocWithZone: (struct _NSZone *)zone {
    return [self sharedMonitor];
}

- (void)dealloc {
    [self stopMonitoring];
}

#pragma mark - Public
- (void)startMonitoring {
#if DEBUG
    if (_isMonitoring) { return; }
    _isMonitoring = YES;
    [self.displayer removeFromSuperview];
    TDFPSDisplayer * displayer = [[TDFPSDisplayer alloc] init];
    self.displayer = displayer;
    [[TDTopWindow topWindow] addSubview: self.displayer];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget: [TDWeakProxy proxyWithTarget: self] selector: @selector(monitor:)];
    [self.displayLink addToRunLoop: [NSRunLoop mainRunLoop] forMode: NSRunLoopCommonModes];
    self.lastTime = self.displayLink.timestamp;
    if ([self.displayLink respondsToSelector: @selector(setPreferredFramesPerSecond:)]) {
        if (@available(iOS 10.0, *)) {
            self.displayLink.preferredFramesPerSecond = 60;
        } else {
            // Fallback on earlier versions
        }
    } else {
        self.displayLink.frameInterval = 1;
    }
#endif
}

- (void)stopMonitoring {
    if (!_isMonitoring) { return; }
    _isMonitoring = NO;
    [self.displayer removeFromSuperview];
    self.displayer = nil;
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark - DisplayLink
- (void)monitor: (CADisplayLink *)link {
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) { return; }
    _lastTime = link.timestamp;
    
    double fps = _count / delta;
    _count = 0;
    [self.displayer updateFPS: (int)round(fps)];
}

@end
