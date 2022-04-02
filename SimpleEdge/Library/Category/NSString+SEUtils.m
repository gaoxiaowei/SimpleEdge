//
//  NSString+SEUtils.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "NSString+SEUtils.h"

@implementation NSString (SEUtils)

- (CGSize)sizeForHavingWidth:(CGFloat)width andFont:(UIFont *)font {
    CGRect frame = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil];
    return CGSizeMake(frame.size.width, frame.size.height + 1);
}

+ (NSString *)transformDataToGbkString:(NSData *)data {
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *gbkString = [[NSString alloc] initWithData:data encoding:gbkEncoding];
    return gbkString;
}

@end
