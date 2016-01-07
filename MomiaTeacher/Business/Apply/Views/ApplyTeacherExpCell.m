//
//  ApplyTeacherExpCell.m
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/7.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "ApplyTeacherExpCell.h"
#import "Education.h"
#import "Experience.h"

@implementation ApplyTeacherExpCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(id)data {
    if ([data isKindOfClass:[Experience class]]) {
        Experience *exp = (Experience *)data;
        self.schoolLabel.text = exp.school;
        self.posLabel.text = exp.post;
        self.dateLabel.text = exp.time;
        
    } else {
        Education *edu = (Education *)data;
        self.schoolLabel.text = edu.school;
        self.posLabel.text = edu.major;
        self.dateLabel.text = edu.time;
    }
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return 62;
}

@end
