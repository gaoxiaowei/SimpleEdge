//
//  SEMutltiTabViewController.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/29.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SEMutltiTabViewController : SEBaseNavigationController

@property(nonatomic,copy)dispatch_block_t dismissBlock;
@end

NS_ASSUME_NONNULL_END
