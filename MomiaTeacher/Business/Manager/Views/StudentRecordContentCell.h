//
//  StudentRecordContentCell.h
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/5.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "MOTableCell.h"

@interface StudentRecordContentCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
