//
//  SEMacrosDefine.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#ifndef SEMacrosDefine_h
#define SEMacrosDefine_h

//HomeUrl
#define kSEHomeUrl @"https://www.bing.com"
//Default Search Engine
#define kSESearchEngineUrl @"https://www.bing.com/search"

#define SE_IS_IPHONE_DEVICE    (UIUserInterfaceIdiomPhone == [[UIDevice currentDevice] userInterfaceIdiom])
#define SE_IS_IPAD_DEVICE      (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom])

#define kSE_ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kSE_ScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define kSE_StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

#define SAFE_BLOCK(block, ...) if((block)) { block(__VA_ARGS__); }
#define SAFE_BLOCK_IN_MAIN_QUEUE(block, ...) if((block)) {\
if ([NSThread isMainThread]) {\
block(__VA_ARGS__);\
}\
else {\
dispatch_async(dispatch_get_main_queue(), ^{\
block(__VA_ARGS__);\
});\
}\
}

#define SE_HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SE_HEXCOLORA(rgbValue,__a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:__a]

// 常用初始化代码宏
#define INIT_WITH_FRAME(x) - (instancetype)initWithFrame:(CGRect)frame { \
if (self = [super initWithFrame:frame]) { \
    x \
} \
return self; \
} \

#define INIT(x) - (instancetype)init { \
if (self = [super init]) { \
    x \
} \
return self; \
} \

#if DEBUG
#define THROW_OVERRIDEN_EXCEPTION @throw [NSException exceptionWithName:[NSString stringWithUTF8String:__FUNCTION__] reason:@"This method should be overriden by its subclass" userInfo:nil]
#else
#define THROW_OVERRIDEN_EXCEPTION
#endif


#define kSENavBarHeight                         44.f
#define kStatusContentHeight                    0.f
#define kMaxTabCount                            50

#pragma mark -notifaction
#define kSEViewWillTransitionNotification        @"SEViewWillTransitionNotification"

#endif /* SEMacrosDefine_h */
