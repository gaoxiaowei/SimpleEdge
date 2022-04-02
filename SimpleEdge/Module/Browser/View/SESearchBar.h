//
//  SESearchBar.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SESearchBar;
@protocol SESearchBarDelegate <NSObject>
@optional
- (void)searchBar:(SESearchBar *)bar didClickCacncel:(UIButton *)sender;
- (void)searchBar:(SESearchBar *)bar textDidChange:(NSString *)text;
- (void)searchBar:(SESearchBar *)bar didClickSearch:(NSString *)text;

@end

@interface SESearchBar : SEBaseView
@property (nonatomic, assign) BOOL                   shouldSelectAll;
@property (nonatomic, copy) NSString                 *searchText;
@property (nonatomic, weak) id <SESearchBarDelegate> delegate;

- (void)focusOnTextField;
- (void)loseFocusOnTextField;

@end
