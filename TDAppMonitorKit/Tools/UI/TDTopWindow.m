//
//  TDTopWindow.m
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//  非交互的顶部窗口

#import "TDTopWindow.h"

static TDTopWindow * td_top_window;

@implementation TDTopWindow


+ (instancetype)topWindow {
#if DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        td_top_window = [[super allocWithZone: NSDefaultMallocZone()] initWithFrame: [UIScreen mainScreen].bounds];
    });
#endif
    return td_top_window;
}

+ (instancetype)allocWithZone: (struct _NSZone *)zone {
    return [self topWindow];
}

- (instancetype)copy {
    return [[self class] topWindow];
}

- (instancetype)initWithFrame: (CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        [super setUserInteractionEnabled: NO];
        [super setWindowLevel: CGFLOAT_MAX];
        
        self.rootViewController = [UIViewController new];
        [self makeKeyAndVisible];
    }
    return self;
}

- (void)setWindowLevel: (UIWindowLevel)windowLevel { }
- (void)setBackgroundColor: (UIColor *)backgroundColor { }
- (void)setUserInteractionEnabled: (BOOL)userInteractionEnabled { }


@end
