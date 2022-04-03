//
//  SETab.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/29.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SETab.h"
#import "SEURLTool.h"

const NSInteger kSEWebLoadTimeOutInterval       =60.0;
NSString*const  kScriptReloadFuncName           =@"edge_reload";

@interface SETab ()<WKScriptMessageHandler>
@property (nonatomic, strong) SEWebViewConfiguration *configuration;

@end

@implementation SETab

- (instancetype)initWithConfiguration:(SEWebViewConfiguration *)configuration {
    if (self = [super init]) {
        _configuration = configuration;
        _consecutiveCrashes = 0;
        _timeStamp =(int64_t)[[NSDate date] timeIntervalSince1970];
    }
    return self;
}

- (void)openURLString:(NSString *)urlString {
    NSURL *url = [SEURLTool convertStringToURL:urlString];
    if ([urlString isEqualToString:kSEHomeUrl]) {
        if (self.webView.isLoading) {
            [self.webView stopLoading];
        }
        url = [NSURL URLWithString:urlString];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:req];
        self.url = url;
        return;
    }
    [self openURL:url];
}

- (void)openURL:(NSURL *)url {
    if (!url) return;
    
    if (url.scheme == nil) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", url.resourceSpecifier]];
    }
    
    if (self.webView.isLoading) {
        [self.webView stopLoading];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kSEWebLoadTimeOutInterval];
    [self.webView loadRequest:request];
    self.url = url;
}

- (void)reload {
    if (self.unreachedUrl) {
        [self openURL:self.unreachedUrl];
        return;
    }
    [self.webView reload];
}

- (void)stop {
    if (self.webView.isLoading) {
        [self.webView stopLoading];
    }
}

- (void)goBack {
    if([self.webView canGoBack]){
        [self.webView goBack];
    }
}

- (void)goForward {
    if([self.webView canGoForward]){
        [self.webView goForward];
    }
}

- (void)destroyWebView {
    if ([self.tabDelegate respondsToSelector:@selector(tab:willDeleteWebView:)]) {
        [self.tabDelegate tab:self willDeleteWebView:self.webView];
    }
    [self.webView.configuration.userContentController removeAllUserScripts];
    [self.webView removeFromSuperview];
    self.webView = nil;
}

- (void)creatWebView {
    if (!_webView) {
        self.configuration.allowsInlineMediaPlayback = YES;
        _webView = [[SEWebView alloc] initWithFrame:CGRectZero configuration:self.configuration];
        if ([self.tabDelegate respondsToSelector:@selector(tab:didCreatWebView:)]) {
            [self.tabDelegate tab:self didCreatWebView:_webView];
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:_url];
        [_webView loadRequest:request];
        [self addContentScript];
    }
}

- (void)restoreWebView {
    if (self.estimatedProgress == 1 && self.restoreUrl.length > 0) {
        NSURL *url = [NSURL URLWithString:self.restoreUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        self.restoreUrl = @"";
    }
}

#pragma mark - WKScriptMessageHandler
- (void)addContentScript {
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:kScriptReloadFuncName];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:kScriptReloadFuncName]) {
        if([_url isKindOfClass:[NSURL class]]){
            NSURLRequest *request = [NSURLRequest requestWithURL:_url];
            [_webView loadRequest:request];
        }
    }
    
}
#pragma mark-share
-(void)getShareImage:(void(^)(NSString*imageURL))completion{
    [self.webView evaluateJavaScript:@"getWebPageShareIcon()" completionHandler:^(NSString* _Nullable result, NSError * _Nullable error) {
        if([result isKindOfClass:[NSString class]] && result.length>0){
            completion(result);
        }else{
            completion(@"");
        }
    }];
    
}
@end
