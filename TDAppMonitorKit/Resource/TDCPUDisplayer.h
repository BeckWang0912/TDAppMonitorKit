//
//  TDCPUDisplayer.h
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//  CPU占用展示器

#import <UIKit/UIKit.h>

@interface TDCPUDisplayer : UIView

- (void)displayCPUUsage: (double)usage;

@end
