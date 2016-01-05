//
//  StudentListItemCell.h
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/4.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "MOTableCell.h"
#import "AvatarImageView.h"

@interface StudentListItemCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet AvatarImageView *avatarIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexIv;
@property (weak, nonatomic) IBOutlet UIImageView *statusIv;

@property (nonatomic, assign) BOOL showStatus;


@end
