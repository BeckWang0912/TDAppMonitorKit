//
//  TDFPSDisplayer.m
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//  FPS显示器

#import "TDFPSDisplayer.h"
#import "TDMonitorUI.h"
#import "TDDispatchAsync.h"

#define TD_FPS_DISPLAYER_SIZE CGSizeMake(54, 20)

@interface TDFPSDisplayer ()
@property (nonatomic, strong) TDAsyncLabel * fpsDisplayer;
@end

@implementation TDFPSDisplayer

- (instancetype)init {
    if (self = [super initWithFrame: CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - TD_FPS_DISPLAYER_SIZE.width) / 2, 30, TD_FPS_DISPLAYER_SIZE.width, TD_FPS_DISPLAYER_SIZE.height)]) {
        CGFloat centerX = round((CGRectGetWidth([UIScreen mainScreen].bounds) - 120)/2);
        self.center = CGPointMake(centerX, self.center.y);
        CAShapeLayer * bgLayer = [CAShapeLayer layer];
        bgLayer.fillColor = [UIColor colorWithWhite: 0 alpha: 0.7].CGColor;
        bgLayer.path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, TD_FPS_DISPLAYER_SIZE.width, TD_FPS_DISPLAYER_SIZE.height) cornerRadius: 5].CGPath;
        [self.layer addSublayer: bgLayer];

        self.fpsDisplayer = [[TDAsyncLabel alloc] initWithFrame: self.bounds];
        self.fpsDisplayer.textColor = [UIColor whiteColor];
        self.fpsDisplayer.textAlignment = NSTextAlignmentCenter;
        self.fpsDisplayer.font = [UIFont fontWithName: @"Menlo" size: 14];
        [self updateFPS: 60];
        [self addSubview: self.fpsDisplayer];
    }
    return self;

}

- (void)updateFPS: (int)fps {
    TDDispatchQueueAsyncBlockInDefault(^{
        NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat: @"%d", fps] attributes: @{ NSForegroundColorAttributeName: [UIColor colorWithHue: 0.27 * (fps / 60.0 - 0.2) saturation: 1 brightness: 0.9 alpha: 1], NSFontAttributeName: _fpsDisplayer.font }];
        [attributed appendAttributedString: [[NSAttributedString alloc] initWithString: @"FPS" attributes: @{ NSFontAttributeName: _fpsDisplayer.font, NSForegroundColorAttributeName: [UIColor whiteColor] }]];
        self.fpsDisplayer.attributedText = attributed;
    });
}

@end
