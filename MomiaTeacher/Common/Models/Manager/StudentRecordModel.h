//
//  StudentRecordModel.h
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/5.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "BaseModel.h"
#import "Student.h"

@interface StudentRecordTag : JSONModel
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *selected;
@end

@protocol StudentRecordTag <NSObject>
@end

@interface StudentRecordData : JSONModel
@property (nonatomic, strong) Student *child;
@property (nonatomic, strong) NSArray<StudentRecordTag> *tags;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber<Optional> *selectAble;//是否可选，非服务器返回
@end

@interface StudentRecordModel : BaseModel
@property (nonatomic, strong) StudentRecordData *data;
@end
