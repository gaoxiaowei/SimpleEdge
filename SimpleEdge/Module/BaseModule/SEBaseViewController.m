//
//  SEBaseViewController.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "SEBaseViewController.h"

@interface SEBaseViewController ()
@property (nonatomic, assign) UIUserInterfaceSizeClass curHorizontalSizeClass;
@end

@implementation SEBaseViewController
- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.isStatusBarHidden = NO;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"======== Dealloc %@ ========", NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"======== Enter %@ ========", NSStringFromClass(self.class));
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return self.isStatusBarHidden;
}

#pragma mark - 方向
- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

//StatusBar color
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    }
    return UIStatusBarStyleDefault;
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    self.curHorizontalSizeClass =newCollection.horizontalSizeClass;
}

-(BOOL)isSizeClassCompactMode{
    return self.curHorizontalSizeClass ==UIUserInterfaceSizeClassCompact;
}

@end
