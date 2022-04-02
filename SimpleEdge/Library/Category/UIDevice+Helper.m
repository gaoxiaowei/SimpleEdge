//
//  UIDevice+Helper.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "UIDevice+Helper.h"
#include <mach/mach.h>
#include <sys/stat.h>
#include <dirent.h>

#define SAFTY_SPACE_BUFFER  300 * 1024 * 1024 //300M

@implementation UIDevice (Helper)

- (double)availableMemory {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    
    if(kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}

- (long long)totalDiskSpace {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    struct statfs tStats;
//    statfs([[paths lastObject] cString], &tStats);
//    float totalSpace = (float)(tStats.f_blocks * tStats.f_bsize);
//
//    return totalSpace;
    
    long long totalSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        totalSpace = [fileSystemSizeInBytes longLongValue];
    }
    return totalSpace;
}

-(long long) freeSpace {
    long long totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalFreeSpace = [freeFileSystemSizeInBytes longLongValue];
    }
    return totalFreeSpace;
}

- (long long)freeSpaceWithSafeBuffer {
    return ([self freeSpace] - SAFTY_SPACE_BUFFER);
}

-(double) applicationUseage {
    
    double directorySizeInBytes = 0.0f;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    
    NSString *pathStr = [paths objectAtIndex:0];
    
    pathStr = [pathStr stringByDeletingLastPathComponent];  //REMOVE THE LAST PATH COMPONENT i.e /Applications
    
    NSDirectoryEnumerator *enumrator = [[NSFileManager defaultManager] enumeratorAtPath:pathStr];
    
    
    for (__strong NSString *itemPath in enumrator) {
        
        itemPath = [pathStr stringByAppendingPathComponent:itemPath];
        
        NSDictionary *attr  =   [[NSFileManager defaultManager] attributesOfItemAtPath:itemPath error:nil];
        
        directorySizeInBytes = directorySizeInBytes + [[attr objectForKey:NSFileSize] doubleValue];
        
    }
    
    
    return directorySizeInBytes;
}

+ (long long) folderSizeAtPath:(NSString*) folderPath{
    return [self _folderSizeAtPath:[folderPath cStringUsingEncoding:NSUTF8StringEncoding]];
}

+ (long long) _folderSizeAtPath: (const char*)folderPath{
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent* child;
    while ((child = readdir(dir))!=NULL) {
        if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) || // 忽略目录 .
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) // 忽略目录 ..
                                        )) continue;
        
        NSInteger folderPathLength = strlen(folderPath);
        char childPath[1024]; // 子文件的路径地址
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath+folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR){ // directory
            folderSize += [self _folderSizeAtPath:childPath]; // 递归调用子目录
            // 把目录本身所占的空间也加上
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }else if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
    }
    return folderSize;
}

+ (BOOL)isJailBreak {
#if !(TARGET_IPHONE_SIMULATOR)
    FILE *f = NULL;
    if ((f = fopen("/bin/bash", "r")) ||
        (f = fopen("/Applications/Cydia.app", "r")) ||
        (f = fopen("/Library/MobileSubstrate/MobileSubstrate.dylib", "r")) ||
        (f = fopen("/usr/sbin/sshd", "r")) ||
        (f = fopen("/etc/apt", "r")))  {
        fclose(f);
        return YES;
    }
    fclose(f);

    NSError *error;
    NSString *stringToBeWritten = @"This is a test.";
    [stringToBeWritten writeToFile:@"/private/jailbreak.txt" atomically:YES encoding:NSUTF8StringEncoding error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:@"/private/jailbreak.txt" error:nil];
    if (error == nil) {
        return YES;
    }
#endif
    return NO;
}

@end
