//
//  NSArray+SEUtils.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "NSArray+SEUtils.h"

@implementation NSArray (SEUtils)

- (id)instanceAtIndex:(NSUInteger )index{
    if (index < self.count) {
        id obj = [self objectAtIndex:index];
        return [obj isKindOfClass:[NSNull class]] ? nil : obj;
    }
    return nil;
}

@end
