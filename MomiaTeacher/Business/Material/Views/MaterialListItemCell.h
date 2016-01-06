//
//  MaterialListItemCell.h
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/6.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "MOTableCell.h"

@interface MaterialListItemCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *iconIv;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@end
