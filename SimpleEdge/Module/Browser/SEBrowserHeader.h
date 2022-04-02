//
//  SEWebTabbar.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#ifndef SEBrowserHeader_h
#define SEBrowserHeader_h

static NSString *const kSEWebViewKVOLoading               = @"loading";
static NSString *const kSEWebViewKVOEestimatedProgress    = @"estimatedProgress";
static NSString *const kSEWebViewKVOUrl                   = @"URL";
static NSString *const kSEWebViewKVOTitle                 = @"title";
static NSString *const kSEWebViewKVOCanGoBack             = @"canGoBack";
static NSString *const kSEWebViewKVOCanGoForward          = @"canGoForward";
static NSString *const kSEWebViewKVOContentSize           = @"contentSize";

static inline NSArray* SEWebViewKVOPaths(void) {
    return @[@"loading",@"estimatedProgress",@"URL",
             @"title",@"canGoBack",@"canGoForward",@"contentSize"];
}
#endif /* SEBrowserHeader_h */
