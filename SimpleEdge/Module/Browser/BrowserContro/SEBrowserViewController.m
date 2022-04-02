//
//  SEBrowserViewController.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

//vc
#import "SEBrowserViewController.h"
#import <Masonry/Masonry.h>

//view
#import "SEWebAdressView.h"
#import "SEWebTabbar.h"
#import "SEWebTabbarActionProtocol.h"

//other
#import "SEBrowserHeader.h"
#import "SETabManager.h"
#import "SEURLTool.h"
#import "SEUtlity.h"


@interface SEBrowserViewController ()<SETabManagerDelegate,SETabDelegate,SEWebTabbarActionProtocol
,SEWebAdressViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIView            *webViewContainer;
@property (nonatomic, strong) SEWebAdressView   *urlBar;
@property (nonatomic, strong) SEWebTabbar       *tabBar;

@end

@implementation SEBrowserViewController

- (instancetype)init {
    if (self = [super init]) {
        [[SETabManager shared] addDelegate:self];
    }
    return self;
}

-(void)dealloc{
    [[SETabManager shared] removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self setupViews];
    [[SETabManager shared] restoreTabs];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - SETabManagerDelegate
- (void)tabManager:(SETabManager *)tabManager didSelectedTab:(SETab *)selectedTab previous:(SETab *)previousTab {
    SEWebView *wv = previousTab.webView;
    if (wv) {
        [wv endEditing:YES];
        [wv removeFromSuperview];
    }
    
    SEWebView *webView = selectedTab.webView;
    [self.webViewContainer addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.webViewContainer);
    }];
    
    [self updateTabCountByTabManager:tabManager];
    [self updateContentByUrl:selectedTab.url];
    [self.urlBar updateGoBackStatus:webView.canGoBack];
    [self.urlBar updateGoForwardStatus:webView.canGoForward];
    [self.tabBar updateGoBackStatus:webView.canGoBack];
    [self.tabBar updateGoForwardStatus:webView.canGoForward];
}

- (void)tabManager:(SETabManager *)tabManager didAddTab:(SETab *)tab {
    tab.tabDelegate = self;
    [self updateTabCountByTabManager:tabManager];
    [self.urlBar updateGoBackStatus:NO];
    [self.urlBar updateGoForwardStatus:NO];
    [self.tabBar updateGoBackStatus:NO];
    [self.tabBar updateGoForwardStatus:NO];
}

- (void)tabManager:(SETabManager *)tabManager didRemoveTab:(SETab *)tab{
    [self updateTabCountByTabManager:tabManager];
    tab.tabDelegate = self;
}

- (void)updateTabCountByTabManager:(SETabManager *)tabManager {
    NSArray *tabs = [tabManager getAllTab];
    NSInteger count = tabs.count;
    [self.tabBar updateTabNum:count];
    [self.urlBar updateTabNum:count];
}

#pragma mark - SETabDelegate
- (void)tab:(SETab *)tab didCreatWebView:(SEWebView *)webView {
    [self.webViewContainer addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.webViewContainer);
    }];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    webView.scrollView.delegate = self;
    [self addKVOForWebView:webView];
}

- (void)tab:(SETab *)tab willDeleteWebView:(SEWebView *)webView {
    [self removeKVOForWebView:webView];
    webView.UIDelegate = nil;
    webView.navigationDelegate=nil;
    webView.scrollView.delegate = nil;
    [webView removeFromSuperview];
}

- (void)webAdressView:(SEWebAdressView *)webAdressView didClickRefresh:(BOOL)isLoading {
    SETabManager *tabManager = [SETabManager shared];
    if (isLoading) {
        [[tabManager getSelectedTab] stop];
    } else {
        [[tabManager getSelectedTab] reload];
    }
}

