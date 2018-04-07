//
//  TDWeakProxy.m
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//  弱引用代理对象

#import "TDWeakProxy.h"

@interface TDWeakProxy ()

@property (nonatomic, weak) id target;

@end

@implementation TDWeakProxy

#pragma mark - Public
+ (instancetype)proxyWithTarget: (id)target {
    return [[self alloc] initWithTarget: target];
}

- (instancetype)initWithTarget: (id)target {
    if (self = [super init]) {
        self.target = target;
    }
    return self;
}

#pragma mark - method transmit
- (id)forwardingTargetForSelector: (SEL)aSelector {
    return _target;
}

- (void)forwardInvocation: (NSInvocation *)anInvocation {
    void * null = NULL;
    [anInvocation setReturnValue: &null];
}

- (NSMethodSignature *)methodSignatureForSelector: (SEL)aSelector {
    return [_target methodSignatureForSelector: aSelector];
}


#pragma mark - judge
- (BOOL)isProxy {
    return YES;
}

- (Class)class {
    return [_target class];
}

- (Class)superclass {
    return [_target superclass];
}

- (NSUInteger)hash {
    return [_target hash];
}

- (NSString *)description {
    return [_target description];
}

- (NSString *)debugDescription {
    return [_target debugDescription];
}

- (BOOL)isEqual: (id)object {
    return [_target isEqual: object];
}

- (BOOL)isKindOfClass: (Class)aClass {
    return [_target isKindOfClass: aClass];
}

- (BOOL)isMemberOfClass: (Class)aClass {
    return [_target isMemberOfClass: aClass];
}

- (BOOL)respondsToSelector: (SEL)aSelector {
    return [_target respondsToSelector: aSelector];
}

- (BOOL)conformsToProtocol: (Protocol *)aProtocol {
    return [_target conformsToProtocol: aProtocol];
}

@end
