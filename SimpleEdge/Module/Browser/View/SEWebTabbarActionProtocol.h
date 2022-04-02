//
//  SEWebTabbarActionProtocol.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, SEWebTabbarAction) {
    SEWebTabbarActionBack = 0,
    SEWebTabbarActionForward,
    SEWebTabbarActionAdd,
    SEWebTabbarActionTab,
    SEWebTabbarActionShare
};

@protocol SEWebTabbarActionProtocol <NSObject>

@optional
- (void)tabBarButtonAction:(SEWebTabbarAction)action;

@end

NS_ASSUME_NONNULL_END
