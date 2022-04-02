//
//  SETabStorage.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/31.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SETabStorage.h"
#import "SETabModel.h"
#import "SETabModel+WCTTableCoding.h"
#import "SEFilePathUtils.h"

NSString * const kTabsDBName               = @"Tabs.db";
NSString * const kTabsTableName            = @"Tabs_table";

#define SETABLE_DICT    @{kTabsTableName:@"SETabModel"}

@interface SETabStorage()
@property (nonatomic, strong) WCTDatabase      *database;
@property (nonatomic, strong) dispatch_queue_t dbQueue;
@end

@implementation SETabStorage

+ (instancetype)sharedStorage{
    static SETabStorage *inst;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[SETabStorage alloc]init];
        [inst _init];
    });
    return inst;
}

-(void)_init{
    const char *queue_specific_key = [[self queueSpecificKey] cStringUsingEncoding:NSUTF8StringEncoding];
    _dbQueue = dispatch_queue_create([[self queuelabel] UTF8String], DISPATCH_QUEUE_SERIAL);
    dispatch_queue_set_specific(_dbQueue, queue_specific_key, (void *)queue_specific_key, NULL);
    
}

-(void)initDB{
    NSString*dbPath=[self createDBIfNeeded:kTabsDBName];
    _database = [[WCTDatabase alloc] initWithPath:dbPath];
    dispatch_async(self.dbQueue, ^{
        [SETABLE_DICT enumerateKeysAndObjectsUsingBlock:^(NSString *tableName, NSString *className, BOOL * _Nonnull stop) {
            BOOL result = [self.database createTableAndIndexesOfName:tableName withClass:NSClassFromString(className)];
            NSLog(@"createTableAndIndexesOfName tableName:%@,result:%@",tableName,@(result));
        }];
    });
}

-(NSString*)createDBIfNeeded:(NSString*)dbName{
    NSString *dbDirPath = [SEFilePathUtils documentPath:@"DataBase"];
    [SEFilePathUtils creatDirectoryIfNeeded:dbDirPath];
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", dbDirPath,dbName];
    return dbPath;
}

- (NSString *)queuelabel{
    return @"tabs_db_queue";
}

- (NSString *)queueSpecificKey{
    return @"tabs_db_queue_specific";
}

- (void)saveTabs:(NSArray<SETabModel*> *)tabModels completion:(void(^)(BOOL result))completion{
    if(tabModels.count<=0){
        completion(NO);
        return;
    }
    dispatch_async(self.dbQueue, ^{
        [self.database runTransaction:^BOOL{
            BOOL result = [self.database insertOrReplaceObjects:tabModels into:kTabsTableName];
            SAFE_BLOCK_IN_MAIN_QUEUE(completion,result);
            return result;
        }];
    });
}

- (void)deleteTab:(SETabModel *)tabModel completion:(void(^)(BOOL result))completion{
    if(!tabModel){
        completion(NO);
        return;
    }
    dispatch_async(self.dbQueue, ^{
        [self.database runTransaction:^BOOL{
            BOOL result =[self.database deleteObjectsFromTable:kTabsTableName where:SETabModel.timeStamp ==tabModel.timeStamp];
            SAFE_BLOCK_IN_MAIN_QUEUE(completion,result);
            return result;
        }];
    });
}

- (void)getAllTabs:(void (^)(NSArray <SETabModel *> *allTabModels))completion{
    dispatch_async(self.dbQueue, ^{
        NSArray<SETabModel*>*array=[self.database getObjectsOfClass:SETabModel.class fromTable:kTabsTableName orderBy:SETabModel.sortIndex.order(WCTOrderedAscending)];
        SAFE_BLOCK_IN_MAIN_QUEUE(completion,array);
        
    });
}

- (void)deleteAlltab:(void(^)(BOOL result))completion{
    dispatch_async(self.dbQueue, ^{
        [self.database runTransaction:^BOOL{
            BOOL result =[self.database deleteAllObjectsFromTable:kTabsTableName];
            SAFE_BLOCK_IN_MAIN_QUEUE(completion,result);
            return result;
        }];
    });
}
@end
