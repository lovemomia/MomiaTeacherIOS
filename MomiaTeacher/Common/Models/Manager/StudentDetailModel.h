//
//  StudentDetailModel.h
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/4.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "BaseModel.h"
#import "Student.h"

@interface StudentDetailComment : JSONModel
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *teacher;
@end

@protocol StudentDetailComment <NSObject>
@end

@interface StudentDetailCommentList : JSONModel
@property (nonatomic, strong) NSArray<StudentDetailComment> *list;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@property (nonatomic, strong) NSNumber *totalCount;
@end

@interface StudentDetailData : JSONModel
@property (nonatomic, strong) Student *child;
@property (nonatomic, strong) StudentDetailCommentList *comments;
@end

@interface StudentDetailModel : BaseModel
@property (nonatomic, strong) StudentDetailData *data;
@end
