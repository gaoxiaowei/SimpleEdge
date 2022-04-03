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
//分屏(1/2宽): iPad全屏样式
//分屏(2/3宽): iPad全屏样式
//分屏(1/3宽): 手机样式
+(BOOL)isPadFullScreenMode{
    CGFloat offfset =10.f;
    CGFloat screenWidth =kSE_ScreenWidth;
    if(SE_IS_IPAD_DEVICE && (self.rootViewWidth+offfset >= screenWidth/2)){
        if([self isOrientationPortrait]){
            if(self.rootViewWidth < screenWidth){
                return NO;
            }
        }
    
        return YES;
    }
    return NO;
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

+(BOOL)isOrientationPortrait{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortraitUpsideDown || orientation == UIInterfaceOrientationPortrait) {
        return YES;
    }
    return NO;
}
@end
