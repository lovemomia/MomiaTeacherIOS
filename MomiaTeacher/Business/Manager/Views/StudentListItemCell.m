//
//  StudentListItemCell.m
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/4.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "StudentListItemCell.h"
#import "Student.h"

@implementation StudentListItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(Student *)data {
    [self.avatarIv sd_setImageWithURL:[NSURL URLWithString:data.avatar]];
    self.nameLabel.text = data.name;
    self.ageLabel.text = data.age;
    if ([data.sex isEqualToString:@"男"]) {
        self.sexIv.image = [UIImage imageNamed:@"IconBoy"];
    } else {
        self.sexIv.image = [UIImage imageNamed:@"IconGirl"];
    }
    
    if (self.showStatus) {
        self.statusIv.hidden = NO;
        if ([data.commented boolValue]) {
            self.statusIv.image = [UIImage imageNamed:@"IconCommented"];
        } else {
            self.statusIv.image = [UIImage imageNamed:@"IconUnComment"];
        }
    } else {
        self.statusIv.hidden = YES;
    }
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return 70;
}

@end
