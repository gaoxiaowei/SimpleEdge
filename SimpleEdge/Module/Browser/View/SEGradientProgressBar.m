//
//  SEGradientProgressBar.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEGradientProgressBar.h"

const NSTimeInterval kSEGradientProgressBarAnimationDuration  =0.2f;

@interface SEGradientProgressBar ()
@property (nonatomic, strong) NSArray           *gradientColors;
@property (nonatomic, strong) CAGradientLayer   *gradientLayer;
@property (nonatomic, strong) CALayer           *alphaMaskLayer;

@end

@implementation SEGradientProgressBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _gradientColors = @[];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    self.trackTintColor = [UIColor clearColor];
    self.progressTintColor = [UIColor clearColor];
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (CGRect)updateRectWidth:(CGRect)rect byPercent:(CGFloat)percent {
    CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width * percent, rect.size.height);
    return newRect;
}

#pragma mark - antimation
- (void)animateGradient {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.duration = kSEGradientProgressBarAnimationDuration * 4;
    animation.fromValue = @[@0.0, @0.0, @0.0, @0.2, @0.4, @0.6, @0.8];
    animation.toValue = @[@0.0, @0.2, @0.4, @0.6, @0.8, @1.0, @1.0];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.repeatCount = MAXFLOAT;
    [self.gradientLayer addAnimation:animation forKey:@"colorChange"];
}

- (void)hideProgressBar {
    if (self.progress != 1) {
        return;
    }
    
    [CATransaction begin];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint toPoint = CGPointMake(self.gradientLayer.frame.size.width, self.gradientLayer.position.y);
    NSValue *from = [NSValue valueWithCGPoint:self.gradientLayer.position];
    NSValue *to = [NSValue valueWithCGPoint:toPoint] ;
    
    animation.fromValue = from;
    animation.toValue = to;
    animation.duration = kSEGradientProgressBarAnimationDuration;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [CATransaction setCompletionBlock:^{
        [self resetProgressBar];
    }];
    [self.gradientLayer addAnimation:animation forKey:@"position"];
    [CATransaction commit];
}

- (void)resetProgressBar {
    [super setProgress:0 animated:NO];
    self.hidden = YES;
}

- (void)updateAlphaMaskLayerWidth:(BOOL)animated {
    [CATransaction begin];
    CFTimeInterval duration = animated ? kSEGradientProgressBarAnimationDuration : 0.0;
    [CATransaction setAnimationDuration:duration];
    
    self.alphaMaskLayer.frame = [self updateRectWidth:self.bounds byPercent:self.progress];
    if (self.progress == 1) {
        [CATransaction setCompletionBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kSEGradientProgressBarAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hideProgressBar];
            });
        }];
    }
    [CATransaction commit];
}


#pragma mark - set
- (void)setGradientColors:(UIColor *)startColor endColor:(UIColor *)endColor {
    id start = (id)startColor.CGColor;
    id end = (id)endColor.CGColor;
    self.gradientColors = @[start, end, start, end, start, end, start];
    self.gradientLayer.colors = self.gradientColors;
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    if (progress < self.progress && self.progress != 1) {
        return;
    }
    [self.gradientLayer removeAnimationForKey:@"position"];
    if ([self.gradientLayer animationForKey:@"colorChange"] == nil) {
        [self animateGradient];
    }
    [super setProgress:progress animated:animated];
    [self updateAlphaMaskLayerWidth:animated];
}

#pragma mark - lazy
- (CALayer *)alphaMaskLayer {
    if (!_alphaMaskLayer) {
        _alphaMaskLayer = [CALayer layer];
        _alphaMaskLayer.frame = self.bounds;
        _alphaMaskLayer.cornerRadius = 3;
        _alphaMaskLayer.anchorPoint = CGPointZero;
        _alphaMaskLayer.position = CGPointZero;
        _alphaMaskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    return _alphaMaskLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width * 2, self.bounds.size.height);
        _gradientLayer.mask = self.alphaMaskLayer;
        _gradientLayer.colors = self.gradientColors;
        _gradientLayer.locations = @[@0.0, @0.2, @0.4, @0.6, @0.8, @1.0, @1.0];
        _gradientLayer.startPoint = CGPointZero;
        _gradientLayer.endPoint = CGPointMake(1, 0);
        _gradientLayer.drawsAsynchronously = YES;
    }
    return _gradientLayer;
}

@end
