//
//  SENavigationBaseView.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "SENavigationBaseView.h"
#import <Masonry/Masonry.h>

@interface SENavigationBaseView()

@property (nonatomic,assign) CGFloat    navStateTopSpacing;
@property (nonatomic,strong) UILabel    *navigationTitle;

@end

@implementation SENavigationBaseView

INIT([self setupView];)

- (instancetype)initWithNavStateTopSpacing:(CGFloat)navStateTopSpacing {
    if (self = [super init]) {
        _navStateTopSpacing = navStateTopSpacing;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.backNaviButton];
    [self addSubview:self.rightNaviButton];
    [self addSubview:self.navigationTitle];
    
    [self.backNaviButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.width.height.mas_equalTo(44);
        make.top.equalTo(self).offset([self navStateTopSpacing]);
    }];
    [self.rightNaviButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-8);
        make.width.height.top.mas_equalTo(self.backNaviButton);
    }];
    [self.navigationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backNaviButton.mas_right).offset(5);
        make.right.equalTo(self.rightNaviButton.mas_left).offset(-5);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.backNaviButton);
    }];
}

- (void)updateTitle:(NSString *)title{
    self.navigationTitle.text = title;
}

#pragma mark - Click
- (void)backNavigationEventHander{
    SAFE_BLOCK(self.block);
}

- (void)rightNavigationEventHander{
    SAFE_BLOCK(self.rightBlock);
}


- (void)hideBackButton{
    self.backNaviButton.hidden = YES;
}
- (void)hideRightButton{
    self.rightNaviButton.hidden = YES;
}

#pragma mark - back

- (void)setBackButtonTitle:(NSString*)title{
    [self setBackButtonTitle:title font:nil color:nil image:nil];
}
- (void)setBackButtonImage:(UIImage*)image{
    [self setBackButtonTitle:nil font:nil color:nil image:image];
}
- (void)setBackButtonTitle:(NSString*)title font:(UIFont*)font{
    [self setBackButtonTitle:title font:font color:nil image:nil];
}
- (void)setBackButtonImage:(NSString*)title color:(UIColor*)color{
    [self setBackButtonTitle:title font:nil color:color image:nil];
}

- (void)setBackButtonTitle:(NSString*)title font:(UIFont*)font color:(UIColor*)color image:(UIImage*)image{
    self.backNaviButton.hidden = NO;
    if (title.length>0) {
        [self.backNaviButton setTitle:title forState:UIControlStateNormal];
    }
    if (font) {
        self.backNaviButton.titleLabel.font = font;
    }
    [self.backNaviButton setImage:image forState:UIControlStateNormal];
    [self.backNaviButton setImage:image forState:UIControlStateHighlighted];
    if (color) {
        [self.backNaviButton setTitleColor:color forState:UIControlStateNormal];
    }
}

#pragma mark - Right
- (void)setRightButtonTitle:(NSString*)title{
    [self setRightButtonTitle:title font:nil color:nil image:nil];
}
- (void)setRightButtonImage:(UIImage*)image{
    [self setRightButtonTitle:nil font:nil color:nil image:image];
}
- (void)setRightButtonTitle:(NSString*)title color:(UIColor*)color{
    [self setRightButtonTitle:title font:nil color:color image:nil];
}
- (void)setRightButtonTitle:(NSString*)title font:(UIFont*)font color:(UIColor*)color{
    [self setRightButtonTitle:title font:font color:color image:nil];
}

- (void)setRightButtonTitle:(NSString*)title font:(UIFont*)font color:(UIColor*)color image:(UIImage*)image{
    self.rightNaviButton.hidden = NO;
    if (title.length>0) {
        [self.rightNaviButton setTitle:title forState:UIControlStateNormal];
    }
    if (font) {
        self.rightNaviButton.titleLabel.font = font;
    }
    [self.rightNaviButton setImage:image forState:UIControlStateNormal];
    [self.rightNaviButton setImage:image forState:UIControlStateHighlighted];
    if (color) {
        [self.rightNaviButton setTitleColor:color forState:UIControlStateNormal];
    }
}

#pragma mark - Lazy
- (UIButton *)backNaviButton{
    if (!_backNaviButton) {
        _backNaviButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backNaviButton setImage:[UIImage imageNamed:@"common_titlebar_back_black"] forState:UIControlStateNormal];
        [_backNaviButton setImage:[UIImage imageNamed:@"common_titlebar_back_black"] forState:UIControlStateHighlighted];
        [_backNaviButton addTarget:self action:@selector(backNavigationEventHander) forControlEvents:UIControlEventTouchUpInside];
        [_backNaviButton setTitleColor:SE_HEXCOLOR(0x222222) forState:UIControlStateNormal];
        _backNaviButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    }
    return _backNaviButton;
}

- (UILabel *)navigationTitle{
    if (!_navigationTitle) {
        _navigationTitle = [[UILabel alloc] init];
        _navigationTitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _navigationTitle.numberOfLines = 1;
        _navigationTitle.textAlignment = NSTextAlignmentCenter;
        _navigationTitle.textColor = SE_HEXCOLOR(0x222222);
    }
    return _navigationTitle;
}

- (UIButton *)rightNaviButton{
    if (!_rightNaviButton) {
        _rightNaviButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightNaviButton setTitleColor:SE_HEXCOLOR(0x14B9C8) forState:UIControlStateNormal];
        _rightNaviButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _rightNaviButton.hidden = YES;
        [_rightNaviButton addTarget:self action:@selector(rightNavigationEventHander) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNaviButton;
}

@end
