//
//  SEWebAdressView.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEWebAdressView.h"
#import "SEGradientProgressBar.h"
#import "SESearchBar.h"
#import "SEURLTool.h"
#import "NSString+Encode.h"
#import "SEUtlity.h"
#import "SEControllerHelper.h"

NSInteger const kSEWebAdressViewBtnWidth    =32.f;
NSInteger const kSEWebAdressViewBtnHeight   =32.f;
NSInteger const kSEWebAdressViewBtnMagrin   =16.f;

@interface SEWebAdressView ()<SESearchBarDelegate>
@property (nonatomic, assign) BOOL                  isLoading;
@property (nonatomic, strong) UIView                *borderView;
@property (nonatomic,strong)  UIImageView           *lockImageView;
@property (nonatomic, strong) UILabel               *addressLab;
@property (nonatomic, strong) UIButton              *addressBtn;
@property (nonatomic, strong) UIButton              *refreshBtn;
@property (nonatomic, strong) SEGradientProgressBar *progressBar;
@property (nonatomic, strong) SESearchBar           *searchBar;

//landscape or fullscreen
@property (nonatomic, strong) UIButton              *backButton;             //后退
@property (nonatomic, strong) UIButton              *forwardButton;          //前进
@property (nonatomic, strong) UIButton              *addTabButton;           //添加标签
@property (nonatomic, strong) UIButton              *multiTabButton;         //多标签
@property (nonatomic, strong) UIButton              *shareButton;            //分享

@end

@implementation SEWebAdressView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        [self setupNotifaction];
    }
    return self;
}

-(void)dealloc{
    
}
- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.borderView];
    [self addSubview:self.searchBar];
    self.searchBar.hidden=YES;
    [self.borderView addSubview:self.lockImageView];
    [self.borderView addSubview:self.addressLab];
    [self.borderView addSubview:self.addressBtn];
    [self.borderView addSubview:self.refreshBtn];
    
    [self addSubview:self.backButton];
    [self addSubview:self.forwardButton];
    [self addSubview:self.addTabButton];
    [self addSubview:self.multiTabButton];
    [self addSubview:self.shareButton];
    
    [self addSubview:self.progressBar];
    [self setupLayout];
}

-(void)setupNotifaction{
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kSEViewWillTransitionNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self updateLayout];
    }];
}

#pragma mark - action
- (void)clickAddressBtn {
    self.searchBar.hidden=NO;
    self.borderView.hidden=YES;
    [self.searchBar setSearchText:self.addressLab.text];
    [self.searchBar focusOnTextField];
}

#pragma mark - update
- (void)updateTitle:(NSString *)title {
    if (title.length > 0) {
        self.addressLab.text = title;
    }
}

- (void)restoreTitle{
    if([self.searchBar.searchText se_isVaild]){
        self.addressLab.text = self.searchBar.searchText;
    }
}

- (void)updateLoadingStatus:(BOOL)isLoading {
    self.isLoading = isLoading;
    NSString *imgName = isLoading ? @"xmark" : @"arrow.clockwise";
    UIImage *img = [UIImage imageNamed:imgName];
    [self.refreshBtn setImage:img forState:UIControlStateNormal];
    [self.refreshBtn setImage:img forState:UIControlStateHighlighted];
}

- (void)updateProgressBar:(CGFloat)progress {
    self.progressBar.alpha = 1;
    self.progressBar.hidden = NO;
    [self.progressBar setProgress:progress animated:YES];
}

- (void)updateGoForwardStatus:(BOOL)canGoForward {
    self.forwardButton.enabled = canGoForward;
}

- (void)updateGoBackStatus:(BOOL)canGoBack {
    self.backButton.enabled = canGoBack;
}

- (void)updateTabNum:(NSInteger)num{
    NSString*imageName;
    if ([SETabManager shared].getAllTab.count >= kMaxTabCount) {
        imageName = @"square.stack";
    }else{
        imageName =[NSString stringWithFormat:@"%ld.square",num];
    }
    UIImage*image =[UIImage imageNamed:imageName];
    [self.multiTabButton setImage:image forState:UIControlStateNormal];
}

- (void)udpateLockImageStatus:(BOOL)isHttpsUrl{
    if(isHttpsUrl){
        _lockImageView.image =[UIImage imageNamed:@"lock.fill"];
    }else{
        _lockImageView.image =[UIImage imageNamed:@"info.circle"];
    }
}

