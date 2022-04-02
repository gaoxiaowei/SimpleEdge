//
//  NSString+Encode.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "NSString+Encode.h"

@implementation NSString (Encode)
- (NSString *)encodeString {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"];
    NSString *ret = [self stringByAddingPercentEncodingWithAllowedCharacters:set];
    return ret;
}

@end
