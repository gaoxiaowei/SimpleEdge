//
//  GLURLBar.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SEWebAdressView;
typedef NS_OPTIONS(NSInteger, SEWebAdressViewAction) {
    SEWebAdressViewActionBack = 0,
    SEWebAdressViewActionForward,
    SEWebAdressViewActionAdd,
    SEWebAdressViewActionTab,
    SEWebAdressViewActionShare
};

@protocol SEWebAdressViewDelegate <NSObject>
@optional
- (void)webAdressView:(SEWebAdressView *)webAdressView didClickRefresh:(BOOL)isLoading;
- (void)webAdressViewButtonAction:(SEWebAdressViewAction)action;
@end


@interface SEWebAdressView : SEBaseView
@property (nonatomic, assign,readonly) BOOL              isLoading;
@property (nonatomic, weak) id <SEWebAdressViewDelegate> delegate;

- (void)updateTitle:(NSString *)title;
- (void)restoreTitle;
- (void)updateLoadingStatus:(BOOL)isLoading;
- (void)updateProgressBar:(CGFloat)progress;

- (void)updateTabNum:(NSInteger)num;
- (void)updateGoBackStatus:(BOOL)canGoBack;
- (void)updateGoForwardStatus:(BOOL)canGoForward;
- (void)udpateLockImageStatus:(BOOL)isHttpsUrl;
@end

