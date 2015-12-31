//
//  EditExpContentInputCell.h
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/30.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "MOTableCell.h"

@interface EditExpContentInputCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UITextView *contentTv;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end
