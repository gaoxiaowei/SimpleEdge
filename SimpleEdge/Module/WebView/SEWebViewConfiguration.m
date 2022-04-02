//
//  SEWebViewConfiguration.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/29.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEWebViewConfiguration.h"

@implementation SEWebViewConfiguration
- (instancetype)init {
    if (self = [super init]) {
        self.ignoresViewportScaleLimits = YES;
    }
    return self;
}
@end
