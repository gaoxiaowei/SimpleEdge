//
//  SEUserAgent.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEUserAgent.h"

static NSString *defaultApplicationNameForUserAgent();
static NSString *standardUserAgentWithApplicationName(NSString *applicationName, NSString *fullWebKitVersionString, UIUserInterfaceIdiom userInterfaceIdiom);

@implementation SEUserAgent

+ (NSString *)standardUserAgent {
    NSString *webKitBundleVersionString = [[NSBundle bundleForClass:[WKWebView class]] objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleVersionKey];
    return standardUserAgentWithApplicationName(defaultApplicationNameForUserAgent(), webKitBundleVersionString, UIUserInterfaceIdiomUnspecified);
}

+ (NSString *)standardUserAgent:(UIUserInterfaceIdiom)userInterfaceIdiom {
    NSString *webKitBundleVersionString = [[NSBundle bundleForClass:[WKWebView class]] objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleVersionKey];
    return standardUserAgentWithApplicationName(defaultApplicationNameForUserAgent(), webKitBundleVersionString, userInterfaceIdiom);
}

+ (NSString *)browserUserAgent {
    NSDictionary<NSString *, id> *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@ Safari/%@ SimpleEdge/%@", [self standardUserAgent], build, version];
}

+ (NSString *)browserUserAgent:(UIUserInterfaceIdiom)userInterfaceIdiom {
    NSDictionary<NSString *, id> *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@ Safari/%@ SimpleEdge/%@", [self standardUserAgent:userInterfaceIdiom], build, version];
}

@end

static NSString *systemMarketingVersionForUserAgentString(){
    // Use underscores instead of dots because when we first added the Mac OS X version to the user agent string
    // we were concerned about old DHTML libraries interpreting "4." as Netscape 4. That's no longer a concern for us
    // but we're sticking with the underscores for compatibility with the format used by older versions of Safari.
    return [[[UIDevice currentDevice] systemVersion] stringByReplacingOccurrencesOfString:@"." withString:@"_"];
}

static NSString *userVisibleWebKitBundleVersionFromFullVersion(NSString *fullWebKitVersion){
    // If the version is longer than 3 digits then the leading digits represent the version of the OS. Our user agent
    // string should not include the leading digits, so strip them off and report the rest as the version. <rdar://problem/4997547>
    NSRange nonDigitRange = [fullWebKitVersion rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    if (nonDigitRange.location == NSNotFound && fullWebKitVersion.length > 3)
        return [fullWebKitVersion substringFromIndex:fullWebKitVersion.length - 3];
    if (nonDigitRange.location != NSNotFound && nonDigitRange.location > 3)
        return [fullWebKitVersion substringFromIndex:nonDigitRange.location - 3];
    return fullWebKitVersion;
}

static NSString *userAgentBundleVersionFromFullVersionString(NSString *fullWebKitVersion){
    // We include at most three components of the bundle version in the user agent string.
    NSString *bundleVersion = userVisibleWebKitBundleVersionFromFullVersion(fullWebKitVersion);
    NSScanner *scanner = [NSScanner scannerWithString:bundleVersion];
    NSInteger periodCount = 0;
    while (true) {
        if (![scanner scanUpToString:@"." intoString:nullptr] || scanner.isAtEnd)
            return bundleVersion;
        
        if (++periodCount == 3)
            return [bundleVersion substringToIndex:scanner.scanLocation];
        
        ++scanner.scanLocation;
    }
}

static inline NSString *osNameForUserAgent(UIUserInterfaceIdiom userInterfaceIdiom){
    if (UIUserInterfaceIdiomUnspecified == userInterfaceIdiom) {
        userInterfaceIdiom = [UIDevice currentDevice].userInterfaceIdiom;
    }
    bool deviceHasIPadCapability = userInterfaceIdiom == UIUserInterfaceIdiomPad;
    if (deviceHasIPadCapability)
        return @"OS";
    return @"iPhone OS";
}

static inline NSString *deviceNameForUserAgent(UIUserInterfaceIdiom userInterfaceIdiom){
    NSString *name = [[UIDevice currentDevice] model];
    return name;
}

static NSString *standardUserAgentWithApplicationName(NSString *applicationName, NSString *fullWebKitVersionString, UIUserInterfaceIdiom userInterfaceIdiom){
    // FIXME: We should implement this with String and/or StringBuilder instead.
    NSString *webKitVersion = userAgentBundleVersionFromFullVersionString(fullWebKitVersionString);
    NSString *osMarketingVersionString = systemMarketingVersionForUserAgentString();
    if (0 == [applicationName length])
        return [NSString stringWithFormat:@"Mozilla/5.0 (%@; CPU %@ %@ like Mac OS X) AppleWebKit/%@ (KHTML, like Gecko)", deviceNameForUserAgent(userInterfaceIdiom), osNameForUserAgent(userInterfaceIdiom), osMarketingVersionString, webKitVersion];
    return [NSString stringWithFormat:@"Mozilla/5.0 (%@; CPU %@ %@ like Mac OS X) AppleWebKit/%@ (KHTML, like Gecko) %@", deviceNameForUserAgent(userInterfaceIdiom), osNameForUserAgent(userInterfaceIdiom), osMarketingVersionString, webKitVersion, applicationName];
}

static NSString *defaultApplicationNameForUserAgent()
{
#if TARGET_OS_IOS
    return [@"Mobile/" stringByAppendingString:[[UIDevice currentDevice] valueForKey:@"buildVersion"]];
#else
    return nil;
#endif
}
