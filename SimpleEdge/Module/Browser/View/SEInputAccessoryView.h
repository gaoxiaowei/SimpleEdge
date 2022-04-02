//
//  SEInputAccessoryView.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectStrAction) (NSString *str);

@interface SEInputAccessoryView : SEBaseView
@property (nonatomic, copy) SelectStrAction selectStrAction;

@end

