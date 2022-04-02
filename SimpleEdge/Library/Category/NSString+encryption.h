//
//  NSString+encryption.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSString (encryption)

- (NSString *)gl_md5;
- (NSString *)gl_sha1;
- (NSString *)gl_sha1_base64;
- (NSString *)gl_md5_base64;
- (NSString *)gl_sha256;
- (NSString *)gl_hex;
- (NSString *)gl_urlEncoded;

//
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

@end
