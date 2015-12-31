//
//  Experience.m
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/30.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "Experience.h"

@implementation Experience
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}
@end