#pragma mark - layout
-(void)preLayout:(void(^)(CGFloat borderViewLeftMargin,CGFloat borderViewRightMargin,CGFloat webAdressViewBtnLRMargin))completion{
    CGFloat borderViewLeftMargin  =8.0f;
    CGFloat borderViewRightMargin =8.0f;
    CGFloat webAdressViewBtnLRMargin =[self calButtonLRMargin];
    BOOL isLandscape = [SEUtlity isLandScapeMode];
    if (SE_IS_IPAD_DEVICE) {
        if(![SEUtlity isPadFullScreenMode]){
            self.backButton.hidden=YES;
            self.forwardButton.hidden=YES;
            self.addTabButton.hidden=YES;
            self.multiTabButton.hidden=YES;
            self.shareButton.hidden=YES;
        }else{
            borderViewLeftMargin =webAdressViewBtnLRMargin+(kSEWebAdressViewBtnWidth+kSEWebAdressViewBtnMagrin)*2;
            borderViewRightMargin =webAdressViewBtnLRMargin+(kSEWebAdressViewBtnWidth+kSEWebAdressViewBtnMagrin)*3+kSEWebAdressViewBtnMagrin;
            self.backButton.hidden=NO;
            self.forwardButton.hidden=NO;
            self.addTabButton.hidden=NO;
            self.multiTabButton.hidden=NO;
            self.shareButton.hidden=NO;
        }
    }else{
        //横屏
        if (isLandscape){
            borderViewLeftMargin =webAdressViewBtnLRMargin+(kSEWebAdressViewBtnWidth+kSEWebAdressViewBtnMagrin)*2;
            borderViewRightMargin =webAdressViewBtnLRMargin+(kSEWebAdressViewBtnWidth+kSEWebAdressViewBtnMagrin)*3+kSEWebAdressViewBtnMagrin;
            self.backButton.hidden=NO;
            self.forwardButton.hidden=NO;
            self.addTabButton.hidden=NO;
            self.multiTabButton.hidden=NO;
            self.shareButton.hidden=NO;
        }else{
            self.backButton.hidden=YES;
            self.forwardButton.hidden=YES;
            self.addTabButton.hidden=YES;
            self.multiTabButton.hidden=YES;
            self.shareButton.hidden=YES;
        }
    }
    SAFE_BLOCK(completion,borderViewLeftMargin,borderViewRightMargin,webAdressViewBtnLRMargin);
}

- (void)setupLayout {
    [self preLayout:^(CGFloat borderViewLeftMargin, CGFloat borderViewRightMargin,CGFloat webAdressViewBtnLRMargin) {
        [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(borderViewLeftMargin);
            make.right.equalTo(self).offset(-borderViewRightMargin);
            make.height.mas_equalTo(38);
            make.centerY.equalTo(self);
        }];
        
        [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.borderView);
        }];
        
        [self.lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.borderView).offset(16);
            make.width.mas_equalTo(13);
            make.centerY.equalTo(self.borderView);
        }];
        [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lockImageView.mas_right).offset(16);
            make.right.equalTo(self.borderView).offset(-48);
            make.top.bottom.equalTo(self.borderView);
        }];
        [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.addressLab);
        }];
        [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.borderView).offset(-12);
            make.centerY.equalTo(self.borderView);
        }];
        [self.progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(2);
        }];
        
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kSEWebAdressViewBtnWidth);
            make.height.mas_equalTo(kSEWebAdressViewBtnHeight);
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(webAdressViewBtnLRMargin);
        }];
        [self.forwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backButton.mas_right).offset(kSEWebAdressViewBtnMagrin);
            make.width.height.equalTo(self.backButton);
            make.centerY.equalTo(self);
        }];
        
        [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-webAdressViewBtnLRMargin);
            make.width.height.equalTo(self.backButton);
            make.centerY.equalTo(self);
        }];
        
        [self.multiTabButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.shareButton.mas_left).offset(-webAdressViewBtnLRMargin);
            make.width.height.equalTo(self.backButton);
            make.centerY.equalTo(self);
        }];
        
        [self.addTabButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.multiTabButton.mas_left).offset(-webAdressViewBtnLRMargin);
            make.width.height.equalTo(self.backButton);
            make.centerY.equalTo(self);
        }];
        self.backButton.enabled=NO;
        self.forwardButton.enabled=NO;
    }];
}

