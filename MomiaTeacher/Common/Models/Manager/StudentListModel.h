//
//  StudentListModel.h
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/4.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "BaseModel.h"
#import "Student.h"

@protocol Student <NSObject>
@end

@interface StudentListModel : BaseModel
@property (nonatomic, strong) NSArray<Student> *data;
@end
