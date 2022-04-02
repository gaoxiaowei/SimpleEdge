//
//  SEUserAgent.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/30.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEUserAgent : NSObject

+ (NSString *)browserUserAgent;
+ (NSString *)browserUserAgent:(UIUserInterfaceIdiom)userInterfaceIdiom;
+ (NSString *)standardUserAgent;

@end
