//
//  SEWebTabbar.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEBaseView.h"
#import "SEWebTabbarActionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SEWebTabbar : SEBaseView

- (void)initWithProtocol:(id<SEWebTabbarActionProtocol>)protocol;
- (void)updateTabNum:(NSInteger)num;
- (void)updateGoBackStatus:(BOOL)canGoBack;
- (void)updateGoForwardStatus:(BOOL)canGoForward;
- (UIButton*)getMultiTabButton;
- (UIButton*)getShareButton;
@end

NS_ASSUME_NONNULL_END
