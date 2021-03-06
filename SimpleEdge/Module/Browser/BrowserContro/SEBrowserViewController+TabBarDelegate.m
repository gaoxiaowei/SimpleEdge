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
#import "SEWebTabbar.h"
#import "SEWebTabbarActionProtocol.h"
#import "SEUtlity.h"

@interface  SEBrowserViewController(TabBarDelegate)
@end
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
        @weakify(self)
        vc.dismissBlock = ^{
            @strongify(self)
            [self setMutltiTabViewController:nil];
        };
        [self setMutltiTabViewController:vc];
        if (navigationVC.popoverPresentationController) {
            if([SEUtlity isPadFullScreenMode]){
                navigationVC.popoverPresentationController.sourceView = self.urlBar.multiTabButton;
                navigationVC.popoverPresentationController.sourceRect = self.urlBar.multiTabButton.bounds;
            }else{
                navigationVC.popoverPresentationController.sourceView = [self.tabBar getMultiTabButton];
                navigationVC.popoverPresentationController.sourceRect = [self.tabBar getMultiTabButton].bounds;
            }
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
        if (SE_IS_IPAD_DEVICE){
            [self setSystemShareViewController:nil];
        }
    };
    if (SE_IS_IPAD_DEVICE) {
        [self setSystemShareViewController:activityVC];
        if (activityVC.popoverPresentationController) {
            if([SEUtlity isPadFullScreenMode]){
                activityVC.popoverPresentationController.sourceView = self.urlBar.shareButton;
                activityVC.popoverPresentationController.sourceRect = self.urlBar.shareButton.bounds;
            }else{
                activityVC.popoverPresentationController.sourceView = [self.tabBar getShareButton];
                activityVC.popoverPresentationController.sourceRect = [self.tabBar getShareButton].bounds;
            }
            activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
    }
    [self presentViewController:activityVC animated:YES completion:nil];
}
//
-(void)updateLayoutPopoverViewIfNeed{
    if (SE_IS_IPAD_DEVICE) {
        if ([self mutltiTabViewController]!=nil) {
            if([SEUtlity isPadFullScreenMode]){
                [self mutltiTabViewController].popoverPresentationController.sourceView = self.urlBar.multiTabButton;
                [self mutltiTabViewController].popoverPresentationController.sourceRect = self.urlBar.multiTabButton.bounds;
            }else{
                [self mutltiTabViewController].popoverPresentationController.sourceView = [self.tabBar getMultiTabButton];
                [self mutltiTabViewController].popoverPresentationController.sourceRect = [self.tabBar getMultiTabButton].bounds;
            }
        }
        if([self systemShareViewController]!=nil){
            if([SEUtlity isPadFullScreenMode]){
                [self systemShareViewController].popoverPresentationController.sourceView = self.urlBar.shareButton;
                [self systemShareViewController].popoverPresentationController.sourceRect = self.urlBar.shareButton.bounds;
            }else{
                [self systemShareViewController].popoverPresentationController.sourceView = [self.tabBar getShareButton];
                [self systemShareViewController].popoverPresentationController.sourceRect = [self.tabBar getShareButton].bounds;
            }
        }
    }
}

#pragma mark - extend property
- (void)setMutltiTabViewController:(SEMutltiTabViewController *)vc {
    objc_setAssociatedObject(self, @selector(mutltiTabViewController),vc,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SEMutltiTabViewController *)mutltiTabViewController {
    return objc_getAssociatedObject(self, @selector(mutltiTabViewController));
}

- (void)setSystemShareViewController:(UIActivityViewController *)vc {
    objc_setAssociatedObject(self, @selector(systemShareViewController),vc,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityViewController *)systemShareViewController {
    return objc_getAssociatedObject(self, @selector(systemShareViewController));
}

@end
