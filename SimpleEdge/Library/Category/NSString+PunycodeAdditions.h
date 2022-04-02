//
//  NSString+PunycodeAdditions.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import <Foundation/Foundation.h>


@interface NSString (PunycodeAdditions)

- (NSString *)punycodeEncodedString;
- (NSString *)punycodeDecodedString;

- (NSString *)IDNAEncodedString;
- (NSString *)IDNADecodedString;

// These methods currently expect self to start with a valid scheme.
- (NSString *)encodedURLString;
- (NSString *)decodedURLString;

@end

@interface NSURL (PunycodeAdditions)

+ (NSURL *)URLWithUnsafeString:(NSString *)URLString;// “`%^{}\"<>| \t”可能导致NSURL为nil.
+ (NSURL *)URLWithUnicodeString:(NSString *)URLString;
- (NSString *)decodedURLString;

@end
