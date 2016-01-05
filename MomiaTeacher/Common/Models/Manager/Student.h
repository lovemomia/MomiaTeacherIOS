//
//  Student.h
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/25.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "BaseModel.h"

@interface Student : JSONModel

@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *age;
@property (nonatomic, strong) NSString<Optional> *sex;

@property (nonatomic, strong) NSNumber<Optional> *type;
@property (nonatomic, strong) NSNumber<Optional> *packageId;
@property (nonatomic, strong) NSNumber<Optional> *checkin;

@property (nonatomic, strong) NSNumber<Optional> *commented;

@end
