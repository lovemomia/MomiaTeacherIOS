//
//  MaterialListModel.m
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/6.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "MaterialListModel.h"

@implementation Material

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}

@end

@implementation MaterialListData

@end

@implementation MaterialListModel

@end
