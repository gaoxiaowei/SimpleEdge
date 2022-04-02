//
//  UIColor+SEUtils.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "UIColor+SEUtils.h"

@implementation UIColor (SEUtils)

+ (UIColor *)colorForHex:(NSString *)hexColor
{
#if 1
    UIColor *ret = [UIColor redColor];
    int off = 0;
    NSInteger len = [hexColor length];
    if (len < 6)
        return (ret);
    if ([hexColor hasPrefix:@"#"])
    {
        off = 1;
        --len;
    }
    if ((len != 6) && (len != 8))   // 6 characters or 8 characters if include alpha
        return (ret);
    
    unsigned r, g, b, a = 0xff;
    [[NSScanner scannerWithString:[hexColor substringWithRange:NSMakeRange(off + 0, 2)]] scanHexInt:&r];
    [[NSScanner scannerWithString:[hexColor substringWithRange:NSMakeRange(off + 2, 2)]] scanHexInt:&g];
    [[NSScanner scannerWithString:[hexColor substringWithRange:NSMakeRange(off + 4, 2)]] scanHexInt:&b];
    if (len == 8)
    {
        [[NSScanner scannerWithString:[hexColor substringWithRange:NSMakeRange(off + 6, 2)]] scanHexInt:&a];
    }
    ret = [UIColor colorWithRed:((float)r/255.0) green:((float)g/255.0) blue:((float)b/255.0) alpha:((float)a/255.0)];
    return (ret);
#else
    // String should be 6 or 7 characters if it includes '#'
    if ([hexColor length]  < 6)
        return nil;
    
    // strip # if it appears
    if ([hexColor hasPrefix:@"#"])
        hexColor = [hexColor fxsafe_substringFromIndex:1];
    
    // if the value isn't 6 characters at this point return
    // the color black
    if ([hexColor length] != 6)
        return nil;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [hexColor substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [hexColor substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [hexColor substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
#endif
}


+ (UIColor *)randomColorWithImage{
    UIColor *color = nil;
    switch(arc4random() % 6){
        case 0: color = [UIColor colorForHex:@"fe5e53"];break;
        case 1: color = [UIColor colorForHex:@"fc6a98"];break;
        case 2: color = [UIColor colorForHex:@"ff8040"];break;
        case 3: color = [UIColor colorForHex:@"3cc24c"];break;
        case 4: color = [UIColor colorForHex:@"2CA7EA"];break;
        case 5: color = [UIColor colorForHex:@"5295fa"];break;
        default: break;
    }
    return color;
}

+ (UIColor *)colorWithString:(NSString *)name{
  return  [UIColor colorWithHextColorString:name alpha:1.0];
}

//支持rgb,argb
+ (UIColor *)colorWithHextColorString:(NSString *)hexColorString alpha:(CGFloat)alphaValue {
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    //排除掉  @\"
    if ([hexColorString hasPrefix:@"@\""]) {
        hexColorString = [hexColorString substringWithRange:NSMakeRange(2, hexColorString.length-3)];
    }
    
    //排除掉 #
    if ([hexColorString hasPrefix:@"#"]) {
        hexColorString = [hexColorString substringFromIndex:1];
    }
    
    if (nil != hexColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:hexColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    if ([hexColorString length]==8) {   //如果是8位，就那其中的alpha
        alphaValue = (float)(unsigned char)(colorCode>>24)/0xff;
    }
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:alphaValue];
    return result;
    
}

@end
