//
//  GLNavigationController.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "SENavigationController.h"

@interface SENavigationController ()

@end

@implementation SENavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if(self = [super initWithRootViewController:rootViewController]){
        [self setup];
    }
    return self;
}

- (void)setup {
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

@end
