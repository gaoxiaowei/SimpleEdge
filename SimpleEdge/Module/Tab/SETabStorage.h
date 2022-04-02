//
//  SETabStorage.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/31.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SETabModel;

@interface SETabStorage : NSObject

+ (instancetype)sharedStorage;

-(void)initDB;

- (void)saveTabs:(NSArray<SETabModel*> *)tabModels completion:(void(^)(BOOL result))completion;
- (void)deleteTab:(SETabModel *)tabModel completion:(void(^)(BOOL result))completion;
- (void)getAllTabs:(void (^)(NSArray <SETabModel *> *allTabModels))completion;
- (void)deleteAlltab:(void(^)(BOOL result))completion;

@end

NS_ASSUME_NONNULL_END
