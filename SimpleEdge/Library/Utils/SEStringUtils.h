//
//  SEStringUtils.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SEStringUtils : NSObject

+ (BOOL)stringIsNull:(NSString *)parameter;
+ (NSString *)durationToString:(NSInteger)duration;
@end

NS_ASSUME_NONNULL_END
