//
//  NSDictionary+SEUtils.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "NSDictionary+SEUtils.h"

@implementation NSDictionary (SEUtils)
- (id)instanceForKey:(id)key{
    id value = [self objectForKey:key];
    if ([value respondsToSelector:@selector(stringValue)]) {
        return [value stringValue];
    }else{
        return [value isKindOfClass:[NSNull class]] ? nil : value;
    }
}

@end
