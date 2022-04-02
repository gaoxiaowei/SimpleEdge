//
//  SENavigationBaseView.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "SEBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SENavigationBaseView : SEBaseView

@property (nonatomic,readonly) UILabel              *navigationTitle;
@property (nonatomic,strong)   UIButton             *rightNaviButton;
@property (nonatomic,strong)   UIButton             *backNaviButton;
@property (nonatomic,    copy) dispatch_block_t     block;
@property (nonatomic,    copy) dispatch_block_t     rightBlock;

- (instancetype)initWithNavStateTopSpacing:(CGFloat)navStateTopSpacing;

- (void)updateTitle:(NSString *)title;

- (void)hideBackButton;
- (void)hideRightButton;
- (void)setBackButtonTitle:(NSString*)title;
- (void)setBackButtonImage:(UIImage*)image;
- (void)setBackButtonTitle:(NSString*)title font:(UIFont*)font;
- (void)setRightButtonTitle:(NSString*)title;
- (void)setRightButtonImage:(UIImage*)image;
- (void)setRightButtonTitle:(NSString*)title color:(UIColor*)color;
- (void)setRightButtonTitle:(NSString*)title font:(UIFont*)font color:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
