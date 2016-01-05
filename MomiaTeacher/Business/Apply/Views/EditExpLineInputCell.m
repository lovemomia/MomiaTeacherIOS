//
//  EditExpLineInputCell.m
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/30.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "EditExpLineInputCell.h"

@implementation EditExpLineInputCell

- (void)awakeFromNib {
    // Initialization code
    [self.inputTextFiled setValue:UIColorFromRGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
