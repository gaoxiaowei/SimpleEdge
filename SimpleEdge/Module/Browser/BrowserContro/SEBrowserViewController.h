//
//  SEBrowserViewController.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEBaseViewController.h"
#import <WebKit/WebKit.h>

@interface SEBrowserViewController : SEBaseViewController
<WKNavigationDelegate,WKUIDelegate>

@end

