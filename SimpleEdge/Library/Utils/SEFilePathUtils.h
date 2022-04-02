//
//  SEFilePathUtils.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SEFilePathUtils : NSObject

+ (NSString *)bundlePathForBundleName:(NSString *)bundleName;

#pragma mark - create dir
+ (NSString *)creatDirectoryIfNeeded:(NSString *)dirPath error:(NSError **)error;
+ (NSString *)creatDirectoryIfNeeded:(NSString *)dirPath;

#pragma mark - check exist
+ (BOOL)isFileExist:(NSString *)filePath;

#pragma mark - path
+ (NSString *)homePath;
+ (NSString *)documentPath:(NSString *)fileName;
+ (NSString *)libraryPath:(NSString *)fileName;
+ (NSString *)tempPath:(NSString *)fileName;
+ (NSString *)cachePath:(NSString *)filName;

+ (NSString *)relativePathForFilePath:(NSString *)filePath;
+ (NSString *)fullPathForRelativePath:(NSString *)relativePath;

#pragma mark - move
+ (BOOL)moveFileAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;

#pragma mark - copu
+ (void)copyResourceFromPath:(NSString *)path toPath:(NSString *)toPath;

#pragma mark - detele
+(BOOL)removeFile:(NSString*)filepath error:(NSError **)error;
+(BOOL)removeFile:(NSString*)filepath;
+(void)removeFiles:(NSArray<NSString *> *)filePaths;
+ (void)removeAllItemsAtPath:(NSString *)path;

#pragma mark - size of path
+ (int64_t)sizeOfFileAtPath:(NSString *)path;
+ (int64_t)sizeOfDirectoryPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
