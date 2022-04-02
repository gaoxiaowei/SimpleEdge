//
//  SETabManager.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/29.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SETabManager.h"
#import "SETabStorage.h"
#import "SETabModel.h"

@interface SETabManager ()
@property (nonatomic, strong) NSHashTable             *delegates;
@property (nonatomic, strong) NSMutableArray<SETab *> *tabs;

@end

@implementation SETabManager

+ (instancetype)shared {
    static SETabManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SETabManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _delegates = [NSHashTable weakObjectsHashTable];
        _tabs = [NSMutableArray array];
        _selectedIndex = 0;
    }
    return self;
}

#pragma mark-SETabManagerDelegate
- (void)addDelegate:(id <SETabManagerDelegate>)delegate {
    if(delegate!=nil){
        [self.delegates addObject:delegate];
    }
}

- (void)removeDelegate:(id <SETabManagerDelegate>)delegate {
    if(delegate!=nil){
        [self.delegates removeObject:delegate];
    }
    
}

#pragma mark -common api

- (void)restoreTabs {
    [[SETabStorage sharedStorage] getAllTabs:^(NSArray<SETabModel *> * _Nonnull allTabModels) {
        if(allTabModels.count ==0){
            [self addTabWithURLString:kSEHomeUrl];
            SETab *selectedTab =[self.tabs firstObject];
            [self selectTab:selectedTab];
        }else{
            SETab *selectedTab;
            for (NSInteger i = 0; i < allTabModels.count; i++) {
                SETabModel *tabModel = allTabModels[i];
                SETab *tab = [self addTabWithURLString:tabModel.url needCreatWeb:NO];
                tab.selected = tabModel.selected;
                tab.url = [NSURL URLWithString:tabModel.url];
                //tab.restoreUrl = tabModel.url;
                tab.title = tabModel.title;
                tab.timeStamp =tabModel.timeStamp;
                tab.sortIndex =tabModel.sortIndex;
                if (tabModel.selected) {
                    selectedTab = tab;
                }
            }
            
            [self selectTab:selectedTab];
        }
    }];
}

- (SETab *)addTabWithURLString:(NSString *)URLString {
    return [self addTabWithURLString:URLString needCreatWeb:YES];
}

- (SETab *)addTabWithURLString:(NSString *)URLString needCreatWeb:(BOOL)needCreatWeb {
    SEWebViewConfiguration *config = [self makeWebViewConfig];
    SETab *tab = [[SETab alloc] initWithConfiguration:config];
    tab.sortIndex =[[SETabManager shared]getLastTabSortIndex]+1;
    [self configTab:tab URLString:URLString needCreatWeb:needCreatWeb];
    return tab;
}

- (SEWebViewConfiguration *)makeWebViewConfig {
    SEWebViewConfiguration *config = [[SEWebViewConfiguration alloc] init];
    // Load the JavaScript code from the Resources and inject it into the web page
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JSTools" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:jsCode injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:userScript];
    return config;
}

- (void)configTab:(SETab *)tab URLString:(NSString *)URLString needCreatWeb:(BOOL)needCreatWeb {
    tab.url = [NSURL URLWithString:URLString];
    [self.tabs addObject:tab];
    
    for (id <SETabManagerDelegate>delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(tabManager:didAddTab:)]) {
            [delegate tabManager:self didAddTab:tab];
        }
    }
    
    if (needCreatWeb) {
        [tab creatWebView];
    }
}

- (void)removeAllTabs {
    [self.tabs removeAllObjects];
    [[SETabStorage sharedStorage]deleteAlltab:^(BOOL result) {
        
    }];
}

- (void)removeTabAndUpdateSelectedIndex:(SETab *)tab {
    NSInteger index = [self.tabs indexOfObject:tab];
    if(index<self.tabs.count){
        [self removeTab:tab atIndex:index];
        [self updateIndexAfterRemoveTab:tab deleteIndex:index];
    }
}

