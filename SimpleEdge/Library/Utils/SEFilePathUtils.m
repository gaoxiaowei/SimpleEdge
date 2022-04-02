//
//  SEFilePathUtils.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "SEFilePathUtils.h"

@implementation SEFilePathUtils

+ (NSString *)bundlePathForBundleName:(NSString *)bundleName {
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:bundleName ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return [bundle resourcePath];
}


+ (NSString *)creatDirectoryIfNeeded:(NSString *)dirPath{
    return [self creatDirectoryIfNeeded:dirPath error:nil];
}

+ (NSString *)creatDirectoryIfNeeded:(NSString *)dirPath error:(NSError **)error{
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:error];
    }
    return dirPath;
}

+ (NSString *)homePath {
    return NSHomeDirectory();
}

+ (NSString *)documentPath:(NSString *)fileName
{
    return [self searchPath:NSDocumentDirectory fileName:fileName];
}

+ (NSString *)libraryPath:(NSString *)fileName
{
    return [self searchPath:NSLibraryDirectory fileName:fileName];
}

+ (NSString *)cachePath:(NSString *)filName{
    return [self searchPath:NSCachesDirectory fileName:filName];
}

+ (NSString *)relativePathForFilePath:(NSString *)filePath {
    NSRange homePathRange = [filePath rangeOfString:[self homePath]];
    if (homePathRange.location != NSNotFound) {
        return [filePath substringFromIndex:NSMaxRange(homePathRange)];
    }
    return filePath;
}

+ (NSString *)fullPathForRelativePath:(NSString *)relativePath {
    for (NSString *prefix in [self validRelativePathPrefix]) {
        if ([relativePath hasPrefix:prefix]) {
            return [NSString stringWithFormat:@"%@%@", [self homePath], relativePath];
        }
    }
    return relativePath;
}

+ (NSArray *)validRelativePathPrefix {
    return @[@"/Library/", @"/Documents/", @"/tmp/"];
}

+ (NSString *)searchPath:(NSSearchPathDirectory)directory fileName:(NSString *)fileName{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    NSString *doc = [documentPaths objectAtIndex:0];
    return [doc stringByAppendingPathComponent:fileName];
}

+ (BOOL)isFileExist:(NSString *)filePath{
    if(filePath == nil) {
        return NO;
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (NSString *)tempPath:(NSString *)fileName{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
}

+ (void)copyResourceFromPath:(NSString *)path toPath:(NSString *)toPath{
    if(![self isFileExist:path]){
        return;
    }
    
    if([self isFileExist:toPath]){
        [self removeFile:toPath];
    }
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath error:&error];
}

+ (int64_t)sizeOfFileAtPath:(NSString *)path {
    NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    unsigned long long int fileSize = [fileDictionary fileSize];

    return fileSize;
}

+ (int64_t)sizeOfDirectoryPath:(NSString *)path {
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;

    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[path stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }

    return fileSize;
}

+ (BOOL)removeFile:(NSString*)filepath{
    return [self removeFile:filepath error:nil];
}

+ (BOOL)removeFile:(NSString*)filepath error:(NSError **)error{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    return [fileMgr removeItemAtPath:filepath error:error];
}

+(void)removeFiles:(NSArray<NSString *> *)filePaths{
    [filePaths enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeFile:obj];
    }];
}

+ (void)removeAllItemsAtPath:(NSString *)path{
    [self removeAllItemsAtPath:path error:nil];
}

+ (void)removeAllItemsAtPath:(NSString *)path error:(NSError **)error{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if ([filemanager fileExistsAtPath:path isDirectory:&isDirectory]) {
        
        NSArray *fileItems = [filemanager contentsOfDirectoryAtPath:path error:error];
        
        if (!fileItems || fileItems.count == 0) {
            [self removeFile:path];
            return;
        }
        
        NSEnumerator *enumerator = [fileItems objectEnumerator];
        NSString *fileName;
        while (fileName = [enumerator nextObject]) {
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            [self removeAllItemsAtPath:filePath error:error];
        }
        
        fileItems = [filemanager contentsOfDirectoryAtPath:path error:error];
        if (!fileItems || fileItems.count == 0) {
            [self removeFile:path error:error];
            return;
        }
    }
}

+ (BOOL)moveFileAtPath:(NSString *)srcPath toPath:(NSString *)dstPath{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL isMove = [fileMgr moveItemAtPath:srcPath toPath:dstPath error:nil];
    return isMove;
}

+ (void)copyFilesFromPath:(NSString *)sourcePath toPath:(NSString *)toPath forceCopy:(BOOL)forceCopy {
    [self copyFilesFromPath:sourcePath toPath:toPath forceCopy:forceCopy error:nil];
}

+ (void)copyFilesFromPath:(NSString *)sourcePath toPath:(NSString *)toPath forceCopy:(BOOL)forceCopy error:(NSError **)error{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSourceFileisFolder = NO;
    
    [fileManager fileExistsAtPath:sourcePath isDirectory:&isSourceFileisFolder];
    if (isSourceFileisFolder) {
        NSArray* contentsArray = [fileManager contentsOfDirectoryAtPath:sourcePath error:error];
        for (int i = 0; i < contentsArray.count; i++) {
            NSString *fromFullPath = [sourcePath stringByAppendingPathComponent:contentsArray[i]];
            NSString *toFullPath = [toPath stringByAppendingPathComponent:contentsArray[i]];
            BOOL isFolder = NO;
            BOOL isExist = [fileManager fileExistsAtPath:fromFullPath isDirectory:&isFolder];
            if (isExist) {
                if (forceCopy) {
                    if (isFolder) {
                        [self removeAllItemsAtPath:toFullPath error:error];
                    }else {
                        [fileManager removeItemAtPath:toFullPath error:error];
                    }
                }
                [self copyFilesFromPath:fromFullPath toPath:toFullPath forceCopy:forceCopy error:forceCopy?error:nil];
            }
        }
    } else {
        if (forceCopy && [self isFileExist:toPath]) {
            [fileManager removeItemAtPath:toPath error:error];
        }
        [self creatDirectoryIfNeeded:[toPath stringByDeletingLastPathComponent] error:error];
        [fileManager copyItemAtPath:sourcePath toPath:toPath error:forceCopy?error:nil];
        return;
    }
}

@end
