//
//  EditEduViewController.h
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/30.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "MOGroupStyleTableViewController.h"
#import "Education.h"

@protocol EditEduDelegate <NSObject>

@optional
- (void)onEduAdded:(Education *)edu;
- (void)onEduDeleted:(Education *)edu;
@end

@interface EditEduViewController : MOGroupStyleTableViewController

@property (nonatomic, strong) Education *model;
@property (nonatomic, strong) id<EditEduDelegate> delegate;

@end
