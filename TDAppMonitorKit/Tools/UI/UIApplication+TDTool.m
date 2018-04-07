//
//  UIApplication+TDTool.m
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//

#import "UIApplication+TDTool.h"

@implementation UIApplication (TDTool)

UIViewController * _findViewController(UIViewController * viewController) {
    if (viewController.presentedViewController != nil) {
        return _findViewController(viewController.presentedViewController);
    } else if ([viewController isKindOfClass: [UINavigationController class]]) {
        return _findViewController(((UINavigationController *)viewController).topViewController);
    } else if ([viewController isKindOfClass: [UITabBarController class]]) {
        UITabBarController * tabBarController = (UITabBarController *)viewController;
        return _findViewController(tabBarController.viewControllers[tabBarController.selectedIndex]);
    }
    return viewController;
}

- (UIViewController *)findTopViewController {
    UIWindow * window = self.keyWindow;
    if (self.keyWindow.windowLevel != UIWindowLevelNormal) {
        for (UIWindow * win in [self windows]) {
            if (win.windowLevel == UIWindowLevelNormal) {
                window = win;
                break;
            }
        }
    }
    UIView * frontView = [[window subviews] lastObject];
    UIViewController * viewController;
    if ([frontView.nextResponder isKindOfClass: [UIViewController class]]) {
        viewController = (UIViewController *)frontView.nextResponder;
    } else {
        viewController = window.rootViewController;
    }
    return _findViewController(viewController);
}


@end
