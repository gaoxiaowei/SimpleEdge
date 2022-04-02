//
//  SETabModel+WCTTableCoding.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/31.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import "SETabModel.h"
#import <WCDB/WCDB.h>


NS_ASSUME_NONNULL_BEGIN

@interface SETabModel (WCTTableCoding) <WCTTableCoding>
WCDB_PROPERTY(title)
WCDB_PROPERTY(url)
WCDB_PROPERTY(selected)
WCDB_PROPERTY(timeStamp)
WCDB_PROPERTY(sortIndex)
@end

NS_ASSUME_NONNULL_END
