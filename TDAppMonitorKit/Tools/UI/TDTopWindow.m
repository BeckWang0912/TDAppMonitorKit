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
        td_top_window = [[super allocWithZone: NSDefaultMallocZone()] initWithFrame: CGRectMake(60, 0, [UIScreen mainScreen].bounds.size.width - 120, 55)];
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
        //[super setBackgroundColor:[UIColor redColor]];
        self.rootViewController = [UIViewController new];
        // 为了不影响keywindow上的交互，把topwindow设置为可见即可。
        self.hidden = NO;
        //[self makeKeyAndVisible];
    }
    return self;
}

- (void)setWindowLevel: (UIWindowLevel)windowLevel { }
- (void)setBackgroundColor: (UIColor *)backgroundColor { }
- (void)setUserInteractionEnabled: (BOOL)userInteractionEnabled { }


@end
