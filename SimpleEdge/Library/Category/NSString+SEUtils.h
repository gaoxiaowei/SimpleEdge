//
//  NSString+SEUtils.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SEUtils)

- (CGSize)sizeForHavingWidth:(CGFloat)width andFont:(UIFont *)font;
+ (NSString *)transformDataToGbkString:(NSData *)data;
- (BOOL)stringIsNull;
- (BOOL)se_isVaild;
@end

NS_ASSUME_NONNULL_END
