//
//  NSString+URLEncoding.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import <Foundation/Foundation.h>
#import "NSString+PunycodeAdditions.h"


@interface NSString (Additions)

@property (nonatomic, readonly, getter=isDomain) BOOL domain;
@property (nonatomic, readonly, copy) NSString *URLDisplayString;
@property (nonatomic, readonly, copy) NSString *URLString;
@property (nonatomic, readonly, copy) NSURL *URL;
@property (nonatomic, readonly, copy) NSString *stringValue;

- (BOOL)isURL;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (BOOL)isNewsURL;
- (NSString *)newsURLString;
- (NSString *)newsOriginalURLString;

- (NSInteger)convertToInt; // 字符串字节数 汉字2 英文1

//base64
- (NSString *)getTextContentName;

@end

@interface NSObject (StringValue)

@property (nonatomic, readonly, copy) NSString *stringValue;

@end
