//
//  CharacterTagsCell.m
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/4.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "CharacterTagsCell.h"
#import "UILabel+ContentSize.h"

#define kLabelPadding   10
#define kLabelHeight    30

@interface CharacterTagsCell()

@property (nonatomic, strong) NSArray *tags;

@end

@implementation CharacterTagsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(StudentRecordModel *)data {
    self.tags = data.data.tags;
    
    [self.tagsContainer removeAllSubviews];
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    for (int i = 0; i < self.tags.count; i++) {
        StudentRecordTag *tag = self.tags[i];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 30, kLabelHeight)];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
        label.layer.borderWidth = 0.5;
        label.layer.cornerRadius = 4.0;
        
        if ([tag.selected boolValue]) {
            label.textColor = [UIColor whiteColor];
            label.layer.backgroundColor = [MO_APP_ThemeColor CGColor];
            
        } else {
            label.textColor = UIColorFromRGB(0x55585d);
            label.layer.backgroundColor = [UIColorFromRGB(0xF7F8FA) CGColor];
        }
        
        UIFont *font = [UIFont systemFontOfSize:12];
        label.font = font;
        label.text = tag.name;
        
        CGSize sizeThatFit = [label sizeThatFits:CGSizeZero];
        label.frame = CGRectMake(x, y, (sizeThatFit.width + 2 * kLabelPadding), kLabelHeight);
        
        x = x + label.width + kLabelPadding;
        if (x > SCREEN_WIDTH) {
            x = 0;
            y = y + kLabelHeight + kLabelPadding;
        }
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        label.tag = i;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:singleTap];
        
        [self.tagsContainer addSubview:label];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tapGesture {
    int i = tapGesture.view.tag;
    StudentRecordTag *tag = self.tags[i];
    BOOL selected = [tag.selected boolValue];
    tag.selected = [NSNumber numberWithBool:!selected];
    if (self.delegate) {
        [self.delegate onTagSelectChanged];
    }
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(StudentRecordModel *)data {
    NSArray *tags = data.data.tags;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    for (int i = 0; i < tags.count; i++) {
        StudentRecordTag *tag = tags[i];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 30, kLabelHeight)];
        
        UIFont *font = [UIFont systemFontOfSize:11];
        label.font = font;
        label.text = tag.name;
        
        CGSize sizeThatFit = [label sizeThatFits:CGSizeZero];
        label.frame = CGRectMake(x, y, (sizeThatFit.width + 2 * kLabelPadding), kLabelHeight);
        
        x = x + label.width + kLabelPadding;
        if (x > SCREEN_WIDTH) {
            x = 0;
            y = y + kLabelHeight + kLabelPadding;
        }
    }
    
    return y + kLabelHeight + 46;
}

@end
