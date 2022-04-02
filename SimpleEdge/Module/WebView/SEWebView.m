//
//  SEWebView.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/29.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEWebView.h"
#import "SEUserAgent.h"

@implementation SEWebView
- (instancetype)initWithFrame:(CGRect)frame configuration:(nonnull WKWebViewConfiguration *)configuration {
    self = [super initWithFrame:frame configuration:configuration];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.allowsLinkPreview = YES;
        self.allowsBackForwardNavigationGestures = YES;
        self.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.customUserAgent =[SEUserAgent browserUserAgent];
    }
    return self;
}

-(void)dealloc{
    NSLog(@"======== Dealloc %@ ========", NSStringFromClass(self.class));
}
@end
