//
//  MaterialListModel.h
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/6.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "BaseModel.h"

@interface Material : JSONModel
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subject;
@end

@protocol Material <NSObject>
@end

@interface MaterialListData : JSONModel
@property (nonatomic, strong) NSNumber *totalCount;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@property (nonatomic, strong) NSArray<Material> *list;
@end

@interface MaterialListModel : BaseModel
@property (nonatomic, strong) MaterialListData *data;
@end
