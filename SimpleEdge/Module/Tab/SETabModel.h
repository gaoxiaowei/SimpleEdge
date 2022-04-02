//
//  SETabModel.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/31.
//  Copyright © 2022 gaoxiaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SETabModel : NSObject
@property (nonatomic, assign) NSInteger      sortIndex;
@property (nonatomic, copy)   NSString       *title;
@property (nonatomic, assign) BOOL           selected;
@property (nonatomic, copy)   NSString       *url;
@property (nonatomic,assign)  int64_t        timeStamp;

@end

NS_ASSUME_NONNULL_END
