//
//  SETab.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/29.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEWebViewConfiguration.h"
#import "SEWebView.h"

@class SETab;
@protocol SETabDelegate <NSObject>
@optional
- (void)tab:(SETab *)tab didCreatWebView:(SEWebView *)webView;
- (void)tab:(SETab *)tab willDeleteWebView:(SEWebView *)webView;

@end


@interface SETab : NSObject

@property (nonatomic, strong) SEWebView     *webView;
@property (nonatomic, copy)   NSString      *restoreUrl;
@property (nonatomic, strong) NSURL         *url;
@property (nonatomic, strong) NSURL         *unreachedUrl;

@property (nonatomic, assign) BOOL          loading;
@property (nonatomic, assign) BOOL          canGoBack;
@property (nonatomic, assign) BOOL          canGoForward;
@property (nonatomic, assign) double        estimatedProgress;
@property (nonatomic, assign) NSInteger     consecutiveCrashes;//连续crash次数

@property (nonatomic, copy)   NSString      *title;
@property (nonatomic, assign) BOOL          selected;
@property (nonatomic,assign)  int64_t       timeStamp;
@property (nonatomic,assign)  NSInteger     sortIndex;

@property (nonatomic, weak) id <SETabDelegate> tabDelegate;

- (instancetype)initWithConfiguration:(SEWebViewConfiguration *)configuration;
- (void)creatWebView;
- (void)openURLString:(NSString *)urlString;
- (void)openURL:(NSURL *)url;
- (void)reload;
- (void)stop;
- (void)goBack;
- (void)goForward;

- (void)destroyWebView;
- (void)restoreWebView;

- (void)getShareImage:(void(^)(NSString*imageURL))completion;
@end
