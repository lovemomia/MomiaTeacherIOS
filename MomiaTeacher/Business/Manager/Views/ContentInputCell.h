//
//  ContentInputCell.h
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/5.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "MOTableCell.h"

@interface ContentInputCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTv;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
