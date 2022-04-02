//
//  UIButton+SEUIUtils.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "UIButton+SEUIUtils.h"

@implementation UIButton (GLUIUtils)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

+ (UIButton *)createButtonWithFrameByImage:(CGRect)frame
                               normalImage:(UIImage *)normalImage
                               selectImage:(UIImage *)selectImage
                              disableImage:(UIImage *)disableImage
                                    target:(id)target
                                    action:(SEL)action
                          forControlEvents:(UIControlEvents)controlEvents{
    return [UIButton createButtonWithFrame:frame
                            backgroundColor:nil
                                buttonTitle:nil
                                  titleFont:nil
                           titleColorNormal:nil
                           titleColorSelect:nil
                                normalImage:normalImage
                                selectImage:selectImage
                               disableImage:disableImage
                                     target:target
                                     action:action
                           forControlEvents:controlEvents];
}


+ (UIButton *)createButtonWithFrame:(CGRect)frame
                    backgroundColor:(UIColor *)backgroundColor
                        buttonTitle:(NSString *)title
                          titleFont:(UIFont *)titleFont
                   titleColorNormal:(UIColor *)titleColorNormal
                   titleColorSelect:(UIColor *)titleColorSelect
                        normalImage:(UIImage *)normalImage
                        selectImage:(UIImage *)selectImage
                       disableImage:(UIImage *)disableImage
                             target:(id)target
                             action:(SEL)action
                   forControlEvents:(UIControlEvents)controlEvents{
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundColor:backgroundColor];
    button.titleLabel.font = titleFont;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColorNormal forState:UIControlStateNormal];
    [button setTitleColor:titleColorSelect forState:UIControlStateSelected];
    [button setTitleColor:titleColorSelect forState:UIControlStateHighlighted];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectImage forState:UIControlStateSelected];
    [button setImage:disableImage forState:UIControlStateDisabled];
    [button addTarget:target action:action forControlEvents:controlEvents];
    return button;
}
#pragma clang diagnostic pop

@end
