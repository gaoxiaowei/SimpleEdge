//
//  SEBrowserViewController+GLHandoff.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEBrowserViewController+GLHandoff.h"

@implementation SEBrowserViewController (GLHandoff)

- (NSUserActivity *)handoffActivity {
    static NSUserActivity *handoffActivity;
    if (!handoffActivity) {
        NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        handoffActivity = [[NSUserActivity alloc]initWithActivityType:bundleId];
        handoffActivity.delegate = self;
        handoffActivity.title = @"网页接力";
    }
    return handoffActivity;
}

- (void)handoffWebView:(WKWebView *)webView {
    //    if (![webView.URL.absoluteString isEqualToString:@"about:blank"]) {
    //        [self.handoffActivity setWebpageURL:webView.URL];
    //        self.handoffActivity.userInfo = @{};
    //        self.handoffActivity.needsSave = YES;
    //        self.handoffActivity.eligibleForHandoff = YES;
    //        [self.handoffActivity becomeCurrent];
    //    }
}

@end
