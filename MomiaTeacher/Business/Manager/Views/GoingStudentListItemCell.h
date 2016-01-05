//
//  ChildListItemCell.h
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/25.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "MOTableCell.h"
#import "AvatarImageView.h"
#import "Student.h"

@protocol GoingStudentListItemCellDelegate <NSObject>

- (void)onOperateBtnClicked:(Student *)student;

@end

@interface GoingStudentListItemCell : MOTableCell<MOTableCellDataProtocol>

@property (nonatomic, assign) id<GoingStudentListItemCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet AvatarImageView *avatarIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexIv;
@property (weak, nonatomic) IBOutlet UIButton *operateBtn;

- (IBAction)onOperateBtnClicked:(id)sender;

@end
