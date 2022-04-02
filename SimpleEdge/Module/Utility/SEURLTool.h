//
//  SEURLTool.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEURLTool : NSObject

+ (NSURL *)convertStringToURL:(NSString *)URLString;
+ (BOOL)isUrl:(NSString *)url;
+ (BOOL)isLocalErrorUrl:(NSURL*)url;
@end

