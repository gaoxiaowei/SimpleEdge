//
//  SEInputAccessoryView.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEInputAccessoryView.h"
#import "SEUtlity.h"

@interface SEInputAccessoryView ()
@property (nonatomic, strong) UIView *titleView;

@end

@implementation SEInputAccessoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupNotifaction];
    }
    return self;
}

#pragma mark - layout
- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleView];
    [self setupLayout];
}

- (void)setupLayout {
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset([self calcTitleLeftMargin]);
        make.right.equalTo(self);
    }];
}

-(void)updatelayout{
    [self.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset([self calcTitleLeftMargin]);
    }];
}
#pragma mark -notifaction

-(void)setupNotifaction{
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kSEViewWillTransitionNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self updatelayout];
    }];
}

#pragma mark - action
- (void)clickTitleBtn:(UIButton *)btn {
    NSString *title = btn.titleLabel.text;
    if (self.selectStrAction) {
        self.selectStrAction(title);
    }
}

#pragma mark - lazy
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor clearColor];
        NSArray *titles = @[@"www.", @".com", @".cn", @".", @"/"];
        CGFloat x = 0;
        for (NSInteger i = 0; i < titles.count; i++) {
            CGFloat width = [self titleAtIndex:i];
            UIButton *btn = [[UIButton alloc] init];
            btn.frame = CGRectMake(x, 0, width, 45);
            x += width;
            btn.backgroundColor = [UIColor clearColor];
            [btn setBackgroundImage:[UIImage imageNamed:@"se_keyboard_bg_hl"] forState:UIControlStateHighlighted];
            [btn setTitleColor:SE_HEXCOLOR(0x222222)  forState:UIControlStateNormal];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
            [btn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
            if (i < [titles count] - 1) {
                UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(btn.bounds.size.width-1, 12.5, 1, 20)];
                sep.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                sep.backgroundColor = SE_HEXCOLOR(0xe8e8e8);
                [btn addSubview:sep];
            }
            _titleView.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin;
            [_titleView addSubview:btn];
        }
    }
    return _titleView;
}

#pragma mark - other
-(CGFloat)calcTitleLeftMargin{
    CGFloat leftMargin =0.f;
    if([SEUtlity isLandScapeMode]){
        if(self.se_safeArea.bottom > 0) {
            leftMargin = 33.f;
        }
    }
    return leftMargin;
}

- (CGFloat)titleAtIndex:(NSInteger)index {
    if (index == 0 || index == 1) {
        return 55;
    } else if (index == 2) {
        return 45;
    } else {
        return 35;
    }
}

@end
