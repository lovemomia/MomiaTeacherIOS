//
//  ApplyTeacherInputCell.h
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/29.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "MOTableCell.h"

@interface ApplyTeacherInputCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;


@end
