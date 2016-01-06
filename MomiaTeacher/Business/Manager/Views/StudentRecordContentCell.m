//
//  StudentRecordContentCell.m
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/5.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "StudentRecordContentCell.h"

@implementation StudentRecordContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSString *)data {
    self.contentLabel.text = data;
}

@end
