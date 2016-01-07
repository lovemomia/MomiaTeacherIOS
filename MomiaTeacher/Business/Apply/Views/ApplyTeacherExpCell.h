//
//  ApplyTeacherExpCell.h
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/7.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "MOTableCell.h"

@interface ApplyTeacherExpCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *posLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