- (void)updateLayout {
    [self preLayout:^(CGFloat borderViewLeftMargin, CGFloat borderViewRightMargin,CGFloat webAdressViewBtnLRMargin) {
        [self.borderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(borderViewLeftMargin);
            make.right.equalTo(self).offset(-borderViewRightMargin);
        }];
    }];
}
#pragma mark - lazy
- (UIView *)borderView {
    if (!_borderView) {
        _borderView = [[UIView alloc] init];
        _borderView.backgroundColor = SE_HEXCOLOR(0xF1F3F4);
        _borderView.layer.cornerRadius = 19;
        _borderView.layer.masksToBounds = YES;
    }
    return _borderView;
}
-(UIImageView*)lockImageView{
    if(!_lockImageView){
        _lockImageView =[UIImageView new];
        _lockImageView.image =[UIImage imageNamed:@"lock.fill"];
        _lockImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _lockImageView;
}

- (UILabel *)addressLab {
    if (!_addressLab) {
        _addressLab = [[UILabel alloc] init];
        _addressLab.textColor = [UIColor blackColor];
        _addressLab.font = [UIFont systemFontOfSize:16];
        _addressLab.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _addressLab;
}

- (UIButton *)addressBtn {
    if (!_addressBtn) {
        _addressBtn = [[UIButton alloc] init];
        _addressBtn.backgroundColor = [UIColor clearColor];
        [_addressBtn addTarget:self action:@selector(clickAddressBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressBtn;
}

- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        @weakify(self)
        [[_refreshBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(webAdressView:didClickRefresh:)]) {
                [self.delegate webAdressView:self didClickRefresh:self.isLoading];
            }
            
        }];
    }
    return _refreshBtn;
}

- (SEGradientProgressBar *)progressBar {
    if (!_progressBar) {
        CGRect rect = CGRectMake(0, 48, [UIScreen mainScreen].bounds.size.width, 4);
        _progressBar = [[SEGradientProgressBar alloc] initWithFrame:rect];
        [_progressBar setGradientColors:SE_HEXCOLOR(0x4E95E7) endColor:SE_HEXCOLOR(0x53B7F6)];
    }
    return _progressBar;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"chevron.left"] forState:UIControlStateNormal];
        @weakify(self)
        [[_backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self doButtonAction:SEWebAdressViewActionBack];
        }];
    }
    return _backButton;
}

- (UIButton *)forwardButton{
    if (!_forwardButton) {
        _forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forwardButton setImage:[UIImage imageNamed:@"chevron.right"] forState:UIControlStateNormal];
        @weakify(self)
        [[_forwardButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self doButtonAction:SEWebAdressViewActionForward];
        }];
    }
    return _forwardButton;
}

- (UIButton *)addTabButton{
    if (!_addTabButton) {
        _addTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addTabButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        @weakify(self)
        [[_addTabButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self doButtonAction:SEWebAdressViewActionAdd];
        }];
    }
    return _addTabButton;
}
- (UIButton *)multiTabButton{
    if (!_multiTabButton) {
        _multiTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_multiTabButton setImage:[UIImage imageNamed:@"0.square"] forState:UIControlStateNormal];
        @weakify(self)
        [[_multiTabButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self doButtonAction:SEWebAdressViewActionTab];
        }];
    }
    return _multiTabButton;
}

- (UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"square.and.arrow.up"] forState:UIControlStateNormal];
        @weakify(self)
        [[_shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self doButtonAction:SEWebAdressViewActionShare];
        }];
    }
    return _shareButton;
}

- (SESearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[SESearchBar alloc] init];
        _searchBar.shouldSelectAll = YES;
        _searchBar.delegate = self;
    }
    return _searchBar;
}

-(void)doButtonAction:(SEWebAdressViewAction)action{
    if ([self.delegate respondsToSelector:@selector(webAdressViewButtonAction:)]) {
        [self.delegate webAdressViewButtonAction:action];
    }
}

#pragma mark - SESearchBarDelegate
- (void)searchBar:(SESearchBar *)bar didClickCacncel:(UIButton *)sender{
    [self.searchBar loseFocusOnTextField];
    self.searchBar.hidden=YES;
    self.borderView.hidden=NO;
}

- (void)searchBar:(SESearchBar *)bar textDidChange:(NSString *)text{
    
}

- (void)searchBar:(SESearchBar *)bar didClickSearch:(NSString *)text{
    BOOL empty = [text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0;
    if (empty) {
        return;
    }
    self.searchBar.hidden=YES;
    self.borderView.hidden=NO;
    [self openUrlWithSearchText:text];
}

#pragma mark -common
- (void)openUrlWithSearchText:(NSString *)selectStr {
    NSString *urlString = selectStr;
    if ([SEURLTool isUrl:selectStr] == NO) {
        urlString =[NSString stringWithFormat:@"%@?q=%@",kSESearchEngineUrl,[selectStr encodeString]];
    }
    
    [[[SETabManager shared] getSelectedTab] openURLString:urlString];
}

-(BOOL)isSizeClassCompactMode{
    UIViewController* currentVC =[SEControllerHelper getCurrentVC];
    if([currentVC isKindOfClass:[SEBaseViewController class]]){
        SEBaseViewController*vc =(SEBaseViewController*)currentVC;
        return [vc isSizeClassCompactMode];
    }
    return currentVC.traitCollection.horizontalSizeClass ==UIUserInterfaceSizeClassCompact;
}

-(CGFloat)calButtonLRMargin{
    if(SE_IS_IPHONE_DEVICE && [self se_safeArea].bottom>0){
        return 32.f;
    }
    return 16.f;
}

@end
