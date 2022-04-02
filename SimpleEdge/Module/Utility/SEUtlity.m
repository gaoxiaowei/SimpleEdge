//
//  SEUtlity.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEUtlity.h"
#import "AppDelegate.h"

@implementation SEUtlity

+ (CGSize)rootViewSize{
    return [[AppDelegate sharedAppDelegate]getRootVC].view.frame.size;
}

+ (CGFloat)rootViewWidth{
    return [self rootViewSize].width;
}

+ (CGFloat)rootViewHeight{
    return [self rootViewSize].height;
}

+ (BOOL)isLandScapeMode{
    return [self rootViewWidth] > [self rootViewHeight];
}

+(BOOL)isPadFullScreenMode{
    if(SE_IS_IPAD_DEVICE && self.rootViewWidth < kSE_ScreenWidth){
        return NO;
    }
    return YES;
}

+ (NSString*)sizeClassInt2Str:(UIUserInterfaceSizeClass)sizeClass{
    switch (sizeClass) {
        case UIUserInterfaceSizeClassCompact:
            return @"UIUserInterfaceSizeClassCompact";
        case UIUserInterfaceSizeClassRegular:
            return @"UIUserInterfaceSizeClassRegular";
        case UIUserInterfaceSizeClassUnspecified:
        default:
            return @"UIUserInterfaceSizeClassUnspecified";
    }
}

@end
