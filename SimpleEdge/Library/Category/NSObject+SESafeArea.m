//
//  NSObject+SESafeArea.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "NSObject+SESafeArea.h"

@implementation NSObject (SESafeArea)

- (UIEdgeInsets)se_safeArea{
    __block UIEdgeInsets inset;
    if([NSThread isMainThread]){
        UIView *view = [[UIApplication sharedApplication].delegate window];
        if (@available(iOS 11.0, *)) {
            inset = view.safeAreaInsets;
            if (inset.bottom == 0) {
                inset = UIEdgeInsetsZero;
            }
        } else {
            inset = UIEdgeInsetsZero;
        }
        return inset;
    }
    // 不在主线程
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view = [[UIApplication sharedApplication].delegate window];
        if (@available(iOS 11.0, *)) {
            inset = view.safeAreaInsets;
            if (inset.bottom == 0) {
                inset = UIEdgeInsetsZero;
            }
        } else {
            inset = UIEdgeInsetsZero;
        }
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return inset;
}

- (NSDictionary *)insetsDict {
	UIEdgeInsets insets = [self se_safeArea];
	return @{
		@"left":@(insets.left),
		@"top":@(insets.top),
		@"bottom":@(insets.bottom),
		@"right":@(insets.right)
	};
}

@end
