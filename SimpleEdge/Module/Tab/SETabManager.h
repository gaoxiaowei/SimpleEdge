//
//  SETabManager.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/29.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SETab.h"

@class SETabManager,SETabModel;

@protocol SETabManagerDelegate <NSObject>
@optional
- (void)tabManager:(SETabManager *)tabManager didAddTab:(SETab *)tab;
- (void)tabManager:(SETabManager *)tabManager didRemoveTab:(SETab *)tab;
- (void)tabManager:(SETabManager *)tabManager didSelectedTab:(SETab *)selectedTab previous:(SETab *)previousTab;

@end


@interface SETabManager : NSObject
@property (nonatomic, assign) NSInteger selectedIndex;
+ (instancetype)shared;

- (void)addDelegate:(id <SETabManagerDelegate>)delegate;
- (void)removeDelegate:(id <SETabManagerDelegate>)delegate;

- (void)restoreTabs;

- (SETab *)addTabWithURLString:(NSString *)URLString;
- (SETab *)addTabWithURLString:(NSString *)URLString needCreatWeb:(BOOL)needCreatWeb;

- (void)removeAllTabs;
- (void)removeTabAndUpdateSelectedIndex:(SETab *)tab;

- (void)selectTab:(SETab *)tab;

- (NSArray *)getAllTab;
- (SETab *)getSelectedTab;
- (SETab *)tabForWebView:(SEWebView *)webView;

-(NSInteger)getLastTabSortIndex;
-(void)updateSelectdTab;
-(void)changeTabIndex:(NSInteger)sourceIndex destinationIndex:(NSInteger)destinationIndex;

@end
