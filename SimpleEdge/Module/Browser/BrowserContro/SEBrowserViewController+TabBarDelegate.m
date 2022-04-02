//
//  SEBrowserViewController+TabBarDelegate.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEBrowserViewController+TabBarDelegate.h"
#import "SETabManager.h"
#import "SEMutltiTabViewController.h"
#import "SENavigationController.h"
#import "SEWebAdressView.h"
#import "SEWebTabbarActionProtocol.h"
#import "SEUtlity.h"

@implementation SEBrowserViewController (TabBarDelegate)

- (void)tabBarButtonAction:(SEWebTabbarAction)action {
    SETab *selectedTab = [[SETabManager shared] getSelectedTab];
    switch (action) {
        case SEWebTabbarActionBack:{
            [selectedTab goBack];
            break;
        }
        case SEWebTabbarActionForward:{
            [selectedTab goForward];
            break;
        }
        case SEWebTabbarActionShare:{
            [self doShareAction:selectedTab];
            break;
        }
        case SEWebTabbarActionTab:{
            [self showMultiTab];
            break;
        }
        case SEWebTabbarActionAdd: {
            SETab *newTab = [[SETabManager shared] addTabWithURLString:kSEHomeUrl];
            [[SETabManager shared] selectTab:newTab];
            break;
        }
        default:
            break;
    }
}

- (void)webAdressViewButtonAction:(SEWebAdressViewAction)action{
    SETab *selectedTab = [[SETabManager shared] getSelectedTab];
    switch (action) {
        case SEWebAdressViewActionBack:{
            [selectedTab goBack];
            break;
        }
        case SEWebAdressViewActionForward:{
            [selectedTab goForward];
            break;
        }
        case SEWebAdressViewActionAdd:{
            SETab *newTab = [[SETabManager shared] addTabWithURLString:kSEHomeUrl];
            [[SETabManager shared] selectTab:newTab];
            break;
        }
        case SEWebAdressViewActionTab:{
            [self showMultiTab];
            break;
        }
        case SEWebAdressViewActionShare:{
            [self doShareAction:selectedTab];
            break;
        }
        default:
            break;
    }
}

- (void)showMultiTab {
    SEMutltiTabViewController*vc =[[SEMutltiTabViewController alloc]init];
    SENavigationController *navigationVC = [[SENavigationController alloc] initWithRootViewController:vc];
    navigationVC.modalPresentationStyle = UIModalPresentationPopover;
    
    if (SE_IS_IPAD_DEVICE) {
        if (navigationVC.popoverPresentationController) {
            navigationVC.popoverPresentationController.sourceView = self.view;
            navigationVC.popoverPresentationController.sourceRect = CGRectMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0, 1.0, 1.0);
            navigationVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
    }
    
    [self presentViewController:navigationVC animated:YES completion:nil];
}

-(void)doShareAction:(SETab *)selectedTab{
    [self systemShare:@[selectedTab.url] completion:^(BOOL success, NSError * _Nullable error) {
        
    }];
}

- (void)systemShare:(NSArray *)items completion:(void(^)(BOOL success, NSError * _Nullable error))completion{
    if (items.count == 0) {
        return;
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            completion(completed, activityError);
        }
    };
    if (SE_IS_IPAD_DEVICE) {
        if (activityVC.popoverPresentationController) {
            activityVC.popoverPresentationController.sourceView = self.view;
            activityVC.popoverPresentationController.sourceRect = CGRectMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0, 1.0, 1.0);
            activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
    }
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
