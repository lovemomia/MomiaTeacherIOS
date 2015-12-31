//
//  CourseGoingModel.h
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/25.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "BaseModel.h"
#import "Course.h"
#import "Student.h"

@protocol Student <NSObject>
@end

@interface CourseGoingData : JSONModel

@property (nonatomic, strong) Course<Optional> *course;
@property (nonatomic, strong) NSArray<Student, Optional> *students;

@end

@interface CourseGoingModel : BaseModel
@property (nonatomic, strong) CourseGoingData *data;
@end
