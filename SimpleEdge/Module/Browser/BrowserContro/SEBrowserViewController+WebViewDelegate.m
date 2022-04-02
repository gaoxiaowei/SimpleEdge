//
//  SEBrowserViewController+WebViewDelegate.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEBrowserViewController+WebViewDelegate.h"
#import "SEBrowserViewController+GLHandoff.h"
#import "SETabStorage.h"
#import "UIView+ScreenShot.h"
#import "SETabModel.h"
#import "SEUserAgent.h"

@implementation SEBrowserViewController (WebViewDelegate)

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //webView.customUserAgent =[UserAgent browserUserAgent];
    if (navigationAction.targetFrame == nil) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [webView loadRequest:navigationAction.request];
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self webView:webView failedLoadingWithError:error];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self handoffWebView:webView];
    [self addTabStore];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self webView:webView failedLoadingWithError:error];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSString *method = challenge.protectionSpace.authenticationMethod;
    if ([method isEqualToString:NSURLAuthenticationMethodDefault] ||
        [method isEqualToString:NSURLAuthenticationMethodHTTPBasic] ||
        [method isEqualToString:NSURLAuthenticationMethodHTTPDigest]) {
        [self showAuthenticationAlert:webView completionHandler:completionHandler];
    } else if ([method isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    SETab *tab = [[SETabManager shared] getSelectedTab];
    if (tab.webView == webView) {
        tab.consecutiveCrashes += 1;
        if (tab.consecutiveCrashes < 3) {
            [webView reload];
        } else {
            tab.consecutiveCrashes = 0;
        }
    }
}

- (void)webView:(WKWebView *)webView failedLoadingWithError:(NSError *)error {
    if (!error) {
        return;
    }
    if ([error.domain isEqual:@"WebKitErrorDomain"]) {
        return;
    }
    
    switch (error.code) {
        case -1002://unsupport request
            break;
        case 102:
        case 204:
        case kCFURLErrorCancelled:
            break;
        case NSURLErrorSecureConnectionFailed:
        case NSURLErrorServerCertificateHasBadDate:
        case NSURLErrorServerCertificateUntrusted:
        case NSURLErrorServerCertificateHasUnknownRoot:
        case NSURLErrorServerCertificateNotYetValid:
        case NSURLErrorClientCertificateRejected:
        case NSURLErrorClientCertificateRequired:{
            [self goToInvalidCertPage];
            break;
        }
        default: {
            SETab *tab = [[SETabManager shared] getSelectedTab];
            tab.unreachedUrl = [error.userInfo objectForKey:NSURLErrorFailingURLErrorKey];
            [self showFailedHTML];
            break;
        }
    }
}
#pragma mark - fail
- (void)goToInvalidCertPage{
    
}

- (void)showFailedHTML {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"error" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    SETab *tab = [[SETabManager shared] getSelectedTab];
    [tab.webView loadRequest:request];
}

#pragma mark - data store
- (void)addTabStore {
    [[SETabManager shared]updateSelectdTab];
}

#pragma mark-AuthenticationAlert
- (void)showAuthenticationAlert:(WKWebView *)webView
              completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"身份认证" message:webView.URL.host preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"用户名";
    }];
    [controller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"密码";
        textField.secureTextEntry = YES;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *userText = controller.textFields[0];
        UITextField *passText = controller.textFields[1];
        NSURLCredential *credential = [[NSURLCredential alloc] initWithUser:userText.text password:passText.text persistence:NSURLCredentialPersistenceForSession];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }];
    [controller addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
    }];
    [controller addAction:cancelAction];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

@end
