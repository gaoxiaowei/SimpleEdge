//
//  SEURLTool.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SEURLTool.h"
#import "NSString+Additions.h"

@implementation SEURLTool
+ (NSURL *)convertStringToURL:(NSString *)URLString {
    URLString = [URLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (URLString.length) {
        NSURL *url = [NSURL URLWithUnicodeString:URLString];
        NSString *scheme = [url.scheme lowercaseString];
        if (url && [self isUrl:URLString] &&([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
            [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame)) {
            return [NSURL URLWithUnicodeString:URLString];
        } else {
            NSString*searchUrl =[NSString stringWithFormat:@"%@?q=%@",kSESearchEngineUrl,[URLString URLEncodedString]];
            return [NSURL URLWithUnicodeString:searchUrl];
        }
    }
    return nil;
}

+ (BOOL)isUrl:(NSString*)urlString {
    if (!urlString) {
        return NO;
    }
    if (![urlString isURL]) {
        return NO;
    }
    NSURL *URL = [NSURL URLWithUnicodeString:urlString];
    if (!URL) {
        return NO;
    }
    return YES;
#if 0
    if (nil != urlString) {
        NSMutableString *newUrlString = [[urlString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t\n\r"]] mutableCopy];
        [newUrlString replaceOccurrencesOfString:@"。" withString:@"." options:0 range:NSMakeRange(0, newUrlString.length)];
        NSRange schemeRange = [newUrlString rangeOfString:@"://"];
        if (schemeRange.location != NSNotFound) {
            [newUrlString deleteCharactersInRange:NSMakeRange(0, schemeRange.location + schemeRange.length)];
        } else {
            NSUInteger lengthOfCmdScheme = 0;
            if ([newUrlString hasPrefix:@"tel:"]) {
                lengthOfCmdScheme = 4;
            } else if ([newUrlString hasPrefix:@"facetime:"]) {
                lengthOfCmdScheme = 9;
            }
            if (lengthOfCmdScheme > 0) {
                return [self isHttpStringValidate:[newUrlString fxsafe_substringFromIndex:lengthOfCmdScheme]];
            }
        }
        return [self isHttpStringValidate:newUrlString];
    }
    return NO;
#endif
}

+ (BOOL)isHttpStringValidate:(NSString *)urlString {
    NSRange hostRange = [urlString rangeOfString:@"/"];
    if (hostRange.location == NSNotFound) {
        hostRange = [urlString rangeOfString:@"?"];
        if (hostRange.location == NSNotFound) {
            return [self isHostValidated:urlString];
        }
    }
    return [self isHostValidated:[urlString substringToIndex:hostRange.location]];
}

+ (BOOL)isHostValidated:(NSString *)host {
    BOOL ret = NO;
    NSString *rootHost = host;
    if (rootHost) {
        if ([rootHost.lowercaseString isEqualToString:kSEHomeUrl]) {
            ret = YES;
        } else {
            return [host isURL];
        }
    }
    return ret;
}

+ (BOOL)isLocalErrorUrl:(NSURL*)url{
    if([url isKindOfClass:[NSURL class]]){
        NSString *urlString =url.absoluteString;
        if(([urlString hasPrefix:@"file:///private/var/"] || [urlString hasPrefix:@"file:///Users/"]) &&[urlString hasSuffix:@"/error.html"]){
            return YES;
        }
    }
    return NO;
}
@end
