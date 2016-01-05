//
//  StudentDetailCommentCell.m
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/4.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "StudentDetailCommentCell.h"
#import "StudentDetailModel.h"

@implementation StudentDetailCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(StudentDetailComment *)data {
    self.dateLabel.text = data.date;
    self.courseTitleLabel.text = data.title;
    self.commentLabel.text = data.content;
    self.teacherLabel.text = data.teacher;
}

@end
