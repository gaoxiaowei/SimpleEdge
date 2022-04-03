//
//  SEBrowserViewController.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEBaseViewController.h"
#import <WebKit/WebKit.h>
@class SEWebAdressView,SEWebTabbar;

@interface SEBrowserViewController : SEBaseViewController
<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong,readonly) SEWebAdressView   *urlBar;
@property (nonatomic, strong,readonly) SEWebTabbar       *tabBar;

@end

