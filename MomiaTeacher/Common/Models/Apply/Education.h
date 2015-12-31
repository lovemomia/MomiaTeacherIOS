//
//  Education.h
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/30.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "JSONModel.h"

@interface Education : JSONModel
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSString *major;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *time;
@end
