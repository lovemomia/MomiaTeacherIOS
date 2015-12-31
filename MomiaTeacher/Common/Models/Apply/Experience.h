//
//  Experience.h
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/30.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "JSONModel.h"

@interface Experience : JSONModel
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSString *post;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *content;
@end
