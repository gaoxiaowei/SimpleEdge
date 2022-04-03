//
//  SEWebTabbar.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEWebTabbar.h"
#import <Masonry/Masonry.h>

NSInteger const kSEWebTabbarActionBaseTag   =10000;

@interface SEWebTabbar()
@property (nonatomic, strong)  UIView                       *containerView;
@property (nonatomic,   weak) id<SEWebTabbarActionProtocol> actionProtocol;
@end

@implementation SEWebTabbar

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)initWithProtocol:(id<SEWebTabbarActionProtocol>)protocol{
    self.actionProtocol = protocol;
}

- (void)setup{
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.top.equalTo(self);
    }];
    [self setupLayout];
}

- (void)setupLayout{
    for (NSInteger index=0;index<[self buttonImageArray].count;index++) {
        NSString *imageName =[self buttonImageArray][index];
        UIButton*button =[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        if (index == 0 || index == 1) {
            button.enabled = NO;
        }
        button.tag = kSEWebTabbarActionBaseTag + index;
        [button addTarget:self action:@selector(buttonActionEventHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:button];
    }
    [self.containerView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [self.containerView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView);
        make.height.mas_equalTo(49);
    }];
}

- (void)updateGoForwardStatus:(BOOL)canGoForward {
    UIButton *forwardBtn = [self.containerView.subviews instanceAtIndex:SEWebTabbarActionForward];
    forwardBtn.enabled = canGoForward;
}

- (void)updateGoBackStatus:(BOOL)canGoBack {
    UIButton *backBtn = [self.containerView.subviews instanceAtIndex:SEWebTabbarActionBack];
    backBtn.enabled = canGoBack;
}

- (void)buttonActionEventHandler:(UIButton *)sender{
    if ([self.actionProtocol respondsToSelector:@selector(tabBarButtonAction:)]) {
        [self.actionProtocol tabBarButtonAction:sender.tag - kSEWebTabbarActionBaseTag];
    }
}

- (void)updateTabNum:(NSInteger)num{
    UIButton *tabButton = [self.containerView.subviews instanceAtIndex:SEWebTabbarActionTab];
    NSString*imageName;
    if ([SETabManager shared].getAllTab.count >= kMaxTabCount) {
        imageName = @"square.stack";
    }else{
        imageName =[NSString stringWithFormat:@"%ld.square",num];
    }
    UIImage*image =[UIImage imageNamed:imageName];
    [tabButton setImage:image forState:UIControlStateNormal];
}

- (NSArray *)buttonImageArray{
    return @[@"chevron.left",@"chevron.right",@"plus",@"0.square",@"square.and.arrow.up"];
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UIButton*)getMultiTabButton{
    return  [self.containerView.subviews instanceAtIndex:SEWebTabbarActionTab];
}

- (UIButton*)getShareButton{
    return  [self.containerView.subviews instanceAtIndex:SEWebTabbarActionShare];
}
@end