- (void)removeTab:(SETab *)tab atIndex:(NSInteger)index {
    if(index<self.tabs.count){
        [self.tabs removeObjectAtIndex:index];
        SETabModel* tabModel =[self generateTabModel:tab];
        [[SETabStorage sharedStorage]deleteTab:tabModel completion:^(BOOL result) {
            
        }];
        [tab destroyWebView];
        for (id <SETabManagerDelegate>delegate in self.delegates) {
            if ([delegate respondsToSelector:@selector(tabManager:didRemoveTab:)]) {
                [delegate tabManager:self didRemoveTab:tab];
            }
        }
    }
    
}
- (void)updateIndexAfterRemoveTab:(SETab *)tab deleteIndex:(NSInteger)deleteIndex {
    BOOL isEmpty = self.tabs.count == 0;
    if (isEmpty) {
        SETab *newTab = [self addTabWithURLString:kSEHomeUrl];
        [self selectTab:newTab];
    } else if (deleteIndex == self.selectedIndex) {
        BOOL isBeyond = self.selectedIndex >= self.tabs.count;
        NSInteger index = self.selectedIndex;
        index = isBeyond ? index - 1 : index;
        SETab *rltab = self.tabs[index];
        [self selectTab:rltab];
    } else if (deleteIndex < self.selectedIndex) {
        SETab *selected = self.tabs[self.selectedIndex - 1];
        [self selectTab:selected];
    }
}

- (void)changeTabIndex:(NSInteger)sourceIndex destinationIndex:(NSInteger)destinationIndex{
    if(sourceIndex<self.tabs.count && destinationIndex <self.tabs.count){
        SETab*sourceTab =self.tabs[sourceIndex];
        SETab*destinationTab =self.tabs[destinationIndex];
        //change index
        NSInteger tempIndex =sourceTab.sortIndex;
        sourceTab.sortIndex=destinationTab.sortIndex;
        destinationTab.sortIndex =tempIndex;
        //change selectedIndex
        if(sourceTab.selected){
            self.selectedIndex =destinationIndex;
        }
        
        [_tabs removeObject:sourceTab];
        [_tabs insertObject:sourceTab atIndex:destinationIndex];
        NSArray*tabs =@[[self generateTabModel:sourceTab],[self generateTabModel:destinationTab]];
        [[SETabStorage sharedStorage]saveTabs:tabs completion:^(BOOL result) {
            
        }];
    }
}

- (void)selectTab:(SETab *)tab {
    SETab*previousTab =[self getSelectedTab];
    if(previousTab!=nil){
        previousTab.selected =NO;
        [[SETabStorage sharedStorage]saveTabs:@[[self generateTabModel:previousTab]] completion:^(BOOL result) {
            
        }];
    }
    
    if (tab) {
        NSInteger index = [self.tabs indexOfObject:tab];
        self.selectedIndex = index ? index : 0;
    } else {
        self.selectedIndex = 0;
    }
    
    SETab *selectedTab = [self getSelectedTab];
    selectedTab.selected=YES;
    [selectedTab creatWebView];
    [[SETabStorage sharedStorage]saveTabs:@[[self generateTabModel:selectedTab]] completion:^(BOOL result) {
        
    }];
    
    for (id <SETabManagerDelegate>delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(tabManager:didSelectedTab:previous:)]) {
            [delegate tabManager:self didSelectedTab:selectedTab previous:previousTab];
        }
    }
}

- (NSArray *)getAllTab {
    NSArray *tabs = self.tabs;
    return tabs;
}

- (SETab *)getSelectedTab {
    NSInteger count = self.tabs.count;
    if (count == 0) return nil;
    if (self.selectedIndex >= count) return nil;
    SETab *tab = self.tabs[self.selectedIndex];
    return tab;
}

- (SETab *)tabAtIndex:(NSInteger)index {
    if (index >= self.tabs.count) return nil;
    SETab *tab = self.tabs[index];
    return tab;
}

- (SETab *)tabForWebView:(SEWebView *)webView {
    for (SETab *tab in self.tabs) {
        if (tab.webView == webView) {
            return tab;
        }
    }
    return nil;
}

-(NSInteger)getLastTabSortIndex{
    if(_tabs.count>0){
        return [_tabs lastObject].sortIndex;
    }
    return 0;
}

-(void)updateSelectdTab{
    SETab *tab = [self getSelectedTab];
    SETabModel*tabModel =[self generateTabModel:tab];
    [[SETabStorage sharedStorage]saveTabs:@[tabModel] completion:^(BOOL result) {
        
    }];
}

-(SETabModel*)generateTabModel:(SETab*)tab{
    if(tab){
        SETabModel*tabModel =[SETabModel new];
        tabModel.timeStamp =tab.timeStamp;
        tabModel.title =tab.title;
        tabModel.url=tab.url.absoluteString;
        tabModel.selected =tab.selected;
        tabModel.sortIndex =tab.sortIndex;
        return tabModel;
    }
    return nil;
}

@end
