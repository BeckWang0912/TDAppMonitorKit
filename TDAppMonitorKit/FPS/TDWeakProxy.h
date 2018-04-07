//
//  TDWeakProxy.h
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//  弱引用代理对象

#import <Foundation/Foundation.h>

@interface TDWeakProxy : NSObject

+ (instancetype)proxyWithTarget: (id)target;
- (instancetype)initWithTarget: (id)target;

@end
