//
//  NSData+NSData+SEUtils.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "NSData+SEUtils.h"

@implementation NSData (SEUtils)

- (BOOL)containChinese {
    char *contentPtr = (char *)[self bytes];
    int index = 0;
    while (index < self.length) {
        if (index + 1 < self.length) {
            unsigned char firstByte = *(contentPtr + index);
            unsigned char secondByte = *(contentPtr + index + 1);
            if (!(firstByte >= 129 && firstByte <= 254 && secondByte >= 64 && secondByte <= 254)) {
                return NO;
            }
            index += 2;
        }
    }
    return YES;
}

@end
