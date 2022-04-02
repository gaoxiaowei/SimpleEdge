//
//  SEBaseNavigationController.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "SEBaseViewController.h"
#import "SENavigationBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SEBaseNavigationController : SEBaseViewController

@property (nonatomic, strong, readonly) SENavigationBaseView *navigationView;

@property (nonatomic,   copy) dispatch_block_t               backBlock;
@property (nonatomic,   copy) dispatch_block_t               rightBlock;

- (void)backEventHander;
- (void)rightEventHander;

- (void)hideBackButton;
- (void)hideRightButton;

- (void)setBackButtonTitle:(NSString*)title;
- (void)setBackButtonTitle:(NSString*)title font:(UIFont*)font;
- (void)setBackButtonImage:(UIImage*)image;
- (void)setRightButtonTitle:(NSString*)title;
- (void)setRightButtonTitle:(NSString*)title color:(UIColor*)color;
- (void)setRightButtonTitle:(NSString*)title font:(UIFont*)font color:(UIColor*)color;
- (void)setRightButtonImage:(UIImage*)image;

@end

NS_ASSUME_NONNULL_END
