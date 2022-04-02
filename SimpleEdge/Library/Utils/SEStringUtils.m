//
//  SEStringUtils.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "SEStringUtils.h"

@implementation SEStringUtils

+ (BOOL)stringIsNull:(NSString *)parameter{
    if ((NSNull *)parameter == [NSNull null]){
        return YES;
    }
    if (parameter == nil || [parameter length] == 0){
        return YES;
    }
    return NO;
}

+ (NSString *)durationToString:(NSInteger)duration{
    NSInteger seconds = duration % 60;
    NSInteger minutes = (duration / 60) % 60;
    NSInteger hours = duration / 3600;
    if(hours){
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hours, minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"%02ld:%02ld",minutes, seconds];
    }
}
@end
