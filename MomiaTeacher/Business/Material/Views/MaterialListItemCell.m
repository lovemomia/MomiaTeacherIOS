//
//  MaterialListItemCell.m
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/6.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "MaterialListItemCell.h"
#import "MaterialListModel.h"

@implementation MaterialListItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(Material *)data {
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:data.cover]];
    self.titleLabel.text = data.title;
    self.placeLabel.text = data.subject;
}

@end
