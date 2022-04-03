//
//  SEBaseNavigationController.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "SEBaseNavigationController.h"

@interface SEBaseNavigationController ()

@property (nonatomic, strong) SENavigationBaseView *navigationView;

@end

@implementation SEBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBaseNavigationViewsLayout];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupBaseNavigationViewsLayout{
    [self.view addSubview:self.navigationView];
    
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(self.topMagrin);
        make.height.mas_equalTo(kSENavBarHeight+[self navStateTopSpacing]);
    }];
}


#pragma mark - layout
- (void)updateBaseNavigationviewsLayout{
    [self.navigationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.topMagrin);
    }];
}

- (CGFloat)topMagrin{
    if (self.presentingViewController) {
        return 0;
    }
    return kStatusContentHeight;
}

#pragma mark - Click
- (void)backEventHander{
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers.count > 1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self) {//push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {//present方式
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    SAFE_BLOCK(self.backBlock);
}

- (void)rightEventHander{
    SAFE_BLOCK(self.rightBlock);
}

#pragma mark -Back
- (void)hideBackButton{
    [self.navigationView hideBackButton];
}

- (void)setBackButtonTitle:(NSString*)title{
    [self.navigationView setBackButtonTitle:title];
}

- (void)setBackButtonImage:(UIImage*)image{
    [self.navigationView setBackButtonImage:image];
}

- (void)setBackButtonTitle:(NSString*)title font:(UIFont*)font{
    [self.navigationView setBackButtonTitle:title font:font];
}

#pragma mark -Right
- (void)hideRightButton{
    [self.navigationView hideRightButton];
}

- (void)setRightButtonTitle:(NSString*)title{
    [self.navigationView setRightButtonTitle:title];
}

- (void)setRightButtonTitle:(NSString*)title color:(UIColor*)color{
    [self.navigationView setRightButtonTitle:title color:color];
}

- (void)setRightButtonTitle:(NSString*)title font:(UIFont*)font color:(UIColor*)color{
    [self.navigationView setRightButtonTitle:title font:font color:color];
}

- (void)setRightButtonImage:(UIImage*)image{
    [self.navigationView setRightButtonImage:image];
}

#pragma mark - Title
- (void)setTitle:(NSString *)title{
    [self.navigationView updateTitle:title];
}

#pragma mark - Helper
//状态栏高度
- (CGFloat)navStateTopSpacing {
    CGFloat top = 0;
    if (self.se_safeArea.bottom > 0) {
        top = self.se_safeArea.top;
    } else {
        top = 20;
    }
    return top;
}

#pragma mark - Lazy
- (SENavigationBaseView *)navigationView{
    if (!_navigationView) {
        _navigationView = [[SENavigationBaseView alloc] initWithNavStateTopSpacing:[self navStateTopSpacing]];
        
        __weak __typeof(self) weakSelf = self;
        _navigationView.block = ^{
            [weakSelf backEventHander];
        };
        _navigationView.rightBlock = ^{
            [weakSelf rightEventHander];
        };
    }
    return _navigationView;
}

@end
