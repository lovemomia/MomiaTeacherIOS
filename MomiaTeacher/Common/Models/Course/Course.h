//
//  Course.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"


@interface Course : JSONModel

@property (nonatomic, strong) NSNumber *courseId;
@property (nonatomic, strong) NSNumber *courseSkuId;
@property (nonatomic, strong) NSString *cover; //封面
@property (nonatomic, strong) NSString *title; //标题
@property (nonatomic, strong) NSString *scheduler;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *commented; //是否已经全部评价过, 只有在已上课接口中才可以反回

@end
