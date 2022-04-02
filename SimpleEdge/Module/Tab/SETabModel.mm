//
//  SETabModel.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/31.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SETabModel.h"
#import "SETabModel+WCTTableCoding.h"

@implementation SETabModel
WCDB_IMPLEMENTATION(SETabModel)
WCDB_SYNTHESIZE(SETabModel,title)
WCDB_SYNTHESIZE(SETabModel,url)
WCDB_SYNTHESIZE(SETabModel,selected)
WCDB_SYNTHESIZE(SETabModel,timeStamp)
WCDB_SYNTHESIZE(SETabModel,sortIndex)

WCDB_UNIQUE(SETabModel, timeStamp)
WCDB_PRIMARY(SETabModel,timeStamp)
@end
