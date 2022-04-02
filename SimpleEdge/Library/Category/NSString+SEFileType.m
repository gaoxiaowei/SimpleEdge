//
//  NSString+SEFileType.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "NSString+SEFileType.h"

@implementation NSString (GLFileType)

- (BOOL)isPicture {
    NSString* str = [self lowercaseString];
    return ([str hasSuffix:@".jpg"] || [str hasSuffix:@".gif"] || [str hasSuffix:@".png"] || [str hasSuffix:@".jpeg"]);
}

- (BOOL)isZip {
    NSString* str = [self lowercaseString];
    return [str hasSuffix:@".zip"] || [str hasSuffix:@".rar"] /*|| [str hasSuffix:@".ipa"]*/;
}

- (BOOL)isVideo {
    NSString* str = [self lowercaseString];
    return [str hasSuffix:@".mov"] || [str hasSuffix:@".mp4"] || [str hasSuffix:@".mpv"] || [str hasSuffix:@".3gp"] || [str hasSuffix:@".m4v"];
}

- (BOOL)isMusic {
    NSString* str = [self lowercaseString];
    return [str hasSuffix:@".wav"] || [str hasSuffix:@".mp3"];
}

- (BOOL)isDoc {
    NSString* str = [self lowercaseString];
    return [str hasSuffix:@".txt"] || [str hasSuffix:@".xls"] || [str hasSuffix:@".xlsx"] || [str hasSuffix:@".rtf"] || [str hasSuffix:@".doc"] || [str hasSuffix:@".docx"];
}

- (BOOL)isTxt {
    NSString* str = [self lowercaseString];
    return [str hasSuffix:@".txt"];
}

- (BOOL)isPDF {
    NSString* str = [self lowercaseString];
    return [str hasSuffix:@".pdf"];
}

- (BOOL)isCertification {
    NSString* str = [self lowercaseString];
    return [str hasSuffix:@".cer"];
}

- (BOOL)isMobileConfig {
    NSString* str = [self lowercaseString];
    return [str hasSuffix:@".mobileconfig"];
}

@end
