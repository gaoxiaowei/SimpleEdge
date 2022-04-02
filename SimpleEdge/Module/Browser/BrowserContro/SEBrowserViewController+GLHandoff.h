//
//  SEBrowserViewController+GLHandoff.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEBrowserViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SEBrowserViewController (GLHandoff)<NSUserActivityDelegate> 

- (void)handoffWebView:(WKWebView *)webView;

@end

NS_ASSUME_NONNULL_END
