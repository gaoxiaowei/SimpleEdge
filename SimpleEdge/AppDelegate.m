//
//  AppDelegate.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "AppDelegate.h"
#import "SEBrowserViewController.h"
#import "SENavigationController.h"
#import "SETabStorage.h"
#import "SEUserAgent.h"

@interface AppDelegate ()
@property(nonatomic,strong) SEBrowserViewController    *rootVC;
@end

@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[SETabStorage sharedStorage]initDB];
    [self setDefaultUserAgent];
    [self setRootVC];
    application.applicationSupportsShakeToEdit = YES;
    [application ignoreSnapshotOnNextApplicationLaunch];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


#pragma mark - VC
- (void)setRootVC {
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kSE_ScreenWidth, kSE_ScreenHeight)];
    SEBrowserViewController *browserVC = [[SEBrowserViewController alloc] init];
    self.rootVC = browserVC;
    SENavigationController *navi = [[SENavigationController alloc] initWithRootViewController:browserVC];
    
    self.window.rootViewController = navi;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (UINavigationController *)getCurrentNavigationController{
    return  [self.rootVC navigationController];
}

- (UIViewController *)getRootVC {
    return self.rootVC;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application
  supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    SENavigationController *nav = (SENavigationController*)self.rootVC.navigationController;
    if (nav.presentedViewController) {
        return nav.presentedViewController.supportedInterfaceOrientations;
    } else {
        return nav.supportedInterfaceOrientations;
    }
}

-(void)setDefaultUserAgent{
    NSString *defaultUserAgent = [SEUserAgent browserUserAgent];
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:defaultUserAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}
@end
