//
//  CourseListItemCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/10.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface CourseListItemCell : MOTableCell<MOTableCellDataProtocol>

@property (nonatomic, assign) BOOL showStatus;
@property (weak, nonatomic) IBOutlet UIImageView *statusIv;

-(void)setData:(id) model;

@end
