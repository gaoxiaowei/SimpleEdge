//
//  UIDevice+Helper.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Helper)

/*
 * Available device memory in MB
 */
@property(readonly) double availableMemory;
@property(readonly) long long totalDiskSpace;
@property(readonly) long long freeSpace;
@property(readonly) double applicationUseage;
@property(readonly) long long freeSpaceWithSafeBuffer;

+ (long long)folderSizeAtPath:(NSString*) folderPath;

+(BOOL)isJailBreak;

@end

NS_ASSUME_NONNULL_END
