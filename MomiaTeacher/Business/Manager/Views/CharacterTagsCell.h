//
//  CharacterTagsCell.h
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/4.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "MOTableCell.h"
#import "StudentRecordModel.h"

@protocol CharacterTagsCellDelegate <NSObject>

- (void)onTagSelectChanged;

@end

@interface CharacterTagsCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UIView *tagsContainer;

@property (nonatomic, assign) id<CharacterTagsCellDelegate> delegate;

@end
