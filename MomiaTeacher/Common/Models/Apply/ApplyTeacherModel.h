//
//  ApplyTeacherModel.h
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/28.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "BaseModel.h"
#import "Experience.h"
#import "Education.h"

@protocol Experience <NSObject>
@end

@protocol Education <NSObject>
@end

@interface ApplyTeacherData : JSONModel

@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString<Optional> *msg;

@property (nonatomic, strong) NSString<Optional> *pic;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *idNo;
@property (nonatomic, strong) NSString<Optional> *sex;
@property (nonatomic, strong) NSString<Optional> *birthday;
@property (nonatomic, strong) NSString<Optional> *address;

@property (nonatomic, strong) NSArray<Experience, Optional> *experiences;
@property (nonatomic, strong) NSArray<Education, Optional> *educations;

@end

@interface ApplyTeacherModel : BaseModel
@property (nonatomic, strong) ApplyTeacherData *data;
@end
