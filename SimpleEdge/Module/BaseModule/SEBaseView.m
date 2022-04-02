//
//  SEBaseView.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "SEBaseView.h"

@interface SEBaseView ()

@end

@implementation SEBaseView
- (void)dealloc {
    NSLog(@"======== Dealloc %@ ========", NSStringFromClass(self.class));
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect area = self.bounds;
    if (!CGSizeEqualToSize(self.enlargeTouchSize, CGSizeZero)) {
        area = CGRectInset(self.bounds, -self.enlargeTouchSize.width, -self.enlargeTouchSize.height);
    } else if (!CGRectEqualToRect(self.enlargeTouchRect, CGRectZero)) {
        area = CGRectMake(self.bounds.origin.x + self.enlargeTouchRect.origin.x, self.bounds.origin.y + self.enlargeTouchRect.origin.y, self.bounds.size.width + self.enlargeTouchRect.size.width, self.bounds.size.height + self.enlargeTouchRect.size.height);
    }
    return CGRectContainsPoint(area, point);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return view;
}
@end
