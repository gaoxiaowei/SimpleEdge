//
//  NSObject+SESafeArea.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SESafeArea)
/// window.safearea
- (UIEdgeInsets)se_safeArea;
- (NSDictionary *)insetsDict;

@end

NS_ASSUME_NONNULL_END
