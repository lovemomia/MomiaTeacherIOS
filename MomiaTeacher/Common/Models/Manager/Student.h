//
//  Student.h
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/25.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "BaseModel.h"

@interface Student : JSONModel

@property (nonatomic, assign) NSInteger *type;
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *packageId;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSNumber *checkedin;

@end
