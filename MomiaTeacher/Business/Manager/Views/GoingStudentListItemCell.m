//
//  ChildListItemCell.m
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/25.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "GoingStudentListItemCell.h"

@interface GoingStudentListItemCell()
@property (nonatomic, strong) Student *student;
@end

@implementation GoingStudentListItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(Student *)data {
    self.student = data;
    [self.avatarIv sd_setImageWithURL:[NSURL URLWithString:data.avatar]];
    self.nameLabel.text = data.name;
    self.ageLabel.text = data.age;
    if ([data.sex isEqualToString:@"男"]) {
        self.sexIv.image = [UIImage imageNamed:@"IconBoy"];
    } else {
        self.sexIv.image = [UIImage imageNamed:@"IconGirl"];
    }
    
    if ([data.checkin boolValue]) {
        [self.operateBtn setTitle:@"课中观察" forState:UIControlStateNormal];
        [self.operateBtn setBackgroundImage:[UIImage imageNamed:@"BgMediumButtonNormal"] forState:UIControlStateNormal];
        
    } else {
        [self.operateBtn setTitle:@"签到" forState:UIControlStateNormal];
        [self.operateBtn setBackgroundImage:[UIImage imageNamed:@"BgRedMediumButtonNormal"] forState:UIControlStateNormal];
    }
}

- (IBAction)onOperateBtnClicked:(id)sender {
    if (self.delegate) {
        [self.delegate onOperateBtnClicked:self.student];
    }
}

@end
