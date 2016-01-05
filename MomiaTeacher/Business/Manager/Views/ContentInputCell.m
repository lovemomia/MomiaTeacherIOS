//
//  ContentInputCell.m
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/5.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "ContentInputCell.h"

@implementation ContentInputCell

- (void)awakeFromNib {
    // Initialization code
    
    self.contentTv.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    self.contentTv.layer.borderWidth = 0.5;
    self.contentTv.layer.cornerRadius = 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSString *)data {
    self.contentTv.text = data;
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return 196;
}

@end
