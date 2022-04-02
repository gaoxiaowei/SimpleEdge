//
//  NSString+SEFileType.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSString (GLFileType)

- (BOOL)isPicture;
- (BOOL)isZip;
- (BOOL)isVideo;
- (BOOL)isMusic;
- (BOOL)isDoc;
- (BOOL)isTxt;
- (BOOL)isPDF;
- (BOOL)isCertification;
- (BOOL)isMobileConfig;

@end
