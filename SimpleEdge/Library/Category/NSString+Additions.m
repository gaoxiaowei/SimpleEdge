//
//  NSString+Additions.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "NSString+Additions.h"

static NSString * prefixString(NSString *string, NSString *separator, NSString *defaultString, NSString **suffixString) {
    NSRange range = [string rangeOfString:separator];
    if (range.location == NSNotFound) {
        *suffixString = [string copy];
        return defaultString;
    }
    *suffixString = [string substringFromIndex:range.location + range.length];
    return [string substringToIndex:range.location];
}

static NSString * suffixString(NSString *string, NSString *separator, NSString *defaultString, NSString **prefixString) {
    NSRange range = [string rangeOfString:separator];
    if (range.location == NSNotFound) {
        *prefixString = [string copy];
        return defaultString;
    }
    *prefixString = [string substringToIndex:range.location];
    return [string substringFromIndex:range.location + range.length];
}

static BOOL checkIPAddress(NSString *host) {
    static NSRegularExpression *expr;
    if (!expr) {
        expr = [NSRegularExpression regularExpressionWithPattern:@"(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[0-9][0-9]|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[0-9][0-9]|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[0-9][0-9]|[1-9])" options:NSRegularExpressionCaseInsensitive error:nil];
    }
    NSRange range = [expr rangeOfFirstMatchInString:host options:0 range:NSMakeRange(0, host.length)];
    return (range.location != NSNotFound);
}

@implementation NSString (Additions)

- (NSInteger)convertToInt{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self dataUsingEncoding:enc];
    return [da length];
}

