//
//  SEUtlity.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SEUtlity : NSObject

+ (CGSize)rootViewSize;
+ (CGFloat)rootViewWidth;
+ (CGFloat)rootViewHeight;
+ (BOOL)isLandScapeMode;
+ (BOOL)isPadFullScreenMode;
+ (NSString*)sizeClassInt2Str:(UIUserInterfaceSizeClass)sizeClass;
+ (BOOL)isOrientationPortrait;
@end

NS_ASSUME_NONNULL_END