#pragma mark - KVO
- (void)addKVOForWebView:(SEWebView *)webView {
    for (NSString *keyPath in SEWebViewKVOPaths()) {
        [webView addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)removeKVOForWebView:(SEWebView *)webView {
    for (NSString *keyPath in SEWebViewKVOPaths()) {
        [webView removeObserver:self forKeyPath:keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    SETabManager *tabManager = [SETabManager shared];
    SEWebView *webView = (SEWebView *)object;
    SETab *tab = [tabManager tabForWebView:webView];
    if ([keyPath isEqualToString:kSEWebViewKVOEestimatedProgress]) {
        double progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        tab.estimatedProgress = progress;
        if (tab == [tabManager getSelectedTab]){
            [self updateProgressBar:progress];
        }
        [tab restoreWebView];
    } else if ([keyPath isEqualToString:kSEWebViewKVOLoading]) {
        BOOL isLoding = [change[NSKeyValueChangeNewKey] boolValue];
        tab.loading = isLoding;
        if (tab == [tabManager getSelectedTab]){
            [self.urlBar updateLoadingStatus:isLoding];
        }
    
    } else if ([keyPath isEqualToString:kSEWebViewKVOUrl]) {
        NSURL *url = [change objectForKey:NSKeyValueChangeNewKey];
        if([url isKindOfClass:[NSURL class]]){
            if(![SEURLTool isLocalErrorUrl:url]){
                tab.url = url;
                if (tab == [tabManager getSelectedTab]){
                    [self updateContentByUrl:url];
                }
            }else{
                tab.url = tab.unreachedUrl;
                if (tab == [tabManager getSelectedTab]){
                    [self.urlBar restoreTitle];
                }
                
            }
        }
        
    } else if ([keyPath isEqualToString:kSEWebViewKVOTitle]) {
        NSString *title = [change objectForKey:NSKeyValueChangeNewKey];
        tab.title = title;
    } else if ([keyPath isEqualToString:kSEWebViewKVOCanGoBack]) {
        BOOL can = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        tab.canGoBack = can;
        if (tab == [tabManager getSelectedTab]) {
            [self.tabBar updateGoBackStatus:can];
            [self.urlBar updateGoBackStatus:can];
        }
    } else if ([keyPath isEqualToString:kSEWebViewKVOCanGoForward]) {
        BOOL can = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        tab.canGoForward = can;
        if (tab == [tabManager getSelectedTab]) {
            [self.tabBar updateGoForwardStatus:can];
            [self.urlBar updateGoForwardStatus:can];
        }
    }
}

- (void)updateProgressBar:(CGFloat)estimatedProgress {
    [self.urlBar updateProgressBar:estimatedProgress];
}

- (void)updateContentByUrl:(NSURL *)url {
    if([url isKindOfClass:[NSURL class]]){
        NSString *urlString = url.absoluteString;
        self.urlBar.hidden = NO;
        self.tabBar.hidden = NO;
        [self.urlBar updateTitle:urlString];
        BOOL isHttpsUrl=[url.scheme isEqualToString:@"https"];
        [self.urlBar udpateLockImageStatus:isHttpsUrl];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}


#pragma mark - UI
- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.urlBar];
    [self.view addSubview:self.webViewContainer];
    [self.view addSubview:self.tabBar];
    [self setupLayout];
}

-(CGFloat)getSafeAreaTop{
    if(SE_IS_IPAD_DEVICE){
        return 20.f;
    }else{
        CGFloat top = 0;
        if (self.se_safeArea.bottom > 0) {
            top = self.se_safeArea.top;
        } else {
            top = 20.f;
        }
        return top;
    }
}

- (void)setupLayout {
    CGFloat safeAreaTop = [self getSafeAreaTop];
    CGFloat safeAreaBottom = [self se_safeArea].bottom;
    [self.urlBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(safeAreaTop);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(48);
    }];
    
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(49);
        if (SE_IS_IPAD_DEVICE) {
            if(![SEUtlity isPadFullScreenMode] ||[self isSizeClassCompactMode]){
                make.top.equalTo(self.view).offset(self.view.frame.size.height-safeAreaBottom-49);
            }else{
                make.top.equalTo(self.view).offset(self.view.frame.size.height);
            }
        }else{
            BOOL isLandscape = self.view.frame.size.width > self.view.frame.size.height;
            if(isLandscape){
                make.top.equalTo(self.view).offset(self.view.frame.size.height);
            }else{
                make.top.equalTo(self.view).offset(self.view.frame.size.height-safeAreaBottom-49);
            }
            
        }
    }];
    
    [self.webViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.urlBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.tabBar.mas_top);
    }];
}

-(void)updateLayout{
    BOOL isLandscape = self.view.frame.size.width > self.view.frame.size.height;
    if(isLandscape){
        CGFloat safeAreaTop = 0;
        if(SE_IS_IPAD_DEVICE){
            safeAreaTop =20.f;
        }
        CGFloat safeAreaBottom = [self se_safeArea].bottom;
        [self.urlBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(safeAreaTop);
        }];
        
        [self.tabBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(self.view.frame.size.height);
        }];
        
        [self.webViewContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-safeAreaBottom);
        }];
        
        
    }else{
        CGFloat safeAreaTop = [self getSafeAreaTop];
        if(safeAreaTop ==0){
            safeAreaTop =self.se_safeArea.left;
        }
        CGFloat safeAreaBottom = [self se_safeArea].bottom;
        [self.urlBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(safeAreaTop);
        }];
        [self.tabBar mas_updateConstraints:^(MASConstraintMaker *make) {
            if (SE_IS_IPAD_DEVICE) {
                if(![SEUtlity isPadFullScreenMode] || [self isSizeClassCompactMode]){
                    make.top.equalTo(self.view).offset(self.view.frame.size.height-safeAreaBottom-49);
                }else{
                    make.top.equalTo(self.view).offset(self.view.frame.size.height);
                }
            }else{
                make.top.equalTo(self.view).offset(self.view.frame.size.height-safeAreaBottom-49);
            }
        }];
        [self.webViewContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.tabBar.mas_top);
        }];
        
    }
}

#pragma mark - lazy
- (SEWebAdressView *)urlBar {
    if (!_urlBar) {
        _urlBar = [[SEWebAdressView alloc] init];
        _urlBar.hidden = YES;
        _urlBar.delegate = self;
    }
    return _urlBar;
}

- (UIView *)webViewContainer {
    if (!_webViewContainer) {
        _webViewContainer = [[UIView alloc] init];
        _webViewContainer.backgroundColor = [UIColor whiteColor];
    }
    return _webViewContainer;
}

- (SEWebTabbar *)tabBar{
    if (!_tabBar) {
        _tabBar = [[SEWebTabbar alloc]init];
        _tabBar.hidden=YES;
        [_tabBar initWithProtocol:self];
    }
    return _tabBar;
}

#pragma mark -view Transition
- (BOOL)prefersStatusBarHidden{
    if (SE_IS_IPAD_DEVICE){
        return NO;
    }
    BOOL isLandscape = self.view.frame.size.width > self.view.frame.size.height;
    return isLandscape;
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    NSLog(@"willTransitionToTraitCollection: current %@, new: %@", [SEUtlity sizeClassInt2Str:self.traitCollection.horizontalSizeClass], [SEUtlity sizeClassInt2Str:newCollection.horizontalSizeClass]);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    NSLog(@"viewWillTransitionToSize,current %@", [SEUtlity sizeClassInt2Str:self.curHorizontalSizeClass]);
    self.view.frame = CGRectMake(0, 0, size.width, size.height);
    [self updateLayout];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSEViewWillTransitionNotification object:nil];
}

@end
