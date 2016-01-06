//
//  EditExpContentInputCell.m
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/30.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "EditExpContentInputCell.h"

@implementation EditExpContentInputCell

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

- (void)setData:(id)data {
}

+(CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return 196;
}

@end
