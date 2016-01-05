//
//  StudentDetailCommentCell.h
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/4.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "MOTableCell.h"

@interface StudentDetailCommentCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;


@end
