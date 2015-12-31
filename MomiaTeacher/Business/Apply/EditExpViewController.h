//
//  AddEduViewController.h
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/30.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "MOGroupStyleTableViewController.h"
#import "Experience.h"

@protocol EditExpDelegate <NSObject>

@optional
- (void)onExpAdded:(Experience *)exp;
- (void)onExpDeleted:(Experience *)exp;

@end

@interface EditExpViewController : MOGroupStyleTableViewController

@property (nonatomic, strong) Experience *model;
@property (nonatomic, strong) id<EditExpDelegate> delegate;

@end
