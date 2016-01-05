//
//  StudentDetailViewController.m
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/4.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "StudentDetailViewController.h"
#import "StudentDetailModel.h"
#import "StudentDetailCommentCell.h"
#import "StudentListItemCell.h"
#import "CommonHeaderView.h"
#import "MJRefreshHelper.h"

static NSString * identifierStudentListItemCell = @"StudentListItemCell";
static NSString * identifierStudentDetailCommentCell = @"StudentDetailCommentCell";

@interface StudentDetailViewController ()
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) Student *student;
@property (nonatomic, strong) NSMutableArray *commentList;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSNumber *totalCount;
@property (nonatomic, strong) NSNumber *nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@end

@implementation StudentDetailViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.cid = [params valueForKey:@"id"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"学生资料";
    
    [StudentListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierStudentListItemCell];
    [StudentDetailCommentCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierStudentDetailCommentCell];
    [CommonHeaderView registerCellFromNibWithTableView:self.tableView];
    
    self.commentList = [NSMutableArray new];
    self.nextIndex = 0;
    [self requestData];
}

- (void)requestData {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    if ([self.commentList count] == 0) {
        [self.view showLoadingBee];
    }
    
    int start = self.nextIndex ? [self.nextIndex intValue] : 0;
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/teacher/student")
                                              parameters:@{@"cid":self.cid, @"start":[NSString stringWithFormat:@"%d", start]} cacheType:CacheTypeDisable JSONModelClass:[StudentDetailModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if ([self.commentList count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     StudentDetailModel *model = (StudentDetailModel *)responseObject;
                                                     if (model.data.child) {
                                                         self.student = model.data.child;
                                                     }
                                                     self.totalCount = model.data.comments.totalCount;
                                                     self.nextIndex = model.data.comments.nextIndex;
                                                     
                                                     for (StudentDetailComment *comment in model.data.comments.list) {
                                                         [self.commentList addObject:comment];
                                                     }
                                                     [self.tableView reloadData];
                                                     self.isLoading = NO;
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     if ([self.commentList count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     [self showDialogWithTitle:nil message:error.message];
                                                     self.isLoading = NO;
                                                 }];
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - tableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (self.nextIndex && self.nextIndex > 0) {
        return self.commentList.count + 1;
    }
    return self.commentList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.student) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if (indexPath.section == 0) {
        StudentListItemCell *itemCell = [StudentListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierStudentListItemCell];
        itemCell.data = self.student;
        cell = itemCell;
        
    } else if (row == self.commentList.count) {
        static NSString *loadIdentifier = @"CellLoading";
        UITableViewCell *load = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
        if(load == nil) {
            load = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadIdentifier];
        }
        [load showLoadingBee];
        cell = load;
        if(!self.isLoading) {
            [self requestData];
            self.isLoading = YES;
        }
        
    } else {
        StudentDetailCommentCell *itemCell = [StudentDetailCommentCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierStudentDetailCommentCell];
        itemCell.data = self.commentList[row];
        cell = itemCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
        
    } else if (indexPath.row < self.commentList.count) {
        return [StudentDetailCommentCell heightWithTableView:tableView withIdentifier:identifierStudentDetailCommentCell forIndexPath:indexPath data:self.commentList[indexPath.row]];
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        CommonHeaderView * header = [CommonHeaderView cellWithTableView:self.tableView];
        header.data = @"所获评语";
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView]) {
        return SCREEN_HEIGHT;
    }
    return 0.1;
}

@end
