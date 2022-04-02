//
//  SETabTableViewCell.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/29.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SETabTableViewCell : UITableViewCell

+ (NSString *)cellIdentifier;

- (void)configWithUrlTitle:(NSString*)urlTitle urlString:(NSString*)urlString selected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