-(NSString *)URLEncodedString
{
    return [[self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_.-"]] stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
}

-(NSString *)URLDecodedString
{
    return [[self stringByReplacingOccurrencesOfString:@"+" withString:@"%20"] stringByRemovingPercentEncoding];
}

- (BOOL)isURL {
    NSString *url, *domain;
    NSString *scheme = prefixString(self, @"://", nil, &url);

    if (scheme && ![scheme isScheme]) {
        return NO; // scheme不正确的认为不是URL
    }
    suffixString(url, @"/", nil, &domain);
    if (0 == domain.length) {
        return NO; // 没有域名认为不是URL
    }
    prefixString(domain, @"@", nil, &domain);
    NSString *port = suffixString(domain, @":", nil, &domain);
    if (port) {
        NSScanner *scan = [NSScanner scannerWithString:port];
        if (!([scan scanInt:nil] && [scan isAtEnd])) {
            return NO; // 端口号非数字认为不是URL
        }
    }
    return [domain isDomain] || checkIPAddress(domain); // 域名不符合要求认为不是URL
}

- (NSString *)URLDisplayString {
    // 把URL中punycode编码的英文域名转换成中文域名，其它部分不变，主要用于界面显示，转换前与转换后含义保持完全相等。
    NSString *url, *domain;
    NSString *protocol = prefixString(self, @"://", @"http", &url);
    NSString *path = suffixString(url, @"/", @"", &domain);
    if (0 == domain.length) {
        return self; // 没有域名认为不是URL
    }
    NSString *userName = prefixString(domain, @"@", nil, &domain);
    NSString *port = suffixString(domain, @":", nil, &domain);
    if (port) {
        NSScanner *scan = [NSScanner scannerWithString:port];
        if (!([scan scanInt:nil] && [scan isAtEnd])) {
            return self; // 端口号非数字认为不是URL
        }
    }
    if ([domain isDomain] || checkIPAddress(domain)) { // 域名不符合要求认为不是URL
        domain = [domain IDNADecodedString];
    } else {
        return self;
    }
    if (userName) {
        domain = [NSString stringWithFormat:@"%@@%@", userName, domain];
    }
    if (port) {
        domain = [NSString stringWithFormat:@"%@:%@", domain, port];
    }
    if (path.length) {
        domain = [NSString stringWithFormat:@"%@://%@/%@", protocol, domain, path];
    } else if ([protocol caseInsensitiveCompare:@"http"] != NSOrderedSame) {
        domain = [NSString stringWithFormat:@"%@://%@", protocol, domain];
    }
    return domain;
}

- (NSString *)URLString {
    // 把一个包含中文的正确URL转换成英文URL，支持中文域名。
    NSString *url, *domain;
    NSString *fragment = suffixString(self, @"#", nil, &url);
    NSString *protocol = prefixString(url, @"://", @"http", &url);
    NSString *path = suffixString(url, @"/", @"", &domain);
    if (0 == domain.length) {
        return nil;
    }
    NSString *userName = prefixString(domain, @"@", nil, &domain);
    NSString *port = suffixString(domain, @":", nil, &domain);
    if (port) {
        NSScanner *scan = [NSScanner scannerWithString:port];
        if (!([scan scanInt:nil] && [scan isAtEnd])) {
            return nil;
        }
    }
    if ([domain isDomain] || checkIPAddress(domain)) {
        domain = [domain IDNAEncodedString];
    } else {
        return nil;
    }
    NSString *password;
    if (userName) {
        password = suffixString(userName, @":", nil, &userName);
    }
    NSString *query = suffixString(path, @"?", @"", &path);
    
    if (userName) {
        if (password) {
            userName = [NSString stringWithFormat:@"%@:%@", userName, password];
        }
        domain = [NSString stringWithFormat:@"%@@%@", userName, domain];
    }
    if (port) {
        domain = [NSString stringWithFormat:@"%@:%@", domain, port];
    }
    if (query.length) {
        path = [NSString stringWithFormat:@"%@?%@", path, query];
    }
    if (fragment) {
        path = [NSString stringWithFormat:@"%@#%@", path, fragment];
    }
    // 原计划对URL的各个部分都执行一次URLEncode防止特殊字符出现，但如此一来相当于对URL做了一次URLEncode转换处理，会导致破坏程序的前后逻辑，因此仅将不可见字符和中文字符做处理，防止NSURL对象不识别字符串的情况出现。
    return [[NSString stringWithFormat:@"%@://%@/%@", protocol, domain, path]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithRange:NSMakeRange(32, 95)]];
}

- (NSURL *)URL {
    NSString *url = self.URLString;
    if (url) {
        return [NSURL URLWithString:url];
    }
    return nil;
}

// 判断字符串是否为域名，支持中日韩文字，字符集判断截止至扩展E区(Unicode 8.0)
- (BOOL)isDomain {
    if (self.length > 256) return NO; // 超过256字符认为不是域名
    static NSMutableCharacterSet *characters;
    if (!characters) {
        characters = [[NSMutableCharacterSet alloc] init];
        [characters addCharactersInRange:NSMakeRange('0', 10)];
        [characters addCharactersInRange:NSMakeRange('A', 26)];
        [characters addCharactersInRange:NSMakeRange('a', 26)];
        [characters addCharactersInRange:NSMakeRange('-', 2)];
        [characters addCharactersInRange:NSMakeRange(0x4E00, 0x51D6)];// UNICODE1.0,4.1,5.1,8.0急用汉字
        [characters addCharactersInRange:NSMakeRange(0x3400, 0x19B6)];// 扩展A区
        [characters addCharactersInRange:NSMakeRange(0x20000, 0xA6D7)];// 扩展B区
        [characters addCharactersInRange:NSMakeRange(0x2F800, 0x21E)];// 扩展B区的台湾兼容汉字
        [characters addCharactersInRange:NSMakeRange(0x2A700, 0x1035)];// 扩展C区
        [characters addCharactersInRange:NSMakeRange(0x2B740, 0x17BB)];// 扩展D区，扩展E区
    }
    NSUInteger dot = 0, location = 0;
    for (NSUInteger i = 0, count = self.length; i < count; ++i) {
        unichar character = [self characterAtIndex:i];
        if (![characters longCharacterIsMember:character]) {
            return NO; // 包含非法字符认为不是域名
        }
        if (character == L'.') {
            ++dot;
            location = i;
        }
    }
    if (0 == dot) {
        return NO; // 没有点的不是域名
    }
    return YES;
}

- (BOOL)isScheme {
    // scheme必须以字母开头，包含字母、数字、加号、减号、点。
    if ([self length] == 0) {
        return YES;
    }
    if (![[NSCharacterSet alphanumericCharacterSet] characterIsMember:[self characterAtIndex:0]]) {
        return NO;
    }
    NSMutableCharacterSet *schemeCharacters = [NSMutableCharacterSet alphanumericCharacterSet];
    [schemeCharacters formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    [schemeCharacters addCharactersInString:@"+-."];
    for (NSUInteger i = 1, count = [self length]; i < count; ++i) {
        if (![schemeCharacters characterIsMember:[self characterAtIndex:i]]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isNewsURL {
    NSURL *URL = [NSURL URLWithString:self];
    NSString *scheme = URL.scheme;
    if (scheme) {
        if (NSOrderedSame == [scheme compare:@"news" options:NSCaseInsensitiveSearch] ||
            NSOrderedSame == [scheme compare:@"newshttp" options:NSCaseInsensitiveSearch] ||
            NSOrderedSame == [scheme compare:@"newshttps" options:NSCaseInsensitiveSearch]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)newsURLString {
    if ([self isNewsURL]) {
        return self;
    } else {
        NSURL *URL = [NSURL URLWithString:self];
        NSString *scheme = URL.scheme;
        if (scheme) {
            if (NSOrderedSame == [scheme compare:@"http" options:NSCaseInsensitiveSearch] ||
                NSOrderedSame == [scheme compare:@"https" options:NSCaseInsensitiveSearch]) {
                return [NSString stringWithFormat:@"news%@", URL.absoluteString];
            }
        }
        return [NSString stringWithFormat:@"news:%@", URL.absoluteString];
    }
}

- (NSString *)newsOriginalURLString {
    if ([self isNewsURL]) {
        NSURL *URL = [NSURL URLWithString:self];
        NSString *scheme = URL.scheme;
        if (scheme) {
            if (NSOrderedSame == [scheme compare:@"news" options:NSCaseInsensitiveSearch]) {
                return URL.resourceSpecifier;
            } else if (NSOrderedSame == [scheme compare:@"newshttp" options:NSCaseInsensitiveSearch]) {
                return [NSString stringWithFormat:@"http:%@", URL.resourceSpecifier];
            } else if (NSOrderedSame == [scheme compare:@"newshttps" options:NSCaseInsensitiveSearch]) {
                return [NSString stringWithFormat:@"https:%@", URL.resourceSpecifier];
            }
        }
    }
    return self;
}

- (NSString *)stringValue {
    return [self copy];
}

//base64
- (NSString *)getTextContentName{
    NSData *data1 = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSString *text =  [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    return text;
}


@end

@implementation NSObject (StringValue)

- (NSString *)stringValue {
    return [NSString stringWithFormat:@"%@", self];
}

@end
