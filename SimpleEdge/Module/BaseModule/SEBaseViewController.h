//
//  SEBaseViewController.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import <UIKit/UIKit.h>

@interface SEBaseViewController : UIViewController

@property (nonatomic, assign)          BOOL                     isStatusBarHidden;
@property (nonatomic, assign,readonly) UIUserInterfaceSizeClass curHorizontalSizeClass;

-(BOOL)isSizeClassCompactMode;

@end
